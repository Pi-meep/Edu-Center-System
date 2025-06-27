/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccountDAO;
import dao.CourseDAO;
import dao.SectionDAO;
import dao.TeacherDAO;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalField;
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import modal.AccountModal;
import modal.CourseModal;
import modal.SectionModal;
import modal.TeacherCertificateModal;
import modal.TeacherModal;
import utils.CurrencyFormatter;

/**
 * Servlet xử lý hiển thị chi tiết khóa học, bao gồm thông tin khóa học, giáo
 * viên, học phí, chứng chỉ, và lịch học theo tuần.
 *
 * Xử lý hai phương thức: - doGet(): hiển thị dữ liệu ban đầu - doPost(): cập
 * nhật lịch học theo tuần được chọn
 *
 * @author hungd
 */
public class CourseDetailsServlet extends HttpServlet {

    private final CourseDAO courseDao = new CourseDAO();
    private final TeacherDAO teacherDao = new TeacherDAO();
    private final SectionDAO sectionDao = new SectionDAO();
    private final AccountDAO accountDao = new AccountDAO();

    /**
     * Xử lý yêu cầu GET để hiển thị chi tiết khóa học. Lấy courseId từ URL,
     * truy vấn cơ sở dữ liệu, format dữ liệu và forward tới trang JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String courseIdStr = request.getParameter("courseId");

        // Kiểm tra tính hợp lệ của courseId
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Mã khóa học không hợp lệ.");
            response.sendRedirect("danh-sach-lop");
            return;
        }

        int courseId;
        String priceLabel = "Học trọn gói chỉ với"; // Gán nhãn mặc định cho học phí

        try {
            courseId = Integer.parseInt(courseIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Mã khóa học không đúng định dạng.");
            response.sendRedirect("danh-sach-lop");
            return;
        }

        // Lấy thông tin khóa học
        CourseModal course = courseDao.getCourseById(courseId);
        if (course == null) {
            session.setAttribute("errorMessage", "Không tìm thấy khóa học yêu cầu.");
            response.sendRedirect("danh-sach-lop");
            return;
        }

        // === Xử lý học phí ===
        BigDecimal discount = course.getDiscountPercentage() != null ? course.getDiscountPercentage() : BigDecimal.ZERO;
        BigDecimal originalPrice;
        BigDecimal finalPrice;
        String originalPriceStr;
        String finalPriceStr;

        // Xác định loại học phí (combo hay daily)
        switch (course.getCourseType()) {
            case combo:
                originalPrice = course.getFeeCombo();
                priceLabel = "Học trọn gói chỉ với";
                break;
            case daily:
                originalPrice = course.getFeeDaily();
                priceLabel = "Mức giá theo từng buổi";
                break;
            default:
                originalPrice = BigDecimal.ZERO;
        }

        // Tính giá sau khi áp dụng giảm giá (nếu có)
        BigDecimal discountAmount = originalPrice.multiply(discount).divide(BigDecimal.valueOf(100));
        finalPrice = originalPrice.subtract(discountAmount);

        originalPriceStr = CurrencyFormatter.formatCurrency(originalPrice);
        finalPriceStr = CurrencyFormatter.formatCurrency(finalPrice);

        // Format ngày bắt đầu và kết thúc
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String startFormatted = course.getStartDate().format(formatter);
        String endFormatted = course.getEndDate().format(formatter);

        // Lấy thông tin giáo viên và chứng chỉ
        TeacherModal teacher = teacherDao.getTeacherById(course.getTeacherId());
        List<TeacherCertificateModal> certOfTeacher = teacherDao.getCertOfTeacher(teacher.getId());

        // Lấy lịch học tuần hiện tại (thứ 2 → CN)
        LocalDate[] weekRange = getCurrentWeekRange();
        LocalDate startDate = weekRange[0];
        LocalDate endDate = weekRange[1];
        List<SectionModal> schedules = sectionDao.getSectionsByCourseIdAndDateRange(courseId, startDate, endDate);

        // Tạo danh sách các tuần để chọn (tuần hiện tại ± vài tuần)
        List<String[]> weekOptions = generateWeekRanges(startDate);

        // Lấy danh sách khóa học liên quan
        List<CourseModal> relatedCourses = courseDao.getRelatedCourses(courseId, course.getSubject().name(), course.getGrade());

        // === Lưu thông tin vào session để sử dụng trong doPost ===
        session.setAttribute("course", course);
        session.setAttribute("teacher", teacher);
        session.setAttribute("teacherMap", buildTeacherAccountMapFromCourses(courseDao.getAllCourse()));
        session.setAttribute("relatedCourses", relatedCourses);
        session.setAttribute("originalPriceStr", originalPriceStr);
        session.setAttribute("finalPriceStr", finalPriceStr);
        session.setAttribute("hasDiscount", discount.compareTo(BigDecimal.ZERO) > 0);
        session.setAttribute("startFormatted", startFormatted);
        session.setAttribute("endFormatted", endFormatted);
        session.setAttribute("priceLabel", priceLabel);
        session.setAttribute("certOfTeacher", certOfTeacher);
        session.setAttribute("certYearMap", getCertYearMap(certOfTeacher));

        // Riêng dữ liệu tuần hiện tại, vì thay đổi theo chọn, chỉ để ở request
        session.setAttribute("schedules", schedules);
        session.setAttribute("weekOptions", weekOptions);
        session.setAttribute("startDate", startDate);
        session.setAttribute("endDate", endDate);

        request.getRequestDispatcher("views/course-details.jsp").forward(request, response);
    }

    /**
     * Xử lý POST khi người dùng chọn một tuần khác để xem lịch học. Chỉ cập
     * nhật phần lịch học và tuần, các phần khác giữ nguyên từ session.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        CourseModal course = (CourseModal) session.getAttribute("course");

        if (course == null) {
            response.sendRedirect("error.jsp");
            return;
        }

        int courseId = course.getId();

        // Lấy startDate từ form
        String startDateRaw = request.getParameter("startDate");
        if (startDateRaw == null) {
            response.sendRedirect("error.jsp");
            return;
        }

        LocalDate startDate = LocalDate.parse(startDateRaw);
        LocalDate endDate = startDate.plusDays(6);

        // Truy vấn lịch học theo tuần đã chọn
        List<SectionModal> schedules = sectionDao.getSectionsByCourseIdAndDateRange(courseId, startDate, endDate);
        List<String[]> weekOptions = generateWeekRanges(startDate);

        // Cập nhật lại phần thay đổi vào session/request
        session.setAttribute("startDate", startDate);
        session.setAttribute("endDate", endDate);
        session.setAttribute("schedules", schedules);
        session.setAttribute("weekOptions", weekOptions);

        request.getRequestDispatcher("views/course-details.jsp").forward(request, response);
    }

    /**
     * Tạo ánh xạ từ teacherId ➝ AccountModal để có tên đăng nhập/tên hiển thị.
     * Logic này lấy từ tất cả giáo viên và tất cả account, kết nối qua
     * accountId.
     */
    private Map<Integer, AccountModal> buildTeacherAccountMapFromCourses(List<CourseModal> courseList) {
        List<TeacherModal> teachers = teacherDao.getAllTeacher();
        List<AccountModal> accounts = accountDao.getAllAccountByRole("teacher");

        Map<Integer, TeacherModal> teacherMap = new HashMap<>();
        for (TeacherModal teacher : teachers) {
            teacherMap.put(teacher.getId(), teacher);
        }

        Map<Integer, AccountModal> accountMap = new HashMap<>();
        for (AccountModal acc : accounts) {
            accountMap.put(acc.getId(), acc);
        }

        // Kết hợp từ teacherId → teacher → accountId → Account
        Map<Integer, AccountModal> teacherAccountMap = new HashMap<>();
        for (CourseModal course : courseList) {
            TeacherModal teacher = teacherMap.get(course.getTeacherId());
            if (teacher != null) {
                AccountModal acc = accountMap.get(teacher.getAccountId());
                if (acc != null) {
                    teacherAccountMap.put(course.getTeacherId(), acc);
                }
            }
        }

        return teacherAccountMap;
    }

