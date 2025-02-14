#### CREATING NEW DATABASE ####
CREATE DATABASE fitbit; 
USE fitbit;

#### DAILY ACTIVITY ####

-- Change table name from dailyActivity_merged to daily_activity
ALTER TABLE dailyActivity_merged RENAME TO daily_activity; 

-- View new table 
SELECT *
FROM daily_activity;

-- Check distinct Id
-- NOTE: 33 distinct IDs
SELECT COUNT(DISTINCT Id)
FROM daily_activity;

-- Grouping by ID and seeing how many entries for each ID
SELECT Id, COUNT(*) AS amount_entries
FROM daily_activity
GROUP BY Id;

-- See what data types are columns are
DESCRIBE daily_activity;

-- Check if there are any NULL values in daily_activity
-- NOTE: NO NULL values because returned 0 rows
SELECT *
FROM daily_activity
WHERE COALESCE(Id, ActivityDate, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance, 
		VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance, 
		VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories) IS NULL;
  
-- Check if any of the values in the columns are less than 1
-- NOTE: 940 rows returned so there is no negative values
SELECT *
FROM daily_activity
WHERE TotalSteps >= 0
	AND TotalDistance >= 0
	AND TrackerDistance >= 0
	AND LoggedActivitiesDistance >= 0
	AND VeryActiveDistance >= 0
	AND ModeratelyActiveDistance >= 0
	AND LightActiveDistance >= 0
	AND SedentaryActiveDistance >= 0
	AND VeryActiveMinutes >= 0
	AND FairlyActiveMinutes >= 0
	AND LightlyActiveMinutes >= 0
	AND SedentaryMinutes >= 0
	AND Calories >= 0;

-- Checking for duplicates rows
-- NOTE: No duplicate rows
SELECT 
	Id, ActivityDate, TotalSteps
FROM  
	daily_activity
GROUP BY
	Id, ActivityDate, TotalSteps
HAVING Count(*) > 1; 

-- Change Column 'ActivityDate' from text to DATE
-- NOTE: Replace '%Y-%m-%d' with the appropriate format that matches the text format of your ActivityDate column
UPDATE daily_activity
SET ActivityDate = STR_TO_DATE(ActivityDate, '%c/%e/%Y');

-- NOTE: Once the values are formatted correctly, update the column data type using ALTER TABLE
ALTER TABLE daily_activity MODIFY COLUMN ActivityDate DATE;

-- Viewing the new data type
DESCRIBE daily_activity;

-- Create new column TotalActiveMinutes and TotalActiveDistance
-- TotalActiveMinutes
ALTER TABLE daily_activity ADD COLUMN TotalActiveMinutes INT;
UPDATE daily_activity SET TotalActiveMinutes = VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes;

-- TotalActiveDistance
ALTER TABLE daily_activity ADD COLUMN TotalActiveMinutes INT;
UPDATE daily_activity SET TotalActiveMinutes = VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes;

-- Getting the day of the week name and adding it as a new column
ALTER TABLE daily_activity ADD COLUMN DayName VARCHAR(9);
UPDATE daily_activity SET DayName = DAYNAME(ActivityDate);

-- Seperate ID by Light, Moderate and Very Active by amount of daily activity
SELECT
	ID,
	COUNT(*) as TotalLoggedDays,
    CASE
		WHEN COUNT(Id) BETWEEN 0 AND 14 THEN 'Light User'
        WHEN COUNT(Id) BETWEEN 15 AND 24 THEN 'Moderate User'
        WHEN COUNT(Id) BETWEEN 25 AND 31 THEN 'Very Active User'
	END AS fitbitactivity
FROM daily_activity
GROUP BY Id;

-- Add new column fitbitactivity
ALTER TABLE daily_activity ADD COLUMN fitbitactivity VARCHAR(20);
UPDATE daily_activity 
  JOIN (
    SELECT 
      Id, 
      CASE 
      WHEN COUNT(*) BETWEEN 0 AND 14 THEN 'Light User' 
      WHEN COUNT(*) BETWEEN 15 AND 24 THEN 'Moderate User' 
      WHEN COUNT(*) BETWEEN 25 AND 31 THEN 'Very Active User' END AS fitbitactivity 
    FROM 
      daily_activity 
    GROUP BY 
      Id
  ) AS summary ON daily_activity.Id = summary.Id 
