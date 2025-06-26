<%-- 
    Document   : teacherSchedule.jsp
    Created on : May 23, 2025, 4:29:19 AM
    Author     : Astersa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<% request.setAttribute("title", "Thời khóa biểu giáo viên");%>

<jsp:include page="layout/header.jsp" />

<style>
.ts-schedule-header {
    background: white;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    border-bottom: 1px solid #e1e8ed;
    padding: 1.5rem 0;
}
.ts-schedule-header-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.ts-schedule-header h1 {
    font-size: 2rem;
    font-weight: 700;
    color: #333;
    margin-bottom: 0.5rem;
}
.ts-schedule-header p {
    color: #666;
    font-size: 0.95rem;
}
.ts-schedule-main {
    max-width: 1200px;
    margin: 2rem auto;
    padding: 0 2rem;
}
.ts-schedule-container {
    background: white;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    overflow: hidden;
    border: 1px solid #e1e8ed;
}
.ts-schedule-header-info {
    padding: 2rem;
    border-bottom: 1px solid #e1e8ed;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: linear-gradient(135deg, rgba(102,126,234,0.05), rgba(118,75,162,0.05));
}
.ts-user-info {
    display: flex;
    align-items: center;
    gap: 1rem;
}
.ts-user-avatar {
    width: 60px;
    height: 60px;
    background: linear-gradient(135deg, #667eea, #764ba2);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: bold;
    font-size: 1.5rem;
}
.ts-user-details h2 {
    font-size: 1.5rem;
    font-weight: 600;
    color: #333;
    margin-bottom: 0.25rem;
}
.ts-user-details p {
    color: #666;
}
.ts-week-navigator {
    display: flex;
    align-items: center;
    gap: 1rem;
}
.ts-nav-btn {
    width: 40px;
    height: 40px;
    border: none;
    background: white;
    border-radius: 8px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}
.ts-nav-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.ts-week-info {
    font-weight: 500;
    color: #333;
    min-width: 120px;
    text-align: center;
}
.ts-schedule-grid {
    padding: 2rem;
}
.ts-schedule-table {
    display: grid;
    grid-template-columns: 120px repeat(5, 1fr);
    gap: 0.5rem;
}
.ts-time-header, .ts-day-header {
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    color: #333;
    border-radius: 12px;
    font-size: 0.9rem;
}
.ts-time-header {
    background: #f8f9ff;
    border: 1px solid #e1e8ed;
}
.ts-day-header {
    background: linear-gradient(135deg, rgba(102,126,234,0.1), rgba(118,75,162,0.1));
    border: 1px solid rgba(102,126,234,0.2);
}
.ts-time-slot {
    height: 80px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.8rem;
    color: #666;
    background: #f8f9ff;
    border: 1px solid #e1e8ed;
    border-radius: 8px;
}
.ts-lesson-slot {
    height: 80px;
    padding: 0.5rem;
    border-radius: 8px;
    border: 2px solid;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    flex-direction: column;
    justify-content: center;
}
.ts-lesson-slot:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.ts-lesson-subject {
    font-size: 0.8rem;
    font-weight: 600;
    margin-bottom: 0.25rem;
    line-height: 1.2;
}
.ts-lesson-detail {
    font-size: 0.7rem;
    color: #666;
    line-height: 1.2;
}
.ts-lesson-room {
    font-size: 0.7rem;
    color: #888;
    display: flex;
    align-items: center;
    gap: 0.25rem;
}
.ts-lesson-type {
    background: #e3f2fd;
    border-color: #2196f3;
    color: #1976d2;
}
.ts-meeting-type {
    background: #f3e5f5;
    border-color: #9c27b0;
    color: #7b1fa2;
}
.ts-extra-type {
    background: #e8f5e8;
    border-color: #4caf50;
    color: #388e3c;
}
.ts-admin-type {
    background: #fff3e0;
    border-color: #ff9800;
    color: #f57c00;
}
.ts-schedule-legend {
    padding: 1.5rem 2rem 2rem;
    background: #f8f9ff;
    border-top: 1px solid #e1e8ed;
}
.ts-legend-title {
    font-size: 0.9rem;
    font-weight: 600;
    color: #333;
    margin-bottom: 1rem;
}
.ts-legend-items {
    display: flex;
    flex-wrap: wrap;
    gap: 1.5rem;
}
.ts-legend-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}
.ts-legend-color {
    width: 16px;
    height: 16px;
    border-radius: 4px;
    border: 1px solid;
}
.ts-legend-text {
    font-size: 0.8rem;
    color: #666;
}
@media (max-width: 768px) {
    .ts-schedule-header-container {
        flex-direction: column;
        gap: 1rem;
        text-align: center;
    }
    .ts-schedule-header-info {
        flex-direction: column;
        gap: 1rem;
        text-align: center;
    }
    .ts-schedule-table {
        grid-template-columns: 100px repeat(5, 1fr);
        gap: 0.25rem;
    }
    .ts-time-slot, .ts-lesson-slot {
        height: 60px;
        font-size: 0.7rem;
    }
    .ts-lesson-subject {
        font-size: 0.7rem;
    }
    .ts-lesson-detail, .ts-lesson-room {
        font-size: 0.6rem;
    }
}
@keyframes ts-fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
.ts-schedule-container {
    animation: ts-fadeInUp 0.6s ease;
}
</style>