    /**
     * Tạo map từ id chứng chỉ ➝ năm cấp chứng chỉ. Dùng trong JSP để hiển thị
     * năm nhanh chóng.
     */
    public static Map<Integer, String> getCertYearMap(List<TeacherCertificateModal> certs) {
        Map<Integer, String> certYearMap = new HashMap<>();
        for (TeacherCertificateModal cert : certs) {
            String year = (cert.getIssuedDate() != null)
                    ? String.valueOf(cert.getIssuedDate().getYear())
                    : "N/A";
            certYearMap.put(cert.getId(), year);
        }
        return certYearMap;
    }

    /**
     * Trả về [Thứ 2, Chủ nhật] của tuần hiện tại theo múi giờ Việt Nam.
     */
    private LocalDate[] getCurrentWeekRange() {
        LocalDate today = LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh"));
        TemporalField weekField = WeekFields.ISO.dayOfWeek(); // ISO: Thứ 2 là ngày đầu tuần

        LocalDate startDate = today.with(weekField, 1); // Thứ 2
        LocalDate endDate = startDate.plusDays(6);      // Chủ nhật

        return new LocalDate[]{startDate, endDate};
    }

    /**
     * Tạo danh sách tuần (value = start date, label = dd/MM/yyyy - dd/MM/yyyy).
     * Dùng để hiển thị dropdown chọn tuần.
     */
    private List<String[]> generateWeekRanges(LocalDate currentMonday) {
        List<String[]> weeks = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        for (int i = -2; i <= 3; i++) {
            LocalDate start = currentMonday.plusWeeks(i);
            LocalDate end = start.plusDays(6);
            weeks.add(new String[]{
                start.toString(), // value gửi đi (yyyy-MM-dd)
                formatRange(start, end) // hiển thị dropdown
            });
        }

        return weeks;
    }

    /**
     * Format dải ngày từ -> đến: dd/MM/yyyy - dd/MM/yyyy
     */
    private String formatRange(LocalDate start, LocalDate end) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return start.format(formatter) + " - " + end.format(formatter);
    }
}

