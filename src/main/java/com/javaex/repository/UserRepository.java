package com.javaex.repository;

import java.util.Map;

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
	
    /** 회원의 담당 트레이너 조회 (없으면 null) */
    public Map<String, Object> selectTrainerByMemberId(int memberId) {
        // 반환: {trainerId: 4, trainerName: "강호동"} 형태의 Map
        return sqlSession.selectOne("user.selectTrainerByMemberId", memberId);
    }
	
}
