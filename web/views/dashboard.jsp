<%-- 
    Document   : dashboard
    Created on : Jun 2, 2025, 4:29:22 AM
    Author     : Astersa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<jsp:include page="layout/adminHeader.jsp" />
<style>
  .widget-card .wc-stats {
    position: static !important;
    right: auto !important;
    top: auto !important;
    text-align: center;
    width: 100%;
    display: block;
  }
</style>
<div class="container-fluid">
	<div class="db-breadcrumb">
		<h4 class="breadcrumb-title">Bảng điều khiển</h4>
		<ul class="db-breadcrumb-list">
			<li><a href="bang-dieu-khien"><i class="fa fa-home"></i>Bảng điều khiển</a></li>
			<li>Bảng điều khiển</li>
		</ul>
	</div>	
	<!-- Card -->
	<div class="row">
		<div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
			<div class="widget-card widget-bg1 d-flex flex-column justify-content-between" style="height: 180px;">
				<div>
					<h4 class="wc-title text-center">Tổng doanh thu</h4>
				</div>
				<div class="d-flex flex-column align-items-center justify-content-center" style="flex:1;">
					<span class="wc-stats d-block" style="font-size: 2.5rem; line-height: 1;">
						<fmt:formatNumber value="${revenue}" type="number" groupingUsed="true"/>
					</span>
					<span class="wc-des d-block mt-1">VNĐ</span>
				</div>
			</div>
		</div>
		<div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
			<div class="widget-card widget-bg2 d-flex flex-column justify-content-between" style="height: 180px;">
				<div>
					<h4 class="wc-title text-center">Tổng người dùng</h4>
				</div>
				<div class="d-flex flex-column align-items-center justify-content-center" style="flex:1;">
					<span class="wc-stats d-block" style="font-size: 2.5rem; line-height: 1;">
						${totalAccounts}
					</span>
					<span class="wc-des d-block mt-1">Người dùng</span>
				</div>
			</div>
		</div>
		<div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
			<div class="widget-card widget-bg3 d-flex flex-column justify-content-between" style="height: 180px;">
				<div>
					<h4 class="wc-title text-center">Tổng khóa học</h4>
				</div>
				<div class="d-flex flex-column align-items-center justify-content-center" style="flex:1;">
					<span class="wc-stats d-block" style="font-size: 2.5rem; line-height: 1;">
						${totalCourses}
					</span>
					<span class="wc-des d-block mt-1">Khóa học</span>
				</div>
			</div>
		</div>
		<div class="col-md-6 col-lg-3 col-xl-3 col-sm-6 col-12">
			<div class="widget-card widget-bg4 d-flex flex-column justify-content-between" style="height: 180px;">
				<div>
					<h4 class="wc-title text-center">Tổng giáo viên</h4>
				</div>
				<div class="d-flex flex-column align-items-center justify-content-center" style="flex:1;">
					<span class="wc-stats d-block" style="font-size: 2.5rem; line-height: 1;">
						${totalTeachers}
					</span>
					<span class="wc-des d-block mt-1">Giáo viên</span>
				</div>
			</div>
		</div>
	</div>
	<!-- Card END -->
	<div class="row">
		<div class="col-lg-12 m-b30">
			<div class="widget-box">
				<div class="wc-title">
					<h4>Thông báo</h4>
				</div>
				<div class="widget-inner">
					<div class="noti-box-list">
						<ul>
							<c:choose>
								<c:when test="${not empty notifications}">
									<c:forEach var="noti" items="${notifications}">
										<li>
											<span class="notification-icon dashbg-gray">
												<i class="fa fa-bell"></i>
											</span>
											<span class="notification-text">
												<span>${noti.accountName}</span>: ${noti.decription}
											</span>
											<span class="notification-time">
												<span>
													<fmt:formatDate value="${noti.createdAt}" pattern="HH:mm"/>
												</span>
											</span>
										</li>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<li>
										<span class="notification-icon dashbg-gray">
											<i class="fa fa-bell"></i>
										</span>
										<span class="notification-text">
											Chưa có thông báo nào
										</span>
									</li>
								</c:otherwise>
							</c:choose>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<jsp:include page="layout/footer.jsp" /> 