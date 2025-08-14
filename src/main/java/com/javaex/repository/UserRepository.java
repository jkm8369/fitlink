package com.javaex.repository;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.javaex.vo.UserVO;

@Repository
public class UserRepository {

	@Autowired
	private SqlSession sqlSession;
	
	// 로그인 user 정보 가져오기 (id password)
	public UserVO userSelectOneByIdPw(UserVO userVO) {
		System.out.println("UserRepository.userSelectOneByIdPw()");
		
		UserVO authUser = sqlSession.selectOne("user.selectOneByIdPw", userVO);
		
		System.out.println(authUser);
		
		return authUser;
	}
	
}
