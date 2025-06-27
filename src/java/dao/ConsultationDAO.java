/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.ConsultationDTO;
import java.sql.*;
import modal.AccountModal;
import utils.DBUtil;
import utils.HashUtils;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
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

     public List<ConsultationDTO> listAndSearchConsultations(String name, String status) {
        List<ConsultationDTO> list = new ArrayList<>();
        String sql = "SELECT c.id, c.name, c.dob, c.phone, c.status "
                + "FROM consultation c WHERE 1=1 ";

        if (name != null && !name.trim().isEmpty()) {
            sql += " AND LOWER(TRIM(c.name)) LIKE ?";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND c.status = ? ";
        }

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;

            if (name != null && !name.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + name.trim().toLowerCase() + "%");

            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }

            ResultSet rs = ps.executeQuery();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

            while (rs.next()) {
                ConsultationDTO c = new ConsultationDTO();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));

                Timestamp dobTs = rs.getTimestamp("dob");
                if (dobTs != null) {
                    LocalDateTime dob = dobTs.toLocalDateTime();
                    c.setDob(dob);
                    c.setDobString(dob.format(formatter));
                }

                c.setPhone(rs.getString("phone"));
                c.setStatus(ConsultationDTO.Status.valueOf(rs.getString("status")));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

     
     public ConsultationDTO getConsultationById(int id) {
        String sql = "SELECT c.*, s.name AS schoolName, sc.class_name AS schoolClassName, cert.imageURL AS certificateImageUrl "
                + "FROM consultation c "
                + "LEFT JOIN school s ON c.schoolId = s.id "
                + "LEFT JOIN school_class sc ON c.schoolClassId = sc.id "
                + "LEFT JOIN consultation_certificate cert ON c.id = cert.consultationId "
                + "WHERE c.id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ConsultationDTO c = new ConsultationDTO();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));

                Timestamp dobTs = rs.getTimestamp("dob");
                if (dobTs != null) {
                    LocalDateTime dob = dobTs.toLocalDateTime();
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    c.setDob(dob);
                    c.setDobString(dob.format(formatter));
                }

                c.setPhone(rs.getString("phone"));
                c.setStatus(ConsultationDTO.Status.valueOf(rs.getString("status")));
                c.setAddress(rs.getString("address"));
                c.setSubject(rs.getString("subject"));
                c.setExperience(rs.getString("experience"));
                c.setSchoolId(rs.getInt("schoolId"));
                c.setSchoolClassId(rs.getInt("schoolClassId"));
                c.setSchoolName(rs.getString("schoolName"));
                c.setSchoolClassName(rs.getString("schoolClassName"));
                c.setCertificateImageUrl(rs.getString("certificateImageUrl"));

                return c;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStatus(int consultationId, ConsultationDTO.Status newStatus) {
        String sql = "UPDATE consultation SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus.name());
            ps.setInt(2, consultationId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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
