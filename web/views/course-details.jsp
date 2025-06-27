<%-- 
    Document   : course-details
    Created on : May 28, 2025, 9:15:08 PM
    Author     : hungd
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<% request.setAttribute("title", "Thông tin lớp học");%>
<jsp:include page="layout/header.jsp" />

<style>
    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 24px; /* căn lề trái phải */
    }
    /* Layout chính */
    .course-main {
        display: flex;
        gap: 24px;
        margin-top: 20px;
    }

    /* Bên trái - Thông tin chính */
    .course-left {
        flex: 3;
    }

    /* Bên phải - Sidebar */
    .course-right {
        flex: 1.2;
        display: flex;
        flex-direction: column;
        gap: 24px;
    }

    /* Tiêu đề khóa học */
    .course-title {
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 10px;
    }

    /* Breadcrumb */
    .breadcrumb {
        padding-top: 30px;
        font-size: 14px;
        margin-bottom: 10px;
    }
    .breadcrumb a {
        color: #007bff;
        text-decoration: none;
    }
    .breadcrumb a:hover {
        text-decoration: underline;
    }

    .teacher-link {
        color: #007BFF;
        text-decoration: none;
        font-weight: 500;
    }

    .teacher-link:hover {
        text-decoration: underline;
    }

    .tab-navigation {
        background-color: #fff; /* cùng màu với nền trang */
        padding: 16px 0;
    }

    .tab-navigation ul {
        list-style: none;
        display: flex;
        justify-content: center;
        padding: 0;
        margin: 0 auto;
        gap: 0;
        background-color: #f5f5f5; /* màu của thanh điều hướng */
        border-radius: 8px;
        overflow: hidden;
        max-width: 720px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.05);
    }

    .tab-navigation ul li {
        flex: 1;
        text-align: center;
    }

    .tab-navigation ul li a {
        display: block;
        padding: 12px 0;
        text-decoration: none;
        color: #333;
        font-weight: 600;
        transition: background-color 0.3s ease;
    }

    .tab-navigation ul li a:hover {
        background-color: #e0ecff;
        color: #007bff;
    }


    /* Mỗi mục nội dung */
    .section {
        margin-top: 32px;
    }

    .course-title {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 12px;
        color: #2c3e50;
    }

    .course-left p {
        font-size: 16px;
        margin: 4px 0;
        color: #333;
    }

    .course-left strong {
        color: #2d3436;
        font-weight: 600;
    }

    .course-description {
        background-color: #f8f9fa;
        border-left: 4px solid #3498db;
        padding: 12px 16px;
        margin-top: 16px;
border-radius: 6px;
    }

    .course-description h5 {
        font-size: 18px;
        color: #2980b9;
        margin-bottom: 6px;
    }

    .course-description p {
        margin: 0;
        color: #444;
        font-size: 15px;
        line-height: 1.6;
    }

    .info-course {
        background-color: #f1f1f1;
        margin-top: 16px;
        padding: 10px 16px;
        border-radius: 6px;
        border: 1px solid #ddd;
    }

    .info-course p {
        margin: 6px 0;
        font-size: 15px;
        color: #333;
    }

    .info-course strong {
        color: #2c3e50;
    }


    /* Hộp nội dung */
    .info-box {
        background: #f9f9f9;
        border: 1px solid #ddd;
        border-radius: 6px;
        padding: 16px 20px;
        margin-bottom: 20px;
    }
    .info-box h4 {
        margin-bottom: 12px;
        font-size: 18px;
        color: #2c3e50;
    }
    .info-box ul {
        padding-left: 20px;
    }
    .info-box ul li {
        margin-bottom: 6px;
        line-height: 1.5;
    }

    /* Bảng giá */
    .price-block {
        background: #fff5e6; /* màu nền nhẹ nổi bật */
        border: 2px solid #f39c12;
        border-radius: 10px;
        padding: 20px 24px;
        margin-top: 20px;
        text-align: center;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        width: 100%;
    }

    .price-block .label {
        font-size: 16px;
        font-weight: 600;
        color: #e67e22;
        display: block;
        margin-bottom: 10px;
    }

    .price-final {
        font-size: 28px;
        font-weight: bold;
        color: #c0392b;
        margin-bottom: 6px;
    }

    .price-original {
        font-size: 16px;
        text-decoration: line-through;
        color: #999;
        margin-bottom: 4px;
    }

    .text-success {
        color: #27ae60;
        font-size: 14px;
        margin-bottom: 16px;
    }

    .register-btn {
        display: inline-block;
        background: #e74c3c;
        color: #fff;
        padding: 10px 22px;
        font-size: 16px;
        font-weight: bold;
        text-decoration: none;
        border-radius: 6px;
        transition: background 0.3s ease;
        margin-top: 8px;
    }

    .register-btn:hover {
        background: #c0392b;
    }

    .tab-content .section {
        padding-top: 40px;
        margin-top: 40px;
        border-top: 2px dashed #ccc; /* Thanh ngăn cách */
    }

    /* Container chung */
    #lich {
        padding: 24px;
        border-radius: 12px;
    }

    /* Tiêu đề */
    #lich h3 {
        font-size: 20px;
        margin-bottom: 16px;
        color: #333;
    }

    /* Form chọn tuần */
    #lich form {
        margin-bottom: 20px;
    }

    #lich select {
        padding: 8px 12px;
        font-size: 14px;
        border-radius: 8px;
        border: 1px solid #ccc;
        outline: none;
        background-color: #fff;
    }
