<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Schedule - FitLink</title>

<!-- 기본 리셋/공용 스타일 -->
<link rel="stylesheet" href="../../assets/css/reset.css" />
<link rel="stylesheet" href="../../assets/css/include.css" />

<!-- member 전용 스타일 (예약/멤버 관련) -->
<link rel="stylesheet" href="../../assets/css/member.css" />

<!-- 트레이너/페이지 커스텀 스타일 (오버라이드 포함해서 가장 뒤쪽에) -->
<link rel="stylesheet" href="../../assets/css/trainer.css" />
<link rel="stylesheet" href="../../assets/css/schedule_modal.css" />

<!-- 아이콘 (폰트어썸) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

</head>

<body>
  <div id="wrap">
    <!-- ===== 헤더 영역 ===== -->
    <header>
      <!-- 왼쪽: 로고 (현재는 단순 링크) -->
      <!-- TODO: 실제 서비스에서는 href에 대시보드/홈 경로 연결 -->
      <a href="" class="btn-logout">
        <!-- 이미지 경로는 프로젝트 구조에 맞게 수정 -->
        <img src="../../../../project/front/assets/images/logo.jpg" alt="FitLnk Logo" />
      </a>

      <!-- 오른쪽: 사용자 메뉴 (로그아웃 버튼) -->
      <div class="btn-logout">
        <a href="#" class="logout-link">
          <i class="fa-solid fa-right-from-bracket"></i> 로그아웃
        </a>
      </div>
    </header>

    <!-- ===== 본문 영역: aside + main ===== -->
    <div id="content">
      <!-- 사이드바: 사용자 정보/메뉴 -->
      <aside>
        <div class="user-info">
          <div class="user-name-wrap">
            <!-- 프로필 아이콘/로고 -->
            <img class="dumbell-icon" src="../../assets/images/사이트로고.jpg" alt="dumbell-icon" />
            <!-- 로그인 사용자명 + 역할 -->
            <p class="user-name">
              홍길동<br />
              <small>(트레이너)</small>
            </p>
          </div>
        </div>

        <!-- 좌측 메뉴 (현재는 데모 링크) -->
        <!-- TODO: 실제 라우팅 경로로 연결 -->
        <div class="aside-menu">
          <a href="#" class="menu-item">
            <i class="fa-solid fa-address-card"></i> <span>회원</span>
          </a>
          <a href="#" class="menu-item">
            <i class="fa-solid fa-calendar-days"></i> <span>일정</span>
          </a>
          <a href="#" class="menu-item">
            <i class="fa-solid fa-list-ul"></i> <span>운동종류</span>
          </a>
        </div>
      </aside>

      <!-- 메인 콘텐츠 -->
      <main>
        <!-- 1) 페이지 제목 -->
        <div class="page-header">
          <h3 class="page-title">Schedule</h3>
        </div>

        <!-- 2) 달력 카드: FullCalendar가 렌더링될 영역 -->
        <div class="calendar-card">
          <!-- FullCalendar가 내부에 DOM을 생성 -->
          <div id="calendar"></div>
        </div>

        <!-- 3) 구분선(디자인용) -->
        <div class="line"></div>

        <!-- 4) 트레이너 수업 리스트(데모 표) -->
        <!-- 실제에선 서버 데이터로 렌더링 -->
        <section class="card2 list-card">
          <div class="card-header">
            <h4 class="card-title list-title">회원 수업 리스트</h4>
          </div>

          <div class="table-wrap">
            <!-- colgroup: 각 칼럼 너비 고정으로 레이아웃 안정화 -->
            <table class="table">
              <colgroup>
                <col class="w-60"><!-- 순서 -->
                <col class="w-110"><!-- 날짜 -->
                <col class="w-90"><!-- 시간 -->
                <col class="w-90"><!-- 회원 -->
                <col class="w-100"><!-- PT 등록일수 -->
                <col class="w-100"><!-- PT 수업일수 -->
                <col class="w-100"><!-- PT 잔여일수 -->
                <col class="w-80"><!-- actions -->
              </colgroup>
              <thead>
                <tr>
                  <th>순서</th>
                  <th>날짜</th>
                  <th>시간</th>
                  <th>회원</th>
                  <th>PT 등록일수</th>
                  <th>PT 수업일수</th>
                  <th>PT 잔여일수</th>
                  <th class="actions-head"></th>
                </tr>
              </thead>
              <tbody>
                <!-- ⬇ 데모 행 (정적) -->
                <tr>
                  <td>1</td>
                  <td>2025.07.01</td>
                  <td>14:00</td>
                  <td class="truncate" title="조강민">조강민</td>
                  <td>30회</td>
                  <td>1회</td>
                  <td>29회</td>
                  <td class="actions">
                    <!-- 취소/삭제 등 액션 아이콘 -->
                    <button class="icon-btn" aria-label="취소">
                      <i class="fa-solid fa-xmark"></i>
                    </button>
                  </td>
                </tr>
                <tr>
                  <td>2</td>
                  <td>2025.07.14</td>
                  <td>15:00</td>
                  <td class="truncate" title="김동민">김동민</td>
                  <td>30회</td>
                  <td>2회</td>
                  <td>28회</td>
                  <td class="actions">
                    <button class="icon-btn" aria-label="취소">
                      <i class="fa-solid fa-xmark"></i>
                    </button>
                  </td>
                </tr>
                <tr>
                  <td>3</td>
                  <td>2025.07.20</td>
                  <td>18:00</td>
                  <td class="truncate" title="김동민">김동민</td>
                  <td>30회</td>
                  <td>3회</td>
                  <td>27회</td>
                  <td class="actions">
                    <button class="icon-btn" aria-label="취소">
                      <i class="fa-solid fa-xmark"></i>
                    </button>
                  </td>
                </tr>
                <!-- ⬆ 데모 행 끝 -->
              </tbody>
            </table>
          </div>
        </section>
      </main>
    </div>

    <!-- 푸터 -->
    <footer>
      <p>Copyright © 2025. FitLink All rights reserved.</p>
    </footer>

  </div>
</body>
</html>
