<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
          <h2 class="modal-title">회원 수정</h2>
          <button class="modal-close-btn">
            <i class="fa-solid fa-xmark"></i>
          </button>
        </div>

        <!-- 2. 모달 바디: 입력 폼 -->
        <div class="modal-body">
          <form class="register-form">
            <!-- 각 입력 필드를 그룹으로 묶습니다 -->

            <!-- 이름 -->
            <div class="form-group">
              <label for="user-name">이름</label>
              <input type="text" id="user-name" value="" />
            </div>

            <!-- 전화번호 -->
            <div class="form-group">
              <label for="user-phone">전화번호</label>
              <input type="text" id="user-phone" value="" />
            </div>

            <!-- 직업 -->
            <div class="form-group">
              <label for="user-job">직업</label>
              <input type="text" id="user-job" value="" />
            </div>

            <!-- 상담일 -->
            <div class="form-group">
              <label for="consult-date">상담일</label>
              <div class="input-with-icon">
                <input type="text" id="consult-date" value="" />
                <i class="fa-regular fa-calendar-days"></i>
              </div>
            </div>

            <!-- 운동목적 -->
            <div class="form-group">
              <label for="purpose">운동목적</label>
              <select id="purpose">
                <option>기타</option>
                <option>체중 감량</option>
                <option>근력 증가</option>
              </select>
            </div>

            <!-- PT 등록일수 -->
            <div class="form-group">
              <label for="pt-days">PT등록일수</label>
              <input type="number" id="pt-days" value="" />
            </div>
          </form>
        </div>

        <!-- 3. 모달 푸터: 저장 버튼 -->
        <div class="modal-footer">
          <button class="submit-btn">저장</button>
        </div>
      </div>
    </div>
  </body>
</html>
