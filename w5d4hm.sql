
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

