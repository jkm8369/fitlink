package com.javaex.apiController;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.javaex.service.PhotoService;
import com.javaex.vo.PhotoVO;
import com.javaex.vo.UserVO;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/photo")
public class PhotoApiController {

	private final PhotoService photoService;

	public PhotoApiController(PhotoService photoService) {
		this.photoService = photoService;
	}

	/** 업로드(회원 전용): file + photoType + targetDate */
	@PostMapping("/upload")
	public ResponseEntity<?> upload(HttpSession session, @RequestParam("file") MultipartFile file,
			@RequestParam("photoType") String photoType, @RequestParam("targetDate") String targetDate) {
		try {
			// (1) 로그인/세션 체크
			UserVO authUser = (UserVO) session.getAttribute("authUser");
			if (authUser == null) {
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
						.body(Map.of("ok", false, "message", "로그인이 필요합니다."));
			}
			int userId = authUser.getUserId();

			// (2) 서비스 호출
			PhotoVO saved = photoService.uploadAndSave(userId, photoType, targetDate, file);

			// (3) 응답
			return ResponseEntity
					.ok(Map.of("ok", true, "photoId", saved.getPhotoId(), "photoUrl", saved.getPhotoUrl()));
		} catch (IllegalArgumentException e) {
			return ResponseEntity.badRequest().body(Map.of("ok", false, "message", e.getMessage()));
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body(Map.of("ok", false, "message", "업로드에 실패했습니다."));
		}
	}
	
    @GetMapping("/list")
    public Map<String,Object> list(HttpSession session,
                                   @RequestParam("photoType") String photoType,
                                   @RequestParam(value="targetDate", required=false) String targetDate,
                                   @RequestParam(value="limit", required=false) Integer limit){
        UserVO auth = (UserVO) session.getAttribute("authUser");
        if(auth==null) return Map.of("ok", false, "message", "로그인이 필요합니다.");
        var rows = photoService.getMyPhotos(auth.getUserId(), photoType, targetDate, limit);
        return Map.of("ok", true, "data", rows);
    }
    
    @DeleteMapping("/{photoId}")
    public ResponseEntity<?> delete(HttpSession session, @PathVariable("photoId") int photoId) {
        UserVO authUser = (UserVO) session.getAttribute("authUser");
        if (authUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("ok", false, "message", "로그인이 필요합니다."));
        }
        try {
            boolean deleted = photoService.deleteMyPhoto(authUser.getUserId(), photoId);
            if (deleted) {
                return ResponseEntity.ok(Map.of("ok", true));
            } else {
                // 내가 가진 사진이 아니거나 이미 삭제된 경우
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("ok", false, "message", "대상을 찾을 수 없거나 권한이 없습니다."));
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("ok", false, "message", "삭제에 실패했습니다."));
        }
    }
    
    @GetMapping("/calendar")
    public Map<String, Object> calendar(HttpSession session,
                                        @RequestParam("start") String start,   // YYYY-MM-DD
                                        @RequestParam("end")   String end) {   // YYYY-MM-DD (미포함)
        UserVO auth = (UserVO) session.getAttribute("authUser");
        if (auth == null) return Map.of("ok", false, "message", "로그인이 필요합니다.");

        var rows = photoService.getCalendarCounts(auth.getUserId(), start, end);
        return Map.of("ok", true, "data", rows); // [{date: "2025-08-29", count: 3}, ...]
    }

}
