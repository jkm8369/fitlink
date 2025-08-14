<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>InBody&Meal</title>
        <link rel="stylesheet" href="../../assets/css/reset.css" />
        <link rel="stylesheet" href="../../assets/css/form_member.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    </head>

    <body>
        <!-- 인바디 등록 모달 -->
        <div class="modal-overlay is-open" aria-hidden="true">
            <div class="modal-container" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
                <h3 class="modal-title">이 인바디를 등록하시겠습니까?</h3>

                <div class="modal-content">
                    <div class="preview">
                        <!-- 미리보기 이미지 경로 교체 -->
                        <img src="PATH/inbody-scan-sample.png" alt="InBody 미리보기">
                    </div>
                </div>

                <div class="modal-actions">
                    <button class="btn btn-primary">등록</button>
                    <button class="btn btn-ghost">취소</button>
                </div>

                <button class="modal-close" aria-label="닫기" data-close>
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
        </div>
    </body>

</html>