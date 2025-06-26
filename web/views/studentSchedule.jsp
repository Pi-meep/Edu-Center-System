<%-- 
    Document   : studentSchedule.jsp
    Created on : May 23, 2025, 4:29:19 AM
    Author     : Astersa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<% request.setAttribute("title", "Thời khóa biểu học sinh");%>

<jsp:include page="layout/header.jsp" />

<style>
.ss-schedule-header {
    background: white;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    border-bottom: 1px solid #e1e8ed;
    padding: 1.5rem 0;
}
.ss-schedule-header-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.ss-schedule-header h1 {
    font-size: 2rem;
    font-weight: 700;
    color: #333;
    margin-bottom: 0.5rem;
}
.ss-schedule-header p {
    color: #666;
    font-size: 0.95rem;
}
.ss-schedule-main {
    max-width: 1200px;
    margin: 2rem auto;
    padding: 0 2rem;
}
.ss-schedule-container {
    background: white;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    overflow: hidden;
    border: 1px solid #e1e8ed;
}
.ss-schedule-header-info {
    padding: 2rem;
    border-bottom: 1px solid #e1e8ed;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: linear-gradient(135deg, rgba(102,126,234,0.05), rgba(118,75,162,0.05));
}
.ss-user-info {
    display: flex;
    align-items: center;
    gap: 1rem;
}
.ss-user-avatar {
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
.ss-user-details h2 {
    font-size: 1.5rem;
    font-weight: 600;
    color: #333;
    margin-bottom: 0.25rem;
}
.ss-user-details p {
    color: #666;
}
.ss-week-navigator {
    display: flex;
    align-items: center;
    gap: 1rem;
}
.ss-nav-btn {
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
.ss-nav-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.ss-week-info {
    font-weight: 500;
    color: #333;
    min-width: 120px;
    text-align: center;
}
.ss-schedule-grid {
    padding: 2rem;
}
.ss-schedule-table {
    display: grid;
    grid-template-columns: 120px repeat(5, 1fr);
    gap: 0.5rem;
}
.ss-time-header, .ss-day-header {
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    color: #333;
    border-radius: 12px;
    font-size: 0.9rem;
}
.ss-time-header {
    background: #f8f9ff;
    border: 1px solid #e1e8ed;
}
.ss-day-header {
    background: linear-gradient(135deg, rgba(102,126,234,0.1), rgba(118,75,162,0.1));
    border: 1px solid rgba(102,126,234,0.2);
}
.ss-time-slot {
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
.ss-lesson-slot {
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
.ss-lesson-slot:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.ss-lesson-subject {
    font-size: 0.8rem;
    font-weight: 600;
    margin-bottom: 0.25rem;
    line-height: 1.2;
}
.ss-lesson-detail {
    font-size: 0.7rem;
    color: #666;
    line-height: 1.2;
}
.ss-lesson-room {
    font-size: 0.7rem;
    color: #888;
    display: flex;
    align-items: center;
    gap: 0.25rem;
}
.ss-lesson-type {
    background: #e3f2fd;
    border-color: #2196f3;
    color: #1976d2;
}
.ss-break-type {
    background: #f5f5f5;
    border-color: #9e9e9e;
    color: #616161;
}
.ss-schedule-legend {
    padding: 1.5rem 2rem 2rem;
    background: #f8f9ff;
    border-top: 1px solid #e1e8ed;
}
.ss-legend-title {
    font-size: 0.9rem;
    font-weight: 600;
    color: #333;
    margin-bottom: 1rem;
}
.ss-legend-items {
    display: flex;
    flex-wrap: wrap;
    gap: 1.5rem;
}
.ss-legend-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}
.ss-legend-color {
    width: 16px;
    height: 16px;
    border-radius: 4px;
    border: 1px solid;
}
.ss-legend-text {
    font-size: 0.8rem;
    color: #666;
}
@media (max-width: 768px) {
    .ss-schedule-header-container {
        flex-direction: column;
        gap: 1rem;
        text-align: center;
    }
    .ss-schedule-header-info {
        flex-direction: column;
        gap: 1rem;
        text-align: center;
    }
    .ss-schedule-table {
        grid-template-columns: 100px repeat(5, 1fr);
        gap: 0.25rem;
    }
    .ss-time-slot, .ss-lesson-slot {
        height: 60px;
        font-size: 0.7rem;
    }
    .ss-lesson-subject {
        font-size: 0.7rem;
    }
    .ss-lesson-detail, .ss-lesson-room {
        font-size: 0.6rem;
    }
}
@keyframes ss-fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
.ss-schedule-container {
    animation: ss-fadeInUp 0.6s ease;
}
</style>

<!-- Header Section -->
<div class="ss-schedule-header">
    <div class="ss-schedule-header-container">
        <div>
            <h1>Thời khóa biểu học sinh</h1>
            <p>Xem thời khóa biểu học tập của bạn</p>
        </div>
    </div>
</div>

<div class="ss-schedule-main">
    <div class="ss-schedule-container">
        <div class="ss-schedule-header-info">
            <div class="ss-user-info">
                <div class="ss-user-avatar" id="user-avatar">N</div>
                <div class="ss-user-details">
                    <h2 id="user-name">Nguyễn Văn A</h2>
                    <p id="user-info">Lớp 10A1</p>
                </div>
            </div>
            <div class="ss-week-navigator">
                <button class="ss-nav-btn" onclick="previousWeek()">←</button>
                <span class="ss-week-info">Tuần 25 - 2024</span>
                <button class="ss-nav-btn" onclick="nextWeek()">→</button>
            </div>
        </div>
        <div class="ss-schedule-grid">
            <div class="ss-schedule-table" id="schedule-table">
                <!-- Schedule content will be generated by JavaScript -->
            </div>
        </div>
        <div class="ss-schedule-legend">
            <div class="ss-legend-title">Chú thích:</div>
            <div class="ss-legend-items" id="legend-items">
                <!-- Legend items will be generated by JavaScript -->
            </div>
        </div>
    </div>
</div>

<script>
    let currentWeek = new Date();
    
    // Sample student schedule data
    const studentSchedule = {
        name: 'Nguyễn Văn A',
        class: '10A1',
        schedule: {
            'Thứ 2': [
                { time: '7:00-7:45', subject: 'Toán', teacher: 'Cô Lan', room: 'A101', type: 'lesson' },
                { time: '7:45-8:30', subject: 'Văn', teacher: 'Thầy Minh', room: 'A102', type: 'lesson' },
                { time: '8:30-8:45', subject: 'Giải lao', teacher: '', room: '', type: 'break' },
                { time: '8:45-9:30', subject: 'Anh', teacher: 'Cô Hoa', room: 'B201', type: 'lesson' },
                { time: '9:30-10:15', subject: 'Lý', teacher: 'Thầy Nam', room: 'C301', type: 'lesson' }
            ],
            'Thứ 3': [
                { time: '7:00-7:45', subject: 'Hóa', teacher: 'Cô Mai', room: 'D401', type: 'lesson' },
                { time: '7:45-8:30', subject: 'Sinh', teacher: 'Thầy Tùng', room: 'E501', type: 'lesson' },
                { time: '8:30-8:45', subject: 'Giải lao', teacher: '', room: '', type: 'break' },
                { time: '8:45-9:30', subject: 'Sử', teacher: 'Cô Linh', room: 'F601', type: 'lesson' },
                { time: '9:30-10:15', subject: 'Địa', teacher: 'Thầy Đức', room: 'G701', type: 'lesson' }
            ],
            'Thứ 4': [
                { time: '7:00-7:45', subject: 'Toán', teacher: 'Cô Lan', room: 'A101', type: 'lesson' },
                { time: '7:45-8:30', subject: 'Văn', teacher: 'Thầy Minh', room: 'A102', type: 'lesson' },
                { time: '8:30-8:45', subject: 'Giải lao', teacher: '', room: '', type: 'break' },
                { time: '8:45-9:30', subject: 'Thể dục', teacher: 'Thầy Cường', room: 'Sân thể thao', type: 'lesson' }
            ],
            'Thứ 5': [
                { time: '7:00-7:45', subject: 'Anh', teacher: 'Cô Hoa', room: 'B201', type: 'lesson' },
                { time: '7:45-8:30', subject: 'Lý', teacher: 'Thầy Nam', room: 'C301', type: 'lesson' },
                { time: '8:30-8:45', subject: 'Giải lao', teacher: '', room: '', type: 'break' },
                { time: '8:45-9:30', subject: 'Hóa', teacher: 'Cô Mai', room: 'D401', type: 'lesson' }
            ],
            'Thứ 6': [
                { time: '7:00-7:45', subject: 'Sinh', teacher: 'Thầy Tùng', room: 'E501', type: 'lesson' },
                { time: '7:45-8:30', subject: 'Sử', teacher: 'Cô Linh', room: 'F601', type: 'lesson' },
                { time: '8:30-8:45', subject: 'Giải lao', teacher: '', room: '', type: 'break' },
                { time: '8:45-9:30', subject: 'Địa', teacher: 'Thầy Đức', room: 'G701', type: 'lesson' }
            ]
        }
    };

    const days = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6'];
    const timeSlots = ['7:00-7:45', '7:45-8:30', '8:30-8:45', '8:45-9:30', '9:30-10:15', '10:15-11:00', '14:00-14:45', '14:45-15:30', '15:30-16:15'];

    function getTypeColor(type) {
        const colors = {
            'lesson': 'ss-lesson-type',
            'break': 'ss-break-type'
        };
        return colors[type] || 'ss-break-type';
    }

    function updateSchedule() {
        // Update user info
        document.getElementById('user-name').textContent = studentSchedule.name;
        document.getElementById('user-avatar').textContent = studentSchedule.name.charAt(0);
        document.getElementById('user-info').textContent = 'Lớp ' + studentSchedule.class;

        // Generate schedule table
        let tableHTML = '';
        tableHTML += '<div class="ss-time-header">Tiết học</div>';
        
        days.forEach(day => {
            tableHTML += '<div class="ss-day-header">' + day + '</div>';
        });
        
        timeSlots.forEach(timeSlot => {
            tableHTML += '<div class="ss-time-slot">' + timeSlot + '</div>';
            
            days.forEach(day => {
                const lesson = studentSchedule.schedule[day] ? studentSchedule.schedule[day].find(item => item.time === timeSlot) : null;
                
                if (!lesson) {
                    tableHTML += '<div class="ss-time-slot"></div>';
                } else {
                    const typeClass = getTypeColor(lesson.type);
                    tableHTML += '<div class="ss-lesson-slot ' + typeClass + '">';
                    tableHTML += '<div class="ss-lesson-subject">' + lesson.subject + '</div>';
                    tableHTML += '<div class="ss-lesson-detail">' + lesson.teacher + '</div>';
                    if (lesson.room) {
                        tableHTML += '<div class="ss-lesson-room">📍 ' + lesson.room + '</div>';
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
            { color: 'ss-lesson-type', text: 'Môn học' },
            { color: 'ss-break-type', text: 'Giải lao' }
        ];
        
        let legendHTML = '';
        legendItems.forEach(item => {
            legendHTML += '<div class="ss-legend-item">';
            legendHTML += '<div class="ss-legend-color ' + item.color + '"></div>';
            legendHTML += '<span class="ss-legend-text">' + item.text + '</span>';
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
        document.querySelector('.ss-week-info').textContent = 'Tuần ' + weekNumber + ' - ' + year;
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateSchedule();
        updateWeekDisplay();
    });
</script>

<jsp:include page="layout/footer.jsp" /> 