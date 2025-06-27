<%-- 
    Document   : createScore
    Created on : Jun 20, 2025, 9:06:50 PM
    Author     : vankh
--%>

<%-- 
    Document   : createScore
    Created on : Jun 20, 2025, 9:06:50 PM
    Author     : vankh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<jsp:include page="layout/header.jsp" />
<style>
    .page-container {
        padding: 20px;
        max-width: 1200px;
        margin: 0 auto;
    }

    .header-section {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        flex-wrap: wrap;
        gap: 15px;
    }

    .info-card {
        background-color: white;
        border-radius: 10px;
        padding: 20px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        width: 100%;
    }

    .info-container {
        display: flex;
        flex-direction: column;
        gap: 16px; /* Khoảng cách đều giữa các dòng */
    }

    /* Các dòng đều sử dụng chung class */
    .info-row {
        display: flex;
        width: 100%;
    }

    /* Dòng 1: Khối + Lớp + Môn */
    .info-multi-items {
        gap: 20px; /* Khoảng cách giữa các item trong cùng dòng */
    }

    /* Các item trong dòng */
    .info-item {
        flex: 1;
        display: flex;
        align-items: center; /* Căn giữa theo chiều dọc */
        min-height: 24px; /* Đảm bảo chiều cao tối thiểu bằng nhau */
    }

    /* Label và value */
    .info-label {
        font-weight: 600;
        color: #555;
        width: 130px;
        flex-shrink: 0; /* Không bị co lại */
    }

    .info-value {
        color: #222;
        font-weight: 500;
        flex-grow: 1;
    }

    /* Tên khóa học */
    .course-name {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .info-multi-items {
            flex-direction: column;
            gap: 12px;
        }

        .info-item {
            width: 100%;
        }

        .course-name {
            white-space: normal;
        }
    }

    .search-container {
        margin: 20px 0;
    }

    .search-form {
        --timing: 0.3s;
        --width-of-input: 300px;
        --height-of-input: 42px;
        --border-height: 2px;
        --input-bg: #f8f9fa;
        --border-color: #4285f4;
        --border-radius: 8px;
        position: relative;
        width: 100%;
        max-width: 400px;
        height: var(--height-of-input);
        display: flex;
        align-items: center;
        padding-inline: 15px;
        border-radius: var(--border-radius);
        background: var(--input-bg);
        border: 1px solid #ddd;
        transition: all 0.3s ease;
    }

    .search-form:focus-within {
        border-color: var(--border-color);
        box-shadow: 0 0 0 2px rgba(66, 133, 244, 0.2);
    }

    .search-input {
        font-size: 14px;
        background-color: transparent;
        width: 100%;
        height: 100%;
        padding-inline: 10px;
        border: none;
        outline: none;
    }

    .search-button {
        border: none;
        background: none;
        color: #6c757d;
        cursor: pointer;
    }

    .reset-button {
        border: none;
        background: none;
        opacity: 0;
        visibility: hidden;
        cursor: pointer;
        color: #6c757d;
        transition: opacity 0.2s;
    }

    .search-input:not(:placeholder-shown) ~ .reset-button {
        opacity: 1;
        visibility: visible;
    }

    .table-container {
        background: white;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        padding: 20px;
        margin-top: 20px;
        overflow-x: auto;
    }

    .table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }

    .table th {
        background-color: #f8f9fa;
        font-weight: 600;
        color: #495057;
        padding: 12px 15px;
        text-align: center;
        border-bottom: 2px solid #e9ecef;
    }

    .table td {
        padding: 12px 15px;
        text-align: center;
        border-bottom: 1px solid #e9ecef;
        vertical-align: middle;
    }

    .table tr:hover {
        background-color: #f8f9fa;
    }

    .score-input {
        width: 80px;
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 6px;
        text-align: center;
        font-size: 14px;
        transition: all 0.3s;
    }

    .score-input:focus {
        border-color: #4285f4;
        box-shadow: 0 0 0 2px rgba(66, 133, 244, 0.2);
        outline: none;
    }

    .submit-btn {
        background-color: #4285f4;
        color: white;
        border: none;
        padding: 10px 25px;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s;
        margin-top: 20px;
        float: right;
    }

    .submit-btn:hover {
        background-color: #3367d6;
    }

    .highlight {
        background-color: #fff8e1 !important;
    }

    @media (max-width: 768px) {
        .info-grid {
            grid-template-columns: 1fr;
        }

        .table th, .table td {
            padding: 10px 8px;
            font-size: 13px;
        }

        .score-input {
            width: 70px;
            padding: 6px 8px;
        }
    }
</style>

