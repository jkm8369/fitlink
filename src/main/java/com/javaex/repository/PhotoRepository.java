package com.javaex.repository;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.javaex.vo.PhotoVO;

@Repository
public class PhotoRepository {
	private final SqlSessionTemplate sqlSession;

	public PhotoRepository(SqlSessionTemplate sqlSession) {
		this.sqlSession = sqlSession;
	}

	// ------------------------------------------------------------
	// 1) 사진 INSERT
	// - IN : photoType, photoUrl, userId, writerId
	// - OUT: 생성된 photoId (useGeneratedKeys 로 PhotoVO/Map에 채워짐)
	// ------------------------------------------------------------
	public Integer insertUserPhoto(String photoType, String photoUrl, int userId, int writerId) {
		Map<String, Object> params = new HashMap<>();
		params.put("photoType", photoType); // 'body' 또는 'meal'
		params.put("photoUrl", photoUrl); // /upload/... 경로
		params.put("userId", userId); // 사진 주인
		params.put("writerId", writerId); // 작성자(회원/트레이너)

		sqlSession.insert("photo.insertUserPhoto", params);

		// useGeneratedKeys 로 채워진 photoId 꺼내기
		Object key = params.get("photoId");
		return (key instanceof Number) ? ((Number) key).intValue() : null;
	}

	// ------------------------------------------------------------
	// 2) 단건 조회
	// - 방금 INSERT 한 row 확인용
	// - writerName 은 JOIN 쿼리일 때만 채워짐 (현재는 null)
	// ------------------------------------------------------------
	public PhotoVO selectUserPhotoById(int photoId) {
		return sqlSession.selectOne("photo.selectUserPhotoById", photoId);
	}
}
