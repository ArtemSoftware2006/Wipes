CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `all_cliams_oasis_nightmares` AS
    SELECT 
        `cl`.`id_claim` AS `id_claim`,
        `v`.`id_vape` AS `id_vape`,
        `s`.`name` AS `server_name`,
        `cl_s`.`name` AS `status`,
        `v`.`started_at` AS `started_at`
    FROM
        (((`Servers` `s`
        JOIN `Vapes` `v` ON ((`v`.`id_server` = `s`.`id_server`)))
        JOIN `Claims` `cl` ON ((`cl`.`Vapes_id_vape` = `v`.`id_vape`)))
        JOIN `Claim_Statuses` `cl_s` ON ((`cl_s`.`id_claim_status` = `cl`.`ClaimStatuses_id_claim_status`)))
    WHERE
        ((`s`.`id_server` = 1)
            AND (`v`.`id_vape` = (SELECT 
                `Vapes`.`id_vape`
            FROM
                `Vapes`
            WHERE
                (`Vapes`.`id_server` = `s`.`id_server`)
            ORDER BY `Vapes`.`started_at` DESC
            LIMIT 1)))

---------

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `approved_cliams_oasis_nightmares` AS
    SELECT 
        `cl`.`id_claim` AS `id_claim`,
        `v`.`id_vape` AS `id_vape`,
        `s`.`name` AS `server_name`,
        `cl_s`.`name` AS `status`,
        `v`.`started_at` AS `started_at`
    FROM
        (((`Servers` `s`
        JOIN `Vapes` `v` ON ((`v`.`id_server` = `s`.`id_server`)))
        JOIN `Claims` `cl` ON ((`cl`.`Vapes_id_vape` = `v`.`id_vape`)))
        JOIN `Claim_Statuses` `cl_s` ON (((`cl_s`.`id_claim_status` = `cl`.`ClaimStatuses_id_claim_status`)
            AND (`cl_s`.`id_claim_status` = 3))))
    WHERE
        ((`s`.`id_server` = 1)
            AND (`v`.`id_vape` = (SELECT 
                `Vapes`.`id_vape`
            FROM
                `Vapes`
            WHERE
                (`Vapes`.`id_server` = `s`.`id_server`)
            ORDER BY `Vapes`.`started_at` DESC
            LIMIT 1)))
-------------

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `top_claims_kerrol_village` AS
    SELECT 
        `ds`.`login` AS `login`,
        `pl`.`dst_nickname` AS `dst_nickname`,
        COUNT(`cl`.`Players_id_player`) AS `claim_count`,
        `s`.`name` AS `name`
    FROM
        ((((`Servers` `s`
        JOIN `Vapes` `v` ON ((`v`.`id_server` = `s`.`id_server`)))
        JOIN `Claims` `cl` ON ((`cl`.`Vapes_id_vape` = `v`.`id_vape`)))
        JOIN `Players` `pl` ON ((`pl`.`id_player` = `cl`.`Players_id_player`)))
        JOIN `Discord_Accounts` `ds` ON ((`ds`.`id_discord_accounts` = `pl`.`id_discord_accounts`)))
    WHERE
        (`s`.`id_server` = 2)
    GROUP BY `cl`.`Players_id_player` , `pl`.`dst_nickname` , `ds`.`login` , `s`.`name`

------------------------

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `top_claims_on_servers` AS
    SELECT 
        `ds`.`login` AS `login`,
        `pl`.`dst_nickname` AS `dst_nickname`,
        COUNT(`cl`.`Players_id_player`) AS `claim_count`,
        `s`.`name` AS `name`
    FROM
        ((((`Claims` `cl`
        JOIN `Players` `pl` ON ((`pl`.`id_player` = `cl`.`Players_id_player`)))
        JOIN `Discord_Accounts` `ds` ON ((`ds`.`id_discord_accounts` = `pl`.`id_discord_accounts`)))
        JOIN `Vapes` `v` ON ((`v`.`id_vape` = `cl`.`Vapes_id_vape`)))
        JOIN `Servers` `s` ON ((`s`.`id_server` = `v`.`id_server`)))
    GROUP BY `cl`.`Players_id_player` , `pl`.`dst_nickname` , `ds`.`login` , `s`.`name`


-----------------------------

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `top_things` AS
    SELECT 
        `th`.`name` AS `name`,
        COUNT(`cl_th`.`id_Claims_has_Things`) AS `thing_count`
    FROM
        (`Claims_has_Things` `cl_th`
        JOIN `Things` `th` ON ((`th`.`id_thing` = `cl_th`.`Things_id_thing`)))
    GROUP BY `cl_th`.`Things_id_thing`
    ORDER BY COUNT(`cl_th`.`id_Claims_has_Things`) DESC