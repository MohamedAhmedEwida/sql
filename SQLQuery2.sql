--o	Retrieve all columns for the first 20 customers

select top 20 *
from project.dbo.Bank_dataset
--Count the total number of records in the dataset.
select count(*)
from project.dbo.Bank_dataset
--o	List all unique job categories
select distinct(job)
from project.dbo.Bank_dataset
--o	Count how many customers belong to each job category.
select distinct(job),count(marital)
from project.dbo.Bank_dataset
group by  (job)
--o	Show the minimum, maximum, and average age
select min(age)as min_age,max(age)as max_age,AVG(age)as avg_age
from project.dbo.Bank_dataset
--o	Find the average age for each educational level
select education,avg(age)
from project.dbo.Bank_dataset
group by education
--o	 Count how many customers are married, single, or divorced.
select distinct(marital),count(marital)
from project.dbo.Bank_dataset
group by marital
--o	 Retrieve the top 10 customers with the highest account balance.
select top 10 balance
from project.dbo.Bank_dataset
order by balance desc
--Calculate the average balance grouped by job.
select distinct(job),AVG(balance)
from project.dbo.Bank_dataset
group by job
--o	 Count how many clients subscribed to the term 
--deposit (y = 'yes') vs. not subscribed.
select deposit,count(deposit)
from project.dbo.Bank_dataset
group by deposit
--Which job category has the highest number of subscriptions
select distinct(job),count(deposit)
from project.dbo.Bank_dataset
where deposit='yes'
group by job
--o	 Which marital status produced the highest subscription rate?
select distinct(marital),count(deposit) as subscription
from project.dbo.Bank_dataset
where deposit='yes'
group by marital
order by subscription desc
--o	 Count how many customers were previously contacted (previous > 0).
select count(previous) as count_customer
from project.dbo.Bank_dataset
where previous>0
--o	Analyse subscription success for customers who were 
--contacted before vs. first-timers.
select distinct (contact),COUNT(contact)
from project.dbo.Bank_dataset
group by contact
--o	Evaluate subscription success
--grouped by the previous campaign outcome (poutcome).
select distinct poutcome,COUNT(poutcome)
from project.dbo.Bank_dataset
group by poutcome



