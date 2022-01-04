WITH feature AS (
SELECT
  date
  , country_name
  , new_confirmed
  , COALESCE(
      cumulative_persons_fully_vaccinated
      , LAG(cumulative_persons_fully_vaccinated, 1) over (order by country_name, location_key, date)
      , LAG(cumulative_persons_fully_vaccinated, 2) over (order by country_name, location_key, date)
      , LAG(cumulative_persons_fully_vaccinated, 3) over (order by country_name, location_key, date)
      , LAG(cumulative_persons_fully_vaccinated, 4) over (order by country_name, location_key, date)
      , LAG(cumulative_persons_fully_vaccinated, 5) over (order by country_name, location_key, date)
      , LAG(cumulative_persons_fully_vaccinated, 6) over (order by country_name, location_key, date)
      , LAG(cumulative_persons_fully_vaccinated, 7) over (order by country_name, location_key, date)
      , 0
      ) AS cumulative_persons_fully_vaccinated
  -- , human_development_index
  -- , (population_age_00_09 + population_age_10_19 + population_age_20_29) AS young_age
  -- , (population_age_30_39 + population_age_40_49 + population_age_50_59) AS middle_age
  -- , (population_age_60_69 + population_age_70_79 + population_age_80_and_older) AS elder_age
  -- , (population_age_00_09 + population_age_10_19 + population_age_20_29 + population_age_30_39 + population_age_40_49 + population_age_50_59 + population_age_60_69 + population_age_70_79 + population_age_80_and_older) AS population
  , mobility_workplaces
  , mobility_residential
  -- , school_closing
  -- , workplace_closing
  -- , cancel_public_events
  -- , restrictions_on_gatherings
  -- , public_transport_closing
  -- , stay_at_home_requirements
  -- , international_travel_controls
  -- , income_support
  -- , debt_relief
  -- , public_information_campaigns
  -- , contact_tracing
  -- , vaccination_policy
  , average_temperature_celsius
  FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    (
      (country_name = "Japan" AND location_key = "JP")
        OR 
      (country_name = "South Korea" AND location_key = "KR")
        OR 
      (country_name = "Germany" AND location_key = "DE")
        OR 
      (country_name = "France" AND location_key = "FR")
        OR
      (country_name = "India" AND location_key = "IN")
        OR
      (country_name = "United Kingdom" AND location_key = "GB")
        OR
      (country_name = "South Africa" AND location_key = "ZA")
        OR
      (country_name = "Turkey" AND location_key = "TR")
        OR
      (country_name = "Chile" AND location_key = "CL")
        OR
      (country_name = "Colombia" AND location_key = "CO")
        OR
      (country_name = "United States of America" AND location_key = "US")
    )
    AND date >= '2020-03-21'
    AND date < '2021-11-01'
ORDER BY location_key, date
)
SELECT 
  *
FROM feature
WHERE date >= '2020-04-01' -- Delete '2020-03-21' ~ '2020-03-31' for invalid value in cumulative_persons_fully_vaccinated
  AND date < '2021-11-01'

-- Japan:        country_name = "Japan" AND location_key = "JP"
-- South Korea:  country_name = "South Korea" AND location_key = "KR"
-- Germany:      country_name = "Germany" AND location_key = "DE"
-- France:       country_name = "France" AND location_key = "FR"
-- India:        country_name = "India" AND location_key = "IN"
-- UK:           country_name = "United Kingdom" AND location_key = "GB"
-- South Africa: country_name = "South Africa" AND location_key = "ZA"
-- Turkey:       country_name = "Turkey" AND location_key = "TR"
-- Thailand:     country_name = "Thailand" AND location_key = "TH"
-- Chile:        country_name = "Chile" AND location_key = "CL"
-- Colombia:     country_name = "Colombia" AND location_key = "CO"
-- United States of America: country_name = "United States of America" AND location_key = "US"