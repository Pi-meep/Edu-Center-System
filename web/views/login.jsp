<%-- 
    Document   : login
    Created on : Jun 24, 2025, 11:44:32 PM
    Author     : ASUS
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<style>
    body {
        margin: 0;
        font-family: 'Segoe UI', sans-serif;
        height: 100vh;
    }

    .main-container {
        display: flex;
        height: calc(100vh - 60px); /* trừ chiều cao header nếu có */
    }

    /* ===================== HEADER ===================== */
    .header {
        background-color: #000;
        opacity: 0.85;
        color: #fff;
        font-size: 18px;
        font-weight: bold;
        text-align: left;
        width: 100%;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        position: static;
    }

    /* ===================== KHUNG 2 BÊN ===================== */
    .left-panel {
        width: 40%;
        background: linear-gradient(135deg, #6a11cb, #2575fc);
/*        background: linear-gradient(rgba(90, 0, 130, 0.85), rgba(90, 0, 130, 0.85)),
            url('your-background-image.jpg') center/cover no-repeat;*/
        color: white;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: 60px;
    }

    .left-panel h1 {
        font-size: 36px;
        margin-bottom: 10px;
    }

    .left-panel p {
        font-size: 18px;
    }

    /* ===================== PANEL PHẢI (CHỨA FORM) ===================== */
    .right-panel {
        width: 60%;
        background: white;
        padding: 60px 80px;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .right-panel h2 {
        font-size: 32px;
        text-transform: uppercase;
        margin-bottom: 30px;
        font-weight: bold;
        position: relative;
        padding-left: 20px;
    }

    .right-panel h2::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 6px;
        height: 80%;
        background-color: #f4a100;
        border-radius: 3px;
    }

    .right-panel a {
        color: purple;
        text-decoration: underline;
        font-size: 14px;
        margin-top: 15px;
        margin-bottom: 30px;
        display: inline-block;
    }

    /* ===================== FORM ===================== */
    form {
        display: flex;
        flex-direction: column;
    }

    form label {
        display: block;
        font-size: 14px;
        margin: 10px 0 5px;
    }

    form input[type="text"],
    form input[type="email"],
    form input[type="password"],
    form input[type="date"],
    form select {
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
    }

    form input[type="submit"] {
        margin-top: 20px;
        background: #f7b900;
        color: white;
        border: none;
        padding: 10px;
        font-size: 16px;
        cursor: pointer;
        border-radius: 5px;
        width: 100%;
    }

    form input[type="submit"]:hover {
        background: #f4a100;
    }

    /* ===================== THÔNG BÁO ===================== */
    .message {
        margin-top: 10px;
        text-align: center;
        font-weight: bold;
        color: green;
    }

    .error {
        margin-top: 10px;
        text-align: center;
        font-weight: bold;
        color: red;
    }
    .main-container {
        display: flex;
        height: calc(100vh - 60px); /* trừ chiều cao header nếu có */
    }
</style>
<html>
    <%
        request.setAttribute("title", "Login");
        request.setAttribute("pageCSS", "/style/login.css");
    %>
    <body>
        <jsp:include page="layout/header.jsp" />

        <div class="main-container">
            <div class="left-panel">
                <h1>EduCenter</h1>
                <p>Trung tâm dạy thêm và khóa học</p>
            </div>

            <div class="right-panel">
                <h2>Đăng nhập</h2>
                <a href="dang-ky">Chưa có tài khoản ? Gửi yêu cầu tạo tài khoản phụ huynh / giáo viên tại đây</a>
                <form action="${pageContext.request.contextPath}/dang-nhap" method="post">
                    <label>Tên đăng nhập:</label>
                    <input type="text" name="identifier" value="${enteredIdentifier}" />

                    <label>Mật khẩu:</label>
                    <input type="password" name="password" />

                    <div class="login-options">
                        <a href="#">Quên mật khẩu ?</a>
                    </div>
                    <input type="submit" value="Đăng nhập" />
                </form>
                <c:if test="${not empty error}">
                    <p class="error">${error}</p>
                </c:if>
            </div>
        </div>
    </body>
</html>
<jsp:include page="layout/footer.jsp" /> 