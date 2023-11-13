SELECT *
FROM customer; 

-- we can alter table "ALTER" will change onfo about table in some way(name of the table, attrib, info in the table)

ALTER TABLE customer 
ADD phone_number VARCHAR(20);


-- updating data inside of data DML
UPDATE customer --- updating table name 
SET phone_number = '773-282-LUNA' -- setting data in column
WHERE customer_id = 1; -- a condition or the data to be set



-- updating data inside of data DML
UPDATE customer --- updating table name 
SET phone_number = '652-222-2582' -- setting data in column
WHERE customer_id = 5; 

SELECT * 
FROM order_

ALTER TABLE order_
ADD order_quantity INTEGER,
ADD staff_first VARCHAR(50),
ADD staff_last VARCHAR(50),
ADD price INTEGER;

SELECT *
FROM order_;

ALTER TABLE order_
ALTER price TYPE  NUMERIC(6,2);

UPDATE order_
SET order_quantity = 3, staff_first = 'Rod', staff_last = 'Kimble', price = 250.00
WHERE order_id = 1; 

SELECT *
FROM order_ ;

CREATE TABLE staff (
	staff_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50)
	
);

SELECT *
FROM staff;

ALTER TABLE staff
DROP COLUMN email;

DROP TABLE staff CASCADE;

SELECT * 
FROM customer; 

SELECT * 
FROM order_;

DROP TABLE customer CASCADE;
-----------------------------
SELECT *
FROM payment;

-- Creating a stored procedure
-- simulating a late fee charge to a customer who was mean

CREATE OR REPLACE PROCEDURE late_fee(
		customer INTEGER, -- customer_id parameter
		late_payment INTEGER, -- payment_id parameter
		late_fee_amount DECIMAL(4,2) -- amount for latefee

)
LANGUAGE plpgsql -- setting the query language for the procedure
AS $$
BEGIN
		-- Add a late fee to customer payment amount
		UPDATE payment
		SET amount = amount + late_fee_amount
		WHERE customer_id = customer AND payment_id = late_payment;
		
		--Commit our update statement inside of our transaction
		COMMIT;
END;
$$

-- Calling a stored procedure
CALL late_fee(341, 17503, 3.50);

-- 7.99
-- 11.49
SELECT *
FROM payment
WHERE payment_id = 17503 AND customer_id = 341;

DROP PROCEDURE late_fee;

-- Stored Functions Example
-- Insert data into the actor table
CREATE OR REPLACE FUNCTION add_actor(
		_actor_id INTEGER,
		_first_name VARCHAR,
		_last_name VARCHAR,
		_last_update TIMESTAMP WITHOUT TIME ZONE)
RETURNS void
LANGUAGE plpgsql
AS $MAIN$
BEGIN
		INSERT INTO actor
		VALUES(_actor_id, _first_name, _last_name, _last_update);
END;
$MAIN$

-- DO NOT 'CALL' A FUNCTION -- SELECT IT
SELECT add_actor(500, 'Orlando', 'Bloom', NOW()::TIMESTAMP);

SELECT *
FROM actor
WHERE actor_id = 500;

-- function to grab return total rentals
CREATE FUNCTION get_total_rentals()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN (SELECT SUM(amount) FROM payment);
	END;
$$;

SELECT get_total_rentals();

-- A function to get a discount that a procedure will use to apply that discount
CREATE OR REPLACE FUNCTION get_discount(price NUMERIC, percentage INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN (price * percentage/100);
	END;
$$

-- procedure that alters the data in a column using the get_discount function
CREATE PROCEDURE apply_discount(percentage INTEGER, _payment_id INTEGER)
AS $$
	BEGIN
		UPDATE payment
		SET amount = get_discount(payment.amount, percentage)
		WHERE payment_id = _payment_id;
	END;
$$ LANGUAGE plpgsql;

SELECT *
FROM payment;

CALL apply_discount(20, 17517);

SELECT *
FROM payment 
WHERE payment_id = 17517;









