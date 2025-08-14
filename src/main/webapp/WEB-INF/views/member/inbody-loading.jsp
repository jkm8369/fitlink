<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>InBody&Meal</title>
    <link rel="stylesheet" href="../../assets/css/reset.css" />
    <link rel="stylesheet" href="../../assets/css/form_member.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
</head>

<body>
    <!-- 상태 모달 -->
    <div class="modal-overlay is-open" id="statusModal" aria-hidden="false">
        <div class="modal-container modal-status" role="dialog" aria-modal="true" aria-labelledby="statusTitle">
            <div class="status-icon" aria-hidden="true"></div>
            <h3 id="statusTitle" class="status-title">업로드 중</h3>
            <p class="status-desc">인바디를 등록 중입니다.<br>잠시만 기다려주세요.</p>
        </div>
    </div>
</body>

</html>