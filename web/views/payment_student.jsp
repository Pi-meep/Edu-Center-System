<%@ page import="java.util.*, modal.*, java.text.SimpleDateFormat, java.text.NumberFormat, java.util.Locale, utils.CurrencyFormatter, utils.DateFormat, java.time.LocalDateTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="layout/header.jsp" />
<%
    Integer studentId = (Integer) request.getAttribute("studentId");
    Integer courseId = (Integer) request.getAttribute("courseId");
    Integer sectionId = (Integer) request.getAttribute("sectionId");
    List<CourseModal> dailyCourses = (List<CourseModal>) request.getAttribute("dailyCourses");
    List<Map<String, Object>> sections = (List<Map<String, Object>>) request.getAttribute("sections");
    PaymentInfoModal paymentInfo = (PaymentInfoModal) request.getAttribute("paymentInfo");
    String transferContent = (String) request.getAttribute("transferContent");
    java.math.BigDecimal amount = (java.math.BigDecimal) request.getAttribute("amount");
    Boolean isCombo = (Boolean) request.getAttribute("isCombo");
    String msg = (String) request.getAttribute("msg");
%>
<html>
<head>
    <title>Thanh toán học phí</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; }
        h2 { color: #2c3e50; margin-top: 30px; }
        form { background: #fff; padding: 30px 40px; border-radius: 10px; box-shadow: 0 2px 8px #ccc; max-width: 500px; margin: 30px auto; }
        label { display: block; margin-top: 15px; font-weight: bold; color: #34495e; }
        select, input[type="text"], input[type="hidden"] { width: 100%; padding: 8px; margin-top: 5px; border-radius: 5px; border: 1px solid #ccc; }
        button { background: #27ae60; color: #fff; border: none; padding: 12px 25px; border-radius: 5px; font-size: 16px; margin-top: 20px; cursor: pointer; transition: background 0.2s; }
        button:hover { background: #219150; }
        h3 { color: #2980b9; margin-top: 25px; }
        p { margin: 8px 0; }
        b { color: #e67e22; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 15px; border-radius: 5px; margin: 20px auto; max-width: 500px; text-align: center; font-size: 16px; }
    </style>
</head>
<body>
    <h2>Thanh toán học phí</h2>
    <% if ("success".equals(msg)) { %>
        <div class="alert-success">Xác nhận thanh toán thành công! Vui lòng chờ duyệt.</div>
    <% } %>
    <form action="trang-thanh-toan" method="get" id="selectForm">
        <input type="hidden" name="studentId" value="<%=studentId%>"/>
        <label>Chọn khóa học:</label>
        <select name="courseId" id="courseId" onchange="document.getElementById('selectForm').submit()">
            <option value="">--Chọn--</option>
            <% for (CourseModal c : dailyCourses) { %>
                <option value="<%=c.getId()%>" <%= (c.getId().equals(courseId)) ? "selected" : "" %>><%=c.getName()%></option>
            <% } %>
        </select>
        <% if (isCombo == null || !isCombo) { %>
        <label>Chọn buổi học:</label>
        <select name="sectionId" id="sectionId" <%= (courseId == null) ? "disabled" : "" %> onchange="document.getElementById('selectForm').submit()">
            <option value="">--Chọn--</option>
            <% for (Map<String, Object> s : sections) { %>
                <option value="<%=s.get("id")%>" <%= (s.get("id").equals(sectionId)) ? "selected" : "" %>>
                    <%
                        java.sql.Timestamp ts = (java.sql.Timestamp) s.get("dateTime");
                        String dateStr = (ts != null) ? utils.DateFormat.formatDate(ts.toLocalDateTime()) : "--";
                        String amountStr = utils.CurrencyFormatter.formatCurrency((java.math.BigDecimal)s.get("amount"));
                        amountStr = amountStr.replace("₫", "VNĐ");
                    %>
                    <%= dateStr %> - Số tiền: <%= amountStr %>
                </option>
            <% } %>
        </select>
        <% } %>
    </form>
    <form action="trang-thanh-toan" method="post">
        <input type="hidden" name="studentId" value="<%=studentId%>"/>
        <input type="hidden" name="courseId" value="<%=courseId%>"/>
        <% if (isCombo == null || !isCombo) { %>
        <input type="hidden" name="sectionId" value="<%=sectionId%>"/>
        <% } %>
        <input type="hidden" name="transferContent" value="<%=transferContent%>"/>
        <h3>Thông tin chuyển khoản</h3>
        <p>Ngân hàng: <%=paymentInfo != null ? paymentInfo.getBankName() : ""%></p>
        <p>Số tài khoản: <%=paymentInfo != null ? paymentInfo.getAccountNumber() : ""%></p>
        <p>Chủ tài khoản: <%=paymentInfo != null ? paymentInfo.getAccountName() : ""%></p>
        <p>Chi nhánh: <%=paymentInfo != null ? paymentInfo.getBranch() : ""%></p>
        <p><b>Số tiền cần thanh toán: 
            <%
                String payAmountStr = (amount != null) ? utils.CurrencyFormatter.formatCurrency(amount) : "--";
                payAmountStr = payAmountStr.replace("₫", "VNĐ");
            %>
            <%= payAmountStr %>
        </b></p>
        <p>Nội dung chuyển khoản: <b><%=transferContent%></b></p>
        <button type="submit" name="action" value="confirm">Tôi đã chuyển khoản</button>
    </form>
<jsp:include page="layout/footer.jsp" />
</body>
</html>
