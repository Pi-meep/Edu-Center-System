<%-- 
    Document   : attendance_mark
    Created on : Jun 26, 2025, 1:11:17 AM
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Điểm Danh Của Tôi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .status-present {
                color: #28a745;
                font-weight: bold;
            }
            .status-absent {
                color: #dc3545;
                font-weight: bold;
            }
            .card-hover:hover {
                background-color: #f8f9fa;
            }
        </style>
    </head>
    <jsp:include page="layout/header.jsp" />
    <body class="bg-light">
        <div class="container py-4">
            <h2 class="mb-4"><i class="fas fa-user-check me-2"></i>Điểm Danh Của Tôi</h2>

            <c:if test="${not empty studentName}">
                <p class="mb-4">Học sinh: <strong>${studentName}</strong></p>
            </c:if>


            <form method="get" class="mb-4">
                <div class="row g-2 align-items-center">
                    <div class="col-auto">
                        <label for="courseId" class="col-form-label">Chọn khóa học:</label>
                    </div>
                    <div class="col-auto">
                        <select name="courseId" id="courseId" class="form-select" onchange="this.form.submit()">
                            <!-- Thêm option mặc định -->
                            <option value="">-- Chọn khóa học --</option>

                            <c:if test="${not empty studentCourses}">
                                <c:forEach var="course" items="${studentCourses}">
                                    <option value="${course.id}" ${course.id == selectedCourseId ? 'selected' : ''}>
                                        ${course.name}
                                    </option>
                                </c:forEach>
                            </c:if>

                            <!-- Hiển thị thông báo nếu không có khóa học -->
                            <c:if test="${empty studentCourses}">
                                <option disabled>Không có khóa học nào</option>
                            </c:if>
                        </select>
                    </div>
                </div>
            </form>


            <!-- Bảng điểm danh -->
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-calendar-day me-2"></i>Danh Sách Buổi Học & Trạng Thái</h5>
                </div>
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty attendanceDetails}">
                            <div class="p-4 text-center text-muted">
                                <i class="fas fa-exclamation-circle fa-2x mb-2"></i><br>
                                Không có dữ liệu điểm danh cho khóa học này.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>STT</th>
                                            <th>Ngày học</th>
                                            <th>Thời gian</th>
                                            <th>Phòng học</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="record" items="${attendanceDetails}" varStatus="status">
                                            <c:set var="section" value="${sectionMap[record.sectionId]}" />
                                            <tr class="card-hover">
                                                <td>${status.index + 1}</td>
                                                <td>${section.formattedDate}</td>
                                                <td>${section.formattedStartTime} - ${section.formattedEndTime}</td>
                                                <td>${section.classroom}</td>
                                                <td>
                                                    <span class="${record.attendanceStatus ? 'status-present' : 'status-absent'}">
                                                        ${record.attendanceStatus ? 'Có mặt' : 'Vắng mặt'}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </body>
</html>
