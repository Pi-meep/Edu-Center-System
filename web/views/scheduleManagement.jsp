<%-- 
    Document   : scheduleManagement
    Created on : Jul 10, 2025, 10:00:00 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<fmt:setLocale value="vi_VN" />
<jsp:include page="layout/adminHeader.jsp" />
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    .bg-success {
        background-color: #248a27 !important;
    }
    .bg-primary {
        background-color: #1768aa !important;
    }
    .bg-danger {
        background-color: #a1170e !important;
    }
    .text-white {
        color: white !important;
    }

    .calendar-container {
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 0 15px rgba(0,0,0,0.05);
        margin-bottom: 30px;
    }

    .calendar-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 20px;
        border-bottom: 1px solid #eee;
    }

    .calendar-view-options .btn {
        margin-left: 5px;
    }

    .calendar-body {
        padding: 20px;
    }

    .calendar-filters {
        background: #f9f9f9;
        padding: 15px 20px;
        border-radius: 8px;
        margin-bottom: 20px;
    }

    .calendar-grid {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 10px;
    }

    .calendar-day-header {
        text-align: center;
        font-weight: bold;
        padding: 10px;
        background: #f5f5f5;
        border-radius: 5px;
    }

    .calendar-day {
        min-height: 120px;
        border: 1px solid #eee;
        border-radius: 5px;
        padding: 10px;
        position: relative;
    }

    .calendar-day.today {
        background-color: #f0f8ff;
        border-color: #007bff;
    }

    .calendar-day-number {
        position: absolute;
        top: 5px;
        right: 10px;
        font-weight: bold;
        color: #777;
    }

    .calendar-event {
        background: #e1f5fe;
        border-left: 3px solid #03a9f4;
        padding: 5px 8px;
        margin-bottom: 5px;
        border-radius: 3px;
        font-size: 12px;
        cursor: pointer;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .calendar-event.conflict {
        background: #ffebee;
        border-left-color: #f44336;
    }

    .modal-body .form-group {
        margin-bottom: 15px;
    }

    .conflict-warning {
        color: #f44336;
        margin-top: 10px;
        display: none;
    }

    .export-options {
        margin-top: 20px;
    }

    /* Time slots for day view */
    .time-slot {
        position: relative;
        border-bottom: 1px solid #eee;
        padding: 10px;
        height: 60px;
        min-height: 60px;
    }

    .time-label {
        position: absolute;
        left: -70px;
        width: 60px;
        text-align: right;
        font-size: 13px;
        color: #666;
        top: 0;
    }

    .day-view-events {
        margin-left: 70px;
        position: relative;
        height: 100%;
    }

    /* Day view container */
    #dayView {
        display: flex;
        flex-direction: column;
        width: 100%;
        border: 1px solid #ccc;
        position: relative;
        padding-left: 80px;
        background: #fafafa;
        box-sizing: border-box;
    }

    .time-slots-container {
        position: relative;
    }

    /* Month view styles */
    .month-view-grid {
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        gap: 2px;
        background: #f5f5f5;
        padding: 10px;
        border-radius: 8px;
    }

    .month-view-day {
        min-height: 100px;
        border: 1px solid #ddd;
        padding: 5px;
        font-size: 12px;
        background: white;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .month-view-day:hover {
        background-color: #f8f9fa;
    }

    .month-view-day.today {
        background-color: #e3f2fd;
        border-color: #2196f3;
    }

    .month-view-day.empty-day {
        background-color: #f9f9f9;
        cursor: default;
    }

    .month-view-day.empty-day:hover {
        background-color: #f9f9f9;
    }

    .month-view-day-number {
        font-weight: bold;
        margin-bottom: 3px;
        color: #333;
    }

    .month-view-events {
        display: flex;
        flex-direction: column;
        gap: 2px;
    }

    .month-view-event {
        background: #e1f5fe;
        border-left: 2px solid #03a9f4;
        padding: 2px 4px;
        border-radius: 2px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
        font-size: 10px;
        line-height: 1.2;
    }

    .event-time {
        font-weight: bold;
        color: #0277bd;
    }

    .event-room {
        color: #666;
    }

    .event-teacher {
        color: #666;
        font-style: italic;
    }

    .more-events {
        background: #f5f5f5;
        border-left-color: #999;
        text-align: center;
        font-weight: bold;
        color: #666;
    }
    .calendar-actions {
        display: flex;
        gap: 20px;
        justify-content: space-around;
        margin: 20px 0;
    }

    .action-item {
        background-color: #f0f4ff;
        padding: 15px 25px;
        border-radius: 12px;
        text-align: center;
        font-weight: 600;
        color: #2c3e50;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
        cursor: pointer;
        transition: all 0.3s ease;
        min-width: 160px;
    }

    .action-item:hover {
        background-color: #d0e2ff;
        transform: translateY(-3px);
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
    }

</style>

<div class="container-fluid">
    <div class="db-breadcrumb">
        <h4 class="breadcrumb-title">Quản lý Lịch học</h4>
        <ul class="db-breadcrumb-list">
            <li><a href="bang-dieu-khien"><i class="fa fa-home"></i>Bảng điều khiển</a></li>
            <li>Quản lý Lịch học</li>
        </ul>
    </div>

    <!-- Calendar Container -->
    <div class="calendar-container">
        <!-- Hiện ngày -->
        <div class="calendar-header">
            <div class="calendar-navigation d-flex">

                <!-- Nút prev -->
                <form action="quan-ly-lich-hoc" method="post" class="me-2">
                    <input type="hidden" name="dayLabel" value="${dayLabel}" />
                    <input type="hidden" name="view" value="${currentView}" />
                    <input type="hidden" name="direction" value="prev" />
                    <input type="hidden" name="roomSelected" value="${not empty roomSelected ? roomSelected : 'All'}">
                    <input type="hidden" name="teacherSelected" value="${not empty teacherSelected ? teacherSelected : 'All'}">
                    <button type="submit" class="btn btn-outline-secondary" id="prevBtn">
                        <i class="fa fa-chevron-left"></i>
                    </button>
                </form>

                <!-- Ngày hiện tại -->
                <fmt:formatDate var="dayLabelFormatted" value="${dayLabel}" pattern="'Ngày' d 'tháng' M 'năm' yyyy" />
                <span class="mx-3 h5" id="currentViewLabel">${dayLabelFormatted}</span>

                <!-- Nút next -->
                <form action="quan-ly-lich-hoc" method="post" class="ms-2">
                    <input type="hidden" name="dayLabel" value="${dayLabel}" />
                    <input type="hidden" name="view" value="${currentView}" />
                    <input type="hidden" name="direction" value="next" />
                    <input type="hidden" name="roomSelected" value="${not empty roomSelected ? roomSelected : 'All'}">
                    <input type="hidden" name="teacherSelected" value="${not empty teacherSelected ? teacherSelected : 'All'}">
                    <button type="submit" class="btn btn-outline-secondary" id="nextBtn">
                        <i class="fa fa-chevron-right"></i>
                    </button>
                </form>

                <!-- Nút hôm nay -->
                <form action="quan-ly-lich-hoc" method="post" class="ms-3">

                    <input type="hidden" name="dayLabel" value="<%= java.time.LocalDate.now().toString()%>" />
                    <input type="hidden" name="view" value="day" />
                    <input type="hidden" name="roomSelected" value="${not empty roomSelected ? roomSelected : 'All'}">
                    <input type="hidden" name="teacherSelected" value="${not empty teacherSelected ? teacherSelected : 'All'}">
                    <button type="submit" class="btn btn-outline-primary" id="todayBtn">Hôm nay</button>
                </form>
            </div>

            <div class="calendar-view-options">
                <div class="calendar-view-options">
                    <form action="quan-ly-lich-hoc" method="post" class="d-flex">
                        <input type="hidden" name="dayLabel" value="${dayLabel}" />
                        <input type="hidden" name="roomSelected" value="${not empty roomSelected ? roomSelected : 'All'}">
                        <input type="hidden" name="teacherSelected" value="${not empty teacherSelected ? teacherSelected : 'All'}">
                        <button class="btn btn-outline-secondary me-2 ${currentView == 'day' ? 'active' : ''}" name="view" value="day">Ngày</button>
                        <button class="btn btn-outline-secondary me-2 ${currentView == 'week' || currentView == null ? 'active' : ''}" name="view" value="week">Tuần</button>
                        <button class="btn btn-outline-secondary ${currentView == 'month' ? 'active' : ''}" name="view" value="month">Tháng</button>
                    </form>
                </div>
            </div>
        </div>


        <!-- Danh sách giáo viên , phòng , khóa học để lọc  -->
        <div class="calendar-filters">
            <form id="filterForm" class="row g-3" action="quan-ly-lich-hoc" method="post">
                <input type="hidden" name="dayLabel" value="${dayLabel}" />
                <input type="hidden" name="view" value="${currentView}" />
                <div class="col-md-3">
                    <label class="form-label">Giáo viên</label>
                    <select class="form-select" name="teacherSelected">
                        <option value="All" ${teacherSelected == null ? 'selected' : ''}>Tất cả giáo viên</option>
                        <c:forEach items="${teachers}" var="teacher">
                            <option value="${teacher.id}" 
                                    <c:if test="${teacher.id == teacherSelected}">selected</c:if>>
                                ${teacher.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Phòng học</label>
                    <select class="form-select" name="roomSelected">
                        <option value="All" ${roomSelected ==null ? 'selected' : ''}>Tất cả phòng học</option>
                        <c:forEach items="${rooms}" var="room">
                            <option value="${room.id}"
                                    <c:if test="${room.id == roomSelected}">selected</c:if>>${room.roomName}
                                    </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">Lọc</button>

                </div>
                <div class="col-md-6 d-flex align-items-end gap-2">
                    <button type="button" class="btn btn-warning w-50" data-bs-toggle="modal" data-bs-target="#changeScheduleModal">
                        Đổi lịch / Giáo viên
                    </button>
                </div>
            </form>
        </div>

        <!-- Lịch học -->
        <div class="calendar-body">
            <!-- Giao diện xem theo tuần -->
            <div id="weekView" class="calendar-view active">
                <div class="calendar-grid">
                    <!-- Tiêu đề các ngày trong tuần -->
                    <div class="calendar-day-header">Thứ Hai</div>
                    <div class="calendar-day-header">Thứ Ba</div>
                    <div class="calendar-day-header">Thứ Tư</div>
                    <div class="calendar-day-header">Thứ Năm</div>
                    <div class="calendar-day-header">Thứ Sáu</div>
                    <div class="calendar-day-header">Thứ Bảy</div>
                    <div class="calendar-day-header">Chủ Nhật</div>

                    <!-- Hiển thị từng ngày trong tuần -->
                    <c:forEach var="currentDate" items="${currentWeekDates}" varStatus="day">
                        <!-- Đánh dấu ngày hôm nay -->
                        <div class="calendar-day ${currentDate == today ? 'today' : ''}">
                            <!-- Hiển thị số ngày (2 chữ số cuối) -->
                            <div class="calendar-day-number">${fn:substring(currentDate, 8, 10)}</div>

                            <!-- Hiển thị các section đúng ngày -->
                            <c:forEach var="section" items="${sections}">
                                <c:if test="${section.dateFormatted == currentDate}">
                                    <c:set var="statusClass" value="" />
                                    <c:choose>
                                        <c:when test="${section.status == 'completed'}">
                                            <c:set var="statusClass" value="bg-success text-white" />
                                        </c:when>
                                        <c:when test="${section.status == 'active'}">
                                            <c:set var="statusClass" value="bg-primary text-white" />
                                        </c:when>
                                        <c:when test="${section.status == 'inactive'}">
                                            <c:set var="statusClass" value="bg-danger text-white" />
                                        </c:when>
                                    </c:choose>

                                    <div class="calendar-event ${statusClass}">
                                        <strong>${section.startTimeFormatted} - ${section.endTimeFormatted}</strong><br>
                                        P.${section.classroom}<br>
                                        <small>GV: ${section.teacherName}</small>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Giao diện xem theo ngày -->
            <div id="dayView" class="calendar-view" style="display: none;">
                <div class="time-slots-container">
                    <c:forEach begin="7" end="21" var="hour">
                        <div class="time-slot">
                            <div class="time-label">${hour}:00</div>
                            <div class="day-view-events">
                                <c:set var="displayedEvents" value="" />
                                <c:forEach var="section" items="${sections}">
                                    <c:if test="${section.dateFormatted == fn:substring(dayLabel, 0, 10)}">
                                        <c:set var="sectionHour" value="${fn:split(section.startTimeFormatted, ':')[0]}" />
                                        <c:if test="${sectionHour == hour}">
                                            <c:set var="eventIdentifier" value="${section.startTimeFormatted}_${section.endTimeFormatted}_${section.teacherName}" />
                                            <c:if test="${!fn:contains(displayedEvents, eventIdentifier)}">
                                                <c:set var="statusClass" value="" />
                                                <c:choose>
                                                    <c:when test="${section.status == 'completed'}">
                                                        <c:set var="statusClass" value="bg-success text-white" />
                                                    </c:when>
                                                    <c:when test="${section.status == 'active'}">
                                                        <c:set var="statusClass" value="bg-primary text-white" />
                                                    </c:when>
                                                    <c:when test="${section.status == 'inactive'}">
                                                        <c:set var="statusClass" value="bg-danger text-white" />
                                                    </c:when>
                                                </c:choose>

                                                <div class="calendar-event ${statusClass}">
                                                    <strong>${section.startTimeFormatted} - ${section.endTimeFormatted}</strong> |
                                                    ${section.courseName} - ${section.classroom} |
                                                    GV: ${section.teacherName}
                                                </div>
                                                <c:set var="displayedEvents" value="${displayedEvents},${eventIdentifier}" />
                                            </c:if>
                                        </c:if>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>


            <!-- Giao diện xem theo tháng -->
            <div id="monthView" class="calendar-view" style="display: none;">
                <div class="month-view-grid" id="monthGrid">
                    <!-- Tiêu đề các ngày trong tuần -->
                    <div class="calendar-day-header">Thứ Hai</div>
                    <div class="calendar-day-header">Thứ Ba</div>
                    <div class="calendar-day-header">Thứ Tư</div>
                    <div class="calendar-day-header">Thứ Năm</div>
                    <div class="calendar-day-header">Thứ Sáu</div>
                    <div class="calendar-day-header">Thứ Bảy</div>
                    <div class="calendar-day-header">Chủ Nhật</div>

                    <!-- Ô rỗng đầu tháng (firstDayOfMonth: 1=Thứ 2, ... 7=Chủ Nhật) -->
                    <c:forEach begin="1" end="${firstDayOfMonth - 1}" var="i">
                        <div class="month-view-day empty-day"></div>
                    </c:forEach>

                    <!-- Hiển thị các ngày trong tháng -->
                    <c:forEach begin="1" end="${daysInMonth}" var="day">
                        <!-- Tạo định dạng ngày yyyy-MM-dd -->
                        <c:set var="currentDate" value="${currentMonth}-${day < 10 ? '0' : ''}${day}" />

                        <div class="month-view-day ${currentDate == fn:substring(dayLabel, 0, 10) ? 'today' : ''}">
                            <div class="month-view-day-number">${day}</div>

                            <!-- Hiển thị sự kiện theo ngày -->
                            <c:forEach var="section" items="${sections}">
                                <c:if test="${section.dateFormatted == currentDate}">
                                    <c:set var="statusClass" value="" />
                                    <c:choose>
                                        <c:when test="${section.status == 'completed'}">
                                            <c:set var="statusClass" value="bg-success text-white" />
                                        </c:when>
                                        <c:when test="${section.status == 'active'}">
                                            <c:set var="statusClass" value="bg-primary text-white" />
                                        </c:when>
                                        <c:when test="${section.status == 'inactive'}">
                                            <c:set var="statusClass" value="bg-danger text-white" />
                                        </c:when>
                                    </c:choose>

                                    <div class="month-view-event ${statusClass}">
                                        <strong>${section.startTimeFormatted} - ${section.endTimeFormatted}</strong><br>
                                        P.${section.classroom}<br>
                                        <small>GV: ${section.teacherName}</small>
                                    </div>

                                </c:if>
                            </c:forEach>
                        </div>
                    </c:forEach>

                </div>
            </div>
        </div>

        <!-- Modal Đổi lịch -->
        <!-- Modal đổi lịch / giáo viên -->
        <div class="modal fade" id="changeScheduleModal" tabindex="-1" aria-labelledby="changeScheduleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">

                    <div class="modal-header">
                        <h5 class="modal-title" id="changeScheduleModalLabel">Đổi lịch học / giáo viên</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>

                    <form action="quan-ly-lich-hoc" method="post">
                        <div class="modal-body">

                            <!-- Chọn loại đổi -->
                            <div class="mb-3">
                                <label class="form-label fw-bold">Loại thay đổi:</label>
                                <select class="form-select" id="changeType" name="changeType">
                                    <option value="schedule">Đổi lịch học</option>
                                    <option value="teacher">Đổi giáo viên</option>
                                </select>
                            </div>

                            <!-- === ĐỔI LỊCH HỌC === -->
                            <div id="changeScheduleForm">
                                <div class="mb-3">
                                    <label class="form-label">Chọn giáo viên:</label>
                                    <select class="form-select" name="teacherId">
                                        <c:forEach items="${teachers}" var="teacher">
                                            <option value="${teacher.id}">${teacher.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Lịch muốn đổi:</label>
                                    <select class="form-select" name="originalScheduleId">
                                        <c:forEach items="${sections}" var="s">
                                            <option value="${s.id}">${s.classroom} - ${s.dayOfWeek} (${s.startTime} - ${s.endTime})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Lịch sẽ đổi sang:</label>
                                    <select class="form-select" name="targetScheduleId">
                                        <c:forEach items="${sections}" var="s">
                                            <option value="${s.id}">${s.classroom} - ${s.dayOfWeek} (${s.startTime} - ${s.endTime})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <!-- === ĐỔI GIÁO VIÊN === -->
                            <div id="changeTeacherForm" style="display: none;">
                                <div class="mb-3">
                                    <label class="form-label">Chọn lịch học:</label>
                                    <select class="form-select" name="scheduleId" id="teacherScheduleSelect" onchange="updateCurrentTeacher(this)">
                                        <c:forEach items="${sections}" var="s">
                                            <option value="${s.id}" data-teacher="${s.teacherId}">${s.classroom} - ${s.dayOfWeek} (${s.startTime} - ${s.endTime})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Giáo viên hiện tại:</label>
                                    <input type="text" class="form-control" id="currentTeacherDisplay" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Giáo viên thay thế:</label>
                                    <select class="form-select" name="newTeacherId">
                                        <c:forEach items="${teachers}" var="t">
                                            <option value="${t.id}">${t.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                        </div>

                        <div class="modal-footer">
                            <input type="hidden" name="action" value="change_request" />
                            <button type="submit" class="btn btn-success">Xác nhận thay đổi</button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>

    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            let currentView = '${currentView}'; // Giá trị do servlet set

            const weekView = document.getElementById('weekView');
            const dayView = document.getElementById('dayView');
            const monthView = document.getElementById('monthView');

            // Hàm chuyển view
            function updateCalendarView() {
                weekView.style.display = 'none';
                dayView.style.display = 'none';
                monthView.style.display = 'none';

                if (currentView === 'day') {
                    dayView.style.display = 'block';
                } else if (currentView === 'week') {
                    weekView.style.display = 'block';
                } else if (currentView === 'month') {
                    monthView.style.display = 'block';
                }
            }

            // Gọi cập nhật sau khi load
            updateCalendarView();

            // Xử lý hiển thị form khi chọn loại thay đổi
            document.getElementById("changeType").addEventListener("change", function () {
                const type = this.value;
                document.getElementById("changeScheduleForm").style.display = (type === "schedule") ? "block" : "none";
                document.getElementById("changeTeacherForm").style.display = (type === "teacher") ? "block" : "none";
            });

            // Gán giáo viên hiện tại vào ô readonly khi chọn lịch
            window.updateCurrentTeacher = function (selectEl) {
                const selectedOption = selectEl.options[selectEl.selectedIndex];
                const teacherId = selectedOption.getAttribute("data-teacher");
                document.getElementById("currentTeacherDisplay").value = teacherId;
            };
        });
    </script>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <jsp:include page="layout/footer.jsp" />