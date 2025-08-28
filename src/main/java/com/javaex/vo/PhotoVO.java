package com.javaex.vo;

public class PhotoVO {
	private int photoId; // 사진 PK
	private int userId; // 사진 주인(회원)
	private int writerId; // 작성자(회원 또는 트레이너)
	private String photoType; // 'body' or 'meal'
	private String targetDate; // 사용자가 선택한 날짜 (YYYY-MM-DD)
	private String uploadDate; // 업로드 날짜/시간 (문자열 또는 LocalDateTime)
	private String photoUrl; // 파일 URL
	
	
	public int getPhotoId() {
		return photoId;
	}
	public void setPhotoId(int photoId) {
		this.photoId = photoId;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public int getWriterId() {
		return writerId;
	}
	public void setWriterId(int writerId) {
		this.writerId = writerId;
	}
	public String getPhotoType() {
		return photoType;
	}
	public void setPhotoType(String photoType) {
		this.photoType = photoType;
	}
	public String getTargetDate() {
		return targetDate;
	}
	public void setTargetDate(String targetDate) {
		this.targetDate = targetDate;
	}
	public String getUploadDate() {
		return uploadDate;
	}
	public void setUploadDate(String uploadDate) {
		this.uploadDate = uploadDate;
	}
	public String getPhotoUrl() {
		return photoUrl;
	}
	public void setPhotoUrl(String photoUrl) {
		this.photoUrl = photoUrl;
	}

	
}
