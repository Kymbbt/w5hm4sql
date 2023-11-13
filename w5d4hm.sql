
SELECT *
FROM customer 


ALTER TABLE customer 
ADD platinum_member boolean; 

SELECT * 
FROM payment; 


-- CREATE PROCEDURE platinum_member1(BOOLEAN)

-- LANGUAGE plpgsql
-- AS $$ 
-- BEGIN 
-- UPDATE payment
-- SET customer.customer_id = payment.customer_id
-- WHERE (SELECT COUNT (payment.amount >= 200 is TRUE and payment.amount <= 200 is FALSE ));

-- END; 
-- $$; 

--CALL platinum_member (TRUE or FALSE);

DROP PROCEDURE platinum_member1


CREATE OR REPLACE PROCEDURE premium_member()
LANGUAGE plpgsql
AS $$ 
BEGIN
UPDATE customer
SET platinum_member = TRUE
WHERE customer_id IN (
 	SELECT customer_id
	FROM payment 
	GROUP BY customer_id
	HAVING SUM (payment.amount) > 200
	

);
COMMIT;
END;
$$ ;

CALL premium_member ();

SELECT *
FROM payment
WHERE customer_id = 526
HAVING SUM (payment.amount) 


--- We did this with Berik and Sarah helped a little))


SELECT *
FROM payment
SELECT *
FROM rental
ALTER TABLE payment
ADD COLUMN late_fee VARCHAR(50);
CREATE OR REPLACE PROCEDURE late_fee()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE payment
	SET late_fee = 'yes'
	WHERE customer_id IN (
	SELECT customer_id
	FROM rental
	WHERE return_date - rental_date > INTERVAL '7 Days'
);
	COMMIT;
END;
$$;

CALL late_fee()


SELECT *
FROM payment
WHERE customer_id = 408;

