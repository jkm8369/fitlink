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

  <!-- FullCalendar 기본 CSS (나중에 오버라이드할 trainer.css보다 먼저 불러오기) -->
  <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.min.css" rel="stylesheet" />

  <!-- 트레이너/페이지 커스텀 스타일 (오버라이드 포함해서 가장 뒤쪽에) -->
  <link rel="stylesheet" href="../../assets/css/trainer.css" />
  <link rel="stylesheet" href="../../assets/css/schedule_modal.css" />

  <!-- 아이콘 (폰트어썸) -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

  <!-- FullCalendar JS (브라우저 전역으로 제공되는 번들) -->
  <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
</head>

<body>
  <div id="wrap">
    <!-- ===== 헤더 영역 ===== -->
    <header>
      <!-- 왼쪽: 로고 영역 (현재는 링크 + 이미지)
           실제 서비스에서는 a 태그의 href에 대시보드/홈 링크를 연결 -->
      <a href="" class="btn-logout">
        <!-- 이미지 경로는 프로젝트 구조에 맞게 조정 -->
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
            <img class="dumbell-icon" src="../../assets/images/사이트로고.jpg" alt="dumbell-icon" />
            <p class="user-name">
              홍길동<br />
              <small>(트레이너)</small>
            </p>
          </div>
        </div>

        <!-- 좌측 메뉴 (현재는 링크만 존재, 실제 페이지 연결 필요) -->
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
          <!-- FullCalendar가 내부에 DOM을 생성하여 출력 -->
          <div id="calendar"></div>
        </div>

        <!-- 3) 구분선(디자인용) -->
        <div class="line"></div>

        <!-- 4) 트레이너 수업 리스트: 표 형태(데모 데이터) -->
        <section class="card2 list-card">
          <div class="card-header">
            <h4 class="card-title list-title">회원 수업 리스트</h4>
          </div>

          <div class="table-wrap">
            <!-- colgroup으로 각 칼럼 폭을 지정(디자인 일관성) -->
            <table class="table">
              <colgroup>
                <col class="w-60">   <!-- 순서 -->
                <col class="w-110">  <!-- 날짜 -->
                <col class="w-90">   <!-- 시간 -->
                <col class="w-90">   <!-- 회원 -->
                <col class="w-100">  <!-- PT 등록일수 -->
                <col class="w-100">  <!-- PT 수업일수 -->
                <col class="w-100">  <!-- PT 잔여일수 -->
                <col class="w-80">   <!-- actions -->
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
                <!-- 아래 데이터는 정적 데모. 실제로는 서버에서 받아서 렌더링 필요 -->
                <tr>
                  <td>1</td>
                  <td>2025.07.01</td>
                  <td>14:00</td>
                  <td class="truncate" title="조강민">조강민</td>
                  <td>30회</td>
                  <td>1회</td>
                  <td>29회</td>
                  <td class="actions">
                    <!-- 취소/삭제 등의 액션 아이콘 (현재는 클릭 시 동작 없음) -->
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

    <!-- ===== 근무시간 등록 모달 (오버레이 + iframe) =====
         - 모달을 열면 overlay가 보이고, 내부 iframe에 별도의 페이지를 로드
         - iframe 내부에서 저장/삭제/닫기 등 독립 UI를 제공 -->
    <div id="scheduleModal" class="modal-overlay">
      <div class="modal-container">
        <!-- iframe: 실제 모달 콘텐츠(근무시간 등록 페이지)가 로딩되는 프레임 -->
        <iframe id="modalFrame" class="modal-iframe" title="근무시간 등록" src="about:blank"></iframe>
      </div>
    </div>

    <!-- ===== 페이지 스크립트 (DOM이 모두 그려진 후 실행) ===== -->
    <script>
      document.addEventListener('DOMContentLoaded', function () {
        // JSP 컨텍스트 루트 (예: "/", "/fitlink" 등)
        const CTX = '<%=request.getContextPath()%>';

        // -----------------------------
        //  모달 열기/닫기 관련 유틸 함수
        // -----------------------------
        const overlay = document.getElementById('scheduleModal'); // 모달 전체 배경(오버레이)
        const frame   = document.getElementById('modalFrame');    // 모달 내부 iframe

        // 특정 날짜(dateStr = "YYYY-MM-DD")를 쿼리로 주어 모달을 연다.
        function openModal(dateStr) {
          // dateStr을 URL에 넣을 때 안전하게 전달하기 위해 인코딩
          const d = encodeURIComponent(dateStr);
          // 모달에 띄울 페이지 경로: /trainer/schedule-insert?date=YYYY-MM-DD
          // - 이 페이지는 "근무시간 등록" 전용 화면(체크박스 그리드 등)을 제공
          frame.src = CTX + '/trainer/schedule-insert?date=' + d;

          // 오버레이 보이기 + 스크롤 방지
          overlay.classList.add('show');
          document.body.classList.add('noscroll');
        }

        // 모달 닫기: iframe 비우고, 오버레이 숨기기 + 스크롤 재허용
        function closeModal() {
          frame.src = 'about:blank';
          overlay.classList.remove('show');
          document.body.classList.remove('noscroll');
        }

        // (UX) 오버레이의 빈 배경을 클릭하면 모달 닫기
        // - e.target이 overlay 자체일 때만 닫음 (안쪽 컨테이너 클릭은 무시)
        overlay.addEventListener('click', (e) => {
          if (e.target === overlay) closeModal();
        });

        // (UX) 키보드 ESC로 모달 닫기
        document.addEventListener('keydown', (e) => {
          if (e.key === 'Escape') closeModal();
        });

        // iframe 내부(모달 콘텐츠)에서 부모에게 postMessage로 "modal-close"를 보내면 닫기
        // - iframe 안쪽 JS: window.parent.postMessage({ type: 'modal-close' }, origin)
        window.addEventListener('message', (e) => {
          if (e.data && e.data.type === 'modal-close') {
            closeModal();
          }
        });

        // -----------------------------
        //  FullCalendar 초기화/설정
        // -----------------------------
        const calendarEl = document.getElementById('calendar');

        // FullCalendar 인스턴스 생성
        const calendar = new FullCalendar.Calendar(calendarEl, {
          // 초기 표시는 "월" 단위 그리드
          initialView: 'dayGridMonth',

          // 한글 로케일 적용 (요일/월 이름 등 한글화)
          locale: 'ko',

          // 상단 툴바 버튼 배치
          headerToolbar: {
            left: 'prev,next today',                // 왼쪽: 이전/다음/오늘
            center: 'title',                        // 가운데: 현재 달 제목
            right: 'dayGridMonth,timeGridWeek,timeGridDay' // 오른쪽: 보기 전환
          },

          // 버튼에 표시될 텍스트(영문 토큰을 원하는 텍스트로)
          // - locale을 ko로 설정했기 때문에 한국어가 기본 적용되지만,
          //   여기서 직접 텍스트를 지정하면 그것이 우선 적용됨.
          buttonText: {
            today: 'today',
            month: 'month',
            week: 'week',
            day: 'day'
          },

          // 월 셀에 표시되는 날짜 텍스트 커스터마이즈
          // - arg.dayNumberText에는 "1일", "2일"처럼 '일'이 붙어올 수 있어 이를 제거
          dayCellContent(arg) {
            const text = arg.dayNumberText.replace(/일/g, '');
            return { html: text };
          },

          // 높이를 자동으로(부모 컨테이너 크기에 맞춤)
          height: 'auto',

          // 주말(토/일) 표시 여부 (true면 표시)
          weekends: true,

          // 달력에서 특정 날짜를 클릭했을 때 실행
          // - 사용자가 클릭한 날짜 문자열(info.dateStr = "YYYY-MM-DD")로 모달을 연다
          dateClick(info) {
            openModal(info.dateStr);
          },

          // 데모용 이벤트(수업 일정) - 실제 프로젝트에서는 서버에서 받아온 데이터를 사용
          // - start에 ISO 날짜/시간 문자열을 지정
          events: [
            { title: 'PT - 조강민', start: '2025-08-14T14:00:00', backgroundColor: '#007bff' },
            { title: 'PT - 김동민', start: '2025-08-15T15:00:00', backgroundColor: '#28a745' }
          ],

          // 이벤트(수업)를 클릭했을 때 실행
          // - 여기서는 간단히 알럿으로 제목만 표시(추후 상세 모달로 확장 가능)
          eventClick(info) {
            alert('수업 정보: ' + info.event.title);
          }
        });

        // 달력 렌더링 시작 (이 호출 이후 실제 DOM에 달력이 그림)
        calendar.render();
      });
    </script>
  </div>
</body>

</html>
