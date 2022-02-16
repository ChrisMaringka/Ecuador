SELECT *
FROM train t, stores s
WHERE t.store_nbr = s.store_nbr;

# confirming there is a date where oil price is null

SELECT *
FROM oil;

SELECT *
FROM oil o
JOIN holidays_events h
	ON h.date = o.date
WHERE dcoilwtico = 0;

# created a table to store average price of oil by month and year

CREATE TABLE oilavg
(SELECT 
	YEAR(o.date) AS year,
    MONTH(o.date) AS month,
	ROUND(AVG(o.dcoilwtico), 2) AS average
FROM oil o
WHERE o.dcoilwtico != 0
GROUP BY MONTH(o.date), YEAR(o.date));

SELECT * FROM oilavg;

# Turn off Safe Updates to update oil table

SET SQL_SAFE_UPDATES = 0;

UPDATE oil
SET dcoilwtico = 
(
   SELECT oi.average
	FROM oilavg oi
	WHERE
	YEAR(oil.date) = oi.year
	AND MONTH(oil.date) = oi.month
)
WHERE oil.dcoilwtico = 0;

SELECT *
FROM holidays_events;

SELECT 
	t.id,
	t.date, 
    t.store_nbr, 
    t.family, 
    t.sales, 
    t.onpromotion, 
    o.dcoilwtico,
    s.city,
    s.type as store_type,
    s.cluster,
	h.type as holiday_type,
    h.locale,
    h.locale_name,
    h.description,
    h.transferred
FROM train t
LEFT JOIN oil o
	ON t.date = o.date
LEFT JOIN stores s
	ON t.store_nbr = s.store_nbr
LEFT JOIN holidays_events h
	ON t.date = h.date
group by t.id;