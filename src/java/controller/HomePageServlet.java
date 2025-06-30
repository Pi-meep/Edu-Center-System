/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BannerDAO;
import dao.CenterInfoDAO;
import dao.CourseDAO;
import dao.TeacherDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modal.BannerModal;
import modal.CenterInfoModal;
import modal.CourseModal;
import modal.TeacherModal;
import utils.DBUtil;

/**
 *
 * @author Astersa
 */
public class HomePageServlet extends HttpServlet {

    private BannerDAO bannerDAO;
    private CenterInfoDAO centerInfoDAO;
    private CourseDAO courseDAO;
    private TeacherDAO teacherDAO;

    @Override
    public void init() throws ServletException {
        bannerDAO = new BannerDAO();
        centerInfoDAO = new CenterInfoDAO();
        courseDAO = new CourseDAO();
        teacherDAO = new TeacherDAO();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private Map<String, Integer> getStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        
        try (Connection conn = DBUtil.getConnection()) {
            
            // Đếm số học sinh
            String studentQuery = "SELECT COUNT(*) as student_count FROM student";
            try (PreparedStatement ps = conn.prepareStatement(studentQuery);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("studentCount", rs.getInt("student_count"));
                }
            }
            
            // Đếm số giáo viên
            String teacherQuery = "SELECT COUNT(*) as teacher_count FROM teacher";
            try (PreparedStatement ps = conn.prepareStatement(teacherQuery);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("teacherCount", rs.getInt("teacher_count"));
                }
            }
            
            // Đếm số khóa học
            String courseQuery = "SELECT COUNT(*) as course_count FROM course WHERE status = 'activated' or status = 'completed'";
            try (PreparedStatement ps = conn.prepareStatement(courseQuery);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("courseCount", rs.getInt("course_count"));
                }
            }
            
            // Đếm số phụ huynh
            String parentQuery = "SELECT COUNT(*) as parent_count FROM parent";
            try (PreparedStatement ps = conn.prepareStatement(parentQuery);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("parentCount", rs.getInt("parent_count"));
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi, trả về giá trị mặc định
            stats.put("studentCount", 500);
            stats.put("teacherCount", 50);
            stats.put("courseCount", 20);
            stats.put("parentCount", 400);
        }
        
        return stats;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lấy dữ liệu thống kê từ database
            Map<String, Integer> stats = getStatistics();
            
            // Lấy banner active từ database
            List<BannerModal> banners = bannerDAO.getActiveBanners();
            
            // Lấy thông tin trung tâm từ database
            CenterInfoModal centerInfo = centerInfoDAO.getCenterInfo();
            
            // Lấy danh sách giáo viên nổi bật (top 6)
            List<Object[]> topTeachers = teacherDAO.getTopTeachersWithAccount(6);
            
            // Lấy danh sách khóa học hot (top 6)
            List<CourseModal> hotCourses = courseDAO.getHotCourses(6);
            
            // Đặt dữ liệu vào request attribute
            request.setAttribute("stats", stats);
            request.setAttribute("banners", banners);
            request.setAttribute("centerInfo", centerInfo);
            request.setAttribute("topTeachers", topTeachers);
            request.setAttribute("hotCourses", hotCourses);
            
            // Forward đến trang JSP
            request.getRequestDispatcher("/views/homepage.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            // Nếu có lỗi database, vẫn hiển thị trang với dữ liệu mặc định
            Map<String, Integer> stats = new HashMap<>();
            stats.put("studentCount", 500);
            stats.put("teacherCount", 50);
            stats.put("courseCount", 20);
            stats.put("parentCount", 400);
            
            request.setAttribute("stats", stats);
            request.setAttribute("banners", null);
            request.setAttribute("centerInfo", null);
            request.setAttribute("topTeachers", null);
            request.setAttribute("hotCourses", null);
            
            request.getRequestDispatcher("/views/homepage.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error");
        }
    }
}
