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
import modal.SectionModal;
import utils.DBUtil;

/**
 *
 * @author hungd
 */
public class SectionDAO extends DBUtil {

    /**
     * Chuyển đổi một dòng dữ liệu từ ResultSet thành đối tượng SectionModal.
     */
    private SectionModal mapResultSet(ResultSet rs) throws SQLException {
        SectionModal section = new SectionModal();
        section.setId(rs.getInt("id"));
        section.setCourseId(rs.getInt("courseId"));
        section.setClassroom(rs.getString("classroom"));
        section.setDayOfWeek(SectionModal.DayOfWeekEnum.valueOf(rs.getString("dayOfWeek")));
        section.setStartTime(rs.getObject("startTime", LocalDateTime.class));
        section.setEndTime(rs.getObject("endTime", LocalDateTime.class));
        section.setDateTime(rs.getObject("dateTime", LocalDateTime.class));
        section.setStatus(SectionModal.Status.valueOf(rs.getString("status")));
        section.setCreatedAt(rs.getObject("created_at", LocalDateTime.class));
        section.setUpdatedAt(rs.getObject("updated_at", LocalDateTime.class));

        return section;
    }

    /**
     * Lấy danh sách tất cả lớp học, sắp xếp theo id tăng dần.
     *
     * @return
     */
    public List<SectionModal> getAllSections() {
        List<SectionModal> sectionList = new ArrayList<>();
        String sql = "SELECT * FROM section ORDER BY id";

        try (Connection connection = DBUtil.getConnection(); PreparedStatement pre = connection.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {

            while (rs.next()) {
                sectionList.add(mapResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sectionList;
    }

    /**
     * Lấy danh sách lớp học của khóa học đó
     *
     * @param courseId
     * @return
     */
    public List<SectionModal> getClassByGrade(int courseId) {
        List<SectionModal> sectionList = new ArrayList<>();
        String sql = "SELECT * FROM section WHERE courseId = ? ORDER BY id";

        try (Connection connection = DBUtil.getConnection(); PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, courseId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    sectionList.add(mapResultSet(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return sectionList;
    }
    
    
}
