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


-- 1. pt_members 테이블: 트레이너와 회원을 users 테이블과 연결합니다.
ALTER TABLE `pt_members`
ADD COLUMN `trainer_id` INT NOT NULL AFTER `fitness_goal`,
ADD COLUMN `member_id` INT NOT NULL AFTER `trainer_id`,
ADD CONSTRAINT `fk_pt_trainer_to_users`
FOREIGN KEY (`trainer_id`)
REFERENCES `users` (`user_id`)
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_pt_member_to_users`
FOREIGN KEY (`member_id`)
REFERENCES `users` (`user_id`)
ON DELETE CASCADE ON UPDATE CASCADE;


-- 2. user_photo 테이블: 사진의 소유자와 작성자를 users 테이블과 연결합니다.
ALTER TABLE `user_photo`
ADD COLUMN `user_id` INT NOT NULL AFTER `photo_url`,
ADD COLUMN `writer_id` INT NOT NULL AFTER `user_id`,
ADD CONSTRAINT `fk_photo_user_to_users`
FOREIGN KEY (`user_id`)
REFERENCES `users` (`user_id`)
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_photo_writer_to_users`
FOREIGN KEY (`writer_id`)
REFERENCES `users` (`user_id`)
ON DELETE CASCADE ON UPDATE CASCADE;


-- 3. inbody 테이블: 인바디 정보의 소유자를 users 테이블과 연결합니다.
ALTER TABLE `inbody`
ADD COLUMN `user_id` INT NOT NULL AFTER `dinner_fat_g`,
ADD CONSTRAINT `fk_inbody_to_users`
FOREIGN KEY (`user_id`)
REFERENCES `users` (`user_id`)
ON DELETE CASCADE ON UPDATE CASCADE;


