package com.javaex.config.auth; // 패키지 경로는 프로젝트에 맞게 생성하세요.

import org.springframework.web.servlet.HandlerInterceptor;

import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		System.out.println("AuthInterceptor: preHandle()");

		// ✅ 미로그인 요청에 새 세션을 만들지 않음
		HttpSession session = request.getSession(false);

		UserVO authUser = (session == null) ? null : (UserVO) session.getAttribute("authUser");

		if (authUser == null) {
			System.out.println("로그인이 필요합니다.");
			response.sendRedirect(request.getContextPath() + "/user/loginform");
			return false;
			
		} else {
			System.out.println("인증된 사용자 접근");
			return true;
		}
	}
}
