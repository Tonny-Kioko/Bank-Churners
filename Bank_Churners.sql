/* The aim of the analysis is to determine the attrition rate among the bank's customers. Looking into 
 the main reason customers leave the bank, the age group likely to leave and the main indicators that
 a customer is about to leave. The analysis will help boost the bank's customer retaining level */

--The customer details from the imported tables

SELECT * FROM [dbo].[Bank_churners]

SELECT
		(SELECT COUNT (Attrition_Flag) 
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer' ) AS Leaving_customer , COUNT (Attrition_Flag) AS Total_Customers
 FROM Bank_churners

--EXPLORING MAJOR FACTORS THAT SET CURRENT AND EXITING CUSTOMERS APART

-- The proportion of attriting customers to the total customer count for the bank
SELECT
		(SELECT COUNT (Attrition_Flag) 
		FROM Bank_churners
		WHERE Attrition_Flag = 'Attrited Customer' ) AS Leaving_customer , COUNT (Attrition_Flag) AS Total_Customers
 FROM Bank_churners

-- The age groups of the customers in the bank
SELECT MIN(Customer_age) Minimum_Age, 
MAX (Customer_age) Maximum_age FROM Bank_churners;

SELECT  CASE 
		WHEN Customer_age BETWEEN 0 AND 20 THEN 'Below 20'
		WHEN customer_age BETWEEN 21 AND 30 THEN '21 to 30'
		WHEN Customer_Age BETWEEN 31 AND 40 THEN '31 to 40'
		WHEN Customer_Age BETWEEN 41  AND 50 THEN '41 to 50'
		WHEN Customer_Age BETWEEN 51 AND 60 THEN ' 51 to 60'
		WHEN Customer_Age BETWEEN 61 AND 70 THEN '61 to 70'
	    WHEN Customer_Age BETWEEN 71 AND 80 THEN 'Above 71'  
	END AS Age_Groups, COUNT (*) AS Clients_Attrited
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
GROUP BY Customer_Age
ORDER BY Customer_Age

WITH groups AS (
	SELECT  CASE 
		WHEN Customer_age BETWEEN 0 AND 20 THEN 'Below 20'
		WHEN customer_age BETWEEN 21 AND 30 THEN '21 to 30'
		WHEN Customer_Age BETWEEN 31 AND 40 THEN '31 to 40'
		WHEN Customer_Age BETWEEN 41  AND 50 THEN '41 to 50'
		WHEN Customer_Age BETWEEN 51 AND 60 THEN ' 51 to 60'
		WHEN Customer_Age BETWEEN 61 AND 70 THEN '61 to 70'
	    WHEN Customer_Age BETWEEN 71 AND 80 THEN 'Above 71'  
	END AS Age_Groups, COUNT (*) AS Clients_Attrited
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
GROUP BY Customer_Age) 
SELECT groups.Age_Groups, COUNT (Clients_Attrited) AS Customers_Left
FROM groups 
GROUP BY Age_Groups
--ORDER BY Age_Groups

-- The proportion of Exiting customers to those who remain
SELECT COUNT (Attrition_Flag) AS Left_customers  FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'


-- What gender makes the exiting the bank
SELECT COUNT (Gender) 
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
/* 1627 customers from both genders left. */ 
SELECT COUNT (Gender) 
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
AND Gender = 'M'
/* 697 Males */
SELECT COUNT (Gender) 
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
AND Gender = 'F'
/* 930 Females */

SELECT CASE 
		WHEN Gender = 'M' THEN 'Male'
		ELSE 'Female'
		END AS Genders, COUNT (*) AS Number_of_Attritions
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
GROUP BY Gender
/* More female customers are leaving the bank */

-- The level of education among those exiting the bank
SELECT DISTINCT(Education_Level), COUNT (Education_Level) AS Customers_In_Each_Level
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
GROUP BY Education_Level
ORDER BY Customers_In_Each_Level
/*Clients with a Graduate level education are leaving more. */ 
SELECT DISTINCT(CASE
		WHEN education_level = 'Uneducated' THEN 'Level 0'
		WHEN education_level = 'High School' THEN 'Level 1'
		WHEN education_level = 'College' THEN 'Level 2'
		WHEN education_level = 'Graduate' THEN 'Level 3'
		WHEN education_level = 'Post-Graduate' THEN 'Level 4'
		WHEN education_level = 'Doctorate' THEN 'Level 5'
		ELSE 'Unkown'
END )AS Education_categories, COUNT (*) AS Numbers_per_Group 
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
GROUP BY Education_Level
ORDER BY Numbers_per_Group

-- Card category determines the customer's "Status". Which category consists those exiting the bank

SELECT DISTINCT (Card_category), COUNT (card_category) AS Card_category_Numbers
FROM Bank_churners 
WHERE Attrition_Flag = 'Attrited Customer'
GROUP BY card_category
/* Blue card owners have the highest attrition rates. They are also a majority of the card holders in the bank (1519)
when a customer quits, they are likely to be from this card holding category. More incentives should be given to
the clients in this group*/

-- After how long (Months_on_book) do the customers close their accounts. 

SELECT AVG (Months_on_book) AS Months_before_Leavinng FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
/* The average months on book for the bank customers is 35.93 months. The average months for attriting customers is 36 months. 
It is close to the majority of the bank clients. The bank will experience more attritions and should register more clients
or introduce new products to entice the existing clients*/

-- Income category of the clients closing their bank accounts. 
SELECT COUNT (Income_category) Members_per_Category, Income_Category
FROM Bank_churners
--WHERE Attrition_Flag = 'Attrited Customer'
GROUP BY Income_Category
ORDER BY Income_Category

SELECT COUNT (Income_category) Members_per_Category, Income_Category
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
GROUP BY Income_Category
ORDER BY Income_Category
/*People earning Less than $40K form the majority of those quitting (612). They also account for the majoprity of customers to the
bank. Creating incentives for this group will reduce their attrition and significantly reduce the attrition rate to the  bank.  */

-- Months of inactivity for those exiting the bank
SELECT AVG (Months_Inactive_12_mon)
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
--GROUP BY Months_Inactive_12_mon 
/* The maximum inactivity duration for customers who are about to attrite the bank have a 2.7 month exit duration. 
Once a client nears 2.7 months of inactivity, they shoul;d target their marketing to the group. */

-- Average credit limit of the attriting customers
SELECT  COUNT (DISTINCT Clientnum) Clients_in_credit_Lim_Cat, ROUND (AVG (credit_Limit), 2) Averare_Credit_Limit 
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
/* 8136.04 is the average credit limit for the clients attriting from the bank. Increasing their credit limit for the clients falling near this
category and possessing a good income category could reduce the attrition rates.*/ 

-- Do customers with high dependants close their account?
SELECT COUNT (DISTINCT Clientnum) Client_numbers, CEILING (AVG (dependent_Count)) Average_dependants
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
/* Customers with 3 dependants are the majority of attritions. Finding external reasons for this could help reduce 
attrition rates */

-- What is the Gender of the clients atriting from the bank?
SELECT
COUNT (Gender)AS Male_Female_Attritions FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer'
AND Gender = 'M'
GROUP BY Gender

UNION 

SELECT
COUNT (Gender) AS Female_attritions FROM Bank_churners
WHERE Gender = 'F'
AND  Attrition_Flag = 'Attrited Customer'
GROUP BY Gender
/* More females are leaving the bank compared to male clients as they make a majority of the attriting customers (930) */

-- Do transaction numbers indicate the posibility of a customer attrition?

SELECT CEILING (AVG (total_trans_ct))  Avg_trans_before_exiting, COUNT (Clientnum) Attriting_customers
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer' 
/* The customers who have left the bank have an average 45 transactions. Looking out for clients who have made over 45 transactions
and introducing means to make them more comfortable or roll out promotions after the 45th transactions can help 
prevent them from attriting */

--The Average Transactions among the clients who left the bank

SELECT ROUND (AVG (Total_Trans_Amt), 2)  Avg_trans_before_exiting, COUNT (Clientnum) Attriting_customers
FROM Bank_churners
WHERE Attrition_Flag = 'Attrited Customer' 
/* the average trancaction amount for attriting customers is 3095.03. It is quite high, and their attrition cannot be ignored by
the bank as it is substantial business */


SELECT * FROM Bank_churners

