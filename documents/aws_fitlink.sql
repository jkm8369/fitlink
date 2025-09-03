-- =======================================================================
-- fitlink_db 테스트용 샘플 데이터 스크립트
-- =======================================================================
show databases;

-- 사용할 데이터베이스를 선택합니다.
USE `fitlink_db`;

drop database fitlink_db;

select *
from users;
-- -----------------------------------------------------------------------
-- 1. 데이터 초기화 (기존 데이터가 있다면 깨끗하게 삭제)
-- -----------------------------------------------------------------------
-- 외래 키(FK) 제약 조건을 잠시 비활성화하여 테이블 삭제 순서에 상관없이 초기화합니다.
SET FOREIGN_KEY_CHECKS = 0;

-- 테이블의 모든 데이터를 삭제합니다.
TRUNCATE TABLE availability;
TRUNCATE TABLE exercise;
TRUNCATE TABLE inbody;
TRUNCATE TABLE member_profile;
TRUNCATE TABLE pt_contract;
TRUNCATE TABLE reservation;
TRUNCATE TABLE selected_exercises;
TRUNCATE TABLE user_photo;
TRUNCATE TABLE users;
TRUNCATE TABLE workout_log;

-- 외래 키(FK) 제약 조건을 다시 활성화합니다.
SET FOREIGN_KEY_CHECKS = 1;


