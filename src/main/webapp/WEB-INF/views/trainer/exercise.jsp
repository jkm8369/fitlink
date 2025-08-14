<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Workout Log - FitLink</title>
  <link rel="stylesheet" href="../../assets/css/reset.css" />
  <link rel="stylesheet" href="../../assets/css/include.css" />
  <link rel="stylesheet" href="../../assets/css/trainer.css" />
  <link rel="stylesheet" href="../../assets/css/member.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
</head>

<body>
  <div id="wrap">
    <!-- ------헤더------ -->
    <header>
      <!-- 왼쪽: 이미지 로고 (변경됨) -->
      <a href="" class="btn-logout">
        <!-- 여기에 실제 로고 이미지 파일을 연결하세요 -->
        <img src="../../../../project/front/assets/images/logo.jpg" alt="FitLnk Logo" />
      </a>

      <!-- 오른쪽: 사용자 메뉴 -->
      <div class="btn-logout">
        <a href="#" class="logout-link">
          <i class="fa-solid fa-right-from-bracket"></i>
          로그아웃
        </a>
      </div>
    </header>

    <!-- --aside + main-- -->
    <div id="content">
      <aside>
        <div class="user-info">
          <div class="user-name-wrap">
            <img class="dumbell-icon" src="../../assets/images/사이트로고.jpg" alt="dumbell-icon" />
            <p class="user-name">홍길동<br /><small>(트레이너)</small></p>
          </div>
        </div>

        <div class="aside-menu">
          <a href="#" class="menu-item">
            <i class="fa-solid fa-address-card"></i>
            <span>회원</span>
          </a>
          <a href="#" class="menu-item">
            <i class="fa-solid fa-calendar-days"></i>
            <span>일정</span>
          </a>
          <a href="#" class="menu-item">
            <i class="fa-solid fa-list-ul"></i>
            <span>운동종류</span>
          </a>
        </div>
      </aside>

      <main>
        <!-- 1. 제목 -->
        <div class="page-header">
          <h3 class="page-title">Exercise</h3>
        </div>
        <!-- //1. 제목 -->

        <!-- 2. 운동 종류 리스트-->
        <div class="exercise-container">
          <div class="exercise-header">
            <button class="btn-edit-exercises">
              <i class="fa-solid fa-scissors"></i>
              <span>운동종류 수정</span>
            </button>
          </div>
          <!-- 가슴 운동 -->
          <section class="exercise-category">
            <h4 class="category-title">가슴</h4>
            <!-- div.exercise-grid를 ul.exercise-grid로 변경 -->
            <ul class="exercise-grid">
              <!-- div.exercise-item을 li.exercise-item으로 변경 -->
              <li class="exercise-item">벤치프레스</li>
              <li class="exercise-item">푸시업</li>
              <li class="exercise-item">해머 벤치프레스</li>
              <li class="exercise-item">스미스머신 벤치프레스</li>
              <li class="exercise-item">중량 푸시업</li>
              <li class="exercise-item">스포토 벤치프레스</li>
            </ul>
          </section>

          <!-- 등 운동 -->
          <section class="exercise-category">
            <h4 class="category-title">등</h4>
            <ul class="exercise-grid">
              <li class="exercise-item">스미스머신 로우</li>
              <li class="exercise-item">인클라인 덤벨 로우</li>
              <li class="exercise-item">어시스트 풀업 머신</li>
              <li class="exercise-item">덤벨 로우</li>
              <li class="exercise-item">인버티드 로우</li>
              <li class="exercise-item">플로어 시티드 케이블 로우</li>
            </ul>
          </section>

          <!-- 어깨 운동 -->
          <section class="exercise-category">
            <h4 class="category-title">어깨</h4>
            <ul class="exercise-grid">
              <li class="exercise-item">오버헤드 프레스</li>
              <li class="exercise-item">핸드스탠드 푸시업</li>
              <li class="exercise-item">시티드 바벨 숄더 프레스</li>
              <li class="exercise-item">스미스머신 오버헤드 프레스</li>
              <li class="exercise-item">케이블 리버스 플라이</li>
              <li class="exercise-item">시티드 덤벨 숄더 프레스</li>
            </ul>
          </section>
        </div>
        <!-- 2. 운동 종류 리스트-->
      </main>
    </div>

    <footer>
      <p>Copyright © 2025. FitLink All rights reserved.</p>
    </footer>
  </div>
</body>

</html>