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
import modal.TeacherModal;
import utils.DBUtil;

/**
 *
 * @author hungd
 */
public class TeacherDAO extends DBUtil {

    private TeacherModal mapResultSetToTeacher(ResultSet rs) throws SQLException {
        TeacherModal teacher = new TeacherModal();
        teacher.setId(rs.getInt("id"));
        teacher.setAccountId(rs.getInt("accountId"));
        teacher.setSchoolId(rs.getInt("schoolId"));
        teacher.setSchoolClassId(rs.getInt("schoolClassId"));
        teacher.setExperience(rs.getString("experience"));
        teacher.setSubject(TeacherModal.Subject.valueOf(rs.getString("subject")));
        teacher.setBio(rs.getString("bio"));
        teacher.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        teacher.setUpdatedAt(rs.getObject("created_at", LocalDateTime.class));

        return teacher;
    }

    /**
     * Lấy danh sách tất cả giáo viên trong hệ thống.
     *
     * @return Danh sách đối tượng TeacherModal
     */
    public List<TeacherModal> getAllTeacher() {
        List<TeacherModal> teacherList = new ArrayList<>();
        String sql = "SELECT * FROM teacher ORDER BY id";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                teacherList.add(mapResultSetToTeacher(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return teacherList;
    }

    /**
     * Lấy thông tin giáo viên dựa theo `account_id`.
     *
     * @param account_id ID của tài khoản giáo viên
     * @return Đối tượng TeacherModal nếu tìm thấy, ngược lại trả về null
     */
    public TeacherModal getTeacherByAccountID(int account_id) {
        String sql = "SELECT * FROM teacher WHERE account_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, account_id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTeacher(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy thông tin giáo viên dựa theo `teacherId`.
     *
     * @param id ID của giáo viên
     * @return Đối tượng TeacherModal nếu tìm thấy, ngược lại trả về null
     */
    public TeacherModal getTeacherById(int id) {
        String sql = "SELECT * FROM teacher WHERE id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTeacher(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách giáo viên có số lượng khóa học nhiều nhất.
     *
     * @param limit Giới hạn số lượng giáo viên cần lấy
     * @return Danh sách giáo viên được sắp xếp theo số lượng khóa học giảm dần
     */
    public List<TeacherModal> getTopTeachers(int limit) {
        List<TeacherModal> topTeachers = new ArrayList<>();

        String sql = """
        SELECT t.*
        FROM teacher t
        JOIN (
            SELECT teacherId, COUNT(*) AS course_count
            FROM course
            GROUP BY teacherId
            ORDER BY course_count DESC
            LIMIT ?
        ) top ON t.id = top.teacherId
        """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    topTeachers.add(mapResultSetToTeacher(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return topTeachers;
    }

    /**
     * Lọc danh sách giáo viên theo các tiêu chí: môn học, lớp học và tên.
     *
     * @param subject Môn học cần lọc (có thể null hoặc rỗng nếu không lọc theo
     * môn)
     * @param grade Lớp học cần lọc (có thể null hoặc rỗng nếu không lọc theo
     * lớp)
     * @param name Tên giáo viên cần tìm (có thể null hoặc rỗng nếu không lọc
     * theo tên)
     * @return Danh sách giáo viên thỏa mãn điều kiện lọc
     */
    public List<TeacherModal> getFilteredTeacher(String subject, String grade, String name) throws Exception {
        List<TeacherModal> teacherList = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT DISTINCT t.* FROM teacher t "
                + "JOIN account a ON a.id = t.accountId "
                + "LEFT JOIN course c ON t.id = c.teacherId "
                + "WHERE a.status = 'active'"
        );

        List<Object> params = new ArrayList<>();

        if (subject != null && !subject.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(subject.trim())) {
            sql.append(" AND t.subject LIKE ?");
            params.add("%" + subject.trim() + "%");
        }

        if (grade != null && !grade.trim().isEmpty() && !"Tất cả".equalsIgnoreCase(grade.trim())) {
            sql.append(" AND c.grade LIKE ?");
            params.add("%" + grade.trim() + "%");
        }

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND LOWER(a.name) LIKE ?");
            params.add("%" + name.trim().toLowerCase() + "%");
        }

        sql.append(" GROUP BY t.id ");
        sql.append(" ORDER BY a.name ASC ");

        try (
                Connection connection = DBUtil.getConnection(); PreparedStatement pre = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pre.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    teacherList.add(mapResultSetToTeacher(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("SQL Error in getFilteredTeacher: " + e.getMessage());
            e.printStackTrace();
        }

        return teacherList;
    }
    
        public int countStudentsFollowByTeacherId(int teacherId) {
        String sql = "SELECT COUNT(DISTINCT e.studentId) "
                + "FROM student_course e "
                + "JOIN course c ON e.courseId = c.id "
                + "WHERE c.teacherId = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, teacherId);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    
}
