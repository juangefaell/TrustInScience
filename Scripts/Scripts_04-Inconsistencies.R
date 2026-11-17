############ TrustInScience - Inconsistencies in knowledge of the nature of science ###############

# BASIC INFO ----

# Section aim: Study the inconsistencies in students' responses.
# Date start: 2026-07-27
# Last update: 2026-11-17 

# SETUP SECTION ----

## 1.- Packages ----
library(tidyverse) # Basic plots and statistical analyses
library(psych) # Test assessment techniques
library(lavaan) # EFA and CFA
library(Hmisc) # Correlations
library(patchwork) # To wrap plots
library(effectsize) # To calculate effect sizes
library(forcats)
library(scales)
library(car) # ANOVA and stuff
library(effectsize) # To calculate effect sizes
library(emmeans) # Post hoc tests
library(parameters)
library(interactions)
library(ggExtra) # To incorporate density plots into scatterplots.
library(rcompanion) # Effect size in chi-square
library(cowplot) # Composite figures
library(patchwork)

## 2.- Dataset loading ----
TrusSci <- read.csv("Data_01.csv")

## 3.- Data handling and overview ----

### 3.1.- Loading and reformatting ----

# Check the structure of the data:
str(TrusSci) 
# OUTPUT: In principle, all variables have the format they should, but will prepare them for future analyses

# Reformat variables:
TrusSci <- TrusSci %>% 
  mutate(
    University = factor(University), # Set the variable as a nominal factor
    Region = factor(Region), # Same
    Degree = factor(Degree, levels = c("English", "History", "Biology", "Chemistry")), # Set factors from less to more "scientificity", understood in a positivistic-Comtean sense 
    Gender = factor(Gender), # Another nominal factor
    AcademicAchievement = factor(AcademicAchievement, levels = c("VocationalTraining", "HighSchool", "UniversityDegree", "Master", "PhD"), ordered = TRUE), # Rank them from lowest to highest academic achievement (from an academic-theoretical point of view)
    AcademicItinerary = factor(AcademicItinerary, levels = c("Art", "Humanities", "SocialSciences", "Technology", "NaturalSciences")), # Same positivistic ranking of itinerary (just as a working hypothesis)
    RegionOfOrigin = factor(RegionOfOrigin)) # Nominal factor as well

### 3.2.- Clean dataset ----

# Create a category of cases to exclude (only seniors):
TrusSci <- TrusSci %>% 
  mutate(
    Exclude_Senior = Age >= 50)

# Create a clean dataset for analyses:
TrusSci_Clean <- TrusSci %>% 
  filter(!Exclude_Senior) %>% # Filter the cases
  filter(!Individual_ID == "433") %>% # Remove the 22-year-old PhD...
  select(-Exclude_Senior) # Remove the variable now that is not useful

### 3.3.- Test subscales ----

# Create the NOS_Items list:
NOS_Items <- grep(
  "^NOS_[0-9]{2}_[fr]$",
  names(TrusSci_Clean),
  value = TRUE)

length(NOS_Items)

# Create total test scores:
TrusSci_Clean <- TrusSci_Clean |>
  mutate(
    DUREL_Total = rowMeans(
      pick(matches("^DUREL_[0-9]{2}$")), na.rm = TRUE),
    TISS_Total = rowMeans(
      pick(matches("^Trust_[0-9]{2}_[fr]$")), na.rm = TRUE),
    NOS_Total = rowMeans(
      pick(matches("^NOS_[0-9]{2}_[fr]$")), na.rm = TRUE))

### 3.4.- Create the "Consistency" variables ----

