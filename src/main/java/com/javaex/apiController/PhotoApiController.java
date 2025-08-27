package com.javaex.apiController;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

import com.javaex.service.PhotoService;
import com.javaex.vo.PhotoVO;

@RestController
@RequestMapping("/api/photos")
public class PhotoApiController {
	
	private final PhotoService photoService;

	public PhotoApiController(PhotoService photoService) {
		this.photoService = photoService;
	}

	@PostMapping("/upload")
	public Map<String, Object> upload(@RequestParam("file") MultipartFile file,
			@RequestParam("photoType") String photoType, @SessionAttribute("memberId") int memberId) {
		Map<String, Object> result = new HashMap<>();
		try {
			PhotoVO vo = photoService.saveUserPhoto(file, photoType, memberId, memberId);
			result.put("ok", true);
			result.put("data", vo);
		} catch (Exception e) {
			result.put("ok", false);
			result.put("message", e.getMessage());
		}
		return result;
	}
	
}
