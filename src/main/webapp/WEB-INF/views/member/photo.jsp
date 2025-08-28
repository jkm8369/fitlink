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
					<c:import url="/WEB-INF/views/include/aside-member.jsp"></c:import>
				</div>
			</aside>
			<!-- ------aside------ -->

			<main id="photo-page" data-member-id="${memberId}">
				<!-- 1. 제목 -->
				<div class="page-header">
					<h3 class="page-title">Photo</h3>
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
				<input type="file" id="photo-file" accept="image/*" style="display: none;">
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

	<!-------------------------- script -------------------------->
	<script>
		// 절대 URL 생성 ("/upload/xxx" -> "http://localhost:8888/upload/xxx")
		function abs(path){
		  if (!path) return '';
		  return path.startsWith('http') ? path : (window.location.origin + path);
		}
		
		// 리스트 렌더(간단/안정) — 템플릿 문자열 대신 Image 객체로 src 지정
		function renderList(gridId, rows){
		  const $g = $(gridId).empty();
		  if (!rows || rows.length === 0) return;
		
		  rows.forEach(function(p){
		    const li  = $('<li class="ph-thumb"></li>');
		    const img = new Image();
		    img.alt   = 'photo';
		    img.src   = abs(p.photoUrl) + '?t=' + Date.now(); // 캐시 우회
		    li.append(img);
		    li.append('<button class="ph-remove" type="button" disabled>×</button>');
		    $g.append(li);
		  });
		}
		
		// 목록 불러오기
		function load(type){
		  $.get('/api/photo/list', { photoType: type, limit: 12 })
		    .done(function(res){
		      if (res && res.ok){
		        renderList(type === 'body' ? '#photo-grid-body' : '#photo-grid-meal', res.data || []);
		      }
		    });
		}
		
		// 파일 선택 트리거 (운동/식단 버튼)
		$(document).on('click', '.btn-add-photo', function(){
		  $('#photo-file').data('ptype', $(this).data('type')).val('').click();
		});
		
		// 업로드
		$('#photo-file').on('change', function(){
		  const file = this.files && this.files[0];
		  if (!file) return;
		
		  const type = $(this).data('ptype');             // body | meal
		  const today = new Date().toISOString().slice(0,10); // YYYY-MM-DD
		
		  const fd = new FormData();
		  fd.append('file', file);
		  fd.append('photoType', type);
		  fd.append('targetDate', today);
		
		  $.ajax({
		    url: '/api/photo/upload',
		    method: 'POST',
		    data: fd,
		    processData: false,
		    contentType: false
		  }).done(function(res){
		    if (res && res.ok){
		      // 업로드 성공 후 해당 섹션만 리로드
		      load(type);
		    } else {
		      alert('업로드 실패');
		    }
		  }).fail(function(){
		    alert('업로드 실패');
		  });
		});
		
		// 초기 로딩
		$(function(){
		  load('body');
		  load('meal');
		});
	</script>

</body>
</html>