<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<!-- <meta name="viewport" content="width=device-width, initial-scale=1"> -->
<meta charset="utf-8">
<title>FitLink</title>
<link rel="stylesheet" href="../../assets/css/main.css">
<link rel="stylesheet" href="../../assets/css/reset.css">
</head>
<body>
	<div id="wrap">

		<header class="site-header">
			<div class="header-container">
				<div class="logo-wrapper">
					<img class="logo-img" src="../../assets/images/logo.jpg" alt="핏링크 로고">
				</div>
				<a href="${pageContext.request.contextPath}/user/loginform" class="login-btn"> <span>로그인</span>
				</a>
			</div>
		</header>

		<main class="site-main">

			<section class="hero-section">
				<img class="hero-icon" src="../../assets/images/overlay.jpg" alt="하늘색 역기 사진">
				<h1 class="hero-title">Fit - Link</h1>
				<p class="hero-subtitle">트레이너와 회원을 위한 종합 관리 플랫폼으로 효율적인 PT 관리를 경험하세요</p>
				<a href="#" class="cta-button primary-button">가입하기</a>
				
			</section>

			<section class="service-intro">
				<h2 class="section-title">서비스 소개</h2>
				<p class="section-subtitle">회원과 트레이너 모두를 위한 맞춤형 기능을 제공합니다</p>

				<div class="service-card-container">
					<article class="service-card">
						<img class="card-icon" src="../../assets/images/overlay2.jpg" alt="파란색 역기사진">
						<div class="card-header">
							<h3 class="card-title">회원용 기능</h3>
							<p class="card-subtitle">개인 운동 관리와 트레이너와의 소통을 위한 기능</p>
						</div>
						<ul class="feature-list">
							<li class="feature-item">
								<h4 class="feature-title">PT 일정 예약 및 관리</h4>
								<p class="feature-description">
									원하는 시간에 트레이너와의 개인 트레이닝을<br />예약하고, 일정을 체계적으로 관리할 수 있습니다.<br />실시간 예약 확인과 변경이 가능합니다.
								</p>
							</li>
							<li class="feature-item">
								<h4 class="feature-title">운동 기록 및 진도 추적</h4>
								<p class="feature-description">
									매일의 운동 성과를 기록하고 시각적 차트로 진도를<br />확인하세요. 체중, 근육량, 운동량 등 다양한 지표를<br />추적할 수 있습니다.
								</p>
							</li>
						</ul>
					</article>

					<article class="service-card">
						<img class="card-icon" src="../../assets/images/overlay2.jpg" alt="파란색 역기사진">
						<div class="card-header">
							<h3 class="card-title">트레이너용 기능</h3>
							<p class="card-subtitle text-gray">효율적인 회원 관리와 일정 관리를 위한 기능</p>
						</div>
						<ul class="feature-list">
							<li class="feature-item">
								<h4 class="feature-title">PT 스케줄 및 가능시간 관리</h4>
								<p class="feature-description text-dark">
									트레이너의 가능한 시간을 설정하고 회원들의 예약 요청을 체계적으로 관리하세요.<br />효율적인 스케줄링으로 시간을 최적화할 수 있습니다.
								</p>
							</li>
							<li class="feature-item">
								<h4 class="feature-title">회원 정보 및 운동 계획 관리</h4>
								<p class="feature-description text-dark">
									각 회원의 목표, 체력 수준, 건강 상태를 파악하고<br />맞춤형 운동 계획을 수립하여 관리할 수 있습니다.<br />개인별 특성을 고려한 전문적인 지도가 가능합니다.
								</p>
							</li>
							<li class="feature-item">
								<h4 class="feature-title">회원별 진도 및 성과 분석</h4>
								<p class="feature-description text-dark">
									회원들의 운동 성과를 데이터로 분석하고 시각적<br />리포트로 확인하세요. 목표 달성률과 개선 방향을<br />한눈에 파악할 수 있습니다.
								</p>
							</li>
						</ul>
					</article>
				</div>
			</section>

			<section class="detailed-features">
				<h2 class="section-title">상세 기능 소개</h2>
				<p class="section-subtitle">FitLink의 핵심 기능들을 자세히 알아보세요</p>

				<div class="feature-card-container">
					<article class="feature-card" id="schedule-management">
						<h3 class="feature-card-title">스마트 일정 관리</h3>
						<p class="feature-card-description">
							실시간 예약 시스템으로 트레이너와 회원<br>모두 편리하게 일정을 관리할 수 있습니다. <br>자동 알림과 일정 변경 기능으로 효율적인<br>PT 관리를 경험하세요.
						</p>
						<ul class="checklist">
							<li class="check-item">실시간 예약 확인 및 변경</li>
							<li class="check-item">자동 알림 및 리마인더</li>
							<li class="check-item">월별/주별 캘린더 뷰</li>
						</ul>
					</article>

					<article class="feature-card" id="progress-analysis">
						<h3 class="feature-card-title">진도 및 성과 분석</h3>
						<p class="feature-card-description">
							운동 기록을 시각적 차트로 확인하고 목표<br />달성도를 추적하세요. 데이터 기반의 개인<br />맞춤형 운동 계획으로 더 나은 결과를 얻을 수<br />있습니다.
						</p>
						<ul class="checklist">
							<li class="check-item">체중, 근육량, 체지방률 추적</li>
							<li class="check-item">운동량 및 칼로리 소모 기록</li>
							<li class="check-item">목표 달성률 시각화</li>
						</ul>
					</article>

					<article class="feature-card" id="member-management">
						<h3 class="feature-card-title wide-title">전문적인 회원 관리</h3>
						<p class="feature-card-description">
							트레이너를 위한 포괄적인 회원 관리 시스템<br />입니다. 각 회원의 특성을 파악하고 맞춤형 운동 계획을 수립하여 최적의 결과를 제공하세요.
						</p>
						<ul class="checklist">
							<li class="check-item">개인별 운동 목표 설정</li>
							<li class="check-item">건강 상태 및 체력 수준 기록</li>
							<li class="check-item">맞춤형 운동 프로그램 생성</li>
						</ul>
					</article>
				</div>

				<div class="feature-image-overlays">
					<div class="overlay-image" id="schedule-overlay">
						<span>일정 관리 인터페이스</span>
					</div>
					<div class="overlay-image" id="progress-overlay">
						<span>진도 분석 대시보드</span>
					</div>
					<div class="overlay-image" id="member-overlay">
						<span>회원 관리 시스템</span>
					</div>
				</div>
			</section>

			<section class="cta-section">
				<h2 class="cta-title">지금 바로 시작하세요</h2>
				<p class="cta-subtitle">회원과 트레이너 모두에게 최적화된 PT 관리 시스템으로 더 나은 운동 경험을 만들어보세요</p>
				<a href="#" class="cta-button secondary-button">가입하기</a>
			</section>

		</main>

		<footer class="site-footer">
			<p>Copyright © 2025. FitLink All rights reserved.</p>
		</footer>

	</div>
</body>
</html>