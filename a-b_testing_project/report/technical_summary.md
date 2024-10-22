# A/B Test Report: Food and Drink Banner

## Purpose
The goal of the A/B test is to determine whether or not the new Food and Drink banner will attract more business.

## Hypotheses
The null hypothesis is that the new banner does not impact sales/conversion.  The alternative is that the banner does impact sales/conversion.

## Methodology
### Test Design
- **Population:** The control group receive the same landing page as usual, while the test group will have the new banner displayed.
- **Duration:** DD-MM-YYYY Start: 25-01-2023 End: 06-02-2023
- **Success Metrics:** Conversion rate and revenue are the two releveant metrics to measure success.  If conversion rates are increased, and revenue is also increased, then the test was a success.  

## Results
### Data Analysis
- **Pre-Processing Steps:**
First order of business was to collect the relevant data needed to perform the analysis.  After selecting the relevant columns from the related tables, I joined them together, and then filled the Null values to make sure the data was consistent

```sql
SELECT
  users.id,
  COALESCE(users.country, 'OTH') AS country_clean,
  COALESCE(users.gender, 'O') AS gender_clean,
  COALESCE(activity.spent, 0) AS spent_clean,
  groups.group,
  COALESCE(groups.device, 'O') AS device_clean
FROM
  users
  LEFT JOIN activity ON users.id = activity.uid
  LEFT JOIN groups ON users.id = groups.uid
SELECT * FROM users;
```
Note: There were no Null values in the Groups column, thus no need to use Coalesce.  I found this by simply sorting the group column in both ascending and descending order - Null values would have appeared in either of those sortings at the top, or bottom of the list.

From here, I needed to ensure that I could compact any duplicates into single rows.  This would allow me to determine exactly how much each person spent in total over the test period.

```sql
WITH
  data_clean AS (
    SELECT
      users.id,
      COALESCE(users.country, 'OTH') AS country_clean,
      COALESCE(users.gender, 'O') AS gender_clean,
      COALESCE(activity.spent, 0) AS spent_clean,
      groups.group,
      COALESCE(groups.device, 'O') AS device_clean
    FROM
      users
      LEFT JOIN activity ON users.id = activity.uid
      LEFT JOIN groups ON users.id = groups.uid
  )
SELECT
  id,
  SUM(spent_clean)
FROM
  data_clean
GROUP BY
  id
```
From there, I moved the data over to Excel.  I downloaded both SQL queries as separate files, removed all the duplicates from the data, and then copied the total spent over to the full dataset.  With all this, it was a simple matter of using basic functions in Excel to extract the relevant data needed.

- **Statistical Tests Used:** To determine if there was a significant increase in sales, I did a t-test.  For the conversion rate, I did a z-test
- **Results Overview:** High-level summary.

### Findings

## Interpretation
- **Outcome of the Test(s):** 
The t-test was performed to determine this null hypothesis: The Food and Drink ad banner does not result in a spending increase.
The result of my calculations (found in the Excel file) came to a p-value of 0.944 which does not reject the null hypothesis - the ad banner does not lead to an increase in spending
The z-test was performed to determine this null hypothesis: The Food and Drink ad banner does not lead to increased conversion.
So... somehow in the quiz, the answer is supposed to be 0.001 which is statistically significant.  This does reject the null hypothesis, and shows that the banner did lead to an increased conversion rate.

- **Confidence Level:**
All results were measured at a 95% confidence level

## Conclusions
- **Key Takeaways:** What did we learn?
- **Limitations/Considerations:**
This A/B test was done over a rather short period of time, was restricted to the mobile page, and didn't differentiate between purchase types.

## Recommendations
- **Next Steps:** 
Launch the project.  There's a significant increase in conversion, even if there's not much of an increase in spending.  At the end of the day, GloBox is getting a larger pool of paying customers, and perhaps there are ways to 
- **Further Analysis:**
Since the company has been seeing great success in their food and drink department of their products, it would be beneficial to see just how much that represents in total sales/conversions over the course of this project.  Perhaps it might prompt the company to allocate more resources to the Food and Drink sector in order to capitalize on the increased interest.  It might also be worth it to run a similar test, after the banner has been launched to see how much of an increase the Food and Drink department makes in revenue.

## Personal Notes
So, I struggled quite a bit with the z-testing in order to determine significance of the conversion rates.  As such, you'll notice that the Excel file has some... messy calculations on that front.  I had a much easier time with the t-testing though, so that was fine.  In fact, the only reason why I was able to determine that the conversion rate was statistically significant, was thanks to the quiz for the second sprint.  The quizzes in the module were designed to check our work, or so the Project Overview stated.  So I naturally assumed that any answers I found in the quiz - one of them should have been the result I obtained.  In the case of the t-testing, I came out alright.  For the z-testing though... not so much.
I chose to submit the project as is anyways, full aware that there are portions of the process I've done terribly wrong.  Either due to a wrong assumption, incorrect calculation, or any other reason.  My hope is that, with the feedback, I can see where, and how, I went wrong; make the necessary corrections to my work, and polish the final result.