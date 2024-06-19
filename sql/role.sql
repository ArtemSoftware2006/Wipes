CREATE ROLE 'observer';
GRANT SELECT ON vapes.top_things_in_claims TO 'observer';

GRANT 'observer' TO 'oasis_nightmares'@'localhost';
GRANT 'observer' TO 'kerrol_village'@'localhost';

CREATE ROLE 'admin_oasis_nightmares';	
GRANT 'admin_oasis_nightmares' TO 'oasis_nightmares'@'localhost';

CREATE ROLE 'admin_kerrol_village';
GRANT 'kerrol_village' TO 'kerrol_village'@'localhost';

FLUSH privileges;
SHOW GRANTS FOR 'oasis_nightmares'@'localhost';
SHOW GRANTS FOR 'kerrol_village'@'localhost';


--------------------------------

SET ROLE ALL;
SET DEFAULT ROLE ALL TO 'oasis_nightmares'@'localhost';

GRANT SELECT ON vapes.Claims
TO 'kerrol_village'@'localhost';
GRANT SELECT ON vapes.Vapes
TO 'kerrol_village'@'localhost';
GRANT SELECT ON vapes.Claims_has_Things
TO 'kerrol_village'@'localhost';

FLUSH PRIVILEGES;

 SELECT *
        FROM mysql.user
        WHERE grantee = CONCAT('\'', CURRENT_USER(), '\'' )
        AND role_name = 'Админ_Деревушки';



CREATE ROLE 'observer';
revoke SELECT ON vapes.top_things_in_claims from 'observer';
GRANT SELECT ON vapes.top_things_in_claims TO 'observer' WITH GRANT OPTION;

CREATE ROLE 'observer2';
revoke SELECT ON vapes.Steam_Accounts from 'observer2';
GRANT SELECT ON vapes.Steam_Accounts TO 'observer2';

GRANT 'observer' TO 'oasis_nightmares'@'localhost';
GRANT 'observer2' TO 'oasis_nightmares'@'localhost';
GRANT 'observer' TO 'kerrol_village'@'localhost';

CREATE ROLE 'admin_oasis_nightmares';	
GRANT 'admin_oasis_nightmares' TO 'oasis_nightmares'@'localhost';

CREATE ROLE 'admin_kerrol_village';
GRANT 'kerrol_village' TO 'kerrol_village'@'localhost';

FLUSH privileges;
SHOW GRANTS FOR 'oasis_nightmares'@'localhost';
SHOW GRANTS FOR 'kerrol_village'@'localhost';

SHOW GRANTS FOR 'observer';

SHOW GRANTS FOR 'oasis_nightmares'@'localhost';



