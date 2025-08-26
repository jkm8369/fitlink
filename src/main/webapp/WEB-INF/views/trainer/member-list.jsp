<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- 컨텍스트 경로 (정적 리소스/링크에 사용). 루트 배포면 '' 가 들어옵니다. --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Members - FitLink</title>

  <%-- 정적 CSS: 컨텍스트 안전하게 로드 --%>
  <link rel="stylesheet" href="<c:url value='/assets/css/reset.css'/>" />
  <link rel="stylesheet" href="<c:url value='/assets/css/include.css'/>" />
  <link rel="stylesheet" href="<c:url value='/assets/css/trainer.css'/>" />
  <link rel="stylesheet" href="<c:url value='/assets/css/member.css'/>" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
  
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body class="member-page">
  <div id="wrap">
    <!-- ===== 헤더 ===== -->
    <header>
      <a href="${ctx}/trainer/member" class="btn-logout">
        <img src="${ctx}/assets/images/logo.jpg" alt="FitLink Logo" />
      </a>
      <div class="btn-logout">
        <a href="#" class="logout-link"><i class="fa-solid fa-right-from-bracket"></i> 로그아웃</a>
      </div>
    </header>

    <!-- ===== aside + main ===== -->
    <div id="content">
      <aside>
        <div class="user-info">
          <div class="user-name-wrap">
            <img class="dumbell-icon" src="${ctx}/assets/images/사이트로고.jpg" alt="dumbell-icon" />
            <p class="user-name">홍길동<br/><small>(트레이너)</small></p>
          </div>
        </div>

        <div class="aside-menu">
          <a href="${ctx}/trainer/member" class="menu-item"><i class="fa-solid fa-address-card"></i><span>회원</span></a>
          <a href="${ctx}/trainer/schedule" class="menu-item"><i class="fa-solid fa-calendar-days"></i><span>일정</span></a>
          <a href="#" class="menu-item"><i class="fa-solid fa-list-ul"></i><span>운동종류</span></a>
        </div>
      </aside>

      <main>
        <div class="page-header">
          <h3 class="page-title">Members</h3>
          <p class="page-subtitle">
            <fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy년 M월 d일"/>
          </p>
        </div>

        <!-- ===== 회원 리스트 ===== -->
        <div class="list-area">
          <section class="card list-card">
            <div class="card-header">
              <h4 class="card-title list-title">회원 리스트</h4>
            </div>

            <div class="table-wrap">
              <table class="table">
                <colgroup>
                  <col class="w-60"><col class="w-120"><col class="w-110"><col class="w-90"><col class="w-120">
                  <col class="w-110"><col class="w-110"><col class="w-110"><col class="w-110"><col class="w-100">
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
                  <c:choose>
                    <c:when test="${not empty rows}">
                      <c:forEach var="row" items="${rows}" varStatus="st">
                        <tr data-id="${row.memberId}">
                          <td>${st.index + 1}</td>
                          <td><a href="#" class="lnk-member" data-id="${row.memberId}">${row.memberName}</a></td>
                          <td><c:out value="${row.birthdate}"/></td>
                          <td><c:out value="${row.job}" default="-"/></td>
                          <td><c:out value="${row.consultDate}" default="-"/></td>
                          <td><c:out value="${row.goal}" default="-"/></td>
                          <td class="nowrap"><c:out value="${row.pt_registered_cnt}"/>회</td>
                          <td class="nowrap"><c:out value="${row.pt_completed_cnt}"/>회</td>
                          <td class="nowrap"><c:out value="${row.pt_remaining_cnt}"/>회</td>
                          <td class="actions">
                            <button class="icon-btn btn-edit" data-id="${row.memberId}" aria-label="수정">
                              <i class="fa-solid fa-pen-to-square"></i>
                            </button>
                            <button class="icon-btn btn-del" data-id="${row.memberId}" aria-label="삭제">
                              <i class="fa-regular fa-trash-can"></i>
                            </button>
                          </td>
                        </tr>
                      </c:forEach>
                    </c:when>
                    <c:otherwise>
                      <tr><td colspan="10" class="text-center">등록된 회원이 없습니다.</td></tr>
                    </c:otherwise>
                  </c:choose>
                </tbody>
              </table>
            </div>
          </section>
        </div>
      </main>
    </div>

    <footer>
      <p>Copyright © 2025. FitLink All rights reserved.</p>
    </footer>

    <!-- ===== 회원 수정 모달 ===== -->
    <div id="memberEditModal" class="modal-overlay" style="display:none;">
      <div class="modal-container">
        <div class="modal-header">
          <h2 class="modal-title">회원 수정</h2>
          <button class="modal-close-btn" id="btnCloseMemberModal" type="button"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body">
          <form id="memberEditForm" onsubmit="return false;">
            <input type="hidden" id="mem_memberId" />
            <div class="form-row"><label>이름</label><input id="mem_userName" type="text"/></div>
            <div class="form-row"><label>전화번호</label><input id="mem_phoneNumber" type="text" placeholder="XXX-XXXX-XXXX"/></div>
            <div class="form-row"><label>직업</label><input id="mem_job" type="text"/></div>
            <div class="form-row"><label>상담일</label><input id="mem_consultDate" type="date"/></div>
            <div class="form-row"><label>운동목적</label>
              <select id="mem_goal">
                <option value="">선택</option><option>체중감량</option><option>근력증가</option><option>자세교정</option><option>건강관리</option><option>기타</option>
              </select>
            </div>
            <div class="form-row"><label>메모</label><textarea id="mem_memo" rows="3" placeholder="특이사항 메모"></textarea></div>
            <div class="form-row"><label>PT등록횟수</label><input id="mem_ptAdd" type="number" min="0" value="0"/><small class="help">※ 이번에 추가 구매한 회수 (합계가 아님)</small></div>
          </form>
        </div>
        <div class="modal-footer"><button id="btnSaveMember" class="submit-btn save-btn" type="button">저장</button></div>
      </div>
    </div>
  </div>

  <%-- ===== Ajax 스크립트 ===== --%>
	<script>
	const CTX = '${pageContext.request.contextPath}';
	const API_MEMBER = `${CTX}/api/trainer/member-list`;
	
	// 공용 유틸
	const getMemberIdFrom = (el) => $(el).data('id') || $(el).closest('tr').data('id');
	const showModal = () => $('#memberEditModal').show();
	const hideModal = () => $('#memberEditModal').hide();
	function ajaxFail(jq, text, err){
	  const msg = (jq.responseText || text || err || '').toString().slice(0,200);
	  alert('요청 실패: ' + msg);
	}
	
	// 모달 폼 채우기
	function fillEditModal(d){
	  $('#mem_memberId').val(d.memberId);
	  $('#mem_userName').val(d.userName || '');
	  $('#mem_phoneNumber').val(d.phoneNumber || '');
	  $('#mem_job').val(d.job || '');
	  $('#mem_consultDate').val((d.consultDate || '').substring(0,10));
	  $('#mem_goal').val(d.goal || '');
	  $('#mem_memo').val(d.memo || '');
	  $('#mem_ptAdd').val(0);
	}
	
	// (1) 수정 아이콘 → 상세 조회 → 모달 오픈
	$(document).on('click', '.btn-edit', function(){
	  const memberId = $(this).data('id');
	  $.getJSON(`${API_MEMBER}/${memberId}`)
	    .done(res => { if(!res.ok){ alert('조회 실패'); return; } fillEditModal(res.data); showModal(); })
	    .fail(ajaxFail);
	});
	
	// 닫기
	$('#btnCloseMemberModal').on('click', hideModal);
	
	// (2) 삭제 아이콘 → DELETE /api/trainer/member-list/{id}
	$(document).on('click', '.btn-del', function(){
	  const memberId = $(this).data('id');
	  if(!confirm('정말 삭제하시겠어요?')) return;
	
	  $.ajax({
	    url: `${API_MEMBER}/${memberId}/delete`,  // <= '/delete' 붙여서 POST로
	    type: 'POST',
	    dataType: 'json'
	  })
	  .done(res => {
	    if(!res.ok){ alert('삭제 실패'); return; }
	    $(`tr[data-id="${memberId}"]`).remove();
	  })
	  .fail(ajaxFail);
	});
	
	// (3) 저장 버튼 → 기본정보/프로필/(선택)PT추가
	$('#btnSaveMember').on('click', function(){
	  const memberId    = $('#mem_memberId').val();
	  const userName    = $('#mem_userName').val().trim();
	  const phoneNumber = $('#mem_phoneNumber').val().trim();
	  const birthdate   = $('#mem_birthdate').length ? $('#mem_birthdate').val() : '';
	  const job         = $('#mem_job').val().trim();
	  const consultDate = $('#mem_consultDate').val();
	  const goal        = $('#mem_goal').val();
	  const memo        = $('#mem_memo').val().trim();
	  const ptAdd       = parseInt($('#mem_ptAdd').val() || '0', 10);
	
	  if(!memberId){ alert('회원이 선택되지 않았습니다.'); return; }
	  if(!userName){ alert('이름을 입력하세요.'); return; }
	
	const p1 = $.ajax({
		  url: `${API_MEMBER}/${memberId}/basic`,
		  type: 'POST',
		  dataType: 'json',
		  data: { userName, phoneNumber, birthdate }
		});
	const p2 = $.ajax({
	  url: `${API_MEMBER}/${memberId}/profile`,
	  type: 'POST',
	  dataType: 'json',
	  data: { job, consultDate, goal, memo }
	});
	const p3 = (ptAdd > 0)
	  ? $.ajax({
	      url: `${API_MEMBER}/${memberId}/pt-contract`,
	      type: 'POST',
	      dataType: 'json',
	      data: { totalSessions: ptAdd }
	    })
	: $.Deferred().resolve({ok:true}).promise();

	
	  $.when(p1, p2, p3).done((r1,r2,r3)=>{
	    const ok1 = r1[0]?.ok !== false, ok2 = r2[0]?.ok !== false, ok3 = (ptAdd>0) ? (r3[0]?.ok !== false) : true;
	    if(ok1 && ok2 && ok3){
	      alert('저장되었습니다.');
	      hideModal();
	      const $row = $(`tr[data-id="${memberId}"]`); if($row.length){ $row.find('a.lnk-member').text(userName); }
	    } else { alert('일부 저장에 실패했습니다.'); }
	  }).fail(ajaxFail);
	});
	
	// 상세 링크 기본 이동 막기
	$(document).on('click', '.lnk-member', (e)=> e.preventDefault());
	</script>
</body>
</html>
