-- f. Verify that you have two tables:  
--     - `app_store_apps` with 7197 rows  
--     - `play_store_apps` with 10840 rows
select*
from app_store_apps

select *
from play_store_apps
inner join app_store_apps
using (name)
-- 2. Assumptions

-- Based on research completed prior to launching App Trader as a company, you can assume the following:

-- a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000. how much can the app trader spend on an app that cost =<10,000

SELECT name, 
CASE WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY)
THEN
CAST (p. price AS MONEY) *10000
WHEN CAST (a.price AS MONEY) > CAST(p.price AS MONEY) THEN CAST(a.price AS
MONEY) *10000
ELSE CAST(p.price AS MONEY)*10000 END AS real_price
FROM play_store_apps
AS p
INNER JOIN app_store_apps AS a
USING (name)
group by real_price, name

where real_price ILIKE '$9,900.00'


    
-- - For example, an app that costs $2.00 will be purchased for $20,000.
SELECT a.name, p.price 
FROM app_store_apps AS a
JOIN play_store_apps AS p
ON a.name = p.name
WHERE p.price = 2.00 (falsch)

    
-- - The cost of an app is not affected by how many app stores it is on. A $1.00 app on the Apple app store will cost the same as a $1.00 app on both stores. 

SELECT*,
CASE WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY)
THEN
CAST (p. price AS MONEY) *10000
WHEN CAST (a.price AS MONEY) > CAST(p.price AS MONEY) THEN CAST(a.price AS
MONEY) *10000
ELSE CAST(p.price AS MONEY)*10000 END AS real_price
FROM play_store_apps
AS p
INNER JOIN app_store_apps AS a
USING (name)
    
-- - If an app is on both stores, it's purchase price will be calculated based off of the highest app price between the two stores. How much did the app then make?

-- b. Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of the price of the app. I am creating a SQL query to calculate the total earnings based on this assumption.
SELECT
  app.name,
  SUM(CAST(5000 AS MONEY)) AS earnings
FROM
  (
    SELECT name FROM app_store_apps
    UNION
    SELECT name FROM play_store_apps
  ) AS app
GROUP BY
  app.name;

-- - An app that costs $200,000 will make the same per month as an app that costs $1.00. 

SELECT 
    app_store_apps.name,
    play_store_apps.name,
    CAST(10000 AS MONEY) AS monthly_earnings
FROM 
    app_store_apps
INNER JOIN 
    play_store_apps 
ON 
    app_store_apps.name = play_store_apps.name; (Richtig)

-- - An app that is on both app stores will make $10,000 per month. 

SELECT 
    app.name,
    CASE 
        WHEN app.name IS NOT NULL AND play_apps.name IS NOT NULL THEN 10000 
        ELSE 0 
    END AS monthly_earnings
FROM 
    app_store_apps AS app
LEFT JOIN 
    play_store_apps AS play_apps 
ON 
    app.name = play_apps.name
LIMIT 10; Richtig

-- c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.

SELECT DISTINCT (name),
CASE WHEN a.name = p.name THEN 'Yes'
ELSE 'No'
END AS in_both,
CAST(1000 AS MONEY) AS market_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING (name)
ORDER BY in_both DESC

    
-- - An app that costs $200,000 and an app that costs $1.00 will both cost $1000 a month for marketing, regardless of the number of stores it is in.

SELECT 
    app_store_apps.name,
    app_store_apps.price AS app_store_price,
    play_store_apps.price AS play_store_price,
    1000 AS monthly_marketing_cost
FROM 
    app_store_apps
JOIN 
    play_store_apps 
ON 
    app_store_apps.name = play_store_apps.name;

-- d. For every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years.

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

    
-- - App store ratings should be calculated by taking the average of the scores from both app stores and rounding to the nearest 0.5.


-- e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.

SELECT app_store_apps.name, app_store_apps.price, CAST(1000 AS MONEY) AS price_for_app
FROM app_store_apps
JOIN play_store_apps
USING (name)
WHERE CAST(app_store_apps.price AS MONEY) <= CAST(1000 AS MONEY) AND CAST(play_store_apps.price AS MONEY) <= CAST(1000 AS MONEY);



-- #### 3. Deliverables

-- a. Develop some general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.

SELECT DISTINCT name,
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


-- b. Develop a Top 10 List of the apps that App Trader should buy.
SELECT DISTINCT name,
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
ORDER BY profitability DESC
LIMIT 10;


-- c. Submit a report based on your findings. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report. 

-- updated 2/18/2023