USE sakila;

-- List of Films and Their Actors

SELECT film.title, CONCAT(actor.first_name,' ', actor.last_name) AS full_name
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id;

-- Customers and Their Total Number of Rentals

SELECT CONCAT(customer.first_name,' ', customer.last_name) AS full_name,
	COUNT(rental.rental_id) AS rental_count
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id;

-- Films That Have Never Been Rented

SELECT film.title
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IS NULL;

-- Total Revenue Per Film

SELECT film.title, SUM(payment.amount) AS total_revenue
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY film.film_id
ORDER BY total_revenue DESC;

-- Most Popular Film Category

SELECT category.name, COUNT(rental.rental_id) AS rental_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY category.category_id
ORDER BY rental_count DESC
LIMIT 1;

-- Active Customers

SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS full_name
FROM customer
WHERE customer.active = 1
ORDER BY full_name;

-- Staff Members and Their Total Sales

SELECT CONCAT(staff.first_name, ' ', staff.last_name) AS full_name,
		SUM(payment.amount) AS total_sales
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id;

-- Customers With Overdue Rentals

SELECT customer.first_name, customer.last_name, rental.rental_date, rental.return_date
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
WHERE rental.return_date < CURRENT_DATE AND rental.return_date IS NOT NULL;

-- Average Rental Duration for Each Film Category

SELECT category.name, AVG(film.rental_duration) AS average_duration
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
GROUP BY category.category_id;

-- Films Rented in Last 20 Years

SELECT film.title, COUNT(*) AS rental_count
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_date BETWEEN DATE_SUB(NOW(), INTERVAL 20 YEAR) AND NOW()
GROUP BY film.title
ORDER BY rental_count DESC;

-- Stores with the Highest Number of Rentals

SELECT store.store_id, COUNT(rental.rental_id) AS rental_count
FROM store
JOIN staff ON store.store_id = staff.store_id
JOIN rental ON staff.staff_id = rental.staff_id
GROUP BY store.store_id
ORDER BY rental_count DESC;

-- Number of Films in Each Category Available in Each Store

SELECT category.name, store.store_id, COUNT(inventory.inventory_id) AS film_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN store ON inventory.store_id = store.store_id
GROUP BY category.category_id, store.store_id
ORDER BY film_count DESC;

