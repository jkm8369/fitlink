CREATE TABLE reservation (
  reservation_id  INT AUTO_INCREMENT PRIMARY KEY,
  member_id       INT NOT NULL,
  availability_id INT NOT NULL,
  status          ENUM('BOOKED','COMPLETED') NOT NULL,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_reservation_member_status (member_id, status),
  KEY idx_reservation_availability  (availability_id),
  CONSTRAINT fk_reservation_member
    FOREIGN KEY (member_id) REFERENCES users(user_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_reservation_availability
    FOREIGN KEY (availability_id) REFERENCES availability(availability_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SELECT *
FROM reservation;