# Specify the categories (with are directional, i.e., only consider low values in the reverse items):
TrusSci_Clean <- TrusSci_Clean |>
  mutate(
    Testing_Consistency = case_when(
      NOS_05_f %in% c(4, 5) & NOS_06_r %in% c(1, 2) ~ "Testing_Inconsistent",
      NOS_05_f %in% c(4, 5) & NOS_06_r %in% c(4, 5) ~ "Testing_Consistent_Right",
      NOS_05_f %in% c(1, 2) & NOS_06_r %in% c(1, 2) ~ "Testing_Consistent_Wrong",
      TRUE ~ "Rest"),
    Testing_Consistency = factor(
      Testing_Consistency,
      levels = c("Testing_Consistent_Right", "Testing_Inconsistent", "Testing_Consistent_Wrong", "Rest")),
    Nonlinearity_Consistency = case_when(
      NOS_07_f %in% c(4, 5) & NOS_08_r %in% c(1, 2) ~ "Nonlinearity_Inconsistent",
      NOS_07_f %in% c(4, 5) & NOS_08_r %in% c(4, 5) ~ "Nonlinearity_Consistent_Right",
      NOS_07_f %in% c(1, 2) & NOS_08_r %in% c(1, 2) ~ "Nonlinearity_Consistent_Wrong",
      TRUE ~ "Rest"),
    Nonlinearity_Consistency = factor(
      Nonlinearity_Consistency,
      levels = c("Nonlinearity_Consistent_Right", "Nonlinearity_Inconsistent", "Nonlinearity_Consistent_Wrong", "Rest")),
    Construction_Consistency = case_when(
      NOS_09_f %in% c(4, 5) & NOS_10_r %in% c(1, 2) ~ "Construction_Inconsistent",
      NOS_09_f %in% c(4, 5) & NOS_10_r %in% c(4, 5) ~ "Construction_Consistent_Right",
      NOS_09_f %in% c(1, 2) & NOS_10_r %in% c(1, 2) ~ "Construction_Consistent_Wrong",
      TRUE ~ "Rest"),
    Construction_Consistency = factor(
      Construction_Consistency,
      levels = c("Construction_Consistent_Right", "Construction_Inconsistent", "Construction_Consistent_Wrong", "Rest")),
    Degree = fct_inorder(Degree))


## 4.- Themes for figures ----

# Theme for figures:
theme_cd <- function(BaseSize = 24, BaseFamily = "sans") {
  theme_classic(base_size = BaseSize, base_family = BaseFamily) +
    theme(
      axis.title = element_text(size = BaseSize + 2, colour = "black"),
      axis.text = element_text(size = BaseSize, colour = "black"),
      axis.ticks = element_line(linewidth = 0.5, colour = "black"),
      axis.ticks.length = unit(2.2, "mm"),
      legend.title = element_blank(),
      legend.text = element_text(size = BaseSize),
      legend.key.size = unit(4, "mm"),
      strip.background = element_blank(),
      strip.text = element_text(size = BaseSize + 1, colour = "black"),
      plot.margin = margin(3, 3, 3, 3, unit = "mm")
    )
}

# ANALYSIS SECTION ----

## 1.- Mapping inconsistencies ----

### 1.1.- First approximation ----

# Pairing of items by theme:
NOS_themes <- tibble::tribble(
  ~Theme,            ~item1,     ~item2,
  "Theory support",  "NOS_01_f", "NOS_02_r",
  "Theory limits",   "NOS_03_f", "NOS_04_r",
  "Testing",         "NOS_05_f", "NOS_06_r",
  "Nonlinearity",    "NOS_07_f", "NOS_08_r",
  "Construction",    "NOS_09_f", "NOS_10_r",
  "Provisionality",  "NOS_11_f", "NOS_12_r",
  "Continuity",      "NOS_13_f", "NOS_14_r",
  "Comparison",      "NOS_15_f", "NOS_16_r",
  "Creativity",      "NOS_17_f", "NOS_18_r",
  "Community",       "NOS_19_f", "NOS_20_r",
  "Applications",    "NOS_21_f", "NOS_22_r",
  "Society/Culture", "NOS_23_f", "NOS_24_r"
)

pair_plot <- function(data, xvar, yvar, title) {
  ggplot(data, aes(x = .data[[xvar]], y = .data[[yvar]])) +
    geom_count(alpha = 0.75, color = "black") +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", linewidth = 0.5) +
    scale_size_area(max_size = 8, guide = "none") +
    scale_x_continuous(breaks = 1:5, limits = c(1, 5)) +
    scale_y_continuous(breaks = 1:5, limits = c(1, 5)) +
    labs(
      x = xvar,
      y = yvar,
      title = title
    ) +
    theme_cd(12)
}

plots <- purrr::pmap(
  NOS_themes,
  function(Theme, item1, item2) {
    pair_plot(TrusSci_Clean, item1, item2, Theme)
  }
)

wrap_plots(plots, ncol = 3)

# Visualize the most problematic: 
pair_plot(TrusSci_Clean, "NOS_05_f", "NOS_06_r", "Testing")
pair_plot(TrusSci_Clean, "NOS_07_f", "NOS_08_r", "Nonlinearity")
pair_plot(TrusSci_Clean, "NOS_09_f", "NOS_10_r", "Construction")

### 1.2.- Nice figures ----

