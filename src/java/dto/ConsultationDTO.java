/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.time.LocalDateTime;

/**
 *
 * @author Admin
 */
public class ConsultationDTO {

    private Integer id;
    private String name;
    private LocalDateTime dob;
    private String phone;
    private Status status;
    private String address;
    private String subject;
    private String experience;
    private Integer schoolId;
    private Integer schoolClassId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String dobString;
    private Integer certificateId;
    private String certificateImageUrl;
    private String email;

    private String schoolName;
    private String schoolClassName;

    // Enum trạng thái
    public enum Status {
        pending, accepted, rejected
    }

    public ConsultationDTO() {
    }

    public ConsultationDTO(Integer id, String name, LocalDateTime dob, String phone, Status status, String address, String subject, String experience, Integer schoolId, Integer schoolClassId, LocalDateTime createdAt, LocalDateTime updatedAt, String schoolName, String schoolClassName, String email) {
        this.id = id;
        this.name = name;
        this.dob = dob;
        this.phone = phone;
        this.status = status;
        this.address = address;
        this.subject = subject;
        this.experience = experience;
        this.schoolId = schoolId;
        this.schoolClassId = schoolClassId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.schoolName = schoolName;
        this.schoolClassName = schoolClassName;
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Integer getId() {
        return id;
    }

    public String getDobString() {
        return dobString;
    }

    public Integer getCertificateId() {
        return certificateId;
    }

    public void setCertificateId(Integer certificateId) {
        this.certificateId = certificateId;
    }

    public String getCertificateImageUrl() {
        return certificateImageUrl;
    }

    public void setCertificateImageUrl(String certificateImageUrl) {
        this.certificateImageUrl = certificateImageUrl;
    }

    public void setDobString(String dobString) {
        this.dobString = dobString;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public LocalDateTime getDob() {
        return dob;
    }

    public void setDob(LocalDateTime dob) {
        this.dob = dob;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public Integer getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(Integer schoolId) {
        this.schoolId = schoolId;
    }

    public Integer getSchoolClassId() {
        return schoolClassId;
    }

    public void setSchoolClassId(Integer schoolClassId) {
        this.schoolClassId = schoolClassId;
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

    public String getSchoolName() {
        return schoolName;
    }

    public void setSchoolName(String schoolName) {
        this.schoolName = schoolName;
    }

    public String getSchoolClassName() {
        return schoolClassName;
    }

    public void setSchoolClassName(String schoolClassName) {
        this.schoolClassName = schoolClassName;
    }

}
