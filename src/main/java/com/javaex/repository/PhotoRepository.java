package com.javaex.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.javaex.vo.PhotoVO;

@Repository
public class PhotoRepository {

	private final SqlSession sqlSession;

	public PhotoRepository(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	public int insert(PhotoVO vo) {
		return sqlSession.insert("photo.insertUserPhoto", vo);
	}

	public List<PhotoVO> selectList(Map<String, Object> p) {
		return sqlSession.selectList("photo.selectUserPhotos", p);
	}
	
	public PhotoVO selectByIdAndUser(int photoId, int userId) {
        Map<String,Object> p = new HashMap<>();
        p.put("photoId", photoId);
        p.put("userId", userId);
        return sqlSession.selectOne("photo.selectByIdAndUser", p);
    }

    // 회원 삭제 전용 (writer까지 확인)
    public int deleteByIdAndUserAndWriter(int photoId, int userId, int writerId) {
        Map<String,Object> p = new HashMap<>();
        p.put("photoId", photoId);
        p.put("userId", userId);
        p.put("writerId", writerId);
        return sqlSession.delete("photo.deleteByIdAndUserAndWriter", p);
    }
	
    // 삭제(소유권 조건)
    public int deleteByIdAndUser(int photoId, int userId) {
        Map<String,Object> p = new HashMap<>();
        p.put("photoId", photoId);
        p.put("userId", userId);
        return sqlSession.delete("photo.deleteByIdAndUser", p);
    }
    
    // 단건 조회 (photoId만)
    public PhotoVO selectById(int photoId) {
        return sqlSession.selectOne("photo.selectById", photoId);
    }
    
    public List<Map<String,Object>> selectCalendarCounts(Map<String,Object> p){
        return sqlSession.selectList("photo.selectCalendarCounts", p);
    }

}
