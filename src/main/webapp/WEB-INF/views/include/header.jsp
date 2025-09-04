<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<header>
	<!-- 왼쪽: 이미지 로고 (변경됨) -->
	<h1>
		<a href="${pageContext.request.contextPath}/" class="btn-logout"> <!-- 여기에 실제 로고 이미지 파일을 연결하세요 --> <img
			src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="FitLnk Logo" />
		</a>
	</h1>
	<!-- 오른쪽: 사용자 메뉴 -->
	<form action="${pageContext.request.contextPath}/user/logout" class="btn-logout" method="post" style="display: inline;">
		<button type="submit" class="logout-link" style="background: none; cursor: pointer;">
			<i class="fa-solid fa-right-from-bracket"></i> 로그아웃
		</button>
	</form>
</header>