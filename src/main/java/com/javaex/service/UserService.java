package com.javaex.service;

import java.util.Map;

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
	
    // 회원의 담당 트레이너 조회
    public Map<String, Object> selectTrainerByMemberId(int memberId) {
        return userRepository.selectTrainerByMemberId(memberId);
    }
	
    
    // 특정 회원의 기본 정보를 조회 (jsp에서 이름 표시용)
    public UserVO exeGetMemberInfo(int memberId) {
        System.out.println("UserService.exeGetMemberInfo()");
        
        return userRepository.selectUserByNo(memberId);
    }
    
}
