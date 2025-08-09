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

### 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? 
Analýza ukazuje, že mzdy rostou ve všech sledovaných odvětvích za období prvního a posledního dostupného roku. Nejnižší celkový růst mzdy zaznamenalo odvětví těžby a dobývání s růstem o 129,06 % a průměrným ročním tempem růstu (CAGR) 4,03 %. Naopak nejvyšší růst vykázalo odvětví zdravotní a sociální péče s celkovým růstem 285,37 % a CAGR 6,63 %.

Původní verze analýzy porovnávala pouze minimální a maximální průměrné mzdy bez ohledu na to, zda tyto hodnoty odpovídaly stejným rokům, což mohlo vést k nepřesnostem. Proto jsem upravil metodiku tak, aby porovnávala mzdy mezi prvním a posledním rokem dostupných dat pro každé odvětví.

Navíc jsem přidal výpočet CAGR (průměrné roční tempo růstu), který lépe zachycuje dynamiku změn mezd v čase a umožňuje spravedlivější srovnání mezi odvětvími s různou délkou sledovaného období.

Tímto způsobem výsledky přesněji reflektují skutečný vývoj mezd v jednotlivých odvětvích.

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
Analýza ročních meziročních růstů HDP, mezd a cen potravin ukazuje, že vztah mezi růstem HDP a růstem mezd či cen potravin není jednoznačně silný ani bezprostřední.

#### Ve stejném roce:
 Zvýšení HDP většinou koreluje s mírným zvýšením mezd a cen potravin, ale velikost tohoto růstu je různorodá a často méně výrazná než růst HDP. V některých letech došlo k růstu HDP bez adekvátního růstu mezd či cen (např. rok 2014), jindy naopak mzdy rostly i při poklesu HDP (např. rok 2009).


#### V následujícím roce: 
Data ukazují, že zvýšení HDP může mít zpožděný vliv na růst mezd a cen potravin, ale tento efekt není stabilní ani konzistentní. Některé roky vykazují silnější růst mezd nebo cen potravin po růstu HDP v předchozím roce (např. rok 2017 po růstu HDP v roce 2016), ale existují i výjimky.
#### Celkově: 
Růst HDP je důležitým makroekonomickým ukazatelem, ale ovlivnění mezd a cen potravin závisí také na dalších faktorech, jako jsou inflace, politika trhu práce, ceny surovin, mezinárodní ekonomické podmínky a specifické tržní síly.
#### Doporučení: 
Pro robustní závěr by bylo vhodné doplnit analýzu korelačním testem (například Pearsonova korelace) a případně pokročilejšími statistickými metodami (např. modely časových řad, Grangerova kauzalita), aby se ověřila síla a směr vzájemné závislosti.


#### Shrnutí:
Výraznější růst HDP může přispět k růstu mezd a cen potravin, ale nelze ho považovat za jediný nebo bezprostřední faktor. Vliv je spíše mírný a často zpožděný, což reflektuje komplexní povahu ekonomiky a další vnější vlivy.

---

## Omezení a poznámky k datům
- Některé roky obsahují chybějící hodnoty (NULL), zejména v dřívějších obdobích, což může ovlivnit výsledky analýzy.
- Data o HDP jsou dostupná od roku 1960, avšak ne pro všechny země a roky, mzdy a ceny potravin mají různou časovou dostupnost podle zdrojů a kategorií.
- Ceny potravin jsou zprůměrovány z několika kategorií, proto by bylo vhodné rozšířit analýzu o detailnější pohled na jednotlivé potravinové skupiny.

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