-- -----------------------------------------------------------------------
-- 2. 기본 운동 데이터 추가 (exercise 테이블)
-- -----------------------------------------------------------------------
INSERT INTO `exercise` (body_part, exercise_name) VALUES
-- 가슴
('가슴', '벤치프레스'), ('가슴', '푸시업'), ('가슴', '해머 벤치프레스'), ('가슴', '스미스머신 벤치프레스'), ('가슴', '중량 푸시업'),
('가슴', '스포토 벤치프레스'), ('가슴', '스미스머신 인클라인 벤치프레스'), ('가슴', '힌두 푸시업'), ('가슴', '어시스트 딥스 머신'),
('가슴', '덤벨 벤치프레스'), ('가슴', '아처 푸시업'), ('가슴', '디클라인 벤치프레스'), ('가슴', '인클라인 덤벨 벤치프레스'),
('가슴', '클로즈그립 푸시업'), ('가슴', '바벨 플로어 프레스'), ('가슴', '덤벨 플라이'), ('가슴', '케이블 크로스오버'), ('가슴', '클랩 푸시업'),
('가슴', '스탠딩 케이블 플라이'), ('가슴', '체스트 프레스 머신'), ('가슴', '디클라인 덤벨 플라이'), ('가슴', '인클라인 벤치프레스'),
('가슴', '펙덱 플라이 머신'), ('가슴', '인클라인 푸시업'), ('가슴', '딥스'), ('가슴', '덤벨 풀오버'), ('가슴', '파이크 푸시업'),
('가슴', '중량 딥스'), ('가슴', '시티드 딥스 머신'), ('가슴', '디클라인 체스트 프레스 머신'), ('가슴', '인클라인 덤벨 플라이'),
('가슴', '로우 풀리 케이블 플라이'), ('가슴', '인클라인 덤벨 트위스트 프레스'),
-- 등
('등', '스미스머신 로우'), ('등', '인클라인 덤벨 로우'), ('등', '어시스트 풀업 머신'), ('등', '덤벨 로우'), ('등', '인버티드 로우'),
('등', '플로어 시티드 케이블 로우'), ('등', '원암 덤벨 로우'), ('등', '바벨 풀오버'), ('등', '레터럴 와이드 풀다운'),
('등', '케이블 암 풀다운'), ('등', '시티드 로우 머신'), ('등', '랫풀다운'), ('등', '언더그립 바벨 로우'), ('등', '라잉 바벨 로우'),
('등', '굿모닝 엑서사이즈'), ('등', '하이퍼 익스텐션'), ('등', '비하인드 넥 풀다운'), ('등', '원암 케이블 풀다운'), ('등', '풀업'),
('등', '중량 하이퍼 익스텐션'), ('등', '백 익스텐션'), ('등', '원암 레터럴 와이드 풀다운'), ('등', '중량 풀업'), ('등', '티바 로우 머신'),
('등', '로우 로우 머신'), ('등', '친업'), ('등', '맥그립 랫풀다운'), ('등', '원암 로우 로우 머신'), ('등', '중량 친업'),
('등', '패러럴그립 랫풀다운'), ('등', '하이 로우 머신'), ('등', '바벨 로우'), ('등', '언더그립 랫풀다운'), ('등', '언더그립 하이 로우 머신'),
('등', '펜들레이 로우'), ('등', '인클라인 바벨 로우'), ('등', '정지 바벨 로우'), ('등', '원암 하이 로우 머신'), ('등', '데드리프트'),
-- 어깨
('어깨', '오버헤드 프레스'), ('어깨', '핸드스탠드 푸시업'), ('어깨', '시티드 바벨 숄더 프레스'), ('어깨', '스미스머신 오버헤드 프레스'),
('어깨', '케이블 리버스 플라이'), ('어깨', '시티드 덤벨 숄더 프레스'), ('어깨', '스미스머신 슈러그'), ('어깨', '바벨 업라이트 로우'),
('어깨', '플레이트 숄더 프레스'), ('어깨', '덤벨 숄더 프레스'), ('어깨', '덤벨 업라이트 로우'), ('어깨', 'Y 레이즈'), ('어깨', '덤벨 레터럴 레이즈'),
('어깨', '이지바 업라이트 로우'), ('어깨', '덤벨 Y 레이즈'), ('어깨', '벤트오버 덤벨 레터럴 레이즈'), ('어깨', '푸시 프레스'),
('어깨', '슈러그 머신'), ('어깨', '아놀드 덤벨 프레스'), ('어깨', '리어 델토이드 플라이 머신'), ('어깨', '케이블 슈러그'),
('어깨', '숄더 프레스 머신'), ('어깨', '레터럴 레이즈 머신'), ('어깨', '케이블 인터널 로테이션'), ('어깨', '비하인드 넥 프레스'),
('어깨', '케이블 레터럴 레이즈'), ('어깨', '케이블 익스터널 로테이션'), ('어깨', '덤벨 프론트 레이즈'), ('어깨', '케이블 프론트 레이즈'),
('어깨', '원암 케이블 레터럴 레이즈'), ('어깨', '바벨 슈러그'), ('어깨', '바벨 프론트 레이즈'), ('어깨', '랜드마인 프레스'),
('어깨', '덤벨 슈러그'), ('어깨', '이지바 프론트 레이즈'), ('어깨', '원암 랜드마인 프레스'), ('어깨', '페이스 풀'),
('어깨', '시티드 덤벨 리어 레터럴 레이즈'), ('어깨', '핸드스탠드 푸시업'), ('어깨', '플랭크 숄더 탭'),
-- 하체
('하체', '컨벤셔널 데드리프트'), ('하체', '리버스 보스 스쿼트'), ('하체', '파워 레그 프레스'), ('하체', '바벨 백스쿼트'),
('하체', '글루트 킥백 머신'), ('하체', '사이드 레그 클램'), ('하체', '스미스머신 스플릿 스쿼트'), ('하체', '힙 어브덕션 머신'),
('하체', '덤벨 원레그 데드리프트'), ('하체', '스미스머신 데드리프트'), ('하체', '시티드 레그 컬'), ('하체', '덤벨 와이드 스쿼트'),
('하체', '스미스머신 스쿼트'), ('하체', '스탑 스쿼트'), ('하체', '케틀벨 스모 데드리프트'), ('하체', '덤벨 런지'),
('하체', '트랩바 데드리프트'), ('하체', '덤벨 스모 데드리프트'), ('하체', '덤벨 레터럴 런지'), ('하체', '덤벨 고블릿 스쿼트'),
('하체', '케이블 힙 어브덕션'), ('하체', '케틀벨 런지'), ('하체', '덤벨 스플릿 스쿼트'), ('하체', '핵 스쿼트 머신'),
('하체', '덤벨 레터럴 워킹'), ('하체', '프론트 스쿼트'), ('하체', '정지 데드리프트'), ('하체', '워킹 런지'), ('하체', '저쳐 스쿼트'),
('하체', '바벨 프론트 랙 런지'), ('하체', '힙레그 익스텐션'), ('하체', '바벨 불가리안 스플릿 스쿼트'), ('하체', '바벨 점프 스쿼트'),
('하체', '워킹 레그 컬'), ('하체', '덤벨 불가리안 스플릿 스쿼트'), ('하체', '바벨 힙 쓰러스트'), ('하체', '원레그 프레스'),
('하체', '에어 스쿼트'), ('하체', '바벨 스플릿 스쿼트'), ('하체', '수평 레그 프레스'), ('하체', '점프 스쿼트'),
('하체', '바벨 스티프 카프 레이즈'), ('하체', '시티드 원레그 컬'), ('하체', '케틀벨 고블릿 스쿼트'), ('하체', '스티프 레그 데드리프트'),
('하체', '노르딕 햄스트링 컬'), ('하체', '루마니안 데드리프트'), ('하체', '덤벨 오버헤드 스쿼트'), ('하체', '바벨 스모 스쿼트'),
('하체', '스모 데드리프트'), ('하체', '덤벨 스모 스쿼트'), ('하체', '레그 프레스'), ('하체', '덤벨 레그 컬'), ('하체', '스모 에어 스쿼트'),
('하체', '레그 컬'), ('하체', '덤벨 스쿼트'), ('하체', '피스톨 스쿼트'), ('하체', '레그 익스텐션'), ('하체', '바벨 핵 스쿼트'),
('하체', '영키 킥'), ('하체', '스탠딩 카프 레이즈'), ('하체', '케이블 덩키 킥'), ('하체', '이너 싸이 머신'),
('하체', '힙 쓰러스트 머신'), ('하체', '데피싯 데드리프트'), ('하체', '런지'), ('하체', '맨몸 카프 레이즈'), ('하체', '베어 크롤'),
('하체', '스텝업'), ('하체', '글루트 브릿지'), ('하체', '케틀벨 런지 트위스트'), ('하체', '중량 스텝업'),
('하체', '덤벨 루마니안 데드리프트'), ('하체', '케이블 풀 스루'), ('하체', '힙 쓰러스트'), ('하체', '가이드 힙 어브덕션'),
('하체', '몬스터 글루트 머신'), ('하체', '바벨 힙 쓰러스트'), ('하체', '싱글 레그 글루트 브릿지'), ('하체', '브이 스쿼트'), ('하체', '스쿼트'),
-- 팔
('팔', '덤벨 컬'), ('팔', '바벨 리스트 컬'), ('팔', '케이블 오버헤드 트라이셉 익스텐션'), ('팔', '덤벨 트라이셉 익스텐션'),
('팔', '이지바 리스트 컬'), ('팔', '케이블 라잉 트라이셉 익스텐션'), ('팔', '덤벨 킥백'), ('팔', '덤벨 리스트 컬'),
('팔', '리버스 바벨 리스트 컬'), ('팔', '케이블 컬'), ('팔', '스컬 크러셔'), ('팔', '리버스 덤벨 리스트 컬'),
('팔', '케이블 푸시 다운'), ('팔', '바벨 라잉 트라이셉 익스텐션'), ('팔', '인클라인 덤벨 컬'), ('팔', '바벨 컬'),
('팔', '덤벨 프리처 컬'), ('팔', '벤치 딥스'), ('팔', '이지바 컬'), ('팔', '바벨 프리처 컬'), ('팔', '리스트 롤러'),
('팔', '덤벨 해머 컬'), ('팔', '이지바 프리처 컬'), ('팔', '리버스 바벨 컬'), ('팔', '클로즈 그립 벤치프레스'),
('팔', '프리처 컬 머신'), ('팔', '트라이셉 익스텐션 머신'), ('팔', '시티드 덤벨 트라이셉 익스텐션'), ('팔', '암 컬 머신'),
('팔', '케이블 트라이셉 익스텐션'), ('팔', '케이블 해머컬'),
-- 복근
('복근', '싯업'), ('복근', '버드독 플랭크'), ('복근', 'RKC 플랭크'), ('복근', '브이 업'), ('복근', '복근 에어 바이크'),
('복근', '케이블 사이드 밴드'), ('복근', '크런치'), ('복근', '토즈투 바'), ('복근', '디클라인 크런치'), ('복근', '힐 터치'),
('복근', '행잉 니 레이즈'), ('복근', '중량 디클라인 크런치'), ('복근', '레그 레이즈'), ('복근', '복근 크런치 머신'),
('복근', '디클라인 리버스 크런치'), ('복근', '행잉 레그 레이즈'), ('복근', '행 클린'), ('복근', '디클라인 싯업'),
('복근', '러시안 트위스트'), ('복근', '행 스내치'), ('복근', '중량 디클라인 싯업'), ('복근', '할로우 락'),
('복근', '필라테스 잭나이프'), ('복근', '사이드 크런치'), ('복근', '할로우 포지션'), ('복근', '리버스 크런치'),
('복근', '케이블 트위스트'), ('복근', '플랭크'), ('복근', '사이드 플랭크'), ('복근', '덤벨 사이드 밴드'),
('복근', '45도 사이드 밴드'), ('복근', '중량 행잉 니 레이즈'),
-- 역도
('역도', '클린'), ('역도', '바벨 오버헤드 스쿼트'), ('역도', '스내치 밸런스'), ('역도', '클린 & 저크'), ('역도', '덤벨 스내치'),
('역도', '저크'), ('역도', '케틀벨 스내치'), ('역도', '클린 하이풀'), ('역도', '스내치'),
('역도', '케이블 크런치'), ('역도', '스내치 하이풀'),
-- 유산소
('유산소', '트레드밀'), ('유산소', '줄넘기'), ('유산소', '스텝밀'), ('유산소', '싸이클'), ('유산소', '이단 뛰기'),
('유산소', '일립티컬 머신'), ('유산소', '로잉 머신'), ('유산소', '하이 니 스킵'), ('유산소', '걷기'), ('유산소', '계단 오르기'),
('유산소', '어썰트 바이크'), ('유산소', '달리기'),
-- 기타
('기타', '쓰러스터'), ('기타', '박스 점프'), ('기타', '덤벨 쓰러스터'), ('기타', '버피'), ('기타', '점핑 잭'),
('기타', '인치웜'), ('기타', '케틀벨 스윙'), ('기타', '바 머슬업'), ('기타', '스모 데드리프트 하이풀'),
('기타', '파머스 워크'), ('기타', '링 머슬업'), ('기타', '케틀벨 스모 하이풀'), ('기타', '월볼 샷'),
('기타', '배틀링 로프'), ('기타', '터키쉬 겟업'), ('기타', '마운틴 클라이머'), ('기타', '덤벨 버피');

