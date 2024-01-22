/* Data cleaning */

select*from [dbo].[CovidDeaths$];
	alter table [dbo].[CovidDeaths$] drop column new_cases_smoothed;
	alter table [dbo].[CovidDeaths$] drop column new_deaths_smoothed,new_cases_smoothed_per_million,new_deaths_smoothed_per_million;
	alter table [dbo].[CovidDeaths$] drop column new_tests_smoothed;
	alter table [dbo].[CovidDeaths$] drop column new_tests_smoothed_per_thousand,new_vaccinations_smoothed,new_vaccinations_smoothed_per_million;

/* Dropping Null values */

delete from [CovidDeaths$] where total_deaths IS NULL;
DELETE FROM [CovidDeaths$]
WHERE reproduction_rate is null
		AND icu_patients_per_million is null
		AND hosp_patients_per_million is null
		AND weekly_icu_admissions_per_million is null
		AND weekly_hosp_admissions_per_million IS null
		AND extreme_poverty IS null;

alter table [CovidDeaths$] drop column people_vaccinated_per_hundred;
alter table [CovidDeaths$] drop column extreme_poverty;
alter table [CovidDeaths$] drop column weekly_hosp_admissions_per_million;
alter table [CovidDeaths$] drop column tests_units;
alter table [CovidDeaths$] drop column handwashing_facilities;

DELETE FROM [CovidDeaths$]
		WHERE icu_patients is null
		and icu_patients_per_million is null
		and hosp_patients is null
		and hosp_patients_per_million is null
		and weekly_icu_admissions is null
		and weekly_icu_admissions_per_million is null
		and weekly_hosp_admissions is null;

select reproduction_rate from CovidDeaths$;

/*Formatting reproduction rate column type for better analysis */

ALTER TABLE CovidDeaths$
ALTER COLUMN reproduction_rate DECIMAL(5,2);

/*replacing null values with mean values in reproduction_rate column to balance the dataset */

DECLARE @meanValue FLOAT;
SELECT @meanValue = AVG(reproduction_rate)
FROM CovidDeaths$
WHERE reproduction_rate IS NOT NULL;

UPDATE CovidDeaths$
SET reproduction_rate = @meanValue
WHERE reproduction_rate IS NULL;

/* Formatting icu_patients column type for better analysis */

SELECT MAX(icu_patients) AS highest_value
FROM CovidDeaths$;

ALTER TABLE CovidDeaths$
ALTER COLUMN icu_patients INT;

/*replacing null values with mean values in icu_patients column to balance the dataset */

DECLARE @meanValueICU FLOAT
SELECT @meanValueICU = AVG(icu_patients)
FROM CovidDeaths$
WHERE icu_patients IS NOT NULL;

UPDATE CovidDeaths$
SET icu_patients = @meanValueICU
WHERE icu_patients IS NULL;


/*changing column types of multiple columns */

ALTER TABLE CovidDeaths$
ALTER COLUMN icu_patients_per_million DECIMAL(7, 3);

ALTER TABLE CovidDeaths$
ALTER COLUMN hosp_patients INT;

ALTER TABLE CovidDeaths$
ALTER COLUMN hosp_patients_per_million DECIMAL(8,3);


DECLARE @meanValue1 FLOAT, @meanValue2 FLOAT, @meanValue3 FLOAT;

SELECT 
    @meanValue1 = AVG(icu_patients_per_million),
    @meanValue2 = AVG(hosp_patients),
    @meanValue3 = AVG(hosp_patients_per_million)

FROM CovidDeaths$
WHERE icu_patients_per_million IS NOT NULL AND hosp_patients IS NOT NULL AND hosp_patients_per_million IS NOT NULL;


UPDATE CovidDeaths$
SET 
    icu_patients_per_million = ISNULL(icu_patients_per_million, @meanValue1),
    hosp_patients = ISNULL(hosp_patients, @meanValue2),
    hosp_patients_per_million = ISNULL(hosp_patients_per_million, @meanValue3)

WHERE 
    icu_patients_per_million IS NULL OR hosp_patients IS NULL OR hosp_patients_per_million IS NULL;

ALTER TABLE CovidDeaths$
ALTER COLUMN weekly_icu_admissions DECIMAL(7,3);

ALTER TABLE CovidDeaths$
ALTER COLUMN weekly_icu_admissions_per_million DECIMAL(7,3);

ALTER TABLE CovidDeaths$
ALTER COLUMN weekly_hosp_admissions DECIMAL(9,3);

DECLARE @meanValue4 FLOAT,@meanValue5 FLOAT, @meanValue6 FLOAT;
SELECT 
	@meanValue4 = AVG(weekly_icu_admissions),
	@meanValue5 =AVG(weekly_icu_admissions_per_million),
	@meanValue6 =AVG(weekly_hosp_admissions)

