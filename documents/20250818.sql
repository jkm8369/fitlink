use fitlink_db;

show tables;

truncate table users;
truncate table workout_log;
truncate table exercise;
truncate table selected_exercises;

select *
from users;

select *
from workout_log;

select *
from exercise;

select *
from selected_exercises;

select *
from user_photo;

select *
from pt_members;


-- 테이블 삭제
DROP TABLE workout_log, user_photo;

-- fk로 묶여있을 때 삭제
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE workout_log, user_photo;
SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE workout_log
ADD COLUMN user_id INT  NOT NULL;

ALTER TABLE workout_log
ADD COLUMN user_exercise_id INT  NOT NULL;

ALTER TABLE workout_log
ADD COLUMN writer_id INT  NOT NULL;

ALTER TABLE user_photo
ADD COLUMN user_id INT  NOT NULL;

ALTER TABLE user_photo
ADD COLUMN writer_id INT  NOT NULL;

ALTER TABLE user_photo
ADD UNIQUE KEY uq_user_photo_writer_id (writer_id);

ALTER TABLE selected_exercises
ADD COLUMN user_id INT  NOT NULL;

ALTER TABLE selected_exercises
ADD COLUMN exercise_id INT  NOT NULL;

ALTER TABLE pt_members
ADD COLUMN trainer_id INT  NOT NULL;

ALTER TABLE pt_members
ADD COLUMN member_id INT  NOT NULL;
  
-- workout_log에 user_id fk 추가
ALTER TABLE workout_log
ADD CONSTRAINT fk_users_workout_log
FOREIGN KEY (user_id) REFERENCES users(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- workout_log에 user_exercise_id fk 추가
ALTER TABLE workout_log
ADD CONSTRAINT fk_selected_exercises_workout_log
FOREIGN KEY (user_exercise_id) REFERENCES selected_exercises(user_exercise_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- workout_log에 writer_id fk 추가
ALTER TABLE workout_log
ADD CONSTRAINT fk_user_photo_writer_id
FOREIGN KEY (writer_id) REFERENCES user_photo(writer_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- user_photo에 user_id fk 추가
ALTER TABLE user_photo
ADD CONSTRAINT fk_users_user_photo
FOREIGN KEY (user_id) REFERENCES users(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE selected_exercises
ADD CONSTRAINT fk_users_selected_exercises
FOREIGN KEY (user_id) REFERENCES users(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE selected_exercises
ADD CONSTRAINT fk_exercise_selected_exercises
FOREIGN KEY (exercise_id) REFERENCES exercise(exercise_id)
ON DELETE CASCADE
ON UPDATE CASCADE;


insert into users
values(null, 'jkm8369', 'whrkdals', '조강민', '01047461667', '950808', 'male', 'member', now());

insert into users
values(null, 'chzh8369', 'whrkdals', '마동석', '01012345678', '800921', 'male', 'trainer', now());

insert into workout_log
values(null, '20250817', '100.23', '10', now(), 'normal', '1', '1', '1');

insert into exercise
values(null, '가슴', '벤치프레스');

insert into exercise
values(null, '가슴', '푸시업');

insert into exercise
values(null, '가슴', '헤머 벤치프레스');

insert into exercise
values(null, '등', '스미스머신 로우');

insert into exercise
values(null, '등', '인클라인 덤벨 로우');

insert into exercise
values(null, '등', '플로어 시티드 케이블 로우');

insert into exercise
values(null, '어깨', '시티드 덤벨 숄더 프레스');

insert into exercise
values(null, '어깨', '오버헤드 프레스');

insert into exercise
values(null, '어깨', '핸드스탠드 푸시업');

insert into selected_exercises
values(null, '1', '1');

insert into user_photo
values(null, now(), 'body', '', '1', '1');


select log_id as logId,
	   log_date as logDate,
       weight,
       reps,
       created_at as createdAt,
       log_type as logType,
       user_id as userId,
       user_exercise_id as userExerciseId,
       writer_id as writerId
from workout_log
order by logId asc;

select w.log_id as logId,
	   w.log_date as logDate,
       w.weight,
       w.reps,
       w.created_at as createdAt,
       w.log_type as logType,
       u.user_id as userId,
       w.user_exercise_id as userExerciseId,
       p.writer_id as writerId,
       u.user_name as userName,
       u.login_id as loginId
from users u, workout_log w, user_photo p
where u.user_id = w.user_id
and w.writer_id = p.writer_id
;

delete
from workout_log
where logId = 1
;