<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">

	<head>
	    <meta charset="UTF-8" />
	    <title>로그인</title>
	    <meta name="viewport" content="width=device-width, initial-scale=1" />
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css">
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/form.css">
	    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
	</head>
	
	<body>
	    <div class="card">
	        <a href="">
	            <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="FinLink logo">
	        </a>
	
	        <!-- 아이디 / 비밀번호 -->
	        <form class="form-login" action="${pageContext.request.contextPath}/user/login" method="post">
	            <!-- 아이디 -->
	            <div class="field-login field-box">
	                <div class="icon"><i class="fa-regular fa-user"></i></div>
	                <input type="text" name="loginId" placeholder="아이디">
	            </div>
	
	            <!-- 비밀번호 -->
	            <div class="field-login field-box">
	                <div class="icon"><i class="fa-solid fa-lock"></i></div>
	                <input type="password" name="password" placeholder="비밀번호">
	            </div>
	        <!-- 회원가입 버튼 -->
	        <button class="btn-login" type="submit">로그인</button>
	        </form>
	
	        <div class="links">
	            <a href="#">비밀번호 찾기</a>
	            <a href="#">아이디 찾기</a>
	            <a href="#">회원가입</a>
	        </div>
	        
	    </div>
	</body>

</html>