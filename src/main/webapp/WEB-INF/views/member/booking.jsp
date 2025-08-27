<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>예약현황</title>

<!-- 기본 리셋/공용 스타일 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/include.css" />
<!-- member 전용 스타일 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member.css" />
<!-- 트레이너/페이지 커스텀 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/trainer.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modal.css" />

<!-- 아이콘 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

<!-- FullCalendar CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/main.min.css" />

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js" crossorigin="anonymous"></script>

<!-- FullCalendar JS + locales -->
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/locales-all.global.min.js"></script>

</head>

<body>
	<div id="wrap">
		<!-- ------헤더------ -->
		<c:import url="/WEB-INF/views/include/header.jsp"></c:import>
		<!-- //------헤더------ -->

		<div id="content">
		<!-- ------aside------ -->
			<aside>
				<div class="user-info">
	            	<c:import url="/WEB-INF/views/include/aside-member.jsp"></c:import>
				</div>
			</aside>
		<!-- ------aside------ -->

			<!-- main -->

			<main>
				<!-- 제목 -->
				<div class="page-header">
					<h3 class="page-title">Booking Status</h3>
				</div>

				<!-- 달력 -->
				<div class="calendar-card">
					<div id="calendar"></div>
				</div>

				<div class="line"></div>

				<!-- 하단 PT 리스트 -->
				<section class="card2 list-card">
					<div class="card-header">
						<h4 class="card-title list-title">PT 리스트</h4>
					</div>
					<div class="table-wrap">
						<table class="table">
							<colgroup>
								<col class="w-60" />
								<col class="w-110" />
								<col class="w-90" />
								<col class="w-120" />
								<col class="w-100" />
								<col class="w-100" />
								<col class="w-100" />
								<col class="w-80" />
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
							<tbody id="pt-body">
								<!-- JS로 렌더 -->
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

	<!-- ====== 모달(회원 예약용) ====== -->
	<div id="schedule-modal" class="modal-overlay" style="display: none;">
		<div class="modal-container is-inner">
			<div class="modal-header">
				<h2 class="modal-title">시간 선택</h2>
				<button class="modal-close-btn" type="button" onclick="closeScheduleModal()">
					<i class="fa-solid fa-xmark"></i>
				</button>
			</div>

			<div class="modal-body">
				<div class="time-selector">
					<p class="time-selector-date" id="modal-date">선택된 날짜</p>
					<div class="time-grid" id="modal-time-container"></div>

					<div class="legend">
						<div class="legend-item">
							<span class="legend-color available"></span><span>예약 가능</span>
						</div>
						<div class="legend-item">
							<span class="legend-color unavailable"></span><span>예약 불가</span>
						</div>
						<div class="legend-item">
							<span class="legend-color selected"></span><span>선택됨</span>
						</div>
					</div>
				</div>
			</div>

			<div class="modal-footer">
				<button class="submit-btn save-btn" id="modal-save-btn" type="button">예약하기</button>
			</div>
		</div>
	</div>

	<!-- ================== Script ================== -->
	<script>
	 const CTX = '${pageContext.request.contextPath}';
	 let calendar;
	
	 document.addEventListener('DOMContentLoaded', function () {
	   const calendarEl = document.getElementById('calendar');
	
	   calendar = new FullCalendar.Calendar(calendarEl, {
	     locale: 'ko',
	     initialView: 'dayGridMonth',
	     headerToolbar: { left: 'prev,next today', center: 'title', right: 'dayGridMonth,timeGridWeek,timeGridDay' },
	     displayEventTime: true,
	     eventTimeFormat: { hour: '2-digit', minute: '2-digit', hour12: false },
	
	     // 달력 이벤트(내 예약)
	     events: function (info, success) {
	       $.ajax({
	         url: CTX + '/api/member/booking/events',
	         method: 'GET',
	         data: { start: info.startStr, end: info.endStr },
	         dataType: 'json'
	       })
	       .done(function (rows) {
	         const BOOKED_COLOR = '#90CAF9';
	         const COMPLETED_COLOR = '#B0BEC5';
	         const events = (rows || []).map(row => {
	           const start = row.startDt || row.available_datetime;
	           const d = new Date(start);
	           return {
	             id: row.reservationId || start,
	             title: (row.trainerName || '예약'),
	             start: start,
	             end: new Date(d.getTime() + 60 * 60 * 1000).toISOString(),
	             backgroundColor: row.slotStatus === 'COMPLETED' ? COMPLETED_COLOR : BOOKED_COLOR
	           };
	         });
	         success(events);
	       })
	       .fail(function (jq) {
	         console.error('events load fail', jq.status, jq.responseText);
	         success([]);
	       });
	     },
	
	     // 날짜 클릭 → 모달(담당 트레이너의 해당일 슬롯)
	     dateClick: function (info) {
	       openScheduleModal(info.dateStr);
	     }
	   });
	
	   calendar.render();
	   // 하단 리스트 초기 로드
	   loadPtList();
	 });
	
	 /** 하단 PT 리스트 로드 */
	 function loadPtList() {
	   $.ajax({
	     url: CTX + '/api/member/booking/pt/list',
	     method: 'GET',
	     dataType: 'json'
	   })
	   .done(function (rows) {
	     const tbody = $('#pt-body').empty();
	     if (!rows || rows.length === 0) {
	       tbody.append('<tr><td class="pt-list-empty" colspan="8">예약이 없습니다.</td></tr>');
	       return;
	     }
	
	     rows.forEach(function (row, idx) {
	       // 날짜/시간
	       const dateStr = row.workDate; // 'YYYY-MM-DD'
	       const timeStr = row.hourLabel; // 'HH:mm'
	       // 취소 버튼 노출: 24시간 이전만
	       const canCancel = canCancelBy24h(dateStr, timeStr);
	
	       const tr = $('<tr/>');
	       tr.append($('<td/>').text(idx + 1));
	       tr.append($('<td/>').text(formatDate(row.workDate)));
	       tr.append($('<td/>').text(timeStr));
	       tr.append($('<td/>').text(row.trainerName || '-'));
	       tr.append($('<td/>').text(row.totalSessions ? row.totalSessions + '회' : '-'));
	       tr.append($('<td/>').text(row.completedCount ? row.completedCount + '회' : '-'));
	       tr.append($('<td/>').text(row.remainingCount ? row.remainingCount + '회' : '-'));
	
	       const tdAct = $('<td class="actions"/>');
	       if (canCancel && row.reservationId) {
	         const btn = $('<button type="button" class="icon-btn" aria-label="취소"><i class="fa-solid fa-xmark"></i></button>');
	         btn.on('click', function () {
	           if (confirm('이 예약을 취소할까요?')) cancelReservation(row.reservationId);
	         });
	         tdAct.append(btn);
	       }
	       tr.append(tdAct);
	       tbody.append(tr);
	     });
	   })
	   .fail(function (jq) {
	     console.error('pt list load fail', jq.status, jq.responseText);
	   });
	 }
	
	 /** 예약 취소(BOOKED만 서버에서 허용) */
	 function cancelReservation(reservationId) {
	   $.ajax({
	     url: CTX + '/api/member/booking/' + reservationId,
	     method: 'DELETE',
	     dataType: 'json'
	   })
	   .done(function () {
	     calendar.refetchEvents();
	     loadPtList();
	   })
	   .fail(function (jq) {
	     alert('취소에 실패했습니다.');
	     console.error('cancel fail', jq.status, jq.responseText);
	   });
	 }
	
	 /** 모달 열기 (회원은 예약 가능 슬롯만 선택 → 1개만 선택 허용) */
	 function openScheduleModal(dateStr) {
	   const $modal = $('#schedule-modal').addClass('member-mode');
	   const $timeBox = $('#modal-time-container').empty();
	   $('#modal-date').text(formatDateK(dateStr));
	
	   let selectedAvailabilityId = null; // 한 개만 선택
	
	   // 06~23 버튼 미리 생성
	   for (let h = 6; h <= 23; h++) {
	     const btn = $('<button class="time-slot-btn" type="button"/>').text(pad2(h) + ':00').attr('data-hour', h);
	     btn.on('click', function () {
	       const $b = $(this);
	       if ($b.hasClass('disabled')) return;
	       // 단일 선택
	       $timeBox.find('.time-slot-btn.selected').removeClass('selected');
	       $b.toggleClass('selected');
	     });
	     $timeBox.append(btn);
	   }
	
	   // 해당 날짜의 슬롯 상태 로드 (담당 트레이너는 서버에서 자동 추적)
	   $.ajax({
	     url: CTX + '/api/member/booking/slots/day',
	     method: 'GET',
	     data: { date: dateStr },
	     dataType: 'json'
	   })
	   .done(function (rows) {
	     (rows || []).forEach(function (row) {
	       const hour = parseInt(row.hourLabel.split(':')[0], 10);
	       const $btn = $timeBox.find('button[data-hour="' + hour + '"]');
	       if (!$btn.length) return;
	
	       if (row.slotStatus === 'AVAILABLE') {
	         // 예약 가능: availabilityId 저장하도록 클릭 시 기억
	         $btn.data('availabilityId', row.availabilityId);
	         $btn.on('click', function () {
	           selectedAvailabilityId = $(this).data('availabilityId');
	         });
	       } else {
	         // BOOKED/COMPLETED → 비활성
	         $btn.addClass('disabled').attr('title', row.slotStatus === 'BOOKED' ? '예약됨' : '완료');
	       }
	     });
	     
		// 1) 응답에 포함된 시간(HH)을 수집 (AVAILABLE/BOOKED/COMPLETED 모두)
	       const knownHours = new Set();
			(rows || []).forEach(function (row) {
			       const h = parseInt(row.hourLabel.split(':')[0], 10);
			       if (!isNaN(h)) knownHours.add(h);
			       });
		
		// 2) 생성된 모든 버튼 중, 응답에 없었던 시간 = 근무 아님(예약 불가)
		$timeBox.find('.time-slot-btn').each(function () {
		       const $b = $(this);
		       const h = parseInt($b.attr('data-hour'), 10);
		       if (!knownHours.has(h)) {
			       $b.addClass('unavailable').attr('title', '예약 불가');
			       }
		       });
	   })
		
	   .fail(function (jq) {
	     console.error('day slots load fail', jq.status, jq.responseText);
	   });
	
	   // 저장(예약)
	   $('#modal-save-btn').off('click').on('click', function () {
	     if (!selectedAvailabilityId) {
	       alert('예약할 시간을 선택해 주세요.');
	       return;
	     }
	     $.ajax({
	       url: CTX + '/api/member/booking',
	       method: 'POST',
	       contentType: 'application/json',
	       data: JSON.stringify({ availabilityId: selectedAvailabilityId }),
	       dataType: 'json'
	     })
	     .done(function () {
	       closeScheduleModal();
	       calendar.refetchEvents();
	       loadPtList();
	     })
	     .fail(function (jq) {
	       alert('예약에 실패했습니다.');
	       console.error('book fail', jq.status, jq.responseText);
	     });
	   });
	
	   $modal.css('display', 'flex');
	 }
	
	 function closeScheduleModal() { $('#schedule-modal').hide(); }
	
	 // ===== Utils =====
	 function pad2(n){ return (n<10?'0':'') + n; }
	 function formatDate(d){ // YYYY-MM-DD -> YYYY.MM.DD
	   if(!d) return '';
	   const p = d.split('-'); return p[0]+'.'+p[1]+'.'+p[2];
	 }
	 function formatDateK(dateStr){
	   const d = new Date(dateStr);
	   const days = ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'];
	   return d.getFullYear() + '년 ' + (d.getMonth()+1) + '월 ' + d.getDate() + '일 ' + days[d.getDay()];
	 }
	 function canCancelBy24h(dateStr, timeStr){
	   // dateStr: 'YYYY-MM-DD', timeStr: 'HH:mm'
	   if(!dateStr || !timeStr) return false;
	   const dt = new Date(dateStr + 'T' + timeStr + ':00');
	   const now = new Date();
	   return (dt.getTime() - now.getTime()) >= (24*60*60*1000);
	 }
	</script>
</body>
</html>