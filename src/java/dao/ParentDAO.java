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
import modal.ParentModal;
import utils.DBUtil;

/**
 *
 * @author Astersa
 */
public class ParentDAO extends DBUtil {

    private ParentModal mapResultSetToParent(ResultSet rs) throws SQLException {
        ParentModal parent = new ParentModal();
        parent.setId(rs.getInt("id"));
        parent.setAccountId(rs.getInt("accountId"));
        
        String relationshipStr = rs.getString("relationship");
        if (relationshipStr != null) {
            parent.setRelationship(ParentModal.Relationship.valueOf(relationshipStr));
        }
        
        parent.setJob(rs.getString("job"));
        parent.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        parent.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));

        return parent;
    }

    /**
     * Lấy thông tin phụ huynh theo AccountId.
     *
     * @param accountId
     * @return
     */
    public ParentModal getParentByAccountID(int accountId) {
        String sql = "SELECT * FROM parent WHERE accountId = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {

            pre.setInt(1, accountId);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToParent(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy thông tin phụ huynh theo ID.
     *
     * @param id
     * @return
     */
    public ParentModal getParentById(int id) {
        String sql = "SELECT * FROM parent WHERE id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {

            pre.setInt(1, id);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToParent(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

} 