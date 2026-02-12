/*
Quesiton: What are the top paying data analyst jobs?
-Identify the top 10 higest paying Data Analyst roles available in the state of Florida. Focus on postings that have specified salaries.
-What skills are required for higher paying jobs?
-What are the top 5 in demand skills in the state of Florida?
-Top Paying skills

*/

SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS Average_Salary
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_location = 'Florida'
GROUP BY
    skills
ORDER BY
    Average_Salary DESC
LIMIT 25;
