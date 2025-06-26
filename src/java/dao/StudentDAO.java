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
import modal.StudentModal;
import utils.DBUtil;

/**
 *
 * @author hungd
 */
public class StudentDAO extends DBUtil {

    private StudentModal mapResultSet(ResultSet rs) throws SQLException {
        StudentModal student = new StudentModal();
        student.setId(rs.getInt("id"));
        student.setAccountId(rs.getInt("accountId"));
        student.setSchoolId(rs.getInt("schoolId"));
        student.setSchoolClassId(rs.getInt("schoolClassId"));
        student.setParentId(rs.getInt("parentId"));
        student.setCurrentGrade(rs.getString("curentGrade"));
        student.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        student.setUpdatedAt(rs.getObject("created_at", LocalDateTime.class));

        return student;
    }

    /**
     * Lấy thông tin học sinh theo AccountId.
     *
     * @param accountId
     * @return
     */
    public StudentModal getStudentByAccountId(int accountId) {
        String sql = "SELECT * FROM student WHERE accountId = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {

            pre.setInt(1, accountId);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
