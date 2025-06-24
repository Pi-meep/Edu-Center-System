/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modal;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 *
 * @author Astersa
 */
public class CourseModal {
    private Integer id;

    private Integer teacherId;
    private String name;
    private String description;
    private Status status;
    private CourseType courseType;
    private BigDecimal feeCombo;
    private BigDecimal feeDaily;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private Integer weekAmount;
    private Integer studentEnrollment;
    private Integer maxStudents;
    private String level;
    private Boolean isHot;
    private String subject;
    private String grade;
    private BigDecimal discountPercentage;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public enum Status {
        activated, pending, upcoming, rejected, inactivated
    }

    public enum CourseType {
        combo, daily
    }

    public CourseModal() {
    }

    public CourseModal(Integer id, Integer teacherId, String name, String description, Status status, CourseType courseType, BigDecimal feeCombo, BigDecimal feeDaily, LocalDateTime startDate, LocalDateTime endDate, Integer weekAmount, Integer studentEnrollment, Integer maxStudents, String level, Boolean isHot, String subject, String grade, BigDecimal discountPercentage, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.teacherId = teacherId;
        this.name = name;
        this.description = description;
        this.status = status;
        this.courseType = courseType;
        this.feeCombo = feeCombo;
        this.feeDaily = feeDaily;
        this.startDate = startDate;
        this.endDate = endDate;
        this.weekAmount = weekAmount;
        this.studentEnrollment = studentEnrollment;
        this.maxStudents = maxStudents;
        this.level = level;
        this.isHot = isHot;
        this.subject = subject;
        this.grade = grade;
        this.discountPercentage = discountPercentage;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(Integer teacherId) {
        this.teacherId = teacherId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public CourseType getCourseType() {
        return courseType;
    }

    public void setCourseType(CourseType courseType) {
        this.courseType = courseType;
    }

    public BigDecimal getFeeCombo() {
        return feeCombo;
    }

    public void setFeeCombo(BigDecimal feeCombo) {
        this.feeCombo = feeCombo;
    }

    public BigDecimal getFeeDaily() {
        return feeDaily;
    }

    public void setFeeDaily(BigDecimal feeDaily) {
        this.feeDaily = feeDaily;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public Integer getWeekAmount() {
        return weekAmount;
    }

    public void setWeekAmount(Integer weekAmount) {
        this.weekAmount = weekAmount;
    }

    public Integer getStudentEnrollment() {
        return studentEnrollment;
    }

    public void setStudentEnrollment(Integer studentEnrollment) {
        this.studentEnrollment = studentEnrollment;
    }

    public Integer getMaxStudents() {
        return maxStudents;
    }

    public void setMaxStudents(Integer maxStudents) {
        this.maxStudents = maxStudents;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public Boolean getIsHot() {
        return isHot;
    }

    public void setIsHot(Boolean isHot) {
        this.isHot = isHot;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public BigDecimal getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(BigDecimal discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    
}