SET 
  daily_activity.fitbitactivity = summary.fitbitactivity;



#### SLEEP DAY ####

-- Change table name from sleepday_merged to sleepday
ALTER TABLE sleepday_merged RENAME TO sleepday;

-- View new table and ata types
SELECT * FROM sleepday;
DESCRIBE sleepday;

-- Check Unique Id
-- Note: 24 distinct IDs
SELECT COUNT(DISTINCT Id)
FROM sleepday;

-- How many times the Id appears
SELECT Id, COUNT(*)
FROM sleepday
GROUP BY Id;

-- Check is there are any NULL values in sleepday
-- NOTE: NO NULL values
SELECT *
FROM sleepday
WHERE COALESCE(Id,SleepDay,TotalSleepRecords,TotalMinutesAsleep,TotalTimeInBed) IS NULL;

-- Addding new column MinutesAwakeInBed = TotalTimeInBed - TotalMinutesAsleep
ALTER TABLE sleepday ADD COLUMN MinutesAwakeInBed INT;
UPDATE sleepday SET MinutesAwakeInBed = TotalTimeInBed - TotalMinutesAsleep;

-- Check if there are any duplicates
-- NOTE: There are 3 duplicate rows
SELECT Id,SleepDay,TotalSleepRecords
FROM sleepday
GROUP BY Id,SleepDay,TotalSleepRecords
HAVING COUNT(*) > 1;

-- Removing duplicate rows
CREATE TABLE cleaned_sleepday AS
SELECT DISTINCT *
FROM sleepday;

-- View new table CLEANED_SLEEPDAY 410 rows appear removing the 3 duplicate data and we keep the original table sleepday
SELECT * FROM cleaned_sleepday;

-- Change Column 'SleepDay' from text to DATETIME
-- NOTE: Replace '%Y-%m-%d' with the appropriate format that matches the text format of your ActivityDate column. Once the values are formatted correctly, update the column type using ALTER TABLE 
UPDATE cleaned_sleepday SET SleepDay = STR_TO_DATE(SleepDay, '%c/%e/%Y %r');
ALTER TABLE cleaned_sleepday MODIFY COLUMN SleepDay DATETIME;

-- View the change in date type from string to date time
SELECT * FROM cleaned_sleepday;
DESCRIBE cleaned_sleepday;

-- Getting the day of the week name and then adding it to a new column
SELECT DAYNAME(SleepDay) AS DAYNAME
FROM cleaned_sleepday;
ALTER TABLE cleaned_sleepday ADD COLUMN DayName VARCHAR(9);
UPDATE cleaned_sleepday SET DayName = DAYNAME(SleepDay);

-- 1. Changing Columns To Hours From Minutes
SELECT TotalMinutesAsleep/60 AS TotalHourAsleep,
TotalTimeInBed/60 AS TotalHourInBed,
MinutesAwakeInBed/60 AS HoursAwakeInBed
FROM cleaned_sleepday;

-- 2. Changing Data Type FROM INT to FLOAT before updating the columns to be in hours instead of minutes
ALTER TABLE cleaned_sleepday
MODIFY TotalMinutesAsleep FLOAT,
MODIFY TotalTimeInBed FLOAT,
MODIFY MinutesAwakeInBed FLOAT;

-- View the change
DESCRIBE cleaned_sleepday;

-- Update the columns to minutes
UPDATE cleaned_sleepday SET
	TotalMinutesAsleep = TotalMinutesAsleep/60,
    TotalTimeInBed = TotalTimeInBed/60,
	MinutesAwakeInBed = MinutesAwakeInBed/60;

-- View the change
SELECT * FROM cleaned_sleepday;

