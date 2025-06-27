<%-- 
    Document   : managerDashboard
    Created on : Jun 26, 2025, 2:53:16 PM
    Author     : Minh Thu
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

    .chart-container {
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        padding: 20px;
        margin-bottom: 30px;
    }

    .table-container {
        background: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        padding: 20px;
    }

    .teacher-rank-table {
        width: 100%;
        border-collapse: collapse;
    }

    .teacher-rank-table th,
    .teacher-rank-table td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #eee;
    }

    .teacher-rank-table th {
        background-color: #f8f9fa;
        font-weight: 600;
        color: #333;
    }

    .teacher-rank-table tr:hover {
        background-color: #f8f9fa;
    }

    .rank-badge {
        display: inline-block;
        width: 30px;
        height: 30px;
        border-radius: 50%;
        text-align: center;
        line-height: 30px;
        font-weight: bold;
        color: white;
    }

    .rank-1 {
        background: #ffd700;
        color: #333;
    }
    .rank-2 {
        background: #c0c0c0;
        color: #333;
    }
    .rank-3 {
        background: #cd7f32;
        color: white;
    }
    .rank-other {
        background: #6c757d;
    }

    .revenue-amount {
        font-weight: 600;
        color: #28a745;
    }

    .section-title {
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 20px;
        color: #333;
    }

    .filter-controls select {
        min-width: 120px;
    }

    .quarterly-stats {
        padding: 15px;
        background: #f8f9fa;
        border-radius: 6px;
        height: 100%;
    }

    .quarter-item {
        padding: 10px 0;
        border-bottom: 1px solid #dee2e6;
    }

    .quarter-item:last-child {
        border-bottom: none;
    }

    .quarter-label {
        font-weight: 600;
        color: #495057;
    }

    .quarter-value {
        font-weight: 700;
        color: #28a745;
    }

    .quarter-comparison {
        font-size: 0.875rem;
    }

    .btn-group-sm .btn {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
    }

    #revenueChart {
        max-height: 300px;
    }
</style>
<div class="container-fluid">
    <div class="db-breadcrumb">
        <h4 class="breadcrumb-title">Bảng điều khiển</h4>
<ul class="db-breadcrumb-list">
            <li><a href="bang-dieu-khien"><i class="fa fa-home"></i>Bảng điều khiển</a></li>
            <li>Quản Lý</li>
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
                    <h4 class="wc-title text-center">Tổng lớp học</h4>
                </div>
                <div class="d-flex flex-column align-items-center justify-content-center" style="flex:1;">
                    <span class="wc-stats d-block" style="font-size: 2.5rem; line-height: 1;">
                        ${totalClass}
                    </span>
                    <span class="wc-des d-block mt-1">Lớp</span>
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
    <!-- Charts and Tables Section -->
    <div class="row mt-4">
        <!-- Revenue Chart -->
        <div class="col-lg-8 col-md-12">
            <div class="chart-container">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="section-title mb-0">
                        <i class="fa fa-pie-chart mr-2"></i>
                        Biểu đồ doanh thu theo quý
                    </h5>
                    <div class="filter-controls">
                        <select id="yearFilter" class="form-control form-control-sm d-inline-block" style="width: auto;">
                            <option value="2025">2025</option>
                            <option value="2024">2024</option>
                            <option value="2023">2023</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <canvas id="revenueChart" width="300" height="300"></canvas>
                    </div>
                    <div class="col-md-4">
                        <div class="quarterly-stats">
                            <h6 class="mb-3">Thống kê so sánh</h6>
                            <div id="quarterlyComparison">
                                <c:forEach var="quarter" items="${quarterlyRevenue}" varStatus="status">
                                    <div class="quarter-item mb-3">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="quarter-label">Quý ${quarter.quarter}</span>
                                            <span class="quarter-value">
                                                <fmt:formatNumber value="${quarter.revenue}" type="number" groupingUsed="true"/>
                                            </span>
                                        </div>
                                        <div class="quarter-comparison mt-1">
                                            <c:choose>
                                                <c:when test="${quarter.growthRate > 0}">
                                                    <small class="text-success">
                                                        <i class="fa fa-arrow-up"></i>
                                                        +<fmt:formatNumber value="${quarter.growthRate}" pattern="#.##"/>% so với quý trước
                                                    </small>
                                                </c:when>
                                                <c:when test="${quarter.growthRate < 0}">
                                                    <small class="text-danger">
