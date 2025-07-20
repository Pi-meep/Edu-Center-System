/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccountDAO;
import dao.ConsultationDAO;
import dao.ParentDAO;
import dao.TeacherDAO;
import dto.ConsultationDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;
import java.util.List;
import modal.AccountModal;
import modal.ConsultationModal;
import modal.ConsultationCertificateModal;
import modal.ParentModal;
import modal.TeacherCertificateModal;
import modal.TeacherModal;

/**
 *
 * @author ASUS
 */
public class CreateAccountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idRaw = req.getParameter("consultationId");
            if (idRaw == null || idRaw.trim().isEmpty()) {
                req.setAttribute("error", "Không tìm thấy mã tư vấn.");
                req.getRequestDispatcher("/views/error.jsp").forward(req, resp);
                return;
            }

            int consultationId = Integer.parseInt(idRaw);
            ConsultationDTO consultation = new ConsultationDAO().getConsultationById(consultationId);
            if (consultation.getDob() != null) {
                String dobString = consultation.getDob().toLocalDate().toString(); // yyyy-MM-dd
                req.setAttribute("dobString", dobString);
            }
            if (consultation == null) {
                req.setAttribute("error", "Không tìm thấy thông tin tư vấn.");
                req.getRequestDispatcher("/views/error.jsp").forward(req, resp);
                return;
            }

            List<ConsultationCertificateModal> consultationCertificates
                    = new ConsultationDAO().getConsultationCertificates(consultationId);

            req.setAttribute("consultation", consultation);
            req.setAttribute("consultationCertificates", consultationCertificates);
            req.getRequestDispatcher("/views/createAccount.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            req.getRequestDispatcher("/views/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idRaw = req.getParameter("consultationId");
            if (idRaw == null || idRaw.trim().isEmpty()) {
                throw new IllegalArgumentException("Mã tư vấn không hợp lệ");
            }

            int consultationId = Integer.parseInt(idRaw);
            ConsultationDTO consultation = new ConsultationDAO().getConsultationById(consultationId);
            if (consultation == null) {
                throw new IllegalArgumentException("Không tìm thấy thông tin tư vấn.");
            }

            String roleParam = req.getParameter("role");
            if (roleParam == null) {
                throw new IllegalArgumentException("Vui lòng chọn vai trò.");
            }

            String username = req.getParameter("username");
            if (username == null || username.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng nhập username.");
            }

            if (new AccountDAO().isUsernameExist(username)) {
                throw new IllegalArgumentException("Username đã tồn tại. Vui lòng chọn username khác.");
            }

            AccountModal.Role role = AccountModal.Role.valueOf(roleParam);
            AccountModal acc = new AccountModal();
            acc.setName(consultation.getName());
            acc.setUsername(username);
            acc.setPhone(consultation.getPhone());
            acc.setDob(consultation.getDob());
            acc.setAddress(consultation.getAddress());
            acc.setAvatarURL(null);
            acc.setPassword("$2a$12$uPKwZ8rKHVxycLrRU.WAjeCg7k/ZLxitSQ1a1QluirGUdOxArDopq");
            acc.setStatus(AccountModal.Status.inactive);
            acc.setRole(role);
            acc.setCreatedAt(LocalDateTime.now());
            acc.setUpdatedAt(LocalDateTime.now());

            int accountId = new AccountDAO().insertAccount(acc);
            if (accountId == -1) {
                throw new RuntimeException("Không thể tạo tài khoản mới.");
            }

            if (role == AccountModal.Role.parent) {
                ParentModal parent = new ParentModal();
                parent.setAccountId(accountId);
                String relStr = req.getParameter("relationship");
                try {
                    ParentModal.Relationship rel = ParentModal.Relationship.valueOf(relStr.toLowerCase());
                    parent.setRelationship(rel);
                } catch (Exception e) {
                    parent.setRelationship(ParentModal.Relationship.guardian);
                }
                new ParentDAO().insertParent(parent);

            } else if (role == AccountModal.Role.teacher) {
                TeacherModal teacher = new TeacherModal();
                teacher.setAccountId(accountId);
                teacher.setExperience(consultation.getExperience());
                new TeacherDAO().insertTeacher(teacher);

                TeacherModal teacherNew = new TeacherDAO().getTeacherByAccountId(accountId);
                int teacherId = teacherNew.getId();

                String[] existingCerts = req.getParameterValues("existingCertificate");
                if (existingCerts != null) {
                    for (String certIdStr : existingCerts) {
                        if (certIdStr != null && !certIdStr.trim().isEmpty()) {
                            try {
                                int certId = Integer.parseInt(certIdStr);
                                transferCertificateToTeacher(certId, teacherId);
                            } catch (NumberFormatException e) {
                                System.err.println("Invalid certificate ID: " + certIdStr);
                            }
                        }
                    }
                }

                String[] newCertificates = req.getParameterValues("newCertificate");
                if (newCertificates != null) {
                    for (String cert : newCertificates) {
                        if (cert != null && !cert.trim().isEmpty()) {
                            TeacherCertificateModal tcm = new TeacherCertificateModal();
                            tcm.setTeacherId(teacherId);
                            tcm.setCertificateName(cert.trim());
                            tcm.setCreatedAt(LocalDateTime.now());
                            new TeacherDAO().insertCertificate(tcm);
                        }
                    }
                }
            }

            new ConsultationDAO().updateStatus(consultationId, ConsultationDTO.Status.accepted);
            resp.sendRedirect("quan-ly-tu-van?message=success&accountCreated=true");

        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi tạo tài khoản: " + e.getMessage());
            req.setAttribute("consultation", new ConsultationDAO().getConsultationById(Integer.parseInt(req.getParameter("consultationId"))));
            req.getRequestDispatcher("/views/createAccount.jsp").forward(req, resp);
        }
    }

    private void transferCertificateToTeacher(int consultationCertId, int teacherId) throws Exception {
        ConsultationDAO consultationDAO = new ConsultationDAO();
        TeacherDAO teacherDAO = new TeacherDAO();

        ConsultationCertificateModal consultationCert = consultationDAO.getConsultationCertificateById(consultationCertId);

        if (consultationCert != null) {
            TeacherCertificateModal teacherCert = new TeacherCertificateModal();
            teacherCert.setTeacherId(teacherId);
            teacherCert.setImageURL(consultationCert.getImageURL());
            teacherCert.setCertificateName("Chứng chỉ từ tư vấn");
            teacherCert.setCreatedAt(LocalDateTime.now());

            teacherDAO.insertCertificate(teacherCert);
        }
    }

    @Override
    public String getServletInfo() {
        return "Create Account Servlet - Enhanced version with certificate management";
    }
}
