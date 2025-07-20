<%-- 
    Document   : studentAssignments
    Created on : Jul 17, 2025, 6:35:44 PM
    Author     : HanND
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="layout/header.jsp" />

<style>
    body {
        font-family: 'Segoe UI', sans-serif;
        background-color: #f3f4f6;
        margin: 0;
        padding: 0;
    }

    .assignment-wrapper {
        max-width: 900px;
        margin: 50px auto;
        padding: 20px;
    }

    .assignment-list {
        background-color: #ffffff;
        border-radius: 10px;
        padding: 24px 28px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.06);
    }

    h2 {
        text-align: center;
        color: #2d3748;
        margin-bottom: 20px;
        font-size: 26px;
    }

    .assignment-description {
        color: #4a5568;
        font-size: 15px;
        margin-bottom: 20px;
        white-space: pre-line;
        text-align: center;
    }

    .assignment-item {
        border-top: 1px solid #e2e8f0;
        padding: 14px 0;
    }

    .assignment-item:first-child {
        border-top: none;
    }

    .assignment-title {
        font-weight: 600;
        font-size: 16px;
        color: #1a202c;
    }

    .assignment-description-detail {
        color: #4a5568;
        font-size: 14px;
        margin-top: 6px;
    }

    .assignment-link {
        display: inline-block;
        margin-top: 6px;
        font-size: 13px;
        color: #3182ce;
        text-decoration: none;
    }

    .assignment-link:hover {
        text-decoration: underline;
    }

    .assignment-meta {
        color: #718096;
        font-size: 13px;
        margin-top: 4px;
    }

    .btn-secondary {
        background-color: #4a5568;
        color: white;
        padding: 8px 16px;
        border: none;
        border-radius: 6px;
        font-size: 14px;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        transition: 0.3s;
    }

    .btn-secondary:hover {
        background-color: #2d3748;
    }

    .back-container {
        margin-top: 30px;
        text-align: right;
    }

    .no-assignment {
        text-align: center;
        color: gray;
        font-style: italic;
        margin-top: 20px;
    }
</style>

<div class="assignment-wrapper">
    <div class="assignment-list">
        <h2>📘 Bài tập cho khóa học: <c:out value="${course.name}" /></h2>

        <c:if test="${not empty course.description}">
            <div class="assignment-description">
                <c:out value="${course.description}" />
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty assignments}">
                <p class="no-assignment">Hiện chưa có bài tập nào cho khóa học này.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="a" items="${assignments}">
                    <div class="assignment-item">
                        <div class="assignment-title">📄 <c:out value="${a.title}" /></div>
                        <div class="assignment-description-detail">
                            <c:choose>
                                <c:when test="${not empty a.description}">
                                    <c:out value="${a.description}" />
                                </c:when>
                                <c:otherwise><em>Không có mô tả</em></c:otherwise>
                            </c:choose>
                        </div>
                        <c:if test="${not empty a.filePath}">
                            <a href="${pageContext.request.contextPath}/studentAssignmentServlet?action=download&assignmentId=${a.id}" class="assignment-link" target="_blank">
                                📎 Tải xuống tệp đính kèm
                            </a>
                        </c:if>
                        <div class="assignment-meta">
                            🕒 Ngày đăng: <fmt:formatDate value="${a.uploadedAt}" pattern="dd/MM/yyyy HH:mm" />
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <div class="back-container">
            <a href="${pageContext.request.contextPath}/studentAssignmentServlet" class="btn-secondary">← Quay lại danh sách khóa học</a>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />
