DROP TABLE IF EXISTS t_karel_nechvatal_project_sql_secondary_final;

CREATE TABLE t_karel_nechvatal_project_sql_secondary_final AS
SELECT
    e.country,
    e.year,
    e.gdp,
    e.gini,
    e.population
FROM economies e
JOIN countries c ON e.country = c.country
WHERE c.continent = 'Europe';
