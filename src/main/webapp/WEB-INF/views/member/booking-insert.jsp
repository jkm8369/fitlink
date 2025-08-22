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
		  // ====================== 공통/초기화 ======================
		  const CTX = '<%=request.getContextPath()%>'; // JSP 컨텍스트 루트. 모든 fetch URL 앞에 붙여 서버 경로를 안전하게 맞춤.
		
		  // DOM 요소 캐시 (반복 접근 최소화)
		  const txtDate  = document.getElementById('selDateText'); // 사람이 읽는 날짜 텍스트 표시 영역
		  const grid     = document.getElementById('timeGrid');    // 시간 슬롯을 렌더링할 컨테이너
		  const btnSave  = document.getElementById('btnSave');     // "예약" 버튼
		  const btnClose = document.getElementById('btnClose');    // 모달 우상단 X 버튼
		  const btnDelete= document.getElementById('btnDelete');   // 하단 "닫기" 버튼
		
		  // URL에서 date 파라미터 추출 (예: ?date=2025-07-09)
		  const params  = new URLSearchParams(location.search);
		  const dateStr = params.get('date');
		  if (!dateStr) {
		    // date가 없으면 모달을 닫고 사용자에게 알림
		    alert('날짜 정보가 없습니다.');
		    // 부모 창(오버레이 띄운 쪽)으로 "모달 닫기" 메시지를 보냄
		    window.parent?.postMessage({ type: 'modal-close' }, window.location.origin);
		    return; // 이후 로직 중단
		  }
		
		  // 사람이 보기 좋은 형식(YYYY년 M월 D일 요일)으로 변환해서 상단에 표시
		  const pretty = new Date(dateStr).toLocaleDateString('ko-KR', {
		    year:'numeric', month:'long', day:'numeric', weekday:'long'
		  });
		  txtDate.textContent = pretty;
		
		  // ====================== 유틸 함수 ======================
		  // 객체에서 여러 키 후보 중 첫번째로 존재하는 값을 골라 반환 (백엔드 컬럼/키 이름이 다를 수 있어 호환용)
		  function pick(obj, ...keys) {
		    for (const k of keys) if (obj && obj[k] != null) return obj[k];
		    return undefined;
		  }
		  // 숫자 변환 유틸 (실패 시 null)
		  function toInt(v) {
		    if (v == null) return null;
		    const n = Number(v);
		    return Number.isFinite(n) ? n : null;
		  }
		  // 2자리 패딩 (예: 6 → "06")
		  function pad2(n) { return String(n).padStart(2,'0'); }
		
		  // ====================== 렌더링 (슬롯 그리기) ======================
		  /**
		   * slotsRaw: 서버에서 내려준 슬롯 배열
		   *  - 시간(hour), 해당 시간의 근무칸/가용ID(availabilityId), 상태(status)가 들어있음
		   *  - 키 이름은 백엔드에 따라 달라질 수 있어 pick()으로 유연하게 매핑
		   * 상태 정의 예시:
		   *  - 'AVAILABLE': 예약 가능
		   *  - 'BOOKED'   : 이미 예약됨
		   *  - 'BLOCKED'  : 근무칸 자체 없음/비가용
		   */
		  function renderSlots(slotsRaw) {
		    // 시간(hour) 기준으로 빠르게 조회하기 위해 Map 구성
		    const mapByHour = new Map();
		    (Array.isArray(slotsRaw) ? slotsRaw : []).forEach(s => {
		      // 다양한 키 네이밍을 허용 (XML/쿼리/DTO에 따라 케이스/스네이크/카멜 혼재 가능)
		      const hour = toInt(pick(s, 'hour','HOUR','workHour','WORK_HOUR','h'));
		      const availabilityId = toInt(pick(s, 'availabilityId','AVAILABILITYID','avail_id','AVAIL_ID','availability_id'));
		      const status = String(pick(s,'status','STATUS') ?? '').toUpperCase();
		      if (hour != null) {
		        mapByHour.set(hour, { hour, availabilityId, status });
		      }
		    });
		
		    // 그리드 초기화
		    grid.innerHTML = '';
		
		    // 화면에 고정적으로 06시~22시까지의 17개 칸을 그림
		    for (let h = 6; h <= 22; h++) {
		      // 서버 데이터에 해당 시간이 없으면 기본 상태를 BLOCKED로 처리
		      const item = mapByHour.get(h) ?? { hour: h, availabilityId: null, status: 'BLOCKED' };
		
		      // 체크박스/라벨 페어를 만들기 위한 고유 id
		      const id = 'h-' + pad2(h);
		
		      // 실제 선택 요소(시각 1칸 = 체크박스 1개)
		      const input = document.createElement('input');
		      input.type = 'checkbox';
		      input.className = 'time-chk';
		      input.id = id;
		
		      // 시각을 보여주는 라벨 (클릭 편의성 ↑)
		      const label = document.createElement('label');
		      label.className = 'time-label';
		      label.htmlFor = id;
		
		      // ★ 템플릿 리터럴 금지 → 문자열 연결 사용 (요구사항 준수)
		      label.innerHTML =
		        '<span class="hh">' + pad2(h) + '</span><span class="mm">:00</span>';
		
		      // 상태/가용ID에 따라 선택 가능 여부와 스타일 결정
		      const status = String(item.status || '').toUpperCase();
		      const availId = item.availabilityId;
		
		      if (status === 'AVAILABLE' && availId != null) {
		        // 예약 가능한 칸: 활성화하고, 체크 시 서버로 보낼 값(value)에 availabilityId 저장
		        label.classList.add('available');
		        input.disabled = false;
		        input.value = String(availId);
		      } else {
		        // 예약 불가 칸: BOOKED / BLOCKED 등
		        label.classList.add('disabled');
		        input.disabled = true;
		      }
		
		      // 체크박스의 선택/해제에 따라 라벨에 'selected' 스타일 토글
		      input.addEventListener('change', function () {
		        label.classList.toggle('selected', this.checked);
		      });
		
		      // DOM에 추가 (체크박스와 라벨을 연속으로 붙임 → CSS로 버튼처럼 보이게 함)
		      grid.appendChild(input);
		      grid.appendChild(label);
		    }
		
		    // (개발 편의) 콘솔에서 시간대별 상태/ID를 한 눈에 확인
		    console.table(
		      Array.from({length:17}, (_,i)=>6+i).map(h=>{
		        const it = mapByHour.get(h) || {};
		        return { hour:h, availabilityId: it.availabilityId ?? null, status: it.status ?? 'BLOCKED' };
		      })
		    );
		  }
		
		  // ====================== API 호출 ======================
		  /**
		   * 선택 날짜(dateStr)의 근무 슬롯을 서버에서 조회해 화면에 렌더
		   * 서버 응답 포맷 가정:
		   *   { ok: true, slots: [ { hour: 9, availabilityId: 123, status: 'AVAILABLE' }, ... ] }
		   * - ok가 false이거나 HTTP 에러면 예외 처리
		   */
		  async function loadSlots() {
		    const url = CTX + '/api/member/booking/slots?date=' + encodeURIComponent(dateStr);
		    const res = await fetch(url);
		    const data = await res.json();
		    if (!res.ok || data.ok === false) throw new Error(data.msg || '슬롯 조회 실패');
		    renderSlots(data.slots);
		  }
		
		  // ====================== 액션(버튼 동작) ======================
		  // "예약" 버튼: 체크된 모든 시간(availabilityId 배열)을 한번에 예약
		  btnSave.addEventListener('click', async () => {
		    // 체크된 체크박스(value=availabilityId) 수집
            //   - value는 문자열이므로 Number()로 변환 → NaN은 필터링
		    const selectedIds = Array.from(grid.querySelectorAll('.time-chk:checked'))
		      .map(i => Number(i.value))
		      .filter(v => !Number.isNaN(v));
		
		    if (selectedIds.length === 0) {
		      alert('예약 가능한 시간을 선택하세요.');
		      return;
		    }
		
		    try {
		      // 일괄 예약 엔드포인트 호출 (서버 요구 스키마에 맞춰 availabilityIds, memo 전송)
		      const res = await fetch(CTX + '/api/member/booking/reserve-bulk', {
		        method: 'POST',
		        headers: { 'Content-Type': 'application/json' },
		        body: JSON.stringify({ availabilityIds: selectedIds, memo: '' })
		      });
		      // JSON 파싱 실패 시를 대비해 안전 처리
		      const data = await res.json().catch(() => ({}));
		      if (!res.ok || data.ok === false) {
		        alert((data && data.msg) ? data.msg : '예약에 실패했습니다.');
		        return;
		      }
		      alert('예약되었습니다.');
		      // 부모 창에 "예약 완료" 이벤트를 보내, 부모가 달력 새로고침 등 후속 처리하도록 위임
		      window.parent?.postMessage({ type: 'booking-done' }, window.location.origin);
		    } catch (e) {
		      console.error(e);
		      alert('네트워크 오류로 예약에 실패했습니다.');
		    }
		  });
		
		  // 상단 X 버튼 / 하단 "닫기" 버튼: 모달 닫기 (부모 창에 위임)
		  btnClose.addEventListener('click', () => {
		    window.parent?.postMessage({ type: 'modal-close' }, window.location.origin);
		  });
		  btnDelete.addEventListener('click', () => {
		    window.parent?.postMessage({ type: 'modal-close' }, window.location.origin);
		  });
		
		  // ====================== 초기 진입 시 슬롯 로드 ======================
		  // 에러 시 알림 후 모달 닫기 (사용자 경험 보호)
		  loadSlots().catch(err => {
		    console.error(err);
		    alert('근무시간(슬롯) 로드에 실패했습니다.');
		    window.parent?.postMessage({ type: 'modal-close' }, window.location.origin);
		  });
		})();
	</script>
</body>
</html>
