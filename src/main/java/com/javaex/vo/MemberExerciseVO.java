package com.javaex.vo;

public class MemberExerciseVO {

	private int exerciseId;
    private String bodyPart;
    private String exerciseName;
    private Integer creatorId;   // null 허용하기 위해 Integer 사용
    
	public MemberExerciseVO() {
		super();
	}

	public MemberExerciseVO(int exerciseId, String bodyPart, String exerciseName, Integer creatorId) {
		super();
		this.exerciseId = exerciseId;
		this.bodyPart = bodyPart;
		this.exerciseName = exerciseName;
		this.creatorId = creatorId;
	}

	public int getExerciseId() {
		return exerciseId;
	}

	public void setExerciseId(int exerciseId) {
		this.exerciseId = exerciseId;
	}

	public String getBodyPart() {
		return bodyPart;
	}

	public void setBodyPart(String bodyPart) {
		this.bodyPart = bodyPart;
	}

	public String getExerciseName() {
		return exerciseName;
	}

	public void setExerciseName(String exerciseName) {
		this.exerciseName = exerciseName;
	}

	public Integer getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(Integer creatorId) {
		this.creatorId = creatorId;
	}

	@Override
	public String toString() {
		return "MemberExerciseVO [exerciseId=" + exerciseId + ", bodyPart=" + bodyPart + ", exerciseName="
				+ exerciseName + ", creatorId=" + creatorId + "]";
	}
    
	
    
    
	
}
