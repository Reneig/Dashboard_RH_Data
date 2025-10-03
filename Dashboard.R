# ==============================
#   Tableau de bord RH avec Shiny
#   Indicateurs : Work Accident, Retention, Satisfaction
#   Auteur : GBODOGBE Zinsou René
# ==============================

# ---- Chargement des librairies ----
library(shiny)             # Pour créer l’application web
library(shinydashboard)    # Pour la mise en page type "dashboard"
library(ggplot2)           # Pour les graphiques

# ---- Importation des données ----
# Assure-toi que HR.csv est dans ton répertoire de travail
HR <- read_csv("C:/Users/gbodo/Downloads/HR.csv")

# ---- Interface utilisateur (UI) ----
ui <- dashboardPage(
  dashboardHeader(title = "Dashboard RH"),   # Titre en haut
  dashboardSidebar(                          # Menu latéral gauche
    sidebarMenu(
      menuItem("Work Accident", tabName = "accident", icon = icon("user-injured")),
      menuItem("People Retention", tabName = "retention", icon = icon("users")),
      menuItem("Employee Satisfaction", tabName = "satisfaction", icon = icon("smile"))
    ),
    # Filtres globaux applicables à tout le tableau de bord
    selectInput("dept", "Choisir un département :", 
                choices = c("All", unique(HR$sales)), selected = "All"),
    selectInput("salary", "Niveau de salaire :", 
                choices = c("All", unique(HR$salary)), selected = "All")
  ),
  dashboardBody(                               # Contenu principal du dashboard
    tabItems(
      # ==============================
      # Onglet 1 : Work Accident
      # ==============================
      tabItem(tabName = "accident",
              fluidRow(
                # Un seul indicateur : % des employés partis et ayant eu un accident
                valueBoxOutput("accident_left", width = 12)
              ),
              fluidRow(
                # Graphique : accidents par département
                box(width = 6, title = "Accidents par département", status = "primary", solidHeader = TRUE,
                    plotOutput("accident_by_dept")),
                # Graphique : accidents par ancienneté
                box(width = 6, title = "Ancienneté et accidents", status = "primary", solidHeader = TRUE,
                    plotOutput("accident_by_tenure"))
              )
      ),
      
      # ==============================
      # Onglet 2 : People Retention
      # ==============================
      tabItem(tabName = "retention",
              fluidRow(
                # Indicateur : taux de départs
                valueBoxOutput("turnover_rate", width = 6),
                # Indicateur : taux de rétention
                valueBoxOutput("retention_rate", width = 6)
              ),
              fluidRow(
                # Graphique : turnover par salaire
                box(width = 6, title = "Turnover par salaire", status = "warning", solidHeader = TRUE,
                    plotOutput("turnover_by_salary")),
                # Graphique : turnover par ancienneté
                box(width = 6, title = "Turnover par ancienneté", status = "warning", solidHeader = TRUE,
                    plotOutput("turnover_by_tenure"))
              )
      ),
      
      # ==============================
      # Onglet 3 : Employee Satisfaction
      # ==============================
      tabItem(tabName = "satisfaction",
              fluidRow(
                # Satisfaction moyenne globale
                valueBoxOutput("avg_satisfaction", width = 6),
                # Satisfaction moyenne des employés restés
                valueBoxOutput("satisfaction_stayed", width = 6)
              ),
              fluidRow(
                # Histogramme de satisfaction
                box(width = 6, title = "Distribution de la satisfaction", status = "success", solidHeader = TRUE,
                    plotOutput("satisfaction_dist")),
                # Relation satisfaction vs évaluation
                box(width = 6, title = "Satisfaction vs Évaluation", status = "success", solidHeader = TRUE,
                    plotOutput("satisfaction_eval"))
              ),
              fluidRow(
                # Satisfaction par département
                box(width = 12, title = "Satisfaction par département", status = "success", solidHeader = TRUE,
                    plotOutput("satisfaction_dept"))
              )
      )
    )
  )
)

