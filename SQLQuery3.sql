CREATE TABLE events_history (
  id INT NOT NULL,
  name VARCHAR(255),
  sex CHAR(1),
  age VARCHAR(255),
  height VARCHAR(255),
  weight VARCHAR(255),
  team VARCHAR(255),
  noc VARCHAR(3),
  games VARCHAR(255),
  year INT,
  season VARCHAR(6),
  city VARCHAR(255),
  sport VARCHAR(255),
  event VARCHAR(255),
  medal VARCHAR(255),
  PRIMARY KEY (id)
)

SELECT *
FROM events

DROP TABLE events_history

SELECT COUNT(DISTINCT games) as num_games FROM events WHERE sport='Athletics';


SELECT DISTINCT games FROM events;

SELECT games FROM events
WHERE season LIKE '%Summer%'

SELECT sport, COUNT(DISTINCT games) AS num_appearances FROM events
WHERE season = 'Summer'
GROUP BY sport
HAVING COUNT(DISTINCT games) = (SELECT COUNT(DISTINCT games) FROM events WHERE season = 'Summer');

SELECT sport, event, COUNT(*) AS medal_count
FROM events
WHERE noc = 'IND' AND medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY sport, event
ORDER BY medal_count DESC
LIMIT 1;

SELECT sport FROM events
GROUP BY sport
HAVING COUNT(DISTINCT sport) = 1;


SELECT TOP 5 name, COUNT(*) AS num_gold_medals
FROM events
WHERE medal = 'Gold'
GROUP BY name
ORDER BY num_gold_medals DESC;


SELECT noc, 
       COUNT(CASE WHEN medal = 'Gold' THEN 1 END) AS num_gold_medals,
       COUNT(CASE WHEN medal = 'Silver' THEN 1 END) AS num_silver_medals,
       COUNT(CASE WHEN medal = 'Bronze' THEN 1 END) AS num_bronze_medals
FROM events
GROUP BY noc
HAVING COUNT(*) > 0
ORDER BY num_gold_medals DESC;


SELECT 
    games, 
    MAX(CASE WHEN medal = 'Gold' THEN noc END) AS gold_winner,
    MAX(CASE WHEN medal = 'Silver' THEN noc END) AS silver_winner,
    MAX(CASE WHEN medal = 'Bronze' THEN noc END) AS bronze_winner
FROM events
WHERE medal IS NOT NULL
GROUP BY games
ORDER BY games ASC;


SELECT 
    games, 
    MAX(CASE WHEN medal = 'Gold' THEN noc END) AS gold_winner,
    SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS gold_count,
    MAX(CASE WHEN medal = 'Silver' THEN noc END) AS silver_winner,
    SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver_count,
    MAX(CASE WHEN medal = 'Bronze' THEN noc END) AS bronze_winner,
    SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_count
FROM events
WHERE medal IS NOT NULL
GROUP BY games
ORDER BY games ASC;


SELECT noc, 
       SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS silver_count,
       SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS bronze_count
FROM events
WHERE noc IN (
    SELECT DISTINCT noc
    FROM events
    WHERE medal = 'Silver' AND noc NOT IN (
        SELECT DISTINCT noc
        FROM events
        WHERE medal = 'Gold'
    ) AND noc IN (
        SELECT DISTINCT noc
        FROM events
        WHERE medal = 'Bronze'
    )
)
GROUP BY noc;


SELECT sport, event, COUNT(*) AS medal_count
FROM events
WHERE noc = 'IND' AND medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY sport, event
HAVING COUNT(*) = (
    SELECT MAX(medal_count)
    FROM (
        SELECT sport, event, COUNT(*) AS medal_count
        FROM events
        WHERE noc = 'IND' AND medal IN ('Gold', 'Silver', 'Bronze')
        GROUP BY sport, event
    ) AS subquery
);