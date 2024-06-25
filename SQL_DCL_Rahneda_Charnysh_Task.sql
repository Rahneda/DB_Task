-- TASK 1
CREATE USER rentaluser WITH PASSWORD 'rentalpassword';
GRANT CONNECT ON DATABASE dvdrental TO rentaluser;


-- TASK 2
GRANT SELECT ON TABLE customer TO rentaluser;
SELECT * FROM customer;


-- TASK 3
CREATE ROLE rental;
GRANT rental TO rentaluser;


--TASK 4
GRANT INSERT, UPDATE ON TABLE rental TO rental;
SET ROLE rental;
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id) 
	VALUES (current_timestamp, 1, 1, null, 1);
UPDATE rental SET rental_date = current_timestamp 
	WHERE rental_id = 1;
RESET ROLE;


-- TASK 5
REVOKE INSERT ON TABLE rental FROM rental;
SET ROLE rental;
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
	VALUES (current_timestamp, 2, 2, null, 2);


