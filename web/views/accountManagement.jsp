<%-- 
    Document   : accountManagement
    Created on : Jul 21, 2025, 10:42:16 PM
    Author     : vankh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="layout/adminHeader.jsp" />

<style>
    .status-active {
        background-color: #28a745;
        color: white;
        padding: 5px 10px;
        border-radius: 20px;
        font-weight: 500;
        display: inline-block;
    }

    .status-inactive {
        background-color: #6c757d;
        color: white;
        padding: 5px 10px;
        border-radius: 20px;
        font-weight: 500;
        display: inline-block;
    }

    .action-buttons .btn {
        padding: 5px 10px;
        margin: 0 2px;
        font-size: 14px;
    }

    .table-responsive {
        margin-top: 20px;
    }

    .search-filter {
        background: #f9f9f9;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 20px;
    }

    .role-staff {
        background-color: #a0ad26;
        color: white;
        padding: 3px 8px;
        border-radius: 4px;
    }

    .role-teacher {
        background-color: #1693a7;
        color: white;
        padding: 3px 8px;
        border-radius: 4px;
    }

    .role-parent {
        background-color: #941cac;
        color: white;
        padding: 3px 8px;
        border-radius: 4px;
    }

    .role-student {
        background-color: #188618;
        color: white;
        padding: 3px 8px;
        border-radius: 4px;
    }

    .add-account-btn {
        margin-bottom: 20px;

    }

    #pagination-controls button {
        margin: 0 4px;
        padding: 6px 12px;
        border: none;
        background-color: #007bff;
        color: white;
        border-radius: 4px;
        cursor: pointer;
        margin-bottom: 5px;
    }
    #pagination-controls button.active {
        background-color: #0056b3;
        font-weight: bold;
    }


</style>

<div class="container-fluid">
<!--    <div class="db-breadcrumb">
        <h4 class="breadcrumb-title">Quản lý Tài khoản</h4>
        <ul class="db-breadcrumb-list">
            <li><a href="bang-dieu-khien"><i class="fa fa-home"></i>Bảng điều khiển</a></li>
            <li>Quản lý Tài khoản</li>
        </ul>
    </div>-->

    <!-- Search and Filter Section -->
    <div class="search-filter">
        <form class="row g-3" method="get" action="quan-ly-tai-khoan">
            <!--            <input type="hidden" name="action" value="filter" >-->
            <div class="col-md-4">
                <label class="form-label">Tìm kiếm</label>
                <input type="text" class="form-control" name="searchKeyword" placeholder="Họ tên, tài khoản..." value="${param.searchKeyword}">
            </div>
            <div class="col-md-3">
                <label class="form-label">Trạng thái</label>
                <select class="form-select" name="statusFilter">
                    <option value="all" ${statusFilter == 'all' ? 'selected' : ''}>Tất cả</option>
                    <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Hoạt động</option>
                    <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label">Chức vụ</label>
                <select class="form-select" name="roleFilter">
                    <option value="all" ${roleFilter == 'all' ? 'selected' : ''}>Tất cả</option>
                    <option value="staff" ${roleFilter == 'staff' ? 'selected' : ''}>Nhân viên tư vấn </option>
                    <option value="teacher" ${roleFilter == 'teacher' ? 'selected' : ''}>Giáo viên</option>
                    <option value="student" ${roleFilter == 'student' ? 'selected' : ''}>Học viên</option>
                </select>
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">Lọc</button>
            </div>
        </form>
    </div>


    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
        <div>
            <button type="button" class="btn btn-success add-account-btn" data-bs-toggle="modal" data-bs-target="#addAccountModal">
                <i class="fas fa-plus"></i> Thêm tài khoản mới
            </button>
        </div>

        <div style="margin-right: 100px; min-width: 300px; text-align: right;">

            <c:choose>
                <c:when  test="${succes!=null}">
                    <div class="alert-success-box">
                        ${succes}
                    </div>
                </c:when>
                <c:when  test="${error!=null}">

                    <div class="alert-error-box">
                        ${error}
                    </div>
                </c:when>
            </c:choose>
        </div>
    </div>



    <!-- Accounts Table -->
    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead class="table-dark">
                <tr>
                    <th>STT</th>
                    <th>Họ và tên</th>
                    <th>Tên tài khoản</th>
                    <th>Số điện thoại</th>
                    <th>Địa chỉ</th>
                    <th>Trạng thái</th>
                    <th>Chức vụ</th>
                    <th>Hoạt động</th>
                </tr>
            </thead>
            <tbody id="account-table-body">
                <c:forEach var="account" items="${accounts}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>${account.name}</td>
                        <td>${account.username}</td>
                        <td>${account.phone}</td>
                        <td>${account.address}</td>
                        <td>
                            <a href="quan-ly-tai-khoan?accountId=${account.id}&status=${account.status}&action=changeStatus&roleFilter=${roleFilter}&statusFilter=${statusFilter}"
                               class="btn btn-sm ${account.status == 'active' ? 'btn-success' : 'btn-secondary'}"
                               title="Nhấn để đổi trạng thái">
                                ${account.status == 'active' ? 'Hoạt động' : 'Không hoạt động'}
                            </a>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${account.role == 'teacher'}">
                                    <span class="role-teacher">Giáo viên</span>
                                </c:when>
                                <c:when test="${account.role == 'staff'}">
                                    <span class="role-staff">Nhân viên tư vấn</span>
                                </c:when>
                                <c:when test="${account.role == 'parent'}">
                                    <span class="role-parent">Phụ huynh</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="role-student">Học viên</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="action-buttons">
                            <a href="quan-ly-tai-khoan?accountId=${account.id}&action=delete&roleFilter=${roleFilter}&statusFilter=${statusFilter}" 
                               class="btn btn-danger btn-sm" title="Xóa tài khoản">
                                <i class="fas fa-trash"></i>
                            </a>
                            <a href="quan-ly-tai-khoan?accountId=${account.id}&action=reset&roleFilter=${roleFilter}&statusFilter=${statusFilter}" 
                               class="btn btn-warning btn-sm" title="Đặt lại mật khẩu">
                                <i class="fas fa-key"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table> 
        </table> 
        <div id="pagination-controls" class="mt-3 text-center"></div>

    </div>
