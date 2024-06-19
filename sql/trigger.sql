DELIMITER //

DROP PROCEDURE IF EXISTS Check_Admin_Oasis_Nightmares;

CREATE PROCEDURE Check_Admin_Oasis_Nightmares()
BEGIN
    DECLARE role_check INT;

    -- Проверяем, есть ли у текущего пользователя роль 'Админ_Деревушки'
   --  SELECT *
--     FROM mysql.role_edges
    
    SELECT count(*) INTO role_check
    FROM mysql.role_edges
    WHERE FROM_USER = 'admin_oasis_nightmares' 
    AND TO_USER = SUBSTRING_INDEX(CURRENT_USER(), '@', 1)
    AND TO_HOST = SUBSTRING_INDEX(CURRENT_USER(), '@', -1);

    -- Если роли нет, вызываем ошибку
    IF role_check = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Permission denied. You must have Админ_Деревушки role to perform this action.';
    END IF;
END //

DELIMITER ;

-- CALL Check_Admin_Oasis_Nightmares();


DELIMITER //

DROP TRIGGER IF EXISTS before_update_on_vapes;

CREATE TRIGGER before_update_on_vapes
BEFORE UPDATE ON Vapes
FOR EACH ROW
BEGIN
    -- Проверяем, что изменяемая строка относится к серверу "Деревушка" (id_server = 1, например)
    IF OLD.id_server = 1 THEN
        CALL Check_Admin_Oasis_Nightmares();
    END IF;
END //

-- CREATE TRIGGER before_delete_on_zaprosy
-- BEFORE DELETE ON Запросы
-- FOR EACH ROW
-- BEGIN
--     -- Проверяем, что удаляемая строка относится к серверу "Деревушка" (id_server = 1, например)
--     IF OLD.id_server = 1 THEN
--         CALL Check_Admin_Derevushka();
--     END IF;
-- END //

DELIMITER ;