-- Changing Column Names TO Hours Now
ALTER TABLE cleaned_sleepday RENAME COLUMN TotalMinutesAsleep TO TotalHourAsleep;
ALTER TABLE cleaned_sleepday RENAME COLUMN TotalTimeInBed TO TotalHourInBed;
ALTER TABLE cleaned_sleepday RENAME COLUMN MinutesAwakeInBed TO HoursAwakeInBed; 



#### HOURLY STEPS ####

-- Change table name from hourlysteps_merged to hourly_steps
AlTER TABLE hourlysteps_merged RENAME TO hourly_steps;

-- View new table and see the data types of our columns
SELECT * FROM hourly_steps;
DESCRIBE hourly_steps;

-- Change the datatype from text to datetime 
UPDATE hourly_steps SET ActivityHour = STR_TO_DATE(ActivityHour, '%m/%d/%Y %h:%i:%s %p');
ALTER TABLE hourly_steps MODIFY ActivityHour DATETIME;

-- Check if there are any NULL values in hourly_steps 
-- Note: NO NULL Values
SELECT *
FROM hourly_steps
WHERE COALESCE(Id,ActivityHour,StepTotal) IS NULL;

-- Check Distinct IDs
-- Note: 33 Distinct Ids
SELECT COUNT(DISTINCT Id)
FROM hourly_steps;

-- Check for duplicate data
-- Note: No duplicate data
SELECT ID, ActivityHour, StepTotal
FROM hourly_steps
GROUP BY ID, ActivityHour, StepTotal
HAVING COUNT(*) > 1; 

## Getting the day of the week name and saving it as a column
SELECT DAYNAME(ActivityHour) AS DAYNAME
FROM hourly_steps;
ALTER TABLE hourly_steps ADD COLUMN DayName VARCHAR(9);
UPDATE hourly_steps SET DayName = DAYNAME(ActivityHour); 



#### Hourly Calories ####

-- Change The Table Name
ALTER TABLE hourlycalories_merged RENAME TO hourly_calories;

-- View New Table 
SELECT * FROM hourly_calories;

-- 33 Distinct Ids
SELECT COUNT(DISTINCT Id)
FROM hourly_calories; 

-- Check For Duplicate Data
-- Note: No duplicates
SELECT Id, ActivityHour, Calories
FROM hourly_calories
GROUP BY Id, ActivityHour, Calories
HAVING COUNT(*) > 1;

-- Check For NULL Values
-- Note: NO NULL Values 
SELECT *
FROM hourly_calories
WHERE COALESCE(Id, ActivityHour, Calories) IS NULL;

-- Change Data Type Activity Hour To DATETIME
UPDATE hourly_calories SET ActivityHour = STR_TO_DATE(ActivityHour,'%m/%d/%Y %h:%i:%s %p');
ALTER TABLE hourly_calories MODIFY ActivityHour DATETIME;

-- See changes
DESCRIBE hourly_calories;

-- Getting the day of the week name and saving it as a column
ALTER TABLE hourly_calories ADD COLUMN DayName VARCHAR(9);
UPDATE hourly_calories SET DayName = DAYNAME(ActivityHour);



#### ALL TABLE TASKS ####
#### ANALYZE PHASE ####
-- Viewing all our tables we have cleaned
SELECT * FROM daily_activity; #33 distint IDs
SELECT * FROM cleaned_sleepday; #24 distint IDs
SELECT * FROM hourly_steps; #33 distint IDs
SELECT * FROM hourly_calories; #33 distint IDs

-- LEFT JOIN daily_activity AND cleaned_sleepday on ID and Activity Date
SELECT *
FROM daily_activity
LEFT JOIN cleaned_sleepday ON daily_activity.Id = cleaned_sleepday.Id
	AND daily_activity.ActivityDate = cleaned_sleepday.SleepDay;

