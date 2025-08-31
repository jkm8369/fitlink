<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta name="viewport"
	content="width=device-width, initial-scale=1, viewport-fit=cover" />
<title>Workout (Mobile)</title>
<!-- reset 먼저 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/reset.css" />


<!-- 모바일 전용 css -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/workout-mobile.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

<script
	src="${pageContext.request.contextPath}/assets/js/jquery/jquery-3.7.1.js"></script>
</head>

<body>
	<div id="mobile-menu" class="mobile-menu-wrap">
		<nav>
			<div class="menu-header">
				<c:if test="${not empty sessionScope.authUser}">
					<p>
						<strong>${sessionScope.authUser.userName}</strong>님
					</p>
				</c:if>
			</div>
			<ul>
				<li><a href="#">내 정보 수정 (예시)</a></li>
				<li><a href="#">운동 기록 (예시)</a></li>
			</ul>
			<div class="menu-footer">
				<a href="${pageContext.request.contextPath}/user/logout"
					class="btn-logout-mobile">로그아웃</a>
			</div>
		</nav>
		<div class="menu-backdrop"></div>
	</div>

	<main id="m-workout">

		<!-- 상단 헤더 (햄버거 / 타이틀 / 달력버튼) -->
		<div class="m-top-icons">
			<button type="button" class="icon-btn" aria-label="메뉴"
				style="color: #6B829A;">☰</button>
			<button id="btnToggleCalendar" class="icon-btn" type="button"
				aria-haspopup="true" aria-expanded="false"
				aria-controls="inlineCalendar" style="padding-top: 2px;">
				<svg width="30" height="30" viewBox="0 0 24 24" aria-hidden="true">
				      <path d="M7 10h5v5H7z"></path>
				      <path
						d="M19 4h-1V2h-2v2H8V2H6v2H5c-1.1 0-2 .9-2 2v12
				            c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 14H5V9h14v9z"></path>
				</svg>
			</button>
		</div>

		<header class="m-header">
			<div class="title-wrap">
				<h1 class="title">Workout Log</h1>
				<div id="currentDateLabel" class="subtitle">2025년 7월 20일</div>
			</div>
		</header>

		<!-- 인라인 캘린더(토글) -->
		<section id="inlineCalendar" class="cal-popover"
			style="display: none;">
			<div class="cal-nav">
				<button id="calPrev" type="button" class="nav-btn" aria-label="이전 달">‹</button>
				<span id="calTitle" class="cal-title">2025년 7월</span>
				<button id="calNext" type="button" class="nav-btn" aria-label="다음 달">›</button>
			</div>
			<div class="cal-weekdays">
				<div>일</div>
				<div>월</div>
				<div>화</div>
				<div>수</div>
				<div>목</div>
				<div>금</div>
				<div>토</div>
			</div>
			<div id="calDays" class="cal-days">
				<!-- JS가 날짜 버튼 채움 -->
			</div>
			<button id="calToday" class="btn-ghost" type="button">오늘로 이동</button>
		</section>

		<!-- 오늘의 운동 카드 -->
		<section class="card workout-today">
			<h2 class="card-title">오늘의 운동</h2>
			<p class="card-desc">수행한 운동과 세트별 무게, 횟수를 확인하세요</p>

			<div class="panel">
				<div class="panel-title">
					총 세트 수행
					<div class="panel-sub" id="exerciseTypeCountText">0개 운동 종목 수행</div>
				</div>
				<div class="panel-metrics">
					<div>
						최고 중량
						<div class="v">
							<strong id="maxWeight">0</strong>
						</div>
					</div>
					<div>
						총 반복수
						<div class="v">
							<strong id="totalReps">0</strong>
						</div>
					</div>
					<div>
						총 볼륨
						<div class="v">
							<strong id="totalVolume">0</strong>
						</div>
					</div>
				</div>
			</div>

			<!-- 입력 영역 -->
			<form id="form-add-log" class="form">
				<!-- 드롭다운 2열 -->
				<div class="grid-2">
					<div class="select-wrap">
						<select id="select-body-part" name="bodyPart" class="fld select">
							<option value="">부위</option>
						</select>
					</div>
					<div class="select-wrap">
						<select id="select-exercise-name" name="userExerciseId"
							class="fld select">
							<option value="">운동</option>
						</select>
					</div>
				</div>

				<!-- 인풋 2열 (오른쪽 안에 단위 표시) -->
				<div class="grid-2">
					<div class="input-group">
						<input id="input-weight" name="weight" type="number"
							inputmode="decimal" placeholder="무게" class="fld" /> <span
							class="suffix">kg</span>
					</div>
					<div class="input-group">
						<input id="input-reps" name="reps" type="number"
							inputmode="numeric" placeholder="몇" class="fld" /> <span
							class="suffix">회</span>
					</div>
				</div>

				<button type="submit" class="btn-primary full btn-lg">＋ 추가</button>
			</form>
		</section>

		<!-- 기록 리스트 (상단 미리보기 2개) -->
		<section class="list-preview" aria-label="오늘의 운동 기록">
			<ul id="todayMiniList">

			</ul>
		</section>

		<!-- 1RM 카드 -->
		<section class="card workout-1rm">
			<h2 class="card-title">1RM 무게</h2>

			<div class="panel">
				<div class="panel-title">
					1RM
					<div class="panel-sub"></div>
				</div>
				<div class="panel-metrics-1rm">
					<div>
						벤치프레스
						<div class="v">
							<strong id="rm-bench">120</strong>
						</div>
					</div>
					<div>
						데드리프트
						<div class="v">
							<strong id="rm-dead">220</strong>
						</div>
					</div>
					<div>
						스쿼트
						<div class="v">
							<strong id="rm-squat">200</strong>
						</div>
					</div>
				</div>
			</div>

			<!-- 입력 -->
			<form id="form-save-1rm" class="form">
				<div class="input-group-labeled">
					<label>벤치프레스</label>
					<div class="input-group">
						<input type="number" class="fld rm-input"
							data-exercise-name="벤치프레스" placeholder="최고 무게"
							inputmode="decimal"> <span class="suffix">kg</span>
					</div>
				</div>
				<div class="input-group-labeled">
					<label>데드리프트</label>
					<div class="input-group">
						<input type="number" class="fld rm-input"
							data-exercise-name="데드리프트" placeholder="최고 무게"
							inputmode="decimal"> <span class="suffix">kg</span>
					</div>
				</div>
				<div class="input-group-labeled">
					<label>스쿼트</label>
					<div class="input-group">
						<input type="number" class="fld rm-input" data-exercise-name="스쿼트"
							placeholder="최고 무게" inputmode="decimal"> <span
							class="suffix">kg</span>
					</div>
				</div>

				<button type="submit" class="btn-primary full btn-lg">＋ 기록
					저장</button>
			</form>

		</section>

		<input type="hidden" id="pickDate" name="pickDate" />
	</main>
	<!-- ===========================================jquery====================================== -->
	<script>
