/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.SectionDTO;
import dto.StudentSectionDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import modal.SectionModal;
import utils.DBUtil;

/**
 *
 * @author hungd
 */
public class SectionDAO extends DBUtil {

    /**
     * Chuyển đổi một dòng dữ liệu từ ResultSet thành đối tượng SectionModal.
     */
    private SectionModal mapResultSet(ResultSet rs) throws SQLException {
        SectionModal section = new SectionModal();
        section.setId(rs.getInt("id"));
        section.setCourseId(rs.getInt("courseId"));
        section.setClassroom(rs.getString("classroom"));
        section.setDayOfWeek(SectionModal.DayOfWeekEnum.valueOf(rs.getString("dayOfWeek")));
        section.setStartTime(rs.getObject("startTime", LocalDateTime.class));
        section.setEndTime(rs.getObject("endTime", LocalDateTime.class));
        section.setDateTime(rs.getObject("dateTime", LocalDateTime.class));
        section.setStatus(SectionModal.Status.valueOf(rs.getString("status")));
        section.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        section.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));
        section.setTeacherId(rs.getInt("teacherId"));
        section.setNote(rs.getString("note"));
 
        

        return section;
    }

    /**
     * Lấy danh sách tất cả lớp học, sắp xếp theo id tăng dần.
     *
     * @return
     */
    public List<SectionModal> getAllSections() {
        List<SectionModal> sectionList = new ArrayList<>();
        String sql = "SELECT * FROM section ORDER BY id";

        try (Connection connection = DBUtil.getConnection(); PreparedStatement pre = connection.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {

            while (rs.next()) {
                sectionList.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sectionList;
    }



    public List<SectionDTO> getAllSectionsByCourse() {
        List<SectionDTO> sectionList = new ArrayList<>();

        String sql = """
           SELECT s.id,
                   c.name AS courseName,
                   s.courseId,
                   s.dayOfWeek,
                   s.startTime,
                   s.endTime,
                   s.classroom,
                   s.dateTime,
                   s.status
            FROM section s
            JOIN course c ON s.courseId = c.id
            ORDER BY s.dateTime ASC;
        """;

        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SectionModal section = new SectionModal();
                section.setId(rs.getInt("id"));
                section.setCourseId(rs.getInt("courseId"));
                section.setDayOfWeek(SectionModal.DayOfWeekEnum.valueOf(rs.getString("dayOfWeek")));

                // Các trường thời gian
                LocalDateTime startTime = rs.getTimestamp("startTime").toLocalDateTime();
                LocalDateTime endTime = rs.getTimestamp("endTime").toLocalDateTime();
                LocalDateTime dateTime = rs.getTimestamp("dateTime").toLocalDateTime();

                section.setStartTime(startTime);
                section.setEndTime(endTime);
                section.setDateTime(dateTime);

                section.setClassroom(rs.getString("classroom"));
                section.setStatus(SectionModal.Status.valueOf(rs.getString("status")));

                SectionDTO dto = new SectionDTO();
                dto.setId(section.getId());
                dto.setCourseId(section.getCourseId());
                dto.setDayOfWeek(section.getDayOfWeek());
                dto.setClassroom(section.getClassroom());
                dto.setStatus(section.getStatus());
                dto.setCourseName(rs.getString("courseName"));
                dto.setSection(section);

                dto.setStartTimeFormatted(startTime.format(timeFormatter));
                dto.setEndTimeFormatted(endTime.format(timeFormatter));
                dto.setDateFormatted(dateTime.toLocalDate().format(dateFormatter));


                sectionList.add(dto);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return sectionList;
    }

    /**
     * Lấy danh sách lớp học của khóa học đó
     *
     * @param courseId
     * @return
     */
    public List<SectionModal> getSectionsByCourseIdAndDateRange(int courseId, LocalDate startDate, LocalDate endDate) {
        List<SectionModal> sectionList = new ArrayList<>();
        String sql = "SELECT * FROM section WHERE courseId = ? AND dateTime BETWEEN ? AND ? ORDER BY dateTime";

        try (Connection connection = DBUtil.getConnection(); PreparedStatement stmt = connection.prepareStatement(sql)) {
            Timestamp startTimestamp = Timestamp.valueOf(startDate.atStartOfDay());         // 00:00:00
            Timestamp endTimestamp = Timestamp.valueOf(endDate.atTime(LocalTime.MAX));      // 23:59:59

            stmt.setInt(1, courseId);
            stmt.setTimestamp(2, startTimestamp);
            stmt.setTimestamp(3, endTimestamp);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sectionList.add(mapResultSet(rs)); // Hàm ánh xạ từ ResultSet sang SectionModal bạn đã có
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return sectionList;
    }

    public List<Map<String, Object>> getTeacherSections(Integer teacherId) throws Exception {
        List<Map<String, Object>> sections = new ArrayList<>();

        String sql = """
            SELECT 
                sec.id,
                sec.courseId,
                c.name as courseName,
                sec.dateTime,
                sec.classroom,
                sec.dayOfWeek,
                sec.startTime,
                sec.endTime
            FROM section sec
            JOIN course c ON sec.courseId = c.id
            WHERE c.teacherId = ? 
            AND sec.dateTime > NOW()
            AND c.status = 'activated'
            ORDER BY sec.dateTime ASC
        """;

        try (Connection con = DBUtil.getConnection(); PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, teacherId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> section = new HashMap<>();
                    section.put("id", rs.getInt("id"));
                    section.put("courseId", rs.getInt("courseId"));
                    section.put("courseName", rs.getString("courseName"));

                    // Format dateTime
                    Timestamp dateTime = rs.getTimestamp("dateTime");
                    if (dateTime != null) {
                        LocalDateTime localDateTime = dateTime.toLocalDateTime();
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                        section.put("dateTime", localDateTime.format(formatter));
                    }

                    section.put("classroom", rs.getString("classroom"));
                    section.put("dayOfWeek", rs.getString("dayOfWeek"));
                    section.put("startTime", rs.getTime("startTime"));
                    section.put("endTime", rs.getTime("endTime"));
                    sections.add(section);
                }
            }
        }
        return sections;
    }

    public void updateSection(SectionModal section) {
        String updateSQL = """
        UPDATE section 
        SET courseId = ?, 
            dayOfWeek = ?, 
            startTime = ?, 
            endTime = ?, 
            classroom = ?, 
            dateTime = ?, 
            status = ?
        WHERE id = ?
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(updateSQL)) {

            stmt.setInt(1, section.getCourseId());
            stmt.setString(2, section.getDayOfWeek().toString());
            stmt.setTimestamp(3, Timestamp.valueOf(section.getStartTime()));
            stmt.setTimestamp(4, Timestamp.valueOf(section.getEndTime()));
            stmt.setString(5, section.getClassroom());
            stmt.setTimestamp(6, Timestamp.valueOf(section.getDateTime()));
            stmt.setString(7, section.getStatus().toString());
            stmt.setInt(8, section.getId());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                System.out.println("Cập nhật lớp học thành công.");
            } else {
                System.out.println("Không tìm thấy lớp học để cập nhật (ID không đúng?).");
            }

        }
        catch (Exception e) {
            System.out.println("Lỗi khi cập nhật section:");
            e.printStackTrace();
        }


    }

    /**
     * Xóa lớp học dựa trên ID.
     *
     * @param id ID lớp học cần xóa
     */
    public void deleteSection(int id) {
        String sql = "DELETE FROM section WHERE id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy chi tiết lớp học bao gồm tên khóa học và tên giáo viên.
     *
     * @param sectionId ID của lớp học
     * @return SectionDTO nếu tìm thấy, null nếu không
     */
    public SectionDTO getSectionDetail(int sectionId) {
        String sql = """
        SELECT s.id, s.dayOfWeek, s.startTime, s.endTime, s.classroom,
               s.dateTime, s.status, c.id AS courseId, c.name AS courseName, 
               a.name AS teacherName
        FROM section s
        JOIN course c ON s.courseId = c.id
        JOIN teacher t ON c.teacherId = t.id
        JOIN account a ON t.accountId = a.id
        WHERE s.id = ?
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sectionId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");


                SectionModal section = new SectionModal();
                section.setId(rs.getInt("id"));
                section.setDayOfWeek(SectionModal.DayOfWeekEnum.valueOf(rs.getString("dayOfWeek")));
                LocalDateTime startTime = rs.getTimestamp("startTime").toLocalDateTime();
                LocalDateTime endTime = rs.getTimestamp("endTime").toLocalDateTime();
                LocalDateTime dateTime = rs.getTimestamp("dateTime").toLocalDateTime();
                section.setStartTime(startTime);
                section.setEndTime(endTime);
                section.setDateTime(dateTime);
                section.setClassroom(rs.getString("classroom"));
                section.setStatus(SectionModal.Status.valueOf(rs.getString("status")));

                SectionDTO dto = new SectionDTO();
                dto.setId(section.getId());
                dto.setCourseId(rs.getInt("courseId"));
                dto.setDayOfWeek(section.getDayOfWeek());
                dto.setClassroom(section.getClassroom());
                dto.setStatus(section.getStatus());
                dto.setCourseName(rs.getString("courseName"));
                dto.setTeacherName(rs.getString("teacherName"));
                dto.setSection(section);

                dto.setStartTimeFormatted(startTime.format(timeFormatter));
                dto.setEndTimeFormatted(endTime.format(timeFormatter));
                dto.setDateFormatted(dateTime.toLocalDate().format(dateFormatter));

                return dto;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách học sinh trong một lớp học cụ thể.
     *
     * @param sectionId ID lớp học
     * @return danh sách StudentSectionDTO
     */
    public List<StudentSectionDTO> getStudentDetailsInSection(int sectionId) {
        List<StudentSectionDTO> list = new ArrayList<>();

        String sql = """
        SELECT st.id AS studentId, a.name AS studentName, 
               ss.isPaid, ss.attendanceStatus
        FROM student_section ss
        JOIN student st ON ss.studentId = st.id
        JOIN account a ON st.accountId = a.id
        WHERE ss.sectionId = ?
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sectionId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                StudentSectionDTO dto = new StudentSectionDTO();
                dto.setStudentId(rs.getInt("studentId"));
                dto.setStudentName(rs.getString("studentName"));
                dto.setIsPaid(rs.getBoolean("isPaid"));
                dto.setAttendanceStatus(rs.getBoolean("attendanceStatus"));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Tạo các buổi học (section) lặp lại hàng tuần dựa trên ngày bắt đầu và kết
     * thúc của khóa học. Mỗi buổi học sẽ được thêm mới vào bảng `section` nếu
     * trùng với ngày trong tuần đã chọn.
     *
     * @param courseId ID của khóa học
     * @param dayOfWeek Thứ trong tuần cần tạo lớp
     * @param startTime Giờ bắt đầu lớp học
     * @param endTime Giờ kết thúc lớp học
     * @param classroom Phòng học
     * @param startDate Ngày bắt đầu khóa học
     * @param endDate Ngày kết thúc khóa học
     * @param status Trạng thái của lớp học
     */
    public void addSections(int courseId, String dayOfWeek, LocalTime startTime, LocalTime endTime,
            String classroom, LocalDate startDate, LocalDate endDate, String status) {
        String sql = "INSERT INTO section (courseId, dayOfWeek, startTime, endTime, classroom, dateTime, status) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            // Lấy enum DayOfWeek tương ứng với tham số truyền vào (VD: "MONDAY")
            java.time.DayOfWeek targetDay = java.time.DayOfWeek.valueOf(dayOfWeek.toUpperCase());

            // Bắt đầu từ startDate
            LocalDate date = startDate;

            // Tìm ngày đầu tiên trong tuần khớp với dayOfWeek (VD: thứ 2 gần nhất sau startDate)
            while (date.getDayOfWeek() != targetDay) {
                date = date.plusDays(1); // tăng dần đến đúng thứ cần tìm
            }

            // Duyệt theo từng tuần cho đến endDate
            while (!date.isAfter(endDate)) {
                // Gộp ngày và giờ bắt đầu/kết thúc thành LocalDateTime
                LocalDateTime startDateTime = date.atTime(startTime);
                LocalDateTime endDateTime = date.atTime(endTime);

                // Gán các giá trị vào PreparedStatement
                ps.setInt(1, courseId);
                ps.setString(2, dayOfWeek);
                ps.setTimestamp(3, Timestamp.valueOf(startDateTime)); // startTime
                ps.setTimestamp(4, Timestamp.valueOf(endDateTime));   // endTime
                ps.setString(5, classroom);
                ps.setTimestamp(6, Timestamp.valueOf(startDateTime)); // dateTime = thời điểm bắt đầu học
                ps.setString(7, status);

                // Thêm vào batch để thực hiện nhiều insert 1 lúc(batch là để thu thập dữ liệu )
                ps.addBatch();

                // Tăng ngày thêm 1 tuần để tạo buổi học tiếp theo
                date = date.plusWeeks(1);
            }

            // Thực thi toàn bộ batch insert
            ps.executeBatch();
            System.out.println("Tạo section theo tuần thành công cho courseId = " + courseId);

        } catch (Exception e) {
            System.out.println("Lỗi khi tạo danh sách section:");
            e.printStackTrace();
        }
    }

    /**
     * Tìm kiếm section theo từ khóa tên khóa học, thứ trong tuần và trạng thái.
     *
     * @param keyword từ khóa tìm kiếm theo tên khóa học
     * @param dayOfWeek lọc theo thứ trong tuần
     * @param status lọc theo trạng thái lớp học
     * @return danh sách SectionDTO phù hợp
     */
    public List<SectionDTO> searchSections(String keyword, String dayOfWeek, String status) {
        List<SectionDTO> list = new ArrayList<>();

        String sql = """
        SELECT s.id, c.name AS courseName, s.courseId, s.dayOfWeek,
               s.startTime, s.endTime, s.classroom, s.dateTime, s.status
        FROM section s
        JOIN course c ON s.courseId = c.id
        WHERE 1 = 1
    """;

        // Thêm điều kiện lọc
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND LOWER(c.name) LIKE LOWER(?)";
        }
        if (dayOfWeek != null && !dayOfWeek.trim().isEmpty()) {
            sql += " AND s.dayOfWeek = ?";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND s.status = ?";
        }

        sql += " ORDER BY s.dateTime ASC";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword.trim() + "%");
            }
            if (dayOfWeek != null && !dayOfWeek.trim().isEmpty()) {
                ps.setString(index++, dayOfWeek);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }

            ResultSet rs = ps.executeQuery();
            DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");
            DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");

            while (rs.next()) {
                SectionModal section = new SectionModal();
                section.setId(rs.getInt("id"));
                section.setCourseId(rs.getInt("courseId"));
                section.setDayOfWeek(SectionModal.DayOfWeekEnum.valueOf(rs.getString("dayOfWeek")));
                LocalDateTime startTime = rs.getTimestamp("startTime").toLocalDateTime();
                LocalDateTime endTime = rs.getTimestamp("endTime").toLocalDateTime();
                LocalDateTime dateTime = rs.getTimestamp("dateTime").toLocalDateTime();
                section.setStartTime(startTime);
                section.setEndTime(endTime);
                section.setDateTime(dateTime);

                section.setClassroom(rs.getString("classroom"));
                section.setStatus(SectionModal.Status.valueOf(rs.getString("status")));

                SectionDTO dto = new SectionDTO();
                dto.setId(section.getId());
                dto.setCourseId(section.getCourseId());
                dto.setDayOfWeek(section.getDayOfWeek());
                dto.setClassroom(section.getClassroom());
                dto.setStatus(section.getStatus());
                dto.setCourseName(rs.getString("courseName"));
                dto.setSection(section);

                dto.setStartTimeFormatted(startTime.format(timeFmt));
                dto.setEndTimeFormatted(endTime.format(timeFmt));
                dto.setDateFormatted(dateTime.toLocalDate().format(dateFmt));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean isConflictSection(int id, String classroom, LocalDate date, LocalTime startTime, LocalTime endTime) {
        String sql = """
        SELECT COUNT(*) FROM section
        WHERE classroom = ?
          AND id != ?
          AND DATE(startTime) = ?
          AND (
                (TIME(startTime) < ? AND TIME(endTime) > ?) 
             )
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, classroom);
            ps.setInt(2, id);
            ps.setDate(3, java.sql.Date.valueOf(date));
            ps.setTime(4, Time.valueOf(endTime));
            ps.setTime(5, Time.valueOf(startTime));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getCourseNameById(int courseId) {
        String sql = "SELECT name FROM course WHERE id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }


    public SectionModal getSectionById(int id) throws Exception {
        String sql = "SELECT * FROM section WHERE id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs); // 🔁 Dùng hàm đã viết
                }
            }
        }
        return null;
    }

    public boolean updateNote(int sectionId, String note) throws Exception {
        String sql = "UPDATE section SET note = ? WHERE id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, note);
            stmt.setInt(2, sectionId);
            return stmt.executeUpdate() > 0;
        }
    }

    public Integer getTeacherIdBySectionId(int sectionId) throws Exception {
        String sql = "SELECT teacherId FROM section WHERE id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, sectionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("teacherId");
                }
            }
        }
        return null; 
    }


}
