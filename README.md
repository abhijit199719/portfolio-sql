Data Cleaning:

Columns containing smoothed data and irrelevant information were dropped to focus on essential metrics related to Covid deaths.
Null values in critical columns like total_deaths, reproduction_rate, and various patient-related metrics were removed to ensure data integrity.
Data Formatting:

Column types were adjusted to optimize storage and analysis, such as changing reproduction_rate to a decimal and converting patient counts to integers where appropriate.
Decimal precision was set for metrics like icu_patients_per_million and hosp_patients_per_million to maintain data accuracy.
Missing Value Imputation:

Null values in certain columns were replaced with mean values to balance the dataset and ensure continuity in analysis. This was particularly done for metrics like reproduction_rate, icu_patients, and others.
Conclusion:

The cleaned and formatted dataset provides a more reliable basis for analyzing Covid-related metrics, specifically focusing on deaths and associated factors.
With the data cleaned and formatted, further analysis can be conducted to derive insights into trends, patterns, and correlations between various Covid-related metrics.
The approach taken in the SQL script demonstrates a systematic way to preprocess and prepare data for analysis, ensuring data quality and consistency throughout the process.
Overall, the data cleaning and formatting steps performed in the SQL script lay a solid foundation for conducting meaningful analysis of Covid deaths and associated metrics, facilitating informed decision-making and understanding of the pandemic's impact.
