<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="../../assets/css/reset.css">
    <link rel="stylesheet" href="../../assets/css/form.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <title>로그인</title>
</head>

<body>
    <div class="card">
        <a href="">
            <img src="../../assets/images/logo.jpg" alt="FinLink logo">
        </a>

        <!-- 아이디 / 비밀번호 -->
        <div class="form-login">
            <!-- 아이디 + 중복확인 -->
            <div class="field-login field-box">
                <div class="icon"><i class="fa-regular fa-user"></i></div>
                <input type="text" placeholder="아이디">
            </div>

            <!-- 비밀번호 -->
            <div class="field-login field-box">
                <div class="icon"><i class="fa-solid fa-lock"></i></div>
                <input type="password" placeholder="비밀번호">
            </div>
        </div>
        <!-- 회원가입 버튼 -->
        <button class="btn-login" type="button">로그인</button>

        <div class="links">
            <a href="#">비밀번호 찾기</a>
            <a href="#">아이디 찾기</a>
            <a href="#">회원가입</a>
        </div>
        
    </div>
</body>

</html>