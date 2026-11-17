############ TrustInScience - Demographic analyses ###############

# BASIC INFO ----

# Section aim: Curate the data, describe the distributions of relevant variables, and look for simple associations between them
# Date start: 2026-05-05
# Last update: 2026-11-07 

# SETUP SECTION ----

## 1.- Packages ----
library(tidyverse) # Basic plots and statistical analyses
library(tibble) # For tables
library(skimr) # Quick overview of variables
library(gtsummary) # Ready to publish tables
library(effectsize) # To calculate effect sizes
library(car) # For type III ANOVA
library(performance) # To check assumptions of lms
library(gt)
library(ordinal) # For ordinal regression

## 2.- Dataset loading ----
TrusSci <- read.csv("Data_01.csv")

## 3.- Data handling and overview ----

# Check the structure of the data:
str(TrusSci) 
# OUTPUT: In principle, all variables have the format they should, but will prepare them for future analyses

# Reformat variables:
TrusSci <- TrusSci %>% 
  mutate(
    University = factor(University), # Set the variable as a nominal factor
    Region = factor(Region), # Same
    Degree = factor(Degree, levels = c("English", "History", "Biology", "Chemistry")), 
    Gender = factor(Gender), # Another nominal factor
    AcademicAchievement = factor(AcademicAchievement, levels = c("VocationalTraining", "HighSchool", "UniversityDegree", "Master", "PhD"), ordered = TRUE), # Rank them from lowest to highest academic achievement (from an academic-theoretical point of view)
    AcademicItinerary = factor(AcademicItinerary, levels = c("Art", "Humanities", "SocialSciences", "Technology", "NaturalSciences")), 
    RegionOfOrigin = factor(RegionOfOrigin)) # Nominal factor as well

## 4.- Themes for figures ----

