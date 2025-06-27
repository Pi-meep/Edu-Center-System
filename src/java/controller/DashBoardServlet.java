/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.NotificationDao;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import modal.NotificationModal;


/**
 *
 * @author Astersa
 */
public class DashBoardServlet extends HttpServlet {

    @Override
    protected void doGet(jakarta.servlet.http.HttpServletRequest request, jakarta.servlet.http.HttpServletResponse response)
            throws jakarta.servlet.ServletException, IOException {
         HttpSession session = request.getSession(false);
        if (session == null ||
            session.getAttribute("loggedInUserRole") == null ||
            session.getAttribute("accountId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String role = (String) session.getAttribute("loggedInUserRole");
        int accountId = (int) session.getAttribute("accountId");

        // Lấy notification cho người dùng
        NotificationDao notiDao = new NotificationDao();
        List<NotificationModal> notifications = notiDao.getNotificationsByAccountId(accountId);
        request.setAttribute("notifications", notifications);

        // Điều hướng theo role
        switch (role.toLowerCase()) {
            case "admin":
                request.getRequestDispatcher("/views/adminDashboard.jsp").forward(request, response);
                break;
            case "manager":
                request.getRequestDispatcher("/views/managerDashboard.jsp").forward(request, response);
                break;
            case "staff":
                request.getRequestDispatcher("/views/staffDashboard.jsp").forward(request, response);
                break;
            case "teacher":
                request.getRequestDispatcher("/views/teacherDashboard.jsp").forward(request, response);
                break;
            case "student":
                request.getRequestDispatcher("/views/studentDashboard.jsp").forward(request, response);
                break;
            case "parent":
                request.getRequestDispatcher("/views/parentDashboard.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect("login.jsp");
        }
    }
}