-- 4. selected_exercises 테이블: 사용자와 운동 종류를 각 테이블과 연결합니다.
ALTER TABLE `selected_exercises`
ADD COLUMN `user_id` INT NOT NULL AFTER `user_exercise_id`,
ADD COLUMN `exercise_id` INT NOT NULL AFTER `user_id`,
ADD CONSTRAINT `fk_se_to_users`
FOREIGN KEY (`user_id`)
REFERENCES `users` (`user_id`)
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_se_to_exercise`
FOREIGN KEY (`exercise_id`)
REFERENCES `exercise` (`exercise_id`)
ON DELETE CASCADE ON UPDATE CASCADE;


-- 5. workout_log 테이블: 운동 기록의 소유자, 작성자, 운동 종류를 각 테이블과 연결합니다.
ALTER TABLE `workout_log`
ADD COLUMN `user_id` INT NOT NULL AFTER `log_type`,
ADD COLUMN `user_exercise_id` INT NOT NULL AFTER `user_id`,
ADD COLUMN `writer_id` INT NOT NULL AFTER `user_exercise_id`,
ADD CONSTRAINT `fk_log_to_users`
FOREIGN KEY (`user_id`)
REFERENCES `users` (`user_id`)
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_log_to_selected_exercises`
FOREIGN KEY (`user_exercise_id`)
REFERENCES `selected_exercises` (`user_exercise_id`)
ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_log_to_writer`
FOREIGN KEY (`writer_id`)
REFERENCES `users` (`user_id`)
ON DELETE CASCADE ON UPDATE CASCADE;


-- =======================================================================
-- fitlink_db 테스트용 샘플 데이터 (FK 오류 해결 버전)
-- =======================================================================
USE `fitlink_db`;

-- 1. 외래 키(FK) 제약 조건을 잠시 비활성화합니다.
SET FOREIGN_KEY_CHECKS = 0;

-- 2. 모든 관련 테이블의 데이터를 깨끗하게 삭제합니다. (TRUNCATE는 FK 비활성화 상태에서만 순서에 상관없이 작동합니다)
TRUNCATE TABLE workout_log;
TRUNCATE TABLE selected_exercises;
TRUNCATE TABLE pt_members;
TRUNCATE TABLE user_photo;
TRUNCATE TABLE inbody;
TRUNCATE TABLE users;
TRUNCATE TABLE exercise;

-- 3. 외래 키(FK) 제약 조건을 다시 활성화합니다.
SET FOREIGN_KEY_CHECKS = 1;

-- =======================================================================
-- 4. 기본 데이터 및 테스트용 샘플 데이터를 다시 추가합니다.
-- =======================================================================

-- 운동 종류 (exercise)
INSERT INTO `exercise` (exercise_id, body_part, exercise_name) VALUES 
(1,'가슴','벤치프레스'),(2,'가슴','푸시업'),(3,'가슴','헤머 벤치프레스'),
(4,'등','스미스머신 로우'),(5,'등','인클라인 덤벨 로우'),(6,'등','플로어 시티드 케이블 로우'),
(7,'어깨','시티드 덤벨 숄더 프레스'),(8,'어깨','오버헤드 프레스'),(9,'어깨','핸드스탠드 푸시업'),
(10, '등', '데드리프트'), (11, '하체', '스쿼트');

-- 사용자 (users)
INSERT INTO `users` (user_id, login_id, password, user_name, phone_number, birthdate, gender, role, created_at) VALUES 
(1,'jkm8369','1234','조강민','010-4746-1667','1995-08-08','male','member', NOW()),
(2,'chzh8369','1234','마동석','010-1234-5678','1980-09-21','male','trainer', NOW()),
(3, 'member01', '1234', '김민지', '010-1111-2222', '1998-03-15', 'female', 'member', NOW()),
(4, 'trainer01', '1234', '박서준', '010-3333-4444', '1988-12-16', 'male', 'trainer', NOW());

-- 사용자가 선택한 운동 목록 (selected_exercises)
INSERT INTO selected_exercises (user_id, exercise_id) VALUES (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 7), (1, 8), (1, 10), (1, 11);
INSERT INTO selected_exercises (user_id, exercise_id) VALUES (3, 2), (3, 6), (3, 7), (3, 9), (3, 11);

-- 운동 기록 (workout_log)
-- [수정] 여러 데이터를 한 번에 INSERT하던 것을 안정성을 위해 각각의 INSERT 문으로 분리합니다.
-- 조강민(user_id=1)의 운동 기록
INSERT INTO workout_log (log_date, weight, reps, created_at, log_type, user_id, user_exercise_id, writer_id) VALUES ('2025-08-19', 80, 10, NOW(), 'NORMAL', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=1), 1);
INSERT INTO workout_log (log_date, weight, reps, created_at, log_type, user_id, user_exercise_id, writer_id) VALUES ('2025-08-19', 80, 8, NOW(), 'NORMAL', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=1), 1);
INSERT INTO workout_log (log_date, weight, reps, created_at, log_type, user_id, user_exercise_id, writer_id) VALUES ('2025-08-18', 140, 5, NOW(), 'NORMAL', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=10), 1);
INSERT INTO workout_log (log_date, weight, reps, created_at, log_type, user_id, user_exercise_id, writer_id) VALUES ('2025-08-18', 120, 8, NOW(), 'NORMAL', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=11), 1);
INSERT INTO workout_log (log_date, weight, reps, created_at, log_type, user_id, user_exercise_id, writer_id) VALUES ('2025-08-15', 102.5, 1, NOW(), '1RM', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=1), 1);

-- 김민지(user_id=3)의 운동 기록
INSERT INTO workout_log (log_date, weight, reps, created_at, log_type, user_id, user_exercise_id, writer_id) VALUES ('2025-08-19', 15, 12, NOW(), 'NORMAL', 3, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=3 AND exercise_id=7), 3);
INSERT INTO workout_log (log_date, weight, reps, created_at, log_type, user_id, user_exercise_id, writer_id) VALUES ('2025-08-17', 60, 5, NOW(), '1RM', 3, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=3 AND exercise_id=11), 3);
-- 김민지(user_id=3) 회원의 운동 목록에 벤치프레스(exercise_id=1)와 데드리프트(exercise_id=10)를 추가합니다.
INSERT INTO selected_exercises (user_id, exercise_id) VALUES (3, 1);
INSERT INTO selected_exercises (user_id, exercise_id) VALUES (3, 10);

-- PT 회원 정보 (pt_members)
INSERT INTO pt_members (total_sessions, job, consultation_date, fitness_goal, trainer_id, member_id)
VALUES
(20, '사무직', '2025-08-10', '근력 증가', 2, 1),
(30, '학생', '2025-08-15', '다이어트', 2, 3);


SELECT DISTINCT log_date
FROM workout_log
WHERE user_id = 1
AND log_date LIKE CONCAT('2025-08', '%')
order by log_date asc
;

select se.user_exercise_id as userExerciseId,
	   se.user_id as userId,
       se.exercise_id as exerciseId,
       u.user_name as userName,
       u.role
from selected_exercises se, users u
where se.user_id = u.user_id
;