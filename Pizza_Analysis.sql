create database Pizza

-- pizza data imported from excel
-- calling the table 
select * from pizza_sales


-- total revenue
select 
	round(sum(total_price),2) as total_revenue
from pizza_sales


-- 2. Average Order Value
select
	round((SUM(total_price) / COUNT(DISTINCT order_id)),2) AS Avg_order_Value 
from pizza_sales

-- Total pizza's sold
select 
	sum(quantity) as total_pizza_sold
from pizza_sales


-- Total Orders
select 
	count(distinct order_id) as total_orders
from pizza_sales

-- 5. Average Pizzas Per Order
select 
	cast(cast(sum(quantity) as decimal(10,2)) / 
	cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2))
as avg_pizzas_per_order
from pizza_sales


-- Daily trends for total orders
select 
	datename(dw, order_date) as order_day,
	count(distinct order_id) as total_orders	
from pizza_sales
group by datename(dw, order_date)


-- Hourly trends of orders
select 
	datepart(hour, order_time) as order_hours,
	count(distinct order_id) as total_orders	
from pizza_sales
group by datepart(hour, order_time) 
order by count(distinct order_id)


-- percentage of Sales by Pizza Category
with revenue as (
    select 
        pizza_category,
        sum(total_price) as total_revenue
    from  pizza_sales
    group by pizza_category
),
total as (
    select 
        sum(total_revenue) as grand_total
    from revenue
)
select 
    r.pizza_category,
    r.total_revenue,
    cast(r.total_revenue * 100.0 / t.grand_total as decimal(10, 2)) as pct
from revenue r, total t;


-- percentage of Sales by Pizza Size
with revenue as (
	select 
		pizza_size,
		round(sum(total_price),2) as total_revenue
	from pizza_sales
	group by pizza_size
),
total as (
	select
		sum(total_revenue) as grand_total
	from revenue
)
select
	r.pizza_size,
	r.total_revenue,
	cast(r.total_revenue * 100 / t.grand_total as decimal(10, 2)) as PCT
from revenue r, total t
order by PCT desc


-- Total Pizzas Sold by Pizza Category 
select
	pizza_category,
	sum(quantity) as total_pizzas
from pizza_sales
group by pizza_category
order by sum(quantity) desc


-- Top 5 Best Sellers by Total Pizzas Sold
with ranking_pizzas as (
	select 
		pizza_name,
		sum(quantity) as total_pizzas_sold,
		rank() over(order by sum(quantity) desc) as pizza_ranking
	from pizza_sales
	group by pizza_name
)
select * 
from ranking_pizzas
where pizza_ranking between 1 and 5;


-- Bottem 5 Best Sellers by Total Pizzas Sold
with ranking_pizzas as (
	select 
		pizza_name,
		sum(quantity) as total_pizzas_sold,
		rank() over(order by sum(quantity) asc) as pizza_ranking
	from pizza_sales
	group by pizza_name
)
select * 
from ranking_pizzas
where pizza_ranking between 1 and 5;


--- month wise total orders made
select 
	datename(dw, order_date) as order_day, 
	count(distinct order_id) as total_orders 
from pizza_sales
where month(order_date) = 1
group by datename(dw, order_date)


-- Quarter wise total orders made
select 
	datename(dw, order_date) as order_day, 
	count(distinct order_id) as total_orders 
from pizza_sales
where datepart(quarter, order_date) = 1
group by datename(dw, order_date)
