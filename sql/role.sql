CREATE ROLE 'observer';
GRANT SELECT ON vapes.top_things_in_claims TO 'observer';

GRANT 'observer' TO 'oasis_nightmares'@'localhost';
GRANT 'observer' TO 'kerrol_village'@'localhost';

CREATE ROLE 'admin_oasis_nightmares';	
GRANT 'admin_oasis_nightmares' TO 'oasis_nightmares'@'localhost';

CREATE ROLE 'admin_kerrol_village';
GRANT 'admin_kerrol_village' TO 'kerrol_village'@'localhost';

FLUSH privileges;
SET DEFAULT ROLE ALL TO 'kerrol_village'@'localhost';
SET DEFAULT ROLE ALL TO 'oasis_nightmares'@'localhost';

SHOW GRANTS FOR 'oasis_nightmares'@'localhost';
SHOW GRANTS FOR 'kerrol_village'@'localhost';




