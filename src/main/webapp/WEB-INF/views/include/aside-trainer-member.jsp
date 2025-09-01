<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<aside>
	<div class="user-info">
		<div class="user-name-wrap">
			<img class="dumbell-icon" src="${pageContext.request.contextPath}/assets/images/사이트로고.jpg" alt="dumbell-icon">
			<p class="user-name">

				<!-- 이름 동적 표시, currentMember는 현재 보고 있는 회원 정보 -->
				<c:choose>
					<c:when test="${not empty currentMember}">
        				${currentMember.userName}<br>
						<small>(회원)</small>
					</c:when>

					<c:otherwise>
        				${sessionScope.authUser.userName}<br>
						<small>(트레이너)</small>
					</c:otherwise>
				</c:choose>
			</p>
		</div>
		
        <div class="trainer-info">
	        <i class="fa-solid fa-clipboard-user"></i>
      		<span>Trainer → Member</span>
        </div>
	</div>

	<div class="aside-menu">
		<%-- 
          현재 보고 있는 회원이 있으면
          모든 메뉴의 링크를 '/.../member/회원ID' 형태로 동적으로 생성합니다.
          보고 있는 회원이 없으면, 트레이너의 기본 페이지(회원 목록)로 가는 링크를 보여줍니다.
        --%>
        <c:choose>
        	<c:when test="${not empty currentMember}">
        		<a href="${pageContext.request.contextPath}/workout/member/${currentMember.userId}" class="menu-item">
            	<i class="fa-solid fa-book"></i>
            	<span>운동일지</span>
        		</a>
        		
		        <a href="${pageContext.request.contextPath}/inbody/member/${currentMember.userId}" class="menu-item">
		            <i class="fa-solid fa-chart-pie"></i>
		            <span>InBody & Meal</span>
		        </a>
		        
		        <a href="${pageContext.request.contextPath}/trainer/photo/${currentMember.userId}" class="menu-item">
		            <i class="fa-solid fa-images"></i>
		            <span>사진</span>
		        </a>
		        
		        <a href="${pageContext.request.contextPath}/exercise/member/${currentMember.userId}" class="menu-item"> 
		            <i class="fa-solid fa-list-ul"></i>
		            <span>운동종류</span>
        		</a>
        	</c:when>
        	
        	<c:otherwise>
        		<!-- 기본 메뉴(회원 목록 페이지로 이동) -->
        		<a href="${pageContext.request.contextPath}/trainer/members" class="menu-item">
                    <i class="fa-solid fa-address-card"></i>
                    <span>회원 목록</span>
                </a>
        	</c:otherwise>
        </c:choose>
		
	</div>
</aside>