FROM CovidDeaths$ 
WHERE weekly_icu_admissions IS NOT NULL AND weekly_icu_admissions_per_million IS NOT NULL AND weekly_hosp_admissions IS NOT NULL;

UPDATE CovidDeaths$
SET 
	weekly_icu_admissions =ISNULL(weekly_icu_admissions,@meanValue4),
	weekly_icu_admissions_per_million =ISNULL(weekly_icu_admissions_per_million,@meanValue5),
	weekly_hosp_admissions =ISNULL(weekly_hosp_admissions,@meanValue6)
WHERE weekly_icu_admissions IS NULL OR weekly_icu_admissions_per_million IS NULL OR weekly_hosp_admissions IS NULL;

ALTER TABLE CovidDeaths$
ALTER COLUMN new_tests BIGINT;

ALTER TABLE CovidDeaths$
ALTER COLUMN total_tests BIGINT;

ALTER TABLE CovidDeaths$
ALTER COLUMN total_tests_per_thousand DECIMAL(10,4);

ALTER TABLE CovidDeaths$
ALTER COLUMN new_tests_per_thousand DECIMAL(6,3);

ALTER TABLE CovidDeaths$
ALTER COLUMN positive_rate DECIMAL(5,3);

ALTER TABLE CovidDeaths$
ALTER COLUMN tests_per_case DECIMAL(7,1);

ALTER TABLE CovidDeaths$
ALTER COLUMN total_vaccinations INT;

ALTER TABLE CovidDeaths$
ALTER COLUMN people_vaccinated INT;

ALTER TABLE CovidDeaths$
ALTER COLUMN people_fully_vaccinated INT;

ALTER TABLE CovidDeaths$
ALTER COLUMN new_vaccinations INT;

ALTER TABLE CovidDeaths$
ALTER COLUMN total_vaccinations_per_hundred DECIMAL(6,3);

ALTER TABLE CovidDeaths$
ALTER COLUMN people_fully_vaccinated_per_hundred DECIMAL(5,2);

--DECLARE @meanvalue7 FLOAT,
--		@meanvalue8 FLOAT,
--		@meanvalue9 FLOAT,
--		@meanvalue10 FLOAT,
--		@meanvalue11 FLOAT,
--		@meanvalue12 FLOAT,
--		@meanvalue13 FLOAT,
--		@meanvalue14 FLOAT,
--		@meanvalue15 FLOAT,
--		@meanvalue16 FLOAT,
--		@meanvalue17 FLOAT,
--		@meanvalue18 FLOAT;

--SELECT  
--    @meanvalue7 = AVG(COALESCE(CAST(new_tests AS FLOAT), 0)),
--    @meanvalue8 = AVG(COALESCE(CAST(total_tests AS FLOAT), 0)),
--    @meanvalue9 = AVG(COALESCE(CAST(total_tests_per_thousand AS FLOAT), 0)),
--    @meanvalue10 = AVG(COALESCE(CAST(new_tests_per_thousand AS FLOAT), 0)),
--    @meanvalue11 = AVG(COALESCE(CAST(positive_rate AS FLOAT), 0)),
--    @meanvalue12 = AVG(COALESCE(CAST(tests_per_case AS FLOAT), 0)),
--    @meanvalue13 = AVG(COALESCE(CAST(total_vaccinations AS FLOAT), 0)),
--    @meanvalue14 = AVG(COALESCE(CAST(people_vaccinated AS FLOAT), 0)),
--    @meanvalue15 = AVG(COALESCE(CAST(people_fully_vaccinated AS FLOAT), 0)),
--    @meanvalue16 = AVG(COALESCE(CAST(new_vaccinations AS FLOAT), 0)),
--    @meanvalue17 = AVG(COALESCE(CAST(total_vaccinations_per_hundred AS FLOAT), 0)),
--    @meanvalue18 = AVG(COALESCE(CAST(people_fully_vaccinated_per_hundred AS FLOAT), 0))
--FROM CovidDeaths$;

