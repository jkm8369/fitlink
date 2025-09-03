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
		            <!-- 트레이너일 경우, currentMember 유무로 어떤 aside를 보여줄지 결정 -->
		            <c:choose>
		                <c:when test="${not empty currentMember}">
		                    <c:import url="/WEB-INF/views/include/aside-trainer-member.jsp"></c:import>
		                </c:when>
		                <c:otherwise>
		                    <c:import url="/WEB-INF/views/include/aside-trainer.jsp"></c:import>
		                </c:otherwise>
		            </c:choose>
		        </c:when>
		        <c:otherwise>
		            <!-- 회원이면 무조건 회원용 aside -->
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
							</select> <select id="select-exercise-name" name="userExerciseId">
								<option value="">운동</option>
							</select> <span>무게</span> <input id="input-weight" name="weight" type="text" placeholder="숫자" /> <span>kg</span> <span>×</span> <input id="input-reps"
								name="reps" type="text" placeholder="숫자" /> <span>회</span>

							<button type="submit" class="btn-plus">+</button>
						</form>

						<!-- -- + 클릭시 추가되는 폼 (js)-- -->
						<div id="workoutLogList" class="set-list"></div>
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
								<label>벤치프레스</label> <input type="number" class="rm-input" data-exercise-name="벤치프레스" placeholder="kg">
							</div>
							<div class="rm-input-group">
								<label>데드리프트</label> <input type="number" class="rm-input" data-exercise-name="데드리프트" placeholder="kg">
							</div>
							<div class="rm-input-group">
								<label>스쿼트</label> <input type="number" class="rm-input" data-exercise-name="스쿼트" placeholder="kg">
							</div>
							<button type="submit" class="btn-plus">+</button>
						</form>

						<!-- -- + 클릭시 추가되는 폼 (js)-- -->
						<div id="1rmLogList" class="set-list"></div>
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
        // [주석] ------------------- 디버깅 & 초기 설정 -------------------
        // [주석] 현재 보고 있는 회원의 ID를 가져옵니다. 이 값이 0이면 본인 페이지, 0보다 크면 트레이너가 보는 회원 페이지입니다.
        const currentMemberId = Number("${currentMember.userId}" || 0);
        
        // [주석] F12 개발자 도구의 'Console' 탭에서 이 값이 올바르게 나오는지 확인해주세요.
        //console.log("페이지 로딩 완료. 현재 보고 있는 회원 ID:", currentMemberId);

        let state = { y: null, m: null, selected: null };
        let userExerciseList = [];

        // [주석] 숫자나 날짜를 포맷하는 헬퍼 함수들
        function pad(n) { return (n < 10 ? '0' : '') + n; }
        function fmt(y, m, d) { return y + "-" + pad(m + 1) + "-" + pad(d); }
        function formatKoreanDate(dateStr) {
            let parts = dateStr.split("-");
            if (parts.length == 3) {
                return parts[0] + "년 " + parseInt(parts[1], 10) + "월 " + parseInt(parts[2], 10) + "일";
            }
            return dateStr;
        }

        // [주석] 페이지 로딩 시 초기화
        let _now = new Date();
        let _today = fmt(_now.getFullYear(), _now.getMonth(), _now.getDate());
        $("#pickDate").val(_today);
        $("#currentDateLabel").text(formatKoreanDate(_today));
        loadLogs(_today);
        initializeForms(); 

        // [주석] 달력 관련 클릭 이벤트 핸들러들
        $("#btnToggleCalendar").on("click", function(e) {
            e.stopPropagation();
            let $cal = $("#inlineCalendar");
            if ($cal.is(":visible")) {
                $cal.hide();
            } else {
                let sel = $("#pickDate").val() || _today;
                let p = sel.split("-");
                state.y = parseInt(p[0], 10);
                state.m = parseInt(p[1], 10) - 1;
                state.selected = sel;
                renderCalendar();
                $cal.show();
            }
        });
        $(document).on("click",function(e) {
            let $cal = $("#inlineCalendar");
            if (!$cal.is(":visible")) return;
            if ($(e.target).closest("#inlineCalendar, #btnToggleCalendar").length === 0) {
                $cal.hide();
            }
        });
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
        $("#calToday").on("click", function(e) {
            e.stopPropagation();
            state.selected = _today;
            $("#pickDate").val(_today);
            $("#currentDateLabel").text(formatKoreanDate(_today));
            loadLogs(_today);
            $("#inlineCalendar").hide();
        });

        /**
        * [주석] 달력에 운동 기록이 있는 날짜를 표시하기 위해 데이터를 불러오는 함수
        */
        function renderCalendar() {
            let y = state.y, m = state.m;
            $("#calTitle").text(y + "년 " + (m + 1) + "월");
            
            let ajaxData = { year: y, month: m + 1 };
            if (currentMemberId > 0) {
                ajaxData.memberId = currentMemberId;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/api/workout/logged-dates",
                type: "get",
                data: ajaxData,
                dataType: "json",
                success: function(jsonResult) {
                    let loggedDates = (jsonResult.result === "success") ? jsonResult.apiData : [];
                    buildCalendarDOM(loggedDates);
                },
                error: function(xhr, status, error) {
                    console.error("달력 데이터 로딩 에러:", error);
                    buildCalendarDOM([]);
                }
            });
        }

        /**
        * [주석] 달력의 HTML을 만드는 함수
        */
        function buildCalendarDOM(loggedDates) {
            let y = state.y, m = state.m;
            let first = new Date(y, m, 1);
            let startDay = first.getDay();
            let lastDate = new Date(y, m + 1, 0).getDate();
            let prevLast = new Date(y, m, 0).getDate();
            let html = "";
            let i, d, dateStr, cls;
            for (i = 0; i < startDay; i++) {
                d = prevLast - (startDay - 1 - i);
                html += '<div class="cal-day out" aria-hidden="true">' + d + '</div>';
            }
            for (d = 1; d <= lastDate; d++) {
                dateStr = fmt(y, m, d);
                cls = "cal-day";
                if (dateStr == _today) cls += " today";
                if (dateStr == state.selected) cls += " selected";
                if (loggedDates.includes(dateStr)) cls += " has-log";
                html += '<button type="button" class="' + cls + '" data-date="' + dateStr + '">' + d + '</button>';
            }
            let totalCells = startDay + lastDate;
            let remain = (7 - (totalCells % 7)) % 7;
            for (i = 1; i <= remain; i++) {
                html += '<div class="cal-day out" aria-hidden="true">' + i + '</div>';
            }
            $("#calDays").html(html);
            $("#calDays .cal-day[data-date]").on("click", function(ev) {
                ev.stopPropagation();
                let picked = $(this).data("date");
                state.selected = picked;
                $("#pickDate").val(picked);
                $("#currentDateLabel").text(formatKoreanDate(picked));
                $("#calDays .cal-day").removeClass("selected");
                $(this).addClass("selected");
                loadLogs(picked);
                $("#inlineCalendar").hide();
            });
        }

        /**
        * [주석] 페이지 로딩 시 폼을 초기화하는 함수 (운동 목록 드롭다운 문제 해결의 핵심)
        */
        function initializeForms() {
            let ajaxData = {};
            if (currentMemberId > 0) {
                ajaxData.memberId = currentMemberId;
            }
            
            $.ajax({
                url: "${pageContext.request.contextPath}/api/workout/user-exercises",
                type: "get",
                data: ajaxData,
                dataType: "json",
                success: function(jsonResult) {
                    if (jsonResult.result == "success") {
                        userExerciseList = jsonResult.apiData;
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
        * [주석] 부위/운동 select 박스 한 쌍을 설정하는 함수
        */
        function setupExerciseSelects(bodyPartSelector, exerciseSelector) {
            let $bodyPartSelect = $(bodyPartSelector);
            let $exerciseSelect = $(exerciseSelector);
            
            $bodyPartSelect.empty().append('<option value="">부위 선택</option>');
            let bodyParts = [...new Set(userExerciseList.map(item => item.bodyPart))]; 
            bodyParts.forEach(function(part) {
                $bodyPartSelect.append('<option value="' + part + '">' + part + '</option>');
            });
            
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

        /**
        * [주석] 특정 날짜의 운동 기록을 불러오는 함수 (운동일지 목록 문제 해결의 핵심)
        */
        function loadLogs(dateStr) {
            let ajaxData = { logDate: dateStr };
            if (currentMemberId > 0) {
                ajaxData.memberId = currentMemberId;
            }
            
            $.ajax({
                url: '${pageContext.request.contextPath}/api/workout/logs',
                type: "get",
                data: ajaxData,
                dataType: "json",
                success: function(jsonResult) {
                    if (jsonResult.result == "success") {
                        renderLogList(jsonResult.apiData);
                        renderSummary(jsonResult.apiData);
                    } else {
                        alert(jsonResult.message);
                    }
                },
                error: function(XHR, status, error) {
                    console.error("운동 기록 로딩 실패:", error);
                }
            });
        }

        /**
        * [주석] 운동 기록 저장을 위한 공통 Ajax 함수 (1RM 등록 문제 해결의 핵심)
        */
        function saveWorkoutLog(workoutData, formSelector) {
            if (currentMemberId > 0) {
                workoutData.userId = currentMemberId;
            }

            return $.ajax({
                url: "${pageContext.request.contextPath}/api/workout/add",
                type: "post",
                contentType: "application/json",
                data: JSON.stringify(workoutData),
                dataType: "json",
                success: function(jsonResult) {
                    if (jsonResult.result === "success") {
                        if (formSelector) {
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

        // [주석] 폼 제출 및 삭제 이벤트 핸들러
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
            saveWorkoutLog(workoutData, "#form-add-log");
        });
        
        $("#form-save-1rm").on("submit", function(e) {
            e.preventDefault();
            let requests = [];
            $(".rm-input").each(function() {
                let $input = $(this);
                let weight = $input.val();
                let exerciseName = $input.data("exercise-name");
                if (weight) {
                    let exercise = userExerciseList.find(ex => ex.exerciseName === exerciseName);
                    if (exercise) {
                        let workoutData = {
                            userExerciseId: exercise.userExerciseId,
                            weight: weight,
                            reps: 1,
                            logDate: $("#pickDate").val(),
                            logType: '1RM'
                        };
                        requests.push(saveWorkoutLog(workoutData));
                    } else {
                        console.warn("'" + exerciseName + "' 운동이 사용자의 운동 목록에 없습니다.");
                    }
                }
            });
            if (requests.length > 0) {
                Promise.all(requests).then(function() {
                    alert("1RM 기록이 저장되었습니다.");
                    loadLogs($("#pickDate").val());
                    $(".rm-input").val("");
                });
            } else {
                alert("저장할 1RM 기록이 없습니다.");
            }
        });

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

        // [주석] 불러온 데이터를 화면에 그리는 함수들
        function renderLogList(logList) {
            let $normalListContainer = $('#workoutLogList');
            $normalListContainer.empty();
            let normalLogs = logList.filter(log => log.logType == 'NORMAL');
            for (let i = 0; i < normalLogs.length; i++) {
                let log = normalLogs[i];
                let str = 
                    '<div class="set-item" data-log-id="' + log.logId + '">' +
                        '<span>' + (log.bodyPart || '-') + '</span>' +
                        '<span>' + (log.exerciseName || '-') + '</span>' +
                        '<span>' + (log.weight || 0) + '</span><span>kg</span>' +
                        '<span>✕</span>' +
                        '<span>' + (log.reps || 0) + '</span><span>회</span>' +
                        '<button class="remove-btn">—</button>' +
                    '</div>';
                $normalListContainer.append(str);
            }
        }

        function renderSummary(rows) {
            let maxW = 0, repsSum = 0, volumeSum = 0;
            let normalLogs = rows.filter(log => log.logType == 'NORMAL');
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
            let actual1RMLogs = rows.filter(log => log.exerciseName == name && log.logType == '1RM');
            if (actual1RMLogs.length > 0) {
                actual1RMLogs.sort((a,b) => (a.createdAt > b.createdAt) ? -1 : 1);
                return actual1RMLogs[0].weight;
            }
            return 0;
        }
    });
    </script>

</body>

</html>