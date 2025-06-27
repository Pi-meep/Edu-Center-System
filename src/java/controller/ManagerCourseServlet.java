/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CourseDAO;
import dao.SectionDAO;
import dao.TeacherDAO;
import dto.CourseDTO;
import dto.TeacherDTO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import modal.CourseModal;
import modal.CourseModal.Status;

/**
 * Servlet dùng để quản lý các chức năng liên quan đến khóa học, bao gồm: - Hiển
 * thị danh sách khóa học (tìm kiếm, lọc) - Thêm mới khóa học - Cập nhật khóa
 * học - Xóa khóa học
 *
 * URL mapping: /quan-ly-khoa-hoc
 *
 * Các action hỗ trợ qua tham số ?action=: - list - add - edit - delete
 *
 * Phần "add" và "update" được xử lý ở method POST.
 *
 * @author HanND
 */
public class ManagerCourseServlet extends HttpServlet {

    /**
     * Xử lý các request GET như hiển thị danh sách, form thêm, form cập nhật.
     *
     * @param request HTTP request chứa tham số truy vấn
     * (?action=list|edit|add|delete)
     * @param response HTTP response để điều hướng hoặc render trang
     * @throws ServletException nếu có lỗi Servlet
     * @throws IOException nếu có lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        CourseDAO courseDAO = new CourseDAO();
        TeacherDAO teacherDAO = new TeacherDAO();
        switch (action) {
            case "list" -> {
                // Lấy tham số tìm kiếm (filter) từ request
                String name = request.getParameter("name");
                String subject = request.getParameter("subject");
                String level = request.getParameter("level");
                String status = request.getParameter("status");
                String gradeStr = request.getParameter("grade");

                Integer grade = null;
                if (gradeStr != null && !gradeStr.trim().isEmpty()) {
                    grade = Integer.parseInt(gradeStr.trim());
                }
                List<CourseDTO> courseList;
                // Kiểm tra nếu có ít nhất 1 tham số lọc thì gọi searchCourses, nếu không thì getAllCourses
                if ((name != null && !name.trim().isEmpty())
                        || (subject != null && !subject.trim().isEmpty())
                        || (level != null && !level.trim().isEmpty())
                        || (status != null && !status.trim().isEmpty())
                        || grade != null) {

                    courseList = courseDAO.searchCourses(name, subject, level, status, grade);
                } else {
                    courseList = courseDAO.getAllCourses();
                }

                request.setAttribute("courseList", courseList);
                request.getRequestDispatcher("views/managerCourse.jsp").forward(request, response);
            }
            case "edit" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                CourseModal course = courseDAO.getCourseById(id);
                if (course == null) {
                    response.sendRedirect("quan-ly-khoa-hoc?action=list&error=notfound");
                    return;
                }
                List<TeacherDTO> teacherList = teacherDAO.getAllTeachers();
                request.setAttribute("course", course);
                request.setAttribute("teacherList", teacherList);
                request.setAttribute("statusString", course.getStatus().name());

                if (course.getStartDate() != null && course.getEndDate() != null) {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                    request.setAttribute("formattedStartDate", course.getStartDate().toLocalDate().format(formatter));
                    request.setAttribute("formattedEndDate", course.getEndDate().toLocalDate().format(formatter));
                }

                request.getRequestDispatcher("views/editCourse.jsp").forward(request, response);
            }
            case "add" -> {
                List<TeacherDTO> teacherList = teacherDAO.getAllTeachers();
                request.setAttribute("teacherList", teacherList);
                request.getRequestDispatcher("views/addCourse.jsp").forward(request, response);
            }
            case "delete" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                courseDAO.deleteCourseById(id);
                response.sendRedirect("quan-ly-khoa-hoc?action=list");
            }
            case "checkDuplicate" -> {
                String name = request.getParameter("name");
                boolean exists = new CourseDAO().existsByName(name);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"exists\":" + exists + "}");
                return;
            }
            default ->
                response.sendRedirect("quan-ly-khoa-hoc?action=list");
        }

    }

    /**
     * Xử lý các request POST để thêm hoặc cập nhật khóa học.
     *
     * @param request HTTP request chứa dữ liệu khóa học gửi từ form
     * @param response HTTP response để điều hướng sau xử lý
     * @throws ServletException nếu có lỗi Servlet
     * @throws IOException nếu có lỗi I/O
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        CourseDAO dao = new CourseDAO();
        SectionDAO sectionDAO = new SectionDAO();

        try {
            if ("add".equals(action)) {
                CourseModal course = new CourseModal();

                course.setName(request.getParameter("name"));
                course.setTeacherId(Integer.valueOf(request.getParameter("teacherId")));
                course.setSubject(CourseModal.Subject.valueOf(request.getParameter("subject")));
                course.setGrade(request.getParameter("grade"));
                course.setDescription(request.getParameter("description"));
                course.setCourseType(CourseModal.CourseType.valueOf(request.getParameter("courseType")));
                course.setStatus(Status.valueOf(request.getParameter("status")));
                course.setStartDate(LocalDate.parse(request.getParameter("startDate")).atStartOfDay());
                course.setEndDate(LocalDate.parse(request.getParameter("endDate")).atStartOfDay());
                course.setWeekAmount(Integer.parseInt(request.getParameter("weekAmount")));
                course.setStudentEnrollment(Integer.parseInt(request.getParameter("studentEnrollment")));
                course.setMaxStudents(Integer.parseInt(request.getParameter("maxStudents")));
                course.setLevel(CourseModal.Level.valueOf(request.getParameter("level")));
                course.setIsHot("true".equalsIgnoreCase(request.getParameter("isHot")));

                String discountStr = request.getParameter("discountPercentage");
                course.setDiscountPercentage((discountStr != null && !discountStr.isEmpty()) ? new BigDecimal(discountStr) : null);

                if (course.getCourseType() == CourseModal.CourseType.combo) {
                    String feeComboStr = request.getParameter("feeCombo");
                    course.setFeeCombo((feeComboStr != null && !feeComboStr.isEmpty()) ? new BigDecimal(feeComboStr) : null);
                    course.setFeeDaily(null);
                } else {
                    String feeDailyStr = request.getParameter("feeDaily");
                    course.setFeeDaily((feeDailyStr != null && !feeDailyStr.isEmpty()) ? new BigDecimal(feeDailyStr) : null);
                    course.setFeeCombo(null);
                }

                int courseId = dao.addCourseReturnId(course);

                // Thêm section nếu có thông tin lịch học
                String dayOfWeek = request.getParameter("dayOfWeek");
                String startTimeStr = request.getParameter("startTime");
                String endTimeStr = request.getParameter("endTime");
                String classroom = request.getParameter("classroom");
                String sectionStatus = request.getParameter("sectionStatus");

                if (dayOfWeek != null && startTimeStr != null && endTimeStr != null && classroom != null && sectionStatus != null) {
                    LocalTime startTime = LocalTime.parse(startTimeStr);
                    LocalTime endTime = LocalTime.parse(endTimeStr);

                    LocalDate startDate = course.getStartDate().toLocalDate();
                    LocalDate endDate = course.getEndDate().toLocalDate();

                    sectionDAO.addSections(courseId, dayOfWeek, startTime, endTime, classroom, startDate, endDate, sectionStatus);
                }
                response.sendRedirect("quan-ly-khoa-hoc?action=list");
                return;
            }
            if ("update".equals(action)) {
                CourseModal course = new CourseModal();
                course.setId(Integer.parseInt(request.getParameter("id")));
                course.setName(request.getParameter("name"));
                course.setTeacherId(Integer.parseInt(request.getParameter("teacherId")));
                course.setSubject(CourseModal.Subject.valueOf(request.getParameter("subject")));
                course.setGrade(request.getParameter("grade"));
                course.setFeeCombo(parseBigDecimal(request.getParameter("feeCombo")));
                course.setFeeDaily(parseBigDecimal(request.getParameter("feeDaily")));
                course.setStartDate(LocalDate.parse(request.getParameter("startDate")).atStartOfDay());
                course.setEndDate(LocalDate.parse(request.getParameter("endDate")).atStartOfDay());
                course.setStudentEnrollment(Integer.parseInt(request.getParameter("studentEnrollment")));
                course.setMaxStudents(Integer.parseInt(request.getParameter("maxStudents")));
                course.setWeekAmount(Integer.parseInt(request.getParameter("weekAmount")));
                course.setLevel(CourseModal.Level.valueOf(request.getParameter("level")));
                course.setStatus(Status.valueOf(request.getParameter("status")));

                dao.updateCourse(course);
                response.sendRedirect("quan-ly-khoa-hoc?action=list");
                return;
            }
        } catch (Exception e) {
            response.sendRedirect("quan-ly-khoa-hoc?action=list&error=failed");
        }
    }

    /**
     * Hàm hỗ trợ parse BigDecimal từ string, nếu null hoặc rỗng thì trả về
     * null.
     *
     * @param value chuỗi đầu vào
     * @return BigDecimal hoặc null nếu không hợp lệ
     */
    //Hàm này giúp tránh lỗi khi người dùng không nhập gì.
    private BigDecimal parseBigDecimal(String value) {
        return (value != null && !value.isEmpty()) ? new BigDecimal(value) : null;
    }

    /**
     * Trả về mô tả ngắn cho servlet.
     *
     * @return mô tả ngắn
     */
    @Override
    public String getServletInfo() {
        return "Quản lý khóa học – hiển thị, thêm, sửa, xóa";
    }
}
