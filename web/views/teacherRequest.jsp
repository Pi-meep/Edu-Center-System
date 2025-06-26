<%-- 
    Document   : teacherRequest.jsp
    Created on : May 23, 2025, 4:29:19 AM
    Author     : Astersa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<% request.setAttribute("title", "Yêu cầu giáo viên");%>

<jsp:include page="layout/header.jsp" />

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.6;
        color: #333;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
    }

    .teacherrequest-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 2rem;
    }

    .teacherrequest-header {
        background: white;
        border-radius: 20px;
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        border: 1px solid #e1e8ed;
    }

    .teacherrequest-header-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }

    .teacherrequest-title h1 {
        font-size: 2.5rem;
        color: #333;
        margin-bottom: 0.5rem;
        font-weight: 700;
    }

    .teacherrequest-title p {
        color: #666;
        font-size: 1.1rem;
    }

    .teacherrequest-role-badge {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
        padding: 0.75rem 1.5rem;
        border-radius: 25px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .teacherrequest-content {
        display: grid;
        grid-template-columns: 1fr 2fr;
        gap: 2rem;
    }

    .teacherrequest-form-section {
        background: white;
        border-radius: 20px;
        padding: 2rem;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        border: 1px solid #e1e8ed;
        height: fit-content;
    }

    .teacherrequest-form-header {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin-bottom: 2rem;
    }

    .teacherrequest-form-icon {
        width: 50px;
        height: 50px;
        background: linear-gradient(135deg, #667eea, #764ba2);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.5rem;
    }

    .teacherrequest-form-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: #333;
    }

    .teacherrequest-type-grid {
        display: grid;
        gap: 0.75rem;
        margin-bottom: 2rem;
    }

    .teacherrequest-type-btn {
        padding: 1rem;
        border: 2px solid #e9ecef;
        border-radius: 12px;
        background: white;
        cursor: pointer;
        transition: all 0.3s ease;
        text-align: left;
    }

    .teacherrequest-type-btn:hover {
        border-color: #667eea;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
    }

    .teacherrequest-type-btn.selected {
        border-color: #667eea;
        background: #f8f9ff;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
    }

    .teacherrequest-type-content {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .teacherrequest-type-icon {
        font-size: 1.5rem;
    }

    .teacherrequest-type-label {
        font-weight: 500;
        color: #333;
    }

    .teacherrequest-form-group {
        margin-bottom: 1.5rem;
    }

    .teacherrequest-label {
        display: block;
        font-weight: 500;
        color: #333;
        margin-bottom: 0.5rem;
        font-size: 0.9rem;
    }

    .teacherrequest-input {
        width: 100%;
        padding: 0.75rem;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 0.9rem;
        transition: all 0.3s ease;
    }

    .teacherrequest-input:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .teacherrequest-textarea {
        resize: vertical;
        min-height: 80px;
    }

    .teacherrequest-select {
        width: 100%;
        padding: 0.75rem;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 0.9rem;
        background: white;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .teacherrequest-select:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .teacherrequest-submit-btn {
        width: 100%;
        padding: 1rem;
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
        border: none;
        border-radius: 12px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
    }

    .teacherrequest-submit-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
    }

    .teacherrequest-list-section {
        background: white;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        border: 1px solid #e1e8ed;
        overflow: hidden;
    }

    .teacherrequest-list-header {
        padding: 2rem;
        border-bottom: 1px solid #e9ecef;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }

    .teacherrequest-list-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: #333;
    }

    .teacherrequest-search-filter {
        display: flex;
        gap: 1rem;
        align-items: center;
    }

    .teacherrequest-search-box {
        position: relative;
    }

    .teacherrequest-search-icon {
        position: absolute;
        left: 1rem;
        top: 50%;
        transform: translateY(-50%);
        color: #999;
    }

    .teacherrequest-search-input {
        padding: 0.75rem 1rem 0.75rem 2.5rem;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 0.9rem;
        width: 250px;
        transition: all 0.3s ease;
    }

    .teacherrequest-search-input:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .teacherrequest-filter-btn {
        padding: 0.75rem 1rem;
        background: #f8f9fa;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        color: #666;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.9rem;
    }

    .teacherrequest-filter-btn:hover {
        background: #e9ecef;
        color: #333;
    }

    .teacherrequest-item {
        padding: 1.5rem 2rem;
        border-bottom: 1px solid #f1f3f4;
        transition: all 0.3s ease;
    }

    .teacherrequest-item:hover {
        background: #f8f9ff;
    }

    .teacherrequest-item:last-child {
        border-bottom: none;
    }

    .teacherrequest-item-content {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 1rem;
    }

    .teacherrequest-item-main {
        flex: 1;
    }

    .teacherrequest-item-header {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin-bottom: 0.75rem;
    }

    .teacherrequest-item-title {
        font-weight: 600;
        color: #333;
        font-size: 1rem;
    }

    .teacherrequest-status {
        padding: 0.25rem 0.75rem;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 500;
        border: 1px solid;
    }

    .teacherrequest-status.pending {
        background: #fff3cd;
        color: #856404;
        border-color: #ffeaa7;
    }

    .teacherrequest-status.approved {
        background: #d4edda;
        color: #155724;
        border-color: #c3e6cb;
    }

    .teacherrequest-status.rejected {
        background: #f8d7da;
        color: #721c24;
        border-color: #f5c6cb;
    }

    .teacherrequest-item-meta {
        display: flex;
        align-items: center;
        gap: 1.5rem;
        color: #666;
        font-size: 0.85rem;
    }

    .teacherrequest-meta-item {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .teacherrequest-role-badge {
        padding: 0.25rem 0.75rem;
        background: #f8f9fa;
        color: #666;
        border-radius: 12px;
        font-size: 0.75rem;
        border: 1px solid #e9ecef;
    }

    .teacherrequest-item-actions {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
    }

    .teacherrequest-action-btn {
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 6px;
        font-size: 0.8rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .teacherrequest-action-btn.detail {
        background: #e3f2fd;
        color: #1976d2;
    }

    .teacherrequest-action-btn.detail:hover {
        background: #bbdefb;
    }

    .teacherrequest-action-btn.approve {
        background: #e8f5e8;
        color: #2e7d32;
    }

    .teacherrequest-action-btn.approve:hover {
        background: #c8e6c9;
    }

    .teacherrequest-action-btn.reject {
        background: #ffebee;
        color: #c62828;
    }

    .teacherrequest-action-btn.reject:hover {
        background: #ffcdd2;
    }

    @media (max-width: 1024px) {
        .teacherrequest-content {
            grid-template-columns: 1fr;
        }
        
        .teacherrequest-header-content {
            flex-direction: column;
            align-items: flex-start;
        }
        
        .teacherrequest-search-filter {
            flex-direction: column;
            align-items: stretch;
        }
        
        .teacherrequest-search-input {
            width: 100%;
        }
    }

    @media (max-width: 768px) {
        .teacherrequest-container {
            padding: 1rem;
        }
        
        .teacherrequest-title h1 {
            font-size: 2rem;
        }
        
        .teacherrequest-item-content {
            flex-direction: column;
            gap: 1rem;
        }
        
        .teacherrequest-item-meta {
            flex-direction: column;
            align-items: flex-start;
            gap: 0.5rem;
        }
    }

    @keyframes teacherrequestFadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .teacherrequest-form-section,
    .teacherrequest-list-section {
        animation: teacherrequestFadeIn 0.6s ease;
    }
</style>

<div class="teacherrequest-container">
    <div class="teacherrequest-header">
        <div class="teacherrequest-header-content">
            <div class="teacherrequest-title">
                <h1>Yêu cầu giáo viên</h1>
                <p>Quản lý các yêu cầu hủy lớp, đổi phòng, thêm lớp bù, thiết bị</p>
            </div>
            
            <div class="teacherrequest-role-badge">
                👩‍🏫 Giáo viên
            </div>
        </div>
    </div>

    <div class="teacherrequest-content">
        <div class="teacherrequest-form-section">
            <div class="teacherrequest-form-header">
                <div class="teacherrequest-form-icon">➕</div>
                <h2 class="teacherrequest-form-title">Tạo yêu cầu mới</h2>
            </div>

            <div class="teacherrequest-form-content">
                <div class="teacherrequest-form-group">
                    <label class="teacherrequest-label">Loại yêu cầu</label>
                    <div class="teacherrequest-type-grid" id="requestTypeGrid">
                        <button class="teacherrequest-type-btn" data-type="cancel_class">
                            <div class="teacherrequest-type-content">
                                <span class="teacherrequest-type-icon">❌</span>
                                <span class="teacherrequest-type-label">Hủy lớp học</span>
                            </div>
                        </button>
                        <button class="teacherrequest-type-btn" data-type="change_room">
                            <div class="teacherrequest-type-content">
                                <span class="teacherrequest-type-icon">🏢</span>
                                <span class="teacherrequest-type-label">Đổi phòng học</span>
                            </div>
                        </button>
                        <button class="teacherrequest-type-btn" data-type="extra_class">
                            <div class="teacherrequest-type-content">
                                <span class="teacherrequest-type-icon">➕</span>
                                <span class="teacherrequest-type-label">Thêm lớp bù</span>
                            </div>
                        </button>
                        <button class="teacherrequest-type-btn" data-type="equipment_request">
                            <div class="teacherrequest-type-content">
                                <span class="teacherrequest-type-icon">💻</span>
                                <span class="teacherrequest-type-label">Yêu cầu thiết bị</span>
                            </div>
                        </button>
                    </div>
                </div>

                <div id="requestForm" style="display: none;">
                    <div class="teacherrequest-form-group">
                        <label class="teacherrequest-label">Tiêu đề yêu cầu</label>
                        <input type="text" class="teacherrequest-input" id="requestTitle" placeholder="Nhập tiêu đề yêu cầu..." required>
                    </div>

                    <div class="teacherrequest-form-group">
                        <label class="teacherrequest-label">Mô tả chi tiết</label>
                        <textarea class="teacherrequest-input teacherrequest-textarea" id="requestDescription" placeholder="Mô tả chi tiết yêu cầu..."></textarea>
                    </div>

                    <button class="teacherrequest-submit-btn" id="submitRequest">
                        📤 Gửi yêu cầu
                    </button>
                </div>
            </div>
        </div>

        <div class="teacherrequest-list-section">
            <div class="teacherrequest-list-header">
                <h2 class="teacherrequest-list-title">Danh sách yêu cầu</h2>
                <div class="teacherrequest-search-filter">
                    <div class="teacherrequest-search-box">
                        <span class="teacherrequest-search-icon">🔍</span>
                        <input type="text" class="teacherrequest-search-input" placeholder="Tìm kiếm..." id="searchInput">
                    </div>
                    <button class="teacherrequest-filter-btn" id="filterBtn">
                        🔧 Lọc
                    </button>
                </div>
            </div>

            <div class="teacherrequest-list-content" id="requestList">
                <div class="teacherrequest-item">
                    <div class="teacherrequest-item-content">
                        <div class="teacherrequest-item-main">
                            <div class="teacherrequest-item-header">
                                <h3 class="teacherrequest-item-title">Hủy lớp Toán 10A1</h3>
                                <span class="teacherrequest-status approved">Đã duyệt</span>
                            </div>
                            <div class="teacherrequest-item-meta">
                                <div class="teacherrequest-meta-item">
                                    <span>👤</span>
                                    <span>Cô Lan</span>
                                </div>
                                <div class="teacherrequest-meta-item">
                                    <span>📅</span>
                                    <span>2024-06-14</span>
                                </div>
                                <span class="teacherrequest-role-badge">👩‍🏫 Giáo viên</span>
                            </div>
                        </div>
                        <div class="teacherrequest-item-actions">
                            <button class="teacherrequest-action-btn detail">Xem chi tiết</button>
                        </div>
                    </div>
                </div>

                <div class="teacherrequest-item">
                    <div class="teacherrequest-item-content">
                        <div class="teacherrequest-item-main">
                            <div class="teacherrequest-item-header">
                                <h3 class="teacherrequest-item-title">Đổi phòng từ A101 sang B205</h3>
                                <span class="teacherrequest-status rejected">Từ chối</span>
                            </div>
                            <div class="teacherrequest-item-meta">
                                <div class="teacherrequest-meta-item">
                                    <span>👤</span>
                                    <span>Thầy Minh</span>
                                </div>
                                <div class="teacherrequest-meta-item">
                                    <span>📅</span>
                                    <span>2024-06-13</span>
                                </div>
                                <span class="teacherrequest-role-badge">👩‍🏫 Giáo viên</span>
                            </div>
                        </div>
                        <div class="teacherrequest-item-actions">
                            <button class="teacherrequest-action-btn detail">Xem chi tiết</button>
                        </div>
                    </div>
                </div>

                <div class="teacherrequest-item">
                    <div class="teacherrequest-item-content">
                        <div class="teacherrequest-item-main">
                            <div class="teacherrequest-item-header">
                                <h3 class="teacherrequest-item-title">Yêu cầu máy chiếu cho lớp Hóa 11B2</h3>
                                <span class="teacherrequest-status pending">Chờ duyệt</span>
                            </div>
                            <div class="teacherrequest-item-meta">
                                <div class="teacherrequest-meta-item">
                                    <span>👤</span>
                                    <span>Cô Hương</span>
                                </div>
                                <div class="teacherrequest-meta-item">
                                    <span>📅</span>
                                    <span>2024-06-16</span>
                                </div>
                                <span class="teacherrequest-role-badge">👩‍🏫 Giáo viên</span>
                            </div>
                        </div>
                        <div class="teacherrequest-item-actions">
                            <button class="teacherrequest-action-btn detail">Xem chi tiết</button>
                            <button class="teacherrequest-action-btn approve">Duyệt</button>
                            <button class="teacherrequest-action-btn reject">Từ chối</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll('.teacherrequest-type-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.teacherrequest-type-btn').forEach(b => b.classList.remove('selected'));
            this.classList.add('selected');
            
            document.getElementById('requestForm').style.display = 'block';
        });
    });

    document.getElementById('submitRequest').addEventListener('click', function() {
        const title = document.getElementById('requestTitle').value;
        const description = document.getElementById('requestDescription').value;
        const selectedType = document.querySelector('.teacherrequest-type-btn.selected');
        
        if (!title || !selectedType) {
            alert('Vui lòng nhập tiêu đề và chọn loại yêu cầu!');
            return;
        }
        
        alert('Yêu cầu đã được gửi thành công!');
        
        document.getElementById('requestTitle').value = '';
        document.getElementById('requestDescription').value = '';
        document.getElementById('requestPriority').value = 'normal';
        document.getElementById('requestForm').style.display = 'none';
        document.querySelectorAll('.teacherrequest-type-btn').forEach(b => b.classList.remove('selected'));
    });

    document.getElementById('searchInput').addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        const requestItems = document.querySelectorAll('.teacherrequest-item');
        
        requestItems.forEach(item => {
            const title = item.querySelector('.teacherrequest-item-title').textContent.toLowerCase();
            const requester = item.querySelector('.teacherrequest-meta-item span:last-child').textContent.toLowerCase();
            
            if (title.includes(searchTerm) || requester.includes(searchTerm)) {
                item.style.display = 'block';
            } else {
                item.style.display = 'none';
            }
        });
    });

    document.getElementById('filterBtn').addEventListener('click', function() {
        alert('Tính năng lọc sẽ được phát triển sau!');
    });

    document.querySelectorAll('.teacherrequest-action-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const action = this.textContent.trim();
            const requestTitle = this.closest('.teacherrequest-item').querySelector('.teacherrequest-item-title').textContent;
            
            if (action === 'Xem chi tiết') {
                alert(`Xem chi tiết yêu cầu: ${requestTitle}`);
            } else if (action === 'Duyệt') {
                if (confirm(`Bạn có chắc muốn duyệt yêu cầu: ${requestTitle}?`)) {
                    this.closest('.teacherrequest-item').querySelector('.teacherrequest-status').className = 'teacherrequest-status approved';
                    this.closest('.teacherrequest-item').querySelector('.teacherrequest-status').textContent = 'Đã duyệt';
                    this.remove();
                    this.nextElementSibling.remove();
                }
            } else if (action === 'Từ chối') {
                if (confirm(`Bạn có chắc muốn từ chối yêu cầu: ${requestTitle}?`)) {
                    this.closest('.teacherrequest-item').querySelector('.teacherrequest-status').className = 'teacherrequest-status rejected';
                    this.closest('.teacherrequest-item').querySelector('.teacherrequest-status').textContent = 'Từ chối';
                    this.remove();
                    this.previousElementSibling.remove();
                }
            }
        });
    });
</script>

<jsp:include page="layout/footer.jsp" /> 