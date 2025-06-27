/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

import java.sql.*;

import java.util.*;
import java.lang.*;
import modal.NotificationModal;
import utils.DBUtil;

/**
 *
 * @author Minh Thu
 */
public class NotificationDao {
     // Thêm 1 thông báo cho 1 người
     // ✅ Gửi thông báo cho 1 người
    public boolean addNotification(int accountId, String description) {
        String sql = "INSERT INTO notifications (account_id, description, is_read, created_at) VALUES (?, ?, false, NOW())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ps.setString(2, description);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Gửi thông báo cho nhiều người
    public boolean addNotificationToMultipleUsers(List<Integer> accountIds, String description) {
        String sql = "INSERT INTO notifications (account_id, description, is_read, created_at) VALUES (?, ?, false, NOW())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Integer accountId : accountIds) {
                ps.setInt(1, accountId);
                ps.setString(2, description);
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            return results.length > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Lấy toàn bộ thông báo theo accountId
    public List<NotificationModal> getNotificationsByAccountId(int accountId) {
        List<NotificationModal> list = new ArrayList<>();
        String sql = "SELECT id, account_id, description, is_read, created_at FROM notifications WHERE account_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new NotificationModal(
                        rs.getInt("id"),
                        rs.getInt("account_id"),
                        rs.getString("description"),
                        rs.getBoolean("is_read"),
                        rs.getTimestamp("created_at").toLocalDateTime()
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Lấy thông báo chưa đọc
    public List<NotificationModal> getUnreadNotificationsByAccountId(int accountId) {
        List<NotificationModal> list = new ArrayList<>();
        String sql = "SELECT id, account_id, description, is_read, created_at FROM notifications WHERE account_id = ? AND is_read = false ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new NotificationModal(
                        rs.getInt("id"),
                        rs.getInt("account_id"),
                        rs.getString("description"),
                        rs.getBoolean("is_read"),
                        rs.getTimestamp("created_at").toLocalDateTime()
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Đánh dấu 1 thông báo đã đọc
    public boolean markAsRead(int notificationId) {
        String sql = "UPDATE notifications SET is_read = true WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Đánh dấu tất cả đã đọc
    public boolean markAllAsReadByAccountId(int accountId) {
        String sql = "UPDATE notifications SET is_read = true WHERE account_id = ? AND is_read = false";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Xoá 1 thông báo
    public boolean deleteNotification(int id) {
        String sql = "DELETE FROM notifications WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Đếm thông báo chưa đọc
    public int countUnreadNotifications(int accountId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE account_id = ? AND is_read = false";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // ✅ Lấy 1 thông báo theo ID
    public NotificationModal getNotificationById(int id) {
        String sql = "SELECT id, account_id, description, is_read, created_at FROM notifications WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new NotificationModal(
                        rs.getInt("id"),
                        rs.getInt("account_id"),
                        rs.getString("description"),
                        rs.getBoolean("is_read"),
                        rs.getTimestamp("created_at").toLocalDateTime()
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
