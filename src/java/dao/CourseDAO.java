/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.CourseDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import modal.CourseModal;
import utils.DBUtil;
import java.sql.*;

/**
 *
 * @author hungd
 */
public class CourseDAO extends DBUtil {

    private CourseModal mapResultSetToCourse(ResultSet rs) throws SQLException {
        CourseModal course = new CourseModal();
        course.setId(rs.getInt("id"));
        course.setName(rs.getString("name"));
        course.setTeacherId(rs.getInt("teacherId"));
        course.setSubject(CourseModal.Subject.valueOf(rs.getString("subject")));
        course.setStatus(CourseModal.Status.valueOf(rs.getString("status")));
        course.setLevel(CourseModal.Level.valueOf(rs.getString("level")));
        course.setCourseType(CourseModal.CourseType.valueOf(rs.getString("courseType")));
        course.setDescription(rs.getString("description"));
        course.setFeeCombo(rs.getBigDecimal("feeCombo"));
        course.setFeeDaily(rs.getBigDecimal("feeDaily"));
        course.setWeekAmount(rs.getInt("weekAmount"));
        course.setStudentEnrollment(rs.getInt("studentEnrollment"));
        course.setMaxStudents(rs.getInt("maxStudents"));
        course.setGrade(rs.getString("grade"));
        course.setDiscountPercentage(rs.getBigDecimal("discountPercentage"));
        course.setStartDate(rs.getObject("startDate", LocalDateTime.class));
        course.setEndDate(rs.getObject("endDate", LocalDateTime.class));
        course.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        course.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));
        course.setIsHot(rs.getBoolean("isHot"));
        course.setCourse_img(rs.getString("course_img"));

        return course;
    }

    /**
     * Lấy danh sách tất cả khóa học, sắp xếp theo id tăng dần. (For admin)
     *
     * @return
     */
    public List<CourseModal> getAllCourse() {
        List<CourseModal> courseList = new ArrayList<>();
        String sql = "SELECT * FROM course ORDER BY id";

        try (Connection connection = DBUtil.getConnection(); PreparedStatement pre = connection.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {

            while (rs.next()) {
                courseList.add(mapResultSetToCourse(rs));

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return courseList;
    }

    public List<CourseDTO> getAllCourses() {
        List<CourseDTO> courseList = new ArrayList<>();
        String sql = """
            SELECT c.id, c.name, c.subject, c.grade, c.description, c.courseType,
                   c.feeCombo, c.feeDaily, c.startDate, c.endDate, c.weekAmount,
                   c.studentEnrollment, c.maxStudents, c.level, c.isHot,
                   c.discountPercentage, c.status, a.name AS teacherName
            FROM course c
            JOIN teacher  t ON c.teacherId = t.id
            JOIN account  a ON t.accountId = a.id
            ORDER BY c.id DESC
        """;

        try (Connection con = DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CourseDTO dto = new CourseDTO();
                dto.setId(rs.getInt("id"));
                dto.setName(rs.getString("name"));
                dto.setSubject(rs.getString("subject"));
                dto.setGrade(rs.getString("grade"));
                dto.setDescription(rs.getString("description"));
                dto.setCourseType(rs.getString("courseType"));
                dto.setFeeCombo(rs.getBigDecimal("feeCombo"));
                dto.setFeeDaily(rs.getBigDecimal("feeDaily"));
                dto.setStartDate(rs.getDate("startDate"));
                dto.setEndDate(rs.getDate("endDate"));
                dto.setWeekAmount(rs.getInt("weekAmount"));
                dto.setStudentEnrollment(rs.getInt("studentEnrollment"));
                dto.setMaxStudents(rs.getInt("maxStudents"));
                dto.setLevel(rs.getString("level"));
                dto.setIsHot(rs.getBoolean("isHot"));
                dto.setDiscountPercentage(rs.getBigDecimal("discountPercentage"));
                dto.setStatus(rs.getString("status"));
                dto.setTeacherName(rs.getString("teacherName"));
                courseList.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return courseList;
    }

    /**
     * Lấy thông tin chi tiết khóa học theo id.
     *
     * @param id
     * @return
     */
    public CourseModal getCourseById(int id) {
        String sql = "SELECT * FROM course WHERE id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {

            pre.setInt(1, id);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCourse(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách khóa học theo trạng thái của nó (status).(For UI)
     *
     * @param status
     * @return
     */
    public List<CourseModal> getCourseByStatus(String status) {
        List<CourseModal> courseList = new ArrayList<>();
        String sql = "SELECT * FROM course WHERE status = ? ORDER BY created_at DESC";

        try (Connection connection = DBUtil.getConnection(); PreparedStatement pre = connection.prepareStatement(sql)) { // Không cần ResultSet trong try-with-resources ở đây

            pre.setString(1, status);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    courseList.add(mapResultSetToCourse(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return courseList;
    }

    /**
     * Lấy danh sách khóa học do một giáo viên cụ thể giảng dạy (theo
     * teacher_id).
     *
     * @param teacher_id
     * @return
     */
    public List<CourseModal> getCourseByTeacher(int teacher_id) {
        List<CourseModal> courseList = new ArrayList<>();
        String sql = "SELECT * FROM course WHERE teacherId = ? AND status = 'activated' ORDER BY created_at DESC";

        try (Connection connection = DBUtil.getConnection(); PreparedStatement pre = connection.prepareStatement(sql)) { // Không cần ResultSet trong try-with-resources ở đây

            pre.setInt(1, teacher_id);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    courseList.add(mapResultSetToCourse(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return courseList;
    }

    public List<CourseModal> getCourseByGrade(String grade) {
        List<CourseModal> courseList = new ArrayList<>();
        String sql = "SELECT * FROM course WHERE grade LIKE ? AND status = 'activated' ORDER BY created_at DESC";

        try (Connection connection = DBUtil.getConnection(); PreparedStatement pre = connection.prepareStatement(sql)) { // Không cần ResultSet trong try-with-resources ở đây

            pre.setString(1, "%" + grade + "%");
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    courseList.add(mapResultSetToCourse(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return courseList;
    }

    /**
     * Tìm kiếm khóa học theo từ khóa, tìm gần đúng trên các trường: - tên khóa
     * học (name) - môn học (subject) - lớp (grade) - trình độ (level) - loại
     * khóa học (courseType) - tên giáo viên (full_name)
     *
     *
     * @param keyword
     * @return
     */
    public List<CourseModal> searchCourses(String keyword) {
        List<CourseModal> courseList = new ArrayList<>();
        String sql = "SELECT c.* FROM course c "
                + "LEFT JOIN teacher t ON c.teacherId = t.id "
                + "LEFT JOIN account a ON t.accountId = a.id "
                + "WHERE c.name LIKE ? "
                + "OR c.subject LIKE ? "
                + "OR c.grade LIKE ? "
                + "OR c.level LIKE ? "
                + "OR c.courseType LIKE ? "
                + "OR a.name LIKE ?"
                + "AND c.status = 'activated'"
                + "ORDER BY c.created_at DESC";

        try (Connection connection = DBUtil.getConnection(); PreparedStatement pre = connection.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            for (int i = 1; i <= 6; i++) {
                pre.setString(i, searchPattern);
            }

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    courseList.add(mapResultSetToCourse(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return courseList;
    }

    /**
     * Lấy danh sách khóa học theo kết hợp các tiêu chí
     *
     * @param subject
     * @param grade
     * @return
     */
    public List<CourseModal> getFilteredCourses(String subject, Integer grade, String level, String courseType) {
        List<CourseModal> courseList = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM course WHERE 1=1 AND status = 'activated'");
        List<Object> params = new ArrayList<>();

        if (subject != null && !subject.equalsIgnoreCase("Tất cả")) {
            sql.append(" AND subject LIKE ?");
            params.add("%" + subject + "%");
        }

        if (grade != null) {
            sql.append(" AND grade LIKE ?");
            params.add("%" + grade + "%");
        }

        if (level != null && !level.equalsIgnoreCase("Tất cả")) {
            sql.append(" AND level LIKE ?");
            params.add("%" + level + "%");
        }

        if (courseType != null && !courseType.equalsIgnoreCase("Tất cả")) {
            sql.append(" AND courseType LIKE ?");
            params.add("%" + courseType + "%");
        }

        sql.append("ORDER BY created_at DESC");

        try (Connection connection = DBUtil.getConnection(); PreparedStatement pre = connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pre.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    courseList.add(mapResultSetToCourse(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return courseList;
    }

    public void updateCourse(CourseModal c) {
        String sql = """
            UPDATE course SET
                name=?, subject=?, grade=?,
                feeCombo=?, feeDaily=?,
                startDate=?, endDate=?,
                studentEnrollment=?, maxStudents=?,
                weekAmount=?, level=?,
                status=?, teacherId=?
            WHERE id=?
        """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getName());
            ps.setString(2, c.getSubject().name());
            ps.setString(3, c.getGrade());
            ps.setBigDecimal(4, c.getFeeCombo());
            ps.setBigDecimal(5, c.getFeeDaily());
            ps.setObject(6, c.getStartDate());
            ps.setObject(7, c.getEndDate());
            ps.setInt(8, c.getStudentEnrollment());
            ps.setInt(9, c.getMaxStudents());
            ps.setInt(10, c.getWeekAmount());
            ps.setString(11, c.getLevel().name());
            ps.setString(12, c.getStatus().toString());
            ps.setInt(13, c.getTeacherId());
            ps.setInt(14, c.getId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteCourseById(int id) {
        String sql = "DELETE FROM course WHERE id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /* -------------------------------------------------
     * 5. Tìm kiếm 
     * ------------------------------------------------- */
    public List<CourseDTO> searchCourses(String name, String subject, String level, String status, Integer grade) {
        List<CourseDTO> list = new ArrayList<>();

        // Sử dụng alias 'c.' trước các cột từ bảng course 
        String sql = "SELECT  c.*, "
                + "        a.name AS teacherName "
                + "FROM    course   c "
                + "JOIN    teacher  t ON c.teacherId  = t.id "
                + "JOIN    account  a ON t.accountId = a.id "
                + "WHERE   1 = 1 ";

        // điều kiện lọc: thêm 'c.' để rõ ràng truy vấn trên bảng course
        if (name != null && !name.trim().isEmpty()) {
            sql += " AND LOWER(c.name) LIKE LOWER(?)";
        }

        if (subject != null && !subject.trim().isEmpty()) {
            sql += " AND LOWER(c.subject) = LOWER(?)";
        }
        if (level != null && !level.trim().isEmpty()) {
            sql += " AND LOWER(c.level) = LOWER(?)";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND LOWER(c.status) = LOWER(?)";
        }
        if (grade != null) {
            sql += " AND c.grade = ?";
        }

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int i = 1;
            if (name != null && !name.trim().isEmpty()) {
                ps.setString(i++, "%" + name.trim() + "%");
            }
            if (subject != null && !subject.trim().isEmpty()) {
                ps.setString(i++, subject.trim());
            }
            if (level != null && !level.trim().isEmpty()) {
                ps.setString(i++, level.trim());
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(i++, status.trim());
            }
            if (grade != null) {
                ps.setInt(i++, grade);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CourseDTO course = new CourseDTO();
                course.setId(rs.getInt("id"));
                course.setName(rs.getString("name"));
                course.setSubject(rs.getString("subject"));
                course.setGrade(rs.getString("grade"));
                course.setTeacherName(rs.getString("teacherName"));
                course.setLevel(rs.getString("level"));
                course.setWeekAmount(rs.getInt("weekAmount"));
                course.setStudentEnrollment(rs.getInt("studentEnrollment"));
                course.setMaxStudents(rs.getInt("maxStudents"));
                course.setStatus(rs.getString("status"));
                course.setStartDate(rs.getDate("startDate"));
                course.setEndDate(rs.getDate("endDate"));
                course.setFeeCombo(rs.getBigDecimal("feeCombo"));
                course.setFeeDaily(rs.getBigDecimal("feeDaily"));

                list.add(course);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /* -------------------------------------------------
     *7 Check tên khoá học
     * ------------------------------------------------- */
    public boolean existsByName(String name) {
        String sql = "SELECT 1 FROM course WHERE name = ? LIMIT 1";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /* -------------------------------------------------
     *7 Thêm mới khóa học và trả về ID
     * ------------------------------------------------- */
    public int addCourseReturnId(CourseModal c) {
        String sql = """
            INSERT INTO course (
                name, subject, grade,
                description, courseType,
                feeCombo, feeDaily,
                startDate, endDate,
                weekAmount, studentEnrollment,
                maxStudents, level,
                isHot, discountPercentage,
                status, teacherId
            ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
        """;
        // Lấy kết nối và chuẩn bị statement cho phép lấy khóa tự tăng
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, c.getName());
            ps.setString(2, c.getSubject().name());
            ps.setString(3, c.getGrade());
            ps.setString(4, c.getDescription());
            ps.setString(5, c.getCourseType().toString());

            if (c.getFeeCombo() == null) {
                ps.setNull(6, Types.DECIMAL);
            } else {
                ps.setBigDecimal(6, c.getFeeCombo());
            }

            if (c.getFeeDaily() == null) {
                ps.setNull(7, Types.DECIMAL);
            } else {
                ps.setBigDecimal(7, c.getFeeDaily());
            }

            if (c.getStartDate() == null) {
                ps.setNull(8, Types.TIMESTAMP);
            } else {
                ps.setTimestamp(8, Timestamp.valueOf(c.getStartDate()));
            }

            if (c.getEndDate() == null) {
                ps.setNull(9, Types.TIMESTAMP);
            } else {
                ps.setTimestamp(9, Timestamp.valueOf(c.getEndDate()));
            }

            ps.setInt(10, c.getWeekAmount());
            ps.setInt(11, c.getStudentEnrollment());
            ps.setInt(12, c.getMaxStudents());
            ps.setString(13, c.getLevel().name());

            if (c.getIsHot() == null) {
                ps.setNull(14, Types.BOOLEAN);
            } else {
                ps.setBoolean(14, c.getIsHot());
            }

            if (c.getDiscountPercentage() == null) {
                ps.setNull(15, Types.DECIMAL);
            } else {
                ps.setBigDecimal(15, c.getDiscountPercentage());
            }

            ps.setString(16, c.getStatus().toString());
            ps.setInt(17, c.getTeacherId());

            ps.executeUpdate();
            // Lấy ID tự động sinh ra từ CSDL
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);// Trả về ID vừa tạo
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Nếu có lỗi xảy ra hoặc không lấy được ID, trả về -1 
        return -1;
    }

    public List<CourseModal> getRelatedCourses(int excludeCourseId, String subject, String grade) {
        List<CourseModal> courseList = new ArrayList<>();

        String sql = "SELECT * FROM course "
                + "WHERE id != ? AND (subject LIKE ? OR grade LIKE ?) AND status = 'activated' "
                + "ORDER BY isHot DESC, created_at DESC ";

        try (Connection connection = DBUtil.getConnection(); PreparedStatement pre = connection.prepareStatement(sql)) { // Không cần ResultSet trong try-with-resources ở đây

            pre.setInt(1, excludeCourseId);
            pre.setString(2, "%" + subject + "%");
            pre.setString(3, "%" + grade + "%");
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    courseList.add(mapResultSetToCourse(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return courseList;
    }

    public List<CourseModal> getCoursesByStudentId(int studentId) {
        List<CourseModal> courseList = new ArrayList<>();
        String sql = "SELECT DISTINCT c.* "
                + "FROM course c "
                + "JOIN section s ON c.id = s.courseId "
                + "JOIN student_section ss ON ss.sectionId = s.id "
                + "WHERE ss.studentId = ? "
                + "ORDER BY c.created_at DESC";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {

            pre.setInt(1, studentId);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    courseList.add(mapResultSetToCourse(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return courseList;
    }

}