-- -----------------------------------------------------------------------
-- 4. 가상 사용자 데이터 추가 (users 테이블)
-- -----------------------------------------------------------------------
INSERT INTO `users` (user_id, login_id, password, user_name, phone_number, birthdate, gender, role, created_at) VALUES 
(1, 'member01', '1234', '김민지', '010-1111-2222', '1998-03-15', 'female', 'member', NOW()),
(2, 'member02', '1234', '이서아', '010-3333-4444', '2001-07-22', 'female', 'member', NOW()),
(3, 'trainer01', '1234', '박서준', '010-5555-6666', '1988-12-16', 'male', 'trainer', NOW()),
(4, 'trainer02', '1234', '마동석', '010-7777-8888', '1971-03-01', 'male', 'trainer', NOW());

-- -----------------------------------------------------------------------
-- 5. 사용자별 선택 운동 데이터 추가 (selected_exercises 테이블)
-- -----------------------------------------------------------------------
-- [수정] 여러 데이터를 한 번에 INSERT 할 때 VALUES 키워드는 한 번만 사용하고 (값) 뒤에 콤마(,)로 구분합니다.
-- 김민지 회원(user_id=1): 하체, 등, 어깨 위주
INSERT INTO selected_exercises (user_id, exercise_id) VALUES
(1, (SELECT exercise_id FROM exercise WHERE exercise_name='바벨 백스쿼트')),
(1, (SELECT exercise_id FROM exercise WHERE exercise_name='컨벤셔널 데드리프트')),
(1, (SELECT exercise_id FROM exercise WHERE exercise_name='레그 프레스')),
(1, (SELECT exercise_id FROM exercise WHERE exercise_name='랫풀다운')),
(1, (SELECT exercise_id FROM exercise WHERE exercise_name='바벨 로우')),
(1, (SELECT exercise_id FROM exercise WHERE exercise_name='오버헤드 프레스')),
(1, (SELECT exercise_id FROM exercise WHERE exercise_name='덤벨 숄더 프레스')),
(1, (SELECT exercise_id FROM exercise WHERE exercise_name='덤벨 레터럴 레이즈')),
(1, (SELECT exercise_id FROM exercise WHERE exercise_name='벤치프레스')),
(1, (SELECT exercise_id FROM exercise WHERE exercise_name='싯업'));

