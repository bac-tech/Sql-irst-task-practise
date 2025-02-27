
use sample_schema;
------------1
select sum( DISTINCT order_id) as total_Quantity  from order_details;
select sum(p.price * od.quantity)  as total_revenue from order_details od join pizzas p on  od.pizza_id=p.pizza_id ;
select  price   from  pizzas order by price DESC limit 1;
select p.size ,count(*)  as order_count  from  pizzas p  join  order_details od group by p.size  order by order_count  limit 1;
SELECT pt.name, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;

-------Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

------Determine the distribution of orders by hour of the day. 
SELECT HOUR(time)AS order_hour, COUNT(order_id) AS total_orders                                                                
FROM orders 
GROUP BY order_hour
ORDER BY order_hour;

------Join relevant tables to find the category-wise distribution of pizzas. 
SELECT pt.category, COUNT(DISTINCT p.pizza_id) AS unique_pizza_types
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY unique_pizza_types DESC;

--------Group the orders by date and calculate the average number of pizzas ordered per day. 
 select date, avg(quantity) as average_pizza_order from order_details od join orders o on 
o.order_id=od.order_id group by date order by average_pizza_order desc;

   

---------Determine the top 3 most ordered pizza types based on revenue. 

SELECT od.pizza_id, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY od.pizza_id
ORDER BY total_revenue DESC
LIMIT 3;





----Calculate the percentage contribution of each pizza type to total revenue. 
use sample_schema;
SELECT 
    p.pizza_type_id, 
    pt.name AS pizza_name, 
    SUM(od.quantity * p.price) AS total_revenue,
    ROUND((SUM(od.quantity * p.price) * 100.0) / 
         (SELECT SUM(od.quantity * p.price) 
          FROM order_details od 
          JOIN pizzas p ON od.pizza_id = p.pizza_id), 2) AS percentage_contribution
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY p.pizza_type_id, pt.name
ORDER BY total_revenue DESC;


-----------Analyze the cumulative revenue generated over time. 

SELECT 
    o.date, 
    (SELECT SUM(od.quantity * p.price) 
     FROM order_details od 
     JOIN pizzas p ON od.pizza_id = p.pizza_id
     JOIN orders o2 ON od.order_id = o2.order_id
     WHERE o2.date = o.date) AS daily_revenue,
    (SELECT SUM(od.quantity * p.price) 
     FROM order_details od 
     JOIN pizzas p ON od.pizza_id = p.pizza_id
     JOIN orders o2 ON od.order_id = o2.order_id
     WHERE o2.date <= o.date) AS cumulative_revenue
FROM orders o
GROUP BY o.date
ORDER BY o.date;


------Calculate the percentage contribution of each pizza type to total revenue. 
SELECT 
    pt.name AS pizza_name, 
    SUM(od.quantity * p.price) AS total_revenue,
    ROUND((SUM(od.quantity * p.price) * 100.0) / 
          (SELECT SUM(od.quantity * p.price) FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id), 2) 
          AS percentage_contribution
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC;


-------Analyze the cumulative revenue generated over time. 
SELECT 
    o.date, 
    SUM(od.quantity * p.price) AS daily_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY o.date;



------Determine the top 3 most ordered pizza types based on revenue for each pizza category. 
SELECT pt.category, pt.name AS pizza_name, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category, pt.name
ORDER BY pt.category, total_revenue DESC;
