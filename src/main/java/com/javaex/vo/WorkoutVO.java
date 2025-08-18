package com.javaex.vo;

public class WorkoutVO {

	private int logId;
	private int userId;
	private int userExerciseId;
	private int writerId;
	private String logDate;
	private int weight;
	private int reps;
	private String createdAt;
	private String logType;
	private String exerciseName;
	private String bodyPart;
	
	public WorkoutVO() {
		super();
	}

	public WorkoutVO(int logId, int userId, int userExerciseId, int writerId, String logDate, int weight, int reps,
			String createdAt, String logType, String exerciseName, String bodyPart) {
		super();
		this.logId = logId;
		this.userId = userId;
		this.userExerciseId = userExerciseId;
		this.writerId = writerId;
		this.logDate = logDate;
		this.weight = weight;
		this.reps = reps;
		this.createdAt = createdAt;
		this.logType = logType;
		this.exerciseName = exerciseName;
		this.bodyPart = bodyPart;
	}

	public int getLogId() {
		return logId;
	}

	public void setLogId(int logId) {
		this.logId = logId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getUserExerciseId() {
		return userExerciseId;
	}

	public void setUserExerciseId(int userExerciseId) {
		this.userExerciseId = userExerciseId;
	}

	public int getWriterId() {
		return writerId;
	}

	public void setWriterId(int writerId) {
		this.writerId = writerId;
	}

	public String getLogDate() {
		return logDate;
	}

	public void setLogDate(String logDate) {
		this.logDate = logDate;
	}

	public int getWeight() {
		return weight;
	}

	public void setWeight(int weight) {
		this.weight = weight;
	}

	public int getReps() {
		return reps;
	}

	public void setReps(int reps) {
		this.reps = reps;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}

	public String getLogType() {
		return logType;
	}

	public void setLogType(String logType) {
		this.logType = logType;
	}

	public String getExerciseName() {
		return exerciseName;
	}

	public void setExerciseName(String exerciseName) {
		this.exerciseName = exerciseName;
	}

	public String getBodyPart() {
		return bodyPart;
	}

	public void setBodyPart(String bodyPart) {
		this.bodyPart = bodyPart;
	}

	@Override
	public String toString() {
		return "WorkoutVO [logId=" + logId + ", userId=" + userId + ", userExerciseId=" + userExerciseId + ", writerId="
				+ writerId + ", logDate=" + logDate + ", weight=" + weight + ", reps=" + reps + ", createdAt="
				+ createdAt + ", logType=" + logType + ", exerciseName=" + exerciseName + ", bodyPart=" + bodyPart
				+ "]";
	}
	
	
	
	
	
}
