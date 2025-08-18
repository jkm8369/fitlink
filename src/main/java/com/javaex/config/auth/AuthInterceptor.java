package com.javaex.config.auth; // 패키지 경로는 프로젝트에 맞게 생성하세요.

import org.springframework.web.servlet.HandlerInterceptor;

import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthInterceptor implements HandlerInterceptor {

	/**
	 * preHandle 메소드는 컨트롤러의 메소드가 실행되기 '전'에 호출됩니다.
	 * 이 메소드가 true를 반환하면 원래 요청했던 컨트롤러 메소드가 실행되고,
	 * false를 반환하면 컨트롤러 메소드가 실행되지 않습니다.
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		System.out.println("AuthInterceptor: preHandle()");
		
		// 1. 세션을 가져옵니다.
		HttpSession session = request.getSession();
		
		// 2. 세션에서 로그인 정보("authUser")를 꺼냅니다.
		UserVO authUser = (UserVO)session.getAttribute("authUser");
		
		// 3. 로그인 여부를 확인합니다.
		if(authUser == null) {
			// --- 로그인하지 않은 경우 ---
			System.out.println("인증되지 않은 사용자 접근");
			
			// 로그인 페이지로 리다이렉트(강제 이동)시킵니다.
			response.sendRedirect(request.getContextPath() + "/user/loginform");
			
			// 컨트롤러를 실행하지 않고 여기서 처리를 끝냅니다.
			return false; 
			
		} else {
			// --- 로그인한 경우 ---
			System.out.println("인증된 사용자 접근");
			
			// 예정대로 컨트롤러를 실행합니다.
			return true;
		}
	}

}
