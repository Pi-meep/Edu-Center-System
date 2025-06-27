<%-- 
    Document   : userProfile
    Created on : Jun 25, 2025, 11:32:11 AM
    Author     : vankh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<%
    String role = (String) request.getAttribute("loggedInUserRole");
    request.setAttribute("role", role);
    String name = (String) request.getAttribute("loggedInUserName");
    request.setAttribute("userName", name);
%> 

<c:choose>
    <c:when test="${role=='student' or role == 'parent' or role=='teacher'}">
        <jsp:include page="layout/header.jsp" />
    </c:when>
    <c:otherwise>
        <jsp:include page="layout/adminHeader.jsp" />
    </c:otherwise>
</c:choose>

<div class="container-fluid">
    <c:if test="${role != 'student' and role!= 'parent' and role !='teacher'}">
        <div class="db-breadcrumb">
            <h4 class="breadcrumb-title">Thông tin cá nhân</h4>
            <ul class="db-breadcrumb-list">
                <li><a href="bang-dieu-khien"><i class="fa fa-home"></i>Bảng điều khiển</a></li>
                <li>Thông tin cá nhân</li>
            </ul>
        </div>
    </c:if>

    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10 m-b30">
            <div class="widget-box form-wrapper">
                <div class="wc-title">
                    <h4>Thông tin cá nhân</h4>
                </div>
                <div class="widget-inner">
                    <div class="edit-profile">
                        <c:if test="${role != 'admin'}">
                            <div class="row">
                                <div class="col-12">
                                    <div class="profile-pic text-center mb-4">
                                        <c:set var="avatarPath" value="${empty admin.avatarUrl ? '/assets/ava.png' : admin.avatarUrl}" />
                                        <img src="${pageContext.request.contextPath}${avatarPath}" alt="Profile Picture" class="rounded-circle" style="width: 150px; height: 150px; object-fit: cover;">
                                        <form method="post" action="admin-ca-nhan" enctype="multipart/form-data">
                                            <input type="hidden" name="action" value="updateAvatar">
                                            <input type="file" name="avatar" id="avatarInput" style="display: none;" accept="image/*" onchange="this.form.submit();">
                                            <button class="btn btn-primary btn-sm" type="button" id="changeAvatarBtn">Đổi ảnh</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <form class="userProfile" id="profileForm" method="post" action="#">
                            <input type="hidden" name="action" value="updateProfile">
                            <div class="row">
                                <div class="col-12">
                                    <div class="form-group row">
                                        <label class="col-sm-3 col-form-label">Họ và tên</label>
                                        <div class="col-sm-9">
                                            <input class="form-control" type="text" name="fullName" value="${currentAccount.getName()}" readonly>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="form-group row">
                                        <label class="col-sm-3 col-form-label">Số điện thoại</label>
                                        <div class="col-sm-9">
                                            <input class="form-control" type="text" name="phone" value="${currentAccount.getPhone()}" readonly>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${role=='student'}">
                                    <div class="col-12">
                                        <div class="form-group row">
                                            <label class="col-sm-3 col-form-label">Lớp</label>
                                            <div class="col-sm-9">
                                                <input class="form-control" type="number" name="grade" min="1" max="12" value="${user.getCurrentGrade()}">
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${role=='student'}">
                                    <div class="col-12">
                                        <div class="form-group row">
                                            <label class="col-sm-3 col-form-label">Trường đang học</label>
                                            <div class="col-sm-9">
                                                <input class="form-control" type="text" name="schoolName" value="${user.getSchoolName()}" readonly>

                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${role=='teacher'}">
                                    <div class="col-12">
                                        <div class="form-group row">
                                            <label class="col-sm-3 col-form-label">Trường đang dạy</label>
                                            <div class="col-sm-9">
                                                <input class="form-control" type="text" name="schoolName" value="${user.getSchoolName()}" readonly>

                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${role!='admin'}">
                                    <div class="col-12">
                                        <div class="form-group row">
                                            <label class="col-sm-3 col-form-label">Ngày sinh</label>
                                            <div class="col-sm-9">
                                                <input class="form-control" type="date" name="dateOfBirth"
                                                       value="${currentAccount.dob != null ? currentAccount.dob.toLocalDate() : ''}">

                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${role=='teacher'}">
                                    <div class="col-12">
                                        <div class="form-group row">
                                            <label class="col-sm-3 col-form-label">Kinh nghiệm</label>
                                            <div class="col-sm-9">
                                                <input class="form-control" type="text" name="bio" value="${user.getExperience()}" readonly>

                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                <div class="col-12">
                                    <div class="form-group row">
                                        <label class="col-sm-3 col-form-label">Địa chỉ</label>
                                        <div class="col-sm-9">
                                            <input class="form-control" type="text" name="address" value="${currentAccount.getAddress()}">

                                        </div>
                                    </div>
                                </div>
                                <c:if test="${role=='teacher'}">
                                    <div class="col-12">
                                        <div class="form-group row">
                                            <label class="col-sm-3 col-form-label">Tiểu sử </label>
                                            <div class="col-sm-9">
                                                <textarea class="form-control" name="bio" rows="2">${user.getBio()}</textarea>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${role == 'student' or role == 'teacher'}">
                                    <input type="hidden" name="schoolId" value="${user.getSchoolId()}">
                                </c:if>


                                <div class="col-12">
                                    <div class="form-group row">
                                        <div class="col-sm-9 offset-sm-3 d-flex justify-content-between">
                                            <button type="button" class="btn btn-primary" id="updateProfileBtn">Cập nhật thông tin</button>
                                            <button type="button" class="btn btn-secondary" id="togglePasswordFormBtn">Đổi mật khẩu</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                        <div id="changePasswordModal" class="custom-modal">
                            <div class="custom-modal-content">
                                <span class="custom-close">&times;</span>
                                <h5 class="mb-3">Đổi mật khẩu</h5>
                                <form method="post" action="admin-ca-nhan" id="changePasswordForm">
                                    <input type="hidden" name="action" value="changePassword">
                                    <div class="form-group">
                                        <label>Tài khoản</label>
                                        <input type="text" name="username" class="form-control" value="${admin.username}" readonly>
                                    </div>
                                    <div class="form-group">
                                        <label>Mật khẩu hiện tại</label>
                                        <input type="password" name="currentPassword" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Mật khẩu mới</label>
                                        <input type="password" name="newPassword" class="form-control" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Xác nhận mật khẩu</label>
                                        <input type="password" name="confirmPassword" class="form-control" required>
                                    </div>
                                    <div class="text-end">
                                        <button type="submit" class="btn btn-success">Đổi mật khẩu</button>
                                    </div>
                                </form>
                            </div>
                        </div>


                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .custom-modal {
        display: none;
        position: fixed;
        z-index: 1050;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0,0,0,0.4);
    }

    .custom-modal-content {
        background-color: #fff;
        margin: 10% auto;
        padding: 2rem;
        border-radius: 1rem;
        width: 90%;
        max-width: 500px;
        position: relative;
        box-shadow: 0 0 15px rgba(0,0,0,0.3);
    }

    .custom-close {
        position: absolute;
        right: 20px;
        top: 15px;
        font-size: 24px;
        font-weight: bold;
        color: #aaa;
        cursor: pointer;
        transition: color 0.2s ease;
    }

    .custom-close:hover {
        color: red;
    }

    .form-wrapper {
        background-color: #fff;
        padding: 2rem;
        border-radius: 1rem;
        box-shadow: 0 0 20px rgba(0,0,0,0.05);
        margin-top: 2rem;
    }

    .edit-profile-form input[readonly],
    .edit-profile-form textarea[readonly] {
        background-color: #f8f9fa;
        cursor: not-allowed;
    }

    .edit-profile-form input:not([readonly]),
    .edit-profile-form textarea:not([readonly]) {
        background-color: #fff;
        border-color: #80bdff;
        box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
    }

    .profile-pic img {
        border: 3px solid #fff;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }

    .form-group {
        margin-bottom: 1.5rem;
    }

    .form-control:focus {
        border-color: #80bdff;
        box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
    }

    .btn-primary {
        background-color: #ff8814;
        border-color: #ff8814;
    }

    .btn-primary:hover {
        background-color: #db4b24;
        border-color: #db4b24;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const updateProfileBtn = document.getElementById('updateProfileBtn');
        const profileForm = document.getElementById('profileForm');
        const changePasswordForm = document.getElementById('changePasswordForm');
        const changeAvatarBtn = document.getElementById('changeAvatarBtn');
        const avatarInput = document.getElementById('avatarInput');
        let isEditMode = false;

        updateProfileBtn.addEventListener('click', function () {
            isEditMode = !isEditMode;
            const inputs = profileForm.querySelectorAll('input:not([name="username"]):not([name="role"]), textarea');

            inputs.forEach(input => {
                input.readOnly = !isEditMode;
            });

            updateProfileBtn.textContent = isEditMode ? 'Lưu thay đổi' : 'Cập nhật thông tin';

            if (!isEditMode) {
                profileForm.submit();
                alert('Thông tin đã được cập nhật!');
            }
        });

        changeAvatarBtn.addEventListener('click', function () {
            avatarInput.click();
        });

        avatarInput.addEventListener('change', function (e) {
            if (e.target.files && e.target.files[0]) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    document.querySelector('.profile-pic img').src = e.target.result;
                };
                reader.readAsDataURL(e.target.files[0]);
            }
        });

        changePasswordForm.addEventListener('submit', function (e) {
            e.preventDefault();
            const currentPassword = this.querySelector('[name="currentPassword"]').value;
            const newPassword = this.querySelector('[name="newPassword"]').value;
            const confirmPassword = this.querySelector('[name="confirmPassword"]').value;

            if (newPassword !== confirmPassword) {
                alert('Mật khẩu mới và xác nhận mật khẩu không khớp!');
                return;
            }

            alert('Mật khẩu đã được thay đổi!');
            this.reset();
        });

        const togglePasswordFormBtn = document.getElementById('togglePasswordFormBtn');
        const passwordModal = document.getElementById('changePasswordModal');
        const closeModalBtn = document.querySelector('.custom-close');

        togglePasswordFormBtn.addEventListener('click', function () {
            passwordModal.style.display = 'block';
        });

        closeModalBtn.addEventListener('click', function () {
            passwordModal.style.display = 'none';
        });

        window.addEventListener('click', function (event) {
            if (event.target === passwordModal) {
                passwordModal.style.display = 'none';
            }
        });

    });
</script>
