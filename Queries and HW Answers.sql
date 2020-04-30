-- Isolate transactions by cardholder

SELECT ID_card_holder 
FROM credit_card
INNER JOIN transactions 
ON credit_card.card = transactions.card
GROUP BY ID_card_holder;

--100 highest transactions from 7 am - 9 am

SELECT transaction_date, amount, merchant_ID
FROM transactions
WHERE date_part('hour', transaction_date) BETWEEN 7 AND 8 
ORDER BY amount DESC
LIMIT 100;

--Are there noticeable fraudulent transactions from 7 am - 9 am?

--The query above shows 8 transactions ranging from $1,894 to $748. Starting at the 9th largest transaction, the amounts falls to $100 and then into the $20-range after that. Therefore, these top-8 transactions should be investigated and probably the $100 one at #9 as well. I would also look for very small ones as coded on lines 22-25 below.


SELECT transaction_date, amount, merchant_ID
FROM transactions
WHERE date_part('hour', transaction_date) BETWEEN 7 AND 8 AND AMOUNT < 2.00
ORDER BY amount ASC;

--Given the note in the instructions that transactions <$2.00 could indicate potential fraud, then it is possible there is fraud since there are 30 of these transactions out of 275 such small transactions (~11%). To run the code I ran as is above to return the sub-$2.00 transactions and then removed 'AND AMOUNT < 2.00' and re-ran the code to find the total transactions. Alternatively, running the code from lines 12=14 also returns the total transactions during these 2 hours.


-- Total fraudulent transactions, assuming multiple transactions < $2.00 suggest possible fraudulent activity

SELECT merchant.merchant_name, COUNT(transactions.amount)
FROM transactions
INNER JOIN merchant
ON transactions.merchant_ID = merchant.merchant_ID
WHERE amount < 2.00
GROUP BY merchant_name
ORDER BY COUNT DESC;

--As the following firms have the most transactions less than $2.00, we view Wood_Ramirez (7), Hood_Phillips  and Baker Inc. (6-each) as the three firms most prone to hacking via small transactions. We count a 12-way tie for the next prone firms as 12 firms such Riggs-Adams and Reed Group had 5 sub-$2.00 transactions.

--Views
--Isolate transactions by cardholders
CREATE VIEW holder_trans as
SELECT ID_card_holder 
FROM credit_card
INNER JOIN transactions 
ON credit_card.card = transactions.card
GROUP BY ID_card_holder;

SELECT *
FROM holder_trans;

--100 highest transactions from 7 am - 9 am

CREATE VIEW high_am_trans as
SELECT transaction_date, amount, merchant_ID
FROM transactions
WHERE date_part('hour', transaction_date) BETWEEN 7 AND 8 
ORDER BY amount DESC
LIMIT 100;

SELECT *
FROM high_am_trans;

--Potential fraudulent transactions from 7 am - 9 am

CREATE VIEW small_am_trans as
SELECT transaction_date, amount, merchant_ID
FROM transactions
WHERE date_part('hour', transaction_date) BETWEEN 7 AND 8 AND AMOUNT < 2.00
ORDER BY amount ASC;

SELECT *
FROM small_am_trans;

-- Total fraudulent transactions, assuming multiple transactions < $2.00 suggest possible fraudulent activity

CREATE VIEW tot_small_trans as
SELECT merchant.merchant_name, COUNT(transactions.amount)
FROM transactions
INNER JOIN merchant
ON transactions.merchant_ID = merchant.merchant_ID
WHERE amount < 2.00
GROUP BY merchant_name
ORDER BY COUNT DESC;

SELECT *
FROM tot_small_trans;

--Cardholder 2 transaction history

SELECT credit_card.ID_card_holder, transactions.transaction_date, transactions.amount
FROM credit_card
INNER JOIN transactions 
ON credit_card.card = transactions.card
WHERE ID_card_holder = 2
GROUP BY ID_card_holder, transaction_date, amount
ORDER BY transaction_date ASC;

--Cardholder 18 transaction history

SELECT credit_card.ID_card_holder, transactions.transaction_date, transactions.amount
FROM credit_card
INNER JOIN transactions 
ON credit_card.card = transactions.card
WHERE ID_card_holder = 18
GROUP BY ID_card_holder, transaction_date, amount
ORDER BY transaction_date ASC;

--Combined cardholder 18 transaction history

SELECT credit_card.ID_card_holder, transactions.transaction_date, transactions.amount
FROM credit_card
INNER JOIN transactions 
ON credit_card.card = transactions.card
WHERE ID_card_holder = 18 OR ID_card_holder = 2
GROUP BY transaction_date, ID_card_holder, amount
ORDER BY transaction_date ASC;


--see visual_data_analysis for conclusions

--Cardholder 25 transaction history

SELECT credit_card.ID_card_holder, transactions.transaction_date, transactions.amount
FROM credit_card
INNER JOIN transactions 
ON credit_card.card = transactions.card
WHERE ID_card_holder = 25
GROUP BY ID_card_holder, transaction_date, amount
ORDER BY transaction_date ASC;

--see visual_data_analysis for conclusions