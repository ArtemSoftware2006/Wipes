select cl.id_claim, v.id_vape, s.name as 'server_name', cl_s.name as 'status', v.started_at FROM Servers AS s
	JOIN Vapes as v ON v.id_server = s.id_server
    JOIN Claims as cl ON cl.Vapes_id_vape = v.id_vape -- and cl.ClaimStatuses_id_claim_status = 3
    JOIN Claim_Statuses as cl_s ON cl_s.id_claim_status = cl.ClaimStatuses_id_claim_status
WHERE 
	s.id_server = 1
    AND v.id_vape = (
		SELECT id_vape
		FROM Vapes
		WHERE id_server = s.id_server
		ORDER BY started_at DESC
		LIMIT 1
	);