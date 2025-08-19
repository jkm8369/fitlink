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