<i class="fa fa-arrow-down"></i>
                                                        <fmt:formatNumber value="${quarter.growthRate}" pattern="#.##"/>% so với quý trước
                                                    </small>
                                                </c:when>
                                                <c:otherwise>
                                                    <small class="text-muted">
                                                        <i class="fa fa-minus"></i>
                                                        Không thay đổi
                                                    </small>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quarterly Revenue Summary -->
        <div class="col-lg-4 col-md-12">
            <div class="table-container">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="section-title mb-0">
                        <i class="fa fa-calendar mr-2"></i>
                        Doanh thu theo quý
                    </h5>
                    <div class="btn-group btn-group-sm" role="group">
                        <button type="button" class="btn btn-outline-primary active" data-period="current">Năm hiện tại</button>
                        <button type="button" class="btn btn-outline-primary" data-period="previous">Năm trước</button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-sm" id="quarterlyTable">
                        <thead>
                            <tr>
                                <th>Quý</th>
                                <th class="text-right">Doanh thu</th>
                                <th class="text-center">Tăng trưởng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="quarter" items="${quarterlyRevenue}" varStatus="status">
                                <tr>
                                    <td>
                                        <strong>Quý ${quarter.quarter}</strong>
                                        <br>
                                        <small class="text-muted">${quarter.year}</small>
                                    </td>
                                    <td class="text-right revenue-amount">
                                        <fmt:formatNumber value="${quarter.revenue}" type="number" groupingUsed="true"/> VNĐ
                                    </td>
<td class="text-center">
                                        <c:choose>
                                            <c:when test="${quarter.growthRate > 0}">
                                                <span class="badge badge-success">
                                                    +<fmt:formatNumber value="${quarter.growthRate}" pattern="#.#"/>%
                                                </span>
                                            </c:when>
                                            <c:when test="${quarter.growthRate < 0}">
                                                <span class="badge badge-danger">
                                                    <fmt:formatNumber value="${quarter.growthRate}" pattern="#.#"/>%
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-secondary">0%</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Summary Cards -->
                <div class="mt-3">
                    <div class="row">
                        <div class="col-6">
                            <div class="text-center p-2 bg-light rounded">
                                <small class="text-muted">Tổng doanh thu năm</small>
                                <div class="font-weight-bold text-primary">
                                    <fmt:formatNumber value="${totalYearRevenue}" type="number" groupingUsed="true"/> VNĐ
                                </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="text-center p-2 bg-light rounded">
                                <small class="text-muted">Tăng trưởng TB</small>
                                <div class="font-weight-bold ${averageGrowthRate >= 0 ? 'text-success' : 'text-danger'}">
                                    <fmt:formatNumber value="${averageGrowthRate}" pattern="#.#"/>%
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Teacher Ranking Section -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="table-container">
                <h5 class="section-title">
                    <i class="fa fa-trophy mr-2"></i>
                    Bảng xếp hạng giáo viên theo doanh thu
                </h5>
                <div class="table-responsive">
<table class="teacher-rank-table">
                        <thead>
                            <tr>
                                <th width="80">Hạng</th>
                                <th>Tên giáo viên</th>
                                <th>Email</th>
                                <th>Số lớp dạy</th>
                                <th>Số học viên</th>
                                <th class="text-right">Doanh thu</th>
                                <th class="text-center">Đánh giá TB</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="teacher" items="${topTeachers}" varStatus="status">
                                <tr>
                                    <td>
                                        <span class="rank-badge ${status.index < 3 ? 'rank-'+(status.index+1) : 'rank-other'}">
                                            ${status.index + 1}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <c:if test="${not empty teacher.avatar}">
                                                <img src="${teacher.avatar}" alt="Avatar" class="rounded-circle mr-2" width="40" height="40">
                                            </c:if>
                                            <c:if test="${empty teacher.avatar}">
                                                <div class="rounded-circle bg-secondary d-flex align-items-center justify-content-center mr-2" style="width: 40px; height: 40px;">
                                                    <i class="fa fa-user text-white"></i>
                                                </div>
                                            </c:if>
                                            <strong>${teacher.fullName}</strong>
                                        </div>
                                    </td>
                                    <td>${teacher.email}</td>
                                    <td>
                                        <span class="badge badge-info">${teacher.totalClasses}</span>
                                    </td>
                                    <td>
                                        <span class="badge badge-success">${teacher.totalStudents}</span>
                                    </td>
                                    <td class="text-right revenue-amount">
                                        <fmt:formatNumber value="${teacher.totalRevenue}" type="number" groupingUsed="true"/> VNĐ
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex align-items-center justify-content-center">
<span class="mr-1">
                                                <fmt:formatNumber value="${teacher.averageRating}" pattern="#.#"/>
                                            </span>
                                            <div class="text-warning">
                                                <c:forEach begin="1" end="${teacher.averageRating >= i ? 1 : 0}" var="i">
                                                    <i class="fa fa-star"></i>
                                                </c:forEach>
                                                <c:if test="${teacher.averageRating % 1 != 0}">
                                                    <i class="fa fa-star-half-o"></i>
                                                </c:if>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
