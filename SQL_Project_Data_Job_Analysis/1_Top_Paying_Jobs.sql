/*
Quesiton: What are the top paying data analyst jobs?
-Identify the top 10 higest paying Data Analyst roles available in the state of Florida.
-Focus on postings that have specified salaries.
*/



SELECT
    job_id,
    job_title,
    name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg
FROM 
    job_postings_fact
LEFT JOIN company_dim
ON job_postings_fact.company_id = company_dim.company_id 
WHERE
    job_title_short = 'Data Analyst' AND 
    job_location = 'Florida' AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10;