<!-- Header Section -->
<div class="ts-schedule-header">
    <div class="ts-schedule-header-container">
        <div>
            <h1>Thời khóa biểu giáo viên</h1>
            <p>Xem lịch giảng dạy của bạn</p>
        </div>
    </div>
</div>

<div class="ts-schedule-main">
    <div class="ts-schedule-container">
        <div class="ts-schedule-header-info">
            <div class="ts-user-info">
                <div class="ts-user-avatar" id="user-avatar">C</div>
                <div class="ts-user-details">
                    <h2 id="user-name">Cô Lan</h2>
                    <p id="user-info">Môn Toán</p>
                </div>
            </div>
            <div class="ts-week-navigator">
                <button class="ts-nav-btn" onclick="previousWeek()">←</button>
                <span class="ts-week-info">Tuần 25 - 2024</span>
                <button class="ts-nav-btn" onclick="nextWeek()">→</button>
            </div>
        </div>
        <div class="ts-schedule-grid">
            <div class="ts-schedule-table" id="schedule-table">
                <!-- Schedule content will be generated by JavaScript -->
            </div>
        </div>
        <div class="ts-schedule-legend">
            <div class="ts-legend-title">Chú thích:</div>
            <div class="ts-legend-items" id="legend-items">
                <!-- Legend items will be generated by JavaScript -->
            </div>
        </div>
    </div>
</div>

