# Canadian Immigration Analysis (2010 - 2023)
This project analyzes yearly records of immigrants to Canada by country of origin, immigration category (economic, family, refugee, etc.), and province of landing.

**Data Source:** Government of Canada Open Data Portal (IRCC)

**Key Columns:**

  - Year
  - Country of Origin
  - Immigration Category (Economic, Family, Refugee, Other)
  - Province of Destination
  - Number of Immigrants

**Objective:**

Analyze immigration trends to Canada over time, including source countries, categories, and settlement provinces.

**Tools & Technologies**

SQL (PostgreSQL) for quering data and PowerBI for data visualization


**Key Insights**

  - Immigration has grown steadily over the last decade, with major increases after 2016.
  - India, China, and the Philippines consistently rank among the top 3 source countries.
  - The Economic category dominates, but Family sponsorship has also grown.
  - Ontario receives the majority of immigrants, followed by British Columbia and Alberta.

**SQL Analysis**
SQL Analysis (Queries go into [sql_queries.sql](./sql_queries.sql))

Examples of queries include:
  - Total immigrants to Canada each year (trend analysis).
  - Top 10 source countries of immigrants (2010–2023).
  - Breakdown by immigration category (Economic vs. Family vs. Refugee).
  - Which province received the highest number of immigrants yearly.
  - Percentage change in immigration year-over-year.
  - Top 5 countries sending Economic immigrants vs. Family immigrants.
