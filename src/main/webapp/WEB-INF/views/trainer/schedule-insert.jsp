<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>근무시간 등록 모달창</title>
<!-- 모달 전용 스타일 -->
<link rel="stylesheet" href="../../assets/css/schedule_modal.css" />
<!-- 아이콘 폰트 (닫기 버튼 X 아이콘 등) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
</head>

<body>

	<!-- 모달 컨테이너: 흰색 박스. is-inner는 내부 모달 스타일용 클래스 -->
	<div class="modal-container is-inner">
		<!-- 1) 모달 헤더: 제목 + 닫기 버튼 -->
		<div class="modal-header">
			<h2 class="modal-title">일정</h2>
			<button class="modal-close-btn" id="btnClose" type="button">
				<i class="fa-solid fa-xmark"></i>
			</button>
		</div>

		<!-- 2) 모달 바디: 폼 영역 -->
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

					<!-- 상태 범례: 색으로 의미 전달 -->
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

		<!-- 3) 모달 푸터: 저장/삭제 버튼 -->
		<div class="modal-footer">
			<button class="submit-btn" id="btnSave" type="button">저장</button>
			<button class="delete-btn" id="btnDelete" type="button">삭제</button>
		</div>
	</div>

	<!--------------------------- script --------------------------->
	<script>
    (function () {
      // ✅ JSP의 컨텍스트 루트(/, /app 등): 백엔드 API 경로 만들 때 사용
      const CTX = '<%=request.getContextPath()%>';

      // ✅ 트레이너 관련 API의 베이스 URL
      const API_BASE = CTX + '/api/trainer';

      // ✅ 현재 로그인된(또는 테스트용) 트레이너 ID
      //   - 여기선 하드코딩 1. 추후 로그인 연동 시 세션값으로 대체 예정
      const TRAINER_ID = 1;

      // ✅ 자주 사용되는 DOM 요소 캐싱
      const grid = document.getElementById('timeGrid');     // 시간 체크박스들이 들어갈 컨테이너
      const txtDate = document.getElementById('selDateText'); // 상단에 사람이 읽기 좋게 표시되는 날짜 텍스트
      const btnSave = document.getElementById('btnSave');     // 저장 버튼
      const btnDelete = document.getElementById('btnDelete'); // 삭제 버튼
      const btnClose = document.getElementById('btnClose');   // 닫기 버튼(X)

      // ✅ 쿼리스트링에서 date=YYYY-MM-DD 값을 읽어옴
      //    예: ...?date=2025-07-09
      const params = new URLSearchParams(location.search);

      // ✅ date 파라미터가 없으면 오늘 날짜(브라우저 기준)를 기본값으로 사용
      const dateStr = params.get('date') || new Date().toISOString().slice(0, 10); // "YYYY-MM-DD"

      // ✅ 사용자가 보기 좋은 한글 날짜로 변환해서 헤더에 표시
      //    예: "2025년 7월 9일 수요일"
      const pretty = new Date(dateStr).toLocaleDateString('ko-KR', {
        year: 'numeric', month: 'long', day: 'numeric', weekday: 'long'
      });
      txtDate.textContent = pretty;

      // ✅ 화면에 표시할 시간대(24시간제). 여기서는 06:00 ~ 22:00까지
      const HOURS = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22];

      /**
       * ✅ 체크박스 + 라벨(시간 버튼)을 동적으로 생성해서 grid에 넣음
       *  - 최초 1회만 생성 (이미 있으면 재생성 안함)
       *  - 각 시간(h)마다 input[type=checkbox]와 label 한 쌍을 만든다
       */
      function ensureTimeGrid() {
        if (grid.childElementCount) return; // 이미 렌더링됐다면 패스

        HOURS.forEach(h => {
          // 예: h=6 -> id="h06", h=13 -> id="h13"
          const id = 'h' + String(h).padStart(2, '0');

          // (1) 체크박스 생성
          const input = document.createElement('input');
          input.type = 'checkbox';
          input.className = 'time-chk'; // 스타일/선택자용 클래스
          input.id = id;                // label과 연결할 id
          input.value = String(h);      // 나중에 선택된 시간 목록을 보낼 때 사용

          // (2) 라벨 생성 (사용자에게 보이는 버튼 역할)
          const label = document.createElement('label');
          label.htmlFor = id;           // 클릭 시 해당 체크박스 토글
          label.className = 'time-label';
          label.textContent = String(h).padStart(2, '0') + ':00'; // "06:00" 형식

          // (3) 접근성: 체크박스 포커스 상태에서 Enter/Space로 토글 가능하게 처리
          input.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
              e.preventDefault();
              input.checked = !input.checked;
            }
          });

          // (4) DOM에 추가 (체크박스 -> 라벨 순으로 추가)
          grid.appendChild(input);
          grid.appendChild(label);
        });
      }

      /**
       * ✅ 서버에서 특정 날짜의 근무 가능 시간 목록을 가져옴 (GET)
       *  - 요청: GET /api/trainer/{id}/availability?date=YYYY-MM-DD
       *  - 응답: [12, 13, 14, ...] 형태의 숫자 배열(시간)
       */
      async function fetchHours(dateStr) {
        const res = await fetch(API_BASE + '/' + TRAINER_ID + '/availability?date=' + encodeURIComponent(dateStr));
        if (!res.ok) throw new Error('GET failed');
        return res.json(); // 예: [12,13,...]
      }

      /**
       * ✅ 서버에 특정 날짜의 근무 가능 시간 목록을 저장함 (POST)
       *  - 요청: POST /api/trainer/{id}/availability
       *  - 바디: { date: "YYYY-MM-DD", hours: [숫자, ...] }
       *  - hours가 빈 배열([])이면 "해당 날짜 전체 삭제" 의미로 사용
       */
      async function saveHours(dateStr, hours) {
        const res = await fetch(API_BASE + '/' + TRAINER_ID + '/availability', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ date: dateStr, hours })
        });
        if (!res.ok) throw new Error('POST failed');
      }

      /**
       * ✅ 체크박스들에 "선택된 시간 배열"을 반영
       *  - 서버에서 받은 hours([12,13,...]) 기준으로 체크 상태를 동기화
       */
      function applySelected(hours) {
        const set = new Set(hours.map(Number)); // 숫자 Set으로 만들어 빠르게 포함 여부 체크
        grid.querySelectorAll('.time-chk').forEach(chk => {
          chk.checked = set.has(Number(chk.value));
        });
      }

      /**
       * ✅ 저장 버튼 클릭
       *  - 현재 체크된 체크박스들의 value(시간)를 수집 → 오름차순 정렬
       *  - 서버로 POST 요청
       */
      btnSave.addEventListener('click', async (e) => {
        e.preventDefault();
        try {
          // ".time-chk:checked"로 체크된 요소만 수집 → 숫자로 변환 → 정렬
          const hours = Array.from(grid.querySelectorAll('.time-chk:checked'))
            .map(i => Number(i.value))
            .sort((a, b) => a - b);

          await saveHours(dateStr, hours);
          alert('저장되었습니다.');
        } catch (err) {
          console.error(err);
          alert('저장 중 오류가 발생했습니다.');
        }
      });

      /**
       * ✅ 삭제 버튼 클릭
       *  - 확인 창에서 "확인" 시: 해당 날짜의 근무시간 전체 삭제(빈 배열 저장)
       *  - UI에서도 체크 해제하여 즉시 반영
       */
      btnDelete.addEventListener('click', async (e) => {
        e.preventDefault();
        if (!confirm('해당 날짜의 근무시간을 모두 삭제할까요?')) return;
        try {
          await saveHours(dateStr, []);
          applySelected([]); // 화면 체크박스도 모두 해제
          alert('삭제되었습니다.');
        } catch (err) {
          console.error(err);
          alert('삭제 중 오류가 발생했습니다.');
        }
      });

      /**
       * ✅ 닫기 버튼(X) 클릭
       *  - 부모 창(모달을 띄운 창)으로 "modal-close" 메세지를 보냄
       *  - 부모는 이 메세지를 받아 모달을 닫는 로직을 실행(예: display:none)
       *  - window.location.origin으로 동일 출처에만 메세지를 보냄 (보안)
       */
      btnClose.addEventListener('click', (e) => {
        e.preventDefault();
        window.parent?.postMessage({ type: 'modal-close' }, window.location.origin);
      });

      /**
       * ✅ 초기 로딩 시퀀스
       *  1) 시간 그리드(체크박스 + 라벨) UI를 만든다.
       *  2) 서버에서 해당 날짜의 선택된 시간 목록을 GET 한다.
       *     - 실패하면(네트워크/서버 문제 등) 빈 배열로 간주하여 모두 체크 해제 상태로 둔다.
       */
      ensureTimeGrid();
      fetchHours(dateStr)
        .then(applySelected)         // 성공 시 체크 상태 반영
        .catch(() => applySelected([])); // 실패 시 모두 해제 상태로
    })();
  </script>
</body>
</html>
