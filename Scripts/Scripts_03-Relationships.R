############ TrustInScience - Relationships between trust and knowledge ###############

# BASIC INFO ----

# Section aim: Study the relationships between TiSS and NoS.
# Date start: 2026-07-24
# Last update: 2026-11-10 

# SETUP SECTION ----

## 1.- Packages ----
library(tidyverse) # Basic plots and statistical analyses
library(psych) # Test assessment techniques
library(lavaan) # EFA and CFA
library(forcats)
library(scales)
library(car) # ANOVA and stuff
library(effectsize) # To calculate effect sizes
library(emmeans) # Post hoc tests
library(ggExtra) # To incorporate density plots into scatterplots.
library(lme4) # GLMs
library(performance) # Check assumptions
library(cowplot) # Composite figures
library(grid) # Composite figures 
library(ggplotify) # To be able to incorporate marginal histograms to the composite figure
library(flextable) # Nice table
library(lavaanPlot) # Visualize the path
library(DiagrammeRsvg) # Save the path diagram as SVG

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

# Create total test scores:
TrusSci_Clean <- TrusSci_Clean |>
  mutate(
    DUREL_Total = rowMeans(
      pick(matches("^DUREL_[0-9]{2}$")), na.rm = TRUE),
    TISS_Total = rowMeans(
      pick(matches("^Trust_[0-9]{2}_[fr]$")), na.rm = TRUE),
    NOS_Total = rowMeans(
      pick(matches("^NOS_[0-9]{2}_[fr]$")), na.rm = TRUE))

# DUREL's subscales:
TrusSci_Clean <- TrusSci_Clean |> 
  mutate(
    DUREL_Org = DUREL_01, # Institutional religiosity
    DUREL_Beh = DUREL_02, # Behavioral religiosity
    DUREL_Intrins = rowMeans(across(c(DUREL_03, DUREL_04, DUREL_05)), na.rm = TRUE)) # Intrinsic religiosity

# TISS's factor scores:
TrusSci_Clean <- TrusSci_Clean |> 
  mutate(
    TISS_Factor1 = rowMeans(
      across(c(Trust_03_r, Trust_07_f, Trust_09_f, Trust_10_f, Trust_11_f,
               Trust_12_f, Trust_14_f, Trust_15_f, Trust_16_f, Trust_21_r)),
      na.rm = TRUE),
    TISS_Factor2 = rowMeans(
      across(c(Trust_01_r, Trust_02_r, Trust_04_r, Trust_05_f, Trust_06_r,
               Trust_08_r, Trust_17_r, Trust_18_r, Trust_19_r, Trust_20_r)),
      na.rm = TRUE))

# Political categories (fine-grained):
TrusSci_Clean <- TrusSci_Clean |> 
  mutate(
    PoliticalPosition2 = case_when(
      PoliticalPosition %in% 1:4 ~ "Progressive",
      PoliticalPosition %in% 5:6 ~ "Centrist",
      PoliticalPosition %in% 7:10 ~ "Conservative"))

TrusSci_Clean <- TrusSci_Clean |> 
  mutate(
    PoliticalPosition2 = factor(PoliticalPosition2, levels = c("Progressive", "Centrist", "Conservative"), ordered = TRUE))

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

# Theme for tags:
tags_cd <- function(p, tag, size = 22, x = 0, y = 1) {
  p +
    labs(tag = tag) +
    theme(
      plot.tag = element_text(size = size, face = "bold"),
      plot.tag.position = c(x, y)
    )
}

# ANALYSIS SECTION ----

## 1.- What predicts trust in science? ----

# Filter minority genders (for analyses explicitly involving 'Gender'; i.e., males and females):
TISS_Data <- TrusSci_Clean |> filter(Gender %in% c("Female", "Male"))

### 1.1.- Simple multiple regression model ----

# Run the model:
TISS_NOS_multi <- lm(TISS_Total ~ NOS_Total + DUREL_Intrins + PoliticalPosition + ClimateChangeConcern + Degree + Gender, data = TISS_Data) 

