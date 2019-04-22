use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select CONCAT( first_name, " ", last_name )  AS "Actor Name" from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor where first_name like 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name from actor where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
select first_name, last_name from actor where last_name like '%LI%' order by last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a Add column
ALTER TABLE actor ADD COLUMN description Blob;

-- 3b Delete the description column.
ALTER TABLE actor drop COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) as NumberOfActors from actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
select last_name, count(*) as NumberOfActors from actor
group by last_name having NumberOfActors > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
update actor set first_name = 'HARPO', last_name = 'WILLIAMS' 
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor set first_name = 'GROUCHO', last_name = 'WILLIAMS' 
where first_name = 'HARPO' and last_name = 'WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
select s.first_name, s.last_name, a.address from staff s, address a 
where s.address_id = a.address_id;

SELECT s.first_name, s.last_name, a.address 
FROM staff s INNER JOIN address a ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.first_name, s.last_name, sum(p.amount)
FROM staff s INNER JOIN payment p ON s.staff_id = p.staff_id
where MONTH(p.payment_date) = '8' AND YEAR(p.payment_date) = '2005'
group by first_name, last_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title, count(f.title) as 'Number of Actors'
FROM film f 
INNER JOIN film_actor fa ON f.film_id = fa.film_id
group by f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title, count(f.title)  as 'Num of copies'
FROM film f INNER JOIN inventory i ON f.film_id = i.film_id
where f.title = 'Hunchback Impossible'
group by f.title;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, sum(p.amount) as 'Total Paid'
FROM customer c INNER JOIN payment p ON c.customer_id = p.customer_id
group by first_name, last_name
order by last_name;

-- 7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select f.title from film f
where f.title in (select title from film where title like 'K%' or title like 'Q%');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select a.first_name, a.last_name from film_actor fa, actor a where fa.actor_id = a.actor_id 
and fa.film_id in (select film_id from film where title = 'Alone Trip');

-- 7c names and email addresses of all Canadian customers
select cu.first_name, cu.last_name, cu.email, ci.city 
from customer cu, country co, city ci, address ad
where cu.address_id = ad.address_id
and ad.city_id = ci.city_id
and ci.country_id = co.country_id
and co.country = 'Canada';

-- Identify all movies categorized as family films.
select title, description from film where rating in ('PG', 'G')

-- 7e. Display the most frequently rented movies in descending order.
select r.inventory_id, f.title, count(r.inventory_id) as 'Most Frequent' 
from rental r, inventory i, film f
where i.inventory_id = r.inventory_id
and i.film_id = f.film_id
group by f.title
order by count(r.inventory_id) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
select st.store_id, sum(py.amount) as 'Total Business $' from store st, staff sf, payment py
where py.staff_id = sf.staff_id
and st.store_id = sf.store_id
group by st.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
select st.store_id, cy.city, co.country from store st, city cy, country co, address ad
where st.address_id = ad.address_id
and ad.city_id = cy.city_id
and cy.country_id = co.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select ca.name, sum(p.amount) as 'Gross Revenue $' from category ca, film_category fc, inventory i, payment p, rental r
where p.rental_id = r.rental_id
and r.inventory_id = i.inventory_id
and i.film_id = fc.film_id
and fc.category_id = ca.category_id
group by (ca.name)
order by sum(p.amount) desc limit 5

-- 8a Use the solution from the problem above to create a view. 
create view top_five_genres as 
select ca.name, sum(p.amount) as 'Gross Revenue $' from category ca, film_category fc, inventory i, payment p, rental r
where p.rental_id = r.rental_id
and r.inventory_id = i.inventory_id
and i.film_id = fc.film_id
and fc.category_id = ca.category_id
group by (ca.name)
order by sum(p.amount) desc limit 5;

-- 8b. How would you display the view that you created in 8a?
select * from top_five_genres;

-- 8c Delete view top_five_genres
drop view top_five_genres;





