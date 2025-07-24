package controller;

import dao.CourseDAO;
import dao.RoomDAO;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import dto.SectionDTO;
import dao.SectionDAO;
import dao.TeacherDAO;
import dto.CourseDTO;
import dto.TeacherDTO;
import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import modal.RoomModal;

/**
 *
 * @author Admin
 */
public class ScheduleManagementServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    SectionDAO sectionDao = new SectionDAO();
    TeacherDAO teacherDao = new TeacherDAO();
    CourseDAO courseDao = new CourseDAO();
    RoomDAO roomDao = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "view";
        }
        Date dayLabel = null;
        switch (action) {
            case "view":
                viewSchedule(request, response, dayLabel, null, null);
                break;
//            case "export":
//                exportSchedule(request, response);
//                break;
            default:
                viewSchedule(request, response, dayLabel, null, null);
        }
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
//        String action = request.getParameter("action");

        String direction = request.getParameter("direction");
        String view = request.getParameter("view");
        String dayLabel = request.getParameter("dayLabel");
        String teacherIdStr = request.getParameter("teacherSelected");
        String roomIdStr = request.getParameter("roomSelected");

        String changeType = request.getParameter("changeType");

        if (teacherIdStr != null) {
            if (teacherIdStr.equalsIgnoreCase("all")) {
                teacherIdStr = null;
            }
        }
        if (roomIdStr != null) {
            if (roomIdStr.equalsIgnoreCase("all")) {
                roomIdStr = null;
            }
        }

        if (changeType != null) {

        }

        if (direction != null && !direction.isBlank()) {
            viewScheduleByView(request, response, direction, view, dayLabel, teacherIdStr, roomIdStr);
        } else if (changeType != null) {

        } else {
            // Xử lý chuyển view mà không chuyển ngày
            Date parsedDate = (dayLabel != null && !dayLabel.isBlank())
                    ? java.sql.Date.valueOf(dayLabel)
                    : null;
            viewSchedule(request, response, parsedDate, teacherIdStr, roomIdStr);
        }
    }

    void changeSchedule(HttpServletRequest request, HttpServletResponse response, String changeType) {
        String teacherIdStr = request.getParameter("teacherId");
        String sectionId = request.getParameter("scheduleId");
        if (changeType.equalsIgnoreCase("schedule")) {

        }
    }

    void viewScheduleByView(HttpServletRequest request, HttpServletResponse response, String direction, String view, String dayLabel, String teacherId, String roomId) {
        try {
            // Định dạng theo kiểu bạn đang dùng (ví dụ: yyyy-MM-dd)
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            // Chuyển String -> LocalDate
            LocalDate currentDate = LocalDate.parse(dayLabel, formatter);

            // Xử lý direction
            if ("prev".equalsIgnoreCase(direction)) {
                if ("day".equalsIgnoreCase(view)) {
                    currentDate = currentDate.minusDays(1);
                } else if ("week".equalsIgnoreCase(view)) {
                    currentDate = currentDate.minusWeeks(1);
                } else if ("month".equalsIgnoreCase(view)) {
                    currentDate = currentDate.minusMonths(1);
                }

            } else if ("next".equalsIgnoreCase(direction)) {
                if ("day".equalsIgnoreCase(view)) {
                    currentDate = currentDate.plusDays(1);
                } else if ("week".equalsIgnoreCase(view)) {
                    currentDate = currentDate.plusWeeks(1);
                } else if ("month".equalsIgnoreCase(view)) {
                    currentDate = currentDate.plusMonths(1);
                }
            }
            // Chuyển lại thành String (nếu cần)
            String newDayLabel = currentDate.format(formatter);

            // Set lại cho request
            request.setAttribute("dayLabel", newDayLabel);
            request.setAttribute("view", view);
            request.setAttribute("currentView", view);

            System.out.println("Chuyển lịch sang: " + newDayLabel);
            viewSchedule(request, response, java.sql.Date.valueOf(newDayLabel), teacherId, roomId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi xử lý ngày");
        }
    }

    private void viewSchedule(HttpServletRequest request, HttpServletResponse response, Date dayLabel, String teacherId, String roomId)
            throws ServletException, IOException {

        // Forward to JSP
        List<TeacherDTO> teachers = teacherDao.getAllTeachers();
        List<SectionDTO> sections = sectionDao.getAllSectionsDTO();
        List<CourseDTO> courses = courseDao.getAllCourses();
        List<RoomModal> rooms = roomDao.getAllRooms();

        if (teacherId != null && !teacherId.isBlank()) {
            int idTeacher = Integer.parseInt(teacherId);
            sections = sections.stream()
                    .filter(s -> s.getTeacherId() == idTeacher)
                    .collect(Collectors.toList());
            request.setAttribute("teacherSelected", teacherId);
        }
        if (roomId != null) {
            sections = sections.stream()
                    .filter(s -> s.getClassroom().equalsIgnoreCase(roomId))
                    .collect(Collectors.toList());
            request.setAttribute("roomSelected", roomId);
        }

        // Định dạng ngày tháng
        LocalDate today = LocalDate.now();
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        Date realTime = new Date();
        if (dayLabel == null) {
            dayLabel = java.sql.Date.valueOf(today);
        }
        LocalDate localDayLabel = ((java.sql.Date) dayLabel).toLocalDate();

        String view = request.getParameter("view");
        if (view == null || view.isBlank()) {
            view = "week";
        }
        // 1. Tính toán tuần hiện tại (từ Thứ 2 đến Chủ Nhật)
        LocalDate monday = localDayLabel.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        List<String> currentWeekDates = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            currentWeekDates.add(monday.plusDays(i).format(dateFormatter));
        }

        // 2. Tính toán tháng hiện tạ
        int daysInMonth = localDayLabel.lengthOfMonth();
        LocalDate firstDayOfMonth = localDayLabel.withDayOfMonth(1);
        int firstDayOfWeek = firstDayOfMonth.getDayOfWeek().getValue(); // 1=Monday, 7=Sunday

        request.setAttribute("rooms", rooms);
        request.setAttribute("realTime", realTime);
        request.setAttribute("today", today.format(dateFormatter));
        request.setAttribute("currentWeekDates", currentWeekDates);
        request.setAttribute("sections", sections);
        request.setAttribute("teachers", teachers);
        request.setAttribute("dayLabel", dayLabel);
        request.setAttribute("courses", courses);
        request.setAttribute("currentView", view);
        request.setAttribute("daysInMonth", daysInMonth);
        request.setAttribute("firstDayOfMonth", firstDayOfWeek);
        request.setAttribute("currentMonth", localDayLabel.format(DateTimeFormatter.ofPattern("yyyy-MM")));

        // Forward đến JSP
        request.getRequestDispatcher("./views/scheduleManagement.jsp").forward(request, response);
    }

    public List<SectionDTO> filterSectionsByDay(List<SectionDTO> sections, LocalDate date) {
        return sections.stream()
                .filter(s -> s.getStartTime() != null && s.getStartTime().toLocalDate().equals(date))
                .collect(Collectors.toList());
    }

    public List<SectionDTO> filterSectionsByWeek(List<SectionDTO> sections, LocalDate anyDateInWeek) {
        LocalDate startOfWeek = anyDateInWeek.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate endOfWeek = anyDateInWeek.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));

        return sections.stream()
                .filter(s -> {
                    if (s.getStartTime() == null) {
                        return false;
                    }
                    LocalDate sectionDate = s.getStartTime().toLocalDate();
                    return (sectionDate.isEqual(startOfWeek) || sectionDate.isAfter(startOfWeek))
                            && (sectionDate.isEqual(endOfWeek) || sectionDate.isBefore(endOfWeek));
                })
                .collect(Collectors.toList());
    }

    public List<SectionDTO> filterSectionsByMonth(List<SectionDTO> sections, YearMonth month) {
        return sections.stream()
                .filter(s -> {
                    if (s.getStartTime() == null) {
                        return false;
                    }
                    YearMonth sectionMonth = YearMonth.from(s.getStartTime().toLocalDate());
                    return sectionMonth.equals(month);
                })
                .collect(Collectors.toList());
    }

}
