<%-- 
    Document   : classBeingTaught
    Created on : Jun 20, 2025, 11:35:41 PM
    Author     : vankh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<jsp:include page="layout/header.jsp" />

<style>
    .container-wrapper {
        background-color: #f4f6f9;
        padding: 40px 0;
        min-height: 100vh;
    }

    .grid-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
        gap: 30px;
        padding: 20px;
        justify-content: center;
    }

    .info-card {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        padding: 20px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
        transition: all 0.3s ease-in-out;
        font-size: 14px;
        height: 100%;
        border: 1px solid #e0e0e0;
    }

    .info-card:hover {
        transform: translateY(-5px) scale(1.02);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        background-color: #ffffff;
    }

    .info-item {
        margin-bottom: 10px;
    }

    .info-label {
        font-weight: 600;
        display: inline-block;
        width: 110px;
        color: #333;
    }

    .info-value {
        display: inline-block;
        color: #555;
    }

    button[type="submit"] {
        all: unset;
        cursor: pointer;
        display: block;
        width: 100%;
        height: 100%;
    }

    .text-center {
        text-align: center;
    }

    .wc-title h4 {
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 20px;
    }

    .no-class-msg {
        text-align: center;
        color: red;
        font-size: 16px;
        margin-top: 20px;
    }
</style>

<div class="container-wrapper">
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="widget-box">
                    <div class="wc-title">
                        <h4 class="text-center">Khóa học đang dạy</h4>
                    </div>
                    <div class="widget-inner">
                        <div class="grid-container">
                            <c:if test="${empty listClass}">
                                <div class="no-class-msg">Không có lớp nào đang dạy.</div>
                            </c:if>

                            <c:forEach var="c" items="${listClass}">
                                <form action="createScore" method="get">
                                    <input type="hidden" name="courseId" value="${c.getCourseId()}">
                                    <input type="hidden" name="grade" value="${c.grade}">
                                    <input type="hidden" name="name" value="${c.name}">
                                    <input type="hidden" name="level" value="${c.level}">
                                    <input type="hidden" name="subject" value="${c.subject}">
                                    <input type="hidden" name="studentEnrollment" value="${c.studentEnrollment}">
                                    <button type="submit">
                                        <div class="info-card">
                                            <div class="info-item"><span class="info-label">Lớp:</span><span class="info-value">${c.grade}</span></div>
                                            <div class="info-item"><span class="info-label">Tên khóa học:</span><span class="info-value">${c.name}</span></div>
                                            <div class="info-item">
                                                <span class="info-label">Cấp độ:</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${c.level == 'Advanced'}">Nâng cao</c:when>
                                                        <c:when test="${c.level == 'Basic'}">Cơ bản</c:when>
                                                        <c:when test="${c.level == 'Topics_Exam'}">Luyện thi</c:when>
                                                        <c:otherwise>${c.level}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Môn:</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${c.subject == 'Mathematics'}">Toán</c:when>
                                                        <c:when test="${c.subject == 'Literature'}">Ngữ văn</c:when>
                                                        <c:when test="${c.subject == 'English'}">Tiếng Anh</c:when>
                                                        <c:when test="${c.subject == 'Physics'}">Vật lý</c:when>
                                                        <c:when test="${c.subject == 'Chemistry'}">Hóa học</c:when>
                                                        <c:when test="${c.subject == 'Biology'}">Sinh học</c:when>
                                                        <c:when test="${c.subject == 'History'}">Lịch sử</c:when>
                                                        <c:when test="${c.subject == 'Geography'}">Địa lý</c:when>
                                                        <c:when test="${c.subject == 'Civic Education'}">Giáo dục công dân</c:when>
                                                        <c:when test="${c.subject == 'Informatics'}">Tin học</c:when>
                                                        <c:otherwise>${c.subject}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>

                                            <div class="info-item"><span class="info-label">Số học sinh:</span><span class="info-value">${c.studentEnrollment}</span></div>
                                        </div>
                                    </button>
                                </form>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
