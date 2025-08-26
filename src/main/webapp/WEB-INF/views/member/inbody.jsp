<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>InBody&Meal - FitLink</title>
    
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/include.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    
    <!-- JavaScript -->
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
		            <c:import url="/WEB-INF/views/include/aside-member.jsp"></c:import>
		        </c:otherwise>
		    </c:choose>
			<!-- //------aside------ -->

            <main>
                <!-- main-box1: 인바디 리스트 -->
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
                                    <th class="w-200">날짜</th>
                                    <th class="w-140">인바디 점수</th>
                                    <th class="w-120 actions-head"></th>
                                </tr>
                            </thead>
                            <tbody id="inbody-list-tbody">
                                <!-- AJAX로 채워질 영역 -->
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="3">
                                        <div class="pagination" id="inbody-pagination">
                                            <!-- AJAX로 채워질 영역 -->
                                        </div>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </section>

                    <hr class="section-divider">
                </div>
                <!-- //main-box1 -->

                <!-- main-box2: 인바디 상세 정보 -->
                <div class="main-box2">
                    <div class="date-row">
                        <div id="detail-date-pill" class="pill pill--date">날짜를 선택해주세요</div>
                    </div>

                    <div class="inbody-card-wrap">
                        <button id="btn-open-modal" class="btn-floating">
                            <i class="fa-solid fa-chart-pie"></i> 인바디 등록
                        </button>

                        <section class="card inbody-card">
                            <div class="inbody-detail">
                                <div id="inbody-scan-area" class="inbody-scan">
                                	<!-- AJAX로 채워질 영역 -->
                                	리스트에서 항목을 선택해주세요
                                </div>
                                <div id="inbody-panel-area" class="inbody-panel" style="display:none;">
                                    <!-- 상세 정보 패널 (초기에는 숨김) -->
                                    <!-- ... (기존 상세 정보 HTML 구조) ... -->
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
                <!-- //main-box2 -->

                <!-- main-box3: 영양 정보 -->
                <div id="nutrition-info-area" class="main-box3" style="display:none;">
                    <!-- 영양 정보 (초기에는 숨김) -->
                    <!-- ... (기존 영양 정보 HTML 구조) ... -->
                </div>
                <!-- //main-box3 -->
            </main>
        </div>

		<!-- ------footer------ -->
        <c:import url="/WEB-INF/views/include/footer.jsp"></c:import>
        <!-- //------footer------ -->
    </div>
    
    <!-- ================================================================= -->
    <!-- [추가] 인바디 등록 모달창 HTML                                     -->
    <!-- ================================================================= -->
    <div class="modal-overlay" id="upload-modal" style="display: none;">
        <div class="modal-container">
            <div class="modal-header">
                <h2 class="modal-title">인바디 등록</h2>
                <button type="button" class="modal-close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <form id="upload-form">
                    <input type="file" name="file" accept="image/*" required>
                </form>
                <div id="loading-indicator" style="display:none; text-align:center; margin-top:15px;">
                	<p>이미지를 분석 중입니다. 잠시만 기다려주세요...</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" form="upload-form" class="submit-btn">업로드</button>
            </div>
        </div>
    </div>
