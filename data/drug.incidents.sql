COPY (SELECT 
	id,
	count (*) as total, 
	count (*) filter (WHERE 
		"offense description" ILIKE '% POSS%' AND "offense description" NOT ILIKE '%INTENT%'
	) as total_possession, 
	count (*) filter (WHERE 
		"offense description" ILIKE '% TRAFF%' OR "offense description" ILIKE '%INTENT%' OR  "offense description" ILIKE '% SALE %'
	) as total_distribution, 
	count (*) filter (WHERE
		"occurred on date"::timestamp >= date_trunc ('week', CURRENT_TIMESTAMP)
	) as incidents_this_week,
	count (*) filter (WHERE
		"occurred on date"::timestamp >= date_trunc ('week', CURRENT_TIMESTAMP) AND
		"offense description" ILIKE '% POSS%' AND "offense description" NOT ILIKE '%INTENT%'
	) as possession_this_week,
	count (*) filter (WHERE
		"occurred on date"::timestamp >= date_trunc ('week', CURRENT_TIMESTAMP) AND
		("offense description" ILIKE '% TRAFF%' OR "offense description" ILIKE '%INTENT%' OR  "offense description" ILIKE '% SALE %')
	) as distribution_this_week,
	count (*) filter (WHERE 
		"occurred on date"::timestamp >= date_trunc ('week', CURRENT_TIMESTAMP) - interval '1 week' AND 
		"occurred on date"::timestamp < date_trunc ('week', CURRENT_TIMESTAMP)
	) as incidents_last_week,
	count (*) filter (WHERE 
		"occurred on date"::timestamp >= date_trunc ('week', CURRENT_TIMESTAMP) - interval '1 week' AND 
		"occurred on date"::timestamp < date_trunc ('week', CURRENT_TIMESTAMP) AND
		"offense description" ILIKE '% POSS%' AND "offense description" NOT ILIKE '%INTENT%'
	) as possession_last_week,
	count (*) filter (WHERE 
		"occurred on date"::timestamp >= date_trunc ('week', CURRENT_TIMESTAMP) - interval '1 week' AND 
		"occurred on date"::timestamp < date_trunc ('week', CURRENT_TIMESTAMP) AND
		("offense description" ILIKE '% TRAFF%' OR "offense description" ILIKE '%INTENT%' OR  "offense description" ILIKE '% SALE %')
	) as distribution_last_week,
	count (*) filter (WHERE
		"occurred on date"::timestamp >= date_trunc ('month', CURRENT_TIMESTAMP)
	) as incidents_this_month,
	count (*) filter (WHERE
		"occurred on date"::timestamp >= date_trunc ('month', CURRENT_TIMESTAMP) AND
		"offense description" ILIKE '% POSS%' AND "offense description" NOT ILIKE '%INTENT%'
	) as possession_this_month,
	count (*) filter (WHERE
		"occurred on date"::timestamp >= date_trunc ('month', CURRENT_TIMESTAMP) AND
		("offense description" ILIKE '% TRAFF%' OR "offense description" ILIKE '%INTENT%' OR  "offense description" ILIKE '% SALE %')
	) as distribution_this_month,
	count (*) filter (WHERE
		"occurred on date"::timestamp >= date_trunc ('month', CURRENT_TIMESTAMP) - interval '1 month' AND
		"occurred on date"::timestamp < date_trunc ('month', CURRENT_TIMESTAMP)
	) as incidents_last_month,
	count (*) filter (WHERE
		"occurred on date"::timestamp >= date_trunc ('month', CURRENT_TIMESTAMP) - interval '1 month' AND
		"occurred on date"::timestamp < date_trunc ('month', CURRENT_TIMESTAMP) AND
		"offense description" ILIKE '% POSS%' AND "offense description" NOT ILIKE '%INTENT%'
	) as incidents_last_month,
	count (*) filter (WHERE
		"occurred on date"::timestamp >= date_trunc ('month', CURRENT_TIMESTAMP) - interval '1 month' AND
		"occurred on date"::timestamp < date_trunc ('month', CURRENT_TIMESTAMP) AND
		("offense description" ILIKE '% TRAFF%' OR "offense description" ILIKE '%INTENT%' OR  "offense description" ILIKE '% SALE %')
	) as distribution_last_month,
	count (*) filter (WHERE
		"offense code" = '01849' OR "offense code" = '1849'
	) as cocaine_possession,
	count (*) filter (WHERe
		"offense code" = '01843' OR "offense code" = '1848'
	) as cocaine_distribution,
	count (*) filter (WHERE
		"offense code" = '01842' OR "offense code" = '1842'
	) as heroin_possession,
	count (*) filter (WHERE
		"offense code" = '01841' OR "offense code" = '1841'
	) as heroin_distribution,
	count (*) filter (WHERE 
		"offense code" = '01844'
	) as class_c_possession,
	count (*) filter (WHERE
		"offense code" = '01847'
	) as class_c_distribution,
	count (*) filter (WHERE
		"offense code" = '01845' OR "offense code" = '1863'
	) as class_d_possession,
	count (*) filter (WHERE
		"offense code" = '01848'
	) as class_d_distribution,
	count (*) filter (WHERE
		"offense code" = '01846'
	) as class_e_possession,
	count (*) filter (WHERE
		"offense code" = '01850'
	)
FROM 
	(
	SELECT
		i.*,
		(
		SELECT
			id
		FROM 
			boston_grid grid
		ORDER BY
			ST_SetSRID (grid.geom, 4326) <-> ST_FlipCoordinates (ST_SetSRID (ST_MakePoint (coalesce (nullif (lat, ''), '0')::numeric, coalesce (nullif (long, ''), '0')::numeric), 4326))
		LIMIT 1
		) as id 

	FROM
		incidents i
	WHERE
		lat != '' AND long != ''
		AND "offense code group" = 'Drug Violation'
	) a
GROUP BY 
	id
ORDER BY 
	total DESC
) TO '/tmp/incidents.csv' CSV HEADER;
