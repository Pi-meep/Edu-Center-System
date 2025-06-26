<%-- 
    Document   : parentRequest.jsp
    Created on : May 23, 2025, 4:29:19 AM
    Author     : Astersa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<% request.setAttribute("title", "Yêu cầu phụ huynh");%>

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

    .parentrequest-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 2rem;
    }

    .parentrequest-header {
        background: white;
        border-radius: 20px;
        padding: 2rem;
        margin-bottom: 2rem;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        border: 1px solid #e1e8ed;
    }

    .parentrequest-header-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }

    .parentrequest-title h1 {
        font-size: 2.5rem;
        color: #333;
        margin-bottom: 0.5rem;
        font-weight: 700;
    }

    .parentrequest-title p {
        color: #666;
        font-size: 1.1rem;
    }

    .parentrequest-role-badge {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
        padding: 0.75rem 1.5rem;
        border-radius: 25px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .parentrequest-content {
        display: grid;
        grid-template-columns: 1fr 2fr;
        gap: 2rem;
    }

    .parentrequest-form-section {
        background: white;
        border-radius: 20px;
        padding: 2rem;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        border: 1px solid #e1e8ed;
        height: fit-content;
    }

    .parentrequest-form-header {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin-bottom: 2rem;
    }

    .parentrequest-form-icon {
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

    .parentrequest-form-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: #333;
    }

    .parentrequest-type-grid {
        display: grid;
        gap: 0.75rem;
        margin-bottom: 2rem;
    }

    .parentrequest-type-btn {
        padding: 1rem;
        border: 2px solid #e9ecef;
        border-radius: 12px;
        background: white;
        cursor: pointer;
        transition: all 0.3s ease;
        text-align: left;
    }

    .parentrequest-type-btn:hover {
        border-color: #667eea;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
    }

    .parentrequest-type-btn.selected {
        border-color: #667eea;
        background: #f8f9ff;
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
    }

    .parentrequest-type-content {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .parentrequest-type-icon {
        font-size: 1.5rem;
    }

    .parentrequest-type-label {
        font-weight: 500;
        color: #333;
    }

    .parentrequest-form-group {
        margin-bottom: 1.5rem;
    }

    .parentrequest-label {
        display: block;
        font-weight: 500;
        color: #333;
        margin-bottom: 0.5rem;
        font-size: 0.9rem;
    }

    .parentrequest-input {
        width: 100%;
        padding: 0.75rem;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 0.9rem;
        transition: all 0.3s ease;
    }

    .parentrequest-input:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .parentrequest-textarea {
        resize: vertical;
        min-height: 80px;
    }

    .parentrequest-date-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
    }

    .parentrequest-select {
        width: 100%;
        padding: 0.75rem;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 0.9rem;
        background: white;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .parentrequest-select:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .parentrequest-submit-btn {
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

    .parentrequest-submit-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
    }

    .parentrequest-list-section {
        background: white;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        border: 1px solid #e1e8ed;
        overflow: hidden;
    }

    .parentrequest-list-header {
        padding: 2rem;
        border-bottom: 1px solid #e9ecef;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 1rem;
    }

    .parentrequest-list-title {
        font-size: 1.25rem;
        font-weight: 600;
        color: #333;
    }

    .parentrequest-search-filter {
        display: flex;
        gap: 1rem;
        align-items: center;
    }

    .parentrequest-search-box {
        position: relative;
    }

    .parentrequest-search-icon {
        position: absolute;
        left: 1rem;
        top: 50%;
        transform: translateY(-50%);
        color: #999;
    }

    .parentrequest-search-input {
        padding: 0.75rem 1rem 0.75rem 2.5rem;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 0.9rem;
        width: 250px;
        transition: all 0.3s ease;
    }

    .parentrequest-search-input:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .parentrequest-filter-btn {
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

    .parentrequest-filter-btn:hover {
        background: #e9ecef;
        color: #333;
    }

    .parentrequest-item {
        padding: 1.5rem 2rem;
        border-bottom: 1px solid #f1f3f4;
        transition: all 0.3s ease;
    }

    .parentrequest-item:hover {
        background: #f8f9ff;
    }

    .parentrequest-item:last-child {
        border-bottom: none;
    }

    .parentrequest-item-content {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 1rem;
    }

    .parentrequest-item-main {
        flex: 1;
    }

    .parentrequest-item-header {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin-bottom: 0.75rem;
    }

    .parentrequest-item-title {
        font-weight: 600;
        color: #333;
        font-size: 1rem;
    }

    .parentrequest-status {
        padding: 0.25rem 0.75rem;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 500;
        border: 1px solid;
    }

    .parentrequest-status.pending {
        background: #fff3cd;
        color: #856404;
        border-color: #ffeaa7;
    }

    .parentrequest-status.approved {
        background: #d4edda;
        color: #155724;
        border-color: #c3e6cb;
    }

    .parentrequest-status.rejected {
        background: #f8d7da;
        color: #721c24;
        border-color: #f5c6cb;
    }

    .parentrequest-item-meta {
        display: flex;
        align-items: center;
        gap: 1.5rem;
        color: #666;
        font-size: 0.85rem;
    }

    .parentrequest-meta-item {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .parentrequest-role-badge {
        padding: 0.25rem 0.75rem;
        background: #f8f9fa;
        color: #666;
        border-radius: 12px;
        font-size: 0.75rem;
        border: 1px solid #e9ecef;
    }

    .parentrequest-item-actions {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
    }

    .parentrequest-action-btn {
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 6px;
        font-size: 0.8rem;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .parentrequest-action-btn.detail {
        background: #e3f2fd;
        color: #1976d2;
    }

    .parentrequest-action-btn.detail:hover {
        background: #bbdefb;
    }

    .parentrequest-action-btn.approve {
        background: #e8f5e8;
        color: #2e7d32;
    }

    .parentrequest-action-btn.approve:hover {
        background: #c8e6c9;
    }

    .parentrequest-action-btn.reject {
        background: #ffebee;
        color: #c62828;
    }

    .parentrequest-action-btn.reject:hover {
        background: #ffcdd2;
    }

    @media (max-width: 1024px) {
        .parentrequest-content {
            grid-template-columns: 1fr;
        }
        
        .parentrequest-header-content {
            flex-direction: column;
            align-items: flex-start;
        }
        
        .parentrequest-search-filter {
            flex-direction: column;
            align-items: stretch;
        }
        
        .parentrequest-search-input {
            width: 100%;
        }
    }

    @media (max-width: 768px) {
        .parentrequest-container {
            padding: 1rem;
        }
        
        .parentrequest-title h1 {
            font-size: 2rem;
        }
        
        .parentrequest-item-content {
            flex-direction: column;
            gap: 1rem;
        }
        
        .parentrequest-item-meta {
            flex-direction: column;
            align-items: flex-start;
            gap: 0.5rem;
        }
        
        .parentrequest-date-grid {
            grid-template-columns: 1fr;
        }
    }

    @keyframes parentrequestFadeIn {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .parentrequest-form-section,
    .parentrequest-list-section {
        animation: parentrequestFadeIn 0.6s ease;
    }
</style>

<div class="parentrequest-container">
    <div class="parentrequest-header">
        <div class="parentrequest-header-content">
            <div class="parentrequest-title">
                <h1>Yêu cầu phụ huynh</h1>
                <p>Quản lý các yêu cầu nghỉ học cho con, nộp muộn học phí</p>
            </div>
            
            <div class="parentrequest-role-badge">
                👨‍👩‍👧‍👦 Phụ huynh
            </div>
        </div>
    </div>

    <div class="parentrequest-content">
        <div class="parentrequest-form-section">
            <div class="parentrequest-form-header">
                <div class="parentrequest-form-icon">➕</div>
                <h2 class="parentrequest-form-title">Tạo yêu cầu mới</h2>
            </div>

            <div class="parentrequest-form-content">
                <div class="parentrequest-form-group">
                    <label class="parentrequest-label">Loại yêu cầu</label>
                    <div class="parentrequest-type-grid" id="requestTypeGrid">
                        <button class="parentrequest-type-btn" data-type="student_break">
                            <div class="parentrequest-type-content">
                                <span class="parentrequest-type-icon">🏠</span>
                                <span class="parentrequest-type-label">Xin nghỉ cho con</span>
                            </div>
                        </button>
                        <button class="parentrequest-type-btn" data-type="late_fee_payment">
                            <div class="parentrequest-type-content">
                                <span class="parentrequest-type-icon">💰</span>
                                <span class="parentrequest-type-label">Xin nộp muộn học phí</span>
                            </div>
                        </button>
                    </div>
                </div>

                <div id="requestForm" style="display: none;">
                    <div class="parentrequest-form-group">
                        <label class="parentrequest-label">Tiêu đề yêu cầu</label>
                        <input type="text" class="parentrequest-input" id="requestTitle" placeholder="Nhập tiêu đề yêu cầu..." required>
                    </div>

                    <div class="parentrequest-form-group">
                        <label class="parentrequest-label">Mô tả chi tiết</label>
                        <textarea class="parentrequest-input parentrequest-textarea" id="requestDescription" placeholder="Mô tả chi tiết yêu cầu..."></textarea>
                    </div>

                    <div class="parentrequest-form-group" id="dateRangeGroup" style="display: none;">
                        <label class="parentrequest-label">Thời gian</label>
                        <div class="parentrequest-date-grid">
                            <div>
                                <label class="parentrequest-label">Từ ngày</label>
                                <input type="date" class="parentrequest-input" id="startDate">
                            </div>
                            <div>
                                <label class="parentrequest-label">Đến ngày</label>
                                <input type="date" class="parentrequest-input" id="endDate">
                            </div>
                        </div>
                    </div>

                    <button class="parentrequest-submit-btn" id="submitRequest">
                        📤 Gửi yêu cầu
                    </button>
                </div>
            </div>
        </div>

        <div class="parentrequest-list-section">
            <div class="parentrequest-list-header">
                <h2 class="parentrequest-list-title">Danh sách yêu cầu</h2>
                <div class="parentrequest-search-filter">
                    <div class="parentrequest-search-box">
                        <span class="parentrequest-search-icon">🔍</span>
                        <input type="text" class="parentrequest-search-input" placeholder="Tìm kiếm..." id="searchInput">
                    </div>
                    <button class="parentrequest-filter-btn" id="filterBtn">
                        🔧 Lọc
                    </button>
                </div>
            </div>

            <div class="parentrequest-list-content" id="requestList">
                <div class="parentrequest-item">
                    <div class="parentrequest-item-content">
                        <div class="parentrequest-item-main">
                            <div class="parentrequest-item-header">
                                <h3 class="parentrequest-item-title">Xin nghỉ cho con Nguyễn Văn A</h3>
                                <span class="parentrequest-status pending">Chờ duyệt</span>
                            </div>
                            <div class="parentrequest-item-meta">
                                <div class="parentrequest-meta-item">
                                    <span>👤</span>
                                    <span>Ông Nguyễn Văn B</span>
                                </div>
                                <div class="parentrequest-meta-item">
                                    <span>📅</span>
                                    <span>2024-06-15</span>
                                </div>
                                <span class="parentrequest-role-badge">👨‍👩‍👧‍👦 Phụ huynh</span>
                            </div>
                        </div>
                        <div class="parentrequest-item-actions">
                            <button class="parentrequest-action-btn detail">Xem chi tiết</button>
                            <button class="parentrequest-action-btn approve">Duyệt</button>
                            <button class="parentrequest-action-btn reject">Từ chối</button>
                        </div>
                    </div>
                </div>

                <div class="parentrequest-item">
                    <div class="parentrequest-item-content">
                        <div class="parentrequest-item-main">
                            <div class="parentrequest-item-header">
                                <h3 class="parentrequest-item-title">Xin nộp muộn học phí tháng 6</h3>
                                <span class="parentrequest-status approved">Đã duyệt</span>
                            </div>
                            <div class="parentrequest-item-meta">
                                <div class="parentrequest-meta-item">
                                    <span>👤</span>
                                    <span>Bà Trần Thị C</span>
                                </div>
                                <div class="parentrequest-meta-item">
                                    <span>📅</span>
                                    <span>2024-06-10</span>
                                </div>
                                <span class="parentrequest-role-badge">👨‍👩‍👧‍👦 Phụ huynh</span>
                            </div>
                        </div>
                        <div class="parentrequest-item-actions">
                            <button class="parentrequest-action-btn detail">Xem chi tiết</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll('.parentrequest-type-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.parentrequest-type-btn').forEach(b => b.classList.remove('selected'));
            this.classList.add('selected');
            
            document.getElementById('requestForm').style.display = 'block';
            
            const requestType = this.dataset.type;
            const dateRangeGroup = document.getElementById('dateRangeGroup');
            if (requestType === 'student_break') {
                dateRangeGroup.style.display = 'block';
            } else {
                dateRangeGroup.style.display = 'none';
            }
        });
    });

    document.getElementById('submitRequest').addEventListener('click', function() {
        const title = document.getElementById('requestTitle').value;
        const description = document.getElementById('requestDescription').value;
        const selectedType = document.querySelector('.parentrequest-type-btn.selected');
        
        if (!title || !selectedType) {
            alert('Vui lòng nhập tiêu đề và chọn loại yêu cầu!');
            return;
        }
        
        alert('Yêu cầu đã được gửi thành công!');
        
        document.getElementById('requestTitle').value = '';
        document.getElementById('requestDescription').value = '';
        document.getElementById('startDate').value = '';
        document.getElementById('endDate').value = '';
        document.getElementById('requestPriority').value = 'normal';
        document.getElementById('requestForm').style.display = 'none';
        document.querySelectorAll('.parentrequest-type-btn').forEach(b => b.classList.remove('selected'));
    });

    document.getElementById('searchInput').addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        const requestItems = document.querySelectorAll('.parentrequest-item');
        
        requestItems.forEach(item => {
            const title = item.querySelector('.parentrequest-item-title').textContent.toLowerCase();
            const requester = item.querySelector('.parentrequest-meta-item span:last-child').textContent.toLowerCase();
            
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

    document.querySelectorAll('.parentrequest-action-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const action = this.textContent.trim();
            const requestTitle = this.closest('.parentrequest-item').querySelector('.parentrequest-item-title').textContent;
            
            if (action === 'Xem chi tiết') {
                alert(`Xem chi tiết yêu cầu: ${requestTitle}`);
            } else if (action === 'Duyệt') {
                if (confirm(`Bạn có chắc muốn duyệt yêu cầu: ${requestTitle}?`)) {
                    this.closest('.parentrequest-item').querySelector('.parentrequest-status').className = 'parentrequest-status approved';
                    this.closest('.parentrequest-item').querySelector('.parentrequest-status').textContent = 'Đã duyệt';
                    this.remove();
                    this.nextElementSibling.remove();
                }
            } else if (action === 'Từ chối') {
                if (confirm(`Bạn có chắc muốn từ chối yêu cầu: ${requestTitle}?`)) {
                    this.closest('.parentrequest-item').querySelector('.parentrequest-status').className = 'parentrequest-status rejected';
                    this.closest('.parentrequest-item').querySelector('.parentrequest-status').textContent = 'Từ chối';
                    this.remove();
                    this.previousElementSibling.remove();
                }
            }
        });
    });
</script>

<jsp:include page="layout/footer.jsp" /> 