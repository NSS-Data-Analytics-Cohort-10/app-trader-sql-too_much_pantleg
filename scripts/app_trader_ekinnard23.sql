
App Trader
Your team has been hired by a new company called App Trader to help them explore and gain insights from apps that are made available through the Apple App Store and Android Play Store.   

App Trader is a broker that purchases the rights to apps from developers in order to market the apps and offer in-app purchases. The apps'' developers retain all money from users purchasing the app from the relevant app store, and they retain half of the money made from in-app purchases. App Trader will be solely responsible for marketing any apps they purchase the rights to.

Unfortunately, the data for Apple App Store apps and the data for Android Play Store apps are located in separate tables with no referential integrity.

1. Loading the data
	a. Launch PgAdmin and create a new database called app_trader.

	b. Right-click on the app_trader database and choose Restore...

	c. Use the default values under the Restore Options tab.

	d. In the Filename section, browse to the backup file app_store_backup.backup in the data folder of this repository.

	e. Click Restore to load the database.

	f. Verify that you have two tables:
		- app_store_apps with 7197 rows
		- play_store_apps with 10840 rows

2. Assumptions
Based on research completed prior to launching App Trader as a company, you can assume the following:

	a. App Trader will purchase the rights to apps for 10,000 times the list price of the app on the Apple App Store/Google Play Store, however the minimum price to purchase the rights to an app is $25,000. For example, a $3 app would cost $30,000 (10,000 x the price) and a free app would cost $25,000 (The minimum price). NO APP WILL EVER COST LESS THEN $25,000 TO PURCHASE.

SELECT *,
	CASE WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY) THEN CAST(p.price AS MONEY)*10000
	WHEN CAST(a.price AS MONEY) > CAST(p.price AS MONEY) THEN CAST(a.price AS MONEY)*10000
	ELSE CAST(10000 AS MONEY) END AS purchase_price
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
USING (name);


	b. Apps earn $5000 per month on average from in-app advertising and in-app purchases regardless of the price of the app.

	c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.

SELECT DISTINCT (name),
CASE WHEN a.name = p.name THEN 'Yes'
ELSE 'No'
END AS in_both,
CAST(1000 AS MONEY) AS market_price
FROM app_store_apps AS a
LEFT JOIN play_store_apps AS p
USING (name)
ORDER BY in_both DESC

	d. For every quarter-point that an app gains in rating, its projected lifespan increases by 6 months, in other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years. Ratings should be rounded to the nearest 0.5 to evaluate an app's' likely longevity.

SELECT play_store_apps.name,
	Round(avg_rating /.5)*.5 AS averages,
	((Round(avg_rating /.5)*.5)*24+12) AS lifespan_months,
	CAST(ROUND(avg_rating *2)+1 AS MONEY),
	app_store_apps.rating AS asa_rating,
	play_store_apps.rating AS psa_rating
FROM (SELECT play_store_apps.name, 
	  (play_store_apps.rating + app_store_apps.rating)/2 AS avg_rating
	  FROM play_store_apps
	  INNER JOIN app_store_apps
	  USING (name)) AS avg_ratings
	  INNER JOIN play_store_apps
	  USING (name)
	  	Inner Join app_store_apps
		Using (name)

	e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.

3. Deliverables
	a. Develop some general recommendations about the price range, genre, content rating, or any other app characteristics that the company should target.

	b. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.

	c. Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically appropriate for next months's' Pi Day themed campaign.

	c. Submit a report based on your findings. The report should include both of your lists of apps along with your analysis of their cost and potential profits. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report.







App Trader
Your team has been hired by a new company called App Trader to help them explore and gain insights from apps that are made available through the Apple App Store and Android Play Store.   

App Trader is a broker that purchases the rights to apps from developers in order to market the apps and offer in-app purchases. The apps'' developers retain all money from users purchasing the app from the relevant app store, and they retain half of the money made from in-app purchases. App Trader will be solely responsible for marketing any apps they purchase the rights to.

Unfortunately, the data for Apple App Store apps and the data for Android Play Store apps are located in separate tables with no referential integrity.

1. Loading the data
	a. Launch PgAdmin and create a new database called app_trader.

	b. Right-click on the app_trader database and choose Restore...

	c. Use the default values under the Restore Options tab.

	d. In the Filename section, browse to the backup file app_store_backup.backup in the data folder of this repository.

	e. Click Restore to load the database.

	f. Verify that you have two tables:
		- app_store_apps with 7197 rows
		- play_store_apps with 10840 rows

2. Assumptions
Based on research completed prior to launching App Trader as a company, you can assume the following:

	a. App Trader will purchase the rights to apps for 10,000 times the list price of the app on the Apple App Store/Google Play Store, however the minimum price to purchase the rights to an app is $25,000. For example, a $3 app would cost $30,000 (10,000 x the price) and a free app would cost $25,000 (The minimum price). NO APP WILL EVER COST LESS THEN $25,000 TO PURCHASE.

	b. Apps earn $5000 per month on average from in-app advertising and in-app purchases regardless of the price of the app.

	c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.

	d. For every quarter-point that an app gains in rating, its projected lifespan increases by 6 months, in other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years. Ratings should be rounded to the nearest 0.25 to evaluate an app's' likely longevity.

