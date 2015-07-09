\c ecomap_db;
DROP TABLE IF EXISTS detailed_problem;
DROP VIEW IF EXISTS detailed_problem;
CREATE VIEW detailed_problem AS
SELECT problems.id,
			 problems.title,
       problems.content,
       problems.proposal,
       problems.severity,
       problems.status,
       problems.location,
       problems.problem_type_id,
       problems.region_id,
			 number_of_votes,
			 datetime,
			 first_name,
			 last_name ,
			 COUNT( comments.id) AS number_of_comments
FROM problems
LEFT OUTER JOIN (SELECT problems_activities.problem_id AS id,
						count(*) AS number_of_votes
						FROM problems_activities
						WHERE problems_activities.activity_type = 'VOTE'
						GROUP BY problems_activities.problem_id ) AS A
						ON problems.id = A.id
LEFT OUTER JOIN (SELECT problems_activities.problem_id AS id,
						datetime AS datetime FROM problems_activities
						WHERE problems_activities.activity_type  = 'ADDED' ) AS B
						ON problems.id = B.id
LEFT OUTER JOIN (SELECT problems_activities.problem_id,
						users.first_name,
						users.last_name
						FROM problems_activities
						LEFT OUTER JOIN users
						ON users.id = problems_activities.user_id
						WHERE  problems_activities.activity_type =  'ADDED'
						GROUP BY problem_id, users.first_name, users.last_name) as C
						ON C.problem_id = problems.id
LEFT OUTER JOIN comments ON problems.id = comments.problem_id

WHERE problems.id NOT IN (SELECT problems_activities.problem_id
					          FROM problems_activities
					          WHERE problems_activities.activity_type =  'REMOVED' )
GROUP BY problems.id,
				 problems.title,
				 problems.proposal,
				 number_of_votes,
				 datetime,
				 first_name,
				 last_name
ORDER BY  problems.id;
\q