<script>
$(document).ready(function() {
    // Chart variables
    let revenueChart;
    const ctx = document.getElementById('revenueChart').getContext('2d');
    
    // Chart configuration
    const chartColors = [
        '#FF6B6B', // Q1 - Coral Red
        '#4ECDC4', // Q2 - Turquoise  
        '#45B7D1', // Q3 - Sky Blue
        '#96CEB4'  // Q4 - Mint Green
    ];
    
    // Initialize the chart
    function initChart() {
        const quarterlyData = [
            <c:forEach var="quarter" items="${quarterlyRevenue}" varStatus="status">
                {
                    quarter: ${quarter.quarter},
                    year: ${quarter.year},
                    revenue: ${quarter.revenue},
                    growthRate: ${quarter.growthRate}
                }${!status.last ? ',' : ''}
            </c:forEach>
        ];
        
        const labels = quarterlyData.map(q => `Quý ${q.quarter}`);
        const data = quarterlyData.map(q => q.revenue);
        
        revenueChart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu',
                    data: data,
                    backgroundColor: chartColors,
                    borderColor: chartColors.map(color => color + '80'),
                    borderWidth: 3,
                    hoverOffset: 8,
                    cutout: '60%'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 15,
usePointStyle: true,
                            pointStyle: 'circle',
                            font: {
                                size: 12,
                                weight: '500'
                            }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        borderColor: '#333',
                        borderWidth: 1,
                        callbacks: {
                            label: function(context) {
                                const value = context.parsed;
                                const total = context.dataset.data.reduce((sum, val) => sum + val, 0);
                                const percentage = ((value / total) * 100).toFixed(1);
                                return `${context.label}: <fmt:formatNumber value="${value}" type="number" groupingUsed="true" /> VNĐ (${percentage}%)`;
                            }
                        }
                    }
                },
                animation: {
                    animateScale: true,
                    animateRotate: true,
                    duration: 1000
                }
            }
        });
    }
    
    // Format currency function
    function formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN').format(amount);
    }
    
    // Year filter change handler
    $('#yearFilter').on('change', function() {
        const selectedYear = $(this).val();
        showLoading();
        fetchQuarterlyData(selectedYear);
    });
    
    // Period toggle handler
    $('[data-period]').on('click', function() {
        const $this = $(this);
        const period = $this.data('period');
        
        // Update button states
        $('[data-period]').removeClass('active');
        $this.addClass('active');
        
        showLoading();
        togglePeriodData(period);
    });
    
    // Show loading state
    function showLoading() {
        $('#quarterlyTable tbody').html(`
            <tr>
                <td colspan="3" class="text-center py-4">
                    <div class="spinner-border spinner-border-sm text-primary" role="status">
                        <span class="sr-only">Đang tải...</span>
                    </div>
                    <span class="ml-2">Đang tải dữ liệu...</span>
                </td>
            </tr>
        `);
    }
    
    // Fetch quarterly data via AJAX
    function fetchQuarterlyData(year) {
        $.ajax({
            url: '/api/quarterly-revenue',
            method: 'GET',
            data: { year: year },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    updateChart(response.data);
                    updateTable(response.data);
updateSummary(response.summary);
                } else {
                    showError('Không thể tải dữ liệu. Vui lòng thử lại.');
                }
            },
            error: function(xhr, status, error) {
                console.error('AJAX Error:', error);
                showError('Lỗi kết nối. Vui lòng kiểm tra lại.');
            }
        });
    }
    
    // Toggle between current and previous year
    function togglePeriodData(period) {
        $.ajax({
            url: '/api/quarterly-revenue',
            method: 'GET',
            data: { period: period },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    updateTable(response.data);
                    updateSummary(response.summary);
                } else {
                    showError('Không thể tải dữ liệu so sánh.');
                }
            },
            error: function(xhr, status, error) {
                console.error('AJAX Error:', error);
                showError('Lỗi kết nối. Vui lòng thử lại.');
            }
        });
    }
    
    // Update chart with new data
    function updateChart(data) {
        const labels = data.map(q => `Quý ${q.quarter}`);
        const values = data.map(q => q.revenue);
        
        revenueChart.data.labels = labels;
        revenueChart.data.datasets[0].data = values;
        revenueChart.update('active');
    }
    
    // Update table with new data
    function updateTable(data) {
        const tbody = $('#quarterlyTable tbody');
        tbody.empty();
        
        if (data.length === 0) {
            tbody.html(`
                <tr>
                    <td colspan="3" class="text-center py-4 text-muted">
                        <i class="fa fa-info-circle mr-2"></i>
                        Không có dữ liệu cho khoảng thời gian này
                    </td>
                </tr>
            `);
            return;
        }
        
        data.forEach(function(quarter) {
            const growthBadge = getGrowthBadge(quarter.growthRate);
            const row = `
                <tr class="fade-in">
                    <td>
                        <strong>Quý ${quarter.quarter}</strong>
                        <br>
                        <small class="text-muted">${quarter.year}</small>
                    </td>
                    <td class="text-right revenue-amount">
                       <fmt:formatNumber value="${quarter.revenue}" type="number" groupingUsed="true" /> VND
                    </td>
                    <td class="text-center">
                        ${growthBadge}
                    </td>
                </tr>
            `;
            tbody.append(row);
        });
    }
    
    // Get growth rate badge HTML
    function getGrowthBadge(growthRate) {
        if (growthRate > 0) {
            return `<span class="badge badge-success">
<i class="fa fa-arrow-up mr-1"></i>
                        +${growthRate.toFixed(1)}%
                    </span>`;
        } else if (growthRate < 0) {
            return `<span class="badge badge-danger">
                        <i class="fa fa-arrow-down mr-1"></i>
                        ${growthRate.toFixed(1)}%
                    </span>`;
        } else {
            return `<span class="badge badge-secondary">
                        <i class="fa fa-minus mr-1"></i>
                        0%
                    </span>`;
        }
    }
    
    // Update summary cards
    function updateSummary(summary) {
        if (summary) {
            $('.total-year-revenue').text(formatCurrency(summary.totalRevenue) + ' VNĐ');
            $('.average-growth-rate').text(summary.averageGrowth.toFixed(1) + '%')
                .removeClass('text-success text-danger')
                .addClass(summary.averageGrowth >= 0 ? 'text-success' : 'text-danger');
        }
    }
    
    // Show error message
    function showError(message) {
        $('#quarterlyTable tbody').html(`
            <tr>
                <td colspan="3" class="text-center py-4 text-danger">
                    <i class="fa fa-exclamation-triangle mr-2"></i>
                    ${message}
                </td>
            </tr>
        `);
    }
    
    // Refresh data function
    function refreshData() {
        const currentYear = $('#yearFilter').val();
        const currentPeriod = $('[data-period].active').data('period');
        
        showLoading();
        
        if (currentPeriod) {
            togglePeriodData(currentPeriod);
        } else {
            fetchQuarterlyData(currentYear);
        }
    }
    
    // Auto refresh every 5 minutes (optional)
    setInterval(refreshData, 300000);
    
    // Initialize chart on page load
    initChart();
    
    // Handle window resize
    $(window).on('resize', function() {
        if (revenueChart) {
            revenueChart.resize();
        }
    });
});

// CSS animation for fade-in effect
const style = document.createElement('style');
style.textContent = `
    .fade-in {
        animation: fadeIn 0.5s ease-in;
    }
    
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    .spinner-border-sm {
        width: 1rem;
        height: 1rem;
    }
`;
document.head.appendChild(style);
</script>