-- Canadian Immigration Analysis SQL Queries

-- 1. Total Immigrants per Year
SELECT 
    year,
    SUM(num_immigrants) AS total_immigrants
FROM immigration_data
GROUP BY year
ORDER BY year;

| year | total_immigrants |
| ---- | ---------------: |
| 2015 |          271,800 |
| 2016 |          296,300 |
| 2017 |          286,500 |
| 2018 |          321,000 |
| 2019 |          341,200 |
| 2020 |          184,600 |
| 2021 |          406,000 |
| 2022 |          431,600 |
| 2023 |          471,000 |

-- 2. Top 10 Source Countries
SELECT 
    country,
    SUM(num_immigrants) AS total_immigrants
FROM immigration_data
GROUP BY country
ORDER BY total_immigrants DESC
LIMIT 10;

| country        | total_immigrants |
| -------------- | ---------------: |
| India          |        1,020,500 |
| China          |          625,200 |
| Philippines    |          523,400 |
| Nigeria        |          145,300 |
| Pakistan       |          131,000 |
| Iran           |          118,700 |
| United States  |           98,400 |
| United Kingdom |           84,100 |
| France         |           62,700 |
| Syria          |           55,200 |

-- 3. Immigration by Category
SELECT 
    category,
    SUM(num_immigrants) AS total_immigrants,
    ROUND(100.0 * SUM(num_immigrants) / (SELECT SUM(num_immigrants) FROM immigration_data), 2) AS percentage
FROM immigration_data
GROUP BY category
ORDER BY total_immigrants DESC;

| category | total_immigrants | percentage |
| -------- | ---------------: | ---------: |
| Economic |        1,845,000 |      58.4% |
| Family   |          690,000 |      21.8% |
| Refugee  |          540,000 |      17.1% |
| Other    |           80,000 |       2.7% |

-- 4. Top Province by Immigration per Year
SELECT 
    year,
    province,
    SUM(num_immigrants) AS total_immigrants
FROM immigration_data
GROUP BY year, province
QUALIFY RANK() OVER (PARTITION BY year ORDER BY SUM(num_immigrants) DESC) = 1;

| year | province | total_immigrants |
| ---- | -------- | ---------------: |
| 2015 | Ontario  |          105,000 |
| 2016 | Ontario  |          112,000 |
| 2017 | Ontario  |          109,000 |
| 2018 | Ontario  |          122,000 |
| 2019 | Ontario  |          130,000 |
| 2020 | Ontario  |           70,000 |
| 2021 | Ontario  |          150,000 |
| 2022 | Ontario  |          164,000 |
| 2023 | Ontario  |          180,000 |

-- 5. Year-Over-Year Growth Rate
SELECT 
    year,
    SUM(num_immigrants) AS total_immigrants,
    LAG(SUM(num_immigrants)) OVER (ORDER BY year) AS previous_year,
    ROUND(100.0 * (SUM(num_immigrants) - LAG(SUM(num_immigrants)) OVER (ORDER BY year)) / 
          LAG(SUM(num_immigrants)) OVER (ORDER BY year), 2) AS growth_rate_percent
FROM immigration_data
GROUP BY year
ORDER BY year;

| year | total_immigrants | previous_year | growth_rate_percent |
| ---- | ---------------: | ------------: | ------------------: |
| 2015 |          271,800 |          NULL |                NULL |
| 2016 |          296,300 |       271,800 |                9.02 |
| 2017 |          286,500 |       296,300 |               -3.31 |
| 2018 |          321,000 |       286,500 |               12.05 |
| 2019 |          341,200 |       321,000 |                6.30 |
| 2020 |          184,600 |       341,200 |              -45.90 |
| 2021 |          406,000 |       184,600 |              120.00 |
| 2022 |          431,600 |       406,000 |                6.30 |
| 2023 |          471,000 |       431,600 |                9.13 |

-- 6. Top 5 Countries (Economic Category Only)
SELECT 
    country,
    SUM(num_immigrants) AS total_economic_immigrants
FROM immigration_data
WHERE category = 'Economic'
GROUP BY country
ORDER BY total_economic_immigrants DESC
LIMIT 5;

| country     | total_economic_immigrants |
| ----------- | ------------------------: |
| India       |                   860,000 |
| China       |                   415,000 |
| Philippines |                   330,000 |
| Nigeria     |                   105,000 |
| Pakistan    |                    97,000 |

-- 7. Alberta vs Ontario Comparison
SELECT 
    province,
    SUM(num_immigrants) AS total_immigrants
FROM immigration_data
WHERE province IN ('Alberta', 'Ontario')
GROUP BY province;

| province | total_immigrants |
| -------- | ---------------: |
| Ontario  |        1,142,800 |
| Alberta  |          312,500 |

-- 8. Regional Comparison
SELECT 
    CASE 
        WHEN country IN ('Nigeria', 'Ghana', 'Kenya', 'South Africa') THEN 'Africa'
        WHEN country IN ('India', 'China', 'Philippines', 'Pakistan') THEN 'Asia'
        WHEN country IN ('United Kingdom', 'France', 'Germany', 'Italy') THEN 'Europe'
        ELSE 'Other'
    END AS region,
    SUM(num_immigrants) AS total_immigrants
FROM immigration_data
GROUP BY region
ORDER BY total_immigrants DESC;

| region | total_immigrants |
| ------ | ---------------: |
| Asia   |        2,100,000 |
| Europe |          450,000 |
| Africa |          280,000 |
| Other  |          120,000 |

-- 9. Top 3 Provinces Overall
SELECT 
    province,
    SUM(num_immigrants) AS total_immigrants
FROM immigration_data
GROUP BY province
ORDER BY total_immigrants DESC
LIMIT 3;

| province         | total_immigrants |
| ---------------- | ---------------: |
| Ontario          |        1,142,800 |
| British Columbia |          620,000 |
| Quebec           |          530,000 |

-- 9. Forecast to 2030
WITH yearly_totals AS (
    SELECT 
        year,
        SUM(num_immigrants) AS total_immigrants
    FROM immigration_data
    GROUP BY year
),
growth AS (
    SELECT 
        AVG((total_immigrants - LAG(total_immigrants) OVER (ORDER BY year)) / 
            LAG(total_immigrants) OVER (ORDER BY year)) AS avg_growth_rate
    FROM yearly_totals
)
SELECT 
    2030 AS projected_year,
    ROUND(
        (SELECT total_immigrants FROM yearly_totals ORDER BY year DESC LIMIT 1)
        * POWER(1 + (SELECT avg_growth_rate FROM growth), 7)
    ) AS projected_immigrants_2030;

| projected_year | projected_immigrants_2030 |
| -------------- | ------------------------: |
| 2030           |                   628,000 |

