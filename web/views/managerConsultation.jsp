<%-- 
    Document   : managerConsultation
    Created on : Jun 26, 2025, 8:16:01 PM
    Author     : HanND
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* Mặc định nút trong btn-group trong suốt, chỉ có viền */
    .btn-group .btn {
        background-color: transparent;
        color: #333;
        border: 1px solid #ccc;
        transition: background-color 0.3s ease, color 0.3s ease;
    }

    /* Khi hover, nút mới đổi màu nền và màu chữ tương ứng */
    .btn-group .btn:hover {
        color: #fff;
    }

    .btn-info.btn-group .btn:hover,
    .btn-info:hover {
        background-color: #0dcaf0;
        border-color: #0dcaf0;
    }

    .btn-success.btn-group .btn:hover,
    .btn-success:hover {
        background-color: #198754;
        border-color: #198754;
    }

    .btn-primary.btn-group .btn:hover,
    .btn-primary:hover {
        background-color: #0d6efd;
        border-color: #0d6efd !important;
    }

    /* Tắt shadow mặc định của Bootstrap btn khi hover */
    .btn-group .btn:focus, .btn-group .btn:active {
        box-shadow: none !important;
    }

    /* Căn đều và căn giữa các cột */
    table thead th, table tbody td {
        text-align: center;
        vertical-align: middle;
    }

    /* Định nghĩa độ rộng các cột */
    table thead th:nth-child(1),
    table tbody td:nth-child(1) {
        width: 5%;
    }

    table thead th:nth-child(2),
    table tbody td:nth-child(2) {
        width: 25%;
        text-align: left;
        padding-left: 10px;
    }

    table thead th:nth-child(3),
    table tbody td:nth-child(3),
    table thead th:nth-child(4),
    table tbody td:nth-child(4),
    table thead th:nth-child(5),
    table tbody td:nth-child(5) {
        width: 15%;
    }

    table thead th:nth-child(6),
    table tbody td:nth-child(6) {
        width: 25%;
    }
</style>

<jsp:include page="layout/adminHeader.jsp" />

<div class="container mt-4">
    <h2 class="mb-4 text-center">Danh sách Tư vấn</h2>
    <form method="get" action="quan-ly-tu-van" class="row g-3 mb-4">
        <input type="hidden" name="action" value="list" />
        <div class="col-md-4">
            <input type="text" class="form-control" name="name" placeholder="VD:Nguyen Duc Han"
                   value="${param.name}" />
        </div>
        <div class="col-md-4">
            <select name="status" class="form-select">
                <option value="">-- Tất cả trạng thái --</option>
                <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                <option value="accepted" ${param.status == 'accepted' ? 'selected' : ''}>Đã duyệt</option>

            </select>
        </div>
        <div class="col-md-4">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-search"></i> Tìm kiếm
            </button>
        </div>
    </form>
    <table class="table table-striped table-bordered table-hover align-middle">
        <thead class="table-primary">
            <tr>
                <th>STT</th> 
                <th>Họ tên</th>
                <th>Ngày sinh</th>
                <th>Điện thoại</th>
                 <th>Email</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="consult" items="${consultations}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td> 
                    <td class="text-start">${consult.name}</td>
                    <td>${consult.dobString}</td>
                    <td>${consult.phone}</td>
                    <td>${consult.email}</td>
                    <td class="text-capitalize">
                        <c:choose>
                            <c:when test="${consult.status == 'pending'}">
                                <span class="badge bg-warning text-dark">Chờ xử lý</span>
                            </c:when>
                            <c:when test="${consult.status == 'accepted'}">
                                <span class="badge bg-success">Đã chấp nhận</span>
                            </c:when>
                            <c:when test="${consult.status == 'rejected'}">
                                <span class="badge bg-success">Từ chối</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Không xác định</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>
                        <div class="btn-group" role="group" aria-label="Actions">
                            <a href="quan-ly-tu-van?action=detail&id=${consult.id}" class="btn btn-info btn-sm" title="Xem chi tiết">
                                <i class="fas fa-eye"></i>
                            </a>
                            <c:if test="${consult.status == 'pending'}">
                                <a href="quan-ly-tu-van?action=approve&id=${consult.id}" class="btn btn-success btn-sm" title="Duyệt">
                                    <i class="fas fa-check"></i>
                                </a>
                            </c:if>
                            <a href="quan-ly-tu-van?action=create&id=${consult.id}" class="btn btn-primary btn-sm" title="Tạo tài khoản">
                                <i class="fas fa-user-plus"></i>
                            </a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty consultations}">
                <tr>
                    <td colspan="6" class="text-center text-danger">Không có kết quả phù hợp</td>
                </tr>
            </c:if>

        </tbody>
    </table>
    <c:if test="${not empty message}">
        <div class="alert alert-success text-center">${message}</div>
    </c:if>

</div>

<jsp:include page="layout/footer.jsp" />
