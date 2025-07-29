-- Dotaz 1: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
SELECT
    ib.name AS odvetvi,
    MIN(p.payroll_year) AS prvni_rok,
    MAX(p.payroll_year) AS posledni_rok,
    MIN(p.value) FILTER (WHERE vt.name='Průměrná hrubá mzda na zaměstnance' AND u.name='Kč' AND calc.name='fyzický') AS mzda_prvni_rok,
    MAX(p.value) FILTER (WHERE vt.name='Průměrná hrubá mzda na zaměstnance' AND u.name='Kč' AND calc.name='fyzický') AS mzda_posledni_rok,
    ROUND(
        (MAX(p.value) - MIN(p.value)) * 100.0 / MIN(p.value), 2
    ) AS rust_v_procentech
FROM czechia_payroll p
JOIN czechia_payroll_industry_branch ib ON p.industry_branch_code = ib.code
JOIN czechia_payroll_value_type vt ON p.value_type_code = vt.code
JOIN czechia_payroll_calculation calc ON p.calculation_code = calc.code
JOIN czechia_payroll_unit u ON p.unit_code = u.code
WHERE vt.name='Průměrná hrubá mzda na zaměstnance' AND calc.name='fyzický' AND u.name='Kč'
GROUP BY ib.name
ORDER BY rust_v_procentech ASC;


-- Dotaz 2: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
WITH base AS (
    SELECT
        rok,
        prumerna_mzda,
        kategorie AS potravina,
        cena,
        jednotka
    FROM t_karel_nechvatal_project_sql_primary_final
    WHERE kategorie IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
),
hranice AS (
    SELECT MIN(rok) AS prvni_rok, MAX(rok) AS posledni_rok FROM base
)
SELECT
    b.rok,
    b.potravina,
    b.prumerna_mzda,
    b.cena,
    ROUND((b.prumerna_mzda / b.cena)::numeric, 2) AS kolik_jednotek_si_koupim,
    CASE
        WHEN b.jednotka = 'l' THEN 'litrů'
        WHEN b.jednotka = 'kg' THEN 'kilogramů'
        ELSE b.jednotka
    END AS jednotka_popis
FROM base b
JOIN hranice h ON b.rok IN (h.prvni_rok, h.posledni_rok)
ORDER BY b.potravina, b.rok;



-- Dotaz 3: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
WITH mezirocni_rust AS (
    SELECT
        c1.kategorie,
        c1.rok,
        c2.rok AS dalsi_rok,
        ((c2.cena - c1.cena) * 100.0 / c1.cena)::numeric(10,2) AS rust_pct
    FROM t_karel_nechvatal_project_sql_primary_final c1
    JOIN t_karel_nechvatal_project_sql_primary_final c2
      ON c1.kategorie = c2.kategorie
     AND c2.rok = c1.rok + 1
),
prumerne_rusty AS (
    SELECT
        kategorie,
        AVG(rust_pct) AS prumer_rocni_rust
    FROM mezirocni_rust
    GROUP BY kategorie
)
SELECT
    kategorie,
    prumer_rocni_rust
FROM prumerne_rusty
ORDER BY prumer_rocni_rust ASC
LIMIT 1;



-- Dotaz 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
WITH mzdy AS (
    SELECT
        payroll_year AS rok,
        AVG(value) AS prumerna_mzda
    FROM czechia_payroll p
    JOIN czechia_payroll_value_type vt ON p.value_type_code = vt.code 
        AND vt.name = 'Průměrná hrubá mzda na zaměstnance'
    JOIN czechia_payroll_calculation calc ON p.calculation_code = calc.code 
        AND calc.name = 'fyzický'
    JOIN czechia_payroll_unit u ON p.unit_code = u.code 
        AND u.name = 'Kč'
    GROUP BY payroll_year
),
mzdy_rust AS (
    SELECT
        rok,
        ROUND( ((prumerna_mzda - LAG(prumerna_mzda) OVER (ORDER BY rok)) * 100.0 / LAG(prumerna_mzda) OVER (ORDER BY rok))::numeric, 2) AS mzdy_rust_pct
    FROM mzdy
),
ceny AS (
    SELECT
        rok,
        AVG(cena) AS prumerna_cena
    FROM t_karel_nechvatal_project_sql_primary_final
    GROUP BY rok
),
ceny_rust AS (
    SELECT
        rok,
        ROUND( ((prumerna_cena - LAG(prumerna_cena) OVER (ORDER BY rok)) * 100.0 / LAG(prumerna_cena) OVER (ORDER BY rok))::numeric, 2) AS ceny_rust_pct
    FROM ceny
),
rozdily AS (
    SELECT
        m.rok,
        m.mzdy_rust_pct,
        c.ceny_rust_pct,
        (c.ceny_rust_pct - m.mzdy_rust_pct) AS rozdil_pct_bodu
    FROM mzdy_rust m
    JOIN ceny_rust c USING (rok)
)
SELECT
    rok,
    mzdy_rust_pct AS "Růst mezd [%]",
    ceny_rust_pct AS "Růst cen potravin [%]",
    rozdil_pct_bodu AS "Rozdíl mezi růstem cen a mezd [% bodů]",
    CASE 
        WHEN rozdil_pct_bodu > 10 THEN 'Ano, výrazný nárůst cen nad mzdy' 
        ELSE 'Ne' 
    END AS "Výrazný nárůst cen nad mzdy?"
FROM rozdily
ORDER BY rok;



-- Dotaz 5: Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
WITH
mzdy AS (
    SELECT 
        payroll_year AS rok, 
        AVG(value) AS prumerna_mzda
    FROM czechia_payroll p
    JOIN czechia_payroll_value_type vt ON p.value_type_code = vt.code AND vt.name = 'Průměrná hrubá mzda na zaměstnance'
    JOIN czechia_payroll_calculation calc ON p.calculation_code = calc.code AND calc.name = 'fyzický'
    JOIN czechia_payroll_unit u ON p.unit_code = u.code AND u.name = 'Kč'
    GROUP BY payroll_year
),
ceny AS (
    SELECT 
        rok, 
        AVG(cena) AS prumerna_cena
    FROM t_karel_nechvatal_project_sql_primary_final
    GROUP BY rok
),
hdeps AS (
    SELECT 
        year AS rok, 
        gdp
    FROM t_karel_nechvatal_project_sql_secondary_final
    WHERE country IN ('Czechia','Czech Republic')
),
data AS (
    SELECT
        h.rok,
        h.gdp,
        m.prumerna_mzda,
        c.prumerna_cena
    FROM hdeps h
    LEFT JOIN mzdy m ON m.rok = h.rok
    LEFT JOIN ceny c ON c.rok = h.rok
),
changes AS (
    SELECT
        rok,
        gdp,
        prumerna_mzda,
        prumerna_cena,
        ROUND( ((gdp - LAG(gdp) OVER (ORDER BY rok)) * 100.0 / NULLIF(LAG(gdp) OVER (ORDER BY rok),0))::numeric, 2) AS gdp_change_pct,
        ROUND( ((prumerna_mzda - LAG(prumerna_mzda) OVER (ORDER BY rok)) * 100.0 / NULLIF(LAG(prumerna_mzda) OVER (ORDER BY rok),0))::numeric, 2) AS mzdy_change_pct,
        ROUND( ((prumerna_cena - LAG(prumerna_cena) OVER (ORDER BY rok)) * 100.0 / NULLIF(LAG(prumerna_cena) OVER (ORDER BY rok),0))::numeric, 2) AS ceny_change_pct
    FROM data
),
lagged AS (
    SELECT
        rok,
        gdp_change_pct,
        mzdy_change_pct,
        ceny_change_pct,
        LEAD(mzdy_change_pct) OVER (ORDER BY rok) AS mzdy_change_pct_next_year,
        LEAD(ceny_change_pct) OVER (ORDER BY rok) AS ceny_change_pct_next_year
    FROM changes
)
SELECT *
FROM lagged
WHERE rok BETWEEN 2006 AND 2018
ORDER BY rok;
