<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Workout Log - FitLink</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/include.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/trainer.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/form_trainer.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
<script src="${pageContext.request.contextPath}/assets/js/jquery/jquery-3.7.1.js"></script>
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
		            <!-- 트레이너일 경우, currentMember 유무로 어떤 aside를 보여줄지 결정 -->
		            <c:choose>
		                <c:when test="${not empty currentMember}">
		                    <c:import url="/WEB-INF/views/include/aside-trainer-member.jsp"></c:import>
		                </c:when>
		                <c:otherwise>
		                    <c:import url="/WEB-INF/views/include/aside-trainer.jsp"></c:import>
		                </c:otherwise>
		            </c:choose>
		        </c:when>
		        <c:otherwise>
		            <!-- 회원이면 무조건 회원용 aside -->
		            <c:import url="/WEB-INF/views/include/aside-member.jsp"></c:import>
		        </c:otherwise>
		    </c:choose>
			<!-- //------aside------ -->

			<c:choose>
		        <c:when test="${not empty currentMember}">
		            <form action="${pageContext.request.contextPath}/exercise/update-member/member/${currentMember.userId}" method="post" style="display: flex; flex: 1;">
		        </c:when>
		        <c:otherwise>
		            <form action="${pageContext.request.contextPath}/exercise/update-member" method="post" style="display: flex; flex: 1;">
		        </c:otherwise>
	    	</c:choose>
				<main>
					<!-- 1. 제목 -->
					<div class="page-header">
						<h3 class="page-title">Exercise</h3>
					</div>
					<!-- //1. 제목 -->
	
					<!-- 2. 운동 종류 탭 -->
					<div class="category-tabs">
						<c:forEach items="${exerciseData.bodyPartTabs}" var="tab">
							<c:choose>
		                        <c:when test="${not empty currentMember}">
		                             <a href="${pageContext.request.contextPath}/exercise/list-member/member/${currentMember.userId}?bodyPart=${tab}" class="tab <c:if test='${exerciseData.currentBodyPart == tab}'>active</c:if>">${tab}</a>
		                        </c:when>
		                        <c:otherwise>
		                            <a href="${pageContext.request.contextPath}/exercise/list-member?bodyPart=${tab}" class="tab <c:if test='${exerciseData.currentBodyPart == tab}'>active</c:if>">${tab}</a>
		                        </c:otherwise>
		                    </c:choose>
						</c:forEach>
					</div>
					<!-- //2. 운동 종류 탭 -->
	
					<!-- 3.버튼 -->
					<div class="category-buttons">
						<button type="button" id="btn-open-modal" class="category-btn">
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
						<!-- 기본 운동 리스트 -->
						<ul class="checkbox-grid">
							
							<c:forEach items="${exerciseData.systemExerciseList}" var="systemExercise">
								<li>
									<label>
										<!-- 체크박스에 name과 value를 추가하여 선택된 값을 서버로 보낼 수 있도록 함 -->
										<input type="checkbox" name="exerciseIds" value="${systemExercise.exerciseId}" <c:if test="${systemExercise.checked}">checked</c:if> >
										<span class="custom-checkbox"></span>
										${systemExercise.exerciseName}
									</label>
								</li>
							</c:forEach>
							
						</ul>
						
						<br><hr>
						<div class="custom-exercise-separator">
								<span style="font-weight: 700;">사용자 추가 운동</span>
						</div>
						<br>
						<!-- 사용자 추가 운동 리스트가 있을 경우에만 구분선과 함께 표시 -->
						<c:if test="${not empty exerciseData.customExerciseList}">
						
							
							
							<ul class="checkbox-grid">
								<c:forEach items="${exerciseData.customExerciseList}" var="customExercise">
									<li>
										<label>
											<input type="checkbox" name="exerciseIds" value="${customExercise.exerciseId}" <c:if test="${customExercise.checked}">checked</c:if> >
											<span class="custom-checkbox"></span>
											${customExercise.exerciseName}
											
											<!-- 삭제버튼 -->
											<button type="button" class="btn-delete-exercise" data-exercise-id="${customExercise.exerciseId}">
												<i class="fa-solid fa-xmark"></i>
											</button>
										</label>
									</li>
								</c:forEach>
							</ul>
						</c:if>
						
						<!-- 두 리스트가 모두 비어있을 경우에만 메시지 표시 -->
						<c:if test="${empty exerciseData.systemExerciseList and empty exerciseData.customExerciseList}">
							<div class="no-data-large">등록된 운동이 없습니다.<br>운동을 추가해주세요.</div>
						</c:if>
						
						
						
					</section>
					<!-- //6.운동종류 리스트 -->
				</main>
			</form>
		</div>
		
		<!-- <footer> -->
		<c:import url="/WEB-INF/views/include/footer.jsp"></c:import>
		<!--// <footer> -->
	</div>
	
	<%-- ================================================================= --%>
    <%-- [추가] 운동 등록 모달창 HTML                                        --%>
    <%-- ================================================================= --%>
    <div class="modal-overlay" id="add-exercise-modal" style="display: none; position: fixed;">
        <div class="modal-container">
            <div class="modal-header">
                <h2 class="modal-title">운동종류 등록</h2>
                <button type="button" class="modal-close-btn">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
            <div class="modal-body">
                <form id="form-add-exercise" class="register-form">
                    <div class="form-group">
                        <label for="modal-exercise-type">운동부위</label>
                        <select id="modal-exercise-type" name="bodyPart">
                            <c:forEach items="${exerciseData.bodyPartTabs}" var="tab">
                                <option value="${tab}">${tab}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="modal-exercise-name">이름</label>
                        <input type="text" id="modal-exercise-name" name="exerciseName" />
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="submit" form="form-add-exercise" class="submit-btn">저장</button>
            </div>
        </div>
    </div>
    
    
    <script>
    $(document).ready(function() {
    	
    	// 현재 보고 있는 회원 ID를 저장 (없으면 0)
    	const currentMemberId = Number("${currentMember.userId}" || 0);
    	
    	let $modal = $("#add-exercise-modal");

        // '운동종류 등록' 버튼 클릭 시 모달 열기
        $("#btn-open-modal").on("click", function() {
        	let currentPart = "${exerciseData.currentBodyPart}";
            $modal.find("#modal-exercise-type").val(currentPart);
            $modal.css("display", "flex");
        });

        // 모달의 닫기(X) 버튼 클릭 시 모달 닫기
        $modal.find(".modal-close-btn").on("click", function() {
            $modal.hide();
        });

        // 모달의 '저장' 버튼 클릭 시 (form 전송 이벤트)
        $("#form-add-exercise").on("submit", function(e) {
            e.preventDefault(); 

            let bodyPart = $("#modal-exercise-type").val();
            let exerciseName = $("#modal-exercise-name").val().trim();

            if (!exerciseName) {
                alert("운동 이름을 입력해주세요.");
                return;
            }

            let exerciseData = {
                bodyPart: bodyPart,
                exerciseName: exerciseName
            };

            $.ajax({
                url: "${pageContext.request.contextPath}/api/exercise/add",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(exerciseData),
                dataType: "json",
                success: function(jsonResult) {
                    if (jsonResult.result === "success") {
                        alert("운동이 성공적으로 등록되었습니다.");
                        
                     	// 현재 상황에 맞는 URL을 동적으로 생성
                        let redirectUrl = "";
                        let bodyPart = $("#modal-exercise-type").val();
                        
                        if (currentMemberId > 0) {
                            // 트레이너가 회원 페이지를 보고 있을 때
                            redirectUrl = "${pageContext.request.contextPath}/exercise/list-member/member/" + currentMemberId + "?bodyPart=" + bodyPart;
                        } else {
                            // 회원 본인 페이지일 때
                            redirectUrl = "${pageContext.request.contextPath}/exercise/list-member?bodyPart=" + bodyPart;
                        }
                        
                        location.href = redirectUrl; // 올바른 주소로 이동
                    } else {
                        alert(jsonResult.message);
                    }
                },
                error: function(xhr, status, error) {
                    console.error("운동 등록 실패:", error);
                    alert("오류가 발생했습니다. 다시 시도해주세요.");
                }
            });
        });
        
        // 사용자 추가 운동 삭제 버튼 클릭 이벤트 
        $(".list-box").on("click", ".btn-delete-exercise", function() {
            // 클릭된 버튼에서 삭제할 운동의 ID를 가져옵니다.
            let exerciseId = $(this).data("exercise-id");
            
            // this를 저장해두면 ajax 내부에서도 현재 클릭한 버튼을 가리킬 수 있음
            let $clickedButton = $(this);

            // 사용자에게 정말 삭제할 것인지 다시 한번 확인
            if (confirm("이 운동을 목록에서 삭제하시겠습니까?")) {
                
                $.ajax({
                    url: "${pageContext.request.contextPath}/api/exercise/delete/" + exerciseId,
                    type: "DELETE", // HTTP 메소드를 'DELETE'로 지정
                    dataType: "json",
                    success: function(jsonResult) {
                        if (jsonResult.result === "success") {
                        	
                        	// '내가 선택한 리스트'에서도 동일한 운동 이름(텍스트)을 가진 항목을 찾아 제거
                        	// 체크박스 리스트에서 해당 항목 제거
                        	$clickedButton.closest("li").fadeOut(300, function() {
                                $(this).remove();
                            });
                        	
                        	// 삭제된 운동의 이름을 가져옴
                            let exerciseName = $clickedButton.closest("label").text().trim();
                        	
                        	// 내가 선택한 리스트(`.select-box ul`) 안을 순회하면서
                            $(".select-box .category-grid li").each(function() {
                                // 리스트 항목의 텍스트와 삭제된 운동의 이름이 같으면
                                if ($(this).text().trim() === exerciseName) {
                                    // 해당 항목을 화면에서 제거
                                    $(this).remove();
                                }
                            });
                        } else {
                            // 실패 시, 서버가 보낸 실패 메시지를 alert 창으로 보여줌
                            alert(jsonResult.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("운동 삭제 실패:", error);
                        alert("삭제 중 오류가 발생했습니다. 다시 시도해주세요.");
                    }
                });
            }
        });
        
     	// ========================================================================
        // [추가] 벤치프레스, 데드리프트, 스쿼트 항상 체크되도록 하는 코드
        // ========================================================================
        $("input[type='checkbox'][name='exerciseIds']").each(function() {
            // label 태그의 텍스트를 가져와서 앞뒤 공백을 제거합니다.
            var exerciseName = $(this).closest("label").text().trim();
            
            // 운동 이름이 "벤치프레스", "데드리프트", "스쿼트" 중 하나와 일치하는지 확인합니다.
            if (exerciseName === "벤치프레스" || exerciseName === "데드리프트" || exerciseName === "스쿼트") {
                // 일치하면 해당 체크박스를 체크 상태로 만듭니다.
                $(this).prop("checked", true);
            }
        });
    });
    </script>
</body>
</html>