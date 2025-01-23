![](/assets/bellabeat_logo.png)
# Bellabeat Case Study

## 1: ASK

In the Ask phase, the objective is to clearly define the business problem and translate it into actionable questions. This involves understanding stakeholder goals, identifying success criteria, and outlining key deliverables while accounting for constraints such as time, resources, and data availability.

### 1.1: The Business Context

**Bellabeat Company**  
Bellabeat specializes in health-focused smart products for women. Its innovative offerings include devices such as the Leaf tracker, Time watch, Spring water bottle, and the Bellabeat app. These products deliver actionable health and wellness insights, empowering users to adopt healthier habits. Founded in 2013, Bellabeat has grown rapidly, employing both digital and traditional marketing strategies to engage its audience.

This case study will analyze usage data from Bellabeat's smart devices to uncover consumer behavior trends and generate actionable insights. The findings aim to enhance Bellabeat’s marketing strategies, expanding its footprint in the competitive global smart device market.

### 1.2: The Business Task

The goal is to analyze smart device usage data to:
- Identify trends and insights related to consumer habits.
- Provide recommendations for one of Bellabeat’s products, enabling the company to optimize its marketing strategies.
- Uncover growth opportunities and address competitive challenges in the smart device market.

### 1.3: Key Stakeholders

- Urška Sršen: Co-founder and Chief Creative Officer at Bellabeat.
- Sando Mur: Co-founder and mathematician, part of Bellabeat’s executive team.
- Bellabeat Marketing Analytics Team: Responsible for data collection, analysis, and reporting to inform Bellabeat's marketing strategies.

### 1.4: Guiding Questions

- What are the trends in smart device usage?
- How can these trends be applied to Bellabeat’s customers?
- How can these trends influence and shape Bellabeat's marketing strategy?

### 1.5: Deliverables for the Case Study

- **Business Task Summary**: A concise overview of the project goals.
- **Data Sources**: A description of all datasets used, including origins and limitations.
- **Data Cleaning and Preparation**: Documentation of preprocessing steps.
- **Analysis Summary**: Key findings and observations derived from the data.
- **Visualizations**: Charts or graphs to highlight trends and insights.
- **Recommendations**: High-level, actionable marketing strategies based on the analysis.

## 2: PREPARE

In the Prepare phase, we examine the data to assess its structure, credibility, and relevance for answering the business questions. This includes addressing potential limitations, verifying the data's integrity, and ensuring compliance with ethical and legal standards.

### 2.1: Data Source

**Primary Dataset:**
- **Name**: FitBit Fitness Tracker Data
- **Source**: Kaggle (CC0: Public Domain)
- **Description**: This dataset contains personal tracker data from 30 Fitbit users who provided consent for submission. It includes minute-level data on daily activity, daily sleep, hourly steps, hourly intensity, hourly calories, heart rate, and weight log, offering insights into users' habits. The dataset is stored in 18 separate CSV files.

### 2.2: Downloading The Data

In this case study, SQL will be the main tool for data analysis. The CSV files that will be used in this case study include:
- `dailyActivity_merged.csv`
- `sleepDay_merged.csv`
- `hourlySteps_merged.csv`
- `hourlyCalories_merged.csv`



### 2.3: Data Credibility and ROCCC Assessment

I will use ROCCC to assess whether this data has issues with bias or credibility.

- **Reliable**: No, the data is not reliable. The sample size consists of only 30 users out of over 20 million Fitbit users in 2016. Furthermore, the data was collected over just one month, which is insufficient to analyze long-term user pattern changes. Additionally, the dataset does not specify whether the 30 users were women, leaving us uncertain if the demographic aligns with Bellabeat's target consumers.
- **Original**: No, the data is not original. It was sourced through a secondary platform, Amazon Mechanical Turk.
- **Comprehensive**: No, the data is not comprehensive. Key participant details, such as age, gender, and height, are missing. Without this information, it is difficult to fully interpret the data, as these factors could significantly influence the results. Moreover, it is unclear how the 30 participants were selected—whether randomly or intentionally—which raises further questions about potential biases.
- **Current**: No, the data is not current. It was collected in 2016, which makes it eight years old and potentially outdated.
- **Cited**: Yes, the data is properly cited, with appropriate attribution to Mobius, ensuring transparency.

## 3: PROCESS
In the process phase, we ensure our data is clean by correcting or removing inaccurate, corrupted, improperly formatted, duplicate, or incomplete entries within the dataset.

### 3.1: Reviewing Our Data in SQL
- To understand our data, we will use SQL to gain an initial overview of the data types, variable names, and the volume of data available.


