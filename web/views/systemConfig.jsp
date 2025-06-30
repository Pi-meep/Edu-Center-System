<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cấu hình hệ thống - EduCenter</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .nav-tabs .nav-link {
            color: #6c757d;
            border: none;
            border-bottom: 2px solid transparent;
        }
        .nav-tabs .nav-link.active {
            color: #0d6efd;
            border-bottom: 2px solid #0d6efd;
            background: none;
        }
        .tab-content {
            padding: 20px 0;
        }
        .card {
            border: none;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
        }
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
        }
        .btn-action {
            margin: 2px;
        }
        .image-preview {
            max-width: 200px;
            max-height: 150px;
            object-fit: cover;
            border-radius: 8px;
        }
        .status-badge {
            font-size: 0.75rem;
        }
        .payment-card {
            border-left: 4px solid #28a745;
        }
        .payment-card.inactive {
            border-left-color: #6c757d;
        }
        .active-payment {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="layout/adminHeader.jsp" />
    
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0">
                            <i class="fas fa-cogs me-2"></i>
                            Cấu hình hệ thống
                        </h4>
                    </div>
                    <div class="card-body">
                        <!-- Alert Messages -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Navigation Tabs -->
                        <ul class="nav nav-tabs" id="configTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="banner-tab" data-bs-toggle="tab" data-bs-target="#banner" type="button" role="tab">
                                    <i class="fas fa-images me-2"></i>Quản lý Banner
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="center-tab" data-bs-toggle="tab" data-bs-target="#center" type="button" role="tab">
                                    <i class="fas fa-building me-2"></i>Thông tin trung tâm
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="payment-tab" data-bs-toggle="tab" data-bs-target="#payment" type="button" role="tab">
                                    <i class="fas fa-credit-card me-2"></i>Thông tin thanh toán
                                </button>
                            </li>
                        </ul>

                        <!-- Tab Content -->
                        <div class="tab-content" id="configTabContent">
                            <!-- Banner Management Tab -->
                            <div class="tab-pane fade show active" id="banner" role="tabpanel">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5>Quản lý Banner</h5>
                                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBannerModal">
                                        <i class="fas fa-plus me-2"></i>Thêm Banner
                                    </button>
                                </div>
                                
                                <div class="row">
                                    <c:forEach var="banner" items="${banners}">
                                        <div class="col-md-6 col-lg-4 mb-3">
                                            <div class="card h-100">
                                                <img src="${pageContext.request.contextPath}/${banner.imageUrl}" class="card-img-top" alt="${banner.title}" style="height: 200px; object-fit: cover;">
                                                <div class="card-body">
                                                    <h6 class="card-title">${banner.title}</h6>
                                                    <p class="card-text text-muted">${banner.description}</p>
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <span class="badge ${banner.isActive ? 'bg-success' : 'bg-secondary'} status-badge">
                                                            ${banner.isActive ? 'Đang hiển thị' : 'Ẩn'}
                                                        </span>
                                                        <small class="text-muted">Thứ tự: ${banner.orderIndex}</small>
                                                    </div>
                                                </div>
                                                <div class="card-footer bg-transparent">
                                                    <div class="btn-group w-100" role="group">
                                                        <button class="btn btn-outline-primary btn-sm" onclick="editBanner(${banner.id})">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <button class="btn btn-outline-${banner.isActive ? 'warning' : 'success'} btn-sm" onclick="toggleBanner(${banner.id}, ${banner.isActive})">
                                                            <i class="fas fa-${banner.isActive ? 'eye-slash' : 'eye'}"></i>
                                                        </button>
                                                        <button class="btn btn-outline-danger btn-sm" onclick="deleteBanner(${banner.id})">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Center Info Tab -->
                            <div class="tab-pane fade" id="center" role="tabpanel">
                                <div class="row">
                                    <div class="col-md-8">
                                        <h5>Thông tin trung tâm</h5>
                                        <form action="cau-hinh-he-thong" method="post">
                                            <input type="hidden" name="action" value="update-center-info">
                                            
                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Tên trung tâm</label>
                                                    <input type="text" class="form-control" name="centerName" value="${centerInfo.centerName}" required>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Số điện thoại</label>
                                                    <input type="tel" class="form-control" name="phone" value="${centerInfo.phone}">
                                                </div>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label class="form-label">Địa chỉ</label>
                                                <textarea class="form-control" name="address" rows="2">${centerInfo.address}</textarea>
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Email</label>
                                                    <input type="email" class="form-control" name="email" value="${centerInfo.email}">
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label">Website</label>
                                                    <input type="url" class="form-control" name="website" value="${centerInfo.website}">
                                                </div>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label class="form-label">Mô tả</label>
                                                <textarea class="form-control" name="description" rows="3">${centerInfo.description}</textarea>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label class="form-label">Giờ làm việc</label>
                                                <input type="text" class="form-control" name="workingHours" value="${centerInfo.workingHours}">
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-md-4 mb-3">
                                                    <label class="form-label">Facebook</label>
                                                    <input type="url" class="form-control" name="facebook" value="${centerInfo.facebook}">
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <label class="form-label">YouTube</label>
                                                    <input type="url" class="form-control" name="youtube" value="${centerInfo.youtube}">
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <label class="form-label">Instagram</label>
                                                    <input type="url" class="form-control" name="instagram" value="${centerInfo.instagram}">
                                                </div>
                                            </div>
                                            
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-2"></i>Lưu thông tin
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- Payment Info Tab -->
                            <div class="tab-pane fade" id="payment" role="tabpanel">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5>Thông tin thanh toán</h5>
                                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPaymentModal">
                                        <i class="fas fa-plus me-2"></i>Thêm tài khoản
                                    </button>
                                </div>
                                
                                <!-- Active Payment Display -->
                                <c:if test="${not empty activePayment}">
                                    <div class="alert alert-success">
                                        <h6><i class="fas fa-star me-2"></i>Tài khoản thanh toán mặc định</h6>
                                        <div class="row">
                                            <div class="col-md-8">
                                                <strong>${activePayment.bankName}</strong><br>
                                                Số tài khoản: ${activePayment.accountNumber}<br>
                                                Chủ tài khoản: ${activePayment.accountName}<br>
                                                <c:if test="${not empty activePayment.branch}">Chi nhánh: ${activePayment.branch}<br></c:if>
                                                <c:if test="${not empty activePayment.swiftCode}">Swift Code: ${activePayment.swiftCode}</c:if>
                                            </div>
                                            <div class="col-md-4 text-center">
                                                <c:if test="${not empty activePayment.qrCodeUrl}">
                                                    <img src="${activePayment.qrCodeUrl}" alt="QR Code" class="img-fluid" style="max-width: 100px;">
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- All Payment Accounts -->
                                <div class="row">
                                    <c:forEach var="payment" items="${paymentInfos}">
                                        <div class="col-md-6 col-lg-4 mb-3">
                                            <div class="card payment-card ${payment.isActive ? 'active-payment' : 'inactive'}">
                                                <div class="card-body">
                                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                        <h6 class="card-title mb-0">${payment.bankName}</h6>
                                                        <c:if test="${payment.isActive}">
                                                            <span class="badge bg-light text-dark">
                                                                <i class="fas fa-star"></i> Mặc định
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                    <p class="card-text">
                                                        <strong>Số TK:</strong> ${payment.accountNumber}<br>
                                                        <strong>Chủ TK:</strong> ${payment.accountName}<br>
                                                        <c:if test="${not empty payment.branch}">
                                                            <strong>Chi nhánh:</strong> ${payment.branch}<br>
                                                        </c:if>
                                                        <c:if test="${not empty payment.swiftCode}">
                                                            <strong>Swift:</strong> ${payment.swiftCode}
                                                        </c:if>
                                                    </p>
                                                    <div class="btn-group w-100" role="group">
                                                        <button class="btn btn-outline-primary btn-sm" onclick="editPayment(${payment.id})">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <c:if test="${!payment.isActive}">
                                                            <button class="btn btn-outline-success btn-sm" onclick="setActivePayment(${payment.id})">
                                                                <i class="fas fa-star"></i>
                                                            </button>
                                                        </c:if>
                                                        <button class="btn btn-outline-danger btn-sm" onclick="deletePayment(${payment.id})">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Banner Modal -->
    <div class="modal fade" id="addBannerModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Banner mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="cau-hinh-he-thong" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add-banner">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Tiêu đề</label>
                                <input type="text" class="form-control" name="title" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Thứ tự hiển thị</label>
                                <input type="number" class="form-control" name="orderIndex" value="1" min="1">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả</label>
                            <textarea class="form-control" name="description" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Hình ảnh</label>
                            <input type="file" class="form-control" name="image" accept="image/*" required>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="isActive" id="bannerActive" checked>
                            <label class="form-check-label" for="bannerActive">
                                Hiển thị ngay
                            </label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm Banner</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Add Payment Modal -->
    <div class="modal fade" id="addPaymentModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm tài khoản thanh toán</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="cau-hinh-he-thong" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add-payment">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Tên ngân hàng</label>
                                <input type="text" class="form-control" name="bankName" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số tài khoản</label>
                                <input type="text" class="form-control" name="accountNumber" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Chủ tài khoản</label>
                                <input type="text" class="form-control" name="accountName" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Chi nhánh</label>
                                <input type="text" class="form-control" name="branch">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Swift Code</label>
                                <input type="text" class="form-control" name="swiftCode">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Thứ tự hiển thị</label>
                                <input type="number" class="form-control" name="orderIndex" value="1" min="1">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mã QR (tùy chọn)</label>
                            <input type="file" class="form-control" name="qrCode" accept="image/*">
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="isActive" id="paymentActive">
                            <label class="form-check-label" for="paymentActive">
                                Đặt làm tài khoản mặc định
                            </label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Thêm tài khoản</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editBanner(id) {
            // Implement edit banner functionality
            alert('Chức năng chỉnh sửa banner sẽ được thêm sau');
        }
        
        function toggleBanner(id, isActive) {
            if (confirm('Bạn có muốn thay đổi trạng thái hiển thị của banner này?')) {
                window.location.href = 'cau-hinh-he-thong?action=toggle-banner&id=' + id + '&isActive=' + !isActive;
            }
        }
        
        function deleteBanner(id) {
            if (confirm('Bạn có chắc chắn muốn xóa banner này?')) {
                window.location.href = 'cau-hinh-he-thong?action=delete-banner&id=' + id;
            }
        }
        
        function editPayment(id) {
            // Implement edit payment functionality
            alert('Chức năng chỉnh sửa tài khoản sẽ được thêm sau');
        }
        
        function setActivePayment(id) {
            if (confirm('Bạn có muốn đặt tài khoản này làm mặc định?')) {
                window.location.href = 'cau-hinh-he-thong?action=set-active-payment&id=' + id;
            }
        }
        
        function deletePayment(id) {
            if (confirm('Bạn có chắc chắn muốn xóa tài khoản này?')) {
                window.location.href = 'cau-hinh-he-thong?action=delete-payment&id=' + id;
            }
        }
    </script>
</body>
</html> 