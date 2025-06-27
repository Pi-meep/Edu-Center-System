<%-- 
    Document   : viewChild
    Created on : Jun 27, 2025, 2:07:11 AM
    Author     : vankh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<% request.setAttribute("pageCSS", "/style/headerProfile.css");%>
<jsp:include page="layout/header.jsp" />
<style>
    .container-fluid {
        max-width: 900px;
        margin: 100px auto 30px auto;
        padding: 0 15px;
    }

    .widget-box {
        background: #fff;
        border-radius: 10px;
        padding: 25px 30px;
        box-shadow: 0 0 15px rgba(0,0,0,0.05);
    }

    .wc-title h4 {
        font-size: 24px;
        font-weight: 600;
        margin-bottom: 25px;
        color: #333;
        text-align: center;
    }

    .student-list {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .student-item {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 15px 20px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        transition: all 0.3s ease;
        cursor: pointer;
        border: none;
        width: 100%;
        text-align: left;
    }

    .student-item:hover {
        background: #e9ecef;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .student-name {
        font-size: 18px;
        font-weight: 600;
        color: #2c3e50;
    }

    .no-data {
        text-align: center;
        padding: 20px;
        color: #6c757d;
    }

    form {
        margin: 0;
        padding: 0;
    }
</style>

<div class="container-fluid">
    <div class="row">
        <div class="col-lg-12 m-b30">
            <div class="widget-box">
                <div class="wc-title">
                    <h4>Danh sách con của phụ huynh</h4>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                </div>

                <div class="widget-inner">
                    <c:choose>
                        <c:when test="${not empty children}">
                            <div class="student-list">
                                <c:forEach var="child" items="${children}">
                                    <form action="viewScore" method="POST">
                                        <input type="hidden" name="studentId" value="${child.id}">
                                        <button type="submit" class="student-item">
                                            <span class="student-name">${child.name}</span>
                                        </button>
                                    </form>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="no-data">Không tìm thấy con nào</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />
