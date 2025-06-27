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
        if (request.getAttribute("loggedInUserRole") == null) {
            response.sendRedirect("dang-nhap.jsp");
            return;
        }

        String role = (String) request.getAttribute("loggedInUserRole");
        int accountId = (int) request.getAttribute("loggedInUserId");

        // Lấy notification cho người dùng
        NotificationDao notiDao = new NotificationDao();
        List<NotificationModal> notifications = notiDao.getNotificationsByAccountId(accountId);
        request.setAttribute("notifications", notifications);

        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}