-- 이서아 회원(user_id=2): 전신, 유산소 위주
INSERT INTO selected_exercises (user_id, exercise_id) VALUES
(2, (SELECT exercise_id FROM exercise WHERE exercise_name='푸시업')),
(2, (SELECT exercise_id FROM exercise WHERE exercise_name='덤벨 로우')),
(2, (SELECT exercise_id FROM exercise WHERE exercise_name='덤벨 런지')),
(2, (SELECT exercise_id FROM exercise WHERE exercise_name='플랭크')),
(2, (SELECT exercise_id FROM exercise WHERE exercise_name='점핑 잭')),
(2, (SELECT exercise_id FROM exercise WHERE exercise_name='버피')),
(2, (SELECT exercise_id FROM exercise WHERE exercise_name='트레드밀')),
(2, (SELECT exercise_id FROM exercise WHERE exercise_name='싸이클'));

-- 박서준 트레이너(user_id=3): 3대 운동 및 머신 위주
INSERT INTO selected_exercises (user_id, exercise_id) VALUES
(3, (SELECT exercise_id FROM exercise WHERE exercise_name='벤치프레스')),
(3, (SELECT exercise_id FROM exercise WHERE exercise_name='바벨 백스쿼트')),
(3, (SELECT exercise_id FROM exercise WHERE exercise_name='컨벤셔널 데드리프트')),
(3, (SELECT exercise_id FROM exercise WHERE exercise_name='체스트 프레스 머신')),
(3, (SELECT exercise_id FROM exercise WHERE exercise_name='랫풀다운')),
(3, (SELECT exercise_id FROM exercise WHERE exercise_name='숄더 프레스 머신')),
(3, (SELECT exercise_id FROM exercise WHERE exercise_name='레그 프레스')),
(3, (SELECT exercise_id FROM exercise WHERE exercise_name='케이블 크로스오버'));

