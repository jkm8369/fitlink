<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>회원 등록 모달창</title>
    <link rel="stylesheet" href="../../assets/css/form_trainer.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
    />
  </head>
  <body>
    <!-- 모달 오버레이: 뒷배경을 어둡게 만드는 역할 -->
    <div class="modal-overlay">
      <!-- 모달 컨테이너: 실제 내용이 들어가는 흰색 박스 -->
      <div class="modal-container">
        <!-- 1. 모달 헤더: 제목과 닫기 버튼 -->
        <div class="modal-header">
          <h2 class="modal-title">PT 예약</h2>
          <button class="modal-close-btn">
            <i class="fa-solid fa-xmark"></i>
          </button>
        </div>

        <!-- 2. 모달 바디: 입력 폼 -->
        <div class="modal-body">
          <form class="register-form">
            <!-- 각 입력 필드를 그룹으로 묶습니다 -->
            <div class="modal-calendar">
              <!-- 풀캘린더 -->
            </div>

            <div class="time-selector">
              <!-- 시간 선택 제목 -->
              <h3 class="time-selector-title">시간 선택</h3>
              <p class="time-selector-date">2025년 7월 9일 수요일</p>

              <!-- 시간 버튼들을 담는 그리드 -->
              <div class="time-grid">
                <button class="time-slot disabled">06:00</button>
                <button class="time-slot">07:00</button>
                <button class="time-slot">08:00</button>
                <button class="time-slot">09:00</button>
                <button class="time-slot">10:00</button>
                <button class="time-slot disabled">11:00</button>
                <button class="time-slot selected">12:00</button>
                <button class="time-slot selected">13:00</button>
                <button class="time-slot">14:00</button>
                <button class="time-slot">15:00</button>
                <button class="time-slot">16:00</button>
                <button class="time-slot">17:00</button>
                <button class="time-slot">18:00</button>
                <button class="time-slot">19:00</button>
                <button class="time-slot">20:00</button>
                <button class="time-slot">21:00</button>
                <button class="time-slot">22:00</button>
              </div>

              <!-- 상태 표시 범례 -->
              <div class="legend">
                <div class="legend-item">
                  <span class="legend-color available"></span>
                  <span>등록 가능</span>
                </div>
                <div class="legend-item">
                  <span class="legend-color disabled"></span>
                  <span>등록 불가</span>
                </div>
                <div class="legend-item">
                  <span class="legend-color selected"></span>
                  <span>선택됨</span>
                </div>
              </div>
            </div>
          </form>
        </div>

        <!-- 3. 모달 푸터: 저장 버튼 -->
        <div class="modal-footer">
          <button class="submit-btn">저장</button>
          <button class="delete-btn">삭제</button>
        </div>
      </div>
    </div>
  </body>
</html>
