# Dashboard_RH_Data
Ce projet de data visualisation est réalisé à titre personnel et concerne la construction d'un tableau de bord sur Rshiny en utilisant les données sur les employés d'une entreprise. Les données concernent les accidents de travail, la satisfaction des employés et le taux de rétention des employés. Ce dashboard comporte trois pages à savoir: Work accident, People retention et Employee satisfaction. Voici les KPIs definit de chaque page.

1️⃣Work accident

Objectif : comprendre les accidents de travail et leur distribution.
Indicateurs à afficher :

-Nombre total d’accidents (global + par département sales)

-Taux d’accidents (% d’employés ayant eu un accident)

-Répartition des accidents par ancienneté (time_spend_company)

-Croisement accidents vs départs (Work_accident × left)

2️⃣People retention

Objectif : analyser les facteurs du turnover (colonne left).
Indicateurs à afficher :

-Taux de rétention = % d’employés restés (left = 0)

-Taux de turnover = % d’employés partis (left = 1)

-Analyse par ancienneté (time_spend_company)

-Analyse par salaire (salary)

Analyse par promotion (promotion_last_5years)


3️⃣ Employee satisfaction

Objectif : explorer la satisfaction des employés et ses liens avec performance et départ.
Indicateurs à afficher :

-Moyenne et distribution du satisfaction_level

-Satisfaction moyenne des employés restés vs partis (left)

-Relation satisfaction vs évaluation (last_evaluation)

-Satisfaction par département (sales)