<!-- ========================================= script ======================================================== -->
<script>
$(document).ready(function() {
   
    // 초기 설정 및 상태 변수
    const authUser = {
        userId: Number("${sessionScope.authUser.userId}" || 0),
        role: "${sessionScope.authUser.role}"
    };
    
    const currentMember = {
        userId: Number("${currentMember.userId}" || 0)
    };

    // 데이터를 조회할 대상 ID (트레이너가 회원 조회 시 memberId, 아니면 본인 ID)
    const targetUserId = (authUser.role === 'trainer' && currentMember.userId > 0) 
                         ? currentMember.userId 
                         : authUser.userId;

    // =================================================
    // 함수 정의
    // =================================================

    // 인바디 리스트와 페이징을 불러와서 그리는 함수
    function fetchInbodyList(page) {
        $.ajax({
            url: "${pageContext.request.contextPath}/api/inbody/list",
            type: "GET",
            data: {
                userId: targetUserId,
                crtPage: page
            },
            dataType: "json",
            success: function(jsonResult) {
                if (jsonResult.result === "success") {
                    renderList(jsonResult.apiData.inbodyList);
                    renderPagination(jsonResult.apiData, page);
                } else {
                    alert(jsonResult.message);
                }
            },
            error: function(xhr, status, error) {
                console.error("리스트 로딩 실패:", error);
            }
        });
    }

    // 인바디 리스트 <tbody>를 그리는 함수
    function renderList(inbodyList) {
        const $tbody = $("#inbody-list-tbody");
        $tbody.empty();

        if (inbodyList.length === 0) {
            $tbody.html('<tr><td colspan="3" class="empty-row">등록된 인바디 정보가 없습니다.</td></tr>');
            return;
        }

        inbodyList.forEach(function(inbody) {
            let str = `
                <tr data-inbody-id="${inbody.inbodyId}" style="cursor:pointer;">
                    <td>${inbody.recordDate}</td>
                    <td>${inbody.inbodyScore || '-'}점</td>
                    <td class="actions">
                        <button class="icon-btn btn-delete" data-inbody-id="${inbody.inbodyId}" aria-label="삭제">
                            <i class="fa-regular fa-trash-can"></i>
                        </button>
                    </td>
                </tr>
            `;
            $tbody.append(str);
        });
    }

    // 페이징 버튼을 그리는 함수
    function renderPagination(pMap, crtPage) {
        const $pagination = $("#inbody-pagination");
        $pagination.empty();
        
        let str = '';
        if (pMap.prev) {
            str += `<button class="page nav prev" data-page="${pMap.startPageBtnNo - 1}"><span>←</span> 이전</button>`;
        }
        for (let i = pMap.startPageBtnNo; i <= pMap.endPageBtnNo; i++) {
            str += `<button class="page ${i == crtPage ? 'active' : ''}" data-page="${i}">${i}</button>`;
        }
        if (pMap.next) {
            str += `<button class="page nav next" data-page="${pMap.endPageBtnNo + 1}">다음 <span>→</span></button>`;
        }
        $pagination.html(str);
    }
    
    // 상세 정보를 불러와서 그리는 함수
    function fetchInbodyDetail(inbodyId) {
        $.ajax({
            url: `\${pageContext.request.contextPath}/api/inbody/\${inbodyId}`,
            type: "GET",
            dataType: "json",
            success: function(jsonResult) {
                if (jsonResult.result === "success") {
                    renderDetail(jsonResult.apiData);
                } else {
                    alert(jsonResult.message);
                }
            },
            error: function(xhr, status, error) {
                console.error("상세 정보 로딩 실패:", error);
            }
        });
    }

    // 상세 정보 영역을 채우는 함수
    function renderDetail(data) {
        $("#detail-date-pill").text(data.recordDate);
        $("#inbody-scan-area").html(`<img src="\${data.imageUrl}" alt="InBody Scan" style="width:100%; height:100%; object-fit:contain;">`);
        
        // TODO: 상세 패널과 영양 정보 영역의 각 요소에 ID를 부여하고, data 객체의 값으로 채워넣는 코드 추가
        // 예: $("#inbody-score-value").text(data.inbodyScore);
        
        $("#inbody-panel-area").show();
        $("#nutrition-info-area").show();
    }

    // =================================================
    // 이벤트 핸들러 바인딩
    // =================================================

    // 인바디 리스트의 행 클릭 시 > 상세 정보 표시 (이벤트 위임)
    $("#inbody-list-tbody").on("click", "tr[data-inbody-id]", function() {
        const inbodyId = $(this).data("inbody-id");
        fetchInbodyDetail(inbodyId);
    });

    // 삭제 버튼 클릭 시 (이벤트 위임)
    $("#inbody-list-tbody").on("click", ".btn-delete", function(e) {
        e.stopPropagation(); // 행 클릭 이벤트가 같이 실행되는 것을 방지
        if (!confirm("정말 삭제하시겠습니까?")) return;

        const inbodyId = $(this).data("inbody-id");
        
        $.ajax({
            url: `\${pageContext.request.contextPath}/api/inbody/\${inbodyId}`,
            type: "DELETE",
            dataType: "json",
            success: function(jsonResult) {
                if (jsonResult.result === "success") {
                    alert("삭제되었습니다.");
                    fetchInbodyList(1); // 목록 새로고침
                } else {
                    alert(jsonResult.message);
                }
            },
            error: function(xhr, status, error) {
                console.error("삭제 실패:", error);
            }
        });
    });

    // 페이징 버튼 클릭 시 (이벤트 위임)
    $("#inbody-pagination").on("click", ".page", function() {
        const page = $(this).data("page");
        fetchInbodyList(page);
    });

    // '인바디 등록' 버튼 클릭 > 모달 열기
    $("#btn-open-modal").on("click", function() {
        $("#upload-modal").css("display", "flex");
    });

    // 모달 닫기 버튼
    $(".modal-close-btn").on("click", function() {
        $("#upload-modal").hide();
    });

    // 모달 폼 제출 (업로드)
    $("#upload-form").on("submit", function(e) {
        e.preventDefault();
        const formData = new FormData(this);
        const $loading = $("#loading-indicator");
        
        $loading.show();

        $.ajax({
            url: "${pageContext.request.contextPath}/api/inbody/upload",
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,
            dataType: "json",
            success: function(jsonResult) {
                if (jsonResult.result === "success") {
                    alert("성공적으로 등록되었습니다.");
                    $("#upload-modal").hide();
                    fetchInbodyList(1); // 목록 새로고침
                } else {
                    alert(jsonResult.message);
                }
            },
            error: function(xhr, status, error) {
                console.error("업로드 실패:", error);
                alert("업로드에 실패했습니다.");
            },
            complete: function() {
                $loading.hide();
                $("#upload-form")[0].reset();
            }
        });
    });

    // =================================================
    // 페이지 최초 로딩
    // =================================================
    fetchInbodyList(1);
});
</script>

</body>
</html>
