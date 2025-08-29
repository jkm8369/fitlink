<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<aside>
    <div class="user-info">
        <div class="user-name-wrap">
            <img class="dumbell-icon" src="${pageContext.request.contextPath}/assets/images/사이트로고.jpg" alt="dumbell-icon">
            <p class="user-name">
                ${sessionScope.authUser.userName}<br>
                <small>(회원)</small>
            </p>
        </div>

    </div>
    <div class="aside-menu">
        <a href="${pageContext.request.contextPath}/workout" class="menu-item">
            <i class="fa-solid fa-book"></i>
            <span>운동일지</span>
        </a>
        <a href="#" class="menu-item">
            <i class="fa-solid fa-chart-pie"></i>
            <span>InBody & Meal</span>
        </a>
        <a href="#" class="menu-item">
            <i class="fa-solid fa-images"></i>
            <span>사진</span>
        </a>
        <a href="#" class="menu-item">
            <i class="fa-solid fa-calendar-check"></i>
            <span>예약현황</span>
        </a>
        <a href="${pageContext.request.contextPath}/exercise" class="menu-item"> 
            <i class="fa-solid fa-list-ul"></i>
            <span>운동종류</span>
        </a>
    </div>
</aside>