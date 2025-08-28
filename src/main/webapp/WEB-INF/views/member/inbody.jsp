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
                        <button id="btn-open-modal" class="btn-floating">
                            <i class="fa-solid fa-chart-pie"></i> 인바디 등록
                        </button>      

                        <section class="card inbody-card" id="inbody-detail-card">
                            <!-- AJAX로 채워질 인바디 상세 정보 -->
                        </section>
                    </div>
                </div>
                <!-- //main-box2 -->

                <!-- main-box3: 영양 정보 -->
                <div id="nutrition-info-area" class="main-box3" style="display:none;">
                    <!-- AJAX로 채워질 영양 정보 -->
                </div>
                <!-- //main-box3 -->
            </main>
        </div>

		<!-- ------footer------ -->
        <c:import url="/WEB-INF/views/include/footer.jsp"></c:import>
        <!-- //------footer------ -->
    </div>
	
	<!------------------------------ 인바디 직접 입력 모달창 ------------------------------------->
	<div id="manual-input-modal" class="modal-backdrop" style="display:none;">
	    <div class="modal-content">
	        <div class="modal-header">
	            <h5 class="modal-title">인바디 정보 직접 입력</h5>
	            <button type="button" class="modal-close" id="btn-close-modal">&times;</button>
	        </div>
	        <div class="modal-body">
	            <div class="form-group">
	                <label for="height">키 (cm)</label>
	                <input type="number" id="height" class="form-control" placeholder="예: 175">
	            </div>
	            <div class="form-group">
	                <label for="weight">체중 (kg)</label>
	                <input type="number" id="weight" class="form-control" placeholder="예: 70.5">
	            </div>
	            <div class="form-group">
	                <label for="muscleMass">골격근량 (kg)</label>
	                <input type="number" id="muscleMass" class="form-control" placeholder="예: 35.2">
	            </div>
	            <div class="form-group">
	                <label for="fatMass">체지방량 (kg)</label>
	                <input type="number" id="fatMass" class="form-control" placeholder="예: 15.8">
	            </div>
	            <div class="form-group">
	                <label for="inbodyScore">인바디 점수</label>
	                <input type="number" id="inbodyScore" class="form-control" placeholder="예: 82">
	            </div>
                 <div class="form-group">
	                <label for="visceralFatLevel">내장지방레벨</label>
	                <input type="number" id="visceralFatLevel" class="form-control" placeholder="예: 8">
	            </div>
	        </div>
	        <div class="modal-footer">
	            <button type="button" class="btn" id="btn-register-inbody">등록하기</button>
	        </div>
	    </div>
	</div>
	<!------------------------------ //인바디 직접 입력 모달창 ------------------------------------->

