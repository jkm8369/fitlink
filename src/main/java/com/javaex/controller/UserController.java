package com.javaex.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.javaex.service.UserService;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value= "/user")
public class UserController {

	@Autowired
	private UserService userService;
	
	//로그인 폼
	@RequestMapping(value="/loginform", method = {RequestMethod.GET, RequestMethod.POST})
	public String loginform() {
		System.out.println("UserController.loginform()");
		
		return "/user/loginform";
	}
	
	//로그인
	@RequestMapping(value="/login", method= {RequestMethod.GET, RequestMethod.POST})
	public String login(@ModelAttribute UserVO userVO, HttpSession session) {
		System.out.println("UserController.login()");
		
		UserVO authUser = userService.exeLogin(userVO);
		
		session.setAttribute("authUser", authUser);
		
		
		return "";
	}
	
	//로그아웃
	@RequestMapping(value="/logout", method= {RequestMethod.GET, RequestMethod.POST})
	public String logout(HttpSession session) {
		System.out.println("UserController.logout()");
		
		session.invalidate();
		
		return "redirect:/";
	}
	
}
