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
@RequestMapping("/api/trainer/photo")
public class TrainerPhotoApiController {
	
	private final PhotoService photoService;

    public TrainerPhotoApiController(PhotoService photoService) {
        this.photoService = photoService;
    }

    /** 트레이너: 특정 회원 사진 목록 */
    @GetMapping("/list")
    public Map<String, Object> list(HttpSession session,
                                    @RequestParam("userId") int userId,
                                    @RequestParam("photoType") String photoType,
                                    @RequestParam(value="targetDate", required=false) String targetDate,
                                    @RequestParam(value="limit", required=false) Integer limit) {
        UserVO auth = (UserVO) session.getAttribute("authUser");
        if (auth == null) return Map.of("ok", false, "message", "로그인이 필요합니다.");
        var rows = photoService.getPhotosByUser(userId, photoType, targetDate, limit);
        return Map.of("ok", true, "data", rows);
    }

    /** 트레이너: 특정 회원 달력 집계 */
    @GetMapping("/calendar")
    public Map<String, Object> calendar(HttpSession session,
                                        @RequestParam("userId") int userId,
                                        @RequestParam("start") String start,
                                        @RequestParam("end") String end) {
        UserVO auth = (UserVO) session.getAttribute("authUser");
        if (auth == null) return Map.of("ok", false, "message", "로그인이 필요합니다.");
        var rows = photoService.getCalendarCounts(userId, start, end);
        return Map.of("ok", true, "data", rows);
    }

    /** 트레이너 업로드: file + photoType + targetDate + userId(사진 주인 회원) */
    @PostMapping("/upload")
    public ResponseEntity<?> upload(HttpSession session,
                                    @RequestParam("userId") int userId,
                                    @RequestParam("photoType") String photoType,
                                    @RequestParam("targetDate") String targetDate,
                                    @RequestParam("file") MultipartFile file) {
        try {
            UserVO auth = (UserVO) session.getAttribute("authUser");
            if (auth == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(Map.of("ok", false, "message", "로그인이 필요합니다."));
            }
            int trainerId = auth.getUserId();
            PhotoVO saved = photoService.uploadAndSaveForMember(userId, trainerId, photoType, targetDate, file);
            return ResponseEntity.ok(Map.of("ok", true, "photoId", saved.getPhotoId(), "photoUrl", saved.getPhotoUrl()));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("ok", false, "message", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("ok", false, "message", "업로드 실패"));
        }
    }

    /** 트레이너 삭제: 대상 회원의 사진이면 작성자와 무관하게 삭제 허용 */
    @DeleteMapping("/{photoId}")
    public ResponseEntity<?> delete(HttpSession session, @PathVariable("photoId") int photoId) {
        UserVO auth = (UserVO) session.getAttribute("authUser");
        if (auth == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("ok", false, "message", "로그인이 필요합니다."));
        }
        try {
            boolean deleted = photoService.deleteByTrainer(photoId);
            if (deleted) return ResponseEntity.ok(Map.of("ok", true));
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("ok", false, "message", "대상이 없거나 권한이 없습니다."));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("ok", false, "message", "삭제 실패"));
        }
    }
    
}
