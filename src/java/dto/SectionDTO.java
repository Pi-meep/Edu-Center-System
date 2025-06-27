/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import modal.SectionModal;
import modal.SectionModal.DayOfWeekEnum;
import modal.SectionModal.Status;

/**
 *
 * @author HanND
 */
public class SectionDTO {

    private Integer id;
    private Integer courseId;
    private DayOfWeekEnum dayOfWeek;
    private String classroom;
    private Status status;
    private String teacherName;

    private String formattedStartTime;
    private String formattedEndTime;
    private String formattedDateTime;

    private SectionModal section;

    public SectionDTO(SectionModal section,
            String formattedStartTime,
            String formattedEndTime,
            String formattedDateTime) {
        this.section = section;

        this.id = section.getId();
        this.courseId = section.getCourseId();
        this.dayOfWeek = section.getDayOfWeek();
        this.classroom = section.getClassroom();
        this.status = section.getStatus();

        this.formattedStartTime = formattedStartTime;
        this.formattedEndTime = formattedEndTime;
        this.formattedDateTime = formattedDateTime;
    }

    public Integer getId() {
        return id;
    }

    public Integer getCourseId() {
        return courseId;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public DayOfWeekEnum getDayOfWeek() {
        return dayOfWeek;
    }

    public String getClassroom() {
        return classroom;
    }

    public Status getStatus() {
        return status;
    }

    public String getFormattedStartTime() {
        return formattedStartTime;
    }

    public String getFormattedEndTime() {
        return formattedEndTime;
    }

    public String getFormattedDateTime() {
        return formattedDateTime;
    }

    public SectionModal getSection() {
        return section;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
    }

    public void setDayOfWeek(DayOfWeekEnum dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public void setClassroom(String classroom) {
        this.classroom = classroom;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public void setFormattedStartTime(String formattedStartTime) {
        this.formattedStartTime = formattedStartTime;
    }

    public void setFormattedEndTime(String formattedEndTime) {
        this.formattedEndTime = formattedEndTime;
    }

    public void setFormattedDateTime(String formattedDateTime) {
        this.formattedDateTime = formattedDateTime;
    }

    public void setSection(SectionModal section) {
        this.section = section;
    }
    
    
}