# Testing:
Plot_Testing <- pair_plot(
  TrusSci_Clean, "NOS_05_f", "NOS_06_r", "Testing") +
  labs(
    x = "Forward-coded items",
    y = "Reverse-coded item",
    title = "Testing") +
  theme_cd(18)

# Nonlinearity:
Plot_Nonlinearity <- pair_plot(
  TrusSci_Clean, "NOS_07_f", "NOS_08_r", "Nonlinearity") +
  labs(
    x = "Forward-coded item",
    y = "Reverse-coded item",
    title = "Nonlinearity") +
  theme_cd(18)

# Construction:
Plot_Construction <- pair_plot(
  TrusSci_Clean, "NOS_09_f", "NOS_10_r", "Construction") +
  labs(
    x = "Forward-coded item",
    y = "Reverse-coded item",
    title = "Construction") +
  theme_cd(18)

# Remove individual axis titles:
Plot_Testing <- Plot_Testing +
  theme(axis.title.x = element_blank())

Plot_Nonlinearity <- Plot_Nonlinearity +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank())

Plot_Construction <- Plot_Construction +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank())

# Combine the three panels:
Combined_Themes <- cowplot::plot_grid(
  Plot_Testing,
  Plot_Nonlinearity,
  Plot_Construction,
  #labels = c("A", "B", "C"),
  #label_size = 20,
  label_x = 0.02,
  label_y = 0.98,
  nrow = 1,
  align = "hv",
  axis = "tblr",
  rel_widths = c(1, 1.05, 1.05))

# Add a shared, centered x-axis title:
Figure_Consistency <- cowplot::ggdraw() +
  cowplot::draw_plot(
    # Combine the three panels:
    Combined_Themes,
    x = 0,
    y = 0.08,
    width = 1,
    height = 0.92) +
  cowplot::draw_label(
    "Forward-coded items",
    x = 0.5,
    y = 0.06,
    size = 20,
    fontfamily = "sans")

# Display:
Figure_Consistency

# Save the figure:
ggsave(
  filename = "FigureS3.svg",
  plot = Figure_Consistency,
  width = 350,
  height = 150,
  units = "mm")

## 2.- Linear regression ----

# Count inconsistencies in themes:
TrusSci_Clean <- TrusSci_Clean |>
  mutate(
    Consistency_Right_Count =
      (Testing_Consistency == "Testing_Consistent_Right") +
      (Nonlinearity_Consistency == "Nonlinearity_Consistent_Right") +
      (Construction_Consistency == "Construction_Consistent_Right"))

table(TrusSci_Clean$Consistency_Right_Count) # Counts

# Flag the consistency items that must be excludes:
Consistency_Items <- c(
  "NOS_05_f", "NOS_06_r",
  "NOS_07_f", "NOS_08_r",
  "NOS_09_f", "NOS_10_r")

# Identifying the remaining items that would feature in the new reduced NOS_Total:
NOS_Items_Without_Consistency <- setdiff(
  NOS_Items,
  Consistency_Items)

# Create the reduced NOS_Total: 
TrusSci_Clean <- TrusSci_Clean |>
  mutate(
    NOS_Total_18 = rowMeans(
      pick(all_of(NOS_Items_Without_Consistency)),
      na.rm = TRUE),
    NOS_Problematic = rowMeans(
      pick(all_of(Consistency_Items)),
      na.rm = TRUE))

# Create problematic theme means (just in case):
TrusSci_Clean <- TrusSci_Clean |>
  mutate(
    NOS_Testing = rowMeans(
      pick(NOS_05_f, NOS_06_r),
      na.rm = TRUE),
    NOS_Nonlinearity = rowMeans(
      pick(NOS_07_f, NOS_08_r),
      na.rm = TRUE),
    NOS_Construction = rowMeans(
      pick(NOS_09_f, NOS_10_r),
      na.rm = TRUE))

# Descriptive: 
psych::describe(
  TrusSci_Clean[c("NOS_Total", "NOS_Total_18")])
# OUTPUT: They correlate a lot.

# Inspect formal correlation:
cor(
  TrusSci_Clean$NOS_Total,
  TrusSci_Clean$NOS_Total_18,
  method = "spearman")
# OUTPUT: Yes, indeed.

# Consistency model:
Consistency_Model_18 <- lm(
  NOS_Total_18 ~ Consistency_Right_Count,
  data = TrusSci_Clean)

# Check the summary:
summary(Consistency_Model_18)
# OUTPUT: Negligible result...

