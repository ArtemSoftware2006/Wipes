GRANT SELECT ON vapes.top_claims_on_server_oasis_nightmares
TO 'oasis_nightmares'@'localhost';
GRANT SELECT ON vapes.executed_claims_oasis_nightmares
TO 'oasis_nightmares'@'localhost';
GRANT SELECT ON vapes.not_approved_claims_oasis_nightmares
TO 'oasis_nightmares'@'localhost';
GRANT SELECT ON vapes.approved_claims_oasis_nightmares
TO 'oasis_nightmares'@'localhost';
GRANT SELECT ON vapes.all_cliams_oasis_nightmares
TO 'oasis_nightmares'@'localhost';

GRANT SELECT, update, delete ON vapes.Claims
TO 'oasis_nightmares'@'localhost';
GRANT SELECT, update, delete ON vapes.Vapes
TO 'oasis_nightmares'@'localhost';
GRANT SELECT, update, delete ON vapes.Claims_has_Things
TO 'oasis_nightmares'@'localhost';
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'oasis_nightmares'@'localhost';


GRANT SELECT ON vapes.top_claims_on_server_kerrol_village
TO 'kerrol_village'@'localhost';
GRANT SELECT ON vapes.executed_claims_kerrol_village
TO 'kerrol_village'@'localhost';
GRANT SELECT ON vapes.not_approved_claims_kerrol_village
TO 'kerrol_village'@'localhost';
GRANT SELECT ON vapes.approved_claims_kerrol_village
TO 'kerrol_village'@'localhost';
GRANT SELECT ON vapes.all_claims_kerrol_village
TO 'kerrol_village'@'localhost';

GRANT SELECT, update, delete ON vapes.Claims
TO 'kerrol_village'@'localhost';
GRANT SELECT, update, delete ON vapes.Vapes
TO 'kerrol_village'@'localhost';
GRANT SELECT, update, delete ON vapes.Claims_has_Things
TO 'kerrol_village'@'localhost';
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'kerrol_village'@'localhost';


GRANT ALL PRIVILEGES ON vapes.* TO 'admin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

SHOW GRANTS FOR 'admin'@'localhost';
 