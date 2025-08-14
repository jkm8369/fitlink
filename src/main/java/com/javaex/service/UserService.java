package com.javaex.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaex.repository.UserRepository;
import com.javaex.vo.UserVO;

@Service
public class UserService {

	@Autowired
	private UserRepository userRepository;
	
	// 로그인
	public UserVO exeLogin(UserVO userVO) {
		System.out.println("UserService.exeLogin()");
		
		UserVO authUser = userRepository.userSelectOneByIdPw(userVO);
		
		
		return authUser;
	}
	
}