# Assumptions:
par(mfrow = c(2, 2))
plot(Consistency_Model_18)
par(mfrow = c(1, 1))
# OUTPUT: All good.

# Visualization:
Figure_Themes <- TrusSci_Clean |> 
  ggplot(aes(x = factor(Consistency_Right_Count), y = NOS_Total_18)) +
  geom_jitter(width = .15, alpha = .30) +
  geom_boxplot(fill = "#DFD2E5", alpha = 0.7, staplewidth = 0.3, linewidth = 1) +
  labs(
    x = "Number of consistent \nand right response profiles",
    y = "Knowledge of the nature of science \n(Items in nonproblematic themes)") +
  theme_cd(18)

# Save the figure:
ggsave(
  filename = "FigureS4.svg",
  plot = Figure_Themes,
  width = 200,
  height = 150,
  units = "mm")

# Check just in case with average values:
TrusSci_Clean |> 
  ggplot(aes(x = NOS_Problematic, y = NOS_Total_18)) +
  geom_point(alpha = 0.55, size = 2) +
  geom_smooth(method = "lm", se = TRUE, linewidth = 1) +
  labs(x = "Mean score in problematic items", y = "Knowledge of the nature of science (18 remaining items)", color = NULL) +
  theme_cd(18) +
  theme(legend.position = c(0.02, 0.98),
        legend.justification = c(0, 1),
        legend.background = element_blank(),
        legend.key = element_blank(),
        legend.title = element_blank(),
        legend.text = element_text(size = 12),
        legend.key.size = unit(0.6, "lines"),
        legend.spacing.y = unit(0.1, "lines")) +
  scale_y_continuous(breaks = 1:5) +
  scale_x_continuous(breaks = 1:5) 

## 3.- Inconsistencies among top and bottom scorers ----

# Put the three theme variables into long format:
InconsistencyPlot_Data <- TrusSci_Clean |>
  select(Degree, Testing_Consistency, Nonlinearity_Consistency, Construction_Consistency) |>
  pivot_longer(
    cols = ends_with("_Consistency"),
    names_to = "Theme",
    values_to = "Profile") |>
  mutate(
    Theme = case_when(
      Theme == "Testing_Consistency" ~ "Testing",
      Theme == "Nonlinearity_Consistency" ~ "Nonlinearity",
      Theme == "Construction_Consistency" ~ "Construction"),
    Theme = factor(Theme, levels = c("Testing", "Nonlinearity", "Construction")),
    Response = case_when(
      grepl("Consistent_Right$", Profile) ~ "Consistent_Right",
      grepl("Inconsistent$", Profile) ~ "Inconsistent",
      TRUE ~ NA_character_),
    Response = factor(
      Response,
      levels = c("Consistent_Right", "Inconsistent"))) |>
  filter(!is.na(Response)) |>
  group_by(Theme, Degree, Response) |>
  summarise(n = n(), .groups = "drop_last") |>
  group_by(Theme, Degree) |>
  mutate(Percentage = n / sum(n)) |>
  ungroup()

# Table:
TrusSci_Clean |>
  select(Degree, Testing_Consistency, Nonlinearity_Consistency, Construction_Consistency) |>
  pivot_longer(
    cols = ends_with("_Consistency"),
    names_to = "Theme",
    values_to = "Profile") |>
  mutate(
    Theme = dplyr::recode(
      Theme,
      Testing_Consistency = "Testing",
      Nonlinearity_Consistency = "Nonlinearity",
      Construction_Consistency = "Construction"),
    Response = case_when(
      grepl("Consistent_Right$", Profile) ~ "Consistent_Right",
      # grepl("Consistent_Wrong$", Profile) ~ "Consistent_Wrong",
      grepl("Inconsistent$", Profile) ~ "Inconsistent",
      TRUE ~ "Rest")) |>
  filter(Response != "Rest") |>
  count(Theme, Degree, Response) |>
  tidyr::pivot_wider(
    names_from = Degree,
    values_from = n,
    values_fill = 0)

### 3.1.- 'Testing' theme ----

# Create top and bottom scorer categories:
Testing_Quartiles <- TrusSci_Clean |> 
  mutate(
    NOS_Group = case_when(
      NOS_Total_18 <= quantile(NOS_Total_18,.25,na.rm=TRUE) ~ "Bottom",
      NOS_Total_18 >= quantile(NOS_Total_18,.75,na.rm=TRUE) ~ "Top", TRUE ~ NA_character_)) |>
  filter(!is.na(NOS_Group))

