<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>InBody&Meal - FitLink</title>    
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/include.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member.css" />
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
                                    <th class="w-90">순서</th>
                                    <th class="w-200">날짜</th>
                                    <th class="w-140">시간</th>
                                    <th class="w-140">인바디 점수</th>
                                    <th class="w-120 actions-head"></th>
                                </tr>
                            </thead>
                            <tbody id="inbody-list-tbody">
                                <!-- AJAX로 채워질 영역 -->
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="5">
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
                        <button id="btn-open-upload" class="btn-floating">
                            <i class="fa-solid fa-chart-pie"></i> 인바디 등록
                        </button>
                        
                        <!-- 파일 입력을 위한 숨겨진 input -->
                        <input type="file" id="file-input" style="display: none;" accept="image/*">

                        <section class="card inbody-card">
                            <div class="inbody-detail">
                                <div id="inbody-scan-area" class="inbody-scan">
                                	리스트에서 항목을 선택해주세요
                                </div>
                                <div id="inbody-panel-area" class="inbody-panel" style="display:none;">
                                    <!-- 상세 정보 패널 (기존 HTML 구조 사용) -->
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
                <!-- //main-box2 -->

                <!-- main-box3: 영양 정보 -->
                <div id="nutrition-info-area" class="main-box3" style="display:none;">
                    <!-- 영양 정보 (기존 HTML 구조 사용) -->
                </div>
                <!-- //main-box3 -->
            </main>
        </div>

		<!-- ------footer------ -->
        <c:import url="/WEB-INF/views/include/footer.jsp"></c:import>
        <!-- //------footer------ -->
    </div>



