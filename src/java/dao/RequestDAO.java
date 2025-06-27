/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import modal.RequestModal;
import modal.RequestModal.Status;
import utils.DBUtil;

/**
 *
 * @author Astersa
 */
public class RequestDAO {
    
    public List<RequestModal> getAllRequests() throws Exception {
        List<RequestModal> requests = new ArrayList<>();
        String sql = "SELECT * FROM request ORDER BY createdAt DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                RequestModal request = mapResultSetToRequest(rs);
                requests.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    public List<RequestModal> getRequestsByUser(Integer userId) throws Exception {
        List<RequestModal> requests = new ArrayList<>();
        String sql = "SELECT * FROM request WHERE requestBy = ? ORDER BY createdAt DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                RequestModal request = mapResultSetToRequest(rs);
                requests.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    public List<RequestModal> getRequestsByType(String type) throws Exception {
        List<RequestModal> requests = new ArrayList<>();
        String sql = "SELECT * FROM request WHERE type = ? ORDER BY createdAt DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, type);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                RequestModal request = mapResultSetToRequest(rs);
                requests.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    public List<RequestModal> getRequestsByStatus(Status status) throws Exception {
        List<RequestModal> requests = new ArrayList<>();
        String sql = "SELECT * FROM request WHERE status = ? ORDER BY createdAt DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status.name());
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                RequestModal request = mapResultSetToRequest(rs);
                requests.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    public RequestModal getRequestById(Integer id) throws Exception {
        String sql = "SELECT * FROM request WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToRequest(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean createRequest(RequestModal request) throws Exception {
        String sql = "INSERT INTO request (requestBy, type, description, sectionId, courseId, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, request.getRequestBy());
            ps.setString(2, request.getType());
            ps.setString(3, request.getDescription());
            ps.setObject(4, request.getSectionId());
            ps.setObject(5, request.getCourseId());
            ps.setString(6, request.getStatus().name());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    request.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean updateRequestStatus(Integer requestId, Status status, Integer processedBy) throws Exception {
        String sql = "UPDATE request SET status = ?, processedBy = ?, updatedAt = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status.name());
            ps.setObject(2, processedBy);
            ps.setInt(3, requestId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean deleteRequest(Integer id) throws Exception {
        String sql = "DELETE FROM request WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public List<RequestModal> searchRequests(String searchTerm) throws Exception {
        List<RequestModal> requests = new ArrayList<>();
        String sql = "SELECT * FROM request WHERE description LIKE ? OR type LIKE ? ORDER BY createdAt DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                RequestModal request = mapResultSetToRequest(rs);
                requests.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    public int getRequestCountByStatus(Status status) throws Exception {
        String sql = "SELECT COUNT(*) FROM request WHERE status = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status.name());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    private RequestModal mapResultSetToRequest(ResultSet rs) throws Exception {
        RequestModal request = new RequestModal();
        
        request.setId(rs.getInt("id"));
        request.setRequestBy(rs.getInt("requestBy"));
        
        Integer processedBy = rs.getObject("processedBy", Integer.class);
        request.setProcessedBy(processedBy);
        
        request.setType(rs.getString("type"));
        request.setDescription(rs.getString("description"));
        request.setStatus(Status.valueOf(rs.getString("status")));
        
        Integer sectionId = rs.getObject("sectionId", Integer.class);
        request.setSectionId(sectionId);
        
        Integer courseId = rs.getObject("courseId", Integer.class);
        request.setCourseId(courseId);
        
        request.setCreatedAt(rs.getObject("createdAt", LocalDateTime.class));
        request.setUpdatedAt(rs.getObject("updatedAt", LocalDateTime.class));
        
        return request;
    }
} 