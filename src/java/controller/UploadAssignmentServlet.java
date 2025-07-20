/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AssignmentDAO;
import dao.CourseDAO;
import modal.AssignmentModal;
import java.io.File;
import java.util.List;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import modal.CourseModal;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)              // 50MB
/**
 * Servlet xử lý các chức năng liên quan đến bài tập của giáo viên trong một
 * khóa học:
 *
 * <ul>
 * <li><b>GET /uploadAssignment?courseId=...</b>: Hiển thị danh sách bài tập của
 * khóa học, cho phép tải lên/xóa.</li>
 * <li><b>GET /uploadAssignment?action=view&amp;filename=...</b>: Hiển thị trực
 * tiếp nội dung file bài tập trên trình duyệt.</li>
 * <li><b>POST /uploadAssignment</b>: Tải lên bài tập mới cho khóa học.</li>
 * <li><b>POST
 * /uploadAssignment?action=delete&amp;assignmentId=...&amp;courseId=...</b>:
 * Xóa một bài tập cụ thể.</li>
 * </ul>
 *
 * <p>
 * <b>Cấu hình upload file:</b></p>
 * <ul>
 * <li><code>fileSizeThreshold</code>: 1MB - kích thước tệp tối thiểu để lưu ra
 * file tạm.</li>
 * <li><code>maxFileSize</code>: 10MB - kích thước tối đa mỗi tệp.</li>
 * <li><code>maxRequestSize</code>: 50MB - tổng kích thước tối đa của toàn bộ
 * request.</li>
 * </ul>
 *
 * <p>
 * <p>
 * <b>Ghi chú:</b> Servlet này dành cho giáo viên sử dụng.</p>
 *
 * @author Admin
 */

public class UploadAssignmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("view".equals(action)) {
            viewFile(request, response);
            return;
        }

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        List<AssignmentModal> assignments = new AssignmentDAO().getAssignmentsByCourse(courseId);
        CourseModal course = new CourseDAO().getCourseById(courseId);

        request.setAttribute("course", course);
        request.setAttribute("assignments", assignments);
        request.setAttribute("courseId", courseId);
        request.getRequestDispatcher("views/uploadAssignment.jsp").forward(request, response);
    }

    private void viewFile(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String fileName = request.getParameter("filename");

        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tên tệp.");
            return;
        }

        String uploadPath = getServletContext().getRealPath("/uploads");
        File file = new File(uploadPath, fileName);

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tệp.");
            return;
        }

        response.setContentType(getServletContext().getMimeType(file.getName()));
        response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");

        try (FileInputStream in = new FileInputStream(file); OutputStream out = response.getOutputStream()) {
            in.transferTo(out);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            new AssignmentDAO().deleteAssignmentById(assignmentId);
            response.sendRedirect("uploadAssignmentServlet?courseId=" + courseId);
            return;
        }

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        int teacherId = new CourseDAO().getCourseById(courseId).getTeacherId();

        Part filePart = request.getPart("fileUpload");
        String fileName = "";

        if (filePart != null && filePart.getSize() > 0) {
            String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmssSSS").format(new Date());
            fileName = timestamp + "_" + originalName;

            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            File fileToSave = new File(uploadDir, fileName);
            filePart.write(fileToSave.getAbsolutePath());

            // ✅ In log để kiểm tra đường dẫn
            System.out.println("📁 Đã lưu file: " + fileToSave.getAbsolutePath());
        }

        AssignmentModal assignment = new AssignmentModal();
        assignment.setCourseId(courseId);
        assignment.setTitle(title);
        assignment.setDescription(description);
        assignment.setFilePath(fileName);
        assignment.setTeacherId(teacherId);

        new AssignmentDAO().insertAssignment(assignment);
        response.sendRedirect("uploadAssignmentServlet?courseId=" + courseId);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý upload, xem, xóa và danh sách bài tập.";
    }
}
