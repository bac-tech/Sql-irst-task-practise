use sample_schema;
----------Who is the senior most employee based on job title?  
SELECT  * FROM employee order by  title  limit 1;

------Which countries have the most Invoices? 
SELECT  billing_country, count(*) as total_count  FROM invoice
group by billing_country order by  total_count desc;


------What are top 3 values of total invoice?  
select total,count(*) as total_count
from invoice  group by total order by total_count desc   limit 3;

------Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals 
SELECT billing_city, SUM(total) AS total_revenue 
FROM invoice 
GROUP BY billing_city 
ORDER BY total_revenue DESC 
LIMIT 1;


---------Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money  
SELECT c.customer_id, c.first_name, c.last_name, SUM(i.total) AS total_spent 
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name 
ORDER BY total_spent DESC 
LIMIT 1;