CREATE TABLE member_profile (
  member_id    INT PRIMARY KEY,
  job          VARCHAR(50)  NULL,
  consult_date DATE         NULL,
  goal         VARCHAR(100) NULL,
  memo         VARCHAR(500) NULL,
  updated_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_member_profile_member
    FOREIGN KEY (member_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT *
FROM member_profile;

ALTER TABLE member_profile
  MODIFY COLUMN goal ENUM(
    '체중감량',
    '근력강화',
    '체형교정',
    '체력향상',
    '재활/건강관리',
    '생활습관 개선',
    '대회/목표 준비'
  ) NULL;
  
-- 잠깐 해제
SET SQL_SAFE_UPDATES = 0;

-- 값 정규화
UPDATE member_profile SET goal='체형교정'  WHERE goal IN ('자세교정','자세 교정');
UPDATE member_profile SET goal='체중감량'  WHERE goal IN ('다이어트','감량');

-- 다시 켜기
SET SQL_SAFE_UPDATES = 1;

UPDATE member_profile
SET goal = '체중감량'
WHERE member_id = 4;
