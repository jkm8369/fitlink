<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Schedule - FitLink</title>

<link rel="stylesheet" href="../../assets/css/reset.css" />
<link rel="stylesheet" href="../../assets/css/include.css" />

<!-- member.css 먼저 (예약/멤버 전용 스타일) -->
<link rel="stylesheet" href="../../assets/css/member.css" />

<!-- FullCalendar CSS (오버라이드보다 앞) -->
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/main.min.css" rel="stylesheet" />

<!-- trainer.css 마지막 (오버라이드 포함) -->
<link rel="stylesheet" href="../../assets/css/trainer.css" />
<link rel="stylesheet" href="../../assets/css/schedule_modal.css" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

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
							홍길동<br /> <small>(트레이너)</small>
						</p>
					</div>
				</div>

				<div class="aside-menu">
					<a href="#" class="menu-item"> <i class="fa-solid fa-address-card"></i> <span>회원</span>
					</a> <a href="#" class="menu-item"> <i class="fa-solid fa-calendar-days"></i> <span>일정</span>
					</a> <a href="#" class="menu-item"> <i class="fa-solid fa-list-ul"></i> <span>운동종류</span>
					</a>
				</div>
			</aside>

			<main>
				<!-- 1. 제목 -->
				<div class="page-header">
					<h3 class="page-title">Schedule</h3>
				</div>
				<!-- //1. 제목 -->

				<!-- 2. 달력 -->
				<div class="calendar-card">
					<div id="calendar"></div>
				</div>
				<!-- //2. 달력 -->

				<!-- 3. 구분선 -->
				<div class="line"></div>
				<!-- //3. 구분선 -->

				<!-- 4. 트레이너 수업 리스트 섹션 -->
				<section class="card2 list-card">
					<div class="card-header">
						<h4 class="card-title list-title">회원 수업 리스트</h4>
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
								<!-- 회원(가변) -->
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
									<th>회원</th>
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
				<!-- //4. 트레이너 수업 리스트 섹션 -->
			</main>
		</div>

		<footer>
			<p>Copyright © 2025. FitLink All rights reserved.</p>
		</footer>

		<div id="scheduleModal" class="modal-overlay">
			<div class="modal-container">
				<iframe id="modalFrame" class="modal-iframe" title="근무시간 등록" src="about:blank"></iframe>
			</div>
		</div>


		<!-- ----------------------------------------------------------------------- -->
		<script>
		document.addEventListener('DOMContentLoaded', function () {
			  const CTX = '<%=request.getContextPath()%>';

			  // ===== 모달 열기/닫기 유틸 =====
			  const overlay = document.getElementById('scheduleModal');   // ②에서 추가한 오버레이
			  const frame   = document.getElementById('modalFrame');      // ②에서 추가한 iframe

			  function openModal(dateStr) {
				  const d = encodeURIComponent(dateStr);
				  frame.src = CTX + '/trainer/schedule-insert?date=' + d;
				  overlay.classList.add('show');
				  document.body.classList.add('noscroll');
				}

				function closeModal() {
				  frame.src = 'about:blank';
				  overlay.classList.remove('show');
				  document.body.classList.remove('noscroll');
				}

				// 배경 클릭 시 닫기
				overlay.addEventListener('click', (e) => {
				  if (e.target === overlay) closeModal();
				});

				// ESC 키로 닫기
				document.addEventListener('keydown', (e) => {
				  if (e.key === 'Escape') closeModal();
				});
				
			  	window.addEventListener('message', (e) => {if (e.data && e.data.type === 'modal-close') {closeModal();}});
			  	
			  // ===== FullCalendar =====
			  const calendarEl = document.getElementById('calendar');
			  const calendar = new FullCalendar.Calendar(calendarEl, {
			    initialView: 'dayGridMonth',
			    locale: 'ko',
			    headerToolbar: { left: 'prev,next today', center: 'title', right: 'dayGridMonth,timeGridWeek,timeGridDay' },
			    buttonText: { today: 'today', month: 'month', week: 'week', day: 'day' },
			    dayCellContent(arg) {
			      const text = arg.dayNumberText.replace(/일/g, '');
			      return { html: text };
			    },
			    height: 'auto',
			    weekends: true,

			    // 모달 열기
			    dateClick(info) {
			      openModal(info.dateStr);
			    },

			    events: [
			      { title: 'PT - 조강민', start: '2025-08-14T14:00:00', backgroundColor: '#007bff' },
			      { title: 'PT - 김동민', start: '2025-08-15T15:00:00', backgroundColor: '#28a745' }
			    ],
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