--UPDATE CovidDeaths$
--SET
--	new_tests=ISNULL(new_tests,@meanvalue7),
--	total_tests=ISNULL(total_tests,@meanvalue8),
--	total_tests_per_thousand=ISNULL(total_tests_per_thousand,@meanvalue9),
--	new_tests_per_thousand=ISNULL(new_tests_per_thousand,@meanvalue10),
--	positive_rate=ISNULL(positive_rate,@meanvalue11),
--	tests_per_case=ISNULL(tests_per_case,@meanvalue12),
--	total_vaccinations=ISNULL(total_vaccinations,@meanvalue13),
--	people_vaccinated=ISNULL(people_vaccinated,@meanvalue14),
--	people_fully_vaccinated=ISNULL(people_fully_vaccinated,@meanvalue15),
--	new_vaccinations=ISNULL(new_vaccinations,@meanvalue16),
--	total_vaccinations_per_hundred=ISNULL(total_vaccinations_per_hundred,@meanvalue17),
--	people_fully_vaccinated_per_hundred=ISNULL(people_fully_vaccinated_per_hundred,@meanvalue18)
--WHERE 
--	new_tests IS NULL OR 
--	total_tests IS NULL OR 
--	total_tests_per_thousand IS NULL OR 
--	new_tests_per_thousand IS NULL OR
--	positive_rate IS NULL OR
--	tests_per_case IS NULL OR
--	total_vaccinations IS NULL OR
--	people_vaccinated IS NULL OR
--	people_fully_vaccinated IS NULL OR
--	new_vaccinations IS NULL OR
--	total_vaccinations_per_hundred IS NULL OR
--	people_fully_vaccinated_per_hundred IS NULL;

--upper queries did't work so new way to get it done by using a temporary table

-- Creating a temporary table to store mean values
CREATE TABLE #MeanValues (
    MeanValue7 FLOAT,
    MeanValue8 FLOAT,
    MeanValue9 FLOAT,
    MeanValue10 FLOAT,
    MeanValue11 FLOAT,
    MeanValue12 FLOAT,
    MeanValue13 FLOAT,
    MeanValue14 FLOAT,
    MeanValue15 FLOAT,
    MeanValue16 FLOAT,
    MeanValue17 FLOAT,
    MeanValue18 FLOAT
);

-- Calculating mean values and inserting into the temporary table
INSERT INTO #MeanValues
SELECT
    AVG(COALESCE(CAST(new_tests AS FLOAT), 0)),
    AVG(COALESCE(CAST(total_tests AS FLOAT), 0)),
    AVG(COALESCE(CAST(total_tests_per_thousand AS FLOAT), 0)),
    AVG(COALESCE(CAST(new_tests_per_thousand AS FLOAT), 0)),
    AVG(COALESCE(CAST(positive_rate AS FLOAT), 0)),
    AVG(COALESCE(CAST(tests_per_case AS FLOAT), 0)),
    AVG(COALESCE(CAST(total_vaccinations AS FLOAT), 0)),
    AVG(COALESCE(CAST(people_vaccinated AS FLOAT), 0)),
    AVG(COALESCE(CAST(people_fully_vaccinated AS FLOAT), 0)),
    AVG(COALESCE(CAST(new_vaccinations AS FLOAT), 0)),
    AVG(COALESCE(CAST(total_vaccinations_per_hundred AS FLOAT), 0)),
    AVG(COALESCE(CAST(people_fully_vaccinated_per_hundred AS FLOAT), 0))
FROM CovidDeaths$;

-- Updating the original table using the mean values from the temporary table
UPDATE C
SET
    new_tests = ISNULL(new_tests, M.MeanValue7),
    total_tests = ISNULL(total_tests, M.MeanValue8),
    total_tests_per_thousand = ISNULL(total_tests_per_thousand, M.MeanValue9),
    new_tests_per_thousand = ISNULL(new_tests_per_thousand, M.MeanValue10),
    positive_rate = ISNULL(positive_rate, M.MeanValue11),
    tests_per_case = ISNULL(tests_per_case, M.MeanValue12),
    total_vaccinations = ISNULL(total_vaccinations, M.MeanValue13),
    people_vaccinated = ISNULL(people_vaccinated, M.MeanValue14),
    people_fully_vaccinated = ISNULL(people_fully_vaccinated, M.MeanValue15),
    new_vaccinations = ISNULL(new_vaccinations, M.MeanValue16),
    total_vaccinations_per_hundred = ISNULL(total_vaccinations_per_hundred, M.MeanValue17),
    people_fully_vaccinated_per_hundred = ISNULL(people_fully_vaccinated_per_hundred, M.MeanValue18)

FROM CovidDeaths$ C
CROSS JOIN #MeanValues M
WHERE
    C.new_tests IS NULL OR 
    C.total_tests IS NULL OR 
    C.total_tests_per_thousand IS NULL OR 
    C.new_tests_per_thousand IS NULL OR
    C.positive_rate IS NULL OR
    C.tests_per_case IS NULL OR
    C.total_vaccinations IS NULL OR
    C.people_vaccinated IS NULL OR
    C.people_fully_vaccinated IS NULL OR
    C.new_vaccinations IS NULL OR
    C.total_vaccinations_per_hundred IS NULL OR
    C.people_fully_vaccinated_per_hundred IS NULL;

-- Drop the temporary table
DROP TABLE #MeanValues;
