<%-- 
    Document   : addCourse
    Created on : Jun 26, 2025, 1:30:35 AM
    Author     : HanND
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="layout/adminHeader.jsp" />

<div class="container mt-4">
    <h4 class="mb-4"><i class="fas fa-plus-circle text-success me-2"></i>Thêm khóa học mới</h4>

    <form id="courseForm" action="quan-ly-khoa-hoc?action=add" method="post" onsubmit="return validateForm()">

        <div class="mb-3">
            <label class="form-label">Tên khoá học</label>
            <input id="courseName" name="name" class="form-control form-control-sm" required>
            <span id="dupMsg" class="text-danger small" style="display:none">
                Tên khóa học đã tồn tại.
            </span>
        </div>

        <div class="mb-3">
            <label class="form-label">Giáo viên phụ trách</label>
            <select name="teacherId" class="form-select form-select-sm" required>
                <c:forEach var="t" items="${teacherList}">
                    <option value="${t.id}">${t.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Môn học</label>
            <select name="subject" class="form-select form-select-sm" required>
                <option value="Mathematics">Toán</option>
                <option value="Literature">Ngữ văn</option>
                <option value="English">Tiếng Anh</option>
                <option value="Physics">Vật lý</option>
                <option value="Chemistry">Hóa học</option>
                <option value="Biology">Sinh học</option>
                <option value="History">Lịch sử</option>
                <option value="Geography">Địa lý</option>
                <option value="Civic Education">GDCD</option>
                <option value="Informatics">Tin học</option>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Mô tả</label>
            <textarea name="description" class="form-control form-control-sm" placeholder="Mô tả ngắn gọn..."></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">Trạng thái</label>
            <select name="status" class="form-select form-select-sm" required>
                <option value="activated">Đang hoạt động</option>
                <option value="pending">Chờ duyệt</option>
                <option value="upcoming">Sắp diễn ra</option>
                <option value="rejected">Từ chối</option>
                <option value="inactivated">Tạm ngưng</option>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Loại khóa học</label>
            <select name="courseType" id="courseType" class="form-select form-select-sm" onchange="toggleFeeFields()" required>
                <option value="combo">Trọn gói</option>
                <option value="daily">Theo buổi</option>
            </select>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label class="form-label">Học phí trọn gói</label>
                <input type="number" class="form-control form-control-sm" name="feeCombo" id="feeCombo" min="0" step="0.01" placeholder="VD: 500000">
            </div>
            <div class="col-md-6">
                <label class="form-label">Học phí theo buổi</label>
                <input type="number" class="form-control form-control-sm" name="feeDaily" id="feeDaily" min="0" step="0.01" placeholder="VD: 80000">
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label class="form-label">Ngày bắt đầu</label>
                <input type="date" class="form-control form-control-sm" name="startDate" id="startDate" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Ngày kết thúc</label>
                <input type="date" class="form-control form-control-sm" name="endDate" id="endDate" required readonly>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-4">
                <label class="form-label">Số tuần học</label>
                <input type="number" class="form-control form-control-sm" name="weekAmount" id="weekAmount" min="1" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">Sĩ số hiện tại</label>
                <input type="number" class="form-control form-control-sm" name="studentEnrollment" id="studentEnrollment" min="0" value="0" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">Sĩ số tối đa</label>
                <input type="number" class="form-control form-control-sm" name="maxStudents" id="maxStudents" min="1" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Trình độ</label>
            <select name="level" class="form-select form-select-sm" required>
                <option value="Foundation">Nhập môn</option>
                <option value="Basic">Cơ bản</option>
                <option value="Advanced">Nâng cao</option>
                <option value="Excellent">Xuất sắc</option>
                <option value="Topics_Exam">Chuyên đề / Luyện thi</option>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Khóa học nổi bật</label>
            <select name="isHot" class="form-select form-select-sm" required>
                <option value="true">Có</option>
                <option value="false" selected>Không</option>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Khối</label>
            <input type="text" class="form-control form-control-sm" name="grade" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Giảm giá (%)</label>
            <input type="number" class="form-control form-control-sm" name="discountPercentage" id="discountPercentage" min="0" max="100" step="0.01" placeholder="VD: 10" onblur="formatDiscount()">
        </div>
        <hr class="my-4">
        <h5>
            <i class="fas fa-calendar-plus text-primary me-2"></i>
            Lịch học (Tuần 1 buổi)
            <button type="button" class="btn btn-sm btn-outline-primary" onclick="toggleScheduleForm()">
                <i class="fas fa-plus"></i>
            </button>
        </h5>

        <div id="scheduleForm" style="display: none;">
            <div class="row mb-3">
                <div class="col-md-4">
                    <label class="form-label">Ngày học</label>
                    <select name="dayOfWeek" class="form-select form-select-sm" required>
                        <option value="Monday">Thứ 2</option>
                        <option value="Tuesday">Thứ 3</option>
                        <option value="Wednesday">Thứ 4</option>
                        <option value="Thursday">Thứ 5</option>
                        <option value="Friday">Thứ 6</option>
                        <option value="Saturday">Thứ 7</option>
                        <option value="Sunday">Chủ nhật</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Giờ bắt đầu</label>
                    <input type="time" class="form-control form-control-sm" name="startTime" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Giờ kết thúc</label>
                    <input type="time" class="form-control form-control-sm" name="endTime" required>
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label">Phòng học</label>
                <input type="text" class="form-control form-control-sm" name="classroom" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Trạng thái buổi học</label>
                <select name="sectionStatus" class="form-select form-select-sm" required>
                    <option value="active">Đang hoạt động</option>
                    <option value="inactive">Tạm ngưng</option>
                    <option value="completed">Đã hoàn thành</option>
                </select>
            </div>
        </div>

        <button type="submit" class="btn btn-success">Thêm khóa học</button>
        <a href="quan-ly-khoa-hoc" class="btn btn-secondary">Hủy</a>
    </form>
</div>
<script>
    var tenBiTrung = false;

    function kiemTraTrung() {
        var oTen = document.getElementById('courseName');
        var canhBao = document.getElementById('dupMsg');
        var ten = oTen.value.trim();

        if (ten === '') {
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

    document.getElementById('courseName').addEventListener('blur', kiemTraTrung);

    // validateForm thành 1 hàm duy nhất
    function validateForm() {
        if (tenBiTrung) {
            alert('Tên khóa học đã tồn tại, vui lòng nhập tên khác.');
            return false;
        }

        const courseType = document.getElementById('courseType').value;
        const feeCombo = document.getElementById('feeCombo');
        const feeDaily = document.getElementById('feeDaily');
        const startDate = new Date(document.getElementById('startDate').value);
        const endDate = new Date(document.getElementById('endDate').value);
        const weekAmount = parseInt(document.getElementById('weekAmount').value);
        const studentEnrollment = parseInt(document.getElementById('studentEnrollment').value);
        const maxStudents = parseInt(document.getElementById('maxStudents').value);
        const discount = parseFloat(document.getElementById('discountPercentage').value);

        if (courseType === 'combo' && (!feeCombo.value || parseFloat(feeCombo.value) <= 0)) {
            alert('Vui lòng nhập học phí trọn gói hợp lệ.');
            feeCombo.focus();
            return false;
        }
        if (courseType === 'daily' && (!feeDaily.value || parseFloat(feeDaily.value) <= 0)) {
            alert('Vui lòng nhập học phí theo buổi hợp lệ.');
            feeDaily.focus();
            return false;
        }

        if (startDate >= endDate) {
            alert("Ngày kết thúc phải sau ngày bắt đầu.");
            return false;
        }

        if (studentEnrollment < 0 || maxStudents < 1 || weekAmount < 1) {
            alert("Thông tin sĩ số hoặc số tuần không hợp lệ.");
            return false;
        }
        if (studentEnrollment > maxStudents) {
            alert("Sĩ số hiện tại không được vượt quá sĩ số tối đa.");
            return false;
        }

        if (!isNaN(discount) && (discount < 0 || discount > 100)) {
            alert("Phần trăm giảm giá phải từ 0 đến 100.");
            return false;
        }

        return true;
    }

    function toggleFeeFields() {
        const type = document.getElementById('courseType').value;
        document.getElementById('feeCombo').disabled = type !== 'combo';
        document.getElementById('feeDaily').disabled = type !== 'daily';
    }

    function formatDiscount() {
        const input = document.getElementById('discountPercentage');
        if (input.value && !input.value.includes('.')) {
            input.value = input.value + '.0';
        }
    }

    function calculateEndDate() {
        const startDate = new Date(document.getElementById('startDate').value);
        const weeks = parseInt(document.getElementById('weekAmount').value);
        if (!isNaN(weeks)) {
            const endDate = new Date(startDate);
            endDate.setDate(startDate.getDate() + (weeks * 7));
            document.getElementById('endDate').value = endDate.toISOString().split('T')[0];
        }
    }

    function toggleScheduleForm() {
        const form = document.getElementById('scheduleForm');
        form.style.display = form.style.display === 'none' ? 'block' : 'none';
    }

    // ✅ Đảm bảo mọi sự kiện được gắn đúng khi DOM sẵn sàng
    document.addEventListener('DOMContentLoaded', () => {
        toggleFeeFields();
        document.getElementById('startDate').addEventListener('change', calculateEndDate);
        document.getElementById('weekAmount').addEventListener('input', calculateEndDate);
    });
</script>

<jsp:include page="layout/footer.jsp" /> 