# ---- Partie serveur ----
server <- function(input, output, session) {
  
  # ---- Filtrage des données selon les choix utilisateur ----
  filtered_data <- reactive({
    data <- HR
    if (input$dept != "All") {
      data <- data[data$sales == input$dept, ]
    }
    if (input$salary != "All") {
      data <- data[data$salary == input$salary, ]
    }
    data
  })
  
  # ==============================
  # 1. Work Accident
  # ==============================
  
  # % d’employés partis et ayant eu un accident
  output$accident_left <- renderValueBox({
    data <- filtered_data()
    prop <- mean(data$Work_accident[data$left == 1], na.rm = TRUE) * 100
    valueBox(
      paste0(round(prop, 1), "%"),
      "Employés partis ayant eu un accident",
      icon = icon("user-injured"),
      color = "red"
    )
  })
  
  # Graphique : accidents par département
  output$accident_by_dept <- renderPlot({
    data <- filtered_data()
    ggplot(data, aes(x = sales, fill = factor(Work_accident))) +
      geom_bar(position = "fill") +
      labs(y = "Proportion", x = "Département", fill = "Accident") +
      theme_minimal() +
      coord_flip()
  })
  
  # Graphique : accidents par ancienneté
  output$accident_by_tenure <- renderPlot({
    data <- filtered_data()
    ggplot(data, aes(x = factor(time_spend_company), fill = factor(Work_accident))) +
      geom_bar(position = "fill") +
      labs(y = "Proportion", x = "Années dans l’entreprise", fill = "Accident") +
      theme_minimal()
  })
  
  # ==============================
  # 2. People Retention
  # ==============================
  
  # Taux de turnover
  output$turnover_rate <- renderValueBox({
    rate <- mean(filtered_data()$left) * 100
    valueBox(
      paste0(round(rate, 1), "%"),
      "Taux de turnover",
      icon = icon("sign-out-alt"),
      color = "orange"
    )
  })
  
  # Taux de rétention
  output$retention_rate <- renderValueBox({
    rate <- mean(filtered_data()$left == 0) * 100
    valueBox(
      paste0(round(rate, 1), "%"),
      "Taux de rétention",
      icon = icon("user-check"),
      color = "green"
    )
  })
  
  # Graphique : turnover par salaire
  output$turnover_by_salary <- renderPlot({
    data <- filtered_data()
    ggplot(data, aes(x = salary, fill = factor(left))) +
      geom_bar(position = "fill") +
      labs(y = "Proportion", x = "Salaire", fill = "Parti") +
      theme_minimal()
  })
  
  # Graphique : turnover par ancienneté
  output$turnover_by_tenure <- renderPlot({
    data <- filtered_data()
    ggplot(data, aes(x = factor(time_spend_company), fill = factor(left))) +
      geom_bar(position = "fill") +
      labs(y = "Proportion", x = "Années dans l’entreprise", fill = "Parti") +
      theme_minimal()
  })
  
  # ==============================
  # 3. Employee Satisfaction
  # ==============================
  
  # Satisfaction moyenne globale
  output$avg_satisfaction <- renderValueBox({
    avg <- mean(filtered_data()$satisfaction_level, na.rm = TRUE) * 100
    valueBox(
      paste0(round(avg, 1), "%"),
      "Satisfaction moyenne globale",
      icon = icon("smile"),
      color = "blue"
    )
  })
  
  # Satisfaction moyenne des employés restés
  output$satisfaction_stayed <- renderValueBox({
    data <- filtered_data()
    sat_stayed <- mean(data$satisfaction_level[data$left == 0], na.rm = TRUE) * 100
    valueBox(
      paste0(round(sat_stayed, 1), "%"),
      "Satisfaction des restés",
      icon = icon("thumbs-up"),
      color = "green"
    )
  })
  
  # Histogramme de satisfaction
  output$satisfaction_dist <- renderPlot({
    data <- filtered_data()
    ggplot(data, aes(x = satisfaction_level)) +
      geom_histogram(binwidth = 0.05, fill = "skyblue", color = "white") +
      labs(x = "Niveau de satisfaction", y = "Effectif") +
      theme_minimal()
  })
  
  # Relation satisfaction vs évaluation
  output$satisfaction_eval <- renderPlot({
    data <- filtered_data()
    ggplot(data, aes(x = satisfaction_level, y = last_evaluation, color = factor(left))) +
      geom_point(alpha = 0.6) +
      labs(x = "Satisfaction", y = "Évaluation", color = "Parti") +
      theme_minimal()
  })
  
  # Satisfaction par département
  output$satisfaction_dept <- renderPlot({
    data <- filtered_data()
    ggplot(data, aes(x = sales, y = satisfaction_level, fill = sales)) +
      geom_boxplot() +
      labs(x = "Département", y = "Satisfaction") +
      theme_minimal() +
      theme(legend.position = "none")
  })
}

# ---- Lancement de l'application ----
shinyApp(ui, server)
