<%-- 
    Document   : editCourse
    Created on : Jun 25, 2025, 1:58:51 AM
    Author     : HanND
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="layout/adminHeader.jsp" />

<div class="container mt-5">
    <div class="card shadow rounded-4">
        <div class="card-body p-4">
            <h4 class="mb-4 text-primary fw-bold">
                <i class="fas fa-edit me-2"></i>Chỉnh sửa khóa học
            </h4>

            <form method="post" action="quan-ly-khoa-hoc" id="editCourseForm">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="id" value="${course.id}" />
                <div class="mb-3">
                    <label class="form-label fw-semibold">Giáo viên</label>
                    <select name="teacherId" class="form-select" required>
                        <c:forEach var="t" items="${teacherList}">
                            <option value="${t.id}" ${t.id == course.teacherId ? 'selected' : ''}>${t.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <!-- Tên khóa học -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Tên khóa học</label>
                    <input type="text"
                           id="courseName"
                           name="name"
                           class="form-control form-control-sm ${isDuplicate ? 'is-invalid' : ''}"
                           value="${course.name}"
                           data-original-name="${course.name}"
                           required>
                    <span id="dupMsg" class="text-danger small" style="display:none">
                        Tên khóa học đã tồn tại.
                    </span>
                </div>

                <!-- Môn học (ẩn) -->
                <input type="hidden" name="subject" value="${course.subject}" />

                <!-- Khối lớp -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Khối</label>
                    <select name="grade" class="form-select" required>
                        <c:forEach var="i" begin="1" end="12">
                            <option value="${i}" ${i == course.grade ? 'selected' : ''}>Khối ${i}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Học phí -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Học phí</label>
                    <c:choose>
                        <c:when test="${course.feeDaily != null}">
                            <input type="number" class="form-control" step="0.01" name="feeDaily" value="${course.feeDaily}" required>
                            <input type="hidden" name="courseType" value="DAILY" />
                        </c:when>
                        <c:when test="${course.feeCombo != null}">
                            <input type="number" class="form-control" step="0.01" name="feeCombo" value="${course.feeCombo}" required>
                            <input type="hidden" name="courseType" value="COMBO" />
                        </c:when>
                    </c:choose>
                </div>

                <!-- Ngày bắt đầu và kết thúc -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Thời gian bắt đầu</label>
                        <input type="date" id="startDate" name="startDate" class="form-control" value="${formattedStartDate}" required />
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Thời gian kết thúc</label>
                        <input type="date" id="endDate" name="endDate" class="form-control" value="${formattedEndDate}" readonly required />
                    </div>
                </div>

                <!-- Sĩ số và số tuần -->
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Sĩ số hiện tại</label>
                        <input type="number" class="form-control" name="studentEnrollment" value="${course.studentEnrollment}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Sĩ số tối đa</label>
                        <input type="number" class="form-control" name="maxStudents" value="${course.maxStudents}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Số tuần</label>
                        <input type="number" class="form-control" id="weekAmount" name="weekAmount" value="${course.weekAmount}" required>
                    </div>
                </div>

                <!-- Trình độ -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Trình độ</label>
                    <select class="form-select" name="level" required>
 <option value="Basic" ${course.level == 'Basic' ? 'selected' : ''}>Cơ bản</option>
<option value="Advanced" ${course.level == 'Advanced' ? 'selected' : ''}>Nâng cao</option>
<option value="Excellent" ${course.level == 'Excellent' ? 'selected' : ''}>Học sinh giỏi</option>
<option value="Foundation" ${course.level == 'Foundation' ? 'selected' : ''}>Nền tảng</option>
<option value="Topics_Exam" ${course.level == 'Topics_Exam' ? 'selected' : ''}>Chuyên đề/Luyện thi</option>

                    </select>
                </div>

                <!-- Trạng thái -->
                <div class="mb-4">
                    <label class="form-label fw-semibold">Trạng thái</label>
                    <select class="form-select" name="status" required>
                        <option value="activated" ${statusString == 'activated' ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="pending" ${statusString == 'pending' ? 'selected' : ''}>Chờ duyệt</option>
                        <option value="upcoming" ${statusString == 'upcoming' ? 'selected' : ''}>Sắp diễn ra</option>
                        <option value="inactivated" ${statusString == 'inactivated' ? 'selected' : ''}>Tạm ngưng</option>
                        <option value="rejected" ${statusString == 'rejected' ? 'selected' : ''}>Từ chối</option>
                    </select>
                </div>

                <!-- Nút -->
                <div class="d-flex justify-content-between">
                    <a href="quan-ly-khoa-hoc" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại
                    </a>
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />


<script>
    var tenBiTrung = false;

    function kiemTraTrung() {
        var oTen = document.getElementById('courseName');
        var canhBao = document.getElementById('dupMsg');
        var ten = oTen.value.trim();
        var tenGoc = oTen.getAttribute('data-original-name')?.trim();

        // Nếu tên không đổi thì không cần kiểm tra
        if (ten === '' || ten === tenGoc) {
            canhBao.style.display = 'none';
            tenBiTrung = false;
            return;
        }

        fetch('quan-ly-khoa-hoc?action=checkDuplicate&name=' + encodeURIComponent(ten))
                .then(function (res) {
                    return res.json();
                })
                .then(function (data) {
                    tenBiTrung = data.exists;
                    canhBao.style.display = tenBiTrung ? 'block' : 'none';
                });
    }
    //chạy khi người dùng rời khỏi ô courseName sau khi nhập
    document.getElementById('courseName').addEventListener('blur', kiemTraTrung);

    // Xử lý kiểm tra dữ liệu đầu vào trước khi submit form
    document.getElementById('editCourseForm').addEventListener('submit', function (e) {
        const name = document.querySelector('input[name="name"]').value.trim();
        const feeDaily = document.querySelector('input[name="feeDaily"]');
        const feeCombo = document.querySelector('input[name="feeCombo"]');
        const startDate = new Date(document.querySelector('input[name="startDate"]').value);
        const endDate = new Date(document.querySelector('input[name="endDate"]').value);
        const studentEnrollment = parseInt(document.querySelector('input[name="studentEnrollment"]').value);
        const maxStudents = parseInt(document.querySelector('input[name="maxStudents"]').value);

        let errorMsg = '';

        // Kiểm tra tên
        if (!name) {
            errorMsg += '- Vui lòng nhập tên khóa học.\n';
        }

        // Kiểm tra học phí > 0
        if (feeDaily && feeDaily.value && parseFloat(feeDaily.value) <= 0) {
            errorMsg += '- Học phí theo ngày phải lớn hơn 0.\n';
        }
        if (feeCombo && feeCombo.value && parseFloat(feeCombo.value) <= 0) {
            errorMsg += '- Học phí theo gói phải lớn hơn 0.\n';
        }

        // Kiểm tra ngày kết thúc không nhỏ hơn ngày bắt đầu
        if (!isNaN(startDate) && !isNaN(endDate) && endDate < startDate) {
            errorMsg += '- Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.\n';
        }

        // Kiểm tra sĩ số
        if (studentEnrollment < 0 || maxStudents <= 0) {
            errorMsg += '- Sĩ số phải là số dương.\n';
        } else if (studentEnrollment > maxStudents) {
            errorMsg += '- Sĩ số hiện tại không được lớn hơn sĩ số tối đa.\n';
        }

        // Nếu có lỗi thì chặn submit và hiển thị cảnh báo
        if (errorMsg) {
            e.preventDefault();
            alert("Lỗi:\n" + errorMsg);
        }
    });
</script>
<script>
    // Tính toán ngày kết thúc dựa trên ngày bắt đầu và số tuần học
    function calculateEndDate() {
        const startDateInput = document.getElementById('startDate');
        const weekAmountInput = document.getElementById('weekAmount');
        const endDateInput = document.getElementById('endDate');

        const startDateStr = startDateInput.value;
        const weekAmount = parseInt(weekAmountInput.value);

        if (startDateStr && !isNaN(weekAmount)) {
            // Tạo ngày kết thúc mới = ngày bắt đầu + (tuần * 7)
            const startDate = new Date(startDateStr);
            const endDate = new Date(startDate);
            endDate.setDate(startDate.getDate() + (weekAmount * 7));

            // Format ngày về đúng chuẩn yyyy-MM-dd cho <input type="date">
            const formattedDate = endDate.toISOString().split('T')[0];

            // Gán giá trị vào input endDate
            endDateInput.value = formattedDate;

            // Debug để kiểm tra trong console
            console.log("Tính ngày kết thúc:", formattedDate);
        }
    }
    // Khi trang vừa load xong
    document.addEventListener('DOMContentLoaded', function () {
        const startDateInput = document.getElementById('startDate');
        const weekAmountInput = document.getElementById('weekAmount');

        // Khi người dùng thay đổi ngày bắt đầu hoặc số tuần, tính lại ngày kết thúc
        startDateInput.addEventListener('change', calculateEndDate);
        weekAmountInput.addEventListener('input', calculateEndDate);

        // Gọi tính toán ban đầu nếu đã có sẵn dữ liệu
        calculateEndDate();
    });
</script>