# Inspect correlation matrix:
TrusSci_Clean |>
  select(TISS_Total, NOS_Total, DUREL_Intrins, PoliticalPosition, ClimateChangeConcern) |>
  psych::pairs.panels()

# Check multicolinearity and other assumptions:
vif(TISS_NOS_multi)
performance::check_model(TISS_NOS_multi)
# OUTPUT: Looks good.

# Check the summary:
summary(TISS_NOS_multi)

# Calculate 95% confidence intervals:
confint(TISS_NOS_multi, level = 0.95)

# Standardized parameters:
effectsize::standardize_parameters(TISS_NOS_multi)

# Semi-partial R^2s of predictors:
effectsize::r2_semipartial(TISS_NOS_multi)

# Manually computing NoS' semi-partial R^2:
TISS_NOS_multi0 <- lm(TISS_Total ~ DUREL_Intrins + PoliticalPosition + ClimateChangeConcern +
                  Degree + Gender, data = TISS_Data) # Null model (without NoS)

summary(TISS_NOS_multi)$r.squared
summary(TISS_NOS_multi0)$r.squared
# OUTPUT: ~ 9% of the variance explained by NoS

### 1.2.- Model with interaction between NoS and Political ideology ----

# Run the model:
TISS_NOSPol_int <- lm(TISS_Total ~ NOS_Total * PoliticalPosition + DUREL_Intrins +
    ClimateChangeConcern + Degree + Gender, data = TISS_Data)

# Summary of the model:
summary(TISS_NOSPol_int)

# Omnibus ANOVA model:
car::Anova(TISS_NOSPol_int, type = 2)

### 1.3.- Model with interaction between NoS and Degree ----

# Run the model:
TISS_NOSDeg_int <- lm(TISS_Total ~ NOS_Total * Degree + PoliticalPosition + DUREL_Intrins +
                        ClimateChangeConcern + Gender, data = TISS_Data)

# Check the model:
summary(TISS_NOSDeg_int)

# Omnibus ANOVA model:
car::Anova(TISS_NOSDeg_int, type = 2)

### 1.4.- Figure 2: Visualizing the (absence of) interactions ----

# Interaction plots:
TISS_NOSPol_plot <- TISS_Data |> # Ideology
  ggplot(aes(x = NOS_Total, y = TISS_Total, color = PoliticalPosition2)) +
  #geom_abline(intercept = 0, slope = 1, color = "black", linetype = "dashed", linewidth = 1) +
  geom_point(alpha = 0.55, size = 2) +
  geom_smooth(aes(group = PoliticalPosition2), method = "lm", se = TRUE, linewidth = 1) +
  scale_color_manual(values = c(
    "Progressive" = "#C82909",
    "Centrist" = "#F4C10B",
    "Conservative" = "#077C9C")) +
  labs(x = "Knowledge of the nature of science", y = "Trust in science", color = NULL) +
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

TISS_NOSDeg_plot <- TISS_Data |> # Degree
  ggplot(aes(x = NOS_Total, y = TISS_Total, color = Degree)) +
  #geom_abline(intercept = 0, slope = 1, color = "black", linetype = "dashed", linewidth = 1) +
  geom_point(alpha = 0.55, size = 2) +
  geom_smooth(aes(group = Degree), method = "lm", se = TRUE, linewidth = 1) +
  scale_color_manual(values = c(
    "English" = "#F58B0A",
    "History" = "#DBDBB8",
    "Biology" = "#708E43",
    "Chemistry" = "#38598A")) +
  labs(x = "Knowledge of the nature of science", y = "Trust in science", color = NULL) +
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
  scale_x_continuous(breaks = c("1" = 1, "2" = 2, "3" = 3, "4" = 4, "5" = 5)) 

# Remove individual x-axis titles (for composed figure):
TISS_NOSPol_plot <- TISS_NOSPol_plot + # Ideology
  theme(axis.title.x = element_blank())

