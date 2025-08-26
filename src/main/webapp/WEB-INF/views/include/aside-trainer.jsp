<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<aside>
    <div class="user-info">
      <div class="user-name-wrap">
        <img class="dumbell-icon" src="${pageContext.request.contextPath}/assets/images/사이트로고.jpg" alt="dumbell-icon">
        <p class="user-name">
          ${sessionScope.authUser.userName}<br>
          <small>(트레이너)</small>
        </p>
      </div>
    </div>

    <div class="aside-menu">
      <a href="${pageContext.request.contextPath}/trainer/member-list" class="menu-item">
        <i class="fa-solid fa-address-card"></i>
        <span>회원</span>
      </a>
      <a href="${pageContext.request.contextPath}/trainer/schedule" class="menu-item">
        <i class="fa-solid fa-calendar-days"></i>
        <span>일정</span>
      </a>
      <a href="${pageContext.request.contextPath}/exercise" class="menu-item">
        <i class="fa-solid fa-list-ul"></i>
        <span>운동종류</span>
      </a>
    </div>
</aside>