<%-- 
    Document   : parentSchedule.jsp
    Created on : May 23, 2025, 4:29:19 AM
    Author     : Astersa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<% request.setAttribute("title", "Thời khóa biểu phụ huynh");%>

<jsp:include page="layout/header.jsp" />

<style>

    
.ps-parent-header {
    background: white;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    border-bottom: 1px solid #e1e8ed;
    padding: 1.5rem 0;
}
.ps-parent-header-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 2rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.ps-parent-header h1 {
    font-size: 2rem;
    font-weight: 700;
    color: #333;
    margin-bottom: 0.5rem;
}
.ps-parent-header p {
    color: #666;
    font-size: 0.95rem;
}
.ps-parent-main {
    max-width: 1200px;
    margin: 2rem auto;
    padding: 0 2rem;
}
.ps-child-selector {
    background: white;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    padding: 2rem;
    margin-bottom: 2rem;
    border: 1px solid #e1e8ed;
}
.ps-child-selector h2 {
    font-size: 1.25rem;
    font-weight: 600;
    color: #333;
    margin-bottom: 1.5rem;
}
.ps-children-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 1rem;
}
.ps-child-card {
    padding: 1.5rem;
    border-radius: 12px;
    border: 2px solid #e1e8ed;
    cursor: pointer;
    transition: all 0.3s ease;
    text-align: left;
    background: white;
}
.ps-child-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.1);
}
.ps-child-card.selected {
    border-color: #667eea;
    background: linear-gradient(135deg, rgba(102,126,234,0.05), rgba(118,75,162,0.05));
    box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
}
.ps-child-info {
    display: flex;
    align-items: center;
    gap: 1rem;
}
.ps-child-avatar {
    font-size: 2rem;
    width: 50px;
    height: 50px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #667eea, #764ba2);
    border-radius: 50%;
    color: white;
}
.ps-child-details h3 {
    font-weight: 600;
    color: #333;
    margin-bottom: 0.25rem;
}
.ps-child-details p {
    color: #666;
    font-size: 0.9rem;
}
.ps-schedule-container {
    background: white;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    overflow: hidden;
    border: 1px solid #e1e8ed;
    display: none;
}
.ps-schedule-header-info {
    padding: 2rem;
    border-bottom: 1px solid #e1e8ed;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: linear-gradient(135deg, rgba(102,126,234,0.05), rgba(118,75,162,0.05));
}
.ps-user-info {
    display: flex;
    align-items: center;
    gap: 1rem;
}
.ps-user-avatar {
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
.ps-user-details h2 {
    font-size: 1.5rem;
    font-weight: 600;
    color: #333;
    margin-bottom: 0.25rem;
}
.ps-user-details p {
    color: #666;
}
.ps-week-navigator {
    display: flex;
    align-items: center;
    gap: 1rem;
}
.ps-nav-btn {
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
.ps-nav-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.ps-week-info {
    font-weight: 500;
    color: #333;
    min-width: 120px;
    text-align: center;
}
.ps-schedule-grid {
    padding: 2rem;
}
.ps-schedule-table {
    display: grid;
    grid-template-columns: 120px repeat(5, 1fr);
    gap: 0.5rem;
}
.ps-time-header, .ps-day-header {
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    color: #333;
    border-radius: 12px;
    font-size: 0.9rem;
}
.ps-time-header {
    background: #f8f9ff;
    border: 1px solid #e1e8ed;
}
.ps-day-header {
    background: linear-gradient(135deg, rgba(102,126,234,0.1), rgba(118,75,162,0.1));
    border: 1px solid rgba(102,126,234,0.2);
}
.ps-time-slot {
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
.ps-lesson-slot {
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
.ps-lesson-slot:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}
.ps-lesson-subject {
    font-size: 0.8rem;
    font-weight: 600;
    margin-bottom: 0.25rem;
    line-height: 1.2;
}
.ps-lesson-detail {
    font-size: 0.7rem;
    color: #666;
    line-height: 1.2;
}
.ps-lesson-room {
    font-size: 0.7rem;
    color: #888;
    display: flex;
    align-items: center;
    gap: 0.25rem;
}
.ps-lesson-type {
    background: #e3f2fd;
    border-color: #2196f3;
    color: #1976d2;
}
.ps-break-type {
    background: #f5f5f5;
    border-color: #9e9e9e;
    color: #616161;
}
.ps-schedule-legend {
    padding: 1.5rem 2rem 2rem;
    background: #f8f9ff;
    border-top: 1px solid #e1e8ed;
}
.ps-legend-title {
    font-size: 0.9rem;
    font-weight: 600;
    color: #333;
    margin-bottom: 1rem;
}
.ps-legend-items {
    display: flex;
    flex-wrap: wrap;
    gap: 1.5rem;
}
.ps-legend-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}
.ps-legend-color {
    width: 16px;
    height: 16px;
    border-radius: 4px;
    border: 1px solid;
}
.ps-legend-text {
    font-size: 0.8rem;
    color: #666;
}
@media (max-width: 768px) {
    .ps-parent-header-container {
        flex-direction: column;
        gap: 1rem;
        text-align: center;
    }
    .ps-schedule-header-info {
        flex-direction: column;
        gap: 1rem;
        text-align: center;
    }
    .ps-schedule-table {
        grid-template-columns: 100px repeat(5, 1fr);
        gap: 0.25rem;
    }
    .ps-time-slot, .ps-lesson-slot {
        height: 60px;
        font-size: 0.7rem;
    }
    .ps-lesson-subject {
        font-size: 0.7rem;
    }
    .ps-lesson-detail, .ps-lesson-room {
        font-size: 0.6rem;
    }
    .ps-children-grid {
        grid-template-columns: 1fr;
    }
}
@keyframes ps-fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
.ps-schedule-container {
    animation: ps-fadeInUp 0.6s ease;
}
.ps-child-card {
    animation: ps-fadeInUp 0.6s ease;
}
</style>

<!-- Header Section -->
<div class="ps-parent-header">
    <div class="ps-parent-header-container">
        <div>
            <h1>Thời khóa biểu phụ huynh</h1>
            <p>Xem thời khóa biểu của con em</p>
        </div>
    </div>
</div>

<div class="ps-parent-main">
    <!-- Child Selector -->
    <div class="ps-child-selector">
        <h2>Chọn con để xem thời khóa biểu</h2>
        <div class="ps-children-grid">
            <div class="ps-child-card" onclick="selectChild(1)">
                <div class="ps-child-info">
                    <div class="ps-child-avatar">👦</div>
                    <div class="ps-child-details">
                        <h3>Nguyễn Văn An</h3>
                        <p>Lớp 10A1</p>
                    </div>
                </div>
            </div>
            <div class="ps-child-card" onclick="selectChild(2)">
                <div class="ps-child-info">
                    <div class="ps-child-avatar">👧</div>
                    <div class="ps-child-details">
                        <h3>Nguyễn Thị Bình</h3>
                        <p>Lớp 8B2</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Schedule Display -->
    <div id="schedule-display" class="ps-schedule-container">
        <div class="ps-schedule-header-info">
            <div class="ps-user-info">
                <div class="ps-user-avatar" id="user-avatar">N</div>
                <div class="ps-user-details">
                    <h2 id="user-name">Nguyễn Văn An</h2>
                    <p id="user-info">Lớp 10A1</p>
                </div>
            </div>
            <div class="ps-week-navigator">
                <button class="ps-nav-btn" onclick="previousWeek()">←</button>
                <span class="ps-week-info">Tuần 25 - 2024</span>
                <button class="ps-nav-btn" onclick="nextWeek()">→</button>
            </div>
        </div>
        <div class="ps-schedule-grid">
            <div class="ps-schedule-table" id="schedule-table">
                <!-- Schedule content will be generated by JavaScript -->
            </div>
        </div>
        <div class="ps-schedule-legend">
            <div class="ps-legend-title">Chú thích:</div>
            <div class="ps-legend-items" id="legend-items">
                <!-- Legend items will be generated by JavaScript -->
            </div>
        </div>
    </div>
</div>

<script>
    let selectedChildId = null;
    let currentWeek = new Date();
    
    // Sample children data
    const children = [
        { 
            id: 1, 
            name: 'Nguyễn Văn An', 
            class: '10A1', 
            avatar: '👦',
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
        },
        { 
            id: 2, 
            name: 'Nguyễn Thị Bình', 
            class: '8B2', 
            avatar: '👧',
            schedule: {
                'Thứ 2': [
                    { time: '7:00-7:45', subject: 'Toán', teacher: 'Cô Hương', room: 'B101', type: 'lesson' },
                    { time: '7:45-8:30', subject: 'Văn', teacher: 'Thầy Dũng', room: 'B102', type: 'lesson' },
                    { time: '8:30-8:45', subject: 'Giải lao', teacher: '', room: '', type: 'break' },
                    { time: '8:45-9:30', subject: 'Anh', teacher: 'Cô Mai', room: 'C201', type: 'lesson' }
                ],
                'Thứ 3': [
                    { time: '7:00-7:45', subject: 'Sinh', teacher: 'Thầy Nam', room: 'D301', type: 'lesson' },
                    { time: '7:45-8:30', subject: 'Lý', teacher: 'Cô Linh', room: 'E401', type: 'lesson' },
                    { time: '8:30-8:45', subject: 'Giải lao', teacher: '', room: '', type: 'break' },
                    { time: '8:45-9:30', subject: 'Hóa', teacher: 'Thầy Tùng', room: 'F501', type: 'lesson' }
                ],
                'Thứ 4': [
                    { time: '7:00-7:45', subject: 'Toán', teacher: 'Cô Hương', room: 'B101', type: 'lesson' },
                    { time: '7:45-8:30', subject: 'Văn', teacher: 'Thầy Dũng', room: 'B102', type: 'lesson' },
                    { time: '8:30-8:45', subject: 'Giải lao', teacher: '', room: '', type: 'break' },
                    { time: '8:45-9:30', subject: 'Thể dục', teacher: 'Thầy Cường', room: 'Sân thể thao', type: 'lesson' }
                ],
                'Thứ 5': [
                    { time: '7:00-7:45', subject: 'Anh', teacher: 'Cô Mai', room: 'C201', type: 'lesson' },
                    { time: '7:45-8:30', subject: 'Lý', teacher: 'Cô Linh', room: 'E401', type: 'lesson' },
                    { time: '8:30-8:45', subject: 'Giải lao', teacher: '', room: '', type: 'break' },
                    { time: '8:45-9:30', subject: 'Hóa', teacher: 'Thầy Tùng', room: 'F501', type: 'lesson' }
                ],
                'Thứ 6': [
                    { time: '7:00-7:45', subject: 'Sinh', teacher: 'Thầy Nam', room: 'D301', type: 'lesson' },
                    { time: '7:45-8:30', subject: 'Sử', teacher: 'Cô Hoa', room: 'G601', type: 'lesson' },
                    { time: '8:30-8:45', subject: 'Giải lao', teacher: '', room: '', type: 'break' },
                    { time: '8:45-9:30', subject: 'Địa', teacher: 'Thầy Đức', room: 'H701', type: 'lesson' }
                ]
            }
        }
    ];

    const days = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6'];
    const timeSlots = ['7:00-7:45', '7:45-8:30', '8:30-8:45', '8:45-9:30', '9:30-10:15', '10:15-11:00', '14:00-14:45', '14:45-15:30', '15:30-16:15'];

    function selectChild(childId) {
        selectedChildId = childId;
        
        // Update child card selection
        document.querySelectorAll('.ps-child-card').forEach(card => card.classList.remove('selected'));
        event.currentTarget.classList.add('selected');
        
        // Show schedule
        document.getElementById('schedule-display').style.display = 'block';
        updateSchedule();
    }

    function getTypeColor(type) {
        const colors = {
            'lesson': 'ps-lesson-type',
            'break': 'ps-break-type'
        };
        return colors[type] || 'ps-break-type';
    }

    function updateSchedule() {
        if (!selectedChildId) return;
        
        const childData = children.find(child => child.id === selectedChildId);
        if (!childData) return;

        // Update user info
        document.getElementById('user-name').textContent = childData.name;
        document.getElementById('user-avatar').textContent = childData.name.charAt(0);
        document.getElementById('user-info').textContent = 'Lớp ' + childData.class;

        // Generate schedule table
        let tableHTML = '';
        tableHTML += '<div class="ps-time-header">Tiết học</div>';
        
        days.forEach(day => {
            tableHTML += '<div class="ps-day-header">' + day + '</div>';
        });
        
        timeSlots.forEach(timeSlot => {
            tableHTML += '<div class="ps-time-slot">' + timeSlot + '</div>';
            
            days.forEach(day => {
                const lesson = childData.schedule[day] ? childData.schedule[day].find(item => item.time === timeSlot) : null;
                
                if (!lesson) {
                    tableHTML += '<div class="ps-time-slot"></div>';
                } else {
                    const typeClass = getTypeColor(lesson.type);
                    tableHTML += '<div class="ps-lesson-slot ' + typeClass + '">';
                    tableHTML += '<div class="ps-lesson-subject">' + lesson.subject + '</div>';
                    tableHTML += '<div class="ps-lesson-detail">' + lesson.teacher + '</div>';
                    if (lesson.room) {
                        tableHTML += '<div class="ps-lesson-room">📍 ' + lesson.room + '</div>';
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
            { color: 'ps-lesson-type', text: 'Môn học' },
            { color: 'ps-break-type', text: 'Giải lao' }
        ];
        
        let legendHTML = '';
        legendItems.forEach(item => {
            legendHTML += '<div class="ps-legend-item">';
            legendHTML += '<div class="ps-legend-color ' + item.color + '"></div>';
            legendHTML += '<span class="ps-legend-text">' + item.text + '</span>';
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
        document.querySelector('.ps-week-info').textContent = 'Tuần ' + weekNumber + ' - ' + year;
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateWeekDisplay();
    });
</script>

<jsp:include page="layout/footer.jsp" /> 