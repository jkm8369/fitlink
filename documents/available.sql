/* =========================================================
  1) 트레이너 근무시간 (trainer_availability)
     - "어느 트레이너가, 어느 날짜에, 몇 시에" 근무하는지
       1시간 단위로 저장하는 테이블
     - 이 테이블의 한 행(=근무칸)이 예약의 대상이 됨
========================================================= */

-- 데이터 베이스 사용
use fitlink_db;

-- 테이블 목록 조회
show tables;

-- 테이블 삭제
DROP TABLE IF EXISTS trainer_availability;

-- 테이블 생성
CREATE TABLE trainer_availability (
  /* 근무칸 고유 번호 (PK). 예약에서 availability_id로 참조함 */
  avail_id   INT PRIMARY KEY AUTO_INCREMENT,
  /* 근무를 하는 트레이너의 사용자 ID (users.user_id) */
  trainer_id INT NOT NULL,     -- users.user_id 를 FK로 참조
  /* 근무 날짜 (예: 2025-07-09) */
  work_date  DATE NOT NULL,    -- 예: 2025-07-09
  /* 근무 시작 시각(시단위, 0~23). 예: 14 -> 14:00~15:00 */
  work_hour  TINYINT NOT NULL, -- 0~23 (예: 14 → 14:00~15:00)

  /* 같은 트레이너가 같은 날짜/시간대를 중복 등록 못 하도록 */
  UNIQUE KEY uk_trainer_date_hour (trainer_id, work_date, work_hour),

  /* (트레이너, 날짜)로 자주 조회하므로 인덱스 */
  INDEX idx_trainer_date (trainer_id, work_date),

  /* FK: 실제 존재하는 사용자만 트레이너로 등록 가능 */
  CONSTRAINT fk_ta_user
    FOREIGN KEY (trainer_id) REFERENCES users(user_id)
);

-- 추가
-- 내가 트레이너 ID를 이미 알고 있을 때 (가장 흔함)
INSERT INTO trainer_availability (trainer_id, work_date, work_hour)
VALUES (1, '2025-07-09', 12),
       (1, '2025-07-09', 13);

-- 로그인아이디로 조인해서 trainer_id를 얻고 저장하고 싶을 때
-- login_id가 'trainer1'인 사용자를 찾아서 그 user_id로 저장
INSERT INTO trainer_availability (trainer_id, work_date, work_hour)
SELECT u.user_id, '2025-07-10', 9
FROM users u
WHERE u.login_id = 'trainer1' AND u.role = 'trainer';

-- 여러 시간 한 번에
INSERT INTO trainer_availability (trainer_id, work_date, work_hour)
SELECT u.user_id, '2025-07-10', t.hh
FROM users u
JOIN (SELECT 10 AS hh UNION ALL SELECT 11 UNION ALL SELECT 14) t
WHERE u.login_id = 'trainer1' AND u.role = 'trainer';


-- 조회
-- 특정 트레이너의 특정 날짜 근무시간(시간 리스트)
SELECT work_hour
FROM trainer_availability
WHERE trainer_id = 4
  AND work_date  = '2025-08-22'
ORDER BY work_hour;

-- 로그인아이디로 내 근무시간 조회(조인 사용)
SELECT ta.work_hour
FROM trainer_availability ta
JOIN users u ON u.user_id = ta.trainer_id
WHERE u.login_id = 'trainer1'
  AND u.role     = 'trainer'
  AND ta.work_date = '2025-07-09'
ORDER BY ta.work_hour;

-- 트레이너 이름까지 같이 보고 싶을 때(관리용)
SELECT u.user_name  AS trainer_name,
       ta.work_date,
       ta.work_hour
FROM trainer_availability tareservation
JOIN users u ON u.user_id = ta.trainer_id
WHERE ta.work_date BETWEEN '2025-07-01' AND '2025-07-31'
ORDER BY u.user_name, ta.work_date, ta.work_hour;

SELECT * 
FROM trainer_availability
WHERE trainer_id = 4
  AND work_date  = '2025-08-25'
ORDER BY work_hour;

-- 모달
-- 1) 삭제
DELETE FROM trainer_availability
WHERE trainer_id = 1
  AND work_date  = '2025-07-19';

-- 2) 새로 저장
INSERT INTO trainer_availability (trainer_id, work_date, work_hour)
VALUES (1, '2025-07-10', 9),
       (1, '2025-07-10', 10),
       (1, '2025-07-10', 14);
	
