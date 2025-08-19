<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>예약현황</title>

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
		<!-- ------헤더------ -->
		<header>
			<!-- 왼쪽: 이미지 로고 (변경됨) -->
			<a href="" class="btn-logout"> <!-- 여기에 실제 로고 이미지 파일을 연결하세요 --> <img src="../../../../project/front/assets/images/logo.jpg" alt="FitLnk Logo" />
			</a>

			<!-- 오른쪽: 사용자 메뉴 -->
			<div class="btn-logout">
				<a href="#" class="logout-link"> <i class="fa-solid fa-right-from-bracket"></i> 로그아웃
				</a>
			</div>
		</header>

		<!-- --aside + main-- -->
		<div id="content">
			<aside>
				<div class="user-info">
					<div class="user-name-wrap">
						<img class="dumbell-icon" src="../../assets/images/사이트로고.jpg" alt="dumbell-icon" />
						<p class="user-name">
							홍길동<br /> <small>(회원)</small>
						</p>
					</div>
					<div class="trainer-info">
						<i class="fa-solid fa-clipboard-user"></i> <span>1 Trainer</span>
					</div>
				</div>
				<div class="aside-menu">
					<a href="#" class="menu-item"> <i class="fa-solid fa-book"></i> <span>운동일지</span>
					</a> <a href="#" class="menu-item"> <i class="fa-solid fa-chart-pie"></i> <span>InBody & Meal</span>
					</a> <a href="#" class="menu-item"> <i class="fa-solid fa-images"></i> <span>사진</span>
					</a> <a href="#" class="menu-item"> <i class="fa-solid fa-calendar-check"></i> <span>예약현황</span>
					</a> <a href="#" class="menu-item"> <i class="fa-solid fa-list-ul"></i> <span>운동종류</span>
					</a>
				</div>
			</aside>

			<main>
				<!-- 1. 제목 -->
				<div class="page-header">
					<h3 class="page-title">Booking Status</h3>
				</div>
				<!-- //1. 제목 -->

				<!-- 2. 달력 -->
				<div class="calendar-card">
					<!-- FullCalendar가 내부에 DOM을 생성하여 출력 -->
					<div id="calendar"></div>
				</div>
				<!-- //2. 달력 -->

				<!-- 3. 구분선 -->
				<div class="line"></div>
				<!-- //3. 구분선 -->

				<!-- 4. 회원수업 리스트 섹션 -->
				<section class="card2 list-card">
					<div class="card-header">
						<h4 class="card-title list-title">PT 리스트</h4>
					</div>

					<div class="table-wrap">
						<table class="table">
							<colgroup>
								<col class="w-60">
								<!-- 순서 -->
								<col class="w-110">
								<!-- 날짜 -->
								<col class="w-90">
								<!-- 시간 -->
								<col class="w-90">
								<!-- 트레이너 (가변) -->
								<col class="w-100">
								<!-- PT 등록일수 -->
								<col class="w-100">
								<!-- PT 수업일수 -->
								<col class="w-100">
								<!-- PT 잔여일수 -->
								<col class="w-80">
								<!-- actions -->
							</colgroup>
							<thead>
								<tr>
									<th>순서</th>
									<th>날짜</th>
									<th>시간</th>
									<th>트레이너</th>
									<th>PT 등록일수</th>
									<th>PT 수업일수</th>
									<th>PT 잔여일수</th>
									<th class="actions-head"></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>1</td>
									<td>2025.07.01</td>
									<td>14:00</td>
									<td class="truncate" title="조강민">조강민</td>
									<td>30회</td>
									<td>1회</td>
									<td>29회</td>
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
				<!-- //4. 회원수업 리스트 섹션 -->
			</main>
		</div>
		
		<footer>
			<p>Copyright © 2025. FitLink All rights reserved.</p>
		</footer>

		<!-- ===== PT예약 모달 (오버레이 + iframe) =====
         - 모달을 열면 overlay가 보이고, 내부 iframe에 별도의 페이지를 로드
         - iframe 내부에서 저장/삭제/닫기 등 독립 UI를 제공 -->
		<div id="scheduleModal" class="modal-overlay">
			<div class="modal-container">
				<!-- iframe: 실제 모달 콘텐츠(근무시간 등록 페이지)가 로딩되는 프레임 -->
				<iframe id="modalFrame" class="modal-iframe" title="PT예약" src="about:blank"></iframe>
			</div>
		</div>
		
		<!------------------------------------------ script ------------------------------------------>
		<script>
			document.addEventListener('DOMContentLoaded', function () {
			  // JSP 컨텍스트 루트 (예: "", "/fitlink")
			  const CTX = '<%=request.getContextPath()%>';
			
			  /* ======================
			     모달 열기/닫기 유틸
			     ====================== */
			  const overlay = document.getElementById('scheduleModal'); // 배경
			  const frame   = document.getElementById('modalFrame');    // 안쪽 iframe
			
			  // [수정] 날짜(YYYY-MM-DD)를 쿼리로 붙여 모달 열기
			  function openModal(dateStr) {
			    frame.src = CTX + '/member/booking-insert?date=' + encodeURIComponent(dateStr);
			    overlay.classList.add('show');
			    document.body.classList.add('noscroll');
			  }
			
			  function closeModal() {
			    frame.src = 'about:blank';
			    overlay.classList.remove('show');
			    document.body.classList.remove('noscroll');
			  }
			
			  // 배경 클릭 → 닫기
			  overlay.addEventListener('click', (e) => {
			    if (e.target === overlay) closeModal();
			  });
			
			  // ESC → 닫기
			  document.addEventListener('keydown', (e) => {
			    if (e.key === 'Escape') closeModal();
			  });
			
			  // [추가] 모달(iframe)에서 보내는 메시지 수신
			  //   - {type:'booking-done'} : 예약 완료 → 닫고 새로고침
			  //   - {type:'modal-close'}  : 그냥 닫기
			  window.addEventListener('message', (e) => {
			    if (!e.data) return;
			    if (e.data.type === 'booking-done' || e.data.type === 'modal-close') {
			      closeModal();
			      // 가장 단순: 페이지 전체 새로고침(달력/리스트 동시 갱신)
			      location.reload();
			    }
			  });
			
			  /* ======================
			     FullCalendar 설정
			     ====================== */
			  const calendarEl = document.getElementById('calendar');
			  const calendar = new FullCalendar.Calendar(calendarEl, {
			    initialView: 'dayGridMonth',
			    locale: 'ko',
			    headerToolbar: {
			      left: 'prev,next today',
			      center: 'title',
			      right: 'dayGridMonth,timeGridWeek,timeGridDay'
			    },
			    buttonText: { today: 'today', month:'month', week:'week', day:'day' },
			    dayCellContent(arg) {
			      // '1일' → '1'로 보이게
			      const text = arg.dayNumberText.replace(/일/g, '');
			      return { html: text };
			    },
			    height: 'auto',
			    weekends: true,
			
			    // 날짜 클릭 → 모달 오픈
			    dateClick(info) { openModal(info.dateStr); },
			
			    // [유지] 이벤트는 나중에 API 붙일 때 교체
			    events: [],
			
			    // (선택) 이벤트 클릭시 행동
			    eventClick(info) {
			      alert('수업 정보: ' + info.event.title);
			    }
			  });
			
			  calendar.render();
			});
		</script>
	</div>
</body>
</html>