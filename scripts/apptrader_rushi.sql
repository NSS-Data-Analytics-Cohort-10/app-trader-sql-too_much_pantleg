SELECT *
FROM app_store_apps
LIMIT 10;

SELECT *
FROM play_store_apps
LIMIT 10;

SELECT *
FROM play_store_apps
INNER JOIN app_store_apps
USING (name);


--PURCHASE PRICE COLUMN


SELECT *,
	CASE WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY)*10000
	WHEN CAST(a.price AS MONEY) > CAST(p.price AS MONEY) AND CAST(a.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(a.price AS MONEY)*10000
	WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) < CAST(1 AS MONEY) THEN CAST(10000 AS MONEY)
	WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY)*10000
	ELSE CAST(10000 AS MONEY) END AS purchase_price
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
USING (name);
--This query gives us all apps that are on both app stores as well as a column that shows what App Trader's purchase price will be; the column is called purchase_price at the far right of the output. 553 rows

SELECT *,
	CASE WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY)*10000
	WHEN CAST(a.price AS MONEY) > CAST(p.price AS MONEY) AND CAST(a.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(a.price AS MONEY)*10000
	WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) < CAST(1 AS MONEY) THEN CAST(10000 AS MONEY)
	WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY)*10000
	ELSE CAST(10000 AS MONEY) END AS purchase_price
FROM play_store_apps AS p
FULL JOIN app_store_apps AS a
USING (name);
--This query does the same thing as the one above but it's a full join instead. 17709 rows

SELECT *,
	CASE WHEN CAST(price AS MONEY) > CAST(.99 AS MONEY) THEN CAST(price AS MONEY)*10000
	WHEN CAST(price AS MONEY) <= CAST(.99 AS MONEY) THEN CAST(10000 AS MONEY)
	ELSE CAST(10000 AS MONEY) END AS purchase_price
FROM play_store_apps;
--This query is all columns in the play_store_apps table with the final column purchase_price as App Trader's purchase price for that app.


SELECT *,
	CASE WHEN CAST(price AS MONEY) > CAST(.99 AS MONEY) THEN CAST(price AS MONEY)*10000
	WHEN CAST(price AS MONEY) <= CAST(.99 AS MONEY) THEN CAST(10000 AS MONEY)
	ELSE CAST(10000 AS MONEY) END AS real_price
FROM app_store_apps
ORDER BY real_price;
----This query is all columns in the app_store_apps table with the final column purchase_price as App Trader's purchase price for that app.





--ROUND(ROUND(((p.rating+a.rating)/2)/5,1)*5,1) AS avg_rating
--This gives us the average rating of an app in both stores rounded to the nearest 0.5


SELECT *,
	CASE WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY)*10000
	WHEN CAST(a.price AS MONEY) > CAST(p.price AS MONEY) AND CAST(a.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(a.price AS MONEY)*10000
	WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) < CAST(1 AS MONEY) THEN CAST(10000 AS MONEY)
	WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY)*10000
	ELSE CAST(10000 AS MONEY) END AS purchase_price,
	ROUND(ROUND(((p.rating+a.rating)/2)/5,1)*5,1) AS avg_rating
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
USING (name);
--This query gives us apps that are in both app stores, a column with App Trader's purchase price, and a column with the average rating rounded to the nearest 0.5.



SELECT *,
	CASE WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY)*10000
	WHEN CAST(a.price AS MONEY) > CAST(p.price AS MONEY) AND CAST(a.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(a.price AS MONEY)*10000
	WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) < CAST(1 AS MONEY) THEN CAST(10000 AS MONEY)
	WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY)*10000
	ELSE CAST(10000 AS MONEY) END AS purchase_price,
	ROUND(ROUND(((p.rating+a.rating)/2)/5,1)*5,1) AS avg_rating, ((ROUND(ROUND(((p.rating+a.rating)/2)/5,1)*5,1)*2)+1) AS lifespan
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
USING (name);
--This query is the same as the one above, now with a lifespan column.



