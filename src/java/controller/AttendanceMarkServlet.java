package controller;

import dao.AccountDAO;
import dao.CourseDAO;
import dao.SectionDAO;
import dao.StudentSectionDAO;
import dao.TeacherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modal.AccountModal;
import modal.CourseModal;
import modal.SectionModal;
import modal.TeacherModal;
import utils.JWTUtils;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author ASUS
 */
public class AttendanceMarkServlet extends HttpServlet {

    private AccountDAO accountDAO;
    private CourseDAO courseDAO;
    private SectionDAO sectionDAO;
    private StudentSectionDAO studentSectionDAO;
    private TeacherDAO teacherDAO;

    @Override
    public void init() throws ServletException {
        accountDAO = new AccountDAO();
        courseDAO = new CourseDAO();
        sectionDAO = new SectionDAO();
        studentSectionDAO = new StudentSectionDAO();
        teacherDAO = new TeacherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = getTokenFromCookies(request);
        if (token == null || !JWTUtils.verifyToken(token)) {
            request.setAttribute("errorLog", "Token không hợp lệ hoặc đã hết hạn.");
            request.getRequestDispatcher("/views/layout/error.jsp").forward(request, response);
            return;
        }

        String role = JWTUtils.getRole(token);
        if (!"teacher".equals(role)) {
            request.setAttribute("errorLog", "Chỉ giáo viên được phép truy cập trang này.");
            request.getRequestDispatcher("/views/layout/error.jsp").forward(request, response);
            return;
        }

        try {
            String identifier = JWTUtils.getIdentifier(token);
            AccountModal teacherAccount = accountDAO.getAccountByUsername(identifier);
            if (teacherAccount == null) {
                request.setAttribute("errorLog", "Không tìm thấy tài khoản giáo viên.");
                request.getRequestDispatcher("/views/layout/error.jsp").forward(request, response);
                return;
            }

            TeacherModal teacher = teacherDAO.getTeacherByAccountID(teacherAccount.getId());
            List<CourseModal> courses = studentSectionDAO.getCoursesWithDetailsByTeacherId(teacher.getId());
            if (courses.isEmpty()) {
                request.setAttribute("error", "Không có khóa học nào để điểm danh.");
            }

            String courseIdParam = request.getParameter("courseId");
            if (courseIdParam != null && !courseIdParam.isEmpty()) {
                try {
                    int courseId = Integer.parseInt(courseIdParam);
                    List<SectionModal> sections = studentSectionDAO.getSectionsByCourseId(courseId);
                    request.setAttribute("sections", sections);
                    request.setAttribute("courseId", courseId);

                    String sectionIdParam = request.getParameter("sectionId");
                    if (sectionIdParam != null && !sectionIdParam.isEmpty()) {
                        int sectionId = Integer.parseInt(sectionIdParam);
                        List<Map<String, Object>> students = studentSectionDAO.getStudentsInSection(sectionId);
                        Map<Integer, Boolean> attendanceMap = new HashMap<>();
                        for (Map<String, Object> student : students) {
                            int studentId = (int) student.get("studentId");
                            boolean isPresent = studentSectionDAO.getAttendanceStatus(studentId, sectionId);
                            attendanceMap.put(studentId, isPresent);
                        }
                        request.setAttribute("students", students);
                        request.setAttribute("sectionId", sectionId);
                        request.setAttribute("attendanceMap", attendanceMap);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "ID khóa học hoặc buổi học không hợp lệ.");
                } catch (Exception e) {
                    request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
                }
            }

            request.setAttribute("courses", courses);
        } catch (Exception e) {
            request.setAttribute("errorLog", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/layout/error.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/views/take-attendance-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = getTokenFromCookies(request);
        if (token == null || !JWTUtils.verifyToken(token)) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Token không hợp lệ hoặc đã hết hạn.");
            return;
        }

        String role = JWTUtils.getRole(token);
        if (!"teacher".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ giáo viên được phép thực hiện hành động này.");
            return;
        }

        String courseIdParam = request.getParameter("courseId");
        String sectionIdParam = request.getParameter("sectionId");
        String[] studentIds = request.getParameterValues("studentIds");

        if (courseIdParam == null || sectionIdParam == null || studentIds == null) {
            request.setAttribute("error", "Thiếu thông tin khóa học, buổi học hoặc học sinh.");
            request.getRequestDispatcher("/views/take-attendance-form.jsp").forward(request, response);
            return;
        }

        try {
            int sectionId = Integer.parseInt(sectionIdParam);
            Map<String, String[]> paramMap = request.getParameterMap();
            boolean success = true;

            for (String studentIdStr : studentIds) {
                try {
                    int studentId = Integer.parseInt(studentIdStr);
                    String[] values = paramMap.get("attendance_" + studentId);
                    if (values == null || values.length == 0) {
                        continue;
                    }
                    boolean isPresent = "present".equals(values[0]);
                    if (!studentSectionDAO.upsertAttendance(studentId, sectionId, isPresent)) {
                        success = false;
                    }
                } catch (NumberFormatException e) {
                    success = false;
                }
            }

            if (success) {
                request.setAttribute("success", "Điểm danh đã được lưu thành công.");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi lưu điểm danh cho một số học sinh.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID buổi học không hợp lệ.");
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống khi lưu điểm danh: " + e.getMessage());
        }

        doGet(request, response);
    }

    private String getTokenFromCookies(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("accessToken".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    @Override
    public String getServletInfo() {
        return "Attendance Mark Servlet for managing student attendance.";
    }
}
