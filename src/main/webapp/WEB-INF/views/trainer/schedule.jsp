<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Schedule - FitLink</title>

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
		<!-- ===== 헤더 ===== -->
		<header>
			<a href="" class="btn-logout"> <img src="${pageContext.request.contextPath}/assets/images/logo.jpg" alt="FitLnk Logo" />
			</a>
			<div class="btn-logout">
				<a href="#" class="logout-link"> <i class="fa-solid fa-right-from-bracket"></i> 로그아웃
				</a>
			</div>
		</header>

		<!-- ===== 본문 ===== -->
		<div id="content">
			<!-- ------aside------ -->
			<c:choose>
				<c:when test="${sessionScope.authUser.role == 'trainer'}">
					<c:import url="/WEB-INF/views/include/aside-trainer.jsp"></c:import>
				</c:when>
				<c:otherwise>
					<c:import url="/WEB-INF/views/include/aside-member.jsp"></c:import>
				</c:otherwise>
			</c:choose>
			<!-- //------aside------ -->

			<!-- main -->
			<main>
				<div class="page-header">
					<h3 class="page-title">Schedule</h3>
				</div>

				<div class="calendar-card">
					<div id="calendar"></div>
				</div>

				<div class="line"></div>

				<section class="card2 list-card">
					<div class="card-header">
						<h4 class="card-title list-title">회원 수업 리스트</h4>
					</div>
					<div class="table-wrap">
						<table class="table">
							<colgroup>
								<col class="w-60" />
								<col class="w-110" />
								<col class="w-90" />
								<col class="w-90" />
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
									<th>회원</th>
									<th>PT 등록일수</th>
									<th>PT 수업일수</th>
									<th>PT 잔여일수</th>
									<th class="actions-head"></th>
								</tr>
							</thead>
							<tbody id="booking-body"></tbody>
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

	<!-- 근무시간 등록 모달 (날짜 클릭 시 표출) -->
	<div id="schedule-modal" class="modal-overlay" style="display: none;">
		<div class="modal-container is-inner">
			<!-- Header -->
			<div class="modal-header">
				<h2 class="modal-title">시간 선택</h2>
				<button class="modal-close-btn" type="button" onclick="closeScheduleModal()">
					<i class="fa-solid fa-xmark"></i>
				</button>
			</div>

			<!-- Body -->
			<div class="modal-body">
				<div class="time-selector">
					<h3 class="time-selector-title">시간 선택</h3>

					<p class="time-selector-date" id="modal-date">선택된 날짜</p>

					<div class="time-grid" id="modal-time-container"></div>

					<div class="legend">
						<div class="legend-item">
							<span class="legend-color available"></span> <span>등록 가능</span>
						</div>
						<div class="legend-item">
							<span class="legend-color selected"></span> <span>선택됨</span>
						</div>
					</div>
				</div>
			</div>

			<!-- Footer -->
			<div class="modal-footer">
				<button class="submit-btn save-btn" id="modal-save-btn" type="button">저장</button>
				<button class="delete-btn" id="modal-delete-btn" type="button">삭제</button>
			</div>
		</div>
	</div>


	<!-- ================== Script ================== -->
	<script>
  // JSP에서 전달된 trainerId (세션에 없으면 null)
  let trainerId = <%=request.getAttribute("trainerId") != null ? request.getAttribute("trainerId") : "null"%>;
  let calendar; // 전역 캘린더

  // "근무가 저장된 날"을 표시하기 위한 Set
  const workDaySet = new Set();

  document.addEventListener('DOMContentLoaded', function () {
    const calendarEl = document.getElementById('calendar');

    calendar = new FullCalendar.Calendar(calendarEl, {
   	  timeZone: 'local',
      locale: 'ko',
      initialView: 'dayGridMonth',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay'
      },

      // 달력 내 시간 표기 포맷 (24시간제)
      displayEventTime: true,
      eventTimeFormat: { hour: '2-digit', minute: '2-digit', hour12: false },

      // 날짜 클릭 → 모달 오픈
      dateClick: function (info) {
        if (!trainerId) {
          alert('트레이너 ID가 없습니다. 로그인을 확인하세요.');
          return;
        }
        openScheduleModal(info.dateStr);
      },

      // 보이는 기간 바뀔 때 하단 리스트 갱신 + 근무표시 리셋
      datesSet: function (info) {
        workDaySet.clear();                    // 뷰 바뀔 때 기존 표시 초기화
        clearWorkdayHighlight();               // 스타일 초기화
        loadBookings(info.startStr, info.endStr);
      },

      // 이벤트 소스: 서버에서 슬롯(근무/예약) 받아오기
      events: function (info, success, failure) {
        if (!trainerId) { success([]); return; }
        
        workDaySet.clear();
        clearWorkdayHighlight();
        
        $.ajax({
          url: '/api/trainer/schedule/slots',
          method: 'GET',
          data: {
            trainerId: trainerId,
            start: info.startStr,
            end: info.endStr
          },
          dataType: 'json'
        })
        .done(function (data) {
          // 색상(참고: 실제 이벤트 칩에는 회원예약만 보일 예정)
          const BOOKED_COLOR    = '#90CAF9';
          const COMPLETED_COLOR = '#B0BEC5';

          const events = (data || []).map(function (item) {
            // 시작 시각
            const startDt =
              item.startDt ||
              item.available_datetime ||
              (item.workDate && item.hourLabel ? (item.workDate + 'T' + item.hourLabel + ':00') : null);

            if (!startDt) return null;

            // "근무가 저장된 날" 수집 (날짜부분만)
            const d = new Date(startDt);
            const dStr = (new Date(d.getTime() - d.getTimezoneOffset()*60000)).toISOString().slice(0,10); // TZ 보정
            workDaySet.add(dStr);

            // 끝시간 1시간 가정
            const endDt = new Date(d.getTime() + 60 * 60 * 1000).toISOString();

            // 달력에는 "회원 예약만" 보여주기: AVAILABLE(근무가능)은 건너뛴다
            if (item.slotStatus === 'AVAILABLE') {
              return null; // 표시하지 않음
            }

            // BOOKED / COMPLETED만 렌더
            let color = BOOKED_COLOR;
            let title = item.memberName || '예약';

            if (item.slotStatus === 'COMPLETED') {
              color = COMPLETED_COLOR;
              title = (item.memberName || '수업') + ' (완료)';
            }

            return {
              id: item.availabilityId || item.reservationId || startDt,
              title: title,
              start: startDt,
              end: endDt,
              backgroundColor: color,
              classNames: ['booking-event'], // 필요 시 스타일링용
              extendedProps: {
                slotStatus: item.slotStatus,
                status: item.status,
                reservationId: item.reservationId
              }
            };
          }).filter(Boolean);

          success(events);

          // 이벤트 로드 후 "근무 저장일" 하이라이트 적용
          requestAnimationFrame(applyWorkdayHighlight);
        })
        .fail(function (jqXHR) {
          console.error('슬롯 API 실패', jqXHR.status, jqXHR.responseText);
          success([]);
        });
      }
    });

    calendar.render();
  });

  // 하단 예약 리스트 로드
  function loadBookings(start, end) {
    if (!trainerId) return;

    $.ajax({
      url: '/api/trainer/schedule/bookings',
      method: 'GET',
      data: { trainerId: trainerId, start: start, end: end },
      dataType: 'json'
    })
    .done(function (data) {
      const tbody = document.getElementById('booking-body');
      tbody.innerHTML = '';

      if (!data || data.length === 0) {
        const tr = document.createElement('tr');
        const td = document.createElement('td');
        td.colSpan = 8;
        td.textContent = '예약된 수업이 없습니다.';
        td.style.textAlign = 'center';
        tr.appendChild(td);
        tbody.appendChild(tr);
        return;
      }

      data.forEach(function (item, idx) {
        const tr = document.createElement('tr');

        // 순서
        const tdIdx = document.createElement('td');
        tdIdx.textContent = idx + 1;
        tr.appendChild(tdIdx);

        // 날짜
        const date = new Date(item.workDate || item.available_datetime);
        const formattedDate = date.getFullYear() + '.' + padZero(date.getMonth() + 1) + '.' + padZero(date.getDate());
        const tdDate = document.createElement('td');
        tdDate.textContent = formattedDate;
        tr.appendChild(tdDate);

        // 시간
        const hourLabel = item.hourLabel || (padZero(date.getHours()) + ':00');
        const tdTime = document.createElement('td');
        tdTime.textContent = hourLabel;
        tr.appendChild(tdTime);

        // 회원
        const tdMember = document.createElement('td');
        tdMember.textContent = item.memberName || '-';
        tdMember.classList.add('truncate');
        tdMember.title = item.memberName || '';
        tr.appendChild(tdMember);

        // PT 등록/수업/잔여
        const tdTotal  = document.createElement('td'); tdTotal.textContent  = item.totalSessions   ? item.totalSessions   + '회' : '-'; tr.appendChild(tdTotal);
        const tdDone   = document.createElement('td'); tdDone.textContent   = item.completedCount  ? item.completedCount  + '회' : '-'; tr.appendChild(tdDone);
        const tdRemain = document.createElement('td'); tdRemain.textContent = item.remainingCount  ? item.remainingCount  + '회' : '-'; tr.appendChild(tdRemain);

        // 취소 버튼
        const tdActions = document.createElement('td');
        tdActions.classList.add('actions');
        const btnDel = document.createElement('button');
        btnDel.className = 'icon-btn';
        btnDel.setAttribute('aria-label', '취소');
        btnDel.innerHTML = '<i class="fa-solid fa-xmark"></i>';
        btnDel.addEventListener('click', function () {
          if (confirm('정말로 이 수업을 취소하시겠습니까?')) {
            cancelReservation(item.reservationId);
          }
        });
        tdActions.appendChild(btnDel);
        tr.appendChild(tdActions);

        tbody.appendChild(tr);
      });
    })
    .fail(function (jqXHR) {
      console.error('예약 리스트를 불러오는 데 실패했습니다.', jqXHR.status, jqXHR.responseText);
    });
  }

  // 예약 취소(회원 예약 취소)
  function cancelReservation(reservationId) {
	if (!reservationId) return;
	$.ajax({
	  url: '/api/trainer/schedule/reservation',   // ← 엔드포인트 변경
	  method: 'DELETE',
	  data: { reservationId: reservationId, trainerId: trainerId }, // 본인 트레이너 검증용
	  dataType: 'json'
	})
	.done(function () {
	  if (calendar) {
	    calendar.refetchEvents();
	    const v = calendar.view;
	    loadBookings(v.activeStart.toISOString(), v.activeEnd.toISOString());
	  }
	})
	.fail(function (jqXHR) {
	  console.error('예약 취소에 실패했습니다.', jqXHR.status, jqXHR.responseText);
	  alert('예약 취소에 실패했습니다.');
	});
  }

  // 0~9 → 2자리
  function padZero(n) { return (n < 10 ? '0' : '') + n; }

  // 모달 열기
  function openScheduleModal(dateStr) {
    const modal = document.getElementById('schedule-modal');
    const dateDisplay = document.getElementById('modal-date');
    const timeContainer = document.getElementById('modal-time-container');
    const saveBtn = document.getElementById('modal-save-btn');
    const deleteBtn = document.getElementById('modal-delete-btn'); // 삭제 버튼(필수)

    let selectedHours = [];
    dateDisplay.textContent = formatDateDisplay(dateStr);

    // 06:00 ~ 23:00 버튼 생성
    timeContainer.innerHTML = '';
    for (let hour = 6; hour <= 23; hour++) {
      const hourLabel = padZero(hour) + ':00';
      const btn = document.createElement('button');
      btn.className = 'time-slot-btn'; // schedule_modal.css 버튼 스타일 활용
      btn.textContent = hourLabel;
      btn.dataset.hour = hour;
      btn.addEventListener('click', function () {
        if (btn.classList.contains('disabled')) return;
        btn.classList.toggle('selected');
        const h = btn.dataset.hour;
        if (selectedHours.includes(h)) selectedHours = selectedHours.filter(x => x !== h);
        else selectedHours.push(h);
      });
      timeContainer.appendChild(btn);
    }

    // 기존 상태 반영
    $.ajax({
      url: '/api/trainer/schedule/slots/day',
      method: 'GET',
      data: { trainerId: trainerId, date: dateStr },
      dataType: 'json'
    })
    .done(function (data) {
      (data || []).forEach(function (item) {
        const hour = parseInt(item.hourLabel.split(':')[0], 10);
        const btn = timeContainer.querySelector('button[data-hour="' + hour + '"]');
        if (!btn) return;
        if (item.slotStatus === 'AVAILABLE') {
          btn.classList.add('selected'); selectedHours.push(String(hour));
        } else if (item.slotStatus === 'BOOKED' || item.slotStatus === 'COMPLETED') {
          btn.classList.add('disabled'); btn.setAttribute('title', item.slotStatus === 'BOOKED' ? '예약됨' : '완료');
        }
      });
    })
    .fail(function (jqXHR) {
      console.error('시간 정보를 불러오는 데 실패했습니다.', jqXHR.status, jqXHR.responseText);
    });

    // 저장(등록)
    saveBtn.onclick = function () {
      if (selectedHours.length === 0) { alert('적어도 하나의 시간을 선택하세요.'); return; }
      const datetimes = selectedHours.map(h => dateStr + ' ' + padZero(parseInt(h, 10)) + ':00:00');

      $.ajax({
        url: '/api/trainer/schedule/availability',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ trainerId: trainerId, datetimes: datetimes }),
        dataType: 'json'
      })
      .done(function () {
        closeScheduleModal();
        calendar.refetchEvents();
        const v = calendar.view;
        loadBookings(v.activeStart.toISOString(), v.activeEnd.toISOString());
      })
      .fail(function (jqXHR) {
        console.error('근무시간 등록에 실패했습니다.', jqXHR.status, jqXHR.responseText);
        alert('근무시간 등록에 실패했습니다.');
      });
    };

    // 삭제(이미 등록된 근무만, 예약/완료 제외)
    if (deleteBtn) {
      deleteBtn.onclick = function () {
        // .selected 중 .disabled 아닌 것만 삭제 대상으로
        const hoursForDelete = Array
          .from(timeContainer.querySelectorAll('.time-slot-btn.selected:not(.disabled)'))
          .map(btn => btn.dataset.hour);

        if (hoursForDelete.length === 0) {
          alert('삭제할 근무 시간을 선택하세요.');
          return;
        }
        const datetimes = hoursForDelete.map(h => dateStr + ' ' + padZero(parseInt(h, 10)) + ':00:00');

        $.ajax({
       	  url: '/api/trainer/schedule/availability/delete', // ← 여기
       	  method: 'POST',                                   // ← 여기 (DELETE JSON Body 이슈 회피)
       	  contentType: 'application/json',
       	  data: JSON.stringify({ trainerId: trainerId, datetimes: datetimes }),
       	  dataType: 'json'
        })
        .done(function () {
          closeScheduleModal();
          calendar.refetchEvents();
          const v = calendar.view;
          loadBookings(v.activeStart.toISOString(), v.activeEnd.toISOString());
        })
        .fail(function (jqXHR) {
          console.error('근무시간 삭제에 실패했습니다.', jqXHR.status, jqXHR.responseText);
          alert('근무시간 삭제에 실패했습니다.');
        });
      };
    }

    modal.style.display = 'flex';
  }

  // 모달 닫기
  function closeScheduleModal() {
	document.getElementById('schedule-modal').style.display = 'none';
  }

  // YYYY-MM-DD → YYYY년 MM월 DD일 요일
  function formatDateDisplay(dateStr) {
    const d = new Date(dateStr);
    const days = ['일요일','월요일','수요일','목요일','금요일','토요일'];
    // 위 요일 배열에 '화요일' 누락되어 오류 방지 위해 수정
    days.splice(1, 0, '화요일'); // ['일','화','수','목','금','토'] → 정상화
    return d.getFullYear() + '년 ' + (d.getMonth() + 1) + '월 ' + d.getDate() + '일 ' + days[d.getDay()];
  }

  // ======== 근무 저장일 하이라이트 ========
  function applyWorkdayHighlight() {
    // 먼저 모두 제거
    clearWorkdayHighlight();

    // 수집된 날짜들에 클래스 추가
    workDaySet.forEach(function(dateStr){
      const cell = document.querySelector('.fc-daygrid-day[data-date="' + dateStr + '"]');
      if (cell) cell.classList.add('has-workday'); // schedule_modal.css에서 스타일링
    });
  }

  function clearWorkdayHighlight() {
    document.querySelectorAll('.fc-daygrid-day.has-workday').forEach(function(el){
      el.classList.remove('has-workday');
    });
  }
  // =======================================
  </script>

</body>
</html>

