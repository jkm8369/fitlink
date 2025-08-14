<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Workout Log - FitLink</title>
    <link rel="stylesheet" href="../../assets/css/reset.css" />
    <link rel="stylesheet" href="../../assets/css/include.css" />
    <link rel="stylesheet" href="../../assets/css/trainer.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
    />
  </head>
  <body>
    <div id="wrap">
      <!-- ------헤더------ -->
      <header>
        <!-- 왼쪽: 이미지 로고 (변경됨) -->
        <a href="" class="btn-logout">
          <!-- 여기에 실제 로고 이미지 파일을 연결하세요 -->
          <img
            src="../../../../project/front/assets/images/logo.jpg"
            alt="FitLnk Logo"
          />
        </a>

        <!-- 오른쪽: 사용자 메뉴 -->
        <div class="btn-logout">
          <a href="#" class="logout-link">
            <i class="fa-solid fa-right-from-bracket"></i>
            로그아웃
          </a>
        </div>
      </header>

      <!-- --aside + main-- -->
      <div id="content">
        <aside>
          <div class="user-info">
            <div class="user-name-wrap">
              <img
                class="dumbell-icon"
                src="../../assets/images/사이트로고.jpg"
                alt="dumbell-icon"
              />
              <p class="user-name">홍길동<br /><small>(트레이너)</small></p>
            </div>
          </div>

          <div class="aside-menu">
            <a href="#" class="menu-item">
              <i class="fa-solid fa-address-card"></i>
              <span>회원</span>
            </a>
            <a href="#" class="menu-item">
              <i class="fa-solid fa-calendar-days"></i>
              <span>일정</span>
            </a>
            <a href="#" class="menu-item">
              <i class="fa-solid fa-list-ul"></i>
              <span>운동종류</span>
            </a>
          </div>
        </aside>

        <main>
          <!-- 1. 제목 -->
          <div class="page-header">
            <h3 class="page-title">Exercise</h3>
          </div>
          <!-- //1. 제목 -->

          <!-- 2. 운동 종류 탭 -->
          <div class="category-tabs">
            <div class="tab">가슴</div>
            <div class="tab">등</div>
            <div class="tab">어깨</div>
            <div class="tab">하체</div>
            <div class="tab">팔</div>
            <div class="tab">복근</div>
            <div class="tab">유산소</div>
            <div class="tab">기타</div>
          </div>
          <!-- //2. 운동 종류 탭 -->

          <!-- 3.버튼 -->
          <div class="category-buttons">
            <button class="category-btn">
              <i class="fa-solid fa-plus"></i>
              운동종류 등록
            </button>
            <button class="category-btn">
              <i class="fa-solid fa-check"></i>
              저장
            </button>
          </div>
          <!-- ..3.버튼 -->

          <!-- 4.선택부위 -->
          <h4 class="category-title">가슴</h4>
          <!-- //4.선택부위 -->

          <!-- 5.내가 선택한 리스트 -->
          <section class="select-box">
            <p>내가 선택한 리스트</p>
            <ul class="category-grid">
              <li>벤치프레스</li>
              <li>스미스머신 벤치프레스</li>
              <li>푸시업</li>
              <li>중량 푸시업</li>
              <li>해머 벤치프레스</li>
              <li>스포토 벤치프레스</li>
            </ul>
          </section>
          <!-- //5.내가 선택한 리스트 -->

          <!-- 6.운동종류 리스트 -->
          <section class="list-box">
            <ul class="checkbox-grid">
              <li class="checkbox-item">
                <label>
                  <input type="checkbox" checked /><span
                    class="custom-checkbox"
                  ></span
                  >벤치프레스
                </label>
              </li>
              <li class="checkbox-item">
                <label>
                  <input type="checkbox" checked /><span
                    class="custom-checkbox"
                  ></span
                  >푸시업
                </label>
              </li>
              <li class="checkbox-item">
                <label>
                  <input type="checkbox" checked /><span
                    class="custom-checkbox"
                  ></span
                  >해머 벤치프레스
                </label>
              </li>
              <li class="checkbox-item">
                <label>
                  <input type="checkbox" checked /><span
                    class="custom-checkbox"
                  ></span
                  >스미스머신 벤치프레스
                </label>
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" checked /><span
                    class="custom-checkbox"
                  ></span
                  >중량 푸시업</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" checked /><span
                    class="custom-checkbox"
                  ></span
                  >스포토 벤치프레스</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >스미스머신 인클라인 벤치프레스</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >힌두 푸시업</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >어시스트 딥스 머신</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >덤벨 벤치프레스</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >아처 푸시업</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >디클라인 벤치프레스</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >인클라인 덤벨 벤치프레스</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >클로즈그립 푸시업</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >바벨 플로어 프레스</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >덤벨 플라이</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >케이블 크로스오버</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >클랩 푸시업</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >스탠딩 케이블 플라이</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >체스트 프레스 머신</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >디클라인 덤벨 플라이</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >인클라인 벤치프레스</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >펙덱 플라이 머신</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >인클라인 푸시업</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >딥스</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >덤벨 풀오버</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >파이크 푸시업</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >중량 딥스</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >시티드 딥스 머신</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >디클라인 체스트 프레스 머신</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >인클라인 덤벨 플라이</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >로우 풀리 케이블 플라이</label
                >
              </li>
              <li class="checkbox-item">
                <label
                  ><input type="checkbox" /><span class="custom-checkbox"></span
                  >인클라인 덤벨 트위스트 프레스</label
                >
              </li>
            </ul>
          </section>
          <!-- //6.운동종류 리스트 -->
        </main>
      </div>
      <footer>
        <p>Copyright © 2025. FitLink All rights reserved.</p>
      </footer>
    </div>
  </body>
</html>