# 🏦 Loan Default Risk Analysis

## 📌 Project Overview
End-to-end data analytics project to identify loan default risk patterns
using SQL for analysis and Power BI for interactive visualization.

## 🎯 Business Problem
A lending company wants to understand:
- Which borrowers are most likely to default?
- What factors (DTI, credit score, employment) drive defaults?
- How to proactively flag high-risk loans?

## 📊 Key Business Insights
| Insight | Finding |
|---------|---------|
| Overall Default Rate | 24.3% (146 of 601 loans) |
| Avg DTI - Defaulted | 57.9% |
| Avg DTI - Healthy | 47.1% |
| Top Default Purpose | Home Improvement, Wedding, Auto |
| Late Loans (at risk) | 103 loans |
| Low Credit Score (<600) | 19.4% of borrowers |

## 🛠️ Tools Used
- **MySQL Workbench** — Data import, cleaning and SQL analysis
- **Power BI Desktop** — Dashboard and visualization
- **Dataset** — 601 loan records + 500 borrower profiles (7 CSV files)

## 📁 Project Structure
- data/        → All 7 raw CSV files
- sql/         → All SQL queries (.sql file)
- powerbi/     → Power BI dashboard (.pbix + PDF preview)
- README.md    → Project documentation

## 🔍 SQL Analysis Questions Answered
1. What is the overall default rate?
2. Default rate by loan purpose
3. Impact of DTI ratio on defaults
4. Credit score bands vs default behavior
5. Employment status vs defaults
6. State-wise default distribution
7. Monthly trend of loan applications

## 🛠️ Author
Vanga Venkateshwar Reddy | Data Analyst
