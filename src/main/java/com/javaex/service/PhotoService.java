package com.javaex.service;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.javaex.repository.PhotoRepository;
import com.javaex.util.FileStorage;
import com.javaex.vo.PhotoVO;

@Service
public class PhotoService {
	private final PhotoRepository repo;
	private final FileStorage fileStorage;

	public PhotoService(PhotoRepository repo, FileStorage fileStorage) {
		this.repo = repo;
		this.fileStorage = fileStorage;
	}

	/**
	 * 사진 저장 (운동/식단 구분)
	 * 
	 * @param file      업로드 파일 (이미지)
	 * @param photoType "body" 또는 "meal"
	 * @param userId    사진 주인(회원)
	 * @param writerId  작성자(지금은 userId와 동일하게 사용)
	 * @return DB에 기록된 최종 PhotoVO (uploadDate 포함)
	 */
	public PhotoVO saveUserPhoto(MultipartFile file, String photoType, int userId, int writerId) {
		// 0) 최소 검증 (간단)
		if (file == null || file.isEmpty()) {
			throw new IllegalArgumentException("파일이 비어있습니다.");
		}
		if (!("body".equals(photoType) || "meal".equals(photoType))) {
			throw new IllegalArgumentException("photoType 은 'body' 또는 'meal' 이어야 합니다.");
		}

		// 1) 오늘 날짜로 폴더 경로용 문자열 구성 (예: 2025-08-27)
		String ymd = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

		// 2) 디스크에 저장하고 접근 URL 반환 (예: /upload/{userId}/YYYY/MM/DD/uuid.jpg)
		String photoUrl;
		try {
			photoUrl = fileStorage.saveImage(file, userId, ymd);
		} catch (IOException e) {
			throw new IllegalStateException("파일 저장 중 오류 발생", e);
		}

		// 3) DB INSERT (생성된 photoId 반환)
		Integer photoId = repo.insertUserPhoto(photoType, photoUrl, userId, writerId);
		if (photoId == null) {
			throw new IllegalStateException("사진 저장에 실패했습니다.(photoId null)");
		}

		// 4) 방금 저장된 레코드 재조회 → uploadDate 포함해서 반환
		return repo.selectUserPhotoById(photoId);
	}

	/**
	 * 작성자 지정 안 할 때(userId == writerId) 편의 메서드
	 */
	public PhotoVO saveUserPhoto(MultipartFile file, String photoType, int userId) {
		return saveUserPhoto(file, photoType, userId, userId);
	}
}
