-- Music Store Data Analysis using MySQl

-- Created a database named music_store
create database if not exists music_store;

-- Imported the all the tables.

use music_store;


-- list of tables in the dataset
show tables;

-- Basic Information about the tables
select * from employee;
select * from artist;
select * from invoice;
select * from track;
select * from playlist;
select * from media_type;
select * from genre;


#Q1. Which country has the most invoices ?
select billing_country, count(*) as Total_count from invoice
group by billing_country
order by Total_count desc
limit 1;



#Q2.List out the top 10 customers along with their respective cities?
select c.first_name, c.last_name, c.city, sum(i.total) as Total_amount
from customer c
join
invoice i on c.customer_id = i.customer_id
group by c.customer_id
order by Total_amount desc
limit 10;


#Q3. Find the top 5 cities based on the sale data?
select billing_city, sum(total) as total_amount
from invoice
group by billing_city
order by total_amount desc
limit 5;



#Q4. Find the name, email, genre of all the Rock music listeners and arrange the result in alphabetical order.
select c.first_name, c.last_name, c.email, g.name
from customer c
join
invoice i on c.customer_id = i.customer_id
join
invoice_line il on i.invoice_id = il.invoice_id
join
track t on il.track_id = t.track_id
join 
genre g on t.genre_id = g.genre_id
where g.name = "Rock"
group by c.first_name, c.last_name
order by c.first_name;



#Q5. Find the total quantity sold according to genre and 
# which genre has the most quantity sold?
select g.name, count(il.quantity) as Quantity
from invoice_line il
join
track t on il.track_id = t.track_id
join 
genre g on t.genre_id = g.genre_id
group by g.name
order by Quantity desc;



#Q6. List all the track names having song length greater than average song length. 
# Order the result by descending song length
select name, milliseconds
from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;



#Q7. List out the top 10 track names based on the quantity sold ?
select t.name, count(il.quantity) as Total_quantity
from track t
join 
invoice_line il on t.track_id = il.track_id
group by t.name
order by Total_Quantity desc
limit 10;


#Q8. Find the list of  most popular playlist?
select p.name, count(il.quantity) as total_quantity
from playlist p
join 
playlist_track pt on p.playlist_id = pt.playlist_id
join
invoice_line il on pt.track_id = il.track_id
group by p.name
order by total_quantity desc;



#Q9 Which country has the max and min orders based on the total amount. 
# List the name fo top 3 customers from the country having maximum orders. 
-- Maximum Orders
select billing_country, sum(total) as total_amount
from invoice
group by billing_country
order by total_amount desc
limit 1;

-- Minimum Orders
select billing_country, sum(total) as total_amount
from invoice
group by billing_country
order by total_amount asc
limit 1;

-- Top 3 Cutomers from country having maximum orders
select c.first_name, c.last_name, i.billing_country,  sum(i.total) as total_amount
from customer c
join
invoice i on c.customer_id = i.customer_id
where i.billing_country = (select billing_country
from invoice
group by billing_country
order by sum(total) desc
limit 1
)
group by c.first_name, c.last_name
order by total_amount desc
limit 3;

-- Another approach
select c.first_name, c.last_name, i.billing_country, sum(i.total) as total_amount
from customer c
join
invoice i on c.customer_id = i.customer_id
where i.billing_country = "USA"
group by first_name, last_name
order by total_amount desc
limit 3;



