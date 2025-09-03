<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>사진</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/include.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/trainer.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

<!-- FullCalendar CSS/JS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/main.min.css">

<!-- jQuery -->
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
					<c:import url="/WEB-INF/views/include/aside-trainer-member.jsp"></c:import>
				</div>
			</aside>
			<!-- ------aside------ -->

			<main id="photo-page" data-member-id="${memberId}" data-trainer-id="${trainerId}">
				<!-- 1. 제목 -->
				<div class="page-header">
					<h3 class="page-title">Photo</h3>
				</div>
				<!-- //1. 제목 -->

				<!-- 2. 달력 -->
				<div class="calendar-card">
				  <div id="photo-calendar"></div>
				</div>


				<!-- //2. 달력 -->

				<!-- 3. 구분선 -->
				<div class="line"></div>
				<!-- //3. 구분선 -->

				<!-- 4. 사진 갤러리 -->
				<input type="file" id="photo-file" accept="image/*" style="display: none;">
				<div class="photo-gallery-section">
					<div class="gallery-header">
						<h4 class="gallery-title">운동사진</h4>
						<button class="btn-add-photo" data-type="body">
							<i class="fa-regular fa-image"></i> 사진 등록
						</button>
					</div>

					<ul class="photo-grid" id="photo-grid-body" data-type="body"></ul>
				</div>

				<div class="photo-gallery-section">
					<div class="gallery-header">
						<h4 class="gallery-title">식단사진</h4>
						<button class="btn-add-photo" data-type="meal">
							<i class="fa-regular fa-image"></i> 사진 등록
						</button>
					</div>

					<ul class="photo-grid" id="photo-grid-meal" data-type="meal"></ul>
				</div>
				<!-- //4. 사진 갤러리 -->
			</main>
		</div>

		<footer>
			<p>Copyright © 2025. FitLink All rights reserved.</p>
		</footer>
	</div>

	<!-------------------------- script -------------------------->
	<script>
	  // ================= 공통 유틸 =================
	  function abs(path){ if(!path) return ''; return path.startsWith('http') ? path : (window.location.origin + path); }
	
	  // [트레이너용 변경] 지금 페이지가 "어느 회원의 갤러리인지" 인지 → data-member-id에서 memberId 추출
	  const $page     = $('#photo-page');
	  const memberId  = Number($page.data('member-id'));   // 사진 주인(회원) → 모든 API에 전달
	  const trainerId = Number($page.data('trainer-id'));  // 작성자(트레이너) → 서버는 세션으로 확인, 클라에서는 표시용(현재 사용 안 함)
	
	  // 선택된 날짜(기본: 오늘)
	  let selectedDate = new Date().toISOString().slice(0,10);
	
	  // ================= 리스트 렌더 =================
	  function renderList(gridId, rows){
	    const $g = $(gridId).empty();
	    if (!rows || rows.length === 0) return;
	
	    rows.forEach(function(p){
	      const li  = $('<li class="ph-thumb"></li>');
	      const img = new Image();
	      img.alt   = 'photo';
	      img.src   = abs(p.photoUrl) + '?t=' + Date.now(); // 캐시 우회
	      li.append(img);
	
	      // 삭제 버튼
	      const $btn = $('<button class="ph-remove" type="button">×</button>').attr('data-id', p.photoId);
	      li.append($btn);
	
	      $g.append(li);
	    });
	  }
	
	  // ================= 목록 불러오기 (선택날짜 반영) =================
	  function load(type, targetDate){
	    // [트레이너용 변경] API prefix 변경 + userId(=memberId) 필수 전달
	    $.get('/api/trainer/photo/list', {
	        userId: memberId,                     // ← 대상 회원 고정
	        photoType: type,
	        targetDate: targetDate || '',
	        limit: 12
	      })
	      .done(function(res){
	        if (res && res.ok){
	          renderList(type === 'body' ? '#photo-grid-body' : '#photo-grid-meal', res.data || []);
	        }
	      });
	  }
	
	  // ================= 업로드 (선택날짜로 저장) =================
	  $(document).on('click', '.btn-add-photo', function(){
	    $('#photo-file').data('ptype', $(this).data('type')).val('').click();
	  });
	
	  $('#photo-file').on('change', function(){
	    const file = this.files && this.files[0];
	    if (!file) return;
	
	    const type = $(this).data('ptype');
	    const day  = selectedDate || new Date().toISOString().slice(0,10);
	
	    const fd = new FormData();
	    fd.append('file', file);
	    fd.append('photoType', type);
	    fd.append('targetDate', day);
	
	    // [트레이너용 변경] 트레이너가 "대상 회원"에게 저장 → userId를 명시적으로 추가
	    fd.append('userId', String(memberId));
	
	    $.ajax({
	      url: '/api/trainer/photo/upload',      // [트레이너용 변경] 업로드 엔드포인트 교체
	      method: 'POST',
	      data: fd,
	      processData: false,
	      contentType: false
	    }).done(function(res){
	      if (res && res.ok){
	        load(type, day);                     // 해당 섹션만 리로드
	        // 업로드 직후 달력 배경 즉시 갱신
	        if (window.__photoCal) { refreshCalendar(window.__photoCal); }
	      } else {
	        alert('업로드에 실패했습니다.');
	      }
	    }).fail(function(){ alert('업로드에 실패했습니다.'); });
	  });
	
	  // ================= FullCalendar =================
	  function fetchPhotoDays(startStr, endStr, calendar){
	    const s = startStr.slice(0,10);
	    const e = endStr.slice(0,10);
	
	    // [트레이너용 변경] 달력 집계도 대상 회원 기준 → userId 포함
	    $.get('/api/trainer/photo/calendar', { userId: memberId, start: s, end: e })
	      .done(function(res){
	        if (!(res && res.ok)) return;
	        calendar.removeAllEvents();
	
	        const evts = (res.data || []).map(function(row){
	          // end는 "다음날"로 (FullCalendar는 end-미포함)
	          const d = new Date(row.date);
	          d.setDate(d.getDate() + 1);
	          const end = d.toISOString().slice(0,10);
	
	          return { start: row.date, end: end, display: 'background', classNames:['has-photos'] };
	        });
	        calendar.addEventSource(evts);
	      });
	  }
	
	  $(function(){
	    // FullCalendar 생성 (대상 엘리먼트: #photo-calendar 유지)
	    const el = document.getElementById('photo-calendar');
	    const calendar = new FullCalendar.Calendar(el, {
	      initialView: 'dayGridMonth',
	      height: 'auto',
	      locale: 'ko',
	      headerToolbar: { left: 'prev,next today', center: 'title', right: 'dayGridMonth,dayGridWeek,dayGridDay' },
	
	      dateClick: function(info){
	        selectedDate = info.dateStr;   // 선택 날짜 업데이트
	        load('body', selectedDate);
	        load('meal', selectedDate);
	      },
	
	      // 보이는 범위 바뀔 때마다 집계 재로딩
	      datesSet: function(info){
	        fetchPhotoDays(info.startStr, info.endStr, calendar);
	      }
	    });
	    window.__photoCal = calendar;
	    calendar.render();
	
	    // [정리] 초기 로딩은 한 번만 (중복 호출 제거)
	    load('body', selectedDate);
	    load('meal', selectedDate);
	    refreshCalendar(calendar);
	  });
	
	  // 삭제 버튼 (×) 클릭
	  $(document).on('click', '.ph-remove', function(){
	    const photoId = $(this).data('id');
	    if (!photoId) return;
	    if (!confirm('이 사진을 삭제하시겠습니까?')) return;
	
	    // 이 버튼이 속한 그리드의 타입(body/meal) 결정
	    const $grid = $(this).closest('ul.photo-grid');
	    let type = $grid.data('type');
	    if (!type) { // data-type이 없으면 id로 추론
	      const id = $grid.attr('id') || '';
	      type = id.includes('body') ? 'body' : 'meal';
	    }
	
	    // [트레이너용 변경] 삭제도 트레이너 전용 엔드포인트 사용
	    $.ajax({
	      url: '/api/trainer/photo/' + encodeURIComponent(photoId),
	      method: 'DELETE'
	    })
	    .done(function(res){
	      if (res && res.ok){
	        load(type, selectedDate);                 // 현재 선택 날짜 그대로 다시 로딩
	        if (window.__photoCal) refreshCalendar(window.__photoCal); // 달력 배경 갱신
	      } else {
	        alert((res && res.message) ? res.message : '삭제에 실패했습니다.');
	      }
	    })
	    .fail(function(xhr){
	      const msg = xhr && xhr.responseJSON && xhr.responseJSON.message;
	      alert(msg || '삭제에 실패했습니다.');
	    });
	  });
	
	  // 달력 집계 재조회 (현재 뷰 범위)
	  function refreshCalendar(cal){
	    const s = cal.view.activeStart.toISOString().slice(0,10);
	    const e = cal.view.activeEnd  .toISOString().slice(0,10);
	
	    // [트레이너용 변경] userId 포함하여 배경 이벤트 갱신
	    $.get('/api/trainer/photo/calendar', { userId: memberId, start: s, end: e })
	      .done(function(res){
	        if (!(res && res.ok)) return;
	        cal.removeAllEvents();
	
	        const bg = (res.data || []).map(function(row){
	          const d = new Date(row.date);
	          d.setDate(d.getDate() + 1); // end(미포함) = 다음날
	          return {
	            start: row.date,
	            end: d.toISOString().slice(0,10),
	            display: 'background',
	            classNames: ['has-photos']
	          };
	        });
	        cal.addEventSource(bg);
	      });
	  }
	</script>

</body>
</html>