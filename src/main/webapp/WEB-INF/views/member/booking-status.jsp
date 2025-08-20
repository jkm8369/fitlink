<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
				<jsp:useBean id="now" class="java.util.Date" />
				<c:set var="MILLIS_24H" value="${24*60*60*1000}" />

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
								<c:forEach var="row" items="${rows}" varStatus="s">
									<!-- ① 수업 시작 시각으로 파싱 (date: yyyy.MM.dd, time: HH:mm) -->
									<fmt:parseDate value="${row.date} ${row.time}" pattern="yyyy.MM.dd HH:mm" var="startDt" />

									<tr>
										<td>${s.count}</td>
										<td>${row.date}</td>
										<td>${row.time}</td>
										<td class="truncate" title="${row.name}">${row.name}</td>
										<td>${row.total}회</td>
										<td class="js-used" data-used="${empty row.used ? 0 : row.used}"><c:out value="${row.used}" default="0" />회</td>
										<td class="js-remain" data-remain="${empty row.remain ? 0 : row.remain}"><c:out value="${row.remain}" default="0" />회</td>

										<!-- ② 24시간 전까지만 취소 버튼 보이기 -->
										<td class="actions"><c:if test="${startDt.time - now.time >= MILLIS_24H}">
												<button type="button" class="icon-btn js-cancel" data-id="${row.no}" aria-label="취소">
													<i class="fa-solid fa-xmark"></i>
												</button>
											</c:if></td>
									</tr>
								</c:forEach>

								<c:if test="${empty rows}">
									<tr>
										<td class="pt-list-empty" colspan="8">예약이 없습니다.</td>
									</tr>
								</c:if>
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
			const CTX = '<%=request.getContextPath()%>';
			let calendar;
			  
			document.addEventListener('DOMContentLoaded', function () {
						
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
			  calendar = new FullCalendar.Calendar(calendarEl, {
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
			    
			    // ✅ 24시간제 시간 표시 형식 (14:00)
			    eventTimeFormat: { hour: '2-digit', minute: '2-digit', hour12: false },

			    // ✅ 이벤트를 "시간만" 보이게 커스텀 렌더
			    eventContent(arg) {
			      // arg.timeText 예: "14:00"
			      const el = document.createElement('span');
			      el.className = 'only-time';
			      el.textContent = arg.timeText || ''; // 제목 없이 시간만
			      return { domNodes: [el] };
			    },

			    // ✅ 달력에 "내 예약" 불러오기
			    //    FullCalendar가 start, end를 쿼리로 넘겨줍니다 (ISO-8601)
			    events: function(info, success, failure) {
		    	 const url = CTX + '/api/member/booking/events'
		    	     + '?start=' + encodeURIComponent(info.startStr)
		    	     + '&end='   + encodeURIComponent(info.endStr);
		     	 fetch(url, { credentials: 'same-origin' })
			        .then(r => r.json())
			        .then(data => success(data))
			        .catch(err => failure(err));
			    },
			    // 날짜 클릭 → 모달 오픈
			    dateClick(info) { openModal(info.dateStr); },
						
			    // (선택) 이벤트 클릭시 행동
			    eventClick(info) {
		    	  const t = info.event.start;
		    	  alert('수업 시간: ' + t.toLocaleTimeString([], {hour:'2-digit', minute:'2-digit'}));
		    	}
			  });
			  calendar.render();
			  
			  window.calendar = calendar;
			});
			
			// ✅ 예약 취소(행 삭제 + 수업/잔여 실시간 갱신)
			document.addEventListener('click', async (e) => {
			  const btn = e.target.closest('button.js-cancel[data-id]');
			  if (!btn) return;

			  if (!confirm('이 예약을 취소할까요? (수업 시작 24시간 전까지만 가능)')) return;

			  // 중복 클릭 방지
			  if (btn.dataset.busy === '1') return;
			  btn.dataset.busy = '1';
			  btn.disabled = true;

			  const reservationId = Number(btn.dataset.id);
			  const headers = { 'Content-Type': 'application/json' };
			  const token  = document.querySelector('meta[name="_csrf"]')?.content;
			  const header = document.querySelector('meta[name="_csrf_header"]')?.content;
			  if (token && header) headers[header] = token;

			  try {
			    const res = await fetch(`${CTX}/api/member/booking/cancel`, {
			      method: 'POST',
			      headers,
			      credentials: 'same-origin',
			      body: JSON.stringify({ reservationId })
			    });
			    if (!res.ok) throw new Error('network');
			    const data = await res.json();

			    if (!data.success) {
			      alert(data.message || '취소할 수 없습니다.');
			      btn.disabled = false;
			      delete btn.dataset.busy;
			      return;
			    }

			    // 1) 테이블 행 제거
			    btn.closest('tr')?.remove();

			    // 2) 수업/잔여 숫자 갱신 (모든 행에 동일 값 표시되는 구조)
				const usedEls   = [...document.querySelectorAll('td.js-used')];
				const remainEls = [...document.querySelectorAll('td.js-remain')];
				
				if (usedEls.length && remainEls.length) {
				  const normalize = (td, attr) => {
				    // 1) data-* 우선, 2) 텍스트 파싱, 3) 둘 다 없으면 0
				    const fromData = td?.dataset?.[attr];
				    if (fromData != null && fromData !== '') return parseInt(fromData, 10) || 0;
				    const m = String(td?.textContent || '').match(/\d+/);
				    return m ? parseInt(m[0], 10) : 0;
				  };
				
				  const curUsed   = normalize(usedEls[0], 'used');     // data-used 지원
				  const curRemain = normalize(remainEls[0], 'remain'); // data-remain 지원
				
				  const newUsed   = Math.max(0, curUsed - 1);
				  const newRemain = curRemain + 1;
				
				  usedEls.forEach(td   => { td.dataset.used   = newUsed;   td.textContent = `${newUsed}회`; });
				  remainEls.forEach(td => { td.dataset.remain = newRemain; td.textContent = `${newRemain}회`; });
				}

			    // 3) 순번 재정렬(보기 좋게)
			    document.querySelectorAll('.table tbody tr').forEach((row, i) => {
			      const first = row.querySelector('td:first-child');
			      if (first) first.textContent = String(i + 1);
			    });

			    // 4) 달력 이벤트만 새로고침 (있으면)
			    window.calendar?.refetchEvents?.();

			  } catch (err) {
			    console.error(err);
			    alert('서버 통신 중 오류가 발생했습니다.');
			    btn.disabled = false;
			    delete btn.dataset.busy;
			  }
			});
		</script>
	</div>
</body>
</html>