TISS_NOSDeg_plot <- TISS_NOSDeg_plot + # Degree
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank())

# Add histograms:
TISS_NOSPol_plot_h <- ggMarginal(TISS_NOSPol_plot, # Ideology
                                 type = "histogram",
                                 groupColour = TRUE,
                                 groupFill = TRUE,
                                 alpha = 0.25)

TISS_NOSDeg_plot_h <- ggMarginal(TISS_NOSDeg_plot, # Degree
                                 type = "histogram",
                                 groupColour = TRUE,
                                 groupFill = TRUE,
                                 alpha = 0.25)

# Convert to ggplot-compatible objects:
TISS_NOSPol_g <- ggplotify::as.ggplot( # Ideology
  TISS_NOSPol_plot_h) 

TISS_NOSDeg_g <- ggplotify::as.ggplot( # Degree
  TISS_NOSDeg_plot_h)

# Combine panels:
Combined <- cowplot::plot_grid(
  TISS_NOSPol_g,
  TISS_NOSDeg_g,
  labels = c("a", "b"),
  label_size = 22,
  label_x = 0.02,
  label_y = 0.98,
  nrow = 1,
  align = "h",
  rel_widths = c(1.1, 1))

# Figure with single x-axis title:
Figure2 <- cowplot::ggdraw() +
  cowplot::draw_plot(
    Combined,
    x = 0,
    y = 0.08,
    width = 1,
    height = 0.92) +
  cowplot::draw_label(
    "Knowledge of the nature of science",
    x = 0.5, 
    y = 0.06, 
    size = 20,
    fontfamily = "sans")

# Save the figure:
ggsave(
  filename = "Figure_02.svg",
  plot = Figure2,
  width = 250,
  height = 130,
  units = "mm")

### 1.5.- Robustness check (1): Do results replicate with TiSS-Factor 1? ----

# Run the models:
TISSf1_NOSPol_int <- lm(TISS_Factor1 ~ NOS_Total * PoliticalPosition + DUREL_Intrins +
                             ClimateChangeConcern + Degree + Gender, data = TISS_Data)

TISSf1_NOSDeg_int <- lm(TISS_Factor1 ~ NOS_Total * Degree + PoliticalPosition + DUREL_Intrins +
                          ClimateChangeConcern + Gender, data = TISS_Data)
# Check the summaries:
summary(TISSf1_NOSPol_int)
summary(TISSf1_NOSDeg_int)

# Omnibus ANOVA model (degree):
car::Anova(TISSf1_NOSDeg_int, type = 2)

### 1.6.- Robustness check (2): Do results replicate with TiSS-Factor 2? ----

# Run the models:
TISSf2_NOSPol_int <- lm(TISS_Factor2 ~ NOS_Total * PoliticalPosition + DUREL_Intrins +
                          ClimateChangeConcern + Degree + Gender, data = TISS_Data)

TISSf2_NOSDeg_int <- lm(TISS_Factor2 ~ NOS_Total * Degree + PoliticalPosition + DUREL_Intrins +
                          ClimateChangeConcern + Gender, data = TISS_Data)
# Check the summaries:
summary(TISSf2_NOSPol_int)
summary(TISSf2_NOSDeg_int)

# Omnibus ANOVA model (degree):
car::Anova(TISSf2_NOSDeg_int, type = 2)

### 1.7.- Robustness check (3): University as random factor ----

# Check samples of degrees per university:
table(TISS_Data$University, TISS_Data$Degree)

# Mixed model:
TISS_Null_Mixed <- lmer(
  TISS_Total ~ 1 + (1 | University),
  data = TISS_Data,
  REML = TRUE)

summary(TISS_Null_Mixed)

# Intraclass Correlation Coefficient:
performance::icc(TISS_Null_Mixed)

