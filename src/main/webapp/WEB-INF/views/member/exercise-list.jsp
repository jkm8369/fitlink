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

			<form action="${pageContext.request.contextPath}/exercise/update-member" method="post" style="display: flex; flex: 1;">
				<main>
					<!-- 1. 제목 -->
					<div class="page-header">
						<h3 class="page-title">Exercise</h3>
					</div>
					<!-- //1. 제목 -->
	
					<!-- 2. 운동 종류 탭 -->
					<div class="category-tabs">
						<c:forEach items="${exerciseData.bodyPartTabs}" var="tab">
							<a href="${pageContext.request.contextPath}/exercise/list-member?bodyPart=${tab}"
								class="tab <c:if test="${exerciseData.currentBodyPart == tab}">active</c:if>">
								${tab}
							</a>
						</c:forEach>
					</div>
					<!-- //2. 운동 종류 탭 -->
	
					<!-- 3.버튼 -->
					<div class="category-buttons">
						<button class="category-btn">
							<i class="fa-solid fa-plus"></i> 운동종류 등록
						</button>
						<button type="submit" class="category-btn">
							<i class="fa-solid fa-check"></i> 저장
						</button>
					</div>
					<!-- ..3.버튼 -->
	
					<!-- 4.선택부위 -->
					<h4 class="category-title">${exerciseData.currentBodyPart}</h4>
					<!-- //4.선택부위 -->
	
					<!-- 현재 보고 있는 부위 이름을 함께 전송하기 위한 hidden input --> 
                    <input type="hidden" name="bodyPart" value="${exerciseData.currentBodyPart}">
	
					<!-- 5.내가 선택한 리스트 -->
					<section class="select-box">
						<p>내가 선택한 리스트</p>
						<ul class="category-grid">
							<c:forEach items="${exerciseData.myExerciseList}" var="myExercise">
								<li>${myExercise.exerciseName}</li>
							</c:forEach>
							<c:if test="${empty exerciseData.myExerciseList}">
								<li class="no-data-small"><p>선택한 운동이 없습니다.<br>운동을 추가해주세요.</p></li>
							</c:if>
						</ul>
					</section>
					<!-- //5.내가 선택한 리스트 -->
	
					<!-- 6.운동종류 리스트 -->
					<section class="list-box">
						<ul class="checkbox-grid">
							
							<c:forEach items="${exerciseData.allExerciseList}" var="allExercise">
								<li>
									<label>
										<!-- 체크박스에 name과 value를 추가하여 선택된 값을 서버로 보낼 수 있도록 함 -->
										<input type="checkbox" name="exerciseIds" value="${allExercise.exerciseId}" <c:if test="${allExercise.checked}">checked</c:if> >
										<span class="custom-checkbox"></span>
										${allExercise.exerciseName}
									</label>
								</li>
							</c:forEach>
							<c:if test="${empty exerciseData.allExerciseList}">
								<li class="no-data-large">등록된 운동이 없습니다.<br>운동을 추가해주세요.</li>
							</c:if>
							
						</ul>
					</section>
					<!-- //6.운동종류 리스트 -->
				</main>
			</form>
		</div>
		
		<!-- <footer> -->
		<c:import url="/WEB-INF/views/include/footer.jsp"></c:import>
		<!--// <footer> -->
	</div>
</body>
</html>