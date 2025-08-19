/* =========================================================
  2) PT 회원 (pt_member)
     - "회원 1명 = 담당 트레이너 1명" 전제에서,
       회원의 총 PT 등록 횟수와 담당 트레이너를 저장
     - 리스트의 "PT 등록일수(총 회수)" 및 잔여 계산에 사용
     - 나중에 한 회원이 여러 트레이너를 갖게 되면
       PK를 (member_id, trainer_id)로 바꾸면 됨
========================================================= */
-- 데이터 베이스 사용
use fitlink_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
drop table pt_member;

-- 테이블 생성
CREATE TABLE pt_member (
  /* 회원 사용자 ID (users.user_id). 현재 단계에선 회원 1명 = 트레이너 1명 */
  member_id      INT PRIMARY KEY,              -- FK: users(user_id)

  /* 담당 트레이너 (users.user_id) */
  trainer_id     INT NOT NULL,                 -- FK: users(user_id)

  /* 총 PT 등록일수(회수). 리스트의 "PT 등록일수"에 표시 */
  total_sessions INT NOT NULL,

  /* FK: 실제 존재하는 사용자만 참조 (정합성 보장) */
  CONSTRAINT fk_ptm_member  FOREIGN KEY (member_id)  REFERENCES users(user_id),
  CONSTRAINT fk_ptm_trainer FOREIGN KEY (trainer_id) REFERENCES users(user_id)
);

-- 추가
INSERT INTO pt_member (member_id, trainer_id, total_sessions)
VALUES (1, 3, 30);

-- 조회
select 	*
from 	pt_member
;

UPDATE pt_member SET trainer_id = 1 WHERE member_id = 1;