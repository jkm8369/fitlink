package com.javaex.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.javaex.vo.InbodyVO;

@Repository
public class InbodyRepository {

	@Autowired
	private SqlSession sqlSession;
	
	
    // 특정 회원의 전체 인바디 기록 수를 가져오기 (페이징 계산용)
    public int selectTotalCount(int userId) {
        System.out.println("InbodyRepository.selectTotalCount()");
        
        return sqlSession.selectOne("inbody.selectTotalCount", userId);
    }
   
    // 특정 회원의 인바디 기록 리스트를 페이징하여 가져오기
    public List<InbodyVO> selectListByUserId(Map<String, Object> params) {
        System.out.println("InbodyRepository.selectListByUserId()");
        
        return sqlSession.selectList("inbody.selectListByUserId", params);
    }

    // 인바디 ID로 특정 기록의 상세 정보를 가져오기
    public InbodyVO selectOneByInbodyId(int inbodyId) {
        System.out.println("InbodyRepository.selectOneByInbodyId()");
        
        return sqlSession.selectOne("inbody.selectOneByInbodyId", inbodyId);
    }
  
    // 새로운 인바디 기록을 데이터베이스에 저장
    public int insert(InbodyVO inbodyVO) {
        System.out.println("InbodyRepository.insert()");
        
        sqlSession.insert("inbody.insert", inbodyVO);
        
        return inbodyVO.getInbodyId();
    }

    // 특정 인바디 기록을 삭제
    public int delete(int inbodyId) {
        System.out.println("InbodyRepository.delete()");
        
        return sqlSession.delete("inbody.delete", inbodyId);
    }
    
}