<script>
$(document).ready(function() {
    // =================================================
    // 초기 설정 및 상태 변수
    // =================================================
    const authUser = {
        userId: Number("${sessionScope.authUser.userId}" || 0),
        role: "${sessionScope.authUser.role}"
    };
    const currentMember = {
        userId: Number("${currentMember.userId}" || 0)
    };
    const targetUserId = (authUser.role === 'trainer' && currentMember.userId > 0) 
                         ? currentMember.userId 
                         : authUser.userId;
    
    let selectedFile = null;

    // =================================================
    // 함수 정의
    // =================================================

    function fetchInbodyList(page) {
        $.ajax({
            url: "${pageContext.request.contextPath}/api/inbody/list",
            type: "GET",
            data: { userId: targetUserId, crtPage: page },
            dataType: "json",
            success: function(jsonResult) {
                if (jsonResult.result === "success") {
                    renderList(jsonResult.apiData.inbodyList, page, jsonResult.apiData.totalCount);
                    renderPagination(jsonResult.apiData, page);
                } else {
                    alert(jsonResult.message);
                }
            },
            error: (xhr, status, error) => console.error("리스트 로딩 실패:", error)
        });
    }

    //인바디 리스트 그리기
    function renderList(inbodyList, page, totalCount) {
        const $tbody = $("#inbody-list-tbody");
        $tbody.empty();
        const listCnt = 5;

        if (inbodyList.length === 0) {
            $tbody.html('<tr><td colspan="5" class="empty-row">등록된 인바디 정보가 없습니다.</td></tr>');
            return;
        }

        inbodyList.forEach(function(inbody, index) {
            const rowNum = totalCount - ((page - 1) * listCnt) - index;
            const dateTimeParts = inbody.recordDate ? inbody.recordDate.split(' ') : ['-','-'];
            const date = dateTimeParts[0];
            const time = dateTimeParts.length > 1 ? dateTimeParts[1].substring(0, 5) : '-';
            
            let scoreText = (inbody.inbodyScore && inbody.inbodyScore > 0) ? inbody.inbodyScore + '점' : '-';

            let str = `
                <tr data-inbody-id="${inbody.inbodyId}" style="cursor:pointer;">
                    <td>\${rowNum}</td>
                    <td>\${date}</td>
                    <td>\${time}</td>
                    <td>\${scoreText}</td>
                    <td class="actions">
                        <button class="icon-btn btn-delete" data-inbody-id="\${inbody.inbodyId}" aria-label="삭제">
                            <i class="fa-regular fa-trash-can"></i>
                        </button>
                    </td>
                </tr>
            `;
            $tbody.append(str);
        });
    }

    // 페이징
    function renderPagination(pMap, crtPage) {
        const $pagination = $("#inbody-pagination");
        $pagination.empty();
        let str = '';
        if (pMap.prev) {
            str += `<button class="page nav prev" data-page="\${pMap.startPageBtnNo - 1}"><span>←</span> 이전</button>`;
        }
        for (let i = pMap.startPageBtnNo; i <= pMap.endPageBtnNo; i++) {
            str += `<button class="page \${i == crtPage ? 'active' : ''}" data-page="\${i}">\${i}</button>`;
        }
        if (pMap.next) {
            str += `<button class="page nav next" data-page="\${pMap.endPageBtnNo + 1}">다음 <span>→</span></button>`;
        }
        $pagination.html(str);
    }
    
    function fetchInbodyDetail(inbodyId) {
        $.ajax({
            url: `\${pageContext.request.contextPath}/api/inbody/\${inbodyId}`,
            type: "GET",
            dataType: "json",
            success: (jsonResult) => {
                if (jsonResult.result === "success") renderDetail(jsonResult.apiData);
                else alert(jsonResult.message);
            },
            error: (xhr, status, error) => console.error("상세 정보 로딩 실패:", error)
        });
    }

    function renderDetail(data) {
        $("#detail-date-pill").text(data.recordDate);
        $("#inbody-scan-area").html(`<img src="\${pageContext.request.contextPath}\${data.imageUrl}" alt="InBody Scan" style="width:100%; height:100%; object-fit:contain;">`);
        $("#inbody-panel-area, #nutrition-info-area").show();
    }

    // =================================================
    // 이벤트 핸들러
    // =================================================

    $("#inbody-list-tbody").on("click", "tr[data-inbody-id]", function() {
        fetchInbodyDetail($(this).data("inbody-id"));
    });

    $("#inbody-list-tbody").on("click", ".btn-delete", function(e) {
        e.stopPropagation();
        if (!confirm("정말 삭제하시겠습니까?")) return;
        
        $.ajax({
            url: `\${pageContext.request.contextPath}/api/inbody/\${$(this).data("inbody-id")}`,
            type: "DELETE",
            dataType: "json",
            success: (jsonResult) => {
                if (jsonResult.result === "success") {
                    alert("삭제되었습니다.");
                    fetchInbodyList(1);
                } else alert(jsonResult.message);
            },
            error: (xhr, status, error) => console.error("삭제 실패:", error)
        });
    });

    $("#inbody-pagination").on("click", ".page", function() {
        fetchInbodyList($(this).data("page"));
    });

    $("#btn-open-upload").on("click", () => $("#file-input").click());

    $("#file-input").on("change", function(event) {
        const file = event.target.files[0];
        if (file) {
            selectedFile = file;
            const reader = new FileReader();
            reader.onload = function(e) {
                $("#preview-image").attr("src", e.target.result);
                $("#confirm-upload-modal").show();
            };
            reader.readAsDataURL(file);
        }
        $(this).val('');
    });

    $("#btn-confirm-upload").on("click", function() {
        if (!selectedFile) return;

        const formData = new FormData();
        formData.append("file", selectedFile);
        
        $("#confirm-upload-modal").hide();
        $("#loading-modal").show();

        $.ajax({
            url: "${pageContext.request.contextPath}/api/inbody/upload",
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,
            dataType: "json",
            success: (jsonResult) => {
                if (jsonResult.result === "success") {
                    alert("성공적으로 등록되었습니다.");
                    fetchInbodyList(1);
                } else alert(jsonResult.message);
            },
            error: (xhr, status, error) => {
                console.error("업로드 실패:", error);
                alert("업로드에 실패했습니다.");
            },
            complete: () => {
                $("#loading-modal").hide();
                selectedFile = null;
            }
        });
    });

    $("#btn-cancel-upload, #confirm-upload-modal .modal-close").on("click", function() {
        $("#confirm-upload-modal").hide();
        selectedFile = null;
    });

    // =================================================
    // 페이지 최초 로딩
    // =================================================
    fetchInbodyList(1);
});
</script>

</body>
</html>