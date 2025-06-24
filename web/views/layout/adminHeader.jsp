<%-- 
    Document   : header
    Created on : May 29, 2025, 1:51:56 PM
    Author     : Astersa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><%= request.getAttribute("title") != null ? request.getAttribute("title") : "Trang web"%></title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/style/style.css">
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/style/adminDashboard.css">
        <c:if test="${not empty pageCSS}">
            <link rel="stylesheet" href="${pageContext.request.contextPath}${pageCSS}">
        </c:if>
    </head>
    <body class="ttr-opened-sidebar ttr-pinned-sidebar">
        <header class="ttr-header">
            <div class="ttr-header-wrapper">
                <!--sidebar menu toggler start -->
                <div class="ttr-toggle-sidebar ttr-material-button">
                    <i class="fa fa-bars ttr-open-icon"></i>
                    <i class="fa fa-times ttr-close-icon"></i>
                </div>
                <!--sidebar menu toggler end -->
                <!--logo start -->
                <div class="ttr-logo-box">
                    <div>
                        <a href="bang-dieu-khien" class="ttr-logo" style="color: #FFF !important;">
                            EDUCENTER
                        </a>
                    </div>
                </div>
                <!--logo end -->
                <div class="ttr-header-menu">
                    <!-- header left menu start -->
                    <ul class="ttr-header-navigation">
                        <li>
                            <a href="trang-chu" class="ttr-material-button ttr-submenu-toggle">TRANG CHỦ</a>
                        </li>
                    </ul>
                    <!-- header left menu end -->
                </div>
                <div class="ttr-header-right ttr-with-seperator">
                    <ul class="ttr-header-navigation">

                        <li>
                            <a href="#" class="ttr-material-button ttr-submenu-toggle"><span class="ttr-user-avatar"><img alt="" src="assets/images/testimonials/pic3.jpg" width="32" height="32"></span></a>
                            <div class="ttr-header-submenu">
                                <ul>
                                    <li><a href="admin-ca-nhan">Hồ sơ</a></li>
                                    <li><a href="dang-nhap">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="ttr-search-bar">
                    <form class="ttr-search-form">
                        <div class="ttr-search-input-wrapper">
                            <input type="text" name="qq" placeholder="search something..." class="ttr-search-input">
                            <button type="submit" name="search" class="ttr-search-submit"><i class="ti-arrow-right"></i></button>
                        </div>
                        <span class="ttr-search-close ttr-search-toggle">
                            <i class="ti-close"></i>
                        </span>
                    </form>
                </div>
            </div>
        </header>
        <div class="ttr-sidebar">
            <div class="ttr-sidebar-wrapper content-scroll">
                <div class="ttr-sidebar-logo">
                    <a href="#" class="ttr-logo" style="color: #000 !important;"> EduCenter </a>
                    <div class="ttr-sidebar-toggle-button">
                        <i class="fa fa-arrow-left"></i>
                    </div>
                </div>
                <nav class="ttr-sidebar-navi">
                    <ul>
                        <c:choose>
                            <c:when test="${loggedInUserRole == 'manager'}">
                                <li>
                                    <a href="bang-dieu-khien" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-home"></i></span>
                                        <span class="ttr-label">Bảng điều khiển</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="admin-quan-ly-khoa-hoc" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-book"></i></span>
                                        <span class="ttr-label">Khóa học</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="admin-ca-nhan" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-address-card"></i></span>
                                        <span class="ttr-label">Hồ sơ</span>
                                    </a>
                                </li>
                            </c:when>
                            <c:when test="${loggedInUserRole == 'superadmin'}">
                                <li>
                                    <a href="bang-dieu-khien" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-home"></i></span>
                                        <span class="ttr-label">Bảng điều khiển</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="admin-quan-ly-tai-khoan" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-user-circle"></i></span>
                                        <span class="ttr-label">Tài khoản</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="admin-quan-ly-nhan-su" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-user-circle"></i></span>
                                        <span class="ttr-label">Tài khoản nhân sự</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="admin-ca-nhan" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-address-card"></i></span>
                                        <span class="ttr-label">Hồ sơ</span>
                                    </a>
                                </li>
                            </c:when>
                            <c:when test="${loggedInUserRole == 'staff'}">
                                <li>
                                    <a href="admin-quan-ly-tai-khoan" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-user-circle"></i></span>
                                        <span class="ttr-label">Tài khoản</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="admin-ca-nhan" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-address-card"></i></span>
                                        <span class="ttr-label">Hồ sơ</span>
                                    </a>
                                </li>
                            </c:when>
                            <c:when test="${loggedInUserRole == null}">
                                <li>
                                    <a href="bang-dieu-khien" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-home"></i></span>
                                        <span class="ttr-label">Bảng điều khiển</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="admin-quan-ly-tai-khoan" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-user-circle"></i></span>
                                        <span class="ttr-label">Tài khoản</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="admin-quan-ly-nhan-su" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-user-circle"></i></span>
                                        <span class="ttr-label">Tài khoản nhân sự</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="admin-ca-nhan" class="ttr-material-button">
                                        <span class="ttr-icon"><i class="fa fa-address-card"></i></span>
                                        <span class="ttr-label">Hồ sơ</span>
                                    </a>
                                </li>
                            </c:when>
                        </c:choose>
                        <li class="ttr-seperate"></li>
                    </ul>
                </nav>
            </div>
        </div>
        <main class="ttr-wrapper">
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // Get all necessary elements
                    const body = document.body;
                    const toggleBtn = document.querySelector('.ttr-toggle-sidebar');
                    const sidebarToggleBtn = document.querySelector('.ttr-sidebar-toggle-button');

                    // Function to toggle sidebar
                    function toggleSidebar() {
                        body.classList.toggle('ttr-opened-sidebar');
                        body.classList.toggle('ttr-pinned-sidebar');
                    }

                    // Add click event listeners
                    if (toggleBtn) {
                        toggleBtn.addEventListener('click', toggleSidebar);
                    }

                    if (sidebarToggleBtn) {
                        sidebarToggleBtn.addEventListener('click', toggleSidebar);
                    }

                    // Initialize sidebar state
                    body.classList.add('ttr-opened-sidebar');
                    body.classList.add('ttr-pinned-sidebar');

                    // Handle window resize
                    let resizeTimer;
                    window.addEventListener('resize', function () {
                        clearTimeout(resizeTimer);
                        resizeTimer = setTimeout(function () {
                            if (window.innerWidth < 992) {
                                body.classList.remove('ttr-opened-sidebar');
                                body.classList.remove('ttr-pinned-sidebar');
                            } else {
                                body.classList.add('ttr-opened-sidebar');
                                body.classList.add('ttr-pinned-sidebar');
                            }
                        }, 250);
                    });
                });
            </script>