<div class="page-container">
    <div class="header-section">
        <div class="info-card">
            <div class="info-container">
                <div class="info-row info-multi-items">
                    <div class="info-item">
                        <span class="info-label">Lớp :</span>
                        <span class="info-value">${grade}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Cấp độ:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${level == 'Advanced'}">Nâng cao</c:when>
                                <c:when test="${level == 'Basic'}">Cơ bản</c:when>
                                <c:when test="${level == 'Topics_Exam'}">Luyện thi</c:when>
                                <c:otherwise>${level}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Môn:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${subject == 'Mathematics'}">Toán</c:when>
                                <c:when test="${subject == 'Literature'}">Ngữ văn</c:when>
                                <c:when test="${subject == 'English'}">Tiếng Anh</c:when>
                                <c:when test="${subject == 'Physics'}">Vật lý</c:when>
                                <c:when test="${subject == 'Chemistry'}">Hóa học</c:when>
                                <c:when test="${subject == 'Biology'}">Sinh học</c:when>
                                <c:when test="${subject == 'History'}">Lịch sử</c:when>
                                <c:when test="${subject == 'Geography'}">Địa lý</c:when>
                                <c:when test="${subject == 'Civic Education'}">Giáo dục công dân</c:when>
                                <c:when test="${subject == 'Informatics'}">Tin học</c:when>
                                <c:otherwise>${subject}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label">Tên khóa học:</span>
                        <span class="info-value course-name">${nameCourse}</span>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-item">
                        <span class="info-label">Số học sinh:</span>
                        <span class="info-value">${currentEnrollment}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="search-container">
        <form class="search-form">
            <button type="button" class="search-button">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M11 19C15.4183 19 19 15.4183 19 11C19 6.58172 15.4183 3 11 3C6.58172 3 3 6.58172 3 11C3 15.4183 6.58172 19 11 19Z" stroke="#6c757d" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M21 21L16.65 16.65" stroke="#6c757d" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </button>
            <input class="search-input" id="searchStudent" placeholder="Tìm kiếm học sinh..." type="text">
            <button type="reset" class="reset-button">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M18 6L6 18" stroke="#6c757d" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M6 6L18 18" stroke="#6c757d" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </button>
        </form>
    </div>

    <div class="table-container">
        <form action="createScore" method="post" onsubmit="return validateScores(event)">
            <input type="hidden" name="courseId" value="${courseId}" />
            <input type="hidden" name="grade" value="${grade}" />
            <input type="hidden" name="subject" value="${subject}" />
            <input type="hidden" name="nameCourse" value="${nameCourse}" />
            <input type="hidden" name="currentEnrollment" value="${currentEnrollment}" />
            <input type="hidden" name="level" value="${level}" />
            <table class="table">
                <div style="margin: 30px 0;">
                    <label style="font-weight: bold; margin-right: 10px;">Loại điểm:</label>
                    <select name="typeScore" style="padding: 8px 12px; border-radius: 6px; border: 1px solid #ddd; width: 200px; font-size: 14px;">
                        <option value="">-- Chọn loại điểm --</option>
                        <option value="Bài tập về nhà">Bài tập về nhà</option>
                        <option value="Điểm miệng">Điểm miệng</option>
                        <option value="Điểm 15 phút">Điểm 15 phút</option>
                        <option value="Điểm 45 phút">Điểm 45 phút</option>
                        <option value="Điểm giữa kỳ">Điểm giữa kỳ</option>
                        <option value="Điểm cuối kỳ">Điểm cuối kỳ</option>
                        <option value="Điểm thực hành">Điểm thực hành</option>
                        <option value="Điểm dự án">Điểm dự án</option>
                    </select>
                </div>

                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ và tên</th>
                        <th>Điểm</th>
                        <th>Nhận xét</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="st" items="${listStudent}">
                        <tr>
                            <td>${st.getId()}</td>
                            <td>${st.getName()}</td>
                            <td>
                                <input type="hidden" name="studentIds" value="${st.getId()}" />
                                <input class="score-input" name="score_${st.getId()}" type="number" min="0" max="10" step="0.1">
                            </td>
                            <td>
                                <textarea name="feedback_${st.getId()}"></textarea>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <button type="submit" class="submit-btn">Lưu điểm</button>
        </form>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const searchInput = document.getElementById("searchStudent");
        const rows = document.querySelectorAll("table tbody tr");

        searchInput.addEventListener("input", function () {
            const keyword = this.value.toLowerCase().trim();

            rows.forEach(row => {
                const idText = row.children[0].textContent.toLowerCase();
                const nameText = row.children[1].textContent.toLowerCase();

                const isMatch = idText.includes(keyword) || nameText.includes(keyword);

                if (keyword === "" || isMatch) {
                    row.style.display = "";
                    row.classList.add("highlight");
                    setTimeout(() => row.classList.remove("highlight"), 1500);
                } else {
                    row.style.display = "none";
                }
            });
        });
    });

    function validateScores(event) {
        const inputs = document.querySelectorAll('.score-input');
        let firstInvalid = null;
        let hasError = false;

        inputs.forEach(input => {
            const value = input.value.trim();
            input.style.border = '';
            input.style.backgroundColor = '';

            if (value === "") {
                hasError = true;
                input.style.border = '1px solid #dc3545';
                input.style.backgroundColor = '#fff5f5';
                if (!firstInvalid)
                    firstInvalid = input;
            } else {
                const num = parseFloat(value);
                if (isNaN(num) || num < 0 || num > 10) {
                    hasError = true;
                    input.style.border = '1px solid #dc3545';
                    input.style.backgroundColor = '#fff5f5';
                    if (!firstInvalid)
                        firstInvalid = input;
                }
            }
        });

        if (hasError) {
            event.preventDefault();
            firstInvalid.scrollIntoView({behavior: 'smooth', block: 'center'});
            firstInvalid.focus();
            alert("Vui lòng nhập điểm hợp lệ từ 0 đến 10 (không để trống).");
            return false;
        }

        return true;
    }
</script>
