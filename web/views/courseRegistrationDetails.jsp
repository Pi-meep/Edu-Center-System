<%-- 
    Document   : courseRegistrationDetails
    Created on : Jul 6, 2025, 2:45:04 PM
    Author     : hungd
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="layout/adminHeader.jsp" />

<style>
    .table-hover tbody tr:hover {
        background-color: #f9f9f9;
    }

    .table th, .table td {
        vertical-align: middle;
    }

    .card-header.bg-primary {
        background-color: #ffffff !important;
        color: #212529;
        border-bottom: 1px solid #dee2e6;
    }

    .card-header h5 i {
        color: #0d6efd;
    }

    .card-body {
        background-color: #ffffff;
    }

    .badge-count {
        padding: 0.5em 1em;
        font-size: 1rem;
    }

    .btn-action {
        transition: 0.2s ease;
        opacity: 0.7;
    }

    tr:hover .btn-action {
        opacity: 1;
        box-shadow: 0 0 4px rgba(0, 0, 0, 0.15);
    }

    .course-info {
        font-size: 0.9rem;
        color: #555;
    }

    .course-info strong {
        font-weight: 500;
        color: #333;
    }
</style>

<!-- THÔNG TIN KHÓA HỌC -->
<div class="card border-0 shadow-sm mt-4 mb-3">
    <div class="card-body course-info">
        <h6 class="fw-bold text-dark mb-3">${course.name}</h6>
        <div class="row g-3">
            <div class="col-md-4"><strong>Giáo viên:</strong> ${course.teacherName}</div>
            <div class="col-md-4"><strong>Môn học:</strong> ${course.subjectDisplayName}</div>
            <div class="col-md-4"><strong>Khối:</strong> ${course.grade}</div>
            <div class="col-md-4"><strong>Trình độ:</strong> ${course.levelDisplayName}</div>
            <div class="col-md-4">
                <strong>Thời gian:</strong> 
                <fmt:formatDate value="${course.startDate}" pattern="dd/MM/yyyy" />
                –
                <fmt:formatDate value="${course.endDate}" pattern="dd/MM/yyyy" />
            </div>
            <div class="col-md-4"><strong>Sĩ số:</strong> ${course.studentEnrollment} / ${course.maxStudents}</div>
            <div class="col-md-4">
                <strong>Học phí:</strong>
                <c:choose>
                    <c:when test="${course.feeCombo != null}">
                        <fmt:formatNumber value="${course.feeCombo}" type="number" groupingUsed="true" /> ₫ (Gói)
                    </c:when>
                    <c:when test="${course.feeDaily != null}">
                        <fmt:formatNumber value="${course.feeDaily}" type="number" groupingUsed="true" /> ₫/ngày
                    </c:when>
                    <c:otherwise>N/A</c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- DANH SÁCH YÊU CẦU -->
<div class="card shadow-sm border-0">
    <div class="card-header bg-white d-flex justify-content-between align-items-center">
        <h5 class="mb-0 fw-semibold text-dark">
            <i class="fas fa-user-clock me-2 text-primary"></i> Danh sách yêu cầu tham gia
        </h5>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-bordered table-hover align-middle text-center bg-white rounded">
            <thead class="table-light">
                <tr>
                    <th>STT</th>
                    <th>Học sinh</th>
                    <th>Ngày đăng ký</th>
                    <th>Trạng thái hợp lệ</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="request" items="${requestList}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td class="text-start fw-semibold">${request.studentName}</td>
                        <td>
                <fmt:formatDate value="${request.enrollmentDate}" pattern="dd/MM/yyyy HH:mm" />
                </td>
                <td>
                    <c:choose>
                        <c:when test="${request.validStatus eq 'valid'}">
                            <span class="badge bg-success">Hợp lệ</span>
                        </c:when>
                        <c:when test="${request.validStatus eq 'invalid_fees'}">
                            <span class="badge bg-danger">Nợ học phí</span>
                        </c:when>
                        <c:when test="${request.validStatus eq 'invalid_schedule'}">
                            <span class="badge bg-warning text-dark">Trùng lịch</span>
                        </c:when>
                        <c:when test="${request.validStatus eq 'invalid_full'}">
                            <span class="badge bg-secondary">Lớp đầy</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-light text-dark">Không xác định</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <form method="post" action="xet-yeu-cau">
                        <input type="hidden" name="requestId" value="${request.id}" />
                        <button name="action" value="accept" class="btn btn-sm btn-success btn-action me-1" title="Chấp nhận">
                            <i class="fas fa-check"></i>
                        </button>
                        <button name="action" value="reject" class="btn btn-sm btn-danger btn-action" title="Từ chối">
                            <i class="fas fa-times"></i>
                        </button>
                    </form>
                </td>
                </tr>
            </c:forEach>
            <c:if test="${empty requestList}">
                <tr>
                    <td colspan="5" class="text-center text-muted">Không có yêu cầu nào chờ duyệt.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />
