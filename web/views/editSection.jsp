<%-- 
    Document   : editSection
    Created on : Jun 26, 2025
    Author     : HanND
--%>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="layout/adminHeader.jsp" />

<div class="container mt-5">
    <div class="card shadow rounded-4">
        <div class="card-body p-4">
            <h4 class="mb-4 text-primary fw-bold">
                <i class="fas fa-edit me-2"></i>Chỉnh sửa lớp học
            </h4>

            <form method="post" action="quan-ly-lop-hoc">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="id" value="${section.id}" />
                <input type="hidden" name="courseName" value="${section.courseName}" />

                <!-- Khóa học -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Khóa học</label>
                    <input type="text" class="form-control-plaintext bg-light border rounded px-3 py-2" value="${section.courseName}" readonly>
                </div>

                <!-- Thứ -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Thứ</label>
                    <select name="dayOfWeek" class="form-select" required>
                        <option value="Monday" ${section.dayOfWeek == 'Monday' ? 'selected' : ''}>Thứ 2</option>
                        <option value="Tuesday" ${section.dayOfWeek == 'Tuesday' ? 'selected' : ''}>Thứ 3</option>
                        <option value="Wednesday" ${section.dayOfWeek == 'Wednesday' ? 'selected' : ''}>Thứ 4</option>
                        <option value="Thursday" ${section.dayOfWeek == 'Thursday' ? 'selected' : ''}>Thứ 5</option>
                        <option value="Friday" ${section.dayOfWeek == 'Friday' ? 'selected' : ''}>Thứ 6</option>
                        <option value="Saturday" ${section.dayOfWeek == 'Saturday' ? 'selected' : ''}>Thứ 7</option>
                        <option value="Sunday" ${section.dayOfWeek == 'Sunday' ? 'selected' : ''}>Chủ nhật</option>
                    </select>
                </div>

                <!-- Giờ học -->
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Giờ bắt đầu</label>
                        <input type="time" name="startTime" class="form-control" value="${section.formattedStartTime}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Giờ kết thúc</label>
                        <input type="time" name="endTime" class="form-control" value="${section.formattedEndTime}" required>
                    </div>
                </div>

                <!-- Phòng học -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Phòng học</label>
                    <input type="text" name="classroom" class="form-control" value="${section.classroom}" required>
                </div>

                <!-- Ngày học -->
                <div class="mb-3">
                    <label class="form-label fw-semibold">Ngày học</label>
                    <input type="date" name="dateTime" class="form-control" value="${section.formattedDateTime}" required>
                </div>

                <!-- Trạng thái -->
                <div class="mb-4">
                    <label class="form-label fw-semibold">Trạng thái</label>
                    <select name="status" class="form-select" required>
                        <option value="active" ${section.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                        <option value="inactive" ${section.status == 'inactive' ? 'selected' : ''}>Tạm ngưng</option>
                        <option value="completed" ${section.status == 'completed' ? 'selected' : ''}>Hoàn tất</option>
                    </select>
                </div>

                <!-- Buttons -->
                <div class="d-flex justify-content-between">
                    <a href="quan-ly-lop-hoc" class="btn btn-outline-secondary">
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
