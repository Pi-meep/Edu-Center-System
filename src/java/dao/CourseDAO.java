/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import modal.CourseModal;
import utils.DBUtil;

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
    
}
