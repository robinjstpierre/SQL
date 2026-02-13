# Data Analyst Job Market Project
## Introduction
This project analyzes 2023 job postings to evaluate the Data Analyst job market in the state of Florida. The analysis focuses on identifying high-paying roles, determining which skills are most associated with higher salaries, understanding overall skill demand, and uncovering which skills command the highest average compensation.
The objective is to transform raw job-posting data into structured, actionable insights using SQL.
## Background
The job title “Data Analyst” spans multiple industries and salary ranges. To generate meaningful insights, the dataset was filtered to include:
Job Title: Data Analyst
Location: Florida
Year: 2023
Salary Requirement: Included only postings with specified salaries when conducting compensation-based analysis
The project was structured around four key research questions:
What are the top 10 highest-paying Data Analyst roles in Florida?
What skills are required for higher-paying jobs?
What are the top 5 most in-demand skills in Florida?
Which skills are associated with the highest average salaries?
## Tools Used
Visual Studio Code – SQL development and project organization
PostgreSQL – Database management and query execution
Common Table Expressions (CTEs) – Modular query structuring and improved readability
Joins (INNER JOIN, etc.) – Connecting job postings data to related skills tables for deeper analysis
## Analysis
The analysis was conducted in structured phases to ensure clarity and accuracy.
### 1) Top Paying Data Analyst Jobs (Florida, Salary-Specified)
- Filtered for Florida-based Data Analyst roles with non-null salary values
- Ordered results by average yearly salary in descending order
- Selected the top 10 highest-paying positions

This identified the premium tier of Data Analyst roles within the state.
```sql
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
```
| job_id  | job_title                                                   | company_name                       | job_location | job_schedule_type | salary_year_avg |
|---------|-------------------------------------------------------------|------------------------------------|--------------|-------------------|-----------------|
| 103610  | Lead Data Analyst, Technology & Digital, Full-Time,8A-4:30P | Baptist Health South Florida       | Florida      | Full-time         | 129503.5        |
| 1510307 | Launch Test Range Systems Data Analyst                      | United States Space Force          | Florida      | Full-time         | 126339.5        |
| 415535  | Data Analyst                                                | firstPRO, Inc                      | Florida      | Full-time         | 115000.0        |
| 769442  | Data Analyst, Business Operations                           | HirePlace                          | Florida      | Full-time         | 90000.0         |
| 349736  | Data Analyst                                                | Vertex Solutions Inc.              | Florida      | Full-time         | 82500.0         |
| 256884  | Lead Business Data Analyst                                  | Revolution Technologies            | Florida      | Full-time         | 79560.0         |
| 683103  | Data Analyst-Life Cycle Maintenance                         | ENGINEERING SERVICES NETWORK, Inc. | Florida      | Full-time         | 70250.0         |
| 1645436 | IT Data Process Analyst                                     | pcms staffing                      | Florida      | Full-time         | 57500.0         |
| 708814  | IT Data and Process Analyst                                 | pcms staffing                      | Florida      | Full-time         | 57500.0         |

### 2) Skills Required for Higher-Paying Jobs
- Isolated higher-paying job postings
- Joined job postings with skills tables
- Counted frequency of skills appearing in top-paying listings

This step revealed which technical skills are most commonly associated with elevated compensation levels.
```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        name AS company_name,
        job_location,
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
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY    
    salary_year_avg DESC;
```

### 3) Top 5 In-Demand Skills (Florida Data Analyst Market)
- Aggregated skill occurrences across all Florida Data Analyst postings
- Ranked skills by total demand count
- Identified the top five most frequently requested skills

This portion of the analysis reflects overall market demand rather than salary correlation.
```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Florida'
GROUP BY
    skills
ORDER BY demand_count DESC
LIMIT 5;
```

### 4) Top Paying Skills
- Calculated average salary grouped by skill
- Ranked skills by highest average salary
- Focused only on postings with specified salary data

This highlights skills that may not be the most common but are strongly linked to higher compensation.
```sql
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
```