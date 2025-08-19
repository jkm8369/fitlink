package com.javaex.vo;

public class SelectedExercisesVO {

	private int userExerciseId;
	private int userId;
	private int exerciseId;
	
	public SelectedExercisesVO() {
		super();
	}

	public SelectedExercisesVO(int userExerciseId, int userId, int exerciseId) {
		super();
		this.userExerciseId = userExerciseId;
		this.userId = userId;
		this.exerciseId = exerciseId;
	}

	public int getUserExerciseId() {
		return userExerciseId;
	}

	public void setUserExerciseId(int userExerciseId) {
		this.userExerciseId = userExerciseId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getExerciseId() {
		return exerciseId;
	}

	public void setExerciseId(int exerciseId) {
		this.exerciseId = exerciseId;
	}

	@Override
	public String toString() {
		return "SelectedExercisesVO [userExerciseId=" + userExerciseId + ", userId=" + userId + ", exerciseId="
				+ exerciseId + "]";
	}
	
	
	
	
}
