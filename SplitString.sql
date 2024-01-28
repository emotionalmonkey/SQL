CREATE PROCEDURE usp_SplitString(
IN inputString text,
IN delimiterChar CHAR(1)
)
BEGIN
	DROP TEMPORARY TABLE IF EXISTS temp_string;
	CREATE TEMPORARY TABLE temp_string(id int auto_increment key, vals text); 

 -- If there is no delimiterChar
	IF delimiterChar <> '' THEN
	  BEGIN
		  WHILE LOCATE(delimiterChar,inputString) > 1 DO
			INSERT INTO temp_string(vals)
			SELECT SUBSTRING_INDEX(inputString, delimiterChar, 1);
			SET inputString = SUBSTRING(inputString, LOCATE(delimiterChar, inputString) + 1, LENGTH(inputString));
		  END WHILE;
		  INSERT INTO temp_string(vals) VALUES(inputString);	  
	  END;
	  ELSE
	  BEGIN
			DECLARE i INT;
			SET i = LENGTH(inputString);
			WHILE i > 0 DO
				INSERT INTO temp_string(vals) SELECT LEFT(inputString,1);
				SET inputString = SUBSTRING(inputString, 2, LENGTH(inputString));        
				SET i = i - 1;
			END WHILE;
	  END;
	END IF;
	SELECT Id, TRIM(vals) AS Output FROM temp_string;   
END
