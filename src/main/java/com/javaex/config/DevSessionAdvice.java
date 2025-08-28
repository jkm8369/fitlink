/*
package com.javaex.config;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import jakarta.servlet.http.HttpSession;

@ControllerAdvice
public class DevSessionAdvice {

	@ModelAttribute
	public void injectDevSession(HttpSession session) {
		if (session.getAttribute("trainerId") == null) {
			session.setAttribute("trainerId", 1); // 트레이너 고정
		}
		if (session.getAttribute("memberId") == null) {
			session.setAttribute("memberId", 3); // 회원 고정
		}
	}
}
*/