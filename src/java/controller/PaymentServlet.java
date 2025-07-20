package controller;

import dao.*;
import modal.*;
import modal.PaymentModal.PaymentType;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

public class PaymentServlet extends HttpServlet {
    private final CourseDAO courseDAO;
    private final SectionDAO sectionDAO;
    private final StudentDAO studentDAO;
    private final PaymentInfoDAO paymentInfoDAO;
    private final NotificationDao notificationDao;
    private final PaymentDAO paymentDAO;

    public PaymentServlet() {
        this.courseDAO = new CourseDAO();
        this.sectionDAO = new SectionDAO();
        this.studentDAO = new StudentDAO();
        this.paymentInfoDAO = new PaymentInfoDAO();
        this.notificationDao = new NotificationDao();
        this.paymentDAO = new PaymentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer accountId = (Integer) request.getAttribute("loggedInUserId");
        StudentModal student = studentDAO.getStudentByAccountId(accountId);
        String courseIdStr = request.getParameter("courseId");
        String sectionIdStr = request.getParameter("sectionId");
        Integer courseId = (courseIdStr != null && !courseIdStr.isEmpty()) ? Integer.parseInt(courseIdStr) : null;
        Integer sectionId = (sectionIdStr != null && !sectionIdStr.isEmpty()) ? Integer.parseInt(sectionIdStr) : null;
        List<CourseModal> dailyCourses = courseDAO.getDailyCoursesByStudent(student.getId());
        List<Map<String, Object>> sections = (courseId != null) ? sectionDAO.getUnpaidSectionsByCourseForStudent(courseId, student.getId()) : new ArrayList<>();
        PaymentInfoModal paymentInfo = paymentInfoDAO.getActivePaymentInfo();
        String transferContent = "";
        BigDecimal amount = null;
        boolean isCombo = false;
        if (courseId != null) {
            String courseType = courseDAO.getCourseType(courseId);
            if ("combo".equalsIgnoreCase(courseType)) {
                // Combo: lấy feeCombo, không cần chọn section
                amount = courseDAO.getFeeCombo(courseId);
                transferContent = "Đóng học-" + student.getId() + "-" + courseId;
                isCombo = true;
                sections = new ArrayList<>(); // Không cần section
                sectionId = null;
            } else {
                // Daily: chọn section, lấy amount từng section
                if (sectionId != null) {
                    for (Map<String, Object> s : sections) {
                        if (s.get("id").equals(sectionId)) {
                            amount = (BigDecimal) s.get("amount");
                            break;
                        }
                    }
                    transferContent = "Đóng học-" + student.getId() + "-" + courseId + "-" + sectionId;
                } else {
                    transferContent = "Đóng học-" + student.getId() + "-" + courseId;
                }
            }
        }
        request.setAttribute("studentId", student.getId());
        request.setAttribute("courseId", courseId);
        request.setAttribute("sectionId", sectionId);
        request.setAttribute("dailyCourses", dailyCourses);
        request.setAttribute("sections", sections);
        request.setAttribute("paymentInfo", paymentInfo);
        request.setAttribute("transferContent", transferContent);
        request.setAttribute("amount", amount);
        request.setAttribute("isCombo", isCombo);
        String msg = request.getParameter("msg");
        request.setAttribute("msg", msg);
        request.getRequestDispatcher("views/payment_student.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Integer accountId = (Integer) request.getAttribute("loggedInUserId");
        StudentModal student = studentDAO.getStudentByAccountId(accountId);
        Integer courseId = Integer.parseInt(request.getParameter("courseId"));
        String sectionIdStr = request.getParameter("sectionId");
        Integer sectionId = (sectionIdStr != null && !sectionIdStr.isEmpty()) ? Integer.parseInt(sectionIdStr) : null;
        String transferContent = request.getParameter("transferContent");
        BigDecimal amount = null;
        String courseType = courseDAO.getCourseType(courseId);
        if ("daily".equals(courseType) && sectionId != null) {
            amount = courseDAO.getFeeDaily(courseId);
        } else {
            amount = courseDAO.getFeeCombo(courseId);
        }
        PaymentType paymentType = ("daily".equals(courseType) && sectionId != null) ? PaymentType.section_fee : PaymentType.course_fee;
        PaymentModal payment = new PaymentModal(null, amount, LocalDateTime.now(), student.getId(), courseId, sectionId, paymentType, transferContent, LocalDateTime.now());
        paymentDAO.addPayment(payment);
        notificationDao.addNotification(student.getId(), "Đã thanh toán, chờ xác nhận");
        List<Integer> staffIds = notificationDao.getStaffAccountIds();
        String notifyStaff = student.getId() + " đã thanh toán " + (sectionId != null ? ("buổi " + sectionId) : ("khóa " + courseId));
        notificationDao.addNotification(staffIds, notifyStaff);
        response.sendRedirect("trang-thanh-toan?msg=success");
    }
} 