SELECT *,
	CASE WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY)*10000
	WHEN CAST(a.price AS MONEY) > CAST(p.price AS MONEY) AND CAST(a.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(a.price AS MONEY)*10000
	WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) < CAST(1 AS MONEY) THEN CAST(10000 AS MONEY)
	WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY)*10000
	ELSE CAST(10000 AS MONEY) END AS purchase_price,
	ROUND(ROUND(((p.rating+a.rating)/2)/5,1)*5,1) AS avg_rating, ((ROUND(ROUND(((p.rating+a.rating)/2)/5,1)*5,1)*2)+1) AS lifespan
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
USING (name)
ORDER BY purchase_price;




SELECT DISTINCT name,category, p.genres,
    ROUND(avg_rating / 0.5) * 0.5 AS averages,
    ((ROUND(avg_rating / 0.5) * 0.5) * 24 + 12) AS lifespan_months,
    CAST(((ROUND(avg_rating / 0.5) * 0.5) * 24 + 12) * 4000 AS MONEY) AS lifespan_income,
    a.rating AS asa_rating,
    p.rating AS psa_rating,
    CASE WHEN a.name = p.name THEN 'Yes' ELSE 'No' END AS in_both,
    purchase_price,
    (CAST(((ROUND(avg_rating / 0.5) * 0.5) * 24 + 12) * 4000 AS MONEY) - purchase_price) AS profitability
FROM (
    SELECT p.name,
        (p.rating + a.rating) / 2 AS avg_rating
    FROM play_store_apps AS p
    INNER JOIN app_store_apps AS a
    USING (name)
) AS avg_ratings
INNER JOIN play_store_apps AS p
USING (name)
INNER JOIN app_store_apps AS a
USING (name)
LEFT JOIN (
    SELECT p.name,
        CASE
            WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY) * 10000
            WHEN CAST(a.price AS MONEY) > CAST(p.price AS MONEY) AND CAST(a.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(a.price AS MONEY) * 10000
            WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) < CAST(1 AS MONEY) THEN CAST(10000 AS MONEY)
            WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY) * 10000
            ELSE CAST(10000 AS MONEY)
        END AS purchase_price
    FROM play_store_apps AS p
    INNER JOIN app_store_apps AS a
    USING (name)
) AS purchase_data
USING (name)
ORDER BY profitability DESC;


SELECT DISTINCT name,
	p.category,
	a.primary_genre,
    ROUND(avg_rating / 0.5) * 0.5 AS averages,
    ((ROUND(avg_rating / 0.5) * 0.5) * 24 + 12) AS lifespan_months,
    CAST(((ROUND(avg_rating / 0.5) * 0.5) * 24 + 12) * 4000 AS MONEY) AS lifespan_income,
    a.rating AS asa_rating,
    p.rating AS psa_rating,
    CASE WHEN a.name = p.name THEN 'Yes' ELSE 'No' END AS in_both,
    purchase_price,
    (CAST(((ROUND(avg_rating / 0.5) * 0.5) * 24 + 12) * 4000 AS MONEY) - purchase_price) AS profitability
FROM (
    SELECT p.name,
        (p.rating + a.rating) / 2 AS avg_rating
    FROM play_store_apps AS p
    INNER JOIN app_store_apps AS a
    USING (name)
) AS avg_ratings
INNER JOIN play_store_apps AS p
USING (name)
INNER JOIN app_store_apps AS a
USING (name)
LEFT JOIN (
    SELECT p.name,
        CASE
            WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY) * 10000
            WHEN CAST(a.price AS MONEY) > CAST(p.price AS MONEY) AND CAST(a.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(a.price AS MONEY) * 10000
            WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) < CAST(1 AS MONEY) THEN CAST(10000 AS MONEY)
            WHEN CAST(p.price AS MONEY) = CAST(a.price AS MONEY) AND CAST(p.price AS MONEY) > CAST(1 AS MONEY) THEN CAST(p.price AS MONEY) * 10000
            ELSE CAST(10000 AS MONEY)
        END AS purchase_price
    FROM play_store_apps AS p
    INNER JOIN app_store_apps AS a
    USING (name)
) AS purchase_data
USING (name)
ORDER BY profitability DESC;