$(document).ready(function(){

  // ------------------- 공통 상태/헬퍼 -------------------
  const currentMemberId = Number("${currentMember.userId}" || 0);
  
  let state = { y: null, m: null, selected: null };
  
  let userExerciseList = [];

  function pad(n){ return (n<10?'0':'')+n; }
  
  function fmt(y,m,d){ return y+"-"+pad(m+1)+"-"+pad(d); }
  
  function formatKoreanDate(dateStr){
    if(!dateStr) return "";
    
    const p = dateStr.split("-");
    
    if(p.length===3) return p[0]+"년 "+parseInt(p[1],10)+"월 "+parseInt(p[2],10)+"일";
    
    return dateStr;
  }

  // ------------------- 초기화 -------------------
  const _now = new Date();
  const _today = fmt(_now.getFullYear(), _now.getMonth(), _now.getDate());
  
  $("#pickDate").val(_today);
  
  $("#currentDateLabel").text(formatKoreanDate(_today));
  
  loadLogs(_today);
  initializeForms();

  // ------------------- 달력 토글/닫기 -------------------
  $("#btnToggleCalendar").on("click", function(e){
    e.stopPropagation();
    const $cal = $("#inlineCalendar");
    
    if($cal.is(":visible")) { $cal.hide(); return; }
    
    const sel = $("#pickDate").val() || _today;
    const p = sel.split("-");
    
    state.y = parseInt(p[0],10);
    state.m = parseInt(p[1],10)-1;
    state.selected = sel;
    
    renderCalendar();
    $cal.show();
  });
  
  $(document).on("click", function(e){
    const $cal = $("#inlineCalendar");
    
    if(!$cal.is(":visible")) return;
    if($(e.target).closest("#inlineCalendar, #btnToggleCalendar").length===0){
      $cal.hide();
    }
  });
  
  $("#calPrev").on("click", function(e){
    e.stopPropagation();
    
    if(--state.m < 0){ state.m=11; state.y--; }
    
    renderCalendar();
  });
  
  $("#calNext").on("click", function(e){
    e.stopPropagation();
    
    if(++state.m > 11){ state.m=0; state.y++; }
    
    renderCalendar();
  });
  
  $("#calToday").on("click", function(e){
    e.stopPropagation();
    
    const now = new Date();
    
    state.y = now.getFullYear();
    state.m = now.getMonth();
    state.selected = fmt(state.y, state.m, now.getDate());
    
    renderCalendar();
  });

  // ------------------- 달력 렌더 -------------------
  function renderCalendar(){
    const y = state.y, m = state.m;
    $("#calTitle").text(y+"년 "+(m+1)+"월");

    const ajaxData = { year: y, month: m+1 };
    if(currentMemberId>0) ajaxData.memberId = currentMemberId;

    $.ajax({
      url: "${pageContext.request.contextPath}/api/workout/logged-dates",
      type: "get",
      data: ajaxData,
      dataType: "json",
      success: function(jsonResult){
        const loggedDates = (jsonResult.result==="success") ? (jsonResult.apiData||[]) : [];
        // 달 구간 계산
        const first = new Date(y, m, 1);
        const lastDate = new Date(y, m+1, 0).getDate();
        const startDay = first.getDay();
        const prevLast = new Date(y, m, 0).getDate();

        let html = "";
        
        for(let i=0;i<startDay;i++){
            const d = prevLast - (startDay-1-i);
            html += '<button type="button" class="cal-day out" disabled>'+d+'</button>';
        }
        
        for(let d=1; d<=lastDate; d++){
          const dateStr = fmt(y,m,d);
          let cls = "cal-day";
          if(dateStr===_today) cls += " today";
          if(dateStr===state.selected) cls += " selected";
          if(loggedDates.includes(dateStr)) cls += " has-log";
          html += '<button type="button" class="'+cls+'" data-date="'+dateStr+'">'+d+'</button>';
        }
        
        const total = startDay + lastDate;
        const remain = (7 - (total % 7)) % 7;
        
        for(let i=1;i<=remain;i++){
            html += '<button type="button" class="cal-day out" disabled>'+i+'</button>';
        }
        
        $("#calDays").html(html);

        $("#calDays .cal-day[data-date]").on("click", function(ev){
          ev.stopPropagation();
          
          const picked = $(this).data("date");
          state.selected = picked;
          
          $("#pickDate").val(picked);
          $("#currentDateLabel").text(formatKoreanDate(picked));
          $("#calDays .cal-day").removeClass("selected");
          $(this).addClass("selected");
          loadLogs(picked);
          $("#inlineCalendar").hide();
        });
      },
      error: function(XHR, status, err){
        console.error("달력 로딩 실패:", err);
      }
    });
  }

  // ------------------- 부위/운동 select 박스를 설정하는 공통 함수 -------------------
  // 부위를 선택하면 해당 부위의 운동 목록만 보여주도록 설정
  function setupExerciseSelects(bodyPartSelector, exerciseSelector) {
      let $bodyPartSelect = $(bodyPartSelector);
      let $exerciseSelect = $(exerciseSelector);
      
      // select 박스를 비우고 기본 옵션을 추가합니다.
      $bodyPartSelect.empty().append('<option value="">부위 선택</option>');

      // userExerciseList에서 부위 목록만 뽑아내 중복을 제거합니다.
      let bodyParts = [...new Set(userExerciseList.map(item => item.bodyPart))];
      bodyParts.forEach(function(part) {
          // 각 부위 옵션을 select 박스에 추가합니다.
          $bodyPartSelect.append('<option value="' + part + '">' + part + '</option>');
      });

      // 부위 select 박스의 값이 바뀔 때마다 실행될 이벤트를 설정합니다.
      $bodyPartSelect.on("change", function() {
          let selectedPart = $(this).val(); // 선택된 부위 값을 가져옵니다.
          $exerciseSelect.empty().append('<option value="">운동 선택</option>'); // 운동 select 박스를 초기화합니다.
          
          if (selectedPart) { // 부위가 선택되었을 경우
              userExerciseList.forEach(function(exercise) {
                  // 전체 운동 목록에서 선택된 부위에 해당하는 운동만 찾아서
                  if (exercise.bodyPart == selectedPart) {
                      // 운동 select 박스에 옵션으로 추가합니다.
                      $exerciseSelect.append('<option value="' + exercise.userExerciseId + '">' + exercise.exerciseName + '</option>');
                  }
              });
          }
      });
  }
  
  
  // ------------------- 폼 초기화 (부위/운동) -------------------
  function initializeForms(){
	    const ajaxData = {};
	    if(currentMemberId>0) ajaxData.memberId = currentMemberId;

	    $.ajax({
	      url: "${pageContext.request.contextPath}/api/workout/user-exercises",
	      type: "get",
	      data: ajaxData,
	      dataType: "json",
	      success: function(jsonResult){
	        if(jsonResult.result!=="success"){ alert(jsonResult.message||"운동 목록 로딩 실패"); return; }
	        userExerciseList = jsonResult.apiData || [];

	        // [수정] 기존의 복잡한 로직 대신, 새로 만든 공통 함수를 호출하도록 변경합니다.
	        // 1. '오늘의 운동' 섹션의 드롭다운을 설정합니다.
	        setupExerciseSelects("#select-body-part", "#select-exercise-name");
	        // 2. '1RM 무게' 섹션의 드롭다운을 설정합니다. (이 부분이 누락되었던 핵심입니다)
	        setupExerciseSelects("#select-body-part-1rm", "#select-exercise-name-1rm");

	      },
	      error: function(){ console.error("운동 목록 로딩 실패"); }
	    });
  }


  // ------------------- 로그 로딩 -------------------
  function loadLogs(dateStr){
  	const ajaxData = { logDate: dateStr };
    if(currentMemberId>0) ajaxData.memberId = currentMemberId;

    $.ajax({
      url: "${pageContext.request.contextPath}/api/workout/logs",
      type: "get",
      data: ajaxData,
      dataType: "json",
      success: function(jsonResult){
        if(jsonResult.result==="success"){
          const rows = jsonResult.apiData || [];
          renderLogList(rows);      // NORMAL
          renderSummary(rows);      // 통계 + 상단 1RM 숫자
          render1RMList(rows);      // 1RM 미니 리스트 (모바일 전용)
        } else {
          alert(jsonResult.message||"기록 로딩 실패");
        }
      },
      error: function(XHR, status, err){
        console.error("운동 기록 로딩 실패:", err);
      }
    });
  }

  // ------------------- 저장 공통 Ajax -------------------
  function saveWorkoutLog(workoutData, formSelector){
    if(currentMemberId>0) workoutData.userId = currentMemberId;

    return $.ajax({
      url: "${pageContext.request.contextPath}/api/workout/add",
      type: "post",
      contentType: "application/json",
      data: JSON.stringify(workoutData),
      dataType: "json",
      success: function(jsonResult){
        if(jsonResult.result==="success"){
          if(formSelector){
            loadLogs($("#pickDate").val());
            $(formSelector)[0].reset();
            if(formSelector==="#form-add-log"){
              $("#select-exercise-name").empty().append('<option value="">운동</option>');
            }
          }
        } else {
          alert(jsonResult.message||"저장 실패");
        }
      },
      error: function(xhr, status, err){ console.error("운동 기록 저장 실패:", err); }
    });
  }

  // ------------------- 폼 제출 -------------------
  // 오늘의 운동 (NORMAL)
  $("#form-add-log").on("submit", function(e){
    e.preventDefault();
    
    const data = {
      userExerciseId: $("#select-exercise-name").val(),
      weight: $("#input-weight").val(),
      reps: $("#input-reps").val(),
      logDate: $("#pickDate").val(),
      logType: "NORMAL"
      
    };
    
    if(!data.userExerciseId || !data.weight || !data.reps){
      alert("운동, 무게, 횟수를 모두 입력해주세요.");
      return;
    }
    saveWorkoutLog(data, "#form-add-log");
  });

// ------------------- 1RM 폼 제출 이벤트 핸들러 -------------------
//1RM은 3대 운동(벤치프레스, 데드리프트, 스쿼트)만 등록 가능하고,
//해당 운동이 '나의 운동 설정'에 추가되어 있어야만 저장되도록 로직을 강화합니다.
$("#form-save-1rm").on("submit", function(e) {
    e.preventDefault(); // 폼의 기본 제출 동작(새로고침)을 막습니다.

    // 1. 저장할 AJAX 요청들을 담을 배열을 준비합니다.
    let requests = [];
    // 1-1. 저장 실패 시 사용자에게 알려줄 운동 이름들을 담을 배열
    let failedExerciseNames = [];

    // 2. 폼 안에 있는 3개의 1RM 입력창(.rm-input)을 각각 순회합니다.
    $(".rm-input").each(function() {
        // this는 현재 순회 중인 input 태그를 가리킵니다.
        let $input = $(this);
        let weight = $input.val(); // 입력된 무게 값
        let exerciseName = $input.data("exercise-name"); // data-exercise-name 속성 값 (예: "벤치프레스")

        // 3. 무게 값이 입력된 경우에만 아래 로직을 실행합니다.
        if (weight) {
            // 4. [핵심] '나의 운동 설정' 목록(userExerciseList)에 현재 운동이 있는지 찾습니다.
            let exercise = userExerciseList.find(ex => ex.exerciseName === exerciseName);

            // 5. 운동이 목록에 존재하는 경우
            if (exercise) {
                // 5-1. 서버에 보낼 데이터를 구성합니다. (reps는 1로 고정)
                let workoutData = {
                    userExerciseId: exercise.userExerciseId,
                    weight: weight,
                    reps: 1,
                    logDate: $("#pickDate").val(),
                    logType: '1RM'
                };
                // 5-2. 생성된 AJAX 요청을 requests 배열에 추가합니다.
                requests.push(saveWorkoutLog(workoutData));
            } else {
                // 6. 운동이 목록에 없는 경우
                // 6-1. 실패한 운동의 이름을 배열에 추가해두었다가 나중에 한 번에 알려줍니다.
                failedExerciseNames.push(exerciseName);
            }
        }
    });

    // 7. 모든 입력창 순회가 끝난 후
    // 7-1. 만약 '나의 운동 설정'에 없어서 실패한 운동이 있다면
    if (failedExerciseNames.length > 0) {
        // 사용자에게 어떤 운동을 추가해야 하는지 알려주고 함수를 종료합니다.
        alert("'" + failedExerciseNames.join(', ') + "' 운동이 '나의 운동 설정'에 없습니다.\n먼저 운동을 추가해주세요.");
        return;
    }

    // 7-2. 저장할 요청이 1개 이상 있다면
    if (requests.length > 0) {
        // Promise.all을 사용해 모든 요청을 동시에 보내고, 전부 성공하면 아래 코드를 실행합니다.
        Promise.all(requests).then(function() {
            alert("1RM 기록이 저장되었습니다.");
            loadLogs($("#pickDate").val()); // 최신 데이터를 다시 불러옵니다.
            $(".rm-input").val(""); // 입력창을 비웁니다.
        });
    } else {
        // 7-3. 입력된 무게가 아무것도 없다면
        alert("저장할 1RM 기록이 없습니다.");
    }
});

  // ------------------- 삭제 -------------------
  // 기존과 동일: 리스트 각 행의 — 버튼
  $("#workoutLogList").on("click", ".remove-btn", onRemoveClick);
  
  // 모바일 미니 리스트(오늘/1RM)도 동일 동작
  $(document).on("click", "#todayMiniList .remove-btn, #rmMiniList .remove-btn", onRemoveClick);

  function onRemoveClick(){
    const $item = $(this).closest(".set-item, .mini-item");
    const logId = $item.data("log-id");
    if(!logId) return;
    if(!confirm("정말 삭제하시겠습니까?")) return;

    $.ajax({
      url: "${pageContext.request.contextPath}/api/workout/remove/" + logId,
      type: "delete",
      dataType: "json",
      success: function(jsonResult){
        if(jsonResult.result==="success"){
          $item.fadeOut(300, function(){
            $(this).remove();
            loadLogs($("#pickDate").val());
          });
        } else {
          alert(jsonResult.message||"삭제 실패");
        }
      },
      error: function(xhr, status, err){ console.error("운동 기록 삭제 실패:", err); }
    });
  }

  // ------------------- 렌더러 -------------------
  // NORMAL 로그 → 오늘의 운동 리스트 컨테이너로
  function renderLogList(rows){
    // 우선순위: todayMiniList 있으면 거기에, 없으면 기존 #workoutLogList
    const $container = $("#todayMiniList").length ? $("#todayMiniList") : $("#workoutLogList");
    $container.empty();

    const normalLogs = rows.filter(log => log.logType==='NORMAL');
    for(let i=0;i<normalLogs.length;i++){
      const log = normalLogs[i];
      const bodyPart = (log.bodyPart||'-');
      const exerciseName = (log.exerciseName||'-');
      const right = (log.weight||0)+"kg × "+(log.reps||0)+"회";
      // 모바일 미니/기존 리스트 모두 커버
      const html =
        '<li class="mini-item set-item" data-log-id="'+log.logId+'">'+
          '<div class="left">'+ '<strong>' + bodyPart +'</strong>' +' (' + exerciseName + ')' + '</div>'+
          '<div class="right">'+right+' <button class="remove-btn" type="button" aria-label="삭제">—</button></div>'+
        '</li>';
      $container.append(html);
    }
  }

  // 상단 통계 + 상단 1RM 숫자
  function renderSummary(rows) {
    // 1. 전체 운동 기록(rows) 중에서 일반 운동(logType === 'NORMAL') 기록만 필터링합니다.
    const normalLogs = rows.filter(log => log.logType === 'NORMAL');

    // 2. [핵심] 몇 종류의 운동을 했는지 계산합니다.
    // 주석: normalLogs 배열에서 exerciseName(운동 이름)만 추출한 새 배열을 만듭니다.
    //       그 다음 Set 객체를 사용해 중복된 운동 이름을 자동으로 제거합니다.
    //       마지막으로 .size를 통해 중복이 제거된 운동의 개수를 구합니다.
    const uniqueExerciseNames = new Set(normalLogs.map(log => log.exerciseName));
    const uniqueExerciseCount = uniqueExerciseNames.size;

    // 3. 최고 중량, 총 반복수, 총 볼륨을 계산하기 위한 변수를 초기화합니다.
    let maxW = 0,
        repsSum = 0,
        volumeSum = 0;
    
    // 4. 필터링된 일반 운동 기록을 하나씩 순회하며 값을 계산합니다.
    for (let i = 0; i < normalLogs.length; i++) {
        const w = Number(normalLogs[i].weight || 0);
        const r = Number(normalLogs[i].reps || 0);
        if (w > maxW) maxW = w;
        repsSum += r;
        volumeSum += (w * r);
    }

    // 5. 계산된 값들을 화면의 각 요소에 업데이트합니다.
    $("#summaryCount").text(normalLogs.length); // 총 세트 수 (총 기록의 개수)
    $("#exerciseTypeCountText").text(uniqueExerciseCount + '개 운동 종목 수행'); // [추가] 운동 종류의 수
    
    $("#maxWeight").text(maxW); // 최고 중량
    $("#totalReps").text(repsSum); // 총 반복수
    $("#totalVolume").text(volumeSum); // 총 볼륨

    // 6. 상단 1RM 숫자 3종(벤치, 데드, 스쿼트)도 최신 기록으로 업데이트합니다.
    $("#rm-bench").text(calc1RM(rows, "벤치프레스"));
    $("#rm-dead").text(calc1RM(rows, "데드리프트"));
    $("#rm-squat").text(calc1RM(rows, "스쿼트"));
}

  function calc1RM(rows, name){
    const list = rows.filter(log => log.exerciseName===name && log.logType==='1RM');
    if(list.length>0){
      list.sort((a,b)=>(a.createdAt>b.createdAt)?-1:1);
      return list[0].weight || 0;
    }
    return 0;
  }

  // 1RM 미니 리스트 (모바일 전용)
  function render1RMList(rows){
    const $rm = $("#rmMiniList");
    if(!$rm.length) return;
    $rm.empty();
    const rmLogs = rows.filter(log => log.logType==='1RM');
    for(let i=0;i<rmLogs.length;i++){
      const log = rmLogs[i];
      const left = (log.exerciseName||'-');
      const right = (log.weight||0)+"kg × "+(log.reps||1)+"회";
      const html =
        '<li class="mini-item set-item" data-log-id="'+log.logId+'">'+
          '<div class="left">'+left+'</div>'+
          '<div class="right">'+right+' <button class="remove-btn" type="button" aria-label="삭제">—</button></div>'+
        '</li>';
      $rm.append(html);
    }
  }

  //[추가] ------------------- 모바일 메뉴 토글 -------------------
  // 주석: 메뉴(햄버거) 버튼을 클릭했을 때의 동작을 정의합니다.
  $(".m-top-icons .icon-btn[aria-label='메뉴']").on("click", function() {
      $("#mobile-menu").addClass("open"); // 메뉴에 open 클래스를 추가하여 보이게 합니다.
  });

  // 주석: 메뉴 바깥의 어두운 배경을 클릭했을 때의 동작을 정의합니다.
  $("#mobile-menu .menu-backdrop").on("click", function() {
      $("#mobile-menu").removeClass("open"); // 메뉴에서 open 클래스를 제거하여 숨깁니다.
  });
});
</script>
</body>
</html>
