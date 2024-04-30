-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT (6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM sales;


-- What is the most selling product line
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

-- What is the most selling product line
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

-- What is the total revenue by month
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue;


-- What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs;


-- What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;

-- What product line had the largest VAT?

SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales?

SELECT 
    avg (quantity) as avg_quantity
from sales;

select 
    product_line,
    case
      when avg(quantity) > 6 then "good"
	else "Bad"
    end as remark
from sales 
group by product_line;

-- Which branch sold more products than average product sold?

select 
    branch,
    sum(quantity) as qnty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?

select 
    gender,
    product_line,
    count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- What is the average rating of each product line?

select
    product_line,
    round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc;

-- --------------------------------------------------------------------
-- ---------------------------- Sales -------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday?

select 
    time_of_day,
    count(*) as no_of_sales
from sales
where day_name = "Sunday"
group by time_of_day
order by no_of_sales desc;

-- Which of the customer types brings the most revenue?

select
     customer_type,
     sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- Which city has the largest tax/VAT percent?

select 
    city,
    round(avg(tax_pct),2) as avg_tax_pct
from sales
group by city
order by avg_tax_pct desc;

-- Which customer type pays the most in VAT?

select
    customer_type,
    avg(tax_pct) as Most_vat
from sales 
group by customer_type
order by Most_vat desc;

-- --------------------------------------------------------------------
-- ---------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?

select 
    distinct(customer_type)
from sales;

-- How many unique payment methods does the data have?

select
    distinct(payment)
from sales;

-- What is the most common customer type?

select 
    customer_type,
    count(customer_type) as count
from sales
group by customer_type
order by count desc;

-- -- Which customer type buys the most?

select 
    customer_type,
    count(customer_type) as buys
from sales
group by customer_type
order by buys desc;

-- What is the gender of most of the customers?

select 
    gender,
    count(customer_type) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- What is the gender distribution per branch?

SELECT
	gender,
	COUNT(gender) as gender_cnt
FROM sales
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?

SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?

select
    time_of_day,
    avg(rating) as avg_rating
from sales
where branch = "B"
group by time_of_day
order by avg_rating desc;

-- Which day of the week has the best avg ratings?

select 
     day_name,
     avg(rating) as best_rating
from sales
group by day_name
order by best_rating desc;

-- -- Which day of the week has the best average ratings per branch?

select 
     day_name,
     avg(rating) as best_avg_rating
from sales
where branch = "A"
group by day_name
order by best_avg_rating desc;
















    


   










