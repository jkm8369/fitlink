<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>MemberList - FitLink</title>

<!-- 기본 리셋/공용 스타일 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/include.css" />

<!-- member 전용 스타일 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member.css" />

<!-- 트레이너/페이지 커스텀 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/trainer.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modal.css" />

<!-- 아이콘 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>


<body>
  <div id="wrap">
    <!-- ------헤더------ -->
    <c:import url="/WEB-INF/views/include/header.jsp"></c:import>
    <!-- //------헤더------ -->

    <div id="content">
      <!-- ------aside------ -->
      <aside>
        <div class="user-info">
          <c:import url="/WEB-INF/views/include/aside-trainer.jsp"></c:import>
        </div>
      </aside>
      <!-- ------aside------ -->

      <!-- trainerId를 JS에서 편하게 쓰도록 data-attr로도 노출 -->
      <main id="member-list" data-trainer-id="${trainerId}">
        <!-- 제목 -->
        <div class="page-header">
          <h3 class="page-title">Members</h3>
        </div>

        <!-- 회원 리스트 -->
        <div class="list-area">
          <section class="card list-card">
            <div class="card-header">
              <h4 class="card-title list-title">회원 리스트</h4>
            </div>

            <table class="table">
              <colgroup>
                <col class="w-60"><!-- 순서 -->
                <col class="w-60"><!-- 이름 -->
                <col class="w-80"><!-- 생년월일 -->
                <col class="w-70"><!-- 직업 -->
                <col class="w-100"><!-- 상담일 -->
                <col class="w-90"><!-- 운동목적 -->
                <col class="w-110"><!-- PT 등록일수 -->
                <col class="w-110"><!-- PT 수업일수 -->
                <col class="w-40"><!-- PT 잔여일수 -->
                <col class="w-100"><!-- 액션 -->
              </colgroup>

              <thead>
                <tr>
                  <th class="w-90">순서</th>
                  <th>이름</th>
                  <th>생년월일</th>
                  <th>직업</th>
                  <th>상담일</th>
                  <th>운동목적</th>
                  <th class="nowrap">PT 등록일수</th>
                  <th class="nowrap">PT 수업일수</th>
                  <th class="nowrap">PT 잔여일수</th>
                  <th class="actions-head"></th>
                </tr>
              </thead>

              <tbody>
                <!-- rows 반복 -->
                <c:forEach var="row" items="${rows}" varStatus="st">
                  <tr data-member-id="${row.memberId}">
                    <td><c:out value="${st.index + 1}"/></td>

                    <td>
                      <a href="#" class="link-member" data-member-id="${row.memberId}">
                        <c:out value="${row.memberName}"/>
                      </a>
                    </td>

                    <!-- 생년월일 -->
                    <td>
					  <c:choose>
					    <c:when test="${empty row.birth}">-</c:when>
					    <c:otherwise>${row.birth}</c:otherwise>
					  </c:choose>
				      <input type="hidden" id="birth" value="${row.birth}" />
					</td>

                    <!-- 직업 -->
                    <td>
                      <c:choose>
                        <c:when test="${empty row.job}">-</c:when>
                        <c:otherwise>${row.job}</c:otherwise>
                      </c:choose>
                    </td>

                    <!-- 상담일 -->
                    <td>
                      <c:choose>
                        <c:when test="${empty row.consultDate}">-</c:when>
                        <c:otherwise>${row.consultDate}</c:otherwise>
                      </c:choose>
                    </td>

                    <!-- 운동목적 -->
                    <td class="td-left">
                      <c:choose>
                        <c:when test="${empty row.goal}">-</c:when>
                        <c:otherwise>${row.goal}</c:otherwise>
                      </c:choose>
                    </td>

					<!-- PT 등록일수 -->
					<td>
					  <c:choose>
					    <c:when test="${empty row.ptRegisteredCnt}">0</c:when>
					    <c:otherwise>${row.ptRegisteredCnt}</c:otherwise>
					  </c:choose>
					</td>
					
					<!-- PT 수업일수 -->
					<td>
					  <c:choose>
					    <c:when test="${empty row.ptUsedCnt}">0</c:when>
					    <c:otherwise>${row.ptUsedCnt}</c:otherwise>
					  </c:choose>
					</td>
					
					<!-- PT 잔여일수 -->
					<td>
					  <c:choose>
					    <c:when test="${empty row.ptRemainingCnt}">0</c:when>
					    <c:otherwise>${row.ptRemainingCnt}</c:otherwise>
					  </c:choose>
					</td>


                    <td class="actions">
                      <button class="icon-btn btn-edit"   type="button" aria-label="수정">
                        <i class="fa-solid fa-pen-to-square"></i>
                      </button>
                      <button class="icon-btn btn-delete" type="button" aria-label="삭제">
                        <i class="fa-regular fa-trash-can"></i>
                      </button>
                    </td>
                  </tr>
                </c:forEach>

                <!-- 빈 목록 처리 -->
                <c:if test="${empty rows}">
                  <tr>
                    <td colspan="10" class="muted">담당 회원이 없습니다.</td>
                  </tr>
                </c:if>
              </tbody>
            </table>
          </section>

          <button class="add-member-btn" type="button" id="btn-create">
            <i class="fa-solid fa-address-card"></i><span>회원 등록</span>
          </button>
        </div>
      </main>
    </div>

    <footer>
      <p>Copyright © 2025. FitLink All rights reserved.</p>
    </footer>
  </div>

	<!-- ================= 회원 등록 모달 ================= -->
	<div id="schedule-modal" class="">
	  <div class="modal-container">
	    <!-- 1. 모달 헤더 -->
	    <div class="modal-header">
	      <h2 class="modal-title">회원 등록</h2>
	      <button type="button" class="modal-close-btn" aria-label="닫기">
	        <i class="fa-solid fa-xmark"></i>
	      </button>
	    </div>
	
	    <!-- 2. 모달 바디 -->
	    <div class="modal-body">
	      <form class="register-form" onsubmit="return false;">
	        <!-- 아이디 -->
	        <div class="form-group">
	          <label for="user-id">아이디</label>
	          <input type="text" id="user-id" />
	        </div>
	        
            <input type="hidden" id="member-id" />
            
	        <!-- 이름 -->
	        <div class="form-group">
	          <label for="user-name">이름</label>
	          <input type="text" id="user-name" />
	        </div>
	        <!-- 전화번호 -->
	        <div class="form-group">
	          <label for="user-phone">전화번호</label>
	          <input type="text" id="user-phone" />
	        </div>
	        <!-- 직업 -->
	        <div class="form-group">
	          <label for="user-job">직업</label>
	          <input type="text" id="user-job" />
	        </div>
	        <!-- 상담일 -->
	        <div class="form-group">
	          <label for="consult-date">상담일</label>
	          <div class="input-with-icon">
	            <input type="text" id="consult-date" placeholder="YYYY-MM-DD" />
	          </div>
	        </div>
	        <!-- 운동목적 -->
	        <div class="form-group">
	          <label for="goal">운동목적</label>
	          <select id="goal">
				<option value="">선택</option>
				<option value="체중감량">체중감량</option>
				<option value="근력강화">근력강화</option>
				<option value="체형교정">체형교정</option>
				<option value="체력향상">체력향상</option>
				<option value="재활/건강관리">재활/건강관리</option>
				<option value="생활습관 개선">생활습관 개선</option>
				<option value="대회/목표 준비">대회/목표 준비</option>
	          </select>
	        </div>
	        
	        <!-- PT 등록일수 -->
	        <div class="form-group">
	          <label for="pt-days">PT등록일수</label>
	          <input type="number" id="pt-days" />
	        </div>
	      </form>
	    </div>
	
	    <!-- 3. 모달 푸터 -->
	    <div class="modal-footer">
	      <button type="button" class="submit-btn save-btn">저장</button>
	    </div>
	  </div>
	</div>

  <!-- script -->
	<script>
	/* ================= 모달 열기/닫기 ================= */
	let $modal = $("#schedule-modal");
	
	function openMemberModal() {
	  let $form = $("#schedule-modal .register-form");
	  if ($form.length > 0 && $form[0].reset) {
	    $form[0].reset();
	  }
	  $modal.addClass("show"); // CSS로 표시
	  setTimeout(function () { $("#user-id").trigger("focus"); }, 0);
	}
	
	function closeMemberModal() {
	  if ($modal.hasClass("show")) {
	    $modal.removeClass("show");
	  }
	}
	
	/* 회원등록 버튼 클릭 → 모달 오픈 */
	$(document).on("click", "#btn-create", function () {
	  openMemberModal();
	});
	
	/* 닫기(X), 오버레이 클릭, ESC */
	$(document).on("click", ".modal-close-btn", function () {
	  closeMemberModal();
	});
	
	$(document).on("click", "#schedule-modal", function (event) {
	  if (event.target && event.target.id === "schedule-modal") {
	    closeMemberModal();
	  }
	});
	
	$(document).on("keydown", function (event) {
	  if (event.key === "Escape" && $modal.hasClass("show")) {
	    closeMemberModal();
	  }
	});
	
	/* ============ 가입정보 자동조회: GET /api/users/{memberId} ============ */
	// 아이디 입력칸(#user-id)에는 login_id를 받습니다.
	function fetchSignupInfoByLoginId(loginId) {
	  if (loginId && loginId.length > 0) {
	    $.ajax({
	      url: "/api/users/by-login/" + encodeURIComponent(loginId),
	      type: "GET",
	      dataType: "json",
	      success: function (response) {
	        if (response && response.ok && response.data) {
	          let user = response.data; // { memberId, userName, phoneNumber, birth }
	          $("#member-id").val(user.memberId || "");      // 숨김: 정수 user_id
	          $("#user-name").val(user.userName || "");
	          $("#user-phone").val(user.phoneNumber || "");
	          $("#birth").val(user.birth || "");             // yyMMdd(보기/전송용)
	        } else {
	          alert("해당 아이디의 회원이 없습니다.");
	          $("#member-id").val("");
	          $("#user-name, #user-phone, #birth").val("");
	        }
	      },
	      error: function () {
	        alert("회원 정보 조회 실패");
	      }
	    });
	  }
	}

	
	/* blur + Enter 둘 다 지원 */
	$(document).on("blur", "#user-id", function () {
	  let loginId = ($(this).val() || "").trim();
	  if (loginId.length > 0) {
	    fetchSignupInfoByLoginId(loginId);
	  }
	});
	
	$(document).on("keydown", "#user-id", function (event) {
	  if (event.key === "Enter") {
	    event.preventDefault();
	    let loginId = ($(this).val() || "").trim();
	    if (loginId.length > 0) {
	      fetchSignupInfoByLoginId(loginId);
	    }
	  }
	});

	
	/* ================= 저장: POST /api/trainer/member-list ================= */
	$(document).on("click", ".save-btn", function () {
	  let trainerId   = $("#member-list").data("trainer-id");
	  let goalValue   = ($("#goal").val() || $("#purpose").val() || "").trim();
	
	  // 중요: 정수 user_id는 숨김에서!
	  let memberIdVal = ($("#member-id").val() || "").trim();
	
	  let payload = {
	    memberId:      memberIdVal,                         // 바뀐 부분
	    userName:      ($("#user-name").val() || "").trim(),
	    phoneNumber:   ($("#user-phone").val() || "").trim(),
	    birthdate:     ($("#birth").val() || "").trim(),
	    job:           ($("#user-job").val() || "").trim(),
	    consultDate:   ($("#consult-date").val() || "").trim(),
	    goal:          goalValue,
	    memo:          ($("#memo").val() || "").trim(),
	    totalSessions: ($("#pt-days").val() || "").trim(),
	    trainerId:     trainerId
	  };
	
	  if (!payload.memberId) { alert("회원 조회를 먼저 해주세요(아이디 입력 후 엔터)."); return; }
	  if (!payload.userName) { alert("이름은 필수입니다."); return; }
	
	  $.ajax({
	    url: "/api/trainer/member-list",
	    type: "POST",
	    contentType: "application/json; charset=UTF-8",
	    dataType: "json",
	    data: JSON.stringify(payload),
	    success: function (response) {
	      if (response && response.ok) {
	        alert("등록되었습니다.");
	        closeMemberModal();
	      } else {
	        alert((response && response.msg) ? response.msg : "등록 실패");
	      }
	    },
	    error: function () {
	      alert("네트워크 오류");
	    }
	  });
	});
	
	/* ================ 수정(연필) 클릭 → 단건 조회 후 모달 채우기 ================ */
	$(document).on("click", ".btn-edit", function () {
	  let memberId = $(this).closest("tr").data("memberId");
	
	  if (!memberId) {
	    alert("회원 ID가 없습니다.");
	    return;
	  }
	
	  $.ajax({
	    url: "/api/trainer/member-list/" + encodeURIComponent(memberId),
	    type: "GET",
	    dataType: "json",
	    success: function (response) {
	      if (response && response.ok === true && response.data) {
	        let data = response.data;
	        openMemberModal();
	
	        $("#user-id").val(data.memberId || "");
	        $("#user-name").val(data.userName || "");
	        $("#user-phone").val(data.phoneNumber || "");
	        $("#birth").val(data.birth || "");
	        $("#user-job").val(data.job || "");
	        $("#consult-date").val(data.consultDate || "");
	        $("#goal").val(data.goal || "");
	        $("#memo").val(data.memo || "");
	        $("#pt-days").val(data.ptRegisteredCnt || "");
	      } else {
	        alert("회원 조회 실패");
	      }
	    },
	    error: function () {
	      alert("회원 조회 실패");
	    }
	  });
	});
	
	/* ================= 삭제 (DELETE /api/trainer/member-list/{memberId}) ================= */
	$(document).on("click", ".btn-delete", function () {
	  let $row = $(this).closest("tr");
	  let memberId = $row.data("memberId");
	
	  if (!memberId) {
	    alert("회원 ID가 없습니다.");
	    return;
	  }
	
	  let confirmDelete = confirm("정말 삭제하시겠습니까?");
	  if (confirmDelete) {
	    $.ajax({
	      url: "/api/trainer/member-list/" + encodeURIComponent(memberId),
	      type: "DELETE",
	      dataType: "json",
	      success: function (response) {
	        if (response && response.ok === true) {
	          $row.remove();
	        } else {
	          alert((response && response.msg) ? response.msg : "삭제 실패");
	        }
	      },
	      error: function () {
	        alert("네트워크 오류");
	      }
	    });
	  }
	});
	</script>

</body>
</html>
