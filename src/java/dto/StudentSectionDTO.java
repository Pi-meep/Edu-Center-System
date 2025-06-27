/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author HanND
 */
public class StudentSectionDTO {

    private int studentId;
    private String studentName;
    private boolean isPaid;
    private boolean attendanceStatus;

    public StudentSectionDTO() {
    }

    public StudentSectionDTO(int studentId, String studentName, boolean isPaid, boolean attendanceStatus) {
        this.studentId = studentId;
        this.studentName = studentName;
        this.isPaid = isPaid;
        this.attendanceStatus = attendanceStatus;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public boolean isIsPaid() {
        return isPaid;
    }

    public void setIsPaid(boolean isPaid) {
        this.isPaid = isPaid;
    }

    public boolean isAttendanceStatus() {
        return attendanceStatus;
    }

    public void setAttendanceStatus(boolean attendanceStatus) {
        this.attendanceStatus = attendanceStatus;
    }
    
}
