DROP TABLE IF EXISTS t_karel_nechvatal_project_sql_primary_final;

CREATE TABLE t_karel_nechvatal_project_sql_primary_final AS
WITH mzdy AS (
    SELECT
        p.payroll_year AS rok,
        AVG(p.value) AS prumerna_mzda
    FROM czechia_payroll p
    JOIN czechia_payroll_value_type vt ON p.value_type_code = vt.code AND vt.name = 'Průměrná hrubá mzda na zaměstnance'
    JOIN czechia_payroll_calculation calc ON p.calculation_code = calc.code AND calc.name = 'fyzický'
    JOIN czechia_payroll_unit u ON p.unit_code = u.code AND u.name = 'Kč'
    GROUP BY p.payroll_year
),
ceny AS (
    SELECT
        EXTRACT(YEAR FROM pr.date_from)::int AS rok,
        pc.name AS kategorie,
        pc.price_unit AS jednotka,
        AVG(pr.value) AS cena
    FROM czechia_price pr
    JOIN czechia_price_category pc ON pr.category_code = pc.code
    GROUP BY 1,2,3
)
SELECT
    m.rok,
    m.prumerna_mzda,
    c.kategorie,
    c.jednotka,
    c.cena
FROM mzdy m
JOIN ceny c USING (rok);

