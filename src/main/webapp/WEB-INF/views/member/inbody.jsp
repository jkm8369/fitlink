<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>InBody&Meal</title>
    <link rel="stylesheet" href="../../assets/css/reset.css" />
    <link rel="stylesheet" href="../../assets/css/include.css" />
    <link rel="stylesheet" href="../../assets/css/member.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
</head>

<body>
    <div id="wrap">

        <!-- ------헤더------ -->
        <header>
            <!-- 왼쪽: 이미지 로고 (변경됨) -->
            <h1>
                <a href="" class="btn-logout">
                    <!-- 여기에 실제 로고 이미지 파일을 연결하세요 -->
                    <img src="../../assets/images/logo.jpg" alt="FitLnk Logo" />
                </a>
            </h1>
            <!-- 오른쪽: 사용자 메뉴 -->
            <div class="btn-logout">
                <a href="#" class="logout-link">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    로그아웃
                </a>
            </div>
        </header>
        <!-- //------헤더------ -->

        <!-- --aside + main-- -->
        <div id="content">

            <aside>
                <div class="user-info">
                    <div class="user-name-wrap">
                        <img class="dumbell-icon" src="../../assets/images/사이트로고.jpg" alt="dumbell-icon">
                        <p class="user-name">
                            홍길동<br /><small>(회원)</small>
                        </p>
                    </div>
                    <div class="trainer-info">
                        <i class="fa-solid fa-clipboard-user"></i>
                        <span>1 Trainer</span>
                    </div>
                </div>
                <div class="aside-menu">
                    <a href="#" class="menu-item">
                        <i class="fa-solid fa-book"></i>
                        <span>운동일지</span>
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fa-solid fa-chart-pie"></i>
                        <span>InBody & Meal</span>
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fa-solid fa-images"></i>
                        <span>사진</span>
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fa-solid fa-calendar-check"></i>
                        <span>예약현황</span>
                    </a>
                    <a href="#" class="menu-item">
                        <i class="fa-solid fa-list-ul"></i>
                        <span>운동종류</span>
                    </a>
                </div>
            </aside>

            <main>
                <!-- main-box1 -->
                <div class="main-box1">
                    <div class="page-header">
                        <h3 class="page-title">InBody &amp; Meal</h3>
                    </div>

                    <section class="card list-card">
                        <div class="card-header">
                            <h4 class="card-title list-title">인바디 리스트</h4>
                        </div>

                        <table class="table inbody-table">
                            <thead>
                                <tr>
                                    <th class="w-90">순서</th>
                                    <th class="w-200">날짜</th>
                                    <th class="w-140">시간</th>
                                    <th class="w-140">인바디 점수</th>
                                    <th class="w-120 actions-head"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td>2025.02.01</td>
                                    <td>14:00</td>
                                    <td>60점</td>
                                    <td class="actions">
                                        <button class="icon-btn" aria-label="등록"><i
                                                class="fa-solid fa-pen-to-square"></i></button>
                                        <button class="icon-btn" aria-label="삭제"><i
                                                class="fa-regular fa-trash-can"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>2025.04.14</td>
                                    <td>15:00</td>
                                    <td>80점</td>
                                    <td class="actions">
                                        <button class="icon-btn" aria-label="등록"><i
                                                class="fa-solid fa-pen-to-square"></i></button>
                                        <button class="icon-btn" aria-label="삭제"><i
                                                class="fa-regular fa-trash-can"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>2025.07.20</td>
                                    <td>18:00</td>
                                    <td>75점</td>
                                    <td class="actions">
                                        <button class="icon-btn" aria-label="등록"><i
                                                class="fa-solid fa-pen-to-square"></i></button>
                                        <button class="icon-btn" aria-label="삭제"><i
                                                class="fa-regular fa-trash-can"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>4</td>
                                    <td>2025.09.17</td>
                                    <td>13:00</td>
                                    <td>75점</td>
                                    <td class="actions">
                                        <button class="icon-btn" aria-label="등록"><i
                                                class="fa-solid fa-pen-to-square"></i></button>
                                        <button class="icon-btn" aria-label="삭제"><i
                                                class="fa-regular fa-trash-can"></i></button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>5</td>
                                    <td>2025.11.06</td>
                                    <td>20:00</td>
                                    <td>75점</td>
                                    <td class="actions">
                                        <button class="icon-btn" aria-label="등록"><i
                                                class="fa-solid fa-pen-to-square"></i></button>
                                        <button class="icon-btn" aria-label="삭제"><i
                                                class="fa-regular fa-trash-can"></i></button>
                                    </td>
                                </tr>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="5">
                                        <div class="pagination">
                                            <button class="page nav prev" type="button"><span>←</span> 이전</button>
                                            <button class="page active" type="button">1</button>
                                            <button class="page" type="button">2</button>
                                            <button class="page" type="button">3</button>
                                            <span class="ellipsis">…</span>
                                            <button class="page" type="button">12</button>
                                            <button class="page" type="button">13</button>
                                            <button class="page nav next" type="button">다음 <span>→</span></button>
                                        </div>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </section>

                    <hr class="section-divider">
                </div>
                <!-- //main-box1 -->

                <!-- main-box2 -->
                <div class="main-box2">
                    <!-- 날짜 알약: 정확히 가운데 -->
                    <div class="date-row">
                        <div class="pill pill--date">2025년 7월 25일</div>
                    </div>

                    <div class="inbody-card-wrap">
                        <!-- 카드 밖 우상단 (겹치지 않게) -->
                        <button class="btn-floating">
                            <i class="fa-solid fa-chart-pie"></i> 인바디 등록
                        </button>

                        <section class="card inbody-card">
                            <div class="inbody-detail">
                                <!-- 좌: 스캔 -->
                                <div class="inbody-scan">InBody 스캔 이미지</div>

                                <!-- 우: 패널 -->
                                <div class="inbody-panel">
                                    <!-- 상단 라벨(좌/우) -->
                                    <div class="panel-head">
                                        <span class="label-pill pill-sky">골격근 · 지방분석(C-I-D그래프)</span>
                                        <span class="label-pill pill-rose">내장지방레벨(안전기준 레벨9 이하)</span>
                                    </div>

                                    <!-- 좌: C/I/D 라디오 · 우: 레벨 -->
                                    <div class="options-row">
                                        <div class="option-group radios-compact">
                                            <label class="radio sm"><input type="radio" name="type" checked>C형
                                                <span></span></label>
                                            <label class="radio sm disabled"><input type="radio" name="type" disabled>I형
                                                <span></span></label>
                                            <label class="radio sm disabled"><input type="radio" name="type" disabled>D형
                                                <span></span></label>
                                        </div>
                                        <div class="option-group right"><span class="opt">레벨 : ??</span></div>
                                    </div>

                                    <!-- 2열 지표 -->
                                    <div class="grid-2 tight">
                                        <!-- 핵심지표 -->
                                        <div class="metric-box no-outline">
                                            <span class="label-pill pill-salmon">핵심지표</span>

                                            <div class="metric mg-top">
                                                <div class="metric-name">체지방률</div>
                                                <div class="progress progress-pink thin">
                                                    <span class="progress-fill w-37"></span>
                                                </div>
                                                <div class="metric-value red">37.2%</div>
                                            </div>

                                            <div class="metric">
                                                <div class="metric-name">체중조절</div>
                                                <div class="metric-pair bold">
                                                    <span class="blue">지방 -10.1(kg)</span>
                                                    <span class="red">근육 +2.7(kg)</span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- 부위별 근육분석 -->
                                        <div class="metric-box no-outline">
                                            <span class="label-pill pill-sky">부위별 근육분석</span>

                                            <div class="metric">
                                                <div class="status-line">
                                                    <span class="status-text">상하체 불균형</span>
                                                    <span class="dot sm on"></span>
                                                </div>
                                            </div>

                                            <div class="metric">
                                                <div class="status-line">
                                                    <span class="status-text muted">좌우 불균형</span>
                                                    <span class="dot sm"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- /grid-2 -->
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
                <!-- //main-box2 -->

                <!-- main-box3 -->
                <div class="main-box3">
                    <!-- 상단 알약형 라벨 -->
                    <div class="calorie-row">
                        <div class="calorie-pill">
                            <span>목표칼로리</span>
                            <strong>1232.8kcal</strong>
                        </div>
                    </div>

                    <div class="mb3-body">
                        <!-- 상단 2열 -->
                        <div class="mb3-row mb3-row-top">
                            <!-- 좌: 일일 단백질 섭취량 -->
                            <section class="mb3-card mb3-card-sm">
                                <h4 class="mb3-title">일일 단백질 섭취량</h4>
                                <div class="mb3-metrics">
                                    <div class="metric-line">
                                        <span class="m-label">현재체중 (kg)</span>
                                        <span class="m-value blue">52.3</span>
                                    </div>
                                    <div class="metric-line">
                                        <span class="m-label">
                                            순수필요단백질(g)
                                            <small class="m-label-sub">(체중*00)</small>
                                        </span>
                                        <span class="m-value blue">94.1</span>
                                    </div>
                                </div>
                            </section>

                            <!-- 우: 탄수화물 · 단백질 · 지방 -->
                            <section class="mb3-card">
                                <h4 class="mb3-title">탄수화물 · 단백질 · 지방</h4>
                                <table class="mb3-table macros">
                                    <thead>
                                        <tr>
                                            <th>항목</th>
                                            <th>탄수화물</th>
                                            <th>단백질</th>
                                            <th>지방</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>비율(5:3:2)</td>
                                            <td>50.0</td>
                                            <td>20.0</td>
                                            <td>30.0</td>
                                        </tr>
                                        <tr>
                                            <td>필요칼로리 (kcal)</td>
                                            <td>614.4</td>
                                            <td>376.56</td>
                                            <td>256.56</td>
                                        </tr>
                                        <tr>
                                            <td>순수필요무게 (g)</td>
                                            <td>160.35</td>
                                            <td>94.14</td>
                                            <td>28.5</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </section>
                        </div>

                        <!-- 하단: 일일식단 -->
                        <div class="mb3-row">
                            <section class="mb3-card mb3-card-full">
                                <h4 class="mb3-title">일일식단</h4>
                                <table class="mb3-table meals">
                                    <thead>
                                        <tr>
                                            <th>시간</th>
                                            <th>칼로리(kcal)</th>
                                            <th>탄수화물(g)</th>
                                            <th>단백질(g)</th>
                                            <th>지방(g)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>아침</td>
                                            <td>73.5</td>
                                            <td>21.5</td>
                                            <td>2</td>
                                            <td>0</td>
                                        </tr>
                                        <tr>
                                            <td>점심</td>
                                            <td>232.0</td>
                                            <td>46.9</td>
                                            <td>8</td>
                                            <td>5</td>
                                        </tr>
                                        <tr>
                                            <td>저녁</td>
                                            <td>802.0</td>
                                            <td>78.1</td>
                                            <td>40</td>
                                            <td>9.6</td>
                                        </tr>
                                    </tbody>
                                    <tfoot>
                                        <tr class="sum">
                                            <td>총합</td>
                                            <td>1107.5</td>
                                            <td>146.5</td>
                                            <td>50.0</td>
                                            <td>14.6</td>
                                        </tr>
                                        <tr class="goal">
                                            <td>칼로리합</td>
                                            <td></td>
                                            <td>153.6</td>
                                            <td>69.1</td>
                                            <td>28.5</td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </section>
                        </div>
                    </div>
                </div>
                <!-- //main-box3 -->
            </main>
        </div>

        <footer>
            <p>Copyright © 2025. FitLink All rights reserved.</p>
        </footer>
    </div>
</body>

</html>