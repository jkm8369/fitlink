package com.javaex.service;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.springframework.stereotype.Service;
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

	public PhotoVO uploadAndSave(int sessionUserId, String photoType, String targetDate, MultipartFile file)
			throws IOException {
		// 1) 세이프가드
		if (file == null || file.isEmpty()) {
			throw new IllegalArgumentException("빈 파일");
		}
		if (file.getSize() > MAX_SIZE) {
			throw new IllegalArgumentException("용량 초과(10MB)");
		}

		// 2) 확장자 점검
		String original = file.getOriginalFilename();
		String ext = (original != null && original.contains("."))
				? original.substring(original.lastIndexOf('.') + 1).toLowerCase()
				: "";
		if (!ALLOWED.contains(ext)) {
			throw new IllegalArgumentException("허용되지 않는 확장자");
		}

		// 3) 파일명/경로
		String uuid = UUID.randomUUID().toString().replace("-", "");
		String saveName = uuid + "." + ext;
		File dir = new File(UPLOAD_DIR);
		if (!dir.exists())
			dir.mkdirs(); // 루트 보장
		File dest = new File(dir, saveName);

		// 4) 저장
		file.transferTo(dest);

		// 5) DB 저장
		PhotoVO vo = new PhotoVO();
		vo.setUserId(sessionUserId);
		vo.setWriterId(sessionUserId);
		vo.setPhotoType(photoType);
		vo.setTargetDate(targetDate);
		vo.setPhotoUrl("/upload/" + saveName); // 웹에서 접근할 URL

		repo.insert(vo); // useGeneratedKeys로 photoId 채워짐
		return vo;
	}
	
    public List<PhotoVO> getMyPhotos(int userId, String type, String targetDate, Integer limit){
        Map<String,Object> p = new HashMap<>();
        p.put("userId", userId);
        p.put("photoType", type);
        p.put("targetDate", targetDate); // null 가능
        p.put("limit", (limit==null? 12 : limit));
        p.put("offset", 0);
        return repo.selectList(p);
    }

}
