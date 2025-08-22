<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>예약현황</title>

<!-- 기본 리셋/공용 스타일 -->
<link rel="stylesheet" href="../../assets/css/reset.css" />
<link rel="stylesheet" href="../../assets/css/include.css" />

<!-- member 전용 스타일 (예약/멤버 관련) -->
<link rel="stylesheet" href="../../assets/css/member.css" />

<!-- 트레이너/페이지 커스텀 스타일 (오버라이드 포함해서 가장 뒤쪽에) -->
<link rel="stylesheet" href="../../assets/css/trainer.css" />
<link rel="stylesheet" href="../../assets/css/schedule_modal.css" />

<!-- 아이콘 (폰트어썸) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

</head>

<body>
	<div id="wrap">
		<!-- ------헤더------ -->
		<header>
			<!-- 왼쪽: 이미지 로고 (변경됨) -->
			<a href="" class="btn-logout"> <!-- 여기에 실제 로고 이미지 파일을 연결하세요 --> <img src="../../../../project/front/assets/images/logo.jpg" alt="FitLnk Logo" />
			</a>

			<!-- 오른쪽: 사용자 메뉴 -->
			<div class="btn-logout">
				<a href="#" class="logout-link"> <i class="fa-solid fa-right-from-bracket"></i> 로그아웃
				</a>
			</div>
		</header>

		<!-- --aside + main-- -->
		<div id="content">
			<aside>
				<div class="user-info">
					<div class="user-name-wrap">
						<img class="dumbell-icon" src="../../assets/images/사이트로고.jpg" alt="dumbell-icon" />
						<p class="user-name">
							홍길동<br /> <small>(회원)</small>
						</p>
					</div>
					<div class="trainer-info">
						<i class="fa-solid fa-clipboard-user"></i> <span>1 Trainer</span>
					</div>
				</div>
				<div class="aside-menu">
					<a href="#" class="menu-item"> <i class="fa-solid fa-book"></i> <span>운동일지</span>
					</a> <a href="#" class="menu-item"> <i class="fa-solid fa-chart-pie"></i> <span>InBody & Meal</span>
					</a> <a href="#" class="menu-item"> <i class="fa-solid fa-images"></i> <span>사진</span>
					</a> <a href="#" class="menu-item"> <i class="fa-solid fa-calendar-check"></i> <span>예약현황</span>
					</a> <a href="#" class="menu-item"> <i class="fa-solid fa-list-ul"></i> <span>운동종류</span>
					</a>
				</div>
			</aside>

			<main>
				<!-- 1. 제목 -->
				<div class="page-header">
					<h3 class="page-title">Booking Status</h3>
				</div>
				<!-- //1. 제목 -->

				<!-- 2. 달력 -->
				<div class="calendar-card">
					<!-- FullCalendar가 내부에 DOM을 생성하여 출력 -->
					<div id="calendar"></div>
				</div>
				<!-- //2. 달력 -->

				<!-- 3. 구분선 -->
				<div class="line"></div>
				<!-- //3. 구분선 -->

				<section class="card2 list-card">
					<div class="card-header">
						<h4 class="card-title list-title">PT 리스트</h4>
					</div>

					<div class="table-wrap">
						<table class="table">
							<colgroup>
								<col class="w-60">
								<!-- 순서 -->
								<col class="w-110">
								<!-- 날짜 -->
								<col class="w-90">
								<!-- 시간 -->
								<col class="w-90">
								<!-- 트레이너 (가변) -->
								<col class="w-100">
								<!-- PT 등록일수 -->
								<col class="w-100">
								<!-- PT 수업일수 -->
								<col class="w-100">
								<!-- PT 잔여일수 -->
								<col class="w-80">
								<!-- actions -->
							</colgroup>
							<thead>
								<tr>
									<th>순서</th>
									<th>날짜</th>
									<th>시간</th>
									<th>트레이너</th>
									<th>PT 등록일수</th>
									<th>PT 수업일수</th>
									<th>PT 잔여일수</th>
									<th class="actions-head"></th>
								</tr>
							</thead>
							<tbody>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td>회</td>
										<td>회</td>

										<!-- ② 24시간 전까지만 취소 버튼 보이기 -->
										<td class="actions"><c:if test="${startDt.time - now.time >= MILLIS_24H}">
												<button type="button" class="icon-btn js-cancel" data-id="${row.no}" aria-label="취소">
													<i class="fa-solid fa-xmark"></i>
												</button>
											</c:if></td>
									<tr>
										<td class="pt-list-empty" colspan="8">예약이 없습니다.</td>
									</tr>
							</tbody>
						</table>
					</div>
				</section>
				<!-- //4. 회원수업 리스트 섹션 -->
			</main>
		</div>

		<footer>
			<p>Copyright © 2025. FitLink All rights reserved.</p>
		</footer>

	</div>
</body>
</html>