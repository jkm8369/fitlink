package com.javaex.apiController;

import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.javaex.service.MemberListService;

@RestController
public class UserApiController {
	
	private final MemberListService service;

    public UserApiController(MemberListService service) {
        this.service = service;
    }

    // 로그인아이디로 유저 기초정보 조회
    @GetMapping("/api/users/by-login/{loginId}")
    public Map<String, Object> getByLoginId(@PathVariable String loginId) {
        Map<String, Object> data = service.getUserBasicByLoginId(loginId);
        boolean ok = (data != null);
        return Map.of("ok", ok, "data", data);
    }
}