# Theme for figures:
theme_cd <- function(BaseSize = 24, BaseFamily = "sans") {
  theme_classic(base_size = BaseSize, base_family = BaseFamily) +
    theme(
      plot.title = element_blank(),
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

## 1.- Data curation ----

# Check the entire distribution of values in all variables:
lapply(TrusSci, table, useNA = "ifany")

# Inspect problematic cases in the "Code" variable:
View(TrusSci %>% # 
       filter(str_detect(Code, regex("prueba", ignore_case = TRUE))))
# OUTPUT: Don't look suspicious, so will be kept

# Inspect the Age NAs:
view(TrusSci %>% filter(is.na(Age)))
# OUTPUT: The rest of responses looks normal; but let's exclude them just in case

# Inspect the "seniors" in the "Age" variable (=> 50):
view(TrusSci %>% filter(Age >=50))
# OUTPUT: Most of these are likely from the University for Elders program, so I will remove them

# Inspect PhDs: 
view(TrusSci %>% filter(AcademicAchievement == "PhD"))
# OUTPUT: There is one that is very suspicious because it reports being 22 years old

# Create a category of cases to exclude (only seniors):
TrusSci <- TrusSci %>% 
  mutate(
    Exclude_Senior = Age >= 50)

# Create a clean dataset for analyses:
TrusSci_Clean <- TrusSci %>% 
  filter(!Exclude_Senior) %>% # Filter the cases
  filter(!Individual_ID == "433") %>% # Remove the 22-year-old PhD...
  select(-Exclude_Senior) # Remove the variable now that is not useful

# Structure of the cleaned dataset:
str(TrusSci_Clean)
# OUTPUT: All good

## 2.- Sample summary (Table 1) ----

# Create table:
TrusSci_Clean |>  
  select(University, Degree, Gender, AcademicAchievement,
         AcademicItinerary, RegionOfOrigin, Age) %>% 
  tbl_summary(
    type = list(Age ~ "continuous"),
    statistic = list(Age ~ "{mean} ({sd})"),
    digits = all_continuous() ~ 2, 
    sort = all_categorical() ~ "frequency")

## 3.- Political ideology ----

### 3.1.- Comparison with Spanish population ----

# Comparison with the mid point of the scale ([1+10]/2 = 5.5, not 5):
t.test(TrusSci_Clean$PoliticalPosition,
       mu = 5.5)

# Get the standard deviation:
sd(TrusSci_Clean$PoliticalPosition) 

# Comparison with general population (CIS, October 2025 barometer, study 3528, p. 18: https://www.cis.es/es/estudios/barometro-de-octubre-2025?cuestionario=18002&muestra=26360&pregunta=656933&variable=1091008&chartType=bar):
t.test(TrusSci_Clean$PoliticalPosition,
       mu = 4.57)

# Assess effect size of ideological difference:
cohens_d(TrusSci_Clean$PoliticalPosition,
         mu = 4.57)
# OUTPUT: The sample is skewed towards the left when compared to the general population (Cohen's d = -0.19)

### 3.2.- Gender, degree, and ideology ----

#### 3.2.1.- Linear model and ANOVA ----

# Testing the effects of gender and degree:
options(contrasts = c("contr.sum", "contr.poly"))

# Filter majority genders:
PolPos_Data <- TrusSci_Clean |> filter(Gender %in% c("Female", "Male")) 

# Linear model:
PolPos_lm <- lm(PoliticalPosition ~ Degree * Gender,
                data = PolPos_Data)

# Assumptions:
performance::check_model(PolPos_lm)

# Omnibus Type III ANOVA (due to an unbalanced design; i.e., uneven sample size per treatment):
ANOVA_obj <- Anova(PolPos_lm, type = 3) 

# Summary:
ANOVA_obj

#### 3.2.2.- Table S3: Gender, degree, and ideology ----

# Create a dataframe:
ANOVA_df <- as.data.frame(ANOVA_obj) |> 
  rownames_to_column("Effect")

# Extract residuals:
resid_ss <- ANOVA_df |>
  filter(Effect == "Residuals") |>
  pull(`Sum Sq`)

# Create table:
ANOVA_table <- ANOVA_df |>
  filter(Effect != "(Intercept)", Effect != "Residuals") |>
  mutate(
    p = `Pr(>F)`,
    `Partial eta²` = `Sum Sq` / (`Sum Sq` + resid_ss),
    p = ifelse(p < .001, "< .001", sprintf("%.3f", p))) |>
  select(Effect, `Sum Sq`, Df, `F value`, p, `Partial eta²`)

# Format table:
ANOVA_table |>
  gt() |>
  fmt_number(
    columns = c(`Sum Sq`, `F value`, `Partial eta²`),
    decimals = 2) |>
  tab_caption("Results of a type III ANOVA with degree, gender, and their interaction as predictors of the political position of students. Type III ANOVA was chosen due to the unbalanced sample.")

#### 3.2.3.- Figure S1: Gender, degree, and ideology ----
FigureS1 <- TrusSci_Clean |>
  filter(Gender %in% c("Female", "Male")) |>
  ggplot(aes(x = Degree, y = PoliticalPosition, fill = Gender, group = Gender)) +
  stat_summary(aes(color = Gender), fun = mean, geom = "line", linewidth = 1, 
               position = position_dodge(width = 0.4)) +
  stat_summary(aes(color = Gender), fun.data = mean_cl_normal, geom = "errorbar", width = 0.3,
               position = position_dodge(width = 0.4)) +
  stat_summary(fun = mean, geom = "point", size = 4,
               position = position_dodge(width = 0.4), shape = 21) +
  scale_y_continuous(breaks = 1:10, limits = c(1, 10)) +
  scale_fill_manual(values = c(
    "Female" = "#B51616",
    "Male"   = "#4C9ED9")) +
  scale_color_manual(values = c(
    "Female" = "#B51616",
    "Male"   = "#4C9ED9")) +
  labs(x = "Degree", y = "Political position (mean ± 95% CI)") +
  theme_cd(18)
# OUTPUT: In Chemistry, both males and females are more rightwards than in the rest of degrees.

# Save in .svg to export to InkScape:
ggsave("FigureS1.svg",
       FigureS1,
       width = 200, height = 150, units = "mm")

## 4.- Climate change ----

# Prepare the ideology variable:
TrusSci_Clean <- TrusSci_Clean |> 
  mutate(
    PoliticalPosition_Ord = ordered(PoliticalPosition, levels = 1:10))

# Ordinal regression:
PolPos_Ordinal <- ordinal::clm(
  PoliticalPosition_Ord ~ factor(ClimateChangeConcern),
  data = TrusSci_Clean,
  link = "logit",
  Hess = TRUE)

# Ordinal model summary:
summary(PolPos_Ordinal)

# Get predictor coefficient:
Beta <- PolPos_Ordinal$beta

# Odds ratio:
OddsRatio <- exp(Beta)

# 95% CI:
CI <- confint(PolPos_Ordinal)

# Table of odds ratios:
OR_Table <- data.frame(
  Predictor = names(Beta),
  OR = exp(Beta),
  CI_Lower = exp(CI[names(Beta), 1]),
  CI_Upper = exp(CI[names(Beta), 2]))

OR_Table # Check the table

# Robustness check: linear model (WARNING: YOU HAVE TO RE-FORMAT POLITICAL POSITION):
ClimCon_lm <- lm(PoliticalPosition ~ ClimateChangeConcern,
                 data = TrusSci_Clean)

# Run diagnostics: 
check_model(ClimCon_lm)

# Summary:
summary(ClimCon_lm)

