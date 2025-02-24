create database financial_loan;
use financial_loan;

SET SQL_SAFE_UPDATES = 0;

describe loan_table;
select issue_date from loan_table limit 10;

UPDATE loan_table
SET issue_date = STR_TO_DATE(issue_date, '%d-%m-%Y');

#total loan applications
SELECT COUNT(id) AS Total_Applications FROM loan_table;

#MTD loan application
SELECT COUNT(id) AS Total_Applications FROM loan_table
 WHERE MONTH(issue_date) = 12;
 
#PMTD loan application
SELECT COUNT(id) AS Total_Applications FROM loan_table
WHERE MONTH(issue_date) = 11;

#Funded amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM loan_table;
 
#MTD Funded amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM loan_table
where month(issue_date)=12;
 
#PMTD Funded amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM loan_table
where month(issue_date)=11; 
 
#amount received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM loan_table;
 
#MTD amount received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM loan_table
where month(issue_date)=12;

#PMTD amount received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM loan_table
where month(issue_date)=11;

#Averege interest rate
SELECT AVG(int_rate)*100 AS Avg_Int_Rate FROM loan_table;

#MTD Averege interest rate
SELECT AVG(int_rate)*100 AS Avg_Int_Rate FROM loan_table
where month(issue_date)=12;

#PMTD Averege interest rate
SELECT AVG(int_rate)*100 AS Avg_Int_Rate FROM loan_table
where month(issue_date)=11;

#average DTI
SELECT AVG(dti)*100 AS Avg_DTI FROM loan_table;

#MTD average DTI
SELECT AVG(dti)*100 AS Avg_DTI FROM loan_table
where month(issue_date)=12;

#PMTD average DTI
SELECT AVG(dti)*100 AS Avg_DTI FROM loan_table
where month(issue_date)=11;

#good loan percentage
SELECT
(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) /
COUNT(id) AS Good_Loan_Percentage
FROM loan_table;

#good loan application
SELECT COUNT(id) AS Good_Loan_Applications FROM loan_table
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

#good loan funded amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount FROM loan_table
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

#good loan amount received
SELECT SUM(total_payment) AS Good_Loan_amount_received FROM loan_table
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

#bad loan percentage
SELECT
(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
COUNT(id)AS Bad_Loan_Percentage
FROM loan_table;

#bad loan application
SELECT COUNT(id) AS Bad_Loan_Applications FROM loan_table
WHERE loan_status = 'Charged Off';

#bad loan funded amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM loan_table
WHERE loan_status = 'Charged Off';

#bad loan amount received
SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM loan_table 
WHERE loan_status = 'Charged Off';

#complete loan status summary
SELECT loan_status, COUNT(id) AS LoanCount,
SUM(total_payment) AS Total_Amount_Received,
SUM(loan_amount) AS Total_Funded_Amount,
AVG(int_rate * 100) AS Interest_Rate,
AVG(dti * 100) AS DTI
FROM
loan_table GROUP BY
loan_status;
SELECT
loan_status,
SUM(total_payment) AS MTD_Total_Amount_Received,
SUM(loan_amount) AS MTD_Total_Funded_Amount
FROM loan_table where month(issue_date) = 12 group by loan_status;

#bank loan report (MONTH)
SELECT
MONTH(issue_date) AS Month_Number, 
MONTHNAME(issue_date) AS Month_name, 
COUNT(id) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount, 
SUM(total_payment) AS Total_Amount_Received
FROM loan_table
GROUP BY MONTH(issue_date), MONTHNAME(issue_date) ORDER BY MONTH(issue_date);

#bank loan report (STATE)
SELECT
address_state AS State,
COUNT(id) AS Total_Loan_Applications, 
SUM(loan_amount) AS Total_Funded_Amount, 
SUM(total_payment) AS Total_Amount_Received
FROM loan_table GROUP BY address_state
ORDER BY address_state;

#bank loan report (TERM)
SELECT
term AS Term,
COUNT(id) AS Total_Loan_Applications, 
SUM(loan_amount) AS Total_Funded_Amount, 
SUM(total_payment) AS Total_Amount_Received, 
ROUND(Avg(int_rate)*100, 2) AS Interest_Rate
FROM loan_table
GROUP BY term
ORDER BY term;

#bank loan report (EMPLOYEE LENGHT)
SELECT
emp_length AS Employment_Length,
COUNT(id) AS Total_Loan_Applications, 
SUM(loan_amount) AS Total_Funded_Amount, 
SUM(total_payment) AS Total_Amount_Received
FROM loan_table
GROUP BY emp_length
ORDER BY emp_length;

#bank loan report (PURPOSE)
SELECT
purpose AS PURPOSE,
COUNT(id) AS Total_Loan_Applications, 
SUM(loan_amount) AS Total_Funded_Amount, 
SUM(total_payment) AS Total_Amount_Received
FROM loan_table
GROUP BY purpose
ORDER BY purpose;

#bank loan report (HOME OWNERSHIP)
SELECT
home_ownership AS Home_Ownership, 
COUNT(id) AS Total_Loan_Applications, 
SUM(loan_amount) AS Total_Funded_Amount, 
SUM(total_payment) AS Total_Amount_Received
FROM loan_table GROUP BY home_ownership
ORDER BY home_ownership;

#MoM loan application growth rate
SELECT MONTH(issue_date) AS Month, 
COUNT(id) AS Total_Application, 
(COUNT(id) - LAG(COUNT(id)) OVER(ORDER BY MONTH(issue_date)))*100 / COUNT(id) AS MoM_Applications
FROM loan_table GROUP BY MONTH(issue_date);

#MoM laon amount disbursed growth rate
SELECT MONTH(issue_date) AS MONTH, 
Sum(loan_amount), (Sum(loan_amount) - LAG(Sum(loan_amount)) OVER(ORDER BY MONTH(issue_date)))*100 / 
Sum(loan_amount) AS MoM_Loan_Disbursed
FROM loan_table
GROUP BY MONTH(issue_date);

#interest rate for various subgrade and grade laon type
SELECT distinct grade,
ROUND(AVG(int_rate) OVER(partition by grade)*100, 2) AS 'grade_interest_rate',
sub_grade, ROUND(AVG(int_rate) OVER(PARTITION BY sub_grade)*100, 2) AS 'sub_grade_interest_rate' 
FROM loan_table;








 
 