</div>

<script>
    function confirmDelete(accountId) {
        document.getElementById('deleteAccountId').value = accountId;
        $('#deleteConfirmModal').modal('show');
    }

    function resetPassword(accountId) {
        document.getElementById('resetPasswordAccountId').value = accountId;
        $('#resetPasswordModal').modal('show');
    }

    const rowsPerPage = 10;
    const tableBody = document.getElementById("account-table-body");
    const rows = tableBody.getElementsByTagName("tr");
    const paginationControls = document.getElementById("pagination-controls");

    let currentPage = 1;
    const totalPages = Math.ceil(rows.length / rowsPerPage);

    function showPage(page) {
        currentPage = page;
        for (let i = 0; i < rows.length; i++) {
            rows[i].style.display = (i >= (page - 1) * rowsPerPage && i < page * rowsPerPage) ? "" : "none";
        }
        renderPagination();
    }

    function renderPagination() {
        paginationControls.innerHTML = "";
        for (let i = 1; i <= totalPages; i++) {
            const btn = document.createElement("button");
            btn.textContent = i;
            btn.className = (i === currentPage) ? "active" : "";
            btn.onclick = () => showPage(i);
            paginationControls.appendChild(btn);
        }
    }

    // Hiển thị trang đầu tiên khi tải xong
    showPage(1);

//    function editAccount(accountId) {
//        // Lấy thông tin tài khoản từ server (giả lập)
//        // Trong thực tế, bạn sẽ gọi AJAX để lấy thông tin chi tiết
//        fetch('quan-ly-tai-khoan?action=get_account&accountId=' + accountId)
//                .then(response => response.json())
//                .then(data => {
//                    document.getElementById('editAccountId').value = data.id;
//                    document.getElementById('editFullName').value = data.fullName;
//                    document.getElementById('editUsername').value = data.username;
//                    document.getElementById('editPhone').value = data.phone;
//                    document.getElementById('editAddress').value = data.address;
//                    document.getElementById('editRole').value = data.role;
//                    document.getElementById('editStatus').value = data.status;
//
//                    $('#editAccountModal').modal('show');
//                })
//                .catch(error => {
//                    console.error('Error:', error);
//                    alert('Không thể tải thông tin tài khoản');
//                });
//    }
</script>

<jsp:include page="layout/footer.jsp" />
