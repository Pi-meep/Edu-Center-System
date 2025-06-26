<%-- 
    Document   : course-details
    Created on : May 28, 2025, 9:15:08 PM
    Author     : hungd
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<% request.setAttribute("title", "Thông tin lớp học");%>
<jsp:include page="layout/header.jsp" />

<style>
    .course-page {
        font-family: 'Segoe UI', sans-serif;
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
        background-color: #fff;
    }

    .course-top {
        display: flex;
        gap: 20px;
        margin-bottom: 30px;
    }

    .course-left {
        flex: 2;
    }

    .course-left img {
        width: 100%;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    .teacher-info {
        margin-top: 10px;
        font-weight: bold;
        color: #333;
    }

    .course-right {
        flex: 1;
        background-color: #f9f9f9;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    }

    .course-price {
        font-size: 20px;
        margin-bottom: 10px;
        color: #e53935;
        font-weight: bold;
    }

    .register-button {
        display: block;
        width: 100%;
        padding: 12px;
        background-color: #1976d2;
        color: white;
        font-size: 16px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        margin-bottom: 20px;
        transition: background-color 0.3s;
    }

    .register-button:hover {
        background-color: #1565c0;
    }

    .course-meta-label {
        font-weight: bold;
        color: #333;
        margin-top: 20px;
        display: block;
    }

    .course-details-list {
        list-style: disc;
        padding-left: 20px;
        margin-top: 5px;
    }

    /* Bottom Section */
    .course-bottom {
        display: flex;
        gap: 20px;
        margin-top: 30px;
    }

    .course-main-tabs {
        flex: 3;
    }

    .course-tab {
        background-color: #fdfdfd;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 20px;
        box-shadow: 0 1px 5px rgba(0, 0, 0, 0.05);
    }

    .course-tab h3 {
        color: #1976d2;
        margin-bottom: 10px;
    }

    .related-courses {
        flex: 1;
    }

    .related-courses h4 {
        margin-bottom: 15px;
        color: #444;
    }

    .related-course-card {
        background-color: #f5f5f5;
        padding: 10px;
        border-radius: 6px;
        margin-bottom: 15px;
        text-align: center;
        box-shadow: 0 1px 4px rgba(0,0,0,0.05);
    }

    .related-course-card img {
        max-width: 100%;
        height: auto;
        border-radius: 4px;
        margin-bottom: 8px;
    }
</style>

<c:choose>
    <c:when test="${not empty sessionScope.course}">
        <c:set var="course" value="${sessionScope.course}" />
        <c:set var="teacherMap" value="${sessionScope.teacherMap}" />
        <c:set var="teacher" value="${teacherMap[course.teacherId]}" />

        <%-- Tính toán giá dựa theo loại khóa học --%>
        <c:choose>
            <c:when test="${course.courseType eq 'daily'}">
                <c:set var="originalPrice" value="${course.feeDaily}" />
            </c:when>

            <c:when test="${course.courseType eq 'combo'}">
                <c:set var="originalPrice" value="${course.feeCombo * course.weekAmount}" />
            </c:when>

            <c:otherwise>
                <c:set var="originalPrice" value="0" />
            </c:otherwise>
        </c:choose>

        <%-- Tính giảm giá (nếu có) --%>
        <c:set var="discountAmount" value="${originalPrice * (course.discountPercentage / 100)}" />
        <c:set var="finalPrice" value="${originalPrice - discountAmount}" />
        <c:set var="hasDiscount" value="${course.discountPercentage > 0}" />

        <%-- Format số tiền --%>
        <fmt:formatNumber var="originalPriceStr" value="${originalPrice}" type="currency" currencySymbol="₫" />
        <fmt:formatNumber var="finalPriceStr" value="${finalPrice}" type="currency" currencySymbol="₫" />

        <div class="body course-details-page">
            <div class="body-container">

                <!-- Breadcrumb -->
                <div class="course-details-breadcrumb">
                    <a href="danh-sach-lop">Trang chủ</a> &gt;
                    <a href="tim-kiem?grade=${course.grade}">Lớp ${course.grade}</a> &gt;
                    <span>${course.name}</span>
                </div>

                <!-- Nội dung 2 cột -->
                <div class="course-details-content">
                    <!-- Bên trái -->
                    <div class="course-details-left">
                        <div class="course-details-header">${course.name}</div>
                        <p>
                            Môn học: <strong>${course.subject}</strong> |
                            Giáo viên: 
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty teacher}">
                                        ${teacher.name}
                                    </c:when>
                                    <c:otherwise>Đang cập nhật</c:otherwise>
                                </c:choose>
                            </strong>
                        </p>

                        <h3>Mô tả khóa học</h3>
                        <p>${course.description}</p>

                        <h4>Thông tin chi tiết</h4>
                        <ul>
                            <li>Thời lượng: ${course.weekAmount} tuần</li>
                            <li>Số học viên tối đa: ${course.maxStudents} người</li>
                            <li>Học viên hiện tại: ${course.studentEnrollment} người</li>
                        </ul>

                        <p class="course-details-warning">
                            Vui lòng không chia sẻ tài khoản. Tài khoản vi phạm sẽ bị khóa vĩnh viễn.
                        </p>
                    </div>

                    <!-- Bên phải -->
                    <div class="course-details-right">
                        <p><strong>Học phí chỉ với:</strong></p>
                        <c:choose>
                            <c:when test="${hasDiscount}">
                                <div class="course-details-price-block">
                                    <div class="course-details-original-price"><del>${originalPriceStr}</del></div>
                                    <div class="course-details-final-price">${finalPriceStr}</div>
                                    <p class="course-details-saving">Tiết kiệm ${course.discountPercentage}%</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="course-details-final-price">${originalPriceStr}</div>
                            </c:otherwise>
                        </c:choose>
                        <button class="course-details-btn-register">Đăng ký ngay</button>
                    </div>
                </div>

                <!-- Tab thông tin thêm -->
                <div class="course-details-more-info">
                    <div class="course-details-left">
                        <div class="course-details-tab-content" id="courseSyllabus">
                            <h3 class="course-details-section-heading">Thông tin về khóa học</h3>
                            <p class="course-details-section-paragraph">Nội dung đề cương khóa học sẽ được cập nhật sau.</p>
                        </div>
                        <div class="course-details-tab-content" id="freeLectures">
                            <h3 class="course-details-section-heading">Lịch học</h3>
                            <p class="course-details-section-paragraph">Chưa có bài giảng miễn phí tại thời điểm hiện tại.</p>
                        </div>
                        <div class="course-details-tab-content" id="teachers">
                            <h3 class="course-details-section-heading">Giáo viên giảng dạy</h3>
                            <p class="course-details-section-paragraph">
                                <c:choose>
                                    <c:when test="${not empty teacher}">
                                        Giáo viên: ${teacher.name}
                                    </c:when>
                                    <c:otherwise>Thông tin đang được cập nhật.</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="body">
            <div class="body-container">
                <h2>Không tìm thấy thông tin khóa học.</h2>
            </div>
        </div>
    </c:otherwise>
</c:choose>
