<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>사진</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reset.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/include.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js" crossorigin="anonymous"></script>
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
					<c:import url="/WEB-INF/views/include/aside-member.jsp"></c:import>
				</div>
			</aside>
			<!-- ------aside------ -->

			<main>
				<!-- 1. 제목 -->
				<div class="page-header">
					<h3 class="page-title">View</h3>
					<p class="page-subtitle">2025년 7월 20일</p>
				</div>
				<!-- //1. 제목 -->

				<!-- 2. 달력 -->
				<div class="calendar">
					<!-- 나중에 이 자리에 실제 달력 코드가 들어갑니다. -->
				</div>
				<!-- //2. 달력 -->

				<!-- 3. 구분선 -->
				<div class="line"></div>
				<!-- //3. 구분선 -->

				<!-- 4. 사진 갤러리 -->
				<div class="photo-gallery-section">
					<div class="gallery-header">
						<h4 class="gallery-title">운동사진</h4>
						<button class="btn-add-photo" data-type="body">
							<i class="fa-regular fa-image"></i> 사진 등록
						</button>
					</div>
					
					<ul class="photo-grid" id="photo-grid-body"></ul>
				</div>

				<div class="photo-gallery-section">
					<div class="gallery-header">
						<h4 class="gallery-title">식단사진</h4>
						<button class="btn-add-photo" data-type="meal">
							<i class="fa-regular fa-image"></i> 사진 등록
						</button>
					</div>
					
					<ul class="photo-grid" id="photo-grid-meal"></ul>
				</div>
				<!-- //4. 사진 갤러리 -->
			</main>
		</div>

		<footer>
			<p>Copyright © 2025. FitLink All rights reserved.</p>
		</footer>

	</div>

	<script>
	/* =========================================================
	   [Photo View Page Script]
	   - 버튼 클릭 → 파일선택 → Ajax 업로드 → 썸네일 그리드에 추가
	   - endpoint: POST /api/photos/upload (multipart/form-data)
	   - form-data: file, photoType
	   ========================================================= */
	
	$(document).ready(function () {
	
	  /* -------------------------------------------------------
	     0) 상수(엔드포인트 / 허용확장자 / 그리드 ID)
	     ------------------------------------------------------- */
	  let API_PHOTO_UPLOAD_URL = "/api/photos/upload";
	  let ALLOWED_IMAGE_TYPES = ["image/jpeg", "image/png", "image/gif", "image/webp"];
	
	  let GRID_ID_BY_TYPE = {
	    "body": "#photo-grid-body",
	    "meal": "#photo-grid-meal"
	  };
	
	  /* -------------------------------------------------------
	     1) “사진 등록” 버튼 클릭 → 파일 선택창 오픈
	     ------------------------------------------------------- */
	  $(document).on("click", ".btn-add-photo", function () {
	    let photoType = $(this).data("type"); // "body" | "meal"
	    openFilePickerForPhotoType(photoType);
	  });
	
	  /* -------------------------------------------------------
	     2) 파일선택 오픈 (동적으로 input[type=file] 생성)
	     ------------------------------------------------------- */
	  function openFilePickerForPhotoType(photoType) {
	    // 이미 같은 타입의 히든 인풋이 있으면 재사용
	    let $input = $("#hidden-file-input-" + photoType);
	    if ($input.length === 0) {
	      $input = $("<input>", {
	        type: "file",
	        id: "hidden-file-input-" + photoType,
	        accept: "image/*",
	        style: "display:none"
	      }).appendTo(document.body);
	
	      // change 이벤트 1회 바인딩
	      $input.on("change", function () {
	        let fileObject = this.files && this.files[0] ? this.files[0] : null;
	        if (!fileObject) { return; }
	
	        // 간단한 유효성 체크 (MIME)
	        if ($.inArray(fileObject.type, ALLOWED_IMAGE_TYPES) === -1) {
	          alert("이미지 파일만 업로드할 수 있습니다 (jpg, png, gif, webp).");
	          $(this).val(""); // 선택 초기화
	          return;
	        }
	
	        // 업로드 요청
	        uploadPhotoFileByAjax(fileObject, photoType);
	        // 동일 파일 다시 선택 가능하도록 초기화
	        $(this).val("");
	      });
	    }
	
	    // 파일 선택 다이얼로그 오픈
	    $input.trigger("click");
	  }
	
	  /* -------------------------------------------------------
	     3) Ajax 업로드 (multipart/form-data)
	     - 성공 시 썸네일을 해당 그리드에 추가
	     ------------------------------------------------------- */
	  function uploadPhotoFileByAjax(fileObject, photoType) {
	    let formData = new FormData();
	    formData.append("file", fileObject);
	    formData.append("photoType", photoType);
	    // userId / writerId 는 서버에서 세션 memberId로 처리(DevSessionAdvice)
	
	    $.ajax({
	      url: API_PHOTO_UPLOAD_URL,
	      type: "POST",
	      data: formData,
	      processData: false,  // FormData 그대로 전송
	      contentType: false,  // 멀티파트 헤더 자동 설정
	      success: function (response) {
	        if (response && response.ok === true && response.data) {
	          let photoData = response.data; // {photoId, photoUrl, photoType, ...}
	          appendPhotoThumbnailToGrid(photoData);
	        } else {
	          alert(response && response.message ? response.message : "업로드에 실패했습니다.");
	        }
	      },
	      error: function () {
	        alert("서버 통신 중 오류가 발생했습니다.");
	      }
	    });
	  }
	
	/* -------------------------------------------------------
	   4) 썸네일 DOM 생성 후 그리드에 추가
	   - 네모칸(li) + img + 삭제(X) 버튼 자리(추후 확장)
	   ------------------------------------------------------- */
	   function appendPhotoThumbnailToGrid(photoData) {
	  	  let gridSelector = GRID_ID_BY_TYPE[photoData.photoType];
	  	  if (!gridSelector) { gridSelector = "#photo-grid-body"; }
	
	  	  // <li class="ph-thumb" data-photo-id="..."><img ...><button class="ph-remove">×</button></li>
	  	  let $li = $("<li>", { "class": "ph-thumb", "data-photo-id": photoData.photoId });
	
	  	  let $img = $("<img>", {
	  	    src: photoData.photoUrl,
	  	    alt: "photo-" + photoData.photoId
	  	  });
	
	  	  let $removeBtn = $("<button>", {
	  	    "class": "ph-remove",
	  	    "type": "button",
	  	    "title": "삭제"
	  	  }).text("×");
	
	  	  $li.append($img).append($removeBtn);
	
	  	  // 최신이 앞에 오게 prepend (원하면 append로 변경)
	  	  $(gridSelector).prepend($li);
	  	}

	
		/* -------------------------------------------------------
		   5) 삭제 버튼 클릭 → Ajax 호출 → 성공 시 DOM 제거
		   ------------------------------------------------------- */
		$(document).on("click", ".ph-thumb .ph-remove", function () {
		  let $thumb = $(this).closest(".ph-thumb");
		  let photoId = $thumb.data("photo-id");
		
		  if (!photoId) {
		    alert("잘못된 사진입니다.");
		    return;
		  }
		
		  if (!confirm("이 사진을 삭제하시겠습니까?")) {
		    return;
		  }
		
		  $.ajax({
		    url: "/api/photos/" + encodeURIComponent(photoId),
		    type: "DELETE",
		    success: function (response) {
		      if (response && response.ok === true) {
		        $thumb.remove();
		      } else {
		        alert(response && response.message ? response.message : "삭제 실패");
		      }
		    },
		    error: function () {
		      alert("서버 통신 중 오류가 발생했습니다.");
		    }
		  });
		});
	});
	</script>

</body>
</html>