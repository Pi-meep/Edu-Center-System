/*
 * Fixed version of AttendanceReport servlet with better error handling and resource management
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.StudentSectionDAO;
import modal.CourseModal;
import modal.SectionModal;
import modal.StudentSectionModal;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class AttendanceReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        try {
            StudentSectionDAO dao = new StudentSectionDAO();

            switch (action) {
                case "list":
                    showCourseList(request, response, dao);
                    break;
                case "course-report":
                    showCourseReport(request, response, dao);
                    break;
                case "section-report":
                    showSectionReport(request, response, dao);
                    break;
                case "student-details":
                    showStudentDetails(request, response, dao);
                    break;
                default:
                    showCourseList(request, response, dao);
            }
        } catch (Exception e) {
            handleError(request, response, e);
        }
    }

    private void showCourseList(HttpServletRequest request, HttpServletResponse response,
            StudentSectionDAO dao) throws Exception {
        List<CourseModal> courses = dao.getAllActiveCourses();
        request.setAttribute("courses", courses);
        request.getRequestDispatcher("/views/attendance-course-list.jsp").forward(request, response);
    }

    private void showCourseReport(HttpServletRequest request, HttpServletResponse response,
            StudentSectionDAO dao) throws Exception {

        // Improved parameter validation
        String courseIdParam = request.getParameter("courseId");
        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Course ID is required");
            showCourseList(request, response, dao);
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdParam.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid Course ID format");
            showCourseList(request, response, dao);
            return;
        }

        List<CourseModal> courses = dao.getAllActiveCourses();
        CourseModal selectedCourse = courses.stream()
                .filter(c -> c.getId().equals(courseId))
                .findFirst()
                .orElse(null);

        if (selectedCourse == null) {
            request.setAttribute("error", "Khóa học không tồn tại");
            showCourseList(request, response, dao);
            return;
        }

        List<Map<String, Object>> attendanceReport = dao.getAttendanceReportByCourse(courseId);
        Map<String, Object> statistics = dao.getAttendanceStatistics(courseId);
        List<SectionModal> sections = dao.getSectionsByCourseId(courseId);

        request.setAttribute("course", selectedCourse);
        request.setAttribute("attendanceReport", attendanceReport);
        request.setAttribute("statistics", statistics);
        request.setAttribute("sections", sections);
        request.setAttribute("courseId", courseId);

        request.getRequestDispatcher("/views/attendance-course-report.jsp").forward(request, response);
    }

    private void showSectionReport(HttpServletRequest request, HttpServletResponse response,
            StudentSectionDAO dao) throws Exception {

        // Improved parameter validation
        String sectionIdParam = request.getParameter("sectionId");
        String courseIdParam = request.getParameter("courseId");

        if (sectionIdParam == null || sectionIdParam.trim().isEmpty()
                || courseIdParam == null || courseIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Section ID and Course ID are required");
            showCourseList(request, response, dao);
            return;
        }

        int sectionId, courseId;
        try {
            sectionId = Integer.parseInt(sectionIdParam.trim());
            courseId = Integer.parseInt(courseIdParam.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ID format");
            showCourseList(request, response, dao);
            return;
        }

        List<Map<String, Object>> sectionReport = dao.getAttendanceReportBySection(sectionId);
        List<SectionModal> sections = dao.getSectionsByCourseId(courseId);

        SectionModal selectedSection = sections.stream()
                .filter(s -> s.getId().equals(sectionId))
                .findFirst()
                .orElse(null);

        if (selectedSection == null) {
            request.setAttribute("error", "Section không tồn tại");
            // Redirect back to course report instead of course list
            request.setAttribute("courseId", courseId);
            showCourseReport(request, response, dao);
            return;
        }

        request.setAttribute("section", selectedSection);
        request.setAttribute("sectionReport", sectionReport);
        request.setAttribute("courseId", courseId);
        request.setAttribute("sectionId", sectionId);

        request.getRequestDispatcher("/views/attendance-section-report.jsp").forward(request, response);
    }

    private void showStudentDetails(HttpServletRequest request, HttpServletResponse response,
            StudentSectionDAO dao) throws Exception {

        String studentIdParam = request.getParameter("studentId");
        String courseIdParam = request.getParameter("courseId");

        if (studentIdParam == null || studentIdParam.trim().isEmpty()
                || courseIdParam == null || courseIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Student ID and Course ID are required");
            showCourseList(request, response, dao);
            return;
        }

        int studentId, courseId;
        try {
            studentId = Integer.parseInt(studentIdParam.trim());
            courseId = Integer.parseInt(courseIdParam.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ID format");
            showCourseList(request, response, dao);
            return;
        }

        List<StudentSectionModal> attendanceDetails = dao.getStudentAttendanceDetails(studentId, courseId);
        List<SectionModal> sections = dao.getSectionsByCourseId(courseId);

        Map<Integer, SectionModal> sectionMap = sections.stream()
                .collect(Collectors.toMap(SectionModal::getId, s -> s));

        request.setAttribute("attendanceDetails", attendanceDetails);
        request.setAttribute("sectionMap", sectionMap);
        request.setAttribute("studentId", studentId);
        request.setAttribute("courseId", courseId);

        request.getRequestDispatcher("/views/attendance-student-details.jsp").forward(request, response);
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, Exception e)
            throws ServletException, IOException {

        // Log the error (trong production nên dùng proper logging framework)
        e.printStackTrace();

        // Create detailed error message for debugging
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        String fullStackTrace = sw.toString();

        // Set error attributes
        request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        request.setAttribute("errorLog", fullStackTrace);

        // Forward to error page
        request.getRequestDispatcher("/views/layout/error.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Attendance Report Servlet - Manages attendance reporting functionality";
    }
}
