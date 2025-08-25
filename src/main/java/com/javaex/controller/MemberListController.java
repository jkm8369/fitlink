package com.javaex.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.javaex.service.MemberListService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/trainer/member-list")
public class MemberListController {

    private final MemberListService service;

    @Autowired
    public MemberListController(MemberListService service){
        this.service = service;
    }

    // 공용: 세션에서 ID 보장 (if/else 버전) - 기본값: 트레이너=1, 회원=3
    private int ensureId(HttpSession session, String who, Integer forceId) {
        boolean isTrainer = "trainer".equalsIgnoreCase(who);

        String key;
        int def;
        if (isTrainer) {
            key = "trainerId";
            def = 1; // 기본 트레이너
        } else {
            key = "memberId";
            def = 3; // 기본 회원
        }

        if (forceId != null) {
            session.setAttribute(key, forceId); // 디버깅용 강제 세팅
        }

        Object v = session.getAttribute(key);
        if (v instanceof Integer) {
            return (Integer) v;
        }

        session.setAttribute(key, def);
        return def;
    }

    /** (A) 멤버리스트 페이지: 표 데이터 주입 후 JSP 반환 */
    @GetMapping
    public String page(@RequestParam(required = false) Integer forceId,
                       HttpSession session, Model model) {

        int trainerId = ensureId(session, "trainer", forceId); // 기본 1 보장 (필요시 ?forceId=로 강제)
        List<Map<String, Object>> rows = service.getMemberListForTrainer(trainerId);

        model.addAttribute("rows", rows);
        model.addAttribute("trainerId", trainerId);
        return "trainer/member-list"; // 이미 만들어둔 JSP 파일명
    }
}