SELECT play_store_apps.name,
	Round(avg_rating /.5)*.5 AS averages,
	Round(avg_rating *2)+1 AS lifespan_years,
	app_store_apps.rating AS asa_rating,
	play_store_apps.rating AS psa_rating
FROM (SELECT play_store_apps.name, 
	  (play_store_apps.rating + app_store_apps.rating)/2 AS avg_rating
	  FROM play_store_apps
	  INNER JOIN app_store_apps
	  USING (name)) AS avg_ratings
	  INNER JOIN play_store_apps
	  USING (name)
	  	Inner Join app_store_apps
		Using (name)

	e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.

3. Deliverables
	a. Develop some general recommendations about the price range, genre, content rating, or any other app characteristics that the company should target.

	b. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.

	c. Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically appropriate for next months's' Pi Day themed campaign.

	c. Submit a report based on your findings. The report should include both of your lists of apps along with your analysis of their cost and potential profits. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report.

SELECT *  
FROM play_store_apps

SELECT *
FROM app_store_apps


SELECT name,
	price,
	price*10000 AS app_trader_price,
		CASE WHEN price = 0
		THEN app_trader_price = 10000
FROM app_store_apps
ORDER BY name

SELECT name,
	price,
	price*10000 AS app_trader_price
FROM play_store_apps
INNER JOIN app_store_apps
ON play_store_apps.name = app_store_apps.name
	ORDER BY name
	
		d. For every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years.


	- App store ratings should be calculated by taking the average of the scores from both app stores and rounding to the nearest 0.5.
	
SELECT play_store_apps.name,
	Round(avg_rating /.5)*.5 AS averages,
	app_store_apps.rating AS asa_rating,
	play_store_apps.rating AS psa_rating
FROM (SELECT play_store_apps.name, 
	  (play_store_apps.rating + app_store_apps.rating)/2 AS avg_rating
	  FROM play_store_apps
	  INNER JOIN app_store_apps
	  USING (name)) AS avg_ratings
	  INNER JOIN play_store_apps
	  USING (name)
	  	Inner Join app_store_apps
		Using (name)
		
		



help them explore and gain insights from apps that are made available through the Apple App Store and Android Play Store. App Trader is a broker that purchases the rights to apps from developers in order to market the apps and offer in-app purchase. 

Unfortunately, the data for Apple App Store apps and Android Play Store Apps is located in separate tables with no referential integrity.

#### 1. Loading the data
a. Launch PgAdmin and create a new database called app_trader.  

RUSHI:
SELECT *,
 CASE WHEN CAST(p.price AS MONEY) > CAST(a.price AS MONEY) THEN CAST(p.price AS MONEY)*10000
 WHEN CAST(a.price AS MONEY) > CAST(p.price AS MONEY) THEN CAST(a.price AS MONEY)*10000
 ELSE CAST(10000 AS MONEY) END AS real_price
FROM play_store_apps AS p
INNER JOIN app_store_apps AS a
USING (name);

b. Right-click on the app_trader database and choose `Restore...`  

c. Use the default values under the `Restore Options` tab. 

d. In the `Filename` section, browse to the backup file `app_store_backup.backup` in the data folder of this repository.  

e. Click `Restore` to load the database.  

f. Verify that you have two tables:  
    - `app_store_apps` with 7197 rows  
    - `play_store_apps` with 10840 rows

#### 2. Assumptions

Based on research completed prior to launching App Trader as a company, you can assume the following:

a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.
    
- For example, an app that costs $2.00 will be purchased for $20,000.
    
- The cost of an app is not affected by how many app stores it is on. A $1.00 app on the Apple app store will cost the same as a $1.00 app on both stores. 
    
	- If an app is on both stores, it's' purchase price will be calculated based off of the highest app price between the two stores. 

	b. Apps earn $5000 per month, per app store it is on, from in-app advertising and in-app purchases, regardless of the price of the app.

	- An app that costs $200,000 will make the same per month as an app that costs $1.00. 

	- An app that is on both app stores will make $10,000 per month. 

	c. App Trader will spend an average of $1000 per month to market an app regardless of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.

	- An app that costs $200,000 and an app that costs $1.00 will both cost $1000 a month for marketing, regardless of the number of stores it is in.

	d. For every half point that an app gains in rating, its projected lifespan increases by one year. In other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years.


	- App store ratings should be calculated by taking the average of the scores from both app stores and rounding to the nearest 0.5.

	e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.


	#### 3. Deliverables

	a. Develop some general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.

	b. Develop a Top 10 List of the apps that App Trader should buy.

	c. Submit a report based on your findings. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report. 

	

	SELECT *  
	FROM play_store_apps

	SELECT *
	FROM app_store_apps

	SELECT name,
		price,
		price*10000 AS app_trader_price,
		CASE WHEN price = 0
		THEN app_trader_price = 10000
	FROM app_store_apps
	ORDER BY name

	SELECT name,
		price,
		price*10000 AS app_trader_price
	FROM play_store_apps
	INNER JOIN app_store_apps
	ON play_store_apps.name = app_store_apps.name
	ORDER BY name