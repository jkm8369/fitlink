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
	
    // -- 회원의 담당 트레이너 조회 (없으면 null)
    public Map<String, Object> selectTrainerByMemberId(int memberId) {
        // 반환: {trainerId: 4, trainerName: "강호동"} 형태의 Map
        return sqlSession.selectOne("user.selectTrainerByMemberId", memberId);
    }
    
    
	// -- user_id로 특정 사용자의 정보를 조회
    public UserVO selectUserByNo(int userId) {
        System.out.println("UserRepository.selectUserByNo()");
        return sqlSession.selectOne("user.selectUserByNo", userId);
    }
    
    
    // -- 특정 회원이 특정 트레이너에게 배정되었는지 확인(보안)
    public int checkMemberAssignment(Map<String, Object> params) {
        System.out.println("UserRepository.checkMemberAssignment()");
        return sqlSession.selectOne("user.checkMemberAssignment", params);
    }
    
    
	
}
