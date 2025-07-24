   Author     : HanND
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="layout/header.jsp" />

<style>
    body {
        background-color: #f8f9fa;
        padding-top: 30px;
    }

    .container {
        margin-top: 80px;
    }

    .card {
        border-radius: 12px;
        border: 1px solid #dee2e6;
        transition: transform 0.2s;
    }

    .card:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
    }

    .card-title {
        color: #212529;
        font-weight: 600;
    }

    .form-label {
        font-size: 0.9rem;
        color: #495057;
    }

    .btn-success {
        padding: 6px 14px;
        font-size: 0.9rem;
    }

    .btn-back {
        margin-bottom: 25px;
        background-color: #6c757d;
        border: none;
        color: white;
        font-size: 0.9rem;
        padding: 6px 12px;
        border-radius: 6px;
        transition: background-color 0.2s ease;
        text-decoration: none;
    }

    .btn-back:hover {
        background-color: #5a6268;
        text-decoration: none;
    }

    a.link-primary {
        font-size: 0.9rem;
        text-decoration: underline;
    }
</style>

<div class="container mt-4 mb-5">
    <h2 class="text-primary mb-4">📚 Bài tập đã nộp - <c:out value="${course.name}" /></h2>

    <c:forEach var="sub" items="${submissions}">
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h5 class="card-title">👩‍🎓 <c:out value="${sub.studentName}" /></h5>
                <p class="card-text mb-1">📝 <strong>Bài tập:</strong> <c:out value="${sub.assignmentTitle}" /></p>
                <p class="card-text mb-1">🕒 <strong>Ngày nộp:</strong> 
                    <fmt:formatDate value="${sub.submittedAt}" pattern="dd-MM-yyyy HH:mm" />
                </p>
                <p class="card-text">📎 
                    <a href="${pageContext.request.contextPath}/submissions/${sub.filePath}" 
                       class="link-primary" download>Tải bài nộp</a>
                </p>

                <form action="viewSubmissionsServlet" method="post" class="row gy-2 gx-3 align-items-center mt-3">
                    <input type="hidden" name="submissionId" value="${sub.id}" />
                    <input type="hidden" name="courseId" value="${course.id}" />

                    <div class="col-auto">
                        <label class="form-label mb-0">Điểm:</label>
                        <input type="number" name="grade" step="0.1" min="0" max="10"
                               value="${sub.grade != null ? sub.grade : ''}"
                               class="form-control form-control-sm" placeholder="0 - 10" />
                    </div>

                    <div class="col-auto">
                        <label class="form-label mb-0">Nhận xét:</label>
                        <input type="text" name="comment"
                               value="${sub.comment != null ? sub.comment : ''}"
                               class="form-control form-control-sm" placeholder="Ghi chú"/>
                    </div>

                    <div class="col-auto mt-3">
                        <button type="submit" class="btn btn-success btn-sm">💯 Chấm điểm</button>
                    </div>
                </form>
            </div>
        </div>
    </c:forEach>
    <a href="classBeingTaught" class="btn-back">← Quay lại khóa học</a>
</div>

<jsp:include page="layout/footer.jsp" />
