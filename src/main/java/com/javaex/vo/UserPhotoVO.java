package com.javaex.vo;

public class UserPhotoVO {

	private int photoId;
	private int userId;
	private int writerId;
	private String uploadDate;
	private String photoType;
	private String photoUrl;
	
	public UserPhotoVO() {
		super();
	}

	public UserPhotoVO(int photoId, int userId, int writerId, String uploadDate, String photoType, String photoUrl) {
		super();
		this.photoId = photoId;
		this.userId = userId;
		this.writerId = writerId;
		this.uploadDate = uploadDate;
		this.photoType = photoType;
		this.photoUrl = photoUrl;
	}

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

	public String getUploadDate() {
		return uploadDate;
	}

	public void setUploadDate(String uploadDate) {
		this.uploadDate = uploadDate;
	}

	public String getPhotoType() {
		return photoType;
	}

	public void setPhotoType(String photoType) {
		this.photoType = photoType;
	}

	public String getPhotoUrl() {
		return photoUrl;
	}

	public void setPhotoUrl(String photoUrl) {
		this.photoUrl = photoUrl;
	}

	@Override
	public String toString() {
		return "UserPhotoVO [photoId=" + photoId + ", userId=" + userId + ", writerId=" + writerId + ", uploadDate="
				+ uploadDate + ", photoType=" + photoType + ", photoUrl=" + photoUrl + "]";
	}
	
	
	
}
