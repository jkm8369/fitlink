package com.javaex.vo;

public class MemberExerciseVO {

	private int exerciseId;
    private String bodyPart;
    private String exerciseName;
    
	public MemberExerciseVO() {
		super();
	}

	public MemberExerciseVO(int exerciseId, String bodyPart, String exerciseName) {
		super();
		this.exerciseId = exerciseId;
		this.bodyPart = bodyPart;
		this.exerciseName = exerciseName;
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

	@Override
	public String toString() {
		return "TrainerExerciseVO [exerciseId=" + exerciseId + ", bodyPart=" + bodyPart + ", exerciseName="
				+ exerciseName + "]";
	}
    
    
	
}
