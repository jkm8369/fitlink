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
  <!-- ===================================================================
       [Modal] 근무시간 등록 (내부 모달 페이지)
       - 역할: 특정 날짜의 근무 가능 시간(시 단위)을 조회/저장/삭제
       - 구성: 헤더(제목/닫기) + 바디(시간 선택) + 푸터(저장/삭제)
     =================================================================== -->
  <div class="modal-container is-inner">
  
    <!-- [Header] 제목 + 닫기 버튼 -->
    <div class="modal-header">
      <h2 class="modal-title">일정</h2>
      <button class="modal-close-btn" id="btnClose" type="button">
        <i class="fa-solid fa-xmark"></i>
      </button>
    </div>

    <!-- [Body] 시간 선택 폼 -->
    <div class="modal-body">
      <form class="register-form">
        <div class="time-selector">
          <!-- 타이틀 -->
          <h3 class="time-selector-title">시간 선택</h3>

          <!-- 사용자가 선택한 날짜(쿼리 date)를 가독성 있게 출력 -->
          <p class="time-selector-date" id="selDateText">2025년 7월 9일 수요일</p>

          <!-- 시간 체크박스 그리드가 주입될 영역 -->
          <div class="time-grid" id="timeGrid"></div>

          <!-- 상태 범례 -->
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

    <!-- [Footer] 저장/삭제 버튼 -->
    <div class="modal-footer">
      <button class="submit-btn" id="btnSave" type="button">저장</button>
      <button class="delete-btn" id="btnDelete" type="button">삭제</button>
    </div>
  </div>

</body>
</html>
