
DROP PROCEDURE IF EXISTS  DeleteAndReorder;

DELIMITER //

CREATE PROCEDURE DeleteAndReorder(IN p_table_name VARCHAR(255), IN p_id_column_name VARCHAR(255), IN p_id INT)
BEGIN
    DECLARE v_query VARCHAR(1024);
    DECLARE v_auto_increment INT;
    
    -- Удаление записи с указанным id
    SET v_query = CONCAT('DELETE FROM ', p_table_name, ' WHERE ', p_id_column_name,' = ', p_id);
    SET @v_query = v_query;
    PREPARE stmt FROM @v_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Обновление id других записей, чтобы они шли по порядку
    SET @row_number = 0;
    SET v_query = CONCAT('UPDATE ', p_table_name, ' SET ', p_id_column_name, ' = (@row_number := @row_number + 1) ORDER BY ', p_id_column_name);
    SET @v_query = v_query;
    PREPARE stmt FROM @v_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Создание временной таблицы для хранения количества строк
    CREATE TEMPORARY TABLE temp_count (count INT);
    
    -- Подсчет количества строк в таблице
    SET v_query = CONCAT('INSERT INTO temp_count SELECT COUNT(*) FROM ', p_table_name);
    SET @v_query = v_query;
    PREPARE stmt FROM @v_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Получение значения из временной таблицы
    SELECT count INTO v_auto_increment FROM temp_count;
    
    -- Обновление значения AUTO_INCREMENT
    SET v_auto_increment = v_auto_increment + 1;
    SET v_query = CONCAT('ALTER TABLE ', p_table_name, ' AUTO_INCREMENT = ', v_auto_increment);
    SET @v_query = v_query;
    PREPARE stmt FROM @v_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- Удаление временной таблицы
    DROP TEMPORARY TABLE temp_count;
END //

DELIMITER ;

select * from Vapes;

SET SQL_SAFE_UPDATES = 0;
call DeleteAndReorder('Vapes', 'id_vape', 9);
SET SQL_SAFE_UPDATES = 1;



-- -----------------------------------

DROP PROCEDURE IF EXISTS get_the_long_living_player;

DELIMITER //
CREATE PROCEDURE get_the_long_living_player()
BEGIN
	select * from Players as p
	where p.id_player = (select Players_id_player from Claims as cl
							JOIN Vapes as v ON v.id_vape = cl.Vapes_id_vape AND v.id_server = 1
						order by cl.created_at
						LIMIT 1);
END //
DELIMITER ;
