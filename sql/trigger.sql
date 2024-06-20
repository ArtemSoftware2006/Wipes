
DROP PROCEDURE IF EXISTS Check_Admin_Oasis_Nightmares;
DELIMITER //

CREATE PROCEDURE Check_Admin_Oasis_Nightmares()
SQL SECURITY INVOKER
BEGIN
    DECLARE role_check INT;

    -- Убедитесь, что пользователь имеет роль admin_oasis_nightmares
    SELECT COUNT(*)
    INTO role_check
    FROM mysql.role_edges
    WHERE FROM_USER = 'admin_oasis_nightmares'
    AND TO_USER = SUBSTRING_INDEX(user(), '@', 1);

    -- Если роли нет, вызываем ошибку
    IF role_check = 0 THEN
        SET v_log_message = 'Permission denied. You must have admin_oasis_nightmares role to perform this action.';
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = v_log_message;
    END IF;
END //

DELIMITER ;


DROP PROCEDURE IF EXISTS Check_Admin_Kerrol_Village;

DELIMITER //

CREATE PROCEDURE Check_Admin_Kerrol_Village()
SQL SECURITY INVOKER
BEGIN
    DECLARE role_check INT;

    SELECT count(*) INTO role_check
    FROM mysql.role_edges
    WHERE FROM_USER = 'admin_kerrol_village' 
    AND TO_USER = SUBSTRING_INDEX(user(), '@', 1);
    
    -- Если роли нет, вызываем ошибку
    IF role_check = 0 THEN
        SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Permission denied. You must have Деревушки role to perform this action.';
    END IF;
END //

DELIMITER ;

DROP TRIGGER IF EXISTS before_update_on_vapes;

DELIMITER //

CREATE TRIGGER before_update_on_vapes
BEFORE UPDATE ON Vapes
FOR EACH ROW
BEGIN
    -- Проверяем, что изменяемая строка относится к серверу "Деревушка" (id_server = 1, например)
    IF OLD.id_server = 1 THEN
        CALL Check_Admin_Oasis_Nightmares();
	ELSEIF OLD.id_server = 2 THEN
         CALL Check_Admin_Kerrol_Village();
     END IF;
END //

DELIMITER ;

DROP TRIGGER IF EXISTS before_delete_on_vapes;

DELIMITER //

CREATE TRIGGER before_delete_on_vapes
BEFORE delete ON Vapes
FOR EACH ROW
BEGIN
    -- Проверяем, что изменяемая строка относится к серверу "Деревушка" (id_server = 1, например)
    IF OLD.id_server = 1 THEN
        CALL Check_Admin_Oasis_Nightmares();
    ELSEIF OLD.id_server = 2 THEN
        CALL Check_Admin_Kerrol_Village();
    END IF;
END //

DELIMITER ;

DROP TRIGGER IF EXISTS before_insert_on_vapes;

DELIMITER //

CREATE TRIGGER before_insert_on_vapes
BEFORE insert ON Vapes
FOR EACH ROW
BEGIN
    -- Проверяем, что изменяемая строка относится к серверу "Деревушка" (id_server = 1, например)
    IF NEW.id_server = 1 THEN
        CALL Check_Admin_Oasis_Nightmares();
    ELSEIF NEW.id_server = 2 THEN
        CALL Check_Admin_Kerrol_Village();
    END IF;
END //

DELIMITER ;



