CREATE TABLE pt_contract (
  contract_id    INT AUTO_INCREMENT PRIMARY KEY,
  member_id      INT NOT NULL,
  trainer_id     INT NOT NULL,
  total_sessions INT NOT NULL CHECK (total_sessions > 0),
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_pt_contract_member_trainer (member_id, trainer_id),
  CONSTRAINT fk_pt_contract_member
    FOREIGN KEY (member_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pt_contract_trainer
    FOREIGN KEY (trainer_id) REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT *
FROM pt_contract;

ALTER TABLE pt_contract
  ADD INDEX idx_pt_contract_mtc (member_id, trainer_id, created_at);

SELECT * FROM pt_contract WHERE member_id = 3 AND trainer_id = 1;

INSERT INTO pt_contract(member_id, trainer_id, total_sessions, created_at)
VALUES (3, 1, 20, NOW());