-- LEFT JOIN daily_activity AND cleaned_sleepday, getting specific columns, joining by Id and Activity Date
SELECT daily_activity.Id, ActivityDate AS ActivityANDSleepDate, TotalSteps, TotalDistance, Calories, TotalActiveMinutes, TotalActiveDistance, 
daily_activity.DayName, fitbitactivity, TotalSleepRecords, TotalHourAsleep, HoursAwakeInBed, HoursAwakeInBed
FROM cleaned_sleepday
LEFT JOIN daily_activity ON daily_activity.Id = cleaned_sleepday.Id 
	AND daily_activity.ActivityDate = cleaned_sleepday.SleepDay
ORDER BY TotalHourAsleep;

-- LEFT JOIN daily_activity and Sleepday, grouping by Activity Date and ID. Getting the AVG of the different columns
SELECT ActivityDate, COUNT(*), AVG(TotalSteps), AVG(TotalDistance), AVG(Calories), AVG(TotalActiveMinutes), 
AVG(TotalActiveDistance), AVG(TotalSleepRecords), AVG(TotalHourAsleep), AVG(HoursAwakeInBed), AVG(HoursAwakeInBed)
FROM cleaned_sleepday
LEFT JOIN daily_activity ON daily_activity.Id = cleaned_sleepday.Id AND daily_activity.ActivityDate = cleaned_sleepday.SleepDay
GROUP BY ActivityDate
ORDER BY AVG(TotalSteps) DESC;


#### DAILY ACTIVITY ####
SELECT * FROM daily_activity; #33 distint IDs
-- Daily Activity MAX, MIN, AVG, SUM, STDDEV for daily_activity grouped by Id
SELECT Id, COUNT(*) AS Total_Entries, 
AVG(TotalDistance), MIN(TotalDistance), MAX(TotalDistance), SUM(TotalDistance), STDDEV(TotalDistance),
AVG(TotalSteps), MIN(TotalSteps), MAX(TotalSteps), SUM(TotalSteps), STDDEV(TotalSteps), AVG(TotalActiveMinutes), 
MIN(TotalActiveMinutes), MAX(TotalActiveMinutes), SUM(TotalActiveMinutes), STDDEV(TotalActiveMinutes)
FROM daily_activity
GROUP BY Id;

-- ^ Changed It
SELECT 
    Id, 
    COUNT(*) AS Total_Entries, 
    AVG(TotalDistance) AS Avg_Distance, 
    STDDEV(TotalDistance) AS StdDev_Distance, 
    AVG(TotalSteps) AS Avg_Steps, 
    STDDEV(TotalSteps) AS StdDev_Steps, 
    AVG(TotalActiveMinutes) AS Avg_ActiveMinutes, 
    STDDEV(TotalActiveMinutes) AS StdDev_ActiveMinutes
FROM 
    daily_activity
GROUP BY 
    Id;

-- Summary Statistic on daily_activity AVG, MAX, MIN, STDDEV
SELECT AVG(TotalDistance), MAX(TotalDistance), MIN(TotalDistance), STDDEV(TotalDistance),
AVG(TotalSteps), MIN(TotalSteps), MAX(TotalSteps), SUM(TotalSteps), STDDEV(TotalSteps),
AVG(TotalActiveMinutes), MIN(TotalActiveMinutes), MAX(TotalActiveMinutes), SUM(TotalActiveMinutes), STDDEV(TotalActiveMinutes)
FROM daily_activity;

-- MAX, MIN, AVG FOR daily_activity ON DayName and Fitbit Activity
-- Note: We see from the data that Tuesday is the most popular day to exercise in general. But if we break it down
-- by the day that people exercise and how active they are 'Very Active' the most popular days to exercide is 
-- still Tuesday, but also Wednesday and Thursday
SELECT DayName, fitbitactivity, COUNT(*) AS Total_Entries,
SUM(TotalDistance), AVG(TotalDistance), MAX(TotalDistance), MIN(TotalDistance), STDDEV(TotalDistance),
SUM(TotalSteps), AVG(TotalSteps), MIN(TotalSteps), MAX(TotalSteps), STDDEV(TotalSteps),
SUM(TotalActiveMinutes), AVG(TotalActiveMinutes), MIN(TotalActiveMinutes), MAX(TotalActiveMinutes), STDDEV(TotalActiveMinutes)
FROM daily_activity
GROUP BY DayName, fitbitactivity;

