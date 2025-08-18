<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>근무시간 등록 모달창</title>
<link rel="stylesheet" href="../../assets/css/schedule_modal.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
</head>

<body>

	<!-- 모달 컨테이너: 실제 내용이 들어가는 흰색 박스 -->
	<div class="modal-container is-inner">
		<!-- 1. 모달 헤더: 제목과 닫기 버튼 -->
		<div class="modal-header">
			<h2 class="modal-title">일정</h2>
			<button class="modal-close-btn" id="btnClose" type="button">
				<i class="fa-solid fa-xmark"></i>
			</button>
		</div>

		<!-- 2. 모달 바디: 입력 폼 -->
		<div class="modal-body">
			<form class="register-form">
				<!-- 각 입력 필드를 그룹으로 묶습니다 -->

				<div class="time-selector">
					<!-- 시간 선택 제목 -->
					<h3 class="time-selector-title">시간 선택</h3>
					<p class="time-selector-date" id="selDateText">2025년 7월 9일 수요일</p>

					<!-- 시간 버튼들을 담는 그리드 -->
					<div class="time-grid" id="timeGrid"></div>

					<!-- 상태 표시 범례 -->
					<div class="legend">
						<div class="legend-item">
							<span class="legend-color available"></span> <span>등록 가능</span>
						</div>
						<div class="legend-item">
							<span class="legend-color selected"></span> <span>선택됨</span>
						</div>
					</div>
				</div>
			</form>
		</div>

		<!-- 3. 모달 푸터: 저장 버튼 -->
		<div class="modal-footer">
			<button class="submit-btn" id="btnSave" type="button">저장</button>
			<button class="delete-btn" id="btnDelete" type="button">삭제</button>
		</div>
	</div>

	<!--------------------------- script --------------------------->
	<script>
		(function () {
		  const CTX = '<%=request.getContextPath()%>';
		  const API_BASE   = CTX + '/api/trainer';
		  const TRAINER_ID = 1;
		
		  const grid = document.getElementById('timeGrid');
		  const txtDate = document.getElementById('selDateText');
		  const btnSave = document.getElementById('btnSave');
		  const btnDelete = document.getElementById('btnDelete');
		  const btnClose = document.getElementById('btnClose');
		
		  const params = new URLSearchParams(location.search);
		  const dateStr = params.get('date') || new Date().toISOString().slice(0, 10);
		
		  const pretty = new Date(dateStr).toLocaleDateString('ko-KR', {
		    year:'numeric', month:'long', day:'numeric', weekday:'long'
		  });
		  txtDate.textContent = pretty;
		
		  const HOURS = [6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
		
		  // ✔ 체크박스 + 라벨 생성
		  function ensureTimeGrid() {
		    if (grid.childElementCount) return;
		    HOURS.forEach(h => {
		      const id = 'h' + String(h).padStart(2, '0');
		
		      const input = document.createElement('input');
		      input.type = 'checkbox';
		      input.className = 'time-chk';
		      input.id = id;
		      input.value = String(h);
		
		      const label = document.createElement('label');
		      label.htmlFor = id;
		      label.className = 'time-label';
		      label.textContent = String(h).padStart(2,'0') + ':00';
		
		      // 키보드 포커스용
		      input.addEventListener('keydown', (e) => {
		        if (e.key === 'Enter' || e.key === ' ') {
		          e.preventDefault();
		          input.checked = !input.checked;
		        }
		      });
		
		      grid.appendChild(input);
		      grid.appendChild(label);
		    });
		  }
		
		  async function fetchHours(dateStr) {
		    const res = await fetch(API_BASE + '/' + TRAINER_ID + '/availability?date=' + encodeURIComponent(dateStr));
		    if (!res.ok) throw new Error('GET failed');
		    return res.json(); // [12,13,...]
		  }
		
		  async function saveHours(dateStr, hours) {
		    const res = await fetch(API_BASE + '/' + TRAINER_ID + '/availability', {
		      method: 'POST',
		      headers: { 'Content-Type': 'application/json' },
		      body: JSON.stringify({ date: dateStr, hours })
		    });
		    if (!res.ok) throw new Error('POST failed');
		  }
		
		  // ✔ 체크 상태 적용
		  function applySelected(hours) {
		    const set = new Set(hours.map(Number));
		    grid.querySelectorAll('.time-chk').forEach(chk => {
		      chk.checked = set.has(Number(chk.value));
		    });
		  }
		
		  // ✔ 저장
		  btnSave.addEventListener('click', async (e) => {
		    e.preventDefault();
		    try {
		      const hours = Array.from(grid.querySelectorAll('.time-chk:checked'))
		        .map(i => Number(i.value))
		        .sort((a,b) => a - b);
		      await saveHours(dateStr, hours);
		      alert('저장되었습니다.');
		    } catch (err) {
		      console.error(err);
		      alert('저장 중 오류가 발생했습니다.');
		    }
		  });
		
		  // ✔ 삭제
		  btnDelete.addEventListener('click', async (e) => {
		    e.preventDefault();
		    if (!confirm('해당 날짜의 근무시간을 모두 삭제할까요?')) return;
		    try {
		      await saveHours(dateStr, []);
		      applySelected([]);
		      alert('삭제되었습니다.');
		    } catch (err) {
		      console.error(err);
		      alert('삭제 중 오류가 발생했습니다.');
		    }
		  });
		
		  // 닫기 → 부모에 닫기 신호
		  btnClose.addEventListener('click', (e) => {
		    e.preventDefault();
		    window.parent?.postMessage({ type: 'modal-close' }, window.location.origin);
		  });
		
		  // 초기 로딩
		  ensureTimeGrid();
		  fetchHours(dateStr).then(applySelected).catch(() => applySelected([]));
		})();
	</script>


</body>

</html>