# Keep only the two profiles of interest:
Testing_Quartiles <- Testing_Quartiles |>
  filter(
    Testing_Consistency %in% c(
      "Testing_Consistent_Right",
      "Testing_Inconsistent")) |>
  droplevels()

# Contingency table:
Testing_Table <- table(
  Testing_Quartiles$NOS_Group,
  Testing_Quartiles$Testing_Consistency)

Testing_Table

# Chi-square test:
Testing_Chi <- chisq.test(Testing_Table)

Testing_Chi # View the result

# Effect size:
cramerV(Testing_Table) # Cramer's V
Testing_Chi$stdres # Standardized residuals

# Percentages (total = top and bottom quartiles only):
Testing_Quartiles |>
  mutate(
    Testing_Consistency = dplyr::recode(
      Testing_Consistency,
      "Testing_Consistent_Right" = "Consistent",
      "Testing_Inconsistent" = "Inconsistent")) |>
  count(NOS_Group, Testing_Consistency) |>
  group_by(NOS_Group) |>
  mutate(
    Percentage = n / sum(n))

### 3.2.- 'Nonlinearity' theme ----

# Create top and bottom scorer categories:
Nonlinearity_Quartiles <- TrusSci_Clean |> 
  mutate(
    NOS_Group = case_when(
      NOS_Total_18 <= quantile(NOS_Total_18,.25,na.rm=TRUE) ~ "Bottom",
      NOS_Total_18 >= quantile(NOS_Total_18,.75,na.rm=TRUE) ~ "Top", TRUE ~ NA_character_)) |>
  filter(!is.na(NOS_Group))

# Keep only the two profiles of interest:
Nonlinearity_Quartiles <- Nonlinearity_Quartiles |>
  filter(
    Nonlinearity_Consistency %in% c(
      "Nonlinearity_Consistent_Right",
      "Nonlinearity_Inconsistent")) |>
  droplevels()

# Contingency table:
Nonlinearity_Table <- table(
  Nonlinearity_Quartiles$NOS_Group,
  Nonlinearity_Quartiles$Nonlinearity_Consistency)

Nonlinearity_Table

# Chi-square test:
Nonlinearity_Chi <- chisq.test(Nonlinearity_Table)

Nonlinearity_Chi # View the result

# Effect size:
cramerV(Nonlinearity_Table) # Cramer's V
Nonlinearity_Chi$stdres # Standardized residuals

# Percentages (total = top and bottom quartiles only):
Nonlinearity_Quartiles |>
  mutate(
    Nonlinearity_Consistency = dplyr::recode(
      Nonlinearity_Consistency,
      "Nonlinearity_Consistent_Right" = "Consistent",
      "Nonlinearity_Inconsistent" = "Inconsistent")) |>
  count(NOS_Group, Nonlinearity_Consistency) |>
  group_by(NOS_Group) |>
  mutate(
    Percentage = n / sum(n))

### 3.3.- 'Construction' theme ----

# Create top and bottom scorer categories:
Construction_Quartiles <- TrusSci_Clean |> 
  mutate(
    NOS_Group = case_when(
      NOS_Total_18 <= quantile(NOS_Total_18,.25,na.rm=TRUE) ~ "Bottom",
      NOS_Total_18 >= quantile(NOS_Total_18,.75,na.rm=TRUE) ~ "Top", TRUE ~ NA_character_)) |>
  filter(!is.na(NOS_Group))

# Keep only the two profiles of interest:
Construction_Quartiles <- Construction_Quartiles |>
  filter(
    Construction_Consistency %in% c(
      "Construction_Consistent_Right",
      "Construction_Inconsistent")) |>
  droplevels()

# Contingency table:
Construction_Table <- table(
  Construction_Quartiles$NOS_Group,
  Construction_Quartiles$Construction_Consistency)

Construction_Table

# Chi-square test:
Construction_Chi <- chisq.test(Construction_Table)

Construction_Chi # View the result

# Effect size:
cramerV(Construction_Table) # Cramer's V
Construction_Chi$stdres # Standardized residuals

# Percentages (total = top and bottom quartiles only):
Construction_Quartiles |>
  mutate(
    Construction_Consistency = dplyr::recode(
      Construction_Consistency,
      "Construction_Consistent_Right" = "Consistent",
      "Construction_Inconsistent" = "Inconsistent")) |>
  count(NOS_Group, Construction_Consistency) |>
  group_by(NOS_Group) |>
  mutate(
    Percentage = n / sum(n))