<script>
    let currentWeek = new Date();
    
    // Sample teacher schedule data
    const teacherSchedule = {
        name: 'Cô Lan',
        subject: 'Toán',
        schedule: {
            'Thứ 2': [
                { time: '7:00-7:45', subject: 'Toán 10A1', class: '10A1', room: 'A101', students: 35, type: 'lesson' },
                { time: '7:45-8:30', subject: 'Toán 10B2', class: '10B2', room: 'A103', students: 32, type: 'lesson' },
                { time: '9:30-10:15', subject: 'Toán 11C1', class: '11C1', room: 'A105', students: 28, type: 'lesson' }
            ],
            'Thứ 3': [
                { time: '7:00-7:45', subject: 'Toán 10A1', class: '10A1', room: 'A101', students: 35, type: 'lesson' },
                { time: '8:45-9:30', subject: 'Họp tổ bộ môn', class: '', room: 'Phòng họp', students: 0, type: 'meeting' },
                { time: '14:00-15:30', subject: 'Bồi dưỡng học sinh giỏi', class: 'Nhóm HSG', room: 'A107', students: 12, type: 'extra' }
            ],
            'Thứ 4': [
                { time: '7:00-7:45', subject: 'Toán 10B2', class: '10B2', room: 'A103', students: 32, type: 'lesson' },
                { time: '7:45-8:30', subject: 'Toán 11C1', class: '11C1', room: 'A105', students: 28, type: 'lesson' },
                { time: '9:30-10:15', subject: 'Toán 10A1', class: '10A1', room: 'A101', students: 35, type: 'lesson' }
            ],
            'Thứ 5': [
                { time: '7:45-8:30', subject: 'Toán 10B2', class: '10B2', room: 'A103', students: 32, type: 'lesson' },
                { time: '8:45-9:30', subject: 'Toán 11C1', class: '11C1', room: 'A105', students: 28, type: 'lesson' }
            ],
            'Thứ 6': [
                { time: '7:00-7:45', subject: 'Toán 10A1', class: '10A1', room: 'A101', students: 35, type: 'lesson' },
                { time: '14:00-16:00', subject: 'Chấm bài kiểm tra', class: '', room: 'Văn phòng', students: 0, type: 'admin' }
            ]
        }
    };

    const days = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6'];
    const timeSlots = ['7:00-7:45', '7:45-8:30', '8:30-8:45', '8:45-9:30', '9:30-10:15', '10:15-11:00', '14:00-14:45', '14:45-15:30', '15:30-16:15'];

    function getTypeColor(type) {
        const colors = {
            'lesson': 'ts-lesson-type',
            'meeting': 'ts-meeting-type',
            'extra': 'ts-extra-type',
            'admin': 'ts-admin-type'
        };
        return colors[type] || 'ts-lesson-type';
    }

    function updateSchedule() {
        // Update user info
        document.getElementById('user-name').textContent = teacherSchedule.name;
        document.getElementById('user-avatar').textContent = teacherSchedule.name.charAt(0);
        document.getElementById('user-info').textContent = 'Môn ' + teacherSchedule.subject;

        // Generate schedule table
        let tableHTML = '';
        tableHTML += '<div class="ts-time-header">Tiết học</div>';
        
        days.forEach(day => {
            tableHTML += '<div class="ts-day-header">' + day + '</div>';
        });
        
        timeSlots.forEach(timeSlot => {
            tableHTML += '<div class="ts-time-slot">' + timeSlot + '</div>';
            
            days.forEach(day => {
                const lesson = teacherSchedule.schedule[day] ? teacherSchedule.schedule[day].find(item => item.time === timeSlot) : null;
                
                if (!lesson) {
                    tableHTML += '<div class="ts-time-slot"></div>';
                } else {
                    const typeClass = getTypeColor(lesson.type);
                    tableHTML += '<div class="ts-lesson-slot ' + typeClass + '">';
                    tableHTML += '<div class="ts-lesson-subject">' + lesson.subject + '</div>';
                    tableHTML += '<div class="ts-lesson-detail">' + lesson.class + '</div>';
                    if (lesson.room) {
                        tableHTML += '<div class="ts-lesson-room">📍 ' + lesson.room + '</div>';
                    }
                    tableHTML += '</div>';
                }
            });
        });
        
        document.getElementById('schedule-table').innerHTML = tableHTML;
        updateLegend();
    }

    function updateLegend() {
        const legendItems = [
            { color: 'ts-lesson-type', text: 'Giảng dạy' },
            { color: 'ts-meeting-type', text: 'Họp' },
            { color: 'ts-extra-type', text: 'Bồi dưỡng' },
            { color: 'ts-admin-type', text: 'Công việc khác' }
        ];
        
        let legendHTML = '';
        legendItems.forEach(item => {
            legendHTML += '<div class="ts-legend-item">';
            legendHTML += '<div class="ts-legend-color ' + item.color + '"></div>';
            legendHTML += '<span class="ts-legend-text">' + item.text + '</span>';
            legendHTML += '</div>';
        });
        
        document.getElementById('legend-items').innerHTML = legendHTML;
    }

    function previousWeek() {
        currentWeek.setDate(currentWeek.getDate() - 7);
        updateWeekDisplay();
    }

    function nextWeek() {
        currentWeek.setDate(currentWeek.getDate() + 7);
        updateWeekDisplay();
    }

    function updateWeekDisplay() {
        const weekNumber = Math.ceil((currentWeek.getDate() + new Date(currentWeek.getFullYear(), currentWeek.getMonth(), 1).getDay()) / 7);
        const year = currentWeek.getFullYear();
        document.querySelector('.ts-week-info').textContent = 'Tuần ' + weekNumber + ' - ' + year;
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateSchedule();
        updateWeekDisplay();
    });
</script>

<jsp:include page="layout/footer.jsp" /> 