package com.javaex.vo;

public class UserVO {
	
	//필드
	private int userId;
	private String loginId;
	private String password;
	private String userName;
	private String phoneNumber;
	private String birthDate;
	private String gender;
	private String role;
	private String createdAt;
	
	
	//생성자
	
	public UserVO() {
		super();
	}

	

	public UserVO(int userId, String loginId, String password, String userName, String phoneNumber, String birthDate,
			String gender, String role, String createdAt) {
		super();
		this.userId = userId;
		this.loginId = loginId;
		this.password = password;
		this.userName = userName;
		this.phoneNumber = phoneNumber;
		this.birthDate = birthDate;
		this.gender = gender;
		this.role = role;
		this.createdAt = createdAt;
	}

	
	//메소드 gs
	
	public int getUserId() {
		return userId;
	}


	public void setUserId(int userId) {
		this.userId = userId;
	}


	public String getLoginId() {
		return loginId;
	}


	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}


	public String getPassword() {
		return password;
	}


	public void setPassword(String password) {
		this.password = password;
	}


	public String getUserName() {
		return userName;
	}


	public void setUserName(String userName) {
		this.userName = userName;
	}


	public String getPhoneNumber() {
		return phoneNumber;
	}


	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}


	public String getBirthDate() {
		return birthDate;
	}


	public void setBirthDate(String birthDate) {
		this.birthDate = birthDate;
	}


	public String getGender() {
		return gender;
	}


	public void setGender(String gender) {
		this.gender = gender;
	}


	public String getRole() {
		return role;
	}


	public void setRole(String role) {
		this.role = role;
	}


	public String getCreatedAt() {
		return createdAt;
	}


	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}


	@Override
	public String toString() {
		return "UserVO [userId=" + userId + ", loginId=" + loginId + ", password=" + password + ", userName=" + userName
				+ ", phoneNumber=" + phoneNumber + ", birthDate=" + birthDate + ", gender=" + gender + ", role=" + role
				+ ", createdAt=" + createdAt + "]";
	}
	

	
	
}
