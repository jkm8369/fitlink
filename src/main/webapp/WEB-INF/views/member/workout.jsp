<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Workout Log - FitLink</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/include.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
<script src="${pageContext.request.contextPath}/assets/js/jquery/jquery-3.7.1.js"></script>
</head>

<body>
	<div id="wrap">


		<!-- ------헤더------ -->
		<c:import url="/WEB-INF/views/include/header.jsp"></c:import>
		<!-- //------헤더------ -->

		<!-- --aside + main-- -->
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


			<main>

				<div class="box1">
					<div class="main-header">
						<h3 class="main-title">Workout Log</h3>
						<!-- 날짜가 동적으로 변경되도록 id 추가 -->
						<p class="main-subtitle" id="currentDateLabel"></p>
					</div>
					<!-- WorkoutLog 타이틀 + 달력 아이콘 + 접히는 달력 -->
					<div class="wl-head">


						<!-- 달력 아이콘 버튼 -->
						<button id="btnToggleCalendar" class="icon-btn" type="button" aria-haspopup="true" aria-expanded="false" aria-controls="inlineCalendar">
							<!-- 작은 캘린더 아이콘 (SVG) -->
							<svg width="30" height="30" viewBox="0 0 24 24" aria-hidden="true">
							      <path d="M7 10h5v5H7z"></path>
							      <path d="M19 4h-1V2h-2v2H8V2H6v2H5c-1.1 0-2 .9-2 2v12
							               c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 14H5V9h14v9z"></path>
							</svg>
						</button>



						<!-- 인라인 달력: 기본은 접힘(display:none), 토글로 펼침 -->
						<div id="inlineCalendar" class="cal-popover" role="dialog" aria-label="날짜 선택" style="display: none;">
							<div class="cal-header">
								<button type="button" class="cal-nav" id="calPrev" aria-label="이전 달">&#10094;</button>
								<h3 id="calTitle" class="cal-title"></h3>
								<button type="button" class="cal-nav" id="calNext" aria-label="다음 달">&#10095;</button>
							</div>
							<div class="cal-grid">
								<!-- 요일 표시를 위한 컨테이너 추가 -->
								<div class="cal-weekdays">
									<div class="cal-dow">일</div>
									<div class="cal-dow">월</div>
									<div class="cal-dow">화</div>
									<div class="cal-dow">수</div>
									<div class="cal-dow">목</div>
									<div class="cal-dow">금</div>
									<div class="cal-dow">토</div>
								</div>
								<div id="calDays" class="cal-days">
									<!-- 날짜는 JS로 렌더 -->
								</div>
							</div>
							<div class="cal-footer">
								<button type="button" id="calToday" class="btn-today-floating">오늘</button>
							</div>
						</div>
					</div>

					<!-- 실제 선택 날짜 저장 (AJAX 파라미터용) -->
					<input type="hidden" id="pickDate" />
				</div>

				<div class="box2">
					<section class="summary-box">
						<h4 class="summary-box-header">총 세트 수행</h4>
						<p id="summaryCount">0개 운동 등록 수행</p>
						<div class="stats">
							<div>
								최고 중량<br> <strong id="maxWeight">0</strong>
							</div>
							<div>
								총 반복수<br> <strong id="totalReps">0</strong>
							</div>
							<div>
								총 볼륨<br> <strong id="totalVolume">0</strong>
							</div>
						</div>
					</section>

					<section class="workout-input">
						<h4>오늘의 운동</h4>
						<!-- -- 운동 입력 폼 -- -->
						<form id="form-add-log" class="set-form">
							<select id="select-body-part" name="bodyPart">
								<option value="">부위</option>
							</select> 
							<select id="select-exercise-name" name="userExerciseId">
								<option value="">운동</option>
							</select> 
							<span>무게</span> <input id="input-weight" name="weight" type="text" placeholder="숫자" /> 
							<span>kg</span> 
							<span>×</span> <input id="input-reps" name="reps" type="text" placeholder="숫자" /> <span>회</span>

							<button type="submit" class="btn-plus">+</button>
						</form>

						<!-- -- + 클릭시 추가되는 폼 (js)-- -->
						<div id="workoutLogList" class="set-list">
							
						</div>	
					</section>
				</div>

				<div class="box3">
					<section class="rm-box">
						<h4 class="rm-box-header">1RM</h4>
						<div class="rm-stats">
							<div>
								벤치프레스<br /> <strong id="rm-bench">120</strong>
							</div>
							<div>
								데드리프트<br /> <strong id="rm-dead">220</strong>
							</div>
							<div>
								스쿼트<br /> <strong id="rm-squat">200</strong>
							</div>
						</div>
					</section>


					<section class="rm-weight">
						<h4>1RM 무게</h4>
						<form id="form-save-1rm" class="set-form">
							<div class="rm-input-group">
								<label>벤치프레스</label>
								<input type="number" class="rm-input" data-exercise-name="벤치프레스" placeholder="kg">
							</div>
							<div class="rm-input-group">
								<label>데드리프트</label>
								<input type="number" class="rm-input" data-exercise-name="데드리프트" placeholder="kg">
							</div>
							<div class="rm-input-group">
								<label>스쿼트</label>
								<input type="number" class="rm-input" data-exercise-name="스쿼트" placeholder="kg">
							</div>
							<button type="submit" class="btn-plus">+</button>
						</form>

						<!-- -- + 클릭시 추가되는 폼 (js)-- -->
						<div id="1rmLogList" class="set-list">
							
						</div>	
					</section>
				</div>
			</main>
		</div>
		<!-- <footer> -->
		<c:import url="/WEB-INF/views/include/footer.jsp"></c:import>
		<!--// <footer> -->
	</div>
	<!-- ===========================================jquery====================================== -->
	<script>
		$(document).ready(function(){
			// ================== 기본 설정 ==================
			let state = {
				y : null,
				m : null,
				selected : null
			}; // 달력 상태(연/월/선택일)
			
			let userExerciseList = [];
	
			// 숫자를 두 자리 문자열로 변환 (예: 1 -> "01")
			function pad(n) {
				return (n < 10 ? '0' : '') + n;
			}
	
			// YYYY-MM-DD 형식으로 날짜 포맷
			function fmt(y, m, d) {
				return y + "-" + pad(m + 1) + "-" + pad(d);
			}
	
			// YYYY년 M월 D일 형식으로 날짜 포맷하는 함수
			function formatKoreanDate(dateStr) {
				let parts = dateStr.split("-");
				if (parts.length == 3) {
					return parts[0] + "년 " + parseInt(parts[1], 10) + "월 "
							+ parseInt(parts[2], 10) + "일";
				}
				return dateStr; // 변환 실패 시 원본 반환
			}
	
			
			// 오늘 날짜를 기본값으로 세팅
			let _now = new Date();
			let _today = fmt(_now.getFullYear(), _now.getMonth(), _now.getDate());   // _붙히는건 이 블록 안에서만 잠깐 쓰는것이라는걸 강조할 때 씀 (관례)
			$("#pickDate").val(_today);
			$("#currentDateLabel").text(formatKoreanDate(_today)); // 한국식 날짜 포맷으로 표시
			
			// 페이지 로딩 시 오늘 날짜의 기록을 불러옴
			loadLogs(_today);
			
			//폼 초기화 함수 이름 변경 및 호출
			initializeForms(); 
	
			// ================== 달력 토글 ==================
			$("#btnToggleCalendar").on("click", function(e) {
				e.stopPropagation(); // 바깥 클릭 닫힘과 충돌 방지
				let $cal = $("#inlineCalendar");
				if ($cal.is(":visible")) {
					$cal.hide();
				} else {
					// 현재 선택된 날짜 기준으로 달력 표시
					let sel = $("#pickDate").val() || _today;
					let p = sel.split("-");
					state.y = parseInt(p[0], 10);
					state.m = parseInt(p[1], 10) - 1; // 0~11
					state.selected = sel;
					renderCalendar();
					$cal.show();
				}
			});
	
			// 달력 바깥 클릭하면 닫기
			$(document).on("click",function(e) {
				let $cal = $("#inlineCalendar");
				if (!$cal.is(":visible"))
					return;
				if ($(e.target).closest(
						"#inlineCalendar, #btnToggleCalendar").length === 0) {
					$cal.hide();
				}
			});
	
			// ================== 달력 네비게이션 ==================
			$("#calPrev").on("click", function(e) {
				e.stopPropagation();
				state.m--;
				if (state.m < 0) {
					state.m = 11;
					state.y--;
				}
				renderCalendar();
			});
	
			$("#calNext").on("click", function(e) {
				e.stopPropagation();
				state.m++;
				if (state.m > 11) {
					state.m = 0;
					state.y++;
				}
				renderCalendar();
			});
	
			// 오늘 버튼 클릭
			$("#calToday").on("click", function(e) {
				e.stopPropagation();
				
				// 1. 오늘 날짜로 상태를 업데이트합니다.
				state.selected = _today;
				$("#pickDate").val(_today);
				$("#currentDateLabel").text(formatKoreanDate(_today));
	
				// 2. 오늘 날짜의 로그를 불러옵니다.
				loadLogs(_today);
	
				// 3. 달력을 닫습니다.
				$("#inlineCalendar").hide();
			});
	
			// ================== 달력 그리기 ==================
			function renderCalendar() {
				let y = state.y, m = state.m;
				$("#calTitle").text(y + "년 " + (m + 1) + "월");
				
				// AJAX로 현재 달력의 운동 기록 날짜 목록을 먼저 받아옵니다.
				$.ajax({
					url: "${pageContext.request.contextPath}/api/workout/logged-dates",
					type: "get",
					data: { year: y, month: m + 1 }, // month는 1~12월로 보냅니다.
					dataType: "json",
					success: function(jsonResult) {
						let loggedDates = [];
						if (jsonResult.result === "success") {
							loggedDates = jsonResult.apiData; // ["2025-08-10", "2025-08-12", ...]
						} else {
							console.error("운동 기록 날짜 로딩 실패:", jsonResult.message);
						}
						// 날짜 데이터를 가지고 달력 DOM을 그리는 함수 호출
						buildCalendarDOM(loggedDates);
					},
					error: function(xhr, status, error) {
						console.error("AJAX 에러:", error);
						// 에러가 발생해도 달력은 그려주되, 기록 표시는 못함
						buildCalendarDOM([]);
					}
				});
	
			}
			
			// 실제 달력의 HTML을 만드는 함수
			function buildCalendarDOM(loggedDates) {
				let y = state.y, m = state.m;
				
				let first = new Date(y, m, 1);
				let startDay = first.getDay(); // 0(일)~6(토)
				let lastDate = new Date(y, m + 1, 0).getDate(); // 이번 달 마지막 일
				let prevLast = new Date(y, m, 0).getDate(); // 이전 달 마지막 일
	
				let html = "";
				let i, d, dateStr, cls;
	
				// 앞쪽 빈칸(이전달 표시, 비활성)
				for (i = 0; i < startDay; i++) {
					d = prevLast - (startDay - 1 - i);
					html += '<div class="cal-day out" aria-hidden="true">' + d
							+ '</div>';
				}
	
				// 이번달 날짜
				for (d = 1; d <= lastDate; d++) {
					dateStr = fmt(y, m, d);
					cls = "cal-day";
					if (dateStr == _today) {
						cls += " today";
					}
					
					if (dateStr == state.selected) { 
						cls += " selected";
					}
					
					// 운동 기록이 있는 날짜에 'has-log' 클래스 추가
					if (loggedDates.includes(dateStr)) {
						cls += " has-log";
					}
					
					html += '<button type="button" class="'+cls+'" data-date="'+dateStr+'">'
							+ d + '</button>';
				}
	
				// 뒤쪽 빈칸(다음달 표시, 비활성)
				let totalCells = startDay + lastDate;
				let remain = (7 - (totalCells % 7)) % 7;
				for (i = 1; i <= remain; i++) {
					html += '<div class="cal-day out" aria-hidden="true">' + i
							+ '</div>';
				}
	
				$("#calDays").html(html);
	
				// 날짜 클릭 → 값 저장 → 데이터 로드 → 달력 닫기
				$("#calDays .cal-day[data-date]").on("click", function(ev) {
					ev.stopPropagation();
					let picked = $(this).data("date");
					state.selected = picked;
	
					$("#pickDate").val(picked);
					$("#currentDateLabel").text(formatKoreanDate(picked)); // 한한국식 날짜 포맷으로 표시
	
					$("#calDays .cal-day").removeClass("selected");
					$(this).addClass("selected");
	
					loadLogs(picked);
					$("#inlineCalendar").hide();
				});
				
			}
	
			/*
			 * ==================================================================================
			 * 운동 입력 폼 관련 기능 (오늘의 운동 / 1RM)
			 * ==================================================================================
			 */

			/**
			 * 페이지 로딩 시 두 개의 폼(일반, 1RM)을 모두 초기화하는 함수
			 */
			function initializeForms() {
				$.ajax({
					url: "${pageContext.request.contextPath}/api/workout/user-exercises",
					type: "get",
					dataType: "json",
					success: function(jsonResult) {
						if (jsonResult.result == "success") {
							userExerciseList = jsonResult.apiData;
							// 두 폼의 select 박스를 각각 초기화
							setupExerciseSelects("#select-body-part", "#select-exercise-name");
							setupExerciseSelects("#select-body-part-1rm", "#select-exercise-name-1rm");
						} else {
							alert(jsonResult.message);
						}
					},
					error: function(xhr, status, error) { console.error("운동 목록 로딩 실패:", error); }
				});
			}

			/**
			 * 부위/운동 select 박스 한 쌍을 설정하는 함수
			 * @param {string} bodyPartSelector - 부위 select 박스의 ID
			 * @param {string} exerciseSelector - 운동 select 박스의 ID
			 */
			function setupExerciseSelects(bodyPartSelector, exerciseSelector) {
				let $bodyPartSelect = $(bodyPartSelector);
				let $exerciseSelect = $(exerciseSelector);
				
				// 1. 부위 select 박스 채우기
				$bodyPartSelect.empty().append('<option value="">부위 선택</option>');
				let bodyParts = [...new Set(userExerciseList.map(item => item.bodyPart))]; 
				bodyParts.forEach(function(part) {
					$bodyPartSelect.append('<option value="' + part + '">' + part + '</option>');
				});
				
				// 2. 부위 선택 시, 운동 select 박스 내용 변경
				$bodyPartSelect.on("change", function() {
					let selectedPart = $(this).val();
					$exerciseSelect.empty().append('<option value="">운동 선택</option>');
					if (selectedPart) {
						userExerciseList.forEach(function(exercise) {
							if (exercise.bodyPart == selectedPart) {
								$exerciseSelect.append('<option value="' + exercise.userExerciseId + '">' + exercise.exerciseName + '</option>');
							}
						});
					}
				});
			}

			// '오늘의 운동' 추가 로직
			$("#form-add-log").on("submit", function(e) {
				e.preventDefault();
				let workoutData = {
					userExerciseId: $("#select-exercise-name").val(),
					weight: $("#input-weight").val(),
					reps: $("#input-reps").val(),
					logDate: $("#pickDate").val(),
					logType: 'NORMAL'
				};

				if (!workoutData.userExerciseId || !workoutData.weight || !workoutData.reps) {
					alert("운동, 무게, 횟수를 모두 입력해주세요.");
					return;
				}
				
				// 공통 저장 함수 호출
				saveWorkoutLog(workoutData, "#form-add-log");
			});
			
			// 1RM 저장 폼 제출 이벤트
			$("#form-save-1rm").on("submit", function(e) {
				e.preventDefault();
				
				let requests = []; // 여러 개의 Ajax 요청을 담을 배열
				
				// 각 1RM 입력 필드를 순회합니다.
				$(".rm-input").each(function() {
					let $input = $(this);
					let weight = $input.val();
					let exerciseName = $input.data("exercise-name");

					// 무게가 입력된 필드만 처리합니다.
					if (weight) {
						// 운동 이름으로 userExerciseList에서 해당 운동 정보를 찾습니다.
						let exercise = userExerciseList.find(function(ex) {
							return ex.exerciseName === exerciseName;
						});
						
						if (exercise) {
							let workoutData = {
								userExerciseId: exercise.userExerciseId,
								weight: weight,
								reps: 1, // 1RM은 항상 1회입니다.
								logDate: $("#pickDate").val(),
								logType: '1RM'
							};
							// 생성된 저장 요청을 배열에 추가합니다.
							requests.push(saveWorkoutLog(workoutData));
						} else {
							// 사용자가 해당 3대 운동을 'selected_exercises'에 추가하지 않았을 경우를 대비한 경고
							console.warn("'" + exerciseName + "' 운동이 사용자의 운동 목록에 없습니다. DB에 추가 후 시도해주세요.");
						}
					}
				});

				// 저장할 기록이 있을 경우에만 실행
				if (requests.length > 0) {
					// Promise.all: 배열 안의 모든 Ajax 요청이 완료되기를 기다립니다.
					Promise.all(requests).then(function() {
						alert("1RM 기록이 저장되었습니다.");
						loadLogs($("#pickDate").val()); // 전체 목록 새로고침
						$(".rm-input").val(""); // 입력 필드 비우기
					});
				} else {
					alert("저장할 1RM 기록이 없습니다.");
				}
			});
			
			/**
			 * 운동 기록 저장을 위한 공통 Ajax 함수
			 */
			function saveWorkoutLog(workoutData, formSelector) {
				return $.ajax({
					url: "${pageContext.request.contextPath}/api/workout/add",
					type: "post",
					contentType: "application/json",
					data: JSON.stringify(workoutData),
					dataType: "json",
					success: function(jsonResult) {
						if (jsonResult.result === "success") {
							if (formSelector) { // 폼 셀렉터가 있을 경우에만 폼을 초기화하고 목록을 다시 로드합니다.
								loadLogs($("#pickDate").val());
								$(formSelector)[0].reset();
								$(formSelector + " [name=userExerciseId]").empty().append('<option value="">운동 선택</option>');
							}
						} else {
							alert(jsonResult.message);
						}
					},
					error: function(xhr, status, error) { console.error("운동 기록 저장 실패:", error); }
				});
			}

			// 삭제 이벤트 핸들러 (이제 '오늘의 운동' 목록만 대상으로 합니다)
			$("#workoutLogList").on("click", ".remove-btn", function() {
				let $item = $(this).closest(".set-item");
				let logId = $item.data("log-id");

				if (confirm("정말 삭제하시겠습니까?")) {
					$.ajax({
						url: "${pageContext.request.contextPath}/api/workout/remove/" + logId,
						type: "delete",
						dataType: "json",
						success: function(jsonResult) {
							if (jsonResult.result === "success") {
								$item.fadeOut(300, function() { 
									$(this).remove(); 
									loadLogs($("#pickDate").val());
								});
							} else {
								alert(jsonResult.message);
							}
						},
						error: function(xhr, status, error) { console.error("운동 기록 삭제 실패:", error); }
					});
				}
			});
			
			// ================== 데이터 불러오기(AJAX) ==================
			function loadLogs(dateStr) {
				console.log(dateStr + "출력");
				
				$.ajax({
					url: '${pageContext.request.contextPath}/api/workout/logs',
					type: "get",
					//contentType: ,
					data: { logDate: dateStr },
					
					dataType: "json",
					success: function(jsonResult) {
						/*성공시 처리해야될 코드 작성*/
						console.log(jsonResult);
						console.log(jsonResult.result);
						console.log(jsonResult.apiData);
						
						if (jsonResult.result == "success") {
							let rows = jsonResult.apiData;
							renderLogList(rows); // 목록 갱신
							renderSummary(rows); // 요약 갱신
						} else {
							alert(jsonResult.message);
						}
					},
					error: function(XHR, status, error) {
						console.error(status + " : " + error);
					}
				});
				
			}
	
			// ================== 운동 기록 목록 렌더링 ==================
			function renderLogList(logList) {
				//변수 이름 앞에 $ 붙이는건 jQuery 객체라는 걸 표시하려는 코딩 관례
				let $normalListContainer = $('#workoutLogList');
				
				//기존 목록 비우기
				$normalListContainer.empty(); 
				
				let normalLogs = logList.filter(function(log) {
					return log.logType == 'NORMAL';
				});
				
				for (let i = 0; i < normalLogs.length; i++) {
					let log = normalLogs[i];
					let str = '<div class="set-item" data-log-id="' + log.logId + '">' +
								'<span>' + (log.bodyPart || '-') + '</span> ' +
								'<span>' + (log.exerciseName || '-') + '</span> ' +
								'<span>' + (log.weight || 0) + '</span> ' + '<span>kg</span> ' +
								'<span>✕</span> ' + '<span>' + (log.reps || 0) + '</span> ' + '<span>회</span>' +
								'<button class="remove-btn">—</button>' + 
							  '</div>';
					$normalListContainer.append(str);
				}
				
				
			}
	
			// ================== 요약 박스(최고중량/총반복/총볼륨/1RM) ==================
			function renderSummary(rows) {
				let maxW = 0, repsSum = 0, volumeSum = 0;
				
				let normalLogs = rows.filter(function(log){
					return log.logType == 'NORMAL';
				});
				
				$('#summaryCount').text(normalLogs.length + '개 운동 등록 수행');
	
				
				for (let i = 0; i < normalLogs.length; i++) {
					let w = Number(normalLogs[i].weight || 0);
					let rep = Number(normalLogs[i].reps || 0);
					
					if (w > maxW) maxW = w;
					repsSum += rep;
					volumeSum += (w * rep);
				}
	
				$("#maxWeight").text(maxW);
				$("#totalReps").text(repsSum);
				$("#totalVolume").text(volumeSum);
	
				
				$("#rm-bench").text(calc1RM(rows, "벤치프레스"));
				$("#rm-dead").text(calc1RM(rows, "데드리프트"));
				$("#rm-squat").text(calc1RM(rows, "스쿼트"));
			}
	
			
			function calc1RM(rows, name) {
				
				let actual1RMLogs = rows.filter(function(log) { 
					return log.exerciseName == name && log.logType == '1RM'; 
				});

				if (actual1RMLogs.length > 0) {
					actual1RMLogs.sort(function(a,b){
						if(a.createdAt > b.createdAt) return -1;
						if(a.createdAt < b.createdAt) return 1;
						return 0;
					});
					
					// 가장 최신 기록의 무게를 반환
					return actual1RMLogs[0].weight;
				}
				// 1RM 기록이 없으면 0을 반환
				return 0;
			}
			
	});
	</script>
</body>

</html>