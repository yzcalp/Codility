
drop table if exists answer;
create table answer 
(
	eventType INT,
    LastAct INT
);

DELIMITER $$
drop procedure if EXISTS myp;
create PROCEDURE myp()
BEGIN
	-- declare variables that will be used in procedure
	DECLARE i INT;
    DECLARE temp_cursor INT;
    DECLARE DONE BOOLEAN DEFAULT FALSE;
    
    -- declare cursor variables
    DECLARE mycursor CURSOR FOR
    SELECT DISTINCT(e.event_type) FROM EVENTS e;
    DECLARE continue HANDLER FOR not FOUND set DONE = TRUE;
    
    -- open cursor
    open mycursor;
    currloop: loop
		if DONE THEN
			leave currloop;
        end if;
        
		-- for every distinct value get last two value and subtrat it
		FETCH mycursor INTO temp_cursor;
        drop table if exists t1;
		create table t1 as
		select * from events where event_type = temp_cursor order by time desc limit 2;
        
        insert into answer
        select t2.event_type,t2.value - t3.value from t1 t2 CROSS join t1 t3 
		on t2.event_type = t3.event_type 
		where t2.time > t3.time; 
        
        
    
    end loop currloop;
    close mycursor;
    
    -- displaying answer
	select * from answer;
END; $$
DELIMITER ;

call myp();
