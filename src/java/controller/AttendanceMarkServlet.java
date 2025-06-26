/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.StudentSectionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author ASUS
 */
public class AttendanceMarkServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int sectionId = Integer.parseInt(request.getParameter("sectionId"));
        String[] attendedIds = request.getParameterValues("attendance");

//        StudentSectionDAO dao = new StudentSectionDAO();
//        dao.clearAttendance(sectionId); // Xoá dữ liệu điểm danh cũ
//
//        if (attendedIds != null) {
//            for (String idStr : attendedIds) {
//                int studentId = Integer.parseInt(idStr);
//                dao.markAttendance(studentId, sectionId, true); // Cập nhật điểm danh
//            }
//        }

        response.sendRedirect("sectionList?success=1"); // quay về danh sách buổi học
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
