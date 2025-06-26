<%-- 
    Document   : course-list
    Created on : May 28, 2025, 3:24:04 PM
    Author     : hungd
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display&display=swap" rel="stylesheet">

<!DOCTYPE html>
<% request.setAttribute("title", "Danh sách lớp học");%>
<jsp:include page="layout/header.jsp" />

<style>
    :root {
        --primary-color: #7e3ff2;
        --secondary-color: #f3f4f6;
        --text-color: #1f2937;
        --tag-color: #9333ea;
        --radius: 16px;
        --shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
    }

    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(to bottom, #1e005e, #7e3ff2 40%, #f9fafb 40%);
        background-repeat: no-repeat;
        background-size: cover;
        color: var(--text-color);
    }

    .course-page {
        width: 100%;
        margin: 0 auto;
    }

    /* ======== Banner ======== */
    .featured-banner {
        background-image: url('${pageContext.request.contextPath}/assets/banners_course/banner.jpg');
        background-size: cover;
        background-position: center right;
        background-repeat: no-repeat;
        color: #111827;
        text-shadow: 0 1px 3px rgba(255, 255, 255, 0.8);
        padding: 60px 80px;
        min-height: 350px;
        border-bottom-left-radius: 50px;
        border-bottom-right-radius: 50px;
        position: relative;
        z-index: 1;
        display: flex;
        justify-content: center;
        align-items: center;
        overflow: hidden;
    }

    .banner-content {
        max-width: 70%; /* tuỳ bạn điều chỉnh */
        text-align: center;
    }

    .banner-content h1 {
        font-family: 'Playfair Display', serif;
        font-size: 3.5em;
        font-weight: 700;
        line-height: 1.2;
        margin-bottom: 20px;
    }

    .quote-author {
        font-size: 1.2em;
        font-weight: 400;
        font-style: italic;
        margin-top: -10px;
        color: #374151; /* Màu xám đậm */
    }


    @media (max-width: 992px) {
        .featured-banner {
            flex-direction: column;
            text-align: center;
            padding: 40px 30px;
            background-position: center center;
            min-height: 300px;
            border-bottom-left-radius: 40px;
            border-bottom-right-radius: 40px;
        }

        .banner-content {
            max-width: 100%;
            margin-bottom: 30px;
        }

        .banner-content h1 {
            font-size: 2.5em;
        }
    }

    @media (max-width: 768px) {
        .featured-banner {
            min-height: 250px;
            border-bottom-left-radius: 30px;
            border-bottom-right-radius: 30px;
        }
        .banner-content h1 {
            font-size: 2em;
        }
    }

    @media (max-width: 480px) {
        .featured-banner {
            min-height: 200px;
            padding: 30px 20px;
            border-bottom-left-radius: 20px;
            border-bottom-right-radius: 20px;
        }
        .banner-content h1 {
            font-size: 1.8em;
        }
    }

    /* ======== Main Container ======== */
    .main-container {
        display: flex;
        gap: 40px;
        margin-top: -50px;
        padding: 40px 80px;
        background: white;
        border-radius: 40px;
        box-shadow: var(--shadow);
        position: relative;
        z-index: 10;
        flex-wrap: wrap;
    }

    /* ======== Sidebar ======== */
    .course-sidebar {
        flex: 1;
        min-width: 250px;
    }

    .search-bar {
        display: flex;
        margin-bottom: 20px;
        border: 1px solid #ccc;
        border-radius: var(--radius);
        overflow: hidden;
    }

    .search-bar input {
        flex: 1;
        border: none;
        padding: 10px;
        outline: none;
    }

    .search-bar button {
        background-color: var(--primary-color);
        color: white;
        border: none;
        padding: 0 16px;
        cursor: pointer;
    }

    .filter-section .section-title {
        font-weight: bold;
        font-size: 1.2rem;
        margin-bottom: 16px;
    }

    .filter-form select,
    .filter-submit {
        width: 100%;
        padding: 10px;
        margin-top: 10px;
        border: 1px solid #ddd;
        border-radius: var(--radius);
        background: white;
        font-size: 0.95rem;
    }

    .filter-submit {
        background-color: var(--primary-color);
        color: white;
        border: none;
        cursor: pointer;
        transition: 0.2s;
    }

    .filter-submit:hover {
        background-color: #5b21b6;
    }

    /* ======== Course List ======== */
    .course-list {
        flex: 3;
        width: 100%;
    }

    .section-heading {
        font-size: 1.6rem;
        font-weight: bold;
        color: var(--primary-color);
        margin-bottom: 24px;
    }

    .grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 24px;
    }

    .course-card {
        background: white;
        border-radius: var(--radius);
        box-shadow: var(--shadow);
        transition: transform 0.2s ease;
        cursor: pointer;
        padding: 0;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        position: relative;
    }

    .course-card:hover {
        transform: translateY(-5px);
    }

    .course-tags {
        position: absolute;
        top: 10px;
        left: 10px;
        z-index: 2;
    }

    .tag-discount {
        background-color: #f43f5e;
        color: white;
        padding: 4px 8px;
        font-size: 0.75rem;
        border-radius: 6px;
    }

    .course-content {
        padding: 16px;
    }

    .course-content h5 {
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 8px;
    }

    .course-content p {
        font-size: 0.9rem;
        margin: 4px 0;
        color: #374151;
    }

    .teacher-link {
        color: var(--primary-color);
        text-decoration: underline;
    }

    .card-image {
        width: 100%;
        aspect-ratio: 4 / 3.4;
        overflow: hidden;
        border-top-left-radius: var(--radius);
        border-top-right-radius: var(--radius);
        position: relative;
        background: #f3f4f6;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .card-image img {
        width: 100%;
        height: 100%;
        object-fit: contain;
        display: block;
        transition: 0.3s;
        padding: 8px;
    }

    .card-image img:hover {
        transform: scale(1.02);
    }

    /* Badge HOT ở bên trái */
    .hot-badge {
        position: absolute;
        top: 10px;
        left: 10px;
        background-color: #f97316; /* màu cam */
        color: white;
        padding: 4px 8px;
        font-size: 0.75rem;
        border-radius: 6px;
        font-weight: bold;
        z-index: 2;
    }

    /* Badge Giảm giá ở bên phải */
    .discount-badge {
        position: absolute;
        top: 10px;
        right: 10px;
        background-color: #ef4444;
        color: white;
        font-size: 0.75rem;
        padding: 4px 8px;
        border-radius: 8px;
        font-weight: bold;
        z-index: 2;
    }

    .course-content {
        padding: 16px;
        margin-top: auto;
    }

    .course-content h5 {
        font-size: 1rem;
        font-weight: bold;
        margin-bottom: 8px;
        color: var(--text-color);
    }

    .course-content p {
        font-size: 0.9rem;
        margin: 4px 0;
    }

    .course-content p a {
        color: #007bff;
        text-decoration: none;
        font-weight: 500;
        transition: color 0.3s ease;
    }

    .course-content p a:hover {
        color: #0056b3;
        text-decoration: underline;
    }

    /* ======== Pagination ======== */
    .pagination-container {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 8px;
        margin-top: 30px;
        font-family: 'Segoe UI', sans-serif;
        font-size: 1rem;
    }

    .pagination-container button {
        background: none;
        border: none;
        font-weight: bold;
        color: #1f2937;
        cursor: pointer;
        padding: 6px 12px;
        transition: background 0.2s ease;
    }

    .pagination-container button:hover {
        background-color: #f3f4f6;
        border-radius: 6px;
    }

    .page-number {
        padding: 6px 12px;
        cursor: pointer;
        border-radius: 8px;
        transition: background 0.2s ease;
    }

    .page-number:hover {
        background-color: #f3f4f6;
    }

    .active-page {
        background-color: #e5e7eb;
        font-weight: bold;
    }

    /* ======== Review Section ======== */
    .review-section {
        background-color: white;
        padding: 60px 80px;
        margin-top: 80px;
        border-top: 1px solid #eee;
        border-radius: var(--radius);
    }

    .reviews {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    .review-item {
        background-color: #f3f4f6;
        padding: 16px 20px;
        border-radius: var(--radius);
        font-style: italic;
        color: #333;
    }

    /* ======== Responsive ======== */
    @media (max-width: 768px) {
        .main-container {
            flex-direction: column;
            padding: 30px 20px;
        }

        .grid {
            grid-template-columns: repeat(auto-fill, minmax(100%, 1fr));
        }

        .featured-banner {
            font-size: 1.4rem;
            padding-bottom: 120px;
        }

        .review-section {
            padding: 40px 20px;
        }
    }
</style>


<div class="course-page">
    <!-- Banner nổi bật -->
    <section class="featured-banner">
        <div class="banner-content">
            <h1>Học - Học nữa - Học mãi</h1>
            <p class="quote-author">— V.I. Lenin —</p>
        </div>
    </section>


    <div class="main-container">
        <!-- SIDEBAR -->
        <aside class="course-sidebar">
            <form action="<c:url value='/danh-sach-lop'/>" method="POST" class="search-bar">
                <input type="text" name="keyword" placeholder="Tìm kiếm khóa học..." required />
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>

            <div class="filter-section">
                <div class="section-title">Lọc khóa học</div>
                <form action="<c:url value='/danh-sach-lop'/>" method="POST" class="filter-form">

                    <!-- Khối,Môn học,Mức độ,Loại khóa học -->
                    <div class="filter-group">
                        <select name="selectedGrade">
                            <option value="Tất cả" <c:if test="${empty requestScope.selectedGrade || requestScope.selectedGrade eq 'Tất cả'}">selected</c:if>>Khối</option>
                            <c:forEach var="i" begin="6" end="12">
                                <c:set var="gradeLabel" value="Lớp ${i}" />
                                <option value="${gradeLabel}"
                                        <c:if test="${requestScope.selectedGrade eq gradeLabel}">selected</c:if>>
                                    ${gradeLabel}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group">
                        <select name="selectedSubject">
                            <option value="Tất cả" <c:if test="${empty requestScope.selectedSubject || requestScope.selectedSubject eq 'Tất cả'}">selected</c:if>>Môn học</option>
                            <c:forEach var="subject" items="${sessionScope.subjectList}">
                                <option value="${subject.name()}"
                                        <c:if test="${requestScope.selectedSubject eq subject.name()}">selected</c:if>>
                                    ${subject.displayName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>


                    <div class="filter-group">
                        <select name="selectedLevel">
                            <option value="Tất cả" <c:if test="${empty requestScope.selectedLevel || requestScope.selectedLevel eq 'Tất cả'}">selected</c:if>>Trình độ</option>
                            <c:forEach var="level" items="${sessionScope.levelList}">
                                <option value="${level.name()}"
                                        <c:if test="${requestScope.selectedLevel eq level.name()}">selected</c:if>>
                                    ${level.displayName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="filter-group">
                        <select name="selectedType">
                            <option value="Tất cả" <c:if test="${empty requestScope.selectedType || requestScope.selectedType eq 'Tất cả'}">selected</c:if>>Gói học</option>
                            <c:forEach var="type" items="${sessionScope.typeCourseList}">
                                <option value="${type.name()}"
                                        <c:if test="${requestScope.selectedType eq type.name()}">selected</c:if>>
                                    ${type.displayName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>


                    <div class="filter-group">
                        <button type="submit" class="filter-submit">Tìm khóa học</button>
                    </div>
                </form>
            </div>
        </aside>

        <!-- COURSE LIST -->
        <main class="course-list">
            <h2 class="section-heading">${requestScope.coursePageTitle}</h2>
            <c:if test="${empty sessionScope.courseList}">
                <p class="no-course-text">Không có khóa học nào.</p>
            </c:if>

            <c:if test="${not empty sessionScope.courseList}">
                <div class="grid" id="courseGrid">
                    <c:forEach var="course" items="${sessionScope.courseList}" varStatus="status">
                        <div class="course-card page-item" data-page="${(status.index div 12) + 1}" onclick="goToCourseDetail('${course.id}')">
                            <div class="card-image">
                                <img src="${pageContext.request.contextPath}/assets/banners_course/${course.course_img}" alt="Hình khóa học" />

                                <!-- Discount badge: bên trái -->
                                <c:if test="${course.discountPercentage > 0}">
                                    <div class="discount-badge">-${course.discountPercentage}%</div>
                                </c:if>

                                <!-- Hot badge: bên phải -->
                                <c:if test="${course.isHot}">
                                    <div class="hot-badge">HOT</div>
                                </c:if>
                            </div>

                            <div class="course-content">
                                <h5>${course.name}</h5>
                                <p><strong>Giáo viên :</strong>
                                    <a href="thong-tin-giao-vien?teacherId=${course.teacherId}" onclick="event.stopPropagation();">
                                        <c:out value="${sessionScope.teacherMap[course.teacherId].name}" />
                                    </a>
                                </p>
                                <p><strong>Thời lượng :</strong> ${course.weekAmount} tuần</p>
                            </div>

                        </div>                    
                    </c:forEach>
                </div>

                <div id="pagination" class="pagination-container">
                    <div id="pagination" class="pagination-container">
                        <button id="prevBtn" onclick="changePage(-1)">← Previous</button>
                        <span id="pagination-numbers"></span>
                        <button id="nextBtn" onclick="changePage(1)">Next →</button>
                    </div>
                </div>
            </c:if>
        </main>
    </div>

    <section class="review-section">
        <h2 class="section-heading">Chia sẻ của phụ huynh và học sinh</h2>
        <div class="reviews">
            <div class="review-item">"Trang rất dễ sử dụng và nhiều khóa học hay."</div>
            <div class="review-item">"Giáo viên giỏi và nhiệt tình, mình học được rất nhiều!"</div>
        </div>
    </section>
</div>

<!-- ========================== JAVASCRIPT ========================== -->
<script>
    let currentPage = 1;
    const itemsPerPage = 12;

    function changePage(delta) {
        const items = document.querySelectorAll('.page-item');
        const totalPages = Math.ceil(items.length / itemsPerPage);
        currentPage += delta;
        currentPage = Math.max(1, Math.min(currentPage, totalPages));
        renderCourses(items, totalPages);
    }

    function goToPage(page) {
        const items = document.querySelectorAll('.page-item');
        const totalPages = Math.ceil(items.length / itemsPerPage);
        currentPage = page;
        renderCourses(items, totalPages);
    }

    function renderCourses(items, totalPages) {
        items.forEach(item => {
            item.style.display = (parseInt(item.dataset.page) === currentPage) ? 'block' : 'none';
        });
        renderPagination(totalPages);
    }


    function renderPagination(totalPages) {
        const container = document.getElementById('pagination-numbers');
        container.innerHTML = '';

        let maxPagesToShow = 5;
        let pages = [];

        if (totalPages <= maxPagesToShow) {
            for (let i = 1; i <= totalPages; i++)
                pages.push(i);
        } else {
            if (currentPage <= 3) {
                pages = [1, 2, 3, 4, '...', totalPages];
            } else if (currentPage >= totalPages - 2) {
                pages = [1, '...', totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
            } else {
                pages = [1, '...', currentPage - 1, currentPage, currentPage + 1, '...', totalPages];
            }
        }

        pages.forEach(p => {
            const span = document.createElement('span');
            if (p === '...') {
                span.textContent = '...';
            } else {
                span.textContent = p;
                span.classList.add('page-number');
                if (p === currentPage)
                    span.classList.add('active-page');
                span.onclick = () => goToPage(p);
            }
            container.appendChild(span);
        });
    }

    window.onload = function () {
        const items = document.querySelectorAll('.page-item');
        const totalPages = Math.ceil(items.length / itemsPerPage);
        renderCourses(items, totalPages);
    }

    function goToCourseDetail(courseId) {
        window.location.href = 'thong-tin-lop-hoc?courseId=' + courseId;
    }
</script>

<jsp:include page="layout/footer.jsp" />
