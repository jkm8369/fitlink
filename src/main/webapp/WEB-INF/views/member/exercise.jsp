<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>



<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Workout Log - FitLink</title>
<link rel="stylesheet" href="../../assets/css/reset.css" />
<link rel="stylesheet" href="../../assets/css/include.css" />
<link rel="stylesheet" href="../../assets/css/trainer.css" />
<link rel="stylesheet" href="../../assets/css/member.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
</head>

<body>
	<div id="wrap">

		<!-- ------헤더------ -->
		<c:import url="/WEB-INF/views/include/header.jsp"></c:import>
		<!-- //------헤더------ -->

		<!-- --aside + main-- -->
		<div id="content">
			<!-- ------aside------ -->
			<c:choose>
				<c:when test="${sessionScope.authUser.role == 'trainer'}">
					<c:import url="/WEB-INF/views/include/aside-trainer.jsp"></c:import>
				</c:when>
				<c:otherwise>
					<c:import url="/WEB-INF/views/include/aside-member.jsp"></c:import>
				</c:otherwise>
			</c:choose>
			<!-- //------aside------ -->

			<main>
				<!-- 1. 제목 -->
				<div class="page-header">
					<h3 class="page-title">Exercise</h3>
				</div>
				<!-- //1. 제목 -->

				<!-- 2. 운동 종류 리스트-->
				<div class="exercise-container">
					<div class="exercise-header">
						<a href="${pageContext.request.contextPath}/exercise/list-member" class="btn-edit-exercises"> <i class="fa-solid fa-scissors"></i> <span>운동종류
								수정</span>
						</a>
					</div>

					<c:forEach items="${exerciseMap}" var="emap">
						<section class="exercise-category">
							<h4 class="category-title">${emap.key}</h4>
							<ul class="exercise-grid">
								<c:forEach items="${emap.value}" var="exercise">
									<li class="exercise-item">${exercise.exerciseName}</li>
								</c:forEach>
							</ul>
						</section>
					</c:forEach>

					<c:if test="${empty exerciseMap}">
						<div class="no-data-message">
							<p>등록된 운동이 없습니다.</p>
							<br>
							<br>
							<p>'운동종류 수정' 버튼을 눌러 운동을 추가해주세요.</p>
						</div>
					</c:if>

				</div>
				<!-- 2. 운동 종류 리스트-->
			</main>
		</div>

		<!-- <footer> -->
		<c:import url="/WEB-INF/views/include/footer.jsp"></c:import>
		<!--// <footer> -->
	</div>
</body>

</html>