-- Changed ^
SELECT DayName,
       COUNT(*) AS Total_Entries,
       SUM(TotalDistance) AS Total_Distance,
       AVG(TotalDistance) AS Avg_Distance,
       SUM(TotalSteps) AS Total_Steps,
       AVG(TotalSteps) AS Avg_Steps,
       SUM(TotalActiveMinutes) AS Total_ActiveMinutes,
       AVG(TotalActiveMinutes) AS Avg_ActiveMinutes
FROM daily_activity
GROUP BY DayName
ORDER BY Avg_Steps DESC;


-- MAX, MIN, AVG FOR daily_activity ON ActivityDate
SELECT ActivityDate, COUNT(*) AS TotalEntires,
AVG(TotalDistance), MIN(TotalDistance), MAX(TotalDistance),
AVG(TotalSteps), MIN(TotalSteps), MAX(TotalSteps),
AVG(TotalActiveMinutes), MIN(TotalActiveMinutes), MAX(TotalActiveMinutes)
FROM daily_activity
GROUP BY ActivityDate;

-- We see that Tuesday and Wednesday are the greatest in terms of total steps, distance, active minutes, and active distance
SELECT DAYNAME, COUNT(*) AS TotalEntries, SUM(TotalSteps), SUM(TotalDistance), SUM(TotalActiveMinutes), SUM(TotalActiveDistance)
FROM daily_activity
GROUP BY DayName
ORDER BY SUM(TotalSteps) DESC;

-- Fit Bit Activity by Day Name
-- Note: This shows that based on the 3 different users light, moderate, and very activeand by the day name; wednesday for
-- light and moderate users is the highest in terms of AVG calories burned and for very active users friday is the most for 
-- AVG calories burned
SELECT fitbitactivity, DayName, ROUND(AVG(Calories), 2) AS AVG_CALORIES, AVG(VeryActiveMinutes), AVG(FairlyActiveMinutes), AVG(LightlyActiveMinutes)
FROM daily_activity
GROUP BY fitbitactivity, DayName
ORDER BY fitbitactivity, AVG_CALORIES DESC;

SELECT
	COUNT(*),
    fitbitactivity, 
    DayName, 
    ROUND(AVG(COALESCE(Calories, 0)), 2) AS avg_calories, 
    AVG(COALESCE(VeryActiveMinutes, 0)) AS avg_very_active_minutes, 
    AVG(COALESCE(FairlyActiveMinutes, 0)) AS avg_fairly_active_minutes, 
    AVG(COALESCE(LightlyActiveMinutes, 0)) AS avg_lightly_active_minutes,
    AVG(COALESCE(TotalActiveMinutes, 0)) AS avg_total_active_minutes
FROM daily_activity
GROUP BY fitbitactivity, DayName
ORDER BY fitbitactivity, avg_calories DESC;


-- Sendentary Min VS Total Active Minutes and by the day
-- Note: Monday on AVG is the highest for sedentary minutes, while Saturday is the highest for Active Min
SELECT DayName, AVG(SedentaryMinutes) AS AVG_SedentaryMinutes, AVG(TotalActiveMinutes) AS AVG_TotalActiveMinutes
FROM daily_activity
GROUP BY DayName
ORDER BY AVG_TotalActiveMinutes DESC;

-- CHANGED ^ 

SELECT 
    DayName,
    COUNT(*) AS total_records,
    ROUND(AVG(COALESCE(SedentaryMinutes, 0)), 2) AS avg_sedentary_minutes, 
    ROUND(AVG(COALESCE(TotalActiveMinutes, 0)), 2) AS avg_total_active_minutes,
    ROUND(AVG(COALESCE(TotalActiveMinutes, 0)) / AVG(COALESCE(SedentaryMinutes, 0)), 3) AS active_to_sedentary_ratio
FROM 
    daily_activity
GROUP BY 
    DayName
ORDER BY 
    active_to_sedentary_ratio DESC;



