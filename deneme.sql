-- sample.sql
SELECT DISTINCT event_type FROM events;
DROP TABLE IF EXISTS answer;
CREATE TABLE answer (
    eventType INT,
    LastAct INT
);

DROP TABLE IF EXISTS distinct_event_types;
CREATE TEMPORARY TABLE distinct_event_types AS
SELECT DISTINCT event_type FROM events;

INSERT INTO answer (eventType, LastAct)
SELECT t2.event_type, t2.value - t3.value
FROM (
    SELECT event_type, time, value, 
           ROW_NUMBER() OVER (PARTITION BY event_type ORDER BY time DESC) as row_num
    FROM events
) t1
JOIN (
    SELECT event_type, time, value, 
           ROW_NUMBER() OVER (PARTITION BY event_type ORDER BY time DESC) as row_num
    FROM events
) t2
ON t1.event_type = t2.event_type
AND t1.row_num = 1
AND t2.row_num = 2;

SELECT * FROM answer;

