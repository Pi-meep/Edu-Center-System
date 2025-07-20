/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Astersa
 */
public class StudentPaymentScheduleDAO  {

    public static void markPaid(int studentId, int sectionId) {
        try (java.sql.Connection conn = utils.DBUtil.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(
                "UPDATE student_payment_schedule sps " +
                "JOIN student_section ss ON sps.student_section_id = ss.id " +
                "SET sps.is_paid = 1, sps.paid_date = NOW() " +
                "WHERE ss.student_id = ? AND ss.section_id = ?")) {
            ps.setInt(1, studentId);
            ps.setInt(2, sectionId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static boolean isPaid(int studentId, int sectionId) {
        boolean paid = false;
        try (java.sql.Connection conn = utils.DBUtil.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(
                "SELECT sps.is_paid FROM student_payment_schedule sps " +
                "JOIN student_section ss ON sps.student_section_id = ss.id " +
                "WHERE ss.student_id = ? AND ss.section_id = ?")) {
            ps.setInt(1, studentId);
            ps.setInt(2, sectionId);
            java.sql.ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                paid = rs.getBoolean("is_paid");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return paid;
    }

    public static List<Map<String, Object>> getPendingSchedules() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT sps.id as schedule_id, ss.studentId, ss.sectionId, sps.amount, sps.isPaid, sps.due_date, " +
                     "a.name as student_name, c.name as course_name, sec.dateTime, sec.startTime, sec.endTime, sps.courseId " +
                     "FROM student_payment_schedule sps " +
                     "LEFT JOIN student_section ss ON sps.student_section_id = ss.id " +
                     "LEFT JOIN student s ON ss.studentId = s.id " +
                     "LEFT JOIN account a ON s.accountId = a.id " +
                     "LEFT JOIN section sec ON ss.sectionId = sec.id " +
                     "LEFT JOIN course c ON (sec.courseId = c.id OR sps.courseId = c.id) " +
                     "WHERE sps.isPaid = 0";
        try (java.sql.Connection conn = utils.DBUtil.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql);
             java.sql.ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new java.util.HashMap<>();
                row.put("scheduleId", rs.getInt("schedule_id"));
                row.put("studentId", rs.getObject("studentId"));
                row.put("sectionId", rs.getObject("sectionId"));
                row.put("amount", rs.getBigDecimal("amount"));
                row.put("isPaid", rs.getBoolean("isPaid"));
                row.put("dueDate", rs.getTimestamp("due_date"));
                row.put("studentName", rs.getString("student_name"));
                row.put("courseName", rs.getString("course_name"));
                row.put("dateTime", rs.getTimestamp("dateTime"));
                row.put("startTime", rs.getTimestamp("startTime"));
                row.put("endTime", rs.getTimestamp("endTime"));
                row.put("courseId", rs.getObject("courseId"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static List<Map<String, Object>> getPendingSchedules(int limit, int offset) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT sps.id as schedule_id, ss.student_id, ss.section_id, sps.amount, sps.is_paid, sps.due_date, " +
                     "a.name as student_name, c.name as course_name, sec.date_time, sec.start_time, sec.end_time " +
                     "FROM student_payment_schedule sps " +
                     "JOIN student_section ss ON sps.student_section_id = ss.id " +
                     "JOIN student s ON ss.student_id = s.id " +
                     "JOIN account a ON s.accountId = a.id " +
                     "JOIN section sec ON ss.section_id = sec.id " +
                     "JOIN course c ON sec.course_id = c.id " +
                     "WHERE sps.is_paid = 0 " +
                     "ORDER BY sps.due_date ASC " +
                     "LIMIT ? OFFSET ?";
        try (java.sql.Connection conn = utils.DBUtil.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            java.sql.ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new java.util.HashMap<>();
                row.put("scheduleId", rs.getInt("schedule_id"));
                row.put("studentId", rs.getInt("student_id"));
                row.put("sectionId", rs.getInt("section_id"));
                row.put("amount", rs.getBigDecimal("amount"));
                row.put("isPaid", rs.getBoolean("is_paid"));
                row.put("dueDate", rs.getTimestamp("due_date"));
                row.put("studentName", rs.getString("student_name"));
                row.put("courseName", rs.getString("course_name"));
                row.put("dateTime", rs.getTimestamp("date_time"));
                row.put("startTime", rs.getTimestamp("start_time"));
                row.put("endTime", rs.getTimestamp("end_time"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static int countPendingSchedules() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM student_payment_schedule sps " +
                     "JOIN student_section ss ON sps.student_section_id = ss.id " +
                     "WHERE sps.is_paid = 0";
        try (java.sql.Connection conn = utils.DBUtil.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql);
             java.sql.ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}
