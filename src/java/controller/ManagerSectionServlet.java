/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SectionDAO;
import dto.SectionDTO;
import dto.StudentSectionDTO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import modal.SectionModal;
import modal.SectionModal.DayOfWeekEnum;
import modal.SectionModal.Status;

/**
 * Servlet dùng để quản lý các chức năng liên quan đến lớp học (section), bao gồm:
 * - Hiển thị danh sách lớp học (tìm kiếm, lọc)
 * - Xem chi tiết lớp học và danh sách học viên
 * - Cập nhật lớp học
 * - Xóa lớp học
 *
 * URL mapping: /quan-ly-lop-hoc
 *
 * Các action hỗ trợ qua tham số ?action=: 
 * - list 
 * - edit 
 * - detail 
 * - delete
 *
 * Phần "update" được xử lý ở method POST.
 *
 * @author HanND
 */

public class ManagerSectionServlet extends HttpServlet {
    /**
     * Xử lý các request GET: hiển thị danh sách, sửa, xóa và chi tiết lớp học.
     *
     * @param request  yêu cầu HTTP từ client
     * @param response phản hồi HTTP trả về cho client
     * @throws ServletException nếu có lỗi khi forward
     * @throws IOException nếu có lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        SectionDAO dao = new SectionDAO();

        switch (action) {
            case "edit" -> {
                // Hiển thị form chỉnh sửa section
                int id = Integer.parseInt(request.getParameter("id"));
                List<SectionDTO> sectionList = dao.getAllSectionsByCourse();

                for (SectionDTO dto : sectionList) {
                    if (dto.getId() == id) {
                        request.setAttribute("section", dto);
                        break;
                    }
                }
                request.getRequestDispatcher("views/editSection.jsp").forward(request, response);
            }
            case "delete" -> {
                 // Xóa section theo ID
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    dao.deleteSection(id);
                    response.sendRedirect("quan-ly-lop-hoc");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            case "detail" -> {
                try {
                 // Hiển thị chi tiết section và danh sách học sinh
                    int id = Integer.parseInt(request.getParameter("id"));
                    SectionDTO section = dao.getSectionDetail(id);
                    request.setAttribute("section", section);

                    List<StudentSectionDTO> studentList = dao.getStudentDetailsInSection(id);
                    request.setAttribute("studentList", studentList);

                    request.getRequestDispatcher("views/detailSection.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("quan-ly-lop-hoc");
                }
            }

            default -> {
                 // Hiển thị danh sách hoặc kết quả tìm kiếm section
                String keyword = request.getParameter("keyword"); // tên khóa học
                String dayOfWeek = request.getParameter("dayOfWeek");
                String status = request.getParameter("status");

                List<SectionDTO> sectionList;

                boolean hasFilter = (keyword != null && !keyword.trim().isEmpty())
                        || (dayOfWeek != null && !dayOfWeek.trim().isEmpty())
                        || (status != null && !status.trim().isEmpty());

                if (hasFilter) {
                    sectionList = dao.searchSections(keyword, dayOfWeek, status);
                } else {
                    sectionList = dao.getAllSectionsByCourse();
                }

                request.setAttribute("sectionList", sectionList);
                request.getRequestDispatcher("views/managerSection.jsp").forward(request, response);
            }

        }
    }
    /**
     * Xử lý request POST: cập nhật thông tin lớp học (section).
     *
     * @param request  yêu cầu HTTP từ client
     * @param response phản hồi HTTP trả về cho client
     * @throws ServletException nếu có lỗi khi xử lý
     * @throws IOException nếu có lỗi I/O
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("update".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String dayOfWeekStr = request.getParameter("dayOfWeek");
                String startTimeStr = request.getParameter("startTime");
                String endTimeStr = request.getParameter("endTime");
                String classroom = request.getParameter("classroom");
                String dateStr = request.getParameter("dateTime");
                String statusStr = request.getParameter("status");

                LocalDate date = LocalDate.parse(dateStr);
                LocalTime startTimeOnly = LocalTime.parse(startTimeStr);
                LocalTime endTimeOnly = LocalTime.parse(endTimeStr);

                LocalDateTime startTime = LocalDateTime.of(date, startTimeOnly);
                LocalDateTime endTime = LocalDateTime.of(date, endTimeOnly);
                LocalDateTime dateTime = date.atStartOfDay();

                SectionModal section = new SectionModal();
                section.setId(id);
                section.setDayOfWeek(DayOfWeekEnum.valueOf(dayOfWeekStr));
                section.setStartTime(startTime);
                section.setEndTime(endTime);
                section.setClassroom(classroom);
                section.setDateTime(dateTime);
                section.setStatus(Status.valueOf(statusStr));

                SectionDAO dao = new SectionDAO();
                dao.updateSection(section);

                response.sendRedirect("quan-ly-lop-hoc");

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

    }
/**
     * Trả về mô tả ngắn gọn về servlet.
     *
     * @return chuỗi mô tả
     */
    @Override
    public String getServletInfo() {
        return "Servlet quản lý lớp học - Section management controller";
    }
}
