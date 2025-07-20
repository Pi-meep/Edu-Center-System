/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AssignmentDAO;
import dao.CourseDAO;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.util.List;
import modal.AssignmentModal;
import modal.CourseModal;
import utils.JWTUtils;

/**
 * Servlet cho phép học sinh xem danh sách khóa học đang tham gia và các bài tập trong từng khóa học.
 * Ngoài ra, servlet này cũng hỗ trợ chức năng tải file bài tập về máy.
 *
 * <p><b>Luồng hoạt động chính:</b></p>
 * <ul>
 *   <li><b>GET /studentAssignments</b>: Hiển thị danh sách khóa học mà học sinh hiện đang học.</li>
 *   <li><b>GET /studentAssignments?courseId={id}</b>: Hiển thị danh sách bài tập thuộc một khóa học cụ thể.</li>
 *   <li><b>GET /studentAssignments?action=download&amp;assignmentId={id}</b>: Tải xuống file bài tập theo ID.</li>
 * </ul>
 *
 * <p><b>Quy trình xác thực:</b></p>
 * <ul>
 *   <li>Lấy JWT từ cookie có tên <code>accessToken</code>.</li>
 *   <li>Kiểm tra hợp lệ của token và vai trò người dùng phải là "student".</li>
 *   <li>Nếu token không hợp lệ hoặc không phải học sinh, chuyển hướng về trang đăng nhập.</li>
 * </ul>
 *
 * <p><b>Chức năng chính:</b></p>
 * <ol>
 *   <li>Lấy danh sách khóa học học sinh đã đăng ký (theo JWT).</li>
 *   <li>Hiển thị danh sách bài tập của khóa học khi truyền courseId.</li>
 *   <li>Cho phép học sinh tải về file bài tập từ thư mục lưu trữ.</li>
 * </ol>
 *
 * @author Admin
 */
public class StudentAssignmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = null;

        // Kiểm tra xem request có cookies hay không
        if (request.getCookies() != null) {
            // Duyệt qua từng cookie
            for (Cookie cookie : request.getCookies()) {
                // Nếu tìm thấy cookie tên là "accessToken"
                if ("accessToken".equals(cookie.getName())) {
                    // Lưu giá trị của cookie đó (token JWT)
                    token = cookie.getValue();
                    break; 
                }
            }
        }

        if (token == null || !JWTUtils.verifyToken(token)) {
            response.sendRedirect("login.jsp");
            return; 
        }

        // Nếu token hợp lệ, phân tích nó để lấy thông tin người dùng
        Jws<Claims> claims = JWTUtils.parseToken(token);

        String role = claims.getBody().get("role", String.class);

        Integer accountId = claims.getBody().get("id", Integer.class);

        if (accountId == null || !"student".equalsIgnoreCase(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("download".equalsIgnoreCase(action)) {
            handleDownload(request, response);
            return;
        }

        String courseIdParam = request.getParameter("courseId");
        if (courseIdParam != null) {
            int courseId = Integer.parseInt(courseIdParam);
            AssignmentDAO assignmentDAO = new AssignmentDAO();
            List<AssignmentModal> assignments = assignmentDAO.getAssignmentsByCourse(courseId);
            request.setAttribute("assignments", assignments);
            request.setAttribute("courseId", courseId);
            request.getRequestDispatcher("/views/studentAssignments.jsp").forward(request, response);
        } else {
            // Hiển thị danh sách khóa học
            CourseDAO courseDAO = new CourseDAO();
            List<CourseModal> courses = courseDAO.getCoursesByStudentId(accountId);
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/views/studentCourses.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void handleDownload(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String assignmentIdParam = request.getParameter("assignmentId");
        if (assignmentIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu assignmentId");
            return;
        }

        int assignmentId = Integer.parseInt(assignmentIdParam);
        AssignmentDAO dao = new AssignmentDAO();
        AssignmentModal assignment = dao.getAssignmentById(assignmentId);

        if (assignment == null || assignment.getFilePath() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy bài tập hoặc file");
            return;
        }

        String uploadPath = getServletContext().getRealPath("/uploads");
        File file = new File(uploadPath, assignment.getFilePath());

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File không tồn tại");
            return;
        }
        //Trình duyệt hiểu đây là file tải về
        response.setContentType("application/octet-stream");
        //Trình duyệt hiển thị "Save As" với tên file đúng
        response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

        try (FileInputStream in = new FileInputStream(file)) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                response.getOutputStream().write(buffer, 0, bytesRead);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị danh sách khóa học và bài tập cho học sinh, hỗ trợ tải file.";
    }
}
