package com.javaex.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.UUID;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileStorage {
	private final Path uploadRootPath;

	public FileStorage() {
		String os = System.getProperty("os.name").toLowerCase();
		if (os.contains("win")) {
			this.uploadRootPath = Paths.get("C:/javastudy/upload");
		} else {
			this.uploadRootPath = Paths.get("/data/upload");
		}
	}

	public String saveImage(MultipartFile file, int userId, String ymd) throws IOException {
		// 1) 확장자
		String original = file.getOriginalFilename();
		String ext = (original != null && original.contains("."))
				? original.substring(original.lastIndexOf(".")).toLowerCase()
				: ".jpg";

		String uuid = UUID.randomUUID().toString().replace("-", "");

		// 2) 날짜별 디렉토리
		LocalDate date = (ymd != null && !ymd.isEmpty()) ? LocalDate.parse(ymd) : LocalDate.now();
		Path dir = uploadRootPath.resolve(String.valueOf(userId)).resolve(String.valueOf(date.getYear()))
				.resolve(String.format("%02d", date.getMonthValue()))
				.resolve(String.format("%02d", date.getDayOfMonth()));

		Files.createDirectories(dir);

		// 3) 파일 저장
		Path target = dir.resolve(uuid + ext);
		Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

		// 4) 웹에서 접근 가능한 URL 리턴
		return String.format("/upload/%d/%04d/%02d/%02d/%s%s", userId, date.getYear(), date.getMonthValue(),
				date.getDayOfMonth(), uuid, ext);
	}
}
