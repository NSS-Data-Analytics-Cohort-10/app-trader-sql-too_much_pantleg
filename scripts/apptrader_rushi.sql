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



SELECT *,
	CASE WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY) THEN CAST(p.price AS MONEY)*10000
	WHEN CAST(a.price AS MONEY) > CAST(p.price AS MONEY) THEN CAST(a.price AS MONEY)*10000
	ELSE CAST(10000 AS MONEY) END AS purchase_price
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
USING (name);
--This query gives us all apps that are on both app stores as well as a column that shows what App Trader's purchase price will be; the column is called real_price at the far right of the output. 553 rows

SELECT *,
	CASE WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY) THEN CAST(p.price AS MONEY)*10000
	WHEN CAST(a.price AS MONEY) > CAST(p.price AS MONEY) THEN CAST(a.price AS MONEY)*10000
	ELSE CAST(10000 AS MONEY) END AS purchase_price
FROM play_store_apps AS p
FULL JOIN app_store_apps AS a
USING (name);
--This query does the same thing as the one above but it's a full join instead. 17709 rows

SELECT *,
	CASE WHEN CAST(price AS MONEY) > CAST(0 AS MONEY) THEN CAST(price AS MONEY)*10000
	WHEN CAST(price AS MONEY) = CAST(0 AS MONEY) THEN CAST(10000 AS MONEY)
	ELSE CAST(10000 AS MONEY) END AS purchase_price
FROM play_store_apps;
--This query is all columns in the play_store_apps table with the final column purchase_price as App Trader's purchase price for that app.


SELECT *,
	CASE WHEN CAST(price AS MONEY) > CAST(0 AS MONEY) THEN CAST(price AS MONEY)*10000
	WHEN CAST(price AS MONEY) = CAST(0 AS MONEY) THEN CAST(10000 AS MONEY)
	ELSE CAST(10000 AS MONEY) END AS real_price
FROM app_store_apps;
----This query is all columns in the app_store_apps table with the final column purchase_price as App Trader's purchase price for that app.