# Full model with University as random variable:
TISS_Mixed <- lmer(TISS_Total ~ NOS_Total + DUREL_Intrins + PoliticalPosition + ClimateChangeConcern +
    Degree + Gender + (1 | University), data = TISS_Data, REML = TRUE)

# Summary of the model:
summary(TISS_Mixed)

# Compare with the fixed model:
TISS_Linear <- lm(TISS_Total ~ NOS_Total + DUREL_Intrins + PoliticalPosition + ClimateChangeConcern + Degree + Gender, data = TISS_Data)

# Summary of the standard model:
summary(TISS_Linear)

# Fixed model with University as fixed factor:
TISS_Fixed <- lm(TISS_Total ~ NOS_Total + DUREL_Intrins + PoliticalPosition +
                   ClimateChangeConcern + Degree + Gender + University, data = TISS_Data)

# Summary of the fixed model:
summary(TISS_Fixed)

# ANOVA:
car::Anova(TISS_Fixed, type = 2)

# Assessment of the importance of university:
summary(TISS_Fixed)$r.squared -
  summary(TISS_Linear)$r.squared
# OUTPUT: Practically irrelevant

## 2.- Exploratory causal model ----

### 2.1.- Run the model ----

# Prepare the variables:
Causal_Data <- TISS_Data |> 
  mutate(Gender_Binary = ifelse(Gender == "Male", 1, 0),
         Degree_Score = as.numeric(Degree),
         PoliticalPosition_c = as.numeric(scale(PoliticalPosition, center = TRUE, scale = FALSE)),
         ClimateChangeConcern_c = as.numeric(scale(ClimateChangeConcern, center = TRUE, scale = FALSE)),
         DUREL_Intrins_c = as.numeric(scale(DUREL_Intrins, center = TRUE, scale = FALSE)),
         NOS_Total_c = as.numeric(scale(NOS_Total, center = TRUE, scale = FALSE)),
         TISS_Total_c = as.numeric(scale(TISS_Total, center = TRUE, scale = FALSE)))

str(Causal_Data)

AcademicItinerary_Dummy <- model.matrix(~ AcademicItinerary, data = Causal_Data)
colnames(AcademicItinerary_Dummy)
Causal_Data <- bind_cols(Causal_Data, as.data.frame(AcademicItinerary_Dummy[, -1, drop = FALSE]))

names(Causal_Data)

# Create the path model:
Path_Model <- '
  # Hypothetical educational causal chain:
  Degree_Score ~ a1*AcademicItineraryHumanities + 
    a2*AcademicItinerarySocialSciences +
    a3*AcademicItineraryTechnology + 
    a4*AcademicItineraryNaturalSciences

NOS_Total_c ~ b*Degree_Score +
  c1*AcademicItineraryHumanities + 
  c2*AcademicItinerarySocialSciences + 
  c3*AcademicItineraryTechnology + 
  c4*AcademicItineraryNaturalSciences

  # Hypothetical socio-political causal chain:
PoliticalPosition_c ~ d1*Gender_Binary +
  d2*ClimateChangeConcern_c
DUREL_Intrins_c ~ e1*Gender_Binary + 
  e2*PoliticalPosition_c

  # Final outcome:
TISS_Total_c ~ f*NOS_Total_c +
  g*PoliticalPosition_c +
  h*DUREL_Intrins_c +
  i*Degree_Score
'

# Set seed:
set.seed(12345)

# Fit the model:
Path_Fit <- sem(Path_Model, data = Causal_Data, se = "bootstrap", bootstrap = 5000)

# Summary of the model:
summary(Path_Fit, fit.measures = TRUE, standardized = TRUE, rsquare = TRUE, ci = TRUE)

# Check sample size used:
lavInspect(Path_Fit, "nobs")
# OUTPUT: Good, 1044.

# Extract the parameters:
Path_Results <- parameterEstimates(
  Path_Fit,
  standardized = TRUE,
  ci = TRUE) |>
  filter(op == "~") |>
  select(
    lhs, rhs, est, se, z, pvalue,
    ci.lower, ci.upper, std.all)

