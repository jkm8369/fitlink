<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>회원 등록 모달창</title>
<!-- 모달 전용 스타일 -->
<link rel="stylesheet" href="../../assets/css/schedule_modal.css" />
<!-- 아이콘 폰트 (닫기 버튼 X 아이콘 등) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
</head>
<body>
	<!-- 모달 컨테이너: 실제 내용이 들어가는 흰색 박스 -->
	<div class="modal-container is-inner">
		<!-- 1) 모달 헤더: 제목 + 닫기 버튼 -->
		<div class="modal-header">
			<h2 class="modal-title">PT 예약</h2>
			<button class="modal-close-btn" id="btnClose" type="button">
				<i class="fa-solid fa-xmark"></i>
			</button>
		</div>

		<!-- 2. 모달 바디: 입력 폼 -->
		<div class="modal-body">
			<form class="register-form">
				<!-- 시간 선택 전체 블록 -->
				<div class="time-selector">

					<!-- 날짜/시간 선택 타이틀 -->
					<h3 class="time-selector-title">시간 선택</h3>

					<!-- 사용자가 선택한 날짜(쿼리스트링의 date)를 사람이 보기 좋게 표시 -->
					<p class="time-selector-date" id="selDateText">2025년 7월 9일 수요일</p>

					<!-- 시간 버튼(체크박스 + 라벨)들이 렌더링될 그리드 -->
					<div class="time-grid" id="timeGrid"></div>

					<!-- 상태 표시 범례 -->
					<div class="legend">
						<div class="legend-item">
							<span class="legend-color available"></span> <span>등록 가능</span>
						</div>
						<div class="legend-item">
							<span class="legend-color disabled"></span> <span>등록 불가</span>
						</div>
						<div class="legend-item">
							<span class="legend-color selected"></span> <span>선택됨</span>
						</div>
					</div>
				</div>
			</form>
		</div>

		<!-- 3) 모달 푸터: 저장/삭제 버튼 -->
		<div class="modal-footer">
			<button class="submit-btn" id="btnSave" type="button">예약</button>
			<button class="delete-btn" id="btnDelete" type="button">닫기</button>
		</div>
	</div>

	<script>
		(function () {
		  const CTX = '<%=request.getContextPath()%>';
		
		  const txtDate  = document.getElementById('selDateText');
		  const grid     = document.getElementById('timeGrid');
		  const btnSave  = document.getElementById('btnSave');
		  const btnClose = document.getElementById('btnClose');
		  const btnDelete= document.getElementById('btnDelete');
		
		  const params  = new URLSearchParams(location.search);
		  const dateStr = params.get('date');
		  if (!dateStr) {
		    alert('날짜 정보가 없습니다.');
		    window.parent?.postMessage({ type: 'modal-close' }, window.location.origin);
		    return;
		  }
		
		  const pretty = new Date(dateStr).toLocaleDateString('ko-KR', {
		    year:'numeric', month:'long', day:'numeric', weekday:'long'
		  });
		  txtDate.textContent = pretty;
		
		  // ---------- utils ----------
		  function pick(obj, ...keys) {
		    for (const k of keys) if (obj && obj[k] != null) return obj[k];
		    return undefined;
		  }
		  function toInt(v) {
		    if (v == null) return null;
		    const n = Number(v);
		    return Number.isFinite(n) ? n : null;
		  }
		  function pad2(n) { return String(n).padStart(2,'0'); }
		
		  // ---------- render ----------
		  function renderSlots(slotsRaw) {
		    const mapByHour = new Map();
		    (Array.isArray(slotsRaw) ? slotsRaw : []).forEach(s => {
		      const hour = toInt(pick(s, 'hour','HOUR','workHour','WORK_HOUR','h'));
		      const availabilityId = toInt(pick(s, 'availabilityId','AVAILABILITYID','avail_id','AVAIL_ID','availability_id'));
		      const status = String(pick(s,'status','STATUS') ?? '').toUpperCase();
		      if (hour != null) {
		        mapByHour.set(hour, { hour, availabilityId, status });
		      }
		    });
		
		    grid.innerHTML = '';
		
		    // 06~22까지 고정 17칸
		    for (let h = 6; h <= 22; h++) {
		      const item = mapByHour.get(h) ?? { hour: h, availabilityId: null, status: 'BLOCKED' };
		
		      const id = 'h-' + pad2(h);
		
		      const input = document.createElement('input');
		      input.type = 'checkbox';
		      input.className = 'time-chk';
		      input.id = id;
		
		      const label = document.createElement('label');
		      label.className = 'time-label';
		      label.htmlFor = id;
		
		      // ★ 템플릿 리터럴 금지 → 문자열 연결 사용
		      label.innerHTML =
		        '<span class="hh">' + pad2(h) + '</span><span class="mm">:00</span>';
		
		      const status = String(item.status || '').toUpperCase();
		      const availId = item.availabilityId;
		
		      if (status === 'AVAILABLE' && availId != null) {
		        label.classList.add('available');
		        input.disabled = false;
		        input.value = String(availId);
		      } else {
		        label.classList.add('disabled'); // BOOKED/BLOCKED
		        input.disabled = true;
		      }
		
		      input.addEventListener('change', function () {
		        label.classList.toggle('selected', this.checked);
		      });
		
		      grid.appendChild(input);
		      grid.appendChild(label);
		    }
		
		    // 디버그용
		    console.table(
		      Array.from({length:17}, (_,i)=>6+i).map(h=>{
		        const it = mapByHour.get(h) || {};
		        return { hour:h, availabilityId: it.availabilityId ?? null, status: it.status ?? 'BLOCKED' };
		      })
		    );
		  }
		
		  // ---------- api ----------
		  async function loadSlots() {
		    const url = CTX + '/api/member/booking/slots?date=' + encodeURIComponent(dateStr);
		    const res = await fetch(url);
		    const data = await res.json();
		    if (!res.ok || data.ok === false) throw new Error(data.msg || '슬롯 조회 실패');
		    renderSlots(data.slots);
		  }
		
		  // ---------- actions ----------
		  btnSave.addEventListener('click', async () => {
		    const selectedIds = Array.from(grid.querySelectorAll('.time-chk:checked'))
		      .map(i => Number(i.value))
		      .filter(v => !Number.isNaN(v));
		
		    if (selectedIds.length === 0) {
		      alert('예약 가능한 시간을 선택하세요.');
		      return;
		    }
		
		    try {
		      const res = await fetch(CTX + '/api/member/booking/reserve-bulk', {
		        method: 'POST',
		        headers: { 'Content-Type': 'application/json' },
		        body: JSON.stringify({ availabilityIds: selectedIds, memo: '' })
		      });
		      const data = await res.json().catch(() => ({}));
		      if (!res.ok || data.ok === false) {
		        alert((data && data.msg) ? data.msg : '예약에 실패했습니다.');
		        return;
		      }
		      alert('예약되었습니다.');
		      window.parent?.postMessage({ type: 'booking-done' }, window.location.origin);
		    } catch (e) {
		      console.error(e);
		      alert('네트워크 오류로 예약에 실패했습니다.');
		    }
		  });
		
		  btnClose.addEventListener('click', () => {
		    window.parent?.postMessage({ type: 'modal-close' }, window.location.origin);
		  });
		  btnDelete.addEventListener('click', () => {
		    window.parent?.postMessage({ type: 'modal-close' }, window.location.origin);
		  });
		
		  // ---------- init ----------
		  loadSlots().catch(err => {
		    console.error(err);
		    alert('근무시간(슬롯) 로드에 실패했습니다.');
		    window.parent?.postMessage({ type: 'modal-close' }, window.location.origin);
		  });
		})();
	</script>
</body>
</html>
