package com.javaex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

/**
 * ✅ 뷰 컨트롤러(View Controller) - JSP(화면 파일)의 경로를 반환하는 컨트롤러입니다. - 여기서는 "페이지 이동"만
 * 담당하고, 데이터(JSON) 응답은 하지 않습니다.
 */
@Controller
@RequestMapping("/member")

public class MemberController {

    /** 상단 달력 + 리스트 페이지 */
    @GetMapping("/booking-status")
    public String showBookingStatus(HttpSession session) {
        // [개발용 임시] 로그인 세션 주입 (운영에선 제거하세요)
        if (session.getAttribute("LOGIN_USER_ID") == null) {
            session.setAttribute("LOGIN_USER_ID", 1);
        }
        return "member/booking-status";
    }

    /**
     * 모달(iframe) 페이지
     * - /member/booking-insert?date=YYYY-MM-DD
     * - date가 없으면 오늘 날짜로 리다이렉트
     */
    @GetMapping("/booking-insert")
    public String showBookingInsertPage(
            @RequestParam(name = "date", required = false) String date, HttpSession session, Model model) {

        // [개발용 임시] 로그인 세션 주입 (운영에선 제거)
        if (session.getAttribute("LOGIN_USER_ID") == null) {
            session.setAttribute("LOGIN_USER_ID", 1);
        }

        if (date == null || date.isBlank()) {
            // date가 없으면 오늘로 리다이렉트 (중복 매핑 방지 + UX 안전장치)
            String today = new java.text.SimpleDateFormat("yyyy-MM-dd")
                    .format(new java.util.Date());
            return "redirect:/member/booking-insert?date=" + today;
        }

        // 필요하면 JSP에서 ${date}로 사용 가능
        model.addAttribute("date", date);
        return "member/booking-insert";
    }
}