1. Check dailyActivity_merged.csv, sleepDay_merged.csv, hourlySteps_merged.csv, hourlyCalories_merged.csv rows and columns.
```SQL
SELECT *
FROM dailyActivity_merged

SELECT *
FROM sleepDay_merged

SELECT *
FROM hourlySteps_merged

SELECT *
FROM hourlyCalories
```
2. Check dailyActivity_merged.csv, sleepDay_merged.csv, hourlySteps_merged.csv, hourlyCalories_merged.csv data types.
```SQL
DESCRIBE dailyActivity_merged

DESCRIBE sleepDay_merged

DESCRIBE hourlySteps_merged

DESCRIBE hourlyCalories
```
3. Check dailyActivity_merged.csv, sleepDay_merged.csv, hourlySteps_merged.csv, hourlyCalories_merged.csv count of data entries.
```SQL
SELECT COUNT(*) AS total_rows FROM dailyActivity_merged;

SELECT COUNT(*) AS total_rows FROM sleepDay_merged;

SELECT COUNT(*) AS total_rows FROM hourlySteps_merged;

SELECT COUNT(*) AS total_rows FROM hourlyCalories;
```
### 3.2: Data Cleaning
##1. Update the names of all four tables to make them clearer and more understandable.
```SQL
ALTER TABLE dailyActivity_merged RENAME TO daily_activity;

ALTER TABLE sleepday_merged RENAME TO sleepday;

AlTER TABLE hourlysteps_merged RENAME TO hourly_steps;

ALTER TABLE hourlycalories_merged RENAME TO hourly_calories;
```

2. Check if there are any NULL values for any of the tables.
```SQL
SELECT *
FROM daily_activity
WHERE COALESCE(Id, ActivityDate, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance, 
		VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance, 
		VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories) IS NULL;
```
There are 0 NULL values for daily_activity because 0 rows were returned.

```SQL
SELECT *
FROM sleepday
WHERE COALESCE(Id,SleepDay,TotalSleepRecords,TotalMinutesAsleep,TotalTimeInBed) IS NULL;
```
There are 0 NULL values for sleepday because 0 rows were returned.
```SQL
SELECT *
FROM hourly_steps
WHERE COALESCE(Id,ActivityHour,StepTotal) IS NULL;
```
There are 0 NULL values for hourly_steps because 0 rows were returned.
```SQL
SELECT *
FROM hourly_calories
WHERE COALESCE(Id, ActivityHour, Calories) IS NULL;
```
There are 0 NULL values for hourly_calories because 0 rows were returned.

3. Checking for duplicates rows for any of the tables.
```SQL
SELECT Id, ActivityDate, TotalSteps
FROM daily_activity
GROUP BY Id, ActivityDate, TotalSteps
HAVING Count(*) > 1;
```
There are no duplicate rows for daily_activity because 0 rows were returned.
```SQL
SELECT ID, ActivityHour, StepTotal
FROM hourly_steps
GROUP BY ID, ActivityHour, StepTotal
HAVING COUNT(*) > 1;
```
There are no duplicate rows for hourly_steps because 0 rows were returned.
```SQL
SELECT Id, ActivityHour, Calories
FROM hourly_calories
GROUP BY Id, ActivityHour, Calories
HAVING COUNT(*) > 1;
```
There are no duplicate rows for hourly_calories because 0 rows were returned.

```SQL
SELECT Id,SleepDay,TotalSleepRecords
FROM sleepday
GROUP BY Id,SleepDay,TotalSleepRecords
HAVING COUNT(*) > 1;
```
There were 3 duplicate rows for sleepday, so we have to create a new table (cleaned_sleepday). We want to keep the original sleepday table intact. This allows us to retain the original data for reference, backup, or further analysis without risk of accidental data loss.
```SQL
CREATE TABLE cleaned_sleepday AS
SELECT DISTINCT *
FROM sleepday;
```
Our new table is called cleaned_sleepday but we will still have the original sleepday table.

4. Changing the data type of all tables from text to DATETIME enables us to join different tables more effectively and extract specific details, such as the date and time of day.
```SQL
UPDATE daily_activity SET ActivityDate = STR_TO_DATE(ActivityDate, '%c/%e/%Y');
-- Once the values are formatted correctly, update the column data type using ALTER TABLE for daily_activity
ALTER TABLE daily_activity MODIFY COLUMN ActivityDate DATETIME;

UPDATE cleaned_sleepday SET SleepDay = STR_TO_DATE(SleepDay, '%c/%e/%Y %r');
-- Once the values are formatted correctly, update the column data type using ALTER TABLE for cleaned_sleepday
ALTER TABLE cleaned_sleepday MODIFY COLUMN SleepDay DATETIME;

UPDATE hourly_steps SET ActivityHour = STR_TO_DATE(ActivityHour, '%m/%d/%Y %h:%i:%s %p');
-- Once the values are formatted correctly, update the column data type using ALTER TABLE for hourly_steps
ALTER TABLE hourly_steps MODIFY ActivityHour DATETIME;

UPDATE hourly_calories SET ActivityHour = STR_TO_DATE(ActivityHour,'%m/%d/%Y %h:%i:%s %p');
-- Once the values are formatted correctly, update the column data type using ALTER TABLE for hourly_calories
ALTER TABLE hourly_calories MODIFY ActivityHour DATETIME;
```

