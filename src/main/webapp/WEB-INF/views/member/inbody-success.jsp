<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
    <!-- 성공 모달 -->
    <div class="modal-overlay is-open" id="successModal" aria-hidden="false">
        <div class="modal-container modal-status" role="dialog" aria-modal="true" aria-labelledby="successTitle">
            <div aria-hidden="true">
                <!-- 깔끔한 SVG 체크 아이콘 -->
                <svg viewBox="0 0 72 72" width="72" height="72">
                    <circle cx="36" cy="36" r="32" fill="#F1FAF5" stroke="#D7EFE4" />
                    <path d="M24 36.5l8 8 16-16" fill="none" stroke="#22C55E" stroke-width="4" stroke-linecap="round"
                        stroke-linejoin="round" />
                </svg>
            </div>
            <p id="successTitle" class="status-text">인바디 등록이 완료되었습니다.</p>
            <button class="modal-close" aria-label="닫기" data-close>
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
    </div>
</body>

</html>