Path_Results # View it

# Set a nice format:
flextable(Path_Results)

### 2.2.- Visualize the model (Figure 3) ----

# Define readable variable labels:
Labels <- c(
  AcademicItineraryHumanities = "Humanities\nitinerary",
  AcademicItinerarySocialSciences = "Social sciences\nitinerary",
  AcademicItineraryTechnology = "Technology\nitinerary",
  AcademicItineraryNaturalSciences = "Natural sciences\nitinerary",
  Degree_Score = "Degree",
  NOS_Total_c = "Knowledge\nof NoS",
  Gender_Binary = "Gender",
  ClimateChangeConcern_c = "Climate change\nconcern",
  PoliticalPosition_c = "Political\nideology",
  DUREL_Intrins_c = "Intrinsic\nreligiosity",
  TISS_Total_c = "Trust in science")

# Create the diagram:
Path_Figure <- lavaanPlot2(model = Path_Fit, labels = Labels, stand = TRUE, coef_labels = TRUE, stars = "regress",
            graph_options = list(rankdir = "LR",
                                 nodesep = 0.9,
                                 ranksep = 1,
                                 splines = "polylines",
                                 margin = "1,1",
                                 fixedsize = FALSE),
            node_options = list(style = "rounded,filled",
                                fillcolor = "#DFD2E5",
                                color = "black", 
                                fontname = "Helvetica",
                                fontsize = 30,
                                penwidth = 3),
            edge_options = list(color = "#555555",
                                penwidth = 3,
                                arrowsize = 2, 
                                fontname = "Helvetica",
                                fontsize = 28))

# Convert to SVG:
Path_SVG <- DiagrammeRsvg::export_svg(Path_Figure)

# Save:
writeLines(Path_SVG, "Figure3.svg")

### 2.3.- Does degree predict knowledge of the nature of science? ----

# Run the model:
NOS_DegAcad <- lm(NOS_Total ~ Degree + AcademicItinerary, data = TISS_Data)

# Check summary:
summary(NOS_DegAcad)

# Perform ANOVA (omnibus assessment):
Anova(NOS_DegAcad, type = 2)

# Check assumptions:
par(mfrow = c(2, 2))
plot(NOS_DegAcad) 
par(mfrow = c(1, 1))

# Effect sizes: 
eta_squared(NOS_DegAcad, partial = FALSE)

# Post hoc tests:
emmeans(NOS_DegAcad, pairwise ~ Degree, adjust = "tukey")

# Plot: 
Figure_NoSDegree <- TISS_Data |> 
  ggplot(aes(x = Degree, y = NOS_Total, fill = Degree)) +
  geom_jitter(aes(fill = Degree), shape = 21, position = position_jitter(0.2), alpha = 0.5, color = "black") +
  geom_boxplot(alpha = 0.8, outlier.shape = NA,  staplewidth = 0.3, linewidth = 1) +
  scale_y_continuous(breaks = 1:5) +
  scale_fill_manual(values = c(
    "English" = "#F58B0A",
    "History" = "#DBDBB8",
    "Biology" = "#708E43",
    "Chemistry" = "#38598A")) +
  labs(x = "Degree", y = "Knowledge of the nature of science", color = NULL) +
  theme_cd(18) + 
  theme(legend.position = "none")

# Save the figure:
ggsave(
  filename = "Figure_NoSDegree.svg",
  plot = Figure_NoSDegree,
  width = 175,
  height = 150,
  units = "mm")

### Robustness check (University as random variable):

# Mixed model: 
NOS_Mixed <- lmer(NOS_Total ~ Degree + AcademicItinerary + (1 | University), data = TISS_Data, REML = TRUE)

# Summary:
summary(NOS_Mixed)
# OUTPUT: I would say irrelevant.

# Intraclass Correlation Coefficient:
performance::icc(NOS_Mixed)