-- 마동석 트레이너(user_id=4): 프리웨이트 및 팔 운동 위주
INSERT INTO selected_exercises (user_id, exercise_id) VALUES
(4, (SELECT exercise_id FROM exercise WHERE exercise_name='덤벨 벤치프레스')),
(4, (SELECT exercise_id FROM exercise WHERE exercise_name='덤벨 로우')),
(4, (SELECT exercise_id FROM exercise WHERE exercise_name='덤벨 숄더 프레스')),
(4, (SELECT exercise_id FROM exercise WHERE exercise_name='덤벨 컬')),
(4, (SELECT exercise_id FROM exercise WHERE exercise_name='덤벨 트라이셉 익스텐션')),
(4, (SELECT exercise_id FROM exercise WHERE exercise_name='바벨 컬')),
(4, (SELECT exercise_id FROM exercise WHERE exercise_name='클로즈 그립 벤치프레스')),
(4, (SELECT exercise_id FROM exercise WHERE exercise_name='풀업'));


-- -----------------------------------------------------------------------
-- 6. 운동 기록 데이터 추가 (workout_log 테이블)
-- -----------------------------------------------------------------------
-- 김민지 회원(user_id=1)의 운동 기록
INSERT INTO workout_log (log_date, weight, reps, created_at, log_type, user_id, user_exercise_id, writer_id) VALUES 
('2025-08-18', 60, 5, NOW(), 'NORMAL', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=(SELECT exercise_id FROM exercise WHERE exercise_name='바벨 백스쿼트')), 1),
('2025-08-18', 60, 5, NOW(), 'NORMAL', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=(SELECT exercise_id FROM exercise WHERE exercise_name='바벨 백스쿼트')), 1),
('2025-08-18', 40, 8, NOW(), 'NORMAL', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=(SELECT exercise_id FROM exercise WHERE exercise_name='랫풀다운')), 1),
('2025-08-20', 40, 10, NOW(), 'NORMAL', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=(SELECT exercise_id FROM exercise WHERE exercise_name='벤치프레스')), 1),
('2025-08-20', 40, 9, NOW(), 'NORMAL', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=(SELECT exercise_id FROM exercise WHERE exercise_name='벤치프레스')), 1),
('2025-08-20', 50, 1, NOW(), '1RM', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=(SELECT exercise_id FROM exercise WHERE exercise_name='벤치프레스')), 1),
('2025-08-22', 80, 1, NOW(), '1RM', 1, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=1 AND exercise_id=(SELECT exercise_id FROM exercise WHERE exercise_name='컨벤셔널 데드리프트')), 1);

