/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import modal.AccountModal;
import utils.DBUtil;
import utils.HashUtils;
import java.time.LocalDateTime;
import modal.ConsultationModal;

/**
 *
 * @author ASUS
 */
public class ConsultationDAO {

    public int insertConsultation(ConsultationModal c) throws Exception {
        String sql = "INSERT INTO consultation (name, dob, phone, status, address, subject, experience, schoolId, schoolClassId, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getName());
            ps.setDate(2, java.sql.Date.valueOf(c.getDob().toLocalDate()));
            ps.setString(3, c.getPhone());
            ps.setString(4, c.getStatus().name());
            ps.setString(5, c.getAddress());
            ps.setString(6, c.getSubject()); // Có thể null nếu là phụ huynh
            ps.setString(7, c.getExperience()); // Có thể null nếu là phụ huynh
            ps.setInt(8, c.getSchoolId());
            if (c.getSchoolClassId() != null) {
                ps.setInt(9, c.getSchoolClassId());
            } else {
                ps.setNull(9, Types.INTEGER);
            }

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    public void insertCertificate(int consultationId, String imageURL) throws Exception {
        String sql = "INSERT INTO consultation_certificate (consultationId, imageURL, created_at) VALUES (?, ?, NOW())";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, consultationId);
            ps.setString(2, imageURL);
            ps.executeUpdate();
        }
    }

    public Integer getSchoolIdByName(String name) throws Exception {
        String sql = "SELECT id FROM school WHERE name = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
        }
        return null;
    }

    public int insertSchool(String name) throws Exception {
        String sql = "INSERT INTO school (name, created_at) VALUES (?, NOW())";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

}
