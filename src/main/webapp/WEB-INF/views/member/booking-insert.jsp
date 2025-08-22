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

		<div class="modal-footer">
			<button class="submit-btn" id="btnSave" type="button">예약</button>
			<button class="delete-btn" id="btnDelete" type="button">닫기</button>
		</div>
	</div>
</body>
</html>
