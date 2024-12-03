CREATE DATABASE PIZZAHUT;
USE PIZZAHUT;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL
);

CREATE TABLE orders_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id VARCHAR(50),
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

-- Retrieving the total number of orders placed.
SELECT 
    COUNT(order_id) AS total_order
FROM
    orders;

-- Calculating the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(orders_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    orders_details
        JOIN
    pizzas ON pizzas.pizza_id = orders_details.pizza_id;

-- Identifying the highest-priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Identifying the most common pizza size ordered.
SELECT 
    pizzas.size,
    COUNT(orders_details.order_details_id) AS orders_count
FROM
    pizzas
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY orders_count DESC
LIMIT 1;

-- Listing the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name, SUM(orders_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

-- Joining the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category, SUM(orders_details.quantity)
FROM
    orders_details
        JOIN
    pizzas ON orders_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category;

-- Determining the distribution of orders by hour of the day.
SELECT hour(order_time) as hour, COUNT(order_id) as order_count FROM orders
GROUP BY hour(order_time);

-- Joining relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(pizza_type_id)
FROM
    pizza_types
GROUP BY category;

-- Grouping the orders by date and calculate the average number of pizzas ordered per day.
SELECT COUNT(order_id), order_date FROM orders
GROUP BY order_date;

-- Determining the top 3 most ordered pizza types based on revenue.
SELECT 
    SUM(orders_details.quantity * pizzas.price) AS revenue,
    pizzas.pizza_type_id
FROM
    orders_details
        JOIN
    pizzas ON orders_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.pizza_type_id
ORDER BY revenue DESC
LIMIT 3;

-- Calculating the percentage contribution of each pizza type to total revenue
SELECT 
    pizza_types.category,
    ROUND(SUM(orders_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(orders_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    orders_details
                        JOIN
                    pizzas ON pizzas.pizza_id = orders_details.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;






