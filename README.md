# Projekt: Analýza dostupnosti potravin v ČR vzhledem k průměrným mzdám a HDP

## Úvod
Cílem tohoto projektu je odpovědět na několik klíčových otázek týkajících se vývoje dostupnosti základních potravin v České republice v kontextu průměrných příjmů obyvatel a ekonomického vývoje (HDP). Výstupy poslouží k podpoře tiskového oddělení při přípravě materiálů na konferenci o životní úrovni.

---

## Použité datové zdroje
- **czechia_payroll** a související číselníky — data o průměrných mzdách podle odvětví a let
- **czechia_price** a související kategorie — ceny vybraných potravin podle let a kategorií
- **economies** a **countries** — doplňková data o HDP, GINI koeficientu a populaci evropských zemí

---

## Přehled vytvořených tabulek
- `t_karel_nechvatal_project_sql_primary_final`  
  Tabulka spojující průměrné mzdy a ceny potravin pro ČR podle roku a kategorií.
- `t_karel_nechvatal_project_sql_secondary_final`  
  Tabulka s daty o HDP, GINI koeficientu a populaci evropských zemí pro stejná období.

---

## Přiložené skripty  
- **`create_primary.sql`** – vytvoření primární tabulky s propojením mezd a cen potravin  
- **`create_secondary.sql`** – vytvoření sekundární tabulky s HDP, GINI a populací  
- **`queries_analysis.sql`** – dotazy k analýze a zodpovězení výzkumných otázek

---

## Výzkumné otázky a výsledky

### 1. Rostou mzdy ve všech odvětvích, nebo v některých klesají?  
Mzdy rostly ve většině odvětví za sledované období(2000-2021), přičemž nejnižší růst činil +166,22 %, což odpovídá nárůstu z 9 036 Kč na 24 056 Kč. V některých odvětvích byl růst výrazně vyšší (až přes 400 %).

### 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
V roce 2006 odpovídala kupní síla průměrné mzdy množství přibližně 1 257,18 kg chleba konzumního kmínového a 1 403,97 litrů polotučného mléka. V roce 2018 se toto množství zvýšilo na 1 317,37 kg chleba a 1 611,26 litrů mléka.
To znamená, že za průměrnou mzdu si lidé mohli koupit více těchto základních potravin než v roce 2006, což ukazuje, že růst mezd převyšoval růst cen těchto potravin.



### 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Nejpomaleji zdražující kategorií je: Cukr krystalový, s průměrným meziročním růstem ceny -1,92 %.
To znamená, že cena cukru v průměru každoročně klesala, zatímco ostatní sledované potraviny spíše zdražovaly.


### 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)? 
Na základě dostupných dat neexistuje rok, kdy by meziroční nárůst cen potravin překročil růst mezd o více než 10 procentních bodů.
Největší rozdíl mezi růstem cen a mezd byl 6,59 % bodu, tedy výrazný, ale nedosahuje hranice 10 %.
Naopak nejnižší rozdíl byl -9,66 % bodu, což znamená, že v některých letech mzdy rostly rychleji než ceny potravin.

### 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
Výsledky ukazují, že meziroční růst HDP má pouze omezený a nepravidelný vliv na změny mezd a cen potravin. Není jasná konzistentní vazba ani se změnami ve stejném roce, ani s ročním zpožděním. Mzdy a ceny potravin reagují na různé další ekonomické faktory, které nejsou v této analýze zachyceny. Pro potvrzení nebo vyvrácení hypotézy by bylo potřeba provést detailnější statistickou analýzu.

---

## Omezení a poznámky k datům
- Některé roky obsahují chybějící hodnoty (NULL), zejména v dřívějších obdobích, což může ovlivnit výstupy analýzy.
- Data o HDP jsou dostupná od roku 1990, mzdy a ceny potravin mají různou časovou dostupnost.
- U cen potravin se jedná o průměry několika kategorií, proto může být vhodné rozšířit analýzu o detailnější pohledy na jednotlivé potravinové skupiny.

---

## Doporučení pro další analýzy
- Prozkoumat korelace statisticky (např. Pearsonova korelace) mezi HDP, mzdami a cenami.
- Vytvořit vizualizace trendů a rozdílů mezi růsty cen a mezd.
- Zvážit vliv dalších ekonomických faktorů (inflace, nezaměstnanost).

---

## Závěr
Vypracované tabulky a dotazy poskytují robustní datové podklady k pochopení dynamiky dostupnosti potravin v ČR ve vztahu k ekonomickému vývoji. Data a metody jsou připraveny k prezentaci i dalšímu rozboru.

---

*Autor: Karel Nechvátal*  
*Datum: [29.7.2025]*

