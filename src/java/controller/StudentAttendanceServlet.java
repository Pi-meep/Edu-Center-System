package controller;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import modal.*;
import utils.JWTUtils;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class StudentAttendanceServlet extends HttpServlet {

    private CourseDAO courseDAO;
    private StudentSectionDAO studentSectionDAO;
    private SectionDAO sectionDAO;
    private StudentDAO studentDAO;

    @Override
    public void init() {
        courseDAO = new CourseDAO();
        studentSectionDAO = new StudentSectionDAO();
        sectionDAO = new SectionDAO();
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = getTokenFromCookies(request);
        if (token == null || !JWTUtils.verifyToken(token)) {
            response.sendRedirect("dang-nhap");
            return;
        }

        String identifier = JWTUtils.getIdentifier(token);

        try {
            AccountModal studentAccount = new AccountDAO().getAccountByUsername(identifier);
            if (studentAccount == null) {
                request.setAttribute("errorLog", "Không tìm thấy tài khoản học sinh.");
                request.getRequestDispatcher("/views/layout/error.jsp").forward(request, response);
                return;
            }

            StudentModal student = studentDAO.getStudentByAccountId(studentAccount.getId());
            if (student == null) {
                request.setAttribute("errorLog", "Không tìm thấy hồ sơ học sinh.");
                request.getRequestDispatcher("/views/layout/error.jsp").forward(request, response);
                return;
            }

            int studentId = student.getId();
            String studentName = studentAccount.getName();
            List<CourseModal> studentCourses = courseDAO.getCoursesByStudentId(studentId);

            request.setAttribute("studentName", studentName);
            request.setAttribute("studentCourses", studentCourses);

            String courseIdParam = request.getParameter("courseId");
            if (courseIdParam != null && !courseIdParam.trim().isEmpty()) {
                showStudentDetailsForStudent(request, response, studentId, studentName, studentCourses, courseIdParam);
            } else {
                request.getRequestDispatcher("/views/student-attendance.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/student-attendance.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
    

    private void showStudentDetailsForStudent(HttpServletRequest request, HttpServletResponse response,
            int studentId, String studentName,
            List<CourseModal> studentCourses, String courseIdParam)
            throws Exception {

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdParam.trim());
            if (courseId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID khóa học không hợp lệ.");
            request.getRequestDispatcher("/views/student-attendance.jsp").forward(request, response);
            return;
        }

        List<StudentSectionModal> attendanceDetails = studentSectionDAO.getStudentAttendanceDetails(studentId, courseId);
        List<SectionModal> sections = studentSectionDAO.getSectionsByCourseId(courseId);

        if (attendanceDetails.isEmpty()) {
            request.setAttribute("warning", "Không có dữ liệu điểm danh cho khóa học này.");
        }

        Map<Integer, SectionModal> sectionMap = sections.stream()
                .filter(s -> s.getId() != null)
                .collect(Collectors.toMap(SectionModal::getId, s -> s));

        CourseModal selectedCourse = studentCourses.stream()
                .filter(c -> c.getId().equals(courseId))
                .findFirst()
                .orElse(null);

        request.setAttribute("attendanceDetails", attendanceDetails);
        request.setAttribute("sectionMap", sectionMap);
        request.setAttribute("selectedCourseId", courseId);
        request.setAttribute("course", selectedCourse);

        request.getRequestDispatcher("/views/student-attendance.jsp").forward(request, response);
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

}
