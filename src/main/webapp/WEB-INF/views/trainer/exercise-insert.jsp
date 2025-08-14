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
          <h2 class="modal-title">운동종류 등록</h2>
          <button class="modal-close-btn">
            <i class="fa-solid fa-xmark"></i>
          </button>
        </div>

        <!-- 2. 모달 바디: 입력 폼 -->
        <div class="modal-body">
          <form class="register-form">
            <!-- 각 입력 필드를 그룹으로 묶습니다 -->

            <!-- 운동종류 -->
            <div class="form-group">
              <label for="exercise-type">운동종류</label>
              <select id="exercise-type">
                <option>가슴</option>
                <option>등</option>
                <option>어깨</option>
              </select>
            </div>

            <!-- 이름 -->
            <div class="form-group">
              <label for="exercise-name">이름</label>
              <input type="text" id="exercise-name" value="" />
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
