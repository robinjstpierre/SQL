/*
Quesiton: What are the top paying data analyst jobs?
-Identify the top 10 higest paying Data Analyst roles available in the state of Florida.
-Focus on postings that have specified salaries.
-What skills are required for higher paying jobs?
-What are the top 5 in demand skills?
*/


SELECT *
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
LIMIT 50;