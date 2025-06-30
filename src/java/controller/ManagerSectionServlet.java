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
 * Servlet dùng để quản lý các chức năng liên quan đến lớp học (section), bao
 * gồm: - Hiển thị danh sách lớp học (tìm kiếm, lọc) - Xem chi tiết lớp học và
 * danh sách học viên - Cập nhật lớp học - Xóa lớp học
 *
 * URL mapping: /quan-ly-lop-hoc
 *
 * Các action hỗ trợ qua tham số ?action=: - list - edit - detail - delete
 *
 * Phần "update" được xử lý ở method POST.
 *
 * @author HanND
 */
public class ManagerSectionServlet extends HttpServlet {

    /**
     * Xử lý các request GET: hiển thị danh sách, sửa, xóa và chi tiết lớp học.
     *
     * @param request yêu cầu HTTP từ client
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

        try {
            switch (action) {
                case "edit" -> {
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
                    int id = Integer.parseInt(request.getParameter("id"));
                    dao.deleteSection(id);
                    response.sendRedirect("quan-ly-lop-hoc");
                }

                case "detail" -> {
                    int id = Integer.parseInt(request.getParameter("id"));

                    SectionDTO section = dao.getSectionDetail(id);
                    request.setAttribute("section", section);

                    List<StudentSectionDTO> studentList = dao.getStudentDetailsInSection(id);
                    request.setAttribute("studentList", studentList);

                    request.getRequestDispatcher("views/detailSection.jsp").forward(request, response);
                }

                default -> {
                    String keyword = request.getParameter("keyword");
                    String dayOfWeek = request.getParameter("dayOfWeek");
                    String status = request.getParameter("status");

                    List<SectionDTO> sectionList = (keyword != null && !keyword.isBlank())
                            || (dayOfWeek != null && !dayOfWeek.isBlank())
                            || (status != null && !status.isBlank())
                            ? dao.searchSections(keyword, dayOfWeek, status)
                            : dao.getAllSectionsByCourse();

                    request.setAttribute("sectionList", sectionList);
                    request.getRequestDispatcher("views/managerSection.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("quan-ly-lop-hoc");
        }
    }

    /**
     * Xử lý request POST: cập nhật thông tin lớp học (section).
     *
     * @param request yêu cầu HTTP từ client
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
                int courseId = Integer.parseInt(request.getParameter("courseId"));
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
                LocalDateTime dateTime = startTime;

                SectionDTO dto = new SectionDTO();
                dto.setId(id);
                dto.setCourseId(courseId);
                dto.setDayOfWeek(DayOfWeekEnum.valueOf(dayOfWeekStr));
                dto.setStartTime(startTime);
                dto.setEndTime(endTime);
                dto.setDateTime(dateTime);
                dto.setClassroom(classroom);
                dto.setStatus(Status.valueOf(statusStr));

                dto.setStartTimeFormatted(startTimeOnly.toString());  // "HH:mm"
                dto.setEndTimeFormatted(endTimeOnly.toString());      // "HH:mm"
                dto.setDateFormatted(date.toString());                // "yyyy-MM-dd"

                SectionDAO dao = new SectionDAO();
                if (dao.isConflictSection(id, classroom, date, startTimeOnly, endTimeOnly)) {
                    String courseName = dao.getCourseNameById(courseId);
                    dto.setCourseName(courseName);

                    request.setAttribute("section", dto);
                    request.setAttribute("error", "Đã có lớp học khác trong cùng phòng, cùng ngày và trùng thời gian.");
                    request.getRequestDispatcher("views/editSection.jsp").forward(request, response);
                    return;
                }

                dao.updateSection(dto);
                response.sendRedirect("quan-ly-lop-hoc");

            } catch (Exception e) {
                e.printStackTrace();

                // Gán lại DTO nếu có lỗi để hiển thị lại form
                SectionDTO dto = new SectionDTO();
                dto.setId(Integer.parseInt(request.getParameter("id")));
                dto.setCourseId(Integer.parseInt(request.getParameter("courseId")));
                dto.setClassroom(request.getParameter("classroom"));
                dto.setStartTimeFormatted(request.getParameter("startTime"));
                dto.setEndTimeFormatted(request.getParameter("endTime"));
                dto.setDateFormatted(request.getParameter("dateTime"));
                dto.setDayOfWeek(DayOfWeekEnum.valueOf(request.getParameter("dayOfWeek")));
                dto.setStatus(Status.valueOf(request.getParameter("status")));

                try {
                    SectionDAO dao = new SectionDAO();
                    String courseName = dao.getCourseNameById(dto.getCourseId());
                    dto.setCourseName(courseName);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

                request.setAttribute("section", dto);
                request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật lớp học.");
                request.getRequestDispatcher("views/editSection.jsp").forward(request, response);
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