/* Mỗi thẻ lịch học */
    .schedule-item {
        background-color: #eef6fb; /* Nền xanh nhạt */
        border-left: 5px solid #007bff; /* Viền màu nổi bật */
        border-radius: 12px;
        padding: 16px 20px;
        margin: 12px 0;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        width: 100%;
        max-width: 500px; /* Không chiếm hết chiều ngang */
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    /* Hover hiệu ứng */
    .schedule-item:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
    }

    /* Căn chỉnh dòng thông tin */
    .schedule-item strong {
        color: #2a2a2a;
        display: inline-block;
        min-width: 90px;
    }


    .teacher-section {
        margin-top: 40px;
        padding: 20px;
    }

    .teacher-info-wrapper {
        display: flex;
        gap: 20px;
        align-items: flex-start;
        flex-wrap: wrap;
        background-color: #f9f9f9;
        padding: 20px;
        border-radius: 12px;
    }

    .teacher-avatar img {
        width: 140px;
        height: 140px;
        object-fit: cover;
        border-radius: 8px;
        border: 2px solid #ddd;
    }

    .teacher-details {
        flex: 1;
    }

    .teacher-details p {
        margin-bottom: 8px;
        line-height: 1.6;
    }

    .teacher-awards ul {
        padding-left: 20px;
        margin-top: 5px;
    }

    .view-more-wrapper {
        margin-top: 12px;
    }

    .view-more-btn {
        background-color: #007bff;
        color: white;
        padding: 6px 14px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 500;
        transition: background-color 0.3s ease;
    }

    .view-more-btn:hover {
        background-color: #0056b3;
    }

    /* Khóa học liên quan */
    .related-wrapper {
        background: transparent;
        padding: 0;
        border: none ;
    }

    .related-courses-list {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    .related-course-link {
        text-decoration: none;
        color: inherit;
    }

    .related-course-item {
        display: flex;
        align-items: center;
        gap: 12px;
        border: 1px solid #ddd;
        padding: 10px;
        border-radius: 8px;
        background: #fff;
        margin: 0 10px; /* Cách lề trái/phải div tổng */
        transition: box-shadow 0.3s;
    }

    .related-course-item:hover {
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .related-img {
        width: 80px;
        height: 60px;
        object-fit: cover;
        border-radius: 6px;
    }

    .related-name {
        font-size: 14px;
        font-weight: 500;
    }

    .hidden {
        display: none;
    }

    .show-more-wrapper {
        text-align: center;
        margin-top: 12px;
    }

    .show-more-btn {
background-color: #007bff;
        color: white;
        border: none;
        padding: 6px 16px;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
    }

    .show-more-btn:hover {
        background-color: #0056b3;
    }


    /* Phản hồi khi không tìm thấy */
    .not-found {
        padding: 20px;
        background-color: #ffecec;
        border: 1px solid #e74c3c;
        color: #e74c3c;
        border-radius: 4px;
        text-align: center;
        margin-top: 40px;
    }

</style>



<div class="container">
    <c:choose>
        <c:when test="${not empty sessionScope.course}">
            <c:set var="course" value="${sessionScope.course}" />
            <c:set var="teacher" value="${sessionScope.teacher}" />

            <!-- PHẦN 1: Breadcrumb -->
            <div class="breadcrumb">
                <a href="trang-chu">Trang chủ </a> &gt;
                <form id="gradeForm" action="danh-sach-lop" method="post" style="display:inline;">
                    <input type="hidden" name="selectedGrade" value="${course.grade}" />
                    <a href="#" onclick="document.getElementById('gradeForm').submit(); return false;">
                        Lớp ${course.grade}
                    </a>
                </form>
                &gt; <span> ${course.name}</span>
            </div>

            <!-- PHẦN 2: Khối thông tin trên cùng -->
            <div class="course-main">
                <!-- Bên trái: thông tin khóa học + mô tả -->
                <div class="course-left">
                    <h1 class="course-title">${course.name}</h1>
                    <p><strong>Môn học:</strong> ${course.subject.displayName}</p>
                    <p><strong>Giáo viên:</strong>
                        <c:choose>
                            <c:when test="${not empty sessionScope.teacherMap[course.teacherId]}">
                                <a href="thong-tin-giao-vien?teacherId=${course.teacherId}" class="teacher-link">
                                    <c:out value="${sessionScope.teacherMap[course.teacherId].name}" />
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span>Đang cập nhật</span>
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <p><strong>Loại khóa học:</strong> ${course.courseType.displayName}</p>
                    <div class="course-description">
                        <h5>Tổng quan khóa học: </h5>
                        <p>${course.description}</p>
                    </div>
                    <div class="info-course">
                        <p><strong>Số học sinh tham gia:</strong> ${course.studentEnrollment}/${course.maxStudents}</p>
<p><strong>Khai giảng:</strong> ${sessionScope.startFormatted}</p>
                        <p><strong>Bế giảng:</strong> ${sessionScope.endFormatted}</p>
                    </div>

                    <!-- PHẦN 3: Điều hướng nội dung -->
                    <div class="tab-navigation">
                        <ul>
                            <li><a href="#mota">Mô tả khóa học</a></li>
                            <li><a href="#lich">Lịch học</a></li>
                            <li><a href="#giaovien">Giáo viên</a></li>
                        </ul>
                    </div>

                    <!-- PHẦN 4: Nội dung từng mục -->
                    <div class="tab-content">
                        <!-- Mô tả -->
                        <div id="mota" class="section">
                            <h3>Mô tả khóa học</h3>
                            <div class="info-box">
                                <h4>Mục tiêu khóa học</h4>
                                <ul>
                                    <li>Nắm chắc kiến thức nền tảng môn học ${course.subject.displayName} lớp ${course.grade}</li>
                                    <li>Rèn luyện tư duy logic, phân tích và phản biện</li>
                                    <li>Phát triển kỹ năng tự học, tự kiểm tra và làm bài tập</li>
                                    <li>Đáp ứng tốt các yêu cầu kiểm tra – đánh giá trên lớp</li>
                                </ul>
                            </div>

                            <div class="info-box">
                                <h4>Phương pháp tiếp cận</h4>
                                <ul>
                                    <li>Giáo viên ${sessionScope.teacherMap[course.teacherId].name} sử dụng tài liệu, hình ảnh trực quan, thí nghiệm (nếu có) để minh họa sinh động</li>
                                    <li>Giảng dạy theo mô hình tương tác: hướng dẫn – luyện tập – sửa bài – điều chỉnh</li>
                                    <li>Kết hợp bài tập tự luyện và đánh giá định kỳ</li>
                                    <li>Phát triển toàn diện kỹ năng trình bày, phân tích và tự kiểm tra</li>
                                </ul>
                            </div>

                            <div class="info-box">
                                <h4>Đặc điểm nổi bật</h4>
                                <ul>
                                    <li>Chương trình học bám sát định hướng mới của Bộ GD&ĐT</li>
                                    <li>Học sinh được hỗ trợ trực tiếp bởi giáo viên và hệ thống tài liệu chất lượng</li>
                                    <li>Tài liệu được biên soạn riêng theo từng chủ đề, phân tầng theo năng lực</li>
                                    <li>Phù hợp cả với học sinh trung bình – khá – giỏi</li>
                                </ul>
                            </div>
<div class="info-box">
                                <h4>Đối tượng phù hợp</h4>
                                <ul>
                                    <li>Học sinh lớp ${course.grade} cần củng cố và nâng cao môn ${course.subject.displayName}</li>
                                    <li>Học sinh muốn thi chuyển cấp, thi học sinh giỏi hoặc vào lớp chuyên</li>
                                    <li>Phụ huynh cần tìm lớp học thêm có định hướng rõ ràng và kiểm tra đều đặn</li>
                                </ul>
                            </div>
                        </div>

                        <!-- Lịch học -->
                        <div id="lich" class="section">
                            <h3>Lịch học</h3>
                            <form method="post" action="thong-tin-lop-hoc">
                                <input type="hidden" name="courseId" value="${course.id}" />
                                <label>Chọn khoảng thời gian:</label>
                                <select name="startDate" onchange="this.form.submit()">
                                    <c:forEach var="week" items="${sessionScope.weekOptions}">
                                        <option value="${week[0]}" ${week[0] == sessionScope.startDate ? 'selected' : ''}>
                                            ${week[1]}
                                        </option>
                                    </c:forEach>
                                </select>
                            </form>
                            <c:forEach var="section" items="${sessionScope.schedules}">
                                <div class="schedule-item">
                                    <strong>Thứ:</strong> ${section.dayOfWeek.displayName}<br>
                                    <strong>Thời gian:</strong> ${section.startTime.toLocalTime().toString().substring(0,5)} - ${section.endTime.toLocalTime().toString().substring(0,5)}<br>
                                    <strong>Địa điểm:</strong> ${section.classroom}
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Giáo viên -->
                        <div id="giaovien" class="section teacher-section">
                            <h3>Giáo viên giảng dạy</h3>
                            <div class="teacher-info-wrapper">
                                <div class="teacher-avatar">
                                    <img src="${pageContext.request.contextPath}/assets/avatars/${sessionScope.teacherMap[course.teacherId].avatarURL}" alt="Ảnh giáo viên" />
                                </div>
                                <div class="teacher-details">
                                    <p><strong>Họ và tên:</strong> ${sessionScope.teacherMap[course.teacherId].name}</p>

                                    <c:if test="${not empty teacher.bio}">
<p><strong>Giới thiệu:</strong> ${teacher.bio}</p>
                                    </c:if>

                                    <c:if test="${not empty sessionScope.certOfTeacher}">
                                        <div class="teacher-awards">
                                            <p><strong>Thành tích nổi bật:</strong></p>
                                            <ul>
                                                <c:forEach var="cert" items="${sessionScope.certOfTeacher}">
                                                    <li>${cert.certificateName} (${sessionScope.certYearMap[cert.id]})</li>
                                                    </c:forEach>
                                            </ul>
                                        </div>
                                    </c:if>

                                    <div class="view-more-wrapper">
                                        <a href="thong-tin-giao-vien?teacherId=${teacher.id}" class="view-more-btn">Xem thêm thông tin giáo viên</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bên phải: học phí và khóa học liên quan -->
                <div class="course-right">
                    <div class="price-block">
                        <span class="label">${sessionScope.priceLabel}</span>
                        <c:choose>
                            <c:when test="${sessionScope.hasDiscount}">
                                <div class="price-original">${sessionScope.originalPriceStr}</div>
                                <div class="price-final">${sessionScope.finalPriceStr}</div>
                                <p class="text-success">Tiết kiệm ${course.discountPercentage}%</p>
                            </c:when>
                            <c:otherwise>
                                <div class="price-final">${sessionScope.originalPriceStr}</div>
                            </c:otherwise>
                        </c:choose>

                        <a href="#" class="register-btn">Đăng ký học ngay</a>
                    </div>

                    <div class="info-box related-wrapper">
                        <h4>Khóa học liên quan</h4>
                        <div class="related-courses-list">
                            <c:forEach var="related" items="${sessionScope.relatedCourses}" varStatus="status">
                                <a href="thong-tin-lop-hoc?courseId=${related.id}" class="related-course-link ${status.index >= 5 ? 'hidden' : ''}">
                                    <div class="related-course-item">
                                        <img src="${pageContext.request.contextPath}/assets/banners_course/${related.course_img}" alt="${related.name}" class="related-img" />
<span class="related-name">${related.name}</span>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                        <div class="show-more-wrapper">
                            <button class="show-more-btn" onclick="toggleRelated()">Xem thêm</button>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="not-found">
                Không tìm thấy thông tin khóa học.
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    let isExpanded = false;

    function toggleRelated() {
        const hiddenItems = document.querySelectorAll(".related-course-link.hidden");
        const btn = document.querySelector(".show-more-btn");

        if (!isExpanded) {
            hiddenItems.forEach(item => item.classList.remove("hidden"));
            btn.innerText = "Ẩn bớt";
        } else {
            hiddenItems.forEach((item, index) => {
                if (index >= 0)
                    item.classList.add("hidden");
            });
            btn.innerText = "Xem thêm";
        }

        isExpanded = !isExpanded;
    }
</script>


<jsp:include page="layout/footer.jsp" />