5. Creating new columns tailored to each specific table to enhance our data analysis.

5.1: Daily Activity

5.1.1: Create new columns TotalActiveMinutes and TotalActiveDistance
```SQL
ALTER TABLE daily_activity ADD COLUMN TotalActiveMinutes INT;
UPDATE daily_activity SET TotalActiveMinutes = VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes;

ALTER TABLE daily_activity ADD COLUMN TotalActiveMinutes INT;
UPDATE daily_activity SET TotalActiveMinutes = VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes;
```
5.1.2: Getting the day of the week name and adding it as a new column
```SQL
ALTER TABLE daily_activity ADD COLUMN DayName VARCHAR(9);
UPDATE daily_activity SET DayName = DAYNAME(ActivityDate);
```
5.1.3: Separate ID by Light, Moderate, and Very Active by the amount of daily activity
```SQL
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
```
5.1.4: Add a new column, fitbitactivity, to categorize users based on the frequency of their activity logs.
```SQL
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
```

5.2: Sleep Day

5.2.1: Addding new column MinutesAwakeInBed = TotalTimeInBed - TotalMinutesAsleep
```SQL
ALTER TABLE sleepday ADD COLUMN MinutesAwakeInBed INT;
UPDATE sleepday SET MinutesAwakeInBed = TotalTimeInBed - TotalMinutesAsleep;
```

5.2.2: Getting the day of the week name and then adding it to a new column
```SQL
SELECT DAYNAME(SleepDay) AS DAYNAME
FROM cleaned_sleepday;
ALTER TABLE cleaned_sleepday ADD COLUMN DayName VARCHAR(9);
UPDATE cleaned_sleepday SET DayName = DAYNAME(SleepDay);
```

5.2.3: Changing Columns To Hours From Minutes. Changing Data Type FROM INT to FLOAT before updating the columns to be in hours instead of minutes
```SQL
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

-- 3. Changing Column Names TO Hours Now
ALTER TABLE cleaned_sleepday RENAME COLUMN TotalMinutesAsleep TO TotalHourAsleep;
ALTER TABLE cleaned_sleepday RENAME COLUMN TotalTimeInBed TO TotalHourInBed;
ALTER TABLE cleaned_sleepday RENAME COLUMN MinutesAwakeInBed TO HoursAwakeInBed; 
```

5.3: Hourly Steps

5.3.1: Getting the day of the week name and saving it as a column
```SQL
SELECT DAYNAME(ActivityHour) AS DAYNAME
FROM hourly_steps;
ALTER TABLE hourly_steps ADD COLUMN DayName VARCHAR(9);
UPDATE hourly_steps SET DayName = DAYNAME(ActivityHour);
```

5.4: Hourly Calories

5.4.1: Getting the day of the week name and saving it as a column
```SQL
ALTER TABLE hourly_calories ADD COLUMN DayName VARCHAR(9);
UPDATE hourly_calories SET DayName = DAYNAME(ActivityHour);
```

## 4: ANALYZE

- **daily_activity**: #33 distinct IDs
  - ID, Activity Date, Calories
  - Day Name (i.e., Tuesday, Wednesday, Friday)
  - Fitbit Activity (i.e., Very Active User, Moderate User, Light User)
  - Total Steps, Total Distance, Total Active Minutes, Total Active Distance
  - Very Active Distance, Moderately Active Distance, Light Active Distance, Sedentary Active Distance
  - Very Active Minutes, Fairly Active Minutes, Lightly Active Minutes, Sedentary Active Minutes

- **cleaned_sleepday**: #24 distinct IDs
  - ID, Sleep Day
  - Total Sleep Records, Total Hours Asleep, Total Hours In Bed, Hours Awake In Bed, Day Name

- **hourly_steps**: #33 distinct IDs
  - ID, Activity Hour, Step Total, Day Name (i.e., Tuesday, Wednesday, Friday)

- **hourly_calories**: #33 distinct IDs
  - ID, Activity Hour, Calories
