/*******************************************************
users
*******************************************************/
-- 데이터 베이스 사용
use project_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table users;

-- 유저(회원) 테이블 생성
create table users(
     user_id 		int 						primary key auto_increment
	,login_id 		varchar(50) 				unique
    ,password 		varchar(20) 				not null
    ,user_name 		varchar(20)
    ,phone_number 	varchar(20)
    ,birthdate 		date
    ,gender			enum('male', 'female')
    ,role			enum('member', 'trainer')
    ,created_at		datetime
);

-- 회원추가
insert into users
value(null, 'aaa', '123', '강호동', '010-1111-1111', '1970-06-11', 'male', 'trainer', now())
;

insert into users
value(null, 'bbb', '123', '정우성', '010-2222-2222', '1970-06-11', 'male', 'member', now())
;

-- 회원조회
select 	*
from 	users
;