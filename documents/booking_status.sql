/*******************************************************
booking_status
*******************************************************/
-- 데이터 베이스 사용
use project_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table booking_status;

-- 테이블 생성
create table booking_status(
	booking_id	int		primary key		auto_increment
    ,status		enum('scheduled', 'completed', 'canceled')
);

-- 추가
insert into booking_status
value(null, 'scheduled')
;

-- 조회
select 	*
from 	booking_status
;