/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccountDAO;
import dao.SchoolDAO;
import dao.StudentDAO;
import dao.TeacherDAO;
import dto.StudentProfile;
import dto.TeacherProfile;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import modal.AccountModal;
import modal.SchoolClass;
import modal.SchoolModal;
import modal.StudentModal;
import modal.TeacherModal;

/**
 *
 * @author vankh
 */
public class UserProfileServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet userProfile</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet userProfile at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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

        String role = (String) request.getAttribute("loggedInUserRole");
        String usname = (String) request.getAttribute("loggedInUserName");
        AccountDAO acdao = new AccountDAO();
        AccountModal ac = null;
        try {
            ac = acdao.getAccountByUsername(usname);
        } catch (Exception ex) {
            java.util.logging.Logger.getLogger(ViewScoreServlet.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        String userName = ac.getPhone();
        if (userName == null || role == null) {
            response.sendRedirect("dang-nhap");
            return;
        }

        StudentDAO studentDao = new StudentDAO();
        AccountDAO accountDao = new AccountDAO();
        TeacherDAO teacherDao = new TeacherDAO();
        AccountModal currentAccount = null;

        try {
            currentAccount = accountDao.getAccountByPhone(userName);
            String avatarPath = currentAccount.getAvatarURL();
            request.setAttribute("avatarPath", avatarPath);
            request.setAttribute("currentAccount", currentAccount);
        } catch (Exception ex) {
            Logger.getLogger(UserProfileServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        if ("student".equalsIgnoreCase(role)) {
            try {
                StudentProfile student = studentDao.getStudentProfileByPhone(userName);
                request.setAttribute("user", student);
            } catch (Exception ex) {
                Logger.getLogger(UserProfileServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else if ("teacher".equalsIgnoreCase(role)) {
            try {
                TeacherProfile teacher = teacherDao.getTeacherProfileByPhone(userName);
                request.setAttribute("user", teacher);
            } catch (Exception ex) {
                Logger.getLogger(UserProfileServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        request.getRequestDispatcher("/views/userProfile.jsp").forward(request, response);

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

        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            String role = (String) request.getAttribute("loggedInUserRole");
            String usname = (String) request.getAttribute("loggedInUserName");
            AccountDAO acdao = new AccountDAO();
            String phone = request.getParameter("phone");

            AccountDAO accountDao = new AccountDAO();
            StudentDAO studentDao = new StudentDAO();
            TeacherDAO teacherDao = new TeacherDAO();
//            ParentDAO parentDao = new ParentDAO();

            try {
                AccountModal account = accountDao.getAccountByUsername(usname);
                if (account == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                // Lấy dữ liệu từ form
                String fullName = request.getParameter("fullName");
                String address = request.getParameter("address");
                String dobStr = request.getParameter("dateOfBirth");

                LocalDate dob = null;
                if (dobStr != null && !dobStr.isEmpty()) {
                    dob = LocalDate.parse(dobStr);
                }

                account.setName(fullName);
                account.setAddress(address);
                account.setPhone(phone);
                if (dob != null) {
                    account.setDob(dob.atTime(12, 0));
                }

                // Cập nhật thông tin chung
                accountDao.updateAccount(account);

                if ("student".equals(role)) {
                    String grade = request.getParameter("grade");
                    int schoolId = Integer.parseInt(request.getParameter("schoolId"));

                    StudentModal student = studentDao.getStudentByAccountId(account.getId());
                    if (student != null) {
                        student.setCurrentGrade(grade);
                        student.setSchoolId(schoolId);
                        studentDao.updateStudent(student);
                    }

                } else if ("teacher".equals(role)) {
                    String experience = request.getParameter("experience");
                    String bio = request.getParameter("bio");
                    int schoolId = Integer.parseInt(request.getParameter("schoolId"));

                    TeacherModal teacher = teacherDao.getTeacherByAccountId(account.getId());
                    if (teacher != null) {
                        teacher.setExperience(experience);
                        teacher.setBio(bio);
                        teacher.setSchoolId(schoolId);
                        teacherDao.updateTeacher(teacher);
                    }

                }
                response.sendRedirect("userProfile");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Cập nhật thất bại: " + e.getMessage());
                request.getRequestDispatcher("userProfile").forward(request, response);
            }
        } else {
            response.sendRedirect("bang-dieu-khien");
        }
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
