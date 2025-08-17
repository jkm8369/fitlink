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
    <title>회원가입</title>
  </head>

  <body>
    <div class="card">
      <a href="">
        <img src="../../assets/images/logo.jpg" alt="FinLink logo">
      </a>

      <!-- 아이디 / 비밀번호 -->
      <div class="form">
        <!-- 아이디 + 중복확인 -->
        <div class="row-id">
          <div class="field field-box">
            <div class="icon">	<i class="fa-solid fa-tag"></i></div>
            <input type="text" placeholder="아이디">
            <button type="button" class="btn-dup">중복확인</button>
          </div>
          
        </div>

        <!-- 비밀번호 -->
        <div class="field field-box">
          <div class="icon"><i class="fa-solid fa-lock"></i></div>
          <input type="password" placeholder="비밀번호">
        </div>

        <!-- 이름 -->
        <div class="field field-line">
          <div class="icon"><i class="fa-regular fa-user"></i></div>
          <input type="text" placeholder="이름">
        </div>

        <!-- 생년월일 -->
        <div class="field field-line">
          <div class="icon"><i class="fa-regular fa-calendar"></i></div>
          <input type="text" placeholder="생년월일">
        </div>

        <!-- 성별 -->
        <div class="field field-line">
          <div class="icon"><i class="fa-solid fa-venus-mars"></i></div>
          <span>성별</span>
          <div class="radios">
            <label><input type="radio" name="gender" value="M"> 남</label>
            <label><input type="radio" name="gender" value="F"> 여</label>
          </div>
        </div>

        <!-- 구분 -->
        <div class="field field-line">
          <div class="icon"><i class="fa-solid fa-id-card"></i></div>
          <span>구분</span>
          <div class="radios">
            <label><input type="radio" name="role" value="trainer"> 트레이너</label>
            <label><input type="radio" name="role" value="member" checked> 회원</label>
          </div>
        </div>

        <!-- 휴대전화번호 -->
        <div class="field field-line">
          <div class="icon"><i class="fa-solid fa-mobile-screen-button"></i></div>
          <input type="text" placeholder="휴대전화번호">
        </div>

      </div>
      <!-- 회원가입 버튼 -->
      <button class="btn-submit" type="button">회원가입</button>

     
    </div>
  </body>

</html>