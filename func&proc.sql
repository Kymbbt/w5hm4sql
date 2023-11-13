SELECT *
FROM payment;

--- Creating a stored procedure
-- simulatimg a late fee charge to a customer whio was mean

CREATE OR REPLACE PROCEDURE late_fee(
	customer INTEGER, -- customer_id parameter
	late_payment INTEGER, --- payment_id parameter
	late_fee_amount DECIMAL (4,2)  --- amount for latefee
)

LANGUAGE plpgsql --- setting the query language
AS $$
BEGIN 
       ---- add a late fee to customer payment amount 
	   UPDATE payment 
	   SET amount = amount + late_fee_amount 
	   WHERE customer_id = customer AND payment_id = late_payment ; 
	   
	   -- commit our update statement inside of our transaction 
	   
	   COMMIT;
END;	   
$$
--- calling a stored procedure
CALL late_fee (341,17508, 3.50);

-- customer_id --7.99
--11.49

SELECT *
FROM payment 
WHERE payment_id = 17503 AND customer_id = 341; 

DROP PROCEDURE late_fee; 
-- functions can return something but not always--
-- Stored Functions Example 
-- Insert data into the actor table 

CREATE OR REPLACE FUNCTION add_actor(
	_actor_id INTEGER, 
	_first_name VARCHAR, 
	_lats_update TIMESTAMP WITHOUT TIME ZONE)
	

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

--- sum of our rentals, returns a discount 
-- function to grab return total rentals

CREATE FUNCTION get_total_rentals()
RETURNS INTEGER 
LANGUAGE plpgsql
AS $$
BEGIN 
RETURN (SELECT SUM(amount)FROM payment);
END;
$$;

---a function to get a discount that a procedure will use to apply that discount 

CREATE FUNCTION get_discount(price NUMERIC, percentage INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$ 
BEGIN 
RETURN (price * percentage/100);
END;
$$

-- procedure thatt alters the data ina column using the get_discount function 
---CREATE PROCEDURE apply_discount(percentage INTEGER, _payment_id INTEGER)
--AS $$
--BEGIN
--UPDATE payment
--SET amount = get_discount(payment.amount, percentage)
--WHERE payment_id = _payment_id;
--END;
--$$ LANGUAGE plpgsql;

CREATE PROCEDURE apply_discount1(percentage INTEGER, _payment_id INTEGER)
AS $$
BEGIN
UPDATE payment
SET amount = get_discount(payment.amount, percentage)
WHERE payment_id = _payment_id;
END;
$$ LANGUAGE plpgsql;


SELECT * 
FROM payment; 

CALL apply_discount1(20, 17509);

SELECT *
FROM payment 
WHERE payment_id = 17517; 


DROP PROCEDURE apply_discount










