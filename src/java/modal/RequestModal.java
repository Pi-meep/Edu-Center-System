/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modal;

import java.time.LocalDateTime;

/**
 *
 * @author Astersa
 */
public class RequestModal {
    private Integer id;
    private Integer requestBy;
    private Integer processedBy;
    private String type;
    private String description;
    private Status status;
    private Integer sectionId;
    private Integer courseId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public enum Status {
        pending, rejected, accepted
    }

    public RequestModal() {
    }

    public RequestModal(Integer id, Integer requestBy, Integer processedBy, String type, String description, Status status, Integer sectionId, Integer courseId, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.requestBy = requestBy;
        this.processedBy = processedBy;
        this.type = type;
        this.description = description;
        this.status = status;
        this.sectionId = sectionId;
        this.courseId = courseId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getRequestBy() {
        return requestBy;
    }

    public void setRequestBy(Integer requestBy) {
        this.requestBy = requestBy;
    }

    public Integer getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(Integer processedBy) {
        this.processedBy = processedBy;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
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

    public Integer getSectionId() {
        return sectionId;
    }

    public void setSectionId(Integer sectionId) {
        this.sectionId = sectionId;
    }

    public Integer getCourseId() {
        return courseId;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
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

    @Override
    public String toString() {
        return "RequestModal{" + "id=" + id + ", requestBy=" + requestBy + ", processedBy=" + processedBy + ", type=" + type + ", description=" + description + ", status=" + status + ", sectionId=" + sectionId + ", courseId=" + courseId + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }
} 