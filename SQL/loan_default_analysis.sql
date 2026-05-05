-- CREATE TABLE borrower_profiles (
 --   borrower_id VARCHAR(20) PRIMARY KEY,
 --   age INT,
 --   state VARCHAR(5),
 --   education_level VARCHAR(50),
 --   employment_status VARCHAR(50),
 --   years_employed INT,
 --  annual_income DECIMAL(12,2),
 --   credit_score INT,
 --   home_ownership VARCHAR(20),
 --   dependents INT,
 --   existing_monthly_debt DECIMAL(10,2)
-- );

--  CREATE TABLE loan_applications (
--  loan_id VARCHAR(20) PRIMARY KEY,
--  borrower_id VARCHAR(20),
--    application_date DATE,
--    loan_purpose VARCHAR(50),
 --   loan_amount DECIMAL(12,2),
 --   term_months INT,
--  interest_rate DECIMAL(5,2),
 --   monthly_payment DECIMAL(10,2),
 --   dti_ratio DECIMAL(5,2),
  --  loan_status VARCHAR(30),
  --  days_delinquent INT,
  --  defaulted TINYINT(1),
  --  FOREIGN KEY (borrower_id) REFERENCES borrower_profiles(borrower_id)
-- );

-- SELECT * FROM loan_default_risk_analysis.borrower_profiles LIMIT 10;
-- SELECT * FROM loan_default_risk_analysis.loan_applications LIMIT 10;

use loan_default_risk_analysis;

-- QA. WHAT IS THE OVERALL DEFAULT RATE?--
select
    count(*) as total_loans,
    sum(defaulted) as total_defaults,
    round(sum(defaulted)/count(*)*100,2) as default_percent
from loan_applications;

-- Q1B. HOW DOES IT BREAK DOWN BY CREDIT SCORE RANGE(eg 520-599, 600-649, 650-699, 700-749, 750+)
 select 
    case
       when bp.credit_score between 520 and 599 then '520-599'
	   when bp.credit_score between 600 and 649 then '600-649'
	   when bp.credit_score between 650 and 699 then '650-699'
	   when bp.credit_score between 700 and 749 then '700-749'
	   when bp.credit_score >+ 750 then '750+'
	   else 'Below 520'
	   end as credit_score_bucket,
	count(*) as total_loans,
    sum(defaulted) as total_defaults,
    round(sum(defaulted)/count(*)*100,2) as default_percent
    from loan_applications la
    join borrower_profiles bp on la.borrower_id = bp.borrower_id
    group by credit_score_bucket
    order by credit_score_bucket;
    
    -- Q2A. IS THERE A RELATIONSHIP BETWEEN A BORROWER'S DEBT-TO-INCOME (DTI) RATIO AND THE LIKELYHOOD OF DEFAULTING? (YES)
    select
         case
             when dti_ratio < 20 then '0-19'
             when dti_ratio between 20 and 29 then '20-29'
             when dti_ratio between 30 and 39 then '30-39'
             when dti_ratio between 40 and 49 then '40-49'
             else '50+'
             end as dti_ratio_bucket,
    count(*) as total_loans,
    sum(defaulted) as total_defaults,
    round(sum(defaulted)/count(*)*100,2) as default_percent
from loan_applications
group by dti_ratio_bucket
order by dti_ratio_bucket;

-- Q3A. WHICH LOAN PURPOSES HAVE THE HIGHEST DEFAULT RATES? --
select
loan_purpose,
count(*) as total_loans, 
sum(defaulted) as total_defaults,
round (sum(defaulted)/count(*)*100,2) as default_percent
from loan_applications 
group by loan_purpose 
order by default_percent desc;


-- Q3B. DOES THE AVERAGE LOAN AMOUNT DIFFER SIGNIFICANTLY BETWEEN DEFAULTED AND NON-DEFAULTED LOANS?
select
     defaulted,
     count(*) as total_loans, 
     round(avg(loan_amount), 0) as avg_loan_amount,
     min(loan_amount) as min_loan, 
     max(loan_amount) as max_loan
from loan_applications 
group by defaulted;
    
    -- Q4A. HOW DO EMPLOYMENT STATUS AFFECT DEFAULT RISK? --
select
     bp.employment_status, 
     count(*) as total_loans, 
     sum(la.defaulted) as total_defaults,
	round (sum(la.defaulted)/count(*)*100,2) as default_percent
from loan_applications la
join borrower_profiles bp on la.borrower_id = bp.borrower_id
group by employment_status 
order by default_percent desc;
    
    -- Q4B. HOW DO YEARS EMPLOYED AFFECT DEFAULT RISK? --
select
     case
	     when bp.years_employed < 2 then '<2 years'
         when bp.years_employed between 2 and 5 then '2-5 years' 
         when bp.years_employed between 6 and 10 then '6-10 years'
         else '10+ years'
         end as employment_tenure,
       count(*) as total_loans, 
       sum(la.defaulted) as total_defaults,
	   round(sum(la.defaulted)/count(*)*100,2) as default_percent
from loan_applications la
join borrower_profiles bp on la.borrower_id = bp.borrower_id
group by employment_tenure 
order by
		case employment_tenure
              when '<2 years' then 1 
              when '2-5 years' then 2
              when '6-10 years' then 3
              when '10+ years' then 4
              else 5
              end asc;
              
	-- Q4C. ARE BORROWERS WITH LESS THAN 2 YEARS OF EMPLOYMENT MORE LIKELY TO DEFAULT? --
select
     case
         when bp.years_employed < 2 then '2 years' else '2+ years'
         end as employment_group, 
	 count(*) as total_loans,
     sum(la.defaulted) as total_defaults,
     round(sum(la.defaulted)/count(*)*100,2) as default_percent
from loan_applications la
join borrower_profiles bp on la.borrower_id = bp.borrower_id
group by employment_group
order by employment_group;