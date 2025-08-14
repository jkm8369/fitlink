/*******************************************************
user_photo
*******************************************************/
-- 데이터 베이스 사용
use project_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table user_photo;

-- 테이블 생성
create table user_photo(
     photo_id 		int 						primary key auto_increment
	,upload_date 	datetime
    ,photo_type 	enum('body', 'meal')
    ,photo_url 		VARCHAR(255)
);

-- 추가
insert into user_photo
value(null, now(), 'meal', 'asdadfuadasdfkakfdf')
;

-- 조회
select 	*
from 	user_photo
;