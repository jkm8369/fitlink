package com.javaex.repository;

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
}