### Sleep Day ###
SELECT AVG(TotalMinutesAsleep), MIN(TotalMinutesAsleep)
FROM cleaned_sleepday;


#### Hourly Steps ####
SELECT * FROM hourly_steps; #33 distint IDs
-- MAX, MIN, AVG FOR hourly_steps
SELECT Id, COUNT(*) AS Total_Entries,
AVG(StepTotal), MIN(StepTotal), MAX(StepTotal), STDDEV(StepTotal)
FROM hourly_steps
GROUP BY Id; 

-- Summary Statistics of Hourly Steps
SELECT AVG(StepTotal), MIN(StepTotal), MAX(StepTotal), STDDEV(StepTotal)
FROM hourly_steps;

-- Shows us the time of day where most active steps for people
SELECT HOUR(ActivityHour), COUNT(*), SUM(StepTotal)
FROM hourly_steps
GROUP BY HOUR(ActivityHour)
ORDER BY SUM(StepTotal) DESC;

-- CHANGED ^
SELECT 
    HOUR(ActivityHour) AS HourOfDay, 
    COUNT(*) AS TotalRecords, 
    SUM(StepTotal) AS TotalSteps,
    AVG(StepTotal) AS AVGSteps
FROM 
    hourly_steps
GROUP BY 
    HOUR(ActivityHour)
ORDER BY 
    TotalSteps DESC;


-- Hourly Actice Hours
-- Note: On average 6PM is the time where the most steps are taken
SELECT HOUR(ActivityHour), SUM(StepTotal) AS SUM_STEP_TOTAL, ROUND(AVG(StepTotal),2) AS AVG_STEP_TOTAL
FROM hourly_steps
GROUP BY HOUR(ActivityHour)
ORDER BY AVG_STEP_TOTAL DESC;

-- Daily Average Steps
-- Note: Saturday on average is the most in terms of step total for users
SELECT DayName, ROUND(AVG(StepTotal),2) AS AVG_STEP_TOTAL
FROM hourly_steps
GROUP BY DayName
ORDER BY AVG_STEP_TOTAL DESC;


#### Hourly Calories ####
SELECT * FROM hourly_calories; #33 distint IDs
-- MAX, MIN, AVG FOR hourly_calories
SELECT Id, COUNT(*) AS Total_Entries,
AVG(Calories), MIN(Calories), MAX(Calories), STDDEV(Calories)
FROM hourly_calories
GROUP BY Id; 

-- Summary Statistics of Hourly Calories
SELECT AVG(Calories), MIN(Calories), MAX(Calories), STDDEV(Calories)
FROM hourly_calories;

-- Hourly AVG Calories
-- Note: On average 6PM is the time that most calories are burned
SELECT HOUR(ActivityHour), ROUND(AVG(Calories),2) AS AVG_Calories
FROM hourly_calories
GROUP BY HOUR(ActivityHour)
ORDER BY AVG_Calories DESC;

-- CHANGED ^
SELECT 
    HOUR(ActivityHour) AS HourOfDay, 
    ROUND(AVG(COALESCE(Calories, 0)), 2) AS AvgCalories
FROM 
    hourly_calories
GROUP BY 
    HOUR(ActivityHour)
ORDER BY 
    AvgCalories DESC;

-- Daily Calories Burned
-- Note: Saturday on AVG is the day where most calories are burned followed by Tuesday, Friday, Monday, Thursday, Wed, Sunday
SELECT DAYNAME(ActivityHour), ROUND(AVG(Calories),2) AS AVG_Calories
FROM hourly_calories
GROUP BY DAYNAME(ActivityHour)
ORDER BY AVG_Calories DESC;

-- CHANGED ^
SELECT 
    DAYNAME(ActivityHour) AS DayOfWeek, 
    ROUND(AVG(Calories), 2) AS AvgCalories
FROM 
    hourly_calories
GROUP BY 
    DAYOFWEEK(ActivityHour), DAYNAME(ActivityHour)
ORDER BY 
    DAYOFWEEK(ActivityHour);


