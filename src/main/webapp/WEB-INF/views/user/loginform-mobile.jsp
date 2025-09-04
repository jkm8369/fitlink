<%-- fitlink/src/main/webapp/WEB-INF/views/user/loginform-mobile.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    
    <%-- 모바일 장치에서 화면 크기를 올바르게 맞추기 위한 뷰포트 설정 --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
    
    <title>FitLink - 로그인</title>
    
    <%-- CSS 파일 경로 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/form-mobile.css">
    
    <%-- Font Awesome 아이콘 라이브러리 --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

    <%-- 전체를 감싸는 컨테이너 --%>
    <div class="login-container">

        <%-- 로고 --%>
        <div class="logo-wrapper">
            <a href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="FitLink 로고">
            </a>
        </div>

        <%-- 로그인 폼 --%>
        <form class="login-form" action="${pageContext.request.contextPath}/user/login/mobile" method="post">
            
            <%-- 아이디 입력 필드 --%>
            <div class="input-group">
                <i class="fa-regular fa-user input-icon"></i>
                <input type="text" name="loginId" placeholder="아이디" required value="${loginId}">
            </div>
            
            <%-- 비밀번호 입력 필드 --%>
            <div class="input-group">
                <i class="fa-solid fa-lock input-icon"></i>
                <input type="password" name="password" placeholder="비밀번호" required value="${password}">
            </div>
            
            <%-- 로그인 버튼 --%>
            <button class="btn-login" type="submit">로그인</button>
            
        </form>

        <%-- 추가 링크 (비밀번호 찾기, 회원가입 등) --%>
        <div class="extra-links">
            <a href="#">비밀번호 찾기</a>
            <span class="separator">|</span>
            <a href="#">아이디 찾기</a>
            <span class="separator">|</span>
            <a href="">회원가입</a>
        </div>
        
    </div>

</body>
</html>