-- 이서아 회원(user_id=2)의 운동 기록
INSERT INTO workout_log (log_date, weight, reps, created_at, log_type, user_id, user_exercise_id, writer_id) VALUES 
('2025-08-19', 0, 15, NOW(), 'NORMAL', 2, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=2 AND exercise_id=(SELECT exercise_id FROM exercise WHERE exercise_name='푸시업')), 2),
('2025-08-19', 0, 20, NOW(), 'NORMAL', 2, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=2 AND exercise_id=(SELECT exercise_id FROM exercise WHERE exercise_name='점핑 잭')), 2),
('2025-08-21', 10, 12, NOW(), 'NORMAL', 2, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=2 AND exercise_id=(SELECT exercise_id FROM exercise WHERE exercise_name='덤벨 로우')), 2),
('2025-08-21', 10, 12, NOW(), 'NORMAL', 2, (SELECT user_exercise_id FROM selected_exercises WHERE user_id=2 AND exercise_id=(SELECT exercise_id FROM exercise WHERE exercise_name='덤벨 로우')), 2);

-- -----------------------------------------------------------------------
-- 7. PT 회원 정보 추가 (pt_members 테이블)
-- -----------------------------------------------------------------------
INSERT INTO pt_members (total_sessions, job, consultation_date, fitness_goal, trainer_id, member_id) VALUES
(20, '대학생', '2025-08-01', '근력 증가 및 체력 향상', 3, 1), -- 박서준 트레이너가 김민지 회원 담당
(30, '직장인', '2025-07-15', '다이어트 및 바디프로필', 4, 2); -- 마동석 트레이너가 이서아 회원 담당
 

ALTER TABLE exercise
ADD COLUMN creator_id INT NULL DEFAULT NULL COMMENT '운동을 생성한 사용자의 ID. NULL이면 시스템 기본 운동';

select *
from users;

select *
from pt_members;

-- 1단계: 먼저 외래 키(FK) 제약 조건을 삭제합니다.
ALTER TABLE users 
DROP FOREIGN KEY fk_users_assigned_trainer;

-- 2단계: 이제 컬럼을 안전하게 삭제할 수 있습니다.
ALTER TABLE users 
DROP COLUMN assigned_trainer_id;
  
  -- 'fitlink_db' 데이터베이스의 모든 외래 키(FK) 관계를 조회하는 쿼리입니다.
SELECT 
    TABLE_NAME,                 -- FK가 설정된 테이블 이름
    COLUMN_NAME,                -- FK 컬럼 이름
    REFERENCED_TABLE_NAME,      -- FK가 참조하는 부모 테이블 이름
    REFERENCED_COLUMN_NAME      -- FK가 참조하는 부모 테이블의 컬럼 이름
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE 
    TABLE_SCHEMA = 'fitlink_db' -- 여기에 확인하고 싶은 데이터베이스 이름을 넣으세요.
    AND REFERENCED_TABLE_NAME IS NOT NULL;



SELECT u.user_id as userId,
	   u.user_name as userName,
	   u.phone_number as phoneNumber
FROM users u
JOIN pt_members pt ON u.user_id = pt.member_id
WHERE pt.trainer_id = 3
ORDER BY u.user_name ASC
;

select *
from reservation;

ALTER TABLE inbody ADD COLUMN inbody_score INT NULL;

