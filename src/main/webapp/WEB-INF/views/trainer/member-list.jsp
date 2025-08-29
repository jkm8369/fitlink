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
                    
                    <!-- 순서 -->
                    <td><c:out value="${st.index + 1}"/></td>

                    <!-- 이름 -->
                    <td>
                      <a href="${pageContext.request.contextPath}/workout/member/${row.memberId}" class="link-member" data-member-id="${row.memberId}" target="_blank">
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
                      <button class="icon-btn btn-edit" type="button" aria-label="수정">
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

	<!-- [CREATE] 회원 등록 모달 -->
	<div id="member-create-modal">
	  <div class="modal-container">
	    <div class="modal-header">
	      <h2 class="modal-title">회원 등록</h2>
	      <button type="button" class="modal-close-btn c-close" aria-label="닫기">
	        <i class="fa-solid fa-xmark"></i>
	      </button>
	    </div>
	
	    <div class="modal-body">
	      <form id="create-form" onsubmit="return false;">
	        <input type="hidden" id="c-member-id" />
	
	        <div class="form-group">
	          <label for="c-user-login-id">아이디</label>
	          <input type="text" id="c-user-login-id" />
	        </div>
	
	        <div class="form-group">
	          <label for="c-user-full-name">이름</label>
	          <input type="text" id="c-user-full-name" />
	        </div>
	
	        <div class="form-group">
	          <label for="c-user-phone-number">전화번호</label>
	          <input type="text" id="c-user-phone-number" />
	        </div>
	
	        <div class="form-group">
	          <label for="c-user-job">직업</label>
	          <input type="text" id="c-user-job" />
	        </div>
	
	        <div class="form-group">
	          <label for="c-consult-date">상담일</label>
	          <input type="text" id="c-consult-date" placeholder="YYYY-MM-DD" />
	        </div>
	
	        <div class="form-group">
	          <label for="c-goal">운동목적</label>
	          <select id="c-goal">
	            <option value="기타" selected>기타</option>
	            <option value="체중감량">체중감량</option>
	            <option value="근력강화">근력강화</option>
	            <option value="체형교정">체형교정</option>
	            <option value="체력향상">체력향상</option>
	            <option value="재활/건강관리">재활/건강관리</option>
	            <option value="생활습관 개선">생활습관 개선</option>
	            <option value="대회/목표 준비">대회/목표 준비</option>
	          </select>
	        </div>
	        
	        <div class="form-group">
			  <label for="c-memo">메모</label>
			  <textarea id="c-memo" rows="3"></textarea>
			</div>
	        
	
	        <div class="form-group">
	          <label for="c-pt-days">PT등록일수</label>
	          <input type="number" id="c-pt-days" />
	        </div>
	      </form>
	    </div>
	
	    <div class="modal-footer">
	      <button type="button" class="submit-btn save-btn c-save-btn">저장</button>
	    </div>
	  </div>
	</div>
	
	<!-- [EDIT] 회원 수정 모달 -->
	<div id="member-edit-modal">
	  <div class="modal-container">
	    <div class="modal-header">
	      <h2 class="modal-title">회원 수정</h2>
	      <button type="button" class="modal-close-btn e-close" aria-label="닫기">
	        <i class="fa-solid fa-xmark"></i>
	      </button>
	    </div>
	
	    <div class="modal-body">
	      <form id="edit-form" onsubmit="return false;">
	        <input type="hidden" id="e-member-id" />
	        <input type="hidden" id="e-birth-date" />
	
	        <div class="form-group">
	          <label for="e-user-login-id">아이디</label>
	          <input type="text" id="e-user-login-id" readonly />
	        </div>
	
	        <div class="form-group">
	          <label for="e-user-full-name">이름</label>
	          <input type="text" id="e-user-full-name" />
	        </div>
	
	        <div class="form-group">
	          <label for="e-user-phone-number">전화번호</label>
	          <input type="text" id="e-user-phone-number" />
	        </div>
	
	        <div class="form-group">
	          <label for="e-user-job">직업</label>
	          <input type="text" id="e-user-job" />
	        </div>
	
	        <div class="form-group">
	          <label for="e-consult-date">상담일</label>
	          <input type="text" id="e-consult-date" placeholder="YYYY-MM-DD" />
	        </div>
	
	        <div class="form-group">
	          <label for="e-goal">운동목적</label>
	          <select id="e-goal">
	            <option value="기타" selected>기타</option>
	            <option value="체중감량">체중감량</option>
	            <option value="근력강화">근력강화</option>
	            <option value="체형교정">체형교정</option>
	            <option value="체력향상">체력향상</option>
	            <option value="재활/건강관리">재활/건강관리</option>
	            <option value="생활습관 개선">생활습관 개선</option>
	            <option value="대회/목표 준비">대회/목표 준비</option>
	          </select>
	        </div>
	        
	        <div class="form-group">
			  <label for="e-memo">메모</label>
			  <textarea id="e-memo" rows="3"></textarea>
			</div>
	
	        <div class="form-group">
	          <label for="e-pt-days">PT등록일수</label>
	          <input type="number" id="e-pt-days" />
	        </div>
	      </form>
	    </div>
	
	    <div class="modal-footer">
	      <button type="button" class="submit-btn save-btn e-save-btn">저장</button>
	    </div>
	  </div>
	</div>

 	<!-- script -->
	<script>
	  // ====================== 모달 열기/닫기 ======================
	  $(document).on('click', '#btn-create', function(){ $('#member-create-modal').show(); });
	  $(document).on('click', '.c-close',    function(){ $('#member-create-modal').hide(); });
	  $(document).on('click', '.e-close',    function(){ $('#member-edit-modal').hide();  });
	
	  // (선택) 저장/수정 후 테이블 다시 불러오기
	  function reloadMemberTable(){ location.reload(); }
	
	  // 세션 trainerId (없으면 data-attr에서)
	  function currentTrainerId(){
	    return $('#member-list').data('trainer-id') || 1;
	  }
	
	  // ====================== [등록] 가입정보 자동 채우기 ======================
	  function fetchSignupInfoByLoginId(loginId) {
	    if (!loginId) return;
	
	    // 먼저 클리어(시각 피드백)
	    $('#c-member-id').val('');
	    $('#c-user-full-name').val('');
	    $('#c-user-phone-number').val('');
	    $('#c-birth-date').val('');
	
	    $.ajax({
	      url: '/api/trainer/member-list/lookup',
	      type: 'GET',
	      data: { loginId: loginId },
	      dataType: 'json',
	      success: function (res) {
	        if (!(res && res.ok && res.data)) {
	          alert('해당 아이디의 회원이 없습니다.');
	          return;
	        }
	        const u = res.data;
	        // 매퍼(L) 별칭에 맞춰 채움
	        $('#c-member-id').val(u.memberId || '');          // hidden
	        $('#c-user-full-name').val(u.userName || '');
	        $('#c-user-phone-number').val(u.phoneNumber || '');
	        $('#c-birth-date').val(u.birth || '');            // hidden (yyMMdd)
	      },
	      error: function () { alert('회원 정보 조회 실패'); }
	    });
	  }
	
	  // ====== [등록] 아이디 입력칸 이벤트: blur + Enter 에서 조회 ======
	  $(document).on('blur', '#c-user-login-id', function(){
	    const loginId = ($(this).val() || '').trim();
	    fetchSignupInfoByLoginId(loginId);
	  });
	
	  $(document).on('keydown', '#c-user-login-id', function(e){
	    if(e.key === 'Enter'){
	      e.preventDefault();
	      const loginId = ($(this).val() || '').trim();
	      fetchSignupInfoByLoginId(loginId);
	    }
	  });
	
	  // ====================== [등록] 저장 ======================
	  // 플로우:
	  // 1) lookup으로 memberId 확보
	  // 2) assign(loginId)으로 배정 시도
	  // 3) (선택) profile 저장
	  // 4) (선택) pt-contract 추가
	  $(document).on('click', '.c-save-btn', function(){
	    const loginId       = ($('#c-user-login-id').val()||'').trim();
	    const memberId      = ($('#c-member-id').val()||'').trim();   // lookup 성공 시 세팅됨
	    const userFullName  = ($('#c-user-full-name').val()||'').trim();
	    const userPhone     = ($('#c-user-phone-number').val()||'').trim();
	    const birthYYMMDD   = ($('#c-birth-date').val()||'').trim();
	    const job           = ($('#c-user-job').val()||'').trim();
	    const consultDate   = ($('#c-consult-date').val()||'').trim(); // YYYY-MM-DD
	    const goal          = ($('#c-goal').val()||'').trim();
	    const memo          = ($('#c-memo').val()||'').trim();
	    const totalSessions = ($('#c-pt-days').val()||'').trim();
	
	    if(!loginId){ alert('아이디를 입력해주세요.'); return; }
	    if(!memberId){ alert('아이디로 회원 조회부터 해주세요.'); return; }
	    if(!userFullName){ alert('이름은 필수입니다.'); return; }
	
	    // (2) 배정 시도
	    $.ajax({
	      url: '/api/trainer/member-list/assign',
	      type: 'POST',
	      data: { loginId: loginId }, // application/x-www-form-urlencoded
	      dataType: 'json',
	      success: function(res){
	        if(!(res && res.ok)){ alert('배정 실패'); return; }
	        const code = res.code;
	        if(code === 'ASSIGNED_OTHER'){
	          alert('이미 다른 트레이너에 배정된 회원입니다.');
	          return;
	        }
	        // OK_ASSIGNED or ALREADY_ASSIGNED_THIS
	        // (3) 프로필 저장 (선택 — 값 하나라도 있으면 저장 시도)
	        function saveProfileIfNeeded(next){
	          if(!job && !consultDate && !goal && !memo){ next(); return; }
	          $.ajax({
	            url: '/api/trainer/member-list/' + encodeURIComponent(memberId) + '/profile',
	            type: 'POST',
	            data: { job: job, consultDate: consultDate, goal: goal, memo: memo },
	            dataType: 'json',
	            success: function(){ next(); },
	            error: function(){ alert('프로필 저장 실패'); next(); }
	          });
	        }
	
	        // (4) PT 계약 추가 (선택)
	        function addPtIfNeeded(done){
	          const n = parseInt(totalSessions, 10);
	          if(isNaN(n) || n <= 0){ done(); return; }
	          $.ajax({
	            url: '/api/trainer/member-list/' + encodeURIComponent(memberId) + '/pt-contract',
	            type: 'POST',
	            data: { totalSessions: n },
	            dataType: 'json',
	            success: function(){ done(); },
	            error: function(){ alert('PT 계약 추가 실패'); done(); }
	          });
	        }
	
	        saveProfileIfNeeded(function(){
	          addPtIfNeeded(function(){
	            alert(code === 'OK_ASSIGNED' ? '배정 및 저장되었습니다.' : '이미 내 회원이라 저장만 완료했습니다.');
	            $('#member-create-modal').hide();
	            reloadMemberTable();
	          });
	        });
	      },
	      error: function(){ alert('배정 요청 실패'); }
	    });
	  });
	
	  // ====================== [수정] 연필 클릭 → 단건 조회 → 모달 채우기 ======================
	  $(document).on('click', '.btn-edit', function () {
	    const memberId = $(this).closest('tr').data('memberId');
	    if (!memberId) { alert('회원 ID가 없습니다.'); return; }
	
	    $.ajax({
	      url: '/api/trainer/member-list/' + encodeURIComponent(memberId) + '/edit',
	      type: 'GET',
	      dataType: 'json',
	      success: function (res) {
	        if (!(res && res.ok && res.data)) { alert('회원 조회 실패'); return; }
	        const d = res.data;
	        const $modal = $('#member-edit-modal');
	
	        // (M) selectMemberDetailForEdit: memberId, loginId, memberName, phoneNumber, birth(YYYY-MM-DD),
	        // job, consultDate, goal, memo, ptRegisteredCnt
	        $modal.find('#e-member-id').val(d.memberId || '');
	        $modal.find('#e-user-login-id').val(d.loginId || '');
	        $modal.find('#e-user-full-name').val(d.memberName || '');
	        $modal.find('#e-user-phone-number').val(d.phoneNumber || '');
	        $modal.find('#e-birth-date').val(d.birth || ''); // YYYY-MM-DD
	        $modal.find('#e-user-job').val(d.job || '');
	        $modal.find('#e-consult-date').val(d.consultDate || ''); // YYYY-MM-DD
	        $modal.find('#e-goal').val(d.goal || '기타');
	        $modal.find('#e-memo').val(d.memo || '');
	        $modal.find('#e-pt-days').val(d.ptRegisteredCnt != null ? d.ptRegisteredCnt : '');
	
	        $modal.show();
	        $modal.find('#e-user-full-name').trigger('focus');
	      },
	      error: function () { alert('회원 조회 실패'); }
	    });
	  });
	
	  // ====================== [수정] 저장 ======================
	  // 플로우:
	  // 1) basic 저장 (users)
	  // 2) profile 저장 (member_profile)
	  // 3) (선택) PT 계약 추가
	  $(document).on('click', '.e-save-btn', function(){
	    const memberId    = ($('#e-member-id').val()||'').trim();
	    const userName    = ($('#e-user-full-name').val()||'').trim();
	    const phoneNumber = ($('#e-user-phone-number').val()||'').trim();
	    const birth       = ($('#e-birth-date').val()||'').trim();       // YYYY-MM-DD 권장
	    const job         = ($('#e-user-job').val()||'').trim();
	    const consultDate = ($('#e-consult-date').val()||'').trim();     // YYYY-MM-DD
	    const goal        = ($('#e-goal').val()||'').trim();
	    const memo        = ($('#e-memo').val()||'').trim();
	    const ptDaysStr   = ($('#e-pt-days').val()||'').trim();
	
	    if(!memberId){ alert('회원 ID가 없습니다.'); return; }
	    if(!userName){ alert('이름은 필수입니다.'); return; }
	
	    // (1) 기본정보 저장
	    $.ajax({
	      url: '/api/trainer/member-list/' + encodeURIComponent(memberId) + '/basic',
	      type: 'POST',
	      data: { userName: userName, phoneNumber: phoneNumber, birth: birth },
	      dataType: 'json',
	      success: function(){
	        // (2) 프로필 저장
	        $.ajax({
	          url: '/api/trainer/member-list/' + encodeURIComponent(memberId) + '/profile',
	          type: 'POST',
	          data: { job: job, consultDate: consultDate, goal: goal, memo: memo },
	          dataType: 'json',
	          success: function(){
	            // (3) PT 계약 추가 (값이 양수일 때만)
	            const n = parseInt(ptDaysStr, 10);
	            if(isNaN(n) || n <= 0){
	              alert('수정되었습니다.');
	              $('#member-edit-modal').hide();
	              reloadMemberTable();
	              return;
	            }
	            $.ajax({
	              url: '/api/trainer/member-list/' + encodeURIComponent(memberId) + '/pt-contract',
	              type: 'POST',
	              data: { totalSessions: n },
	              dataType: 'json',
	              success: function(){
	                alert('수정 및 PT 계약 추가가 완료되었습니다.');
	                $('#member-edit-modal').hide();
	                reloadMemberTable();
	              },
	              error: function(){
	                alert('PT 계약 추가 실패(나머지는 저장됨).');
	                $('#member-edit-modal').hide();
	                reloadMemberTable();
	              }
	            });
	          },
	          error: function(){ alert('프로필 저장 실패'); }
	        });
	      },
	      error: function(){ alert('기본정보 저장 실패'); }
	    });
	  });
	
	  // ====================== [삭제=배정 해제] ======================
	  $(document).on('click', '.btn-delete', function(){
	    const $row = $(this).closest('tr');
	    const memberId = $row.data('memberId');
	    if(!memberId){ alert('회원 ID가 없습니다.'); return; }
	    if(!confirm('정말 해제하시겠습니까? (예약/계약 기록은 보존됩니다)')) return;
	
	    $.ajax({
	      url: '/api/trainer/member-list/' + encodeURIComponent(memberId),
	      type: 'DELETE', dataType: 'json',
	      success: function(response){
	        if(response && response.ok === true){ $row.remove(); }
	        else{ alert((response && response.msg) ? response.msg : '해제 실패'); }
	      },
	      error: function(){ alert('네트워크 오류'); }
	    });
	  });
	</script>

</body>
</html>
