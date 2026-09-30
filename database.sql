CREATE TABLE IF NOT EXISTS towtruck_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    towtruck_owned BOOLEAN DEFAULT FALSE,
    towtruck_model VARCHAR(50),
    towtruck_plate VARCHAR(10),
    UNIQUE KEY unique_player (player_id)
);

INSERT INTO towtruck_data (player_id, towtruck_owned, towtruck_model, towtruck_plate) VALUES (1, TRUE, 'flatbed', 'TOW001');