-- 3번 회원(조강민)에게 모든 컬럼을 채운 테스트용 인바디 데이터 15개를 추가합니다.
INSERT INTO inbody (
    record_date, image_url, weight_kg, muscle_mass_kg, fat_mass_kg, bmi, 
    percent_body_fat, cid_type, visceral_fat_level, fat_control_kg, muscle_control_kg, 
    upper_lower_balance, left_right_balance, target_calories, required_protein_g, 
    carb_ratio, protein_ratio, fat_ratio, target_carb_kcal, target_protein_kcal, 
    target_fat_kcal, target_carb_g, target_protein_g, target_fat_g, breakfast_kcal, 
    breakfast_carb_g, breakfast_protein_g, breakfast_fat_g, lunch_kcal, lunch_carb_g, 
    lunch_protein_g, lunch_fat_g, dinner_kcal, dinner_carb_g, dinner_protein_g, 
    dinner_fat_g, user_id, inbody_score
) VALUES
('2025-08-25', '/upload/dummy.jpg', 75.3, 35.1, 15.2, 24.5, 20.2, 'D', 7, -5.2, 2.0, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 82),
('2025-08-18', '/upload/dummy.jpg', 75.1, 34.9, 15.5, 24.4, 20.6, 'D', 7, -5.5, 2.2, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 81),
('2025-08-11', '/upload/dummy.jpg', 74.8, 34.6, 15.8, 24.3, 21.1, 'I', 8, -5.8, 2.4, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 80),
('2025-08-04', '/upload/dummy.jpg', 74.5, 34.4, 16.1, 24.2, 21.6, 'I', 8, -6.1, 2.6, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 79),
('2025-07-28', '/upload/dummy.jpg', 74.2, 34.1, 16.4, 24.1, 22.1, 'I', 8, -6.4, 2.8, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 78),
('2025-07-21', '/upload/dummy.jpg', 73.9, 33.8, 16.7, 24.0, 22.6, 'C', 9, -6.7, 3.0, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 77),
('2025-07-14', '/upload/dummy.jpg', 73.5, 33.5, 17.0, 23.9, 23.1, 'C', 9, -7.0, 3.2, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 76),
('2025-07-07', '/upload/dummy.jpg', 73.1, 33.2, 17.3, 23.8, 23.7, 'C', 9, -7.3, 3.4, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 75),
('2025-06-30', '/upload/dummy.jpg', 72.8, 32.9, 17.6, 23.7, 24.2, 'C', 10, -7.6, 3.6, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 74),
('2025-06-23', '/upload/dummy.jpg', 72.4, 32.6, 17.9, 23.6, 24.7, 'C', 10, -7.9, 3.8, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 73),
('2025-06-16', '/upload/dummy.jpg', 72.0, 32.3, 18.2, 23.4, 25.3, 'C', 10, -8.2, 4.0, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 72),
('2025-06-09', '/upload/dummy.jpg', 71.7, 32.0, 18.5, 23.3, 25.8, 'C', 11, -8.5, 4.2, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 71),
('2025-06-02', '/upload/dummy.jpg', 71.3, 31.7, 18.8, 23.2, 26.4, 'C', 11, -8.8, 4.4, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 70),
('2025-05-26', '/upload/dummy.jpg', 71.0, 31.4, 19.1, 23.1, 26.9, 'C', 11, -9.1, 4.6, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 69),
('2025-05-19', '/upload/dummy.jpg', 70.6, 31.1, 19.4, 23.0, 27.5, 'C', 12, -9.4, 4.8, 'BALANCED', 'BALANCED', 2000, 150, 50, 30, 20, 1000, 600, 400, 250, 150, 44, 400, 50, 30, 8, 800, 100, 60, 18, 800, 100, 60, 18, 3, 68);

-- 시간 나오게 DATETIME으로 변경
ALTER TABLE inbody MODIFY COLUMN record_date DATETIME;

select *
from inbody
;

ALTER TABLE inbody
DROP COLUMN upper_lower_balance,
DROP COLUMN left_right_balance;

ALTER TABLE inbody 
ADD COLUMN height DECIMAL(5, 2) NULL COMMENT '측정 당시 키(cm)';

ALTER TABLE inbody
DROP COLUMN image_url;

ALTER TABLE inbody 
MODIFY COLUMN percent_body_fat DECIMAL(5, 2) NULL COMMENT '체지방률',
MODIFY COLUMN bmi DECIMAL(5, 2) NULL COMMENT 'BMI';

ALTER TABLE exercise
ADD COLUMN for_user_id INT NULL COMMENT '이 운동이 지정된 사용자(회원)의 ID. null이면 생성자 본인 또는 모두를 위한 운동.';