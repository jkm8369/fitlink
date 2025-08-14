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
  <link rel="stylesheet" href="../../assets/css/member.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
</head>

<body>
  <div id="wrap">

    <!-- ------헤더------ -->
    <header>
      <!-- 왼쪽: 이미지 로고 (변경됨) -->
      <h1>
        <a href="" class="btn-logout">
          <!-- 여기에 실제 로고 이미지 파일을 연결하세요 -->
          <img src="../../assets/images/logo.jpg" alt="FitLnk Logo" />
        </a>
      </h1>
      <!-- 오른쪽: 사용자 메뉴 -->
      <div class="btn-logout">
        <a href="#" class="logout-link">
          <i class="fa-solid fa-right-from-bracket"></i>
          로그아웃
        </a>
      </div>
    </header>
    <!-- //------헤더------ -->

    <!-- --aside + main-- -->
    <div id="content">

      <aside>
        <div class="user-info">
          <div class="user-name-wrap">
            <img class="dumbell-icon" src="../../assets/images/사이트로고.jpg" alt="dumbell-icon">
            <p class="user-name">
              홍길동<br /><small>(회원)</small>
            </p>
          </div>
          <div class="trainer-info">
            <i class="fa-solid fa-clipboard-user"></i>
            <span>1 Trainer</span>
          </div>
        </div>
        <div class="aside-menu">
          <a href="#" class="menu-item">
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
          <a href="#" class="menu-item">
            <i class="fa-solid fa-list-ul"></i>
            <span>운동종류</span>
          </a>
        </div>
      </aside>

      <main>

        <div class="box1">
          <div class="main-header">
            <h3 class="main-title">Workout Log</h3>
            <p class="main-subtitle">2025년 8월 7일</p>
          </div>
        </div>

        <div class="box2">
          <section class="summary-box">
            <h4 class="summary-box-header">총 세트 수행</h4>
            <p>0개 운동 등록 수행</p>
            <div class="stats">
              <div>최고 중량<br><strong>0</strong></div>
              <div>총 반복수<br><strong>0</strong></div>
              <div>총 볼륨<br><strong>0</strong></div>
            </div>
          </section>

          <section class="workout-input">
            <h4>오늘의 운동</h4>
            <!-- -- 운동 입력 폼 -- -->
            <form class="set-form">
              <select>
                <option>부위</option>
                <option>가슴</option>
                <option>등</option>
              </select>

              <select>
                <option>운동</option>
                <option>벤치프레스</option>
                <option>스쿼트</option>
              </select>

              <span>무게</span>
              <input type="text" placeholder="숫자" />
              <span>kg</span>
              <span>×</span>
              <input type="text" placeholder="숫자" />
              <span>회</span>

              <button type="submit" class="btn-plus">+</button>
            </form>

            <!-- -- + 클릭시 추가되는 폼 (js)-- -->
            <div class="set-list">
              <div class="set-item">
                <span>가슴</span>
                <span>운동</span>
                <span>100</span>
                <span>kg</span>
                <span>✕</span>
                <span>1</span>
                <span>회</span>
                <button class="remove-btn">—</button>
              </div>
              <div class="set-item">
                <span>어깨</span>
                <span>운동</span>
                <span>100</span>
                <span>kg</span>
                <span>✕</span>
                <span>1</span>
                <span>회</span>
                <button class="remove-btn">—</button>
              </div>
              <div class="set-item">
                <span>복근</span>
                <span>운동</span>
                <span>100</span>
                <span>kg</span>
                <span>✕</span>
                <span>1</span>
                <span>회</span>
                <button class="remove-btn">—</button>
              </div>

          </section>
        </div>

        <div class="box3">
          <section class="rm-box">
            <h4 class="rm-box-header">1RM</h4>
            <div class="rm-stats">
              <div>벤치프레스<br /><strong>120</strong></div>
              <div>데드리프트<br /><strong>220</strong></div>
              <div>스쿼트<br /><strong>200</strong></div>
            </div>
          </section>


          <section class="rm-weight">
            <h4>1RM 무게</h4>
            <form class="set-form">
              <select>
                <option>부위</option>
                <option>가슴</option>
                <option>등</option>
              </select>

              <select>
                <option>운동</option>
                <option>벤치프레스</option>
                <option>스쿼트</option>
              </select>

              <span>무게</span>
              <input type="text" placeholder="숫자" />
              <span>kg</span>
              <span>×</span>
              <input type="text" placeholder="숫자" />
              <span>회</span>

              <button type="submit" class="btn-plus">+</button>
            </form>

            <!-- -- + 클릭시 추가되는 폼 (js)-- -->
            <div class="set-list">
              <div class="set-item">
                <span>가슴</span>
                <span>운동</span>
                <span>100</span>
                <span>kg</span>
                <span>✕</span>
                <span>1</span>
                <span>회</span>
                <button class="remove-btn">—</button>
              </div>
              <div class="set-item">
                <span>어깨</span>
                <span>운동</span>
                <span>100</span>
                <span>kg</span>
                <span>✕</span>
                <span>1</span>
                <span>회</span>
                <button class="remove-btn">—</button>
              </div>
              <div class="set-item">
                <span>복근</span>
                <span>운동</span>
                <span>100</span>
                <span>kg</span>
                <span>✕</span>
                <span>1</span>
                <span>회</span>
                <button class="remove-btn">—</button>
              </div>

          </section>
        </div>
      </main>
    </div>

    <footer>
      <p>Copyright © 2025. FitLink All rights reserved.</p>
    </footer>
  </div>
</body>

</html>