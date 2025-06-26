/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import utils.DBUtil;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import modal.SchoolClass;
/**
 *
 * @author ASUS
 */
public class SchoolClassDAO {
    public Map<Integer, List<SchoolClass>> getMapSchoolClass() {
    Map<Integer, List<SchoolClass>> map = new HashMap<>();
    String sql = "SELECT * FROM school_class";
    try (Connection con = DBUtil.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            SchoolClass sc = new SchoolClass();
            sc.setId(rs.getInt("id"));
            sc.setSchoolId(rs.getInt("schoolId"));
            sc.setClassName(rs.getString("class_name"));
            sc.setGrade(rs.getString("grade"));
            sc.setAcademicYear(rs.getString("academic_year"));
            sc.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            sc.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

            map.computeIfAbsent(sc.getSchoolId(), k -> new ArrayList<>()).add(sc);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return map;
}

}