<script>
$(document).ready(function() {
	// =================================================
    // 초기 설정
    // =================================================
    const contextPath = "${pageContext.request.contextPath}";
    
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

    // =================================================
    // 함수 정의
    // =================================================

   	// 인바디 입력 폼의 모든 값을 비우기
    function resetInbodyForm() {
        $("#height").val("");
        $("#weight").val("");
        $("#muscleMass").val("");
        $("#fatMass").val("");
        $("#inbodyScore").val("");
        $("#visceralFatLevel").val("");
    }
    
    // 리스트 가져오기 함수
    function fetchInbodyList(page) {
        $.ajax({
            url: `\${contextPath}/api/inbody/list`,
            type: "GET",
            data: { userId: targetUserId, crtPage: page },
            dataType: "json",
            success: function(jsonResult) {
                if (jsonResult.result === "success") {
                    renderList(jsonResult.apiData.inbodyList, page, jsonResult.apiData.totalCount);
                    renderPagination(jsonResult.apiData, page);
                    // 첫번째 데이터가 있다면 자동으로 상세정보를 불러옵니다.
                    if(page == 1 && jsonResult.apiData.inbodyList.length > 0) {
                    	fetchInbodyDetail(jsonResult.apiData.inbodyList[0].inbodyId);
                        // 첫 번째 행에 active 클래스 추가
                        $('#inbody-list-tbody tr:first-child').addClass('active');
                    }
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
                <tr data-inbody-id="\${inbody.inbodyId}" style="cursor:pointer;">
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
    
    // 인바디 상세 정보 가져오기
    function fetchInbodyDetail(inbodyId) {
    	$("#nutrition-info-area").show();
        
        $.ajax({
            url: `\${contextPath}/api/inbody/\${inbodyId}`,
            type: "GET",
            dataType: "json",
            success: (jsonResult) => {
                if (jsonResult.result === "success") {
                	renderDetail(jsonResult.apiData);
                }
                else {
                	alert(jsonResult.message);
                }
            },
            error: (xhr, status, error) => console.error("상세 정보 로딩 실패:", error)
        });
    }
	
    // 상세 정보 그리기 (main-box2, main-box3) - CSS 클래스 기반으로 수정
    function renderDetail(data) {
        // 날짜 업데이트
        let dateStr = data.recordDate.substring(0, 10);
        let parts = dateStr.split("-");
        let formatted = parts[0] + "년 " + parts[1] + "월 " + parts[2] + "일";
        $("#detail-date-pill").text(formatted);

        // main-box2: 인바디 상세 정보 패널 업데이트
        const panelHtml = `
            <div class="inbody-analysis-section">
                <div class="panel-head">
                    <span class="label-pill pill-sky">골격근 · 지방분석 (C-I-D그래프)</span>
                    <span class="label-pill pill-rose">내장지방레벨(안전기준 레벨9 이하)</span>
                </div>
                <div class="options-row">
                    <div class="option-group">
                        <div class="radios-compact">
                            <label class="radio sm"><input type="radio" name="cid" \${data.cidType === 'C' ? 'checked' : ''} disabled><span></span> C형</label>
                            <label class="radio sm"><input type="radio" name="cid" \${data.cidType === 'I' ? 'checked' : ''} disabled><span></span> I형</label>
                            <label class="radio sm"><input type="radio" name="cid" \${data.cidType === 'D' ? 'checked' : ''} disabled><span></span> D형</label>
                        </div>
                    </div>
                    <div class="option-group right">
                        <span>레벨 : \${data.visceralFatLevel}</span>
                    </div>
                </div>
            </div>

            <div class="core-indicators-section">
                <div class="panel-head core">
                     <span class="label-pill pill-salmon">핵심지표</span>
                </div>
                <div class="grid-2 tight">
	                <div class="metric-box no-outline">
	                    <div class="metric metric-pbf">
	                        <span class="metric-name">체지방률</span>
	                        <div class="progress progress-pink">
	                            <span class="progress-fill" style="width: \${data.percentBodyFat}%;"></span>
	                        </div>
	                        <span class="metric-value red">\${data.percentBodyFat}%</span>
	                    </div>
	                    <div class="metric metric-control">
	                        <span class="metric-name">체중조절</span>
	                        <div class="metric-pair bold">
	                            <span class="label">지방</span>
	                            <span class="value red">\${data.fatControlKg}kg</span>
	                            <span class="label">근육</span>
	                            <span class="value blue">\${data.muscleControlKg > 0 ? '+' : ''}\${data.muscleControlKg}kg</span>
	                        </div>
	                    </div>
	                </div>
                </div>
            </div>
        `;
        $("#inbody-detail-card").html(panelHtml);

        // main-box3: 영양 정보 업데이트
        const nutritionHtml = `
            <div class="calorie-row">
                <div class="calorie-pill">
                    <span>목표칼로리</span>
                    <strong>\${Math.round(data.targetCalories)}kcal</strong>
                </div>
            </div>
            <div class="mb3-body">
                <div class="mb3-row-top">
                    <div class="mb3-card mb3-card-sm">
                        <h4 class="card-title" style="font-size:16px; font-weight:bold;">일일 단백질 섭취량</h4>
                        <div class="mb3-metrics">
                            <div class="metric-line">
                                <span class="m-label">현재체중(kg)<br><small>(체중 * 00)</small></span>
                                <span class="m-value blue">\${data.weightKg}</span>
                            </div>
                            <div class="metric-line">
                                <span class="m-label">순수필요단백질(g)<br><small>(체중*0.8)</small></span>
                                <span class="m-value blue">\${Math.round(data.requiredProteinG)}</span>
                            </div>
                        </div>
                    </div>
                    <div class="mb3-card">
                        <h4 class="card-title" style="font-size:16px; font-weight:bold;">탄수화물 · 단백질 · 지방</h4>
                        <table class="mb3-table">
                            <thead>
                                <tr>
                                    <th>항목</th>
                                    <th>탄수화물</th>
                                    <th>단백질</th>
                                    <th>지방</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>비율(5:3:2)</td>
                                    <td>\${data.carbRatio / 100}</td>
                                    <td>\${data.proteinRatio / 100}</td>
                                    <td>\${data.fatRatio / 100}</td>
                                </tr>       
                                <tr>
                                    <td>필요칼로리(kcal)</td>
                                    <td>\${Math.round(data.targetCarbKcal)}</td>
                                    <td>\${Math.round(data.targetProteinKcal)}</td>
                                    <td>\${Math.round(data.targetFatKcal)}</td>
                                </tr>
                                <tr>
                                    <td>순수필요무게(g)</td>
                                    <td>\${Math.round(data.targetCarbG)}</td>
                                    <td>\${Math.round(data.targetProteinG)}</td>
                                    <td>\${Math.round(data.targetFatG)}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="mb3-card mb3-card-full">
                    <h4 class="card-title" style="font-size:16px; font-weight:bold;">일일식단</h4>
                    <table class="mb3-table">
                        <thead>
                            <tr>
                                <th>시간</th>
                                <th>칼로리(kcal)</th>
                                <th>탄수화물(g)</th>
                                <th>단백질(g)</th>
                                <th>지방(g)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>아침</td>
                                <td>\${Math.round(data.breakfastKcal)}</td>
                                <td>\${Math.round(data.breakfastCarbG)}</td>
                                <td>\${Math.round(data.breakfastProteinG)}</td>
                                <td>\${Math.round(data.breakfastFatG)}</td>
                            </tr>
                            <tr>
                                <td>점심</td>
                                <td>\${Math.round(data.lunchKcal)}</td>
                                <td>\${Math.round(data.lunchCarbG)}</td>
                                <td>\${Math.round(data.lunchProteinG)}</td>
                                <td>\${Math.round(data.lunchFatG)}</td>
                            </tr>
                            <tr>
                                <td>저녁</td>
                                <td>\${Math.round(data.dinnerKcal)}</td>
                                <td>\${Math.round(data.dinnerCarbG)}</td>
                                <td>\${Math.round(data.dinnerProteinG)}</td>
                                <td>\${Math.round(data.dinnerFatG)}</td>
                            </tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td>총량</td>
                                <td>\${Math.round(data.breakfastKcal + data.lunchKcal + data.dinnerKcal)}</td>
                                <td>\${Math.round(data.breakfastCarbG + data.lunchCarbG + data.dinnerCarbG)}</td>
                                <td>\${Math.round(data.breakfastProteinG + data.lunchProteinG + data.dinnerProteinG)}</td>
                                <td>\${Math.round(data.breakfastFatG + data.lunchFatG + data.dinnerFatG)}</td>
                            </tr>
                             <tr>
                                <td>칼로리합</td>
                                <td></td>
                                <td>\${Math.round((data.breakfastCarbG + data.lunchCarbG + data.dinnerCarbG)*4)}</td>
                                <td>\${Math.round((data.breakfastProteinG + data.lunchProteinG + data.dinnerProteinG)*4)}</td>
                                <td>\${Math.round((data.breakfastFatG + data.lunchFatG + data.dinnerFatG)*9)}</td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        `;
        $("#nutrition-info-area").html(nutritionHtml);
    }
    
    // =================================================
    // 이벤트 핸들러
    // =================================================
	
    // 인바디 직접입력 버튼 클릭시 모달 열기
    $("#btn-open-modal").on("click", function() {
    	resetInbodyForm();
        $("#manual-input-modal").show();
    });

    // 모달 닫기 버튼
    $("#btn-close-modal").on("click", function() {
        $("#manual-input-modal").hide();
    });

    // 등록하기 버튼 클릭 이벤트
    $("#btn-register-inbody").on("click", function() {
    
	    // 1. 사용자가 입력한 데이터 모으기
	    const inbodyData = {
	        height: parseFloat($("#height").val()),
	        weightKg: parseFloat($("#weight").val()),
	        muscleMassKg: parseFloat($("#muscleMass").val()),
	        fatMassKg: parseFloat($("#fatMass").val()),
	        inbodyScore: parseInt($("#inbodyScore").val()),
	        visceralFatLevel: parseInt($("#visceralFatLevel").val())
	    };
	
	    // 2. 유효성 검사
	    if (!inbodyData.height || !inbodyData.weightKg || !inbodyData.muscleMassKg || !inbodyData.fatMassKg || !inbodyData.inbodyScore || !inbodyData.visceralFatLevel) {
	        alert("모든 값을 숫자로 정확히 입력해주세요.");
	        return;
	    }
	
	    // 3. AJAX를 통해 서버에 데이터 전송
	    $.ajax({
	        url: `\${contextPath}/api/inbody/manual-add`,
	        type: "POST",
	        contentType: "application/json",
	        data: JSON.stringify(inbodyData),
	        dataType: "json",
	        success: function(jsonResult) {
	            if (jsonResult.result === "success") {
	                alert("인바디 정보가 성공적으로 등록되었습니다.");
	                $("#manual-input-modal").hide();
	                fetchInbodyList(1);
	            } else {
	                alert("등록에 실패했습니다: " + jsonResult.message);
	            }
	        },
	        error: function(xhr, status, error) {
	            console.error("인바디 등록 실패:", error);
	            alert("등록 중 오류가 발생했습니다.");
	        }
	    });
	});
    
    // 리스트의 행(tr) 클릭 이벤트
    $("#inbody-list-tbody").on("click", "tr[data-inbody-id]", function() {
        fetchInbodyDetail($(this).data("inbody-id"));
        // 활성화된 행 스타일링
        $(this).addClass('active').siblings().removeClass('active');
    });

    // 삭제 버튼 클릭 이벤트
    $("#inbody-list-tbody").on("click", ".btn-delete", function(e) {
        e.stopPropagation(); // 행 클릭 이벤트가 같이 실행되는 것을 방지
        if (!confirm("정말 삭제하시겠습니까?")) {
            return;
        }
        
        const inbodyId = $(this).data("inbody-id");

        $.ajax({
            url: `\${contextPath}/api/inbody/\${inbodyId}`,
            type: "DELETE",
            dataType: "json",
            success: function(jsonResult) {
                if (jsonResult.result === "success") {
                    alert("삭제되었습니다.");
                    fetchInbodyList(1);
                    
                    // 상세 정보 영역 초기화
                    $("#detail-date-pill").text("날짜를 선택해주세요");
                    $("#inbody-detail-card").empty();
                    $("#nutrition-info-area").hide();

                } else {
                    alert(jsonResult.message);
                }
            },
            error: function(xhr, status, error) {
                console.error("삭제 요청 실패:", error);
                alert("삭제 처리 중 서버에서 오류가 발생했습니다.");
            }
        });
    });

    // 페이지네이션 버튼 클릭 이벤트
    $("#inbody-pagination").on("click", ".page", function() {
        fetchInbodyList($(this).data("page"));
    });

    // =================================================
    // 페이지 최초 로딩
    // =================================================
    fetchInbodyList(1);
});
</script>

</body>
</html>