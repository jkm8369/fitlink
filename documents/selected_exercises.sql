/*******************************************************
selected_exercises
*******************************************************/
-- 데이터 베이스 사용
use fitlink_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table selected_exercises;

-- 테이블 생성
create table selected_exercises(
	user_exercise_id		int		primary key		auto_increment
);

-- 추가
insert into selected_exercises
value(null)
;

-- 조회
select 	*
from 	selected_exercises
;