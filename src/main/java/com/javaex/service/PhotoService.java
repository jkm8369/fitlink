package com.javaex.service;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.javaex.repository.PhotoRepository;
import com.javaex.vo.PhotoVO;

@Service
public class PhotoService {
	private final PhotoRepository repo;

	// 업로드 루트 (WebMvcConfig의 ResourceHandler와 일치)
	private static final String UPLOAD_DIR = "C:/javaStudy/upload/";
	private static final long MAX_SIZE = 10L * 1024 * 1024; // 10MB
	private static final Set<String> ALLOWED = Set.of("jpg", "jpeg", "png", "gif");

	public PhotoService(PhotoRepository repo) {
		this.repo = repo;
	}

	// 회원 본인 업로드
    public PhotoVO uploadAndSave(int sessionUserId, String photoType, String targetDate, MultipartFile file)
            throws IOException {
        return doSave(sessionUserId, sessionUserId, photoType, targetDate, file);
    }

    // 트레이너가 특정 회원에게 업로드
    public PhotoVO uploadAndSaveForMember(int userId, int trainerId, String photoType, String targetDate, MultipartFile file)
            throws IOException {
        return doSave(userId, trainerId, photoType, targetDate, file);
    }

    // 공통 저장 로직
    private PhotoVO doSave(int userId, int writerId, String photoType, String targetDate, MultipartFile file)
            throws IOException {
        if (file == null || file.isEmpty()) throw new IllegalArgumentException("빈 파일");
        if (file.getSize() > MAX_SIZE) throw new IllegalArgumentException("용량 초과(10MB)");

        String original = file.getOriginalFilename();
        String ext = (original != null && original.contains(".")) ? original.substring(original.lastIndexOf('.') + 1).toLowerCase() : "";
        if (!ALLOWED.contains(ext)) throw new IllegalArgumentException("허용되지 않는 확장자");

        String uuid = UUID.randomUUID().toString().replace("-", "");
        String saveName = uuid + "." + ext;
        File dir = new File(UPLOAD_DIR);
        if (!dir.exists()) dir.mkdirs();
        file.transferTo(new File(dir, saveName));

        PhotoVO vo = new PhotoVO();
        vo.setUserId(userId);
        vo.setWriterId(writerId);
        vo.setPhotoType(photoType);
        vo.setTargetDate(targetDate);
        vo.setPhotoUrl("/upload/" + saveName);
        repo.insert(vo);
        return vo;
    }

    // 회원 본인 조회
    public List<PhotoVO> getMyPhotos(int userId, String type, String targetDate, Integer limit){
        return getPhotosByUser(userId, type, targetDate, limit);
    }

    // 임의의 userId 조회(트레이너/회원 공용)
    public List<PhotoVO> getPhotosByUser(int userId, String type, String targetDate, Integer limit){
        Map<String,Object> p = new HashMap<>();
        p.put("userId", userId);
        p.put("photoType", type);
        p.put("targetDate", targetDate);
        p.put("limit", (limit==null? 12 : limit));
        p.put("offset", 0);
        return repo.selectList(p);
    }

    // 달력 집계: 이미 userId 파라미터로 동작 (트레이너/회원 공용)
    public List<Map<String,Object>> getCalendarCounts(int userId, String start, String end){
        Map<String,Object> p = new HashMap<>();
        p.put("userId", userId);
        p.put("start", start);
        p.put("end",   end);
        return repo.selectCalendarCounts(p);
    }

    // 회원 삭제: "본인이 올린 것"만 허용 (writerId == memberId)
    @Transactional
    public boolean deleteMyPhoto(int memberId, int photoId) {
        PhotoVO row = repo.selectByIdAndUser(photoId, memberId);
        if (row == null) return false;                  // 소유 아님
        if (row.getWriterId() != memberId) return false; // 본인 업로드가 아님 → 삭제 불가

        deletePhysicalFile(row.getPhotoUrl());
        int cnt = repo.deleteByIdAndUserAndWriter(photoId, memberId, memberId);
        return (cnt > 0);
    }

    // 트레이너 삭제: 대상 회원의 사진이면 작성자와 무관하게 삭제
    @Transactional
    public boolean deleteByTrainer(int photoId) {
        PhotoVO row = repo.selectById(photoId);
        if (row == null) return false;

        deletePhysicalFile(row.getPhotoUrl());
        int cnt = repo.deleteByIdAndUser(photoId, row.getUserId());
        return (cnt > 0);
    }

    // 공통: 물리 파일 삭제 (실패해도 예외 던지지 않음)
    private void deletePhysicalFile(String url) {
        try {
            if (url != null && url.startsWith("/upload/")) {
                String fileName = url.substring("/upload/".length());
                File f = new File(UPLOAD_DIR, fileName);
                if (f.exists()) f.delete();
            }
        } catch (Exception ignore) {}
    }
}
