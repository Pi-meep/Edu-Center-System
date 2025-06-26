/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CourseDAO;
import dao.TeacherDAO;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import modal.CourseModal;
import modal.TeacherModal;

/**
 *
 * @author hungd
 */
public class CourseDetailsServlet extends HttpServlet {

    private final CourseDAO courseDao = new CourseDAO();
    private final TeacherDAO teacherDao = new TeacherDAO();

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String courseIdStr = request.getParameter("courseId");

        // Kiểm tra courseId có hợp lệ không
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Mã khóa học không hợp lệ.");
            response.sendRedirect("danh-sach-lop");
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Mã khóa học không đúng định dạng.");
            response.sendRedirect("danh-sach-lop");
            return;
        }

        CourseModal course = courseDao.getCourseById(courseId);

        if (course == null) {
            session.setAttribute("errorMessage", "Không tìm thấy khóa học yêu cầu.");
            response.sendRedirect("danh-sach-lop");
            return;
        }

        // Nếu có khóa học thì tiếp tục xử lý
//        TeacherModal teacher = teacherDao.getTeacherById(course.getTeacherId());
//        BigDecimal monthlyFee = course.get
//        int weeks = course.getDurationWeeks();
//        BigDecimal discount = course.getDiscountPercentage();
//
//        BigDecimal originalPrice = monthlyFee.multiply(new BigDecimal(weeks));
//        BigDecimal discountAmount = originalPrice.multiply(discount).divide(new BigDecimal(100));
//        BigDecimal finalPrice = originalPrice.subtract(discountAmount);
//
//        NumberFormat nf = NumberFormat.getInstance(new Locale("vi", "VN"));
//        nf.setMaximumFractionDigits(0);
//        String originalPriceStr = nf.format(originalPrice) + " VNĐ";
//        String finalPriceStr = nf.format(finalPrice) + " VNĐ";
//
        session.setAttribute("course", course);
//        request.setAttribute("originalPriceStr", originalPriceStr);
//        request.setAttribute("finalPriceStr", finalPriceStr);
//        request.setAttribute("hasDiscount", discount.compareTo(BigDecimal.ZERO) > 0);

//        session.setAttribute("teacher", teacher);
        request.getRequestDispatcher("views/course-details.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
