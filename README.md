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

```SQL
-- Check dailyActivity_merged rows and columns.
SELECT *
FROM dailyActivity_merged

-- Check dailyActivity_merged data types.
DESCRIBE dailyActivity_merged

-- Check dailyActivity_merged amount of data entries we have.
SELECT COUNT(*) AS total_rows FROM dailyActivity_merged;;

SELECT *
FROM sleepDay_merged

DESCRIBE sleepDay_merged

SELECT COUNT(*) AS total_rows FROM sleepDay_merged;

SELECT *
FROM hourlySteps_merged

DESCRIBE hourlySteps_merged

SELECT COUNT(*) AS total_rows FROM hourlySteps_merged;

SELECT *
FROM hourlyCalories

DESCRIBE hourlyCalories

SELECT COUNT(*) AS total_rows FROM hourlyCalories;
```
### 3.2: Data Cleaning
```SQL
-- Change table name from dailyActivity_merged to daily_activity
ALTER TABLE dailyActivity_merged RENAME TO daily_activity;

-- Check if there are any NULL values in daily_activity
-- NOTE: NO NULL values because returned 0 rows
SELECT *
FROM daily_activity
WHERE COALESCE(Id, ActivityDate, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance, 
		VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance, 
		VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories) IS NULL;

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
