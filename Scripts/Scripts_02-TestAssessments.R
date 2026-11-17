############ TrustInScience - Test assessments ###############

# BASIC INFO ----

# Section aim: Assess the psychometric properties of the three test used: TiSS, NoS, and DUREL.
# Date start: 2026-05-05
# Last update: 2026-11-08 

# SETUP SECTION ----

## 1.- Packages ----
library(tidyverse) # Basic plots and statistical analyses
library(psych) # Test assessment techniques
library(lavaan) # EFA and CFA

## 2.- Dataset loading ----
TrusSci <- read.csv("Data_01.csv")

## 3.- Data handling and overview ----

# Load and set shortcut for the dataset: 

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

## 1.- Trust in Science and Scientists (TiSS) inventory ----

### 1.1.- Item descriptives ----

# Create a category of TiSS items:
TISS_Items <- grep("^Trust_[0-9]", names(TrusSci_Clean), value = TRUE) 

# Provide summary statistics:
psych::describe(TrusSci_Clean[TISS_Items])

# Create total score:
TrusSci_Clean <- TrusSci_Clean |>
  mutate(
    TISS_Total = rowMeans(pick(starts_with("Trust_")), na.rm = TRUE))

# Summary statistics of total test score:
psych::describe(TrusSci_Clean$TISS_Total)

### 1.2.- Reliability ----

#### 1.2.1.- McDonald's Omega and Cronbach's alpha ----

# Omega:
psych::omega(TrusSci_Clean[TISS_Items], plot = TRUE)

# Alpha (total sample): 
psych::alpha(TrusSci_Clean[TISS_Items], 
             check.keys = FALSE) 

# Alpha (by degree):
psych::alpha(subset(TrusSci_Clean, Degree == "Biology")[TISS_Items])
psych::alpha(subset(TrusSci_Clean, Degree == "Chemistry")[TISS_Items])
psych::alpha(subset(TrusSci_Clean, Degree == "English")[TISS_Items])
psych::alpha(subset(TrusSci_Clean, Degree == "History")[TISS_Items])

#### 1.2.2.- Inspection of item #13 (Not featured in manuscript) ----

# Inspect all items:
psych::alpha(TrusSci_Clean[TISS_Items], 
             check.keys = FALSE) 
# OUTPUT: Confirms that item #13 is weird

# Create a set with all items except #13:
TISS_Items_no13 <- setdiff(TISS_Items, "Trust_13_r")

# McDonald's Omega: 
psych::omega(TrusSci_Clean[TISS_Items], plot = TRUE) # With item
psych::omega(TrusSci_Clean[TISS_Items_no13], plot = TRUE) # Without it

# Item inspection:
psych::alpha(TrusSci_Clean[TISS_Items], # With item
             check.keys = FALSE)

psych::alpha(TrusSci_Clean[TISS_Items_no13], # Without it
             check.keys = FALSE) 

# Parallel analysis scree plots:
fa.parallel(TrusSci_Clean[TISS_Items], fa = "fa", cor = "poly") # With item
fa.parallel(TrusSci_Clean[TISS_Items_no13], fa = "fa", cor = "poly") # Without it

# Total scores' comparison:
TrusSci_Clean$TISS_Total_no13 <- rowMeans(TrusSci_Clean[TISS_Items_no13], na.rm = TRUE)

cor.test(TrusSci_Clean$TISS_Total,
         TrusSci_Clean$TISS_Total_no13)
# OUTPUT: The item doesn't do any harm to the questionnaire, so it was kept.

### 1.3.- Dimensionality ----

#### 1.3.1.- Bartlett and KMO ----

# With Pearson correlations:
TISS_Bartlett <- cor(TrusSci_Clean[TISS_Items], use = "pairwise.complete.obs")

cortest.bartlett(TISS_Bartlett, n = nrow(TrusSci_Clean))

KMO(TISS_Bartlett)

# With polychoric correlations:
TISS_Poly <- psych::polychoric(
  TrusSci_Clean[TISS_Items])$rho

KMO(TISS_Poly)

#### 1.3.2.- Parallel analysis scree plots -----
fa.parallel(TrusSci_Clean[TISS_Items], fa = "fa", cor = "poly")

#### 1.3.3.- Exploratory factor analysis ----

# Two-factor solution:
TISS_efa2 <- fa(TrusSci_Clean[TISS_Items],
                nfactors = 2, 
                rotate = "oblimin",
                fm = "minres",
                cor = "poly") # Polychoric correlation (advisable for ordinal variables)

print(TISS_efa2, cut = 0.30)

# Three-factor solution:
TISS_efa3 <- fa(TrusSci_Clean[TISS_Items],
                nfactors = 3, 
                rotate = "oblimin",
                fm = "minres",
                cor = "poly") # Polychoric correlation (advisable for ordinal variables)

print(TISS_efa3, cut = 0.30)

# Comparing factor structures:
TISS_efa2$RMSEA
TISS_efa3$RMSEA

TISS_efa2$TLI
TISS_efa3$TLI

TISS_efa2$rms
TISS_efa3$rms

TISS_efa2$Vaccounted
TISS_efa3$Vaccounted

TISS_efa2$Phi
TISS_efa3$Phi
# OUTPUT: Let's keep the 2-factor structure out of parsimony considerations (see Supporting information file).

#### 1.3.4.- Reliability of factors ----

# Create item lists:
TISS_Factor1_Items <- c("Trust_03_r", "Trust_07_f", "Trust_09_f", "Trust_10_f", "Trust_11_f",
                         "Trust_12_f", "Trust_14_f", "Trust_15_f", "Trust_16_f", "Trust_21_r")

TISS_Factor2_Items <- c("Trust_01_r", "Trust_02_r", "Trust_04_r", "Trust_05_f", "Trust_06_r",
                         "Trust_08_r", "Trust_17_r", "Trust_18_r", "Trust_19_r", "Trust_20_r")

# Cronbach's alpha:
TISS_Factor1_alpha <- psych::alpha(TrusSci_Clean[TISS_Factor1_Items], check.keys = FALSE)
TISS_Factor2_alpha <- psych::alpha(TrusSci_Clean[TISS_Factor2_Items], check.keys = FALSE)

TISS_Factor1_alpha 
TISS_Factor2_alpha

# Mcdonald's Omega:
TISS_Factor1_omega <- psych::omega(TrusSci_Clean[TISS_Factor1_Items], plot = FALSE)
TISS_Factor2_omega <- psych::omega(TrusSci_Clean[TISS_Factor2_Items], plot = FALSE)

TISS_Factor1_omega
TISS_Factor2_omega

#### 1.3.5.- Confirmatory factor analysis ----

# Select factor items:
TISS_cfa <- 'Factor1 =~
Trust_03_r + Trust_07_f + Trust_09_f + Trust_10_f +
Trust_11_f + Trust_12_f + Trust_14_f + Trust_15_f +
Trust_16_f + Trust_21_r

Factor2 =~
Trust_01_r + Trust_02_r + Trust_04_r + Trust_05_f +
Trust_06_r + Trust_08_r + Trust_17_r + Trust_18_r +
Trust_19_r + Trust_20_r'

# Perform the test:
TISS_cfa_fit <- cfa(TISS_cfa,
                data = TrusSci_Clean,
                ordered = c(TISS_Factor1_Items,
                            TISS_Factor2_Items))

# Summary of CFA:
summary(TISS_cfa_fit, fit.measures = TRUE, standardized = TRUE)

# Clearer summary:
fitMeasures(TISS_cfa_fit, c("cfi", "tli", "rmsea", "srmr", "chisq", "df", "pvalue"))

#### 1.3.6.- Resulting average factor scores ----
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

## 2.- Nature of Science (NoS) inventory ----

### 2.1.- Item descriptives ----

#### 2.1.1.- Basic description ----

# Create a category of NoS items:
NOS_Items <- grep("^NOS_[0-9]", names(TrusSci_Clean), value = TRUE) 

# Provide summary statistics:
psych::describe(TrusSci_Clean[NOS_Items])

# Create total score:
TrusSci_Clean <- TrusSci_Clean |>
  mutate(
    NOS_Total = rowMeans(pick(starts_with("NOS_")), na.rm = TRUE))

# See the central tendency values:
psych::describe(TrusSci_Clean$NOS_Total)

#### 2.1.2.- Description according to themes in Lombrozo et al. (2008) ----

# Name the themes (according to Lombrozo et al. 2008):
NOS_Themes <- list(
  TheorySupport  = c("NOS_01_f", "NOS_02_r"),
  TheoryLimits   = c("NOS_03_f", "NOS_04_r"),
  Testing        = c("NOS_05_f", "NOS_06_r"),
  Nonlinearity   = c("NOS_07_f", "NOS_08_r"),
  Construction   = c("NOS_09_f", "NOS_10_r"),
  Provisionality = c("NOS_11_f", "NOS_12_r"),
  Continuity     = c("NOS_13_f", "NOS_14_r"),
  Comparison     = c("NOS_15_f", "NOS_16_r"),
  Creativity     = c("NOS_17_f", "NOS_18_r"),
  Community      = c("NOS_19_f", "NOS_20_r"),
  Applications   = c("NOS_21_f", "NOS_22_r"),
  SocietyCulture = c("NOS_23_f", "NOS_24_r"))

# Compute means and SDs:
Theme_Descriptives <-
  purrr::map_dfr(
    names(NOS_Themes),
    function(theme){
      
      vars <- NOS_Themes[[theme]]
      
      scores <- rowMeans(TrusSci_Clean[vars])
      
      tibble(
        Theme = theme,
        Mean  = mean(scores),
        SD    = sd(scores)
      )
    }
  )

#Theme_Descriptives # View the means and SDs

# Correlations between items comprising themes:
Theme_Correlations <-
  purrr::map_dfr(
    names(NOS_Themes),
    function(theme){
      
      vars <- NOS_Themes[[theme]]
      
      test <- cor.test(
        TrusSci_Clean[[vars[1]]],
        TrusSci_Clean[[vars[2]]],
        method = "spearman",
        exact = FALSE
      )
      
      tibble(
        Theme = theme,
        rho = unname(test$estimate),
        p = test$p.value
      )
    }
  )

#Theme_Correlations # View Spearman's correlations

# Descriptive table of themes:
Theme_Table <-
  Theme_Descriptives |>
  dplyr::left_join(Theme_Correlations, by = "Theme") 

Theme_Table # View the table

### 2.2.- Reliability ----

#### 2.2.1.- McDonald's Omega and Cronbach's Alpha ----

# Omega:
psych::omega(TrusSci_Clean[NOS_Items], plot = TRUE)

# Alpha (total sample):
psych::alpha(TrusSci_Clean[NOS_Items], 
             check.keys = FALSE) 

# Alpha (by degree):
psych::alpha(subset(TrusSci_Clean, Degree == "Biology")[NOS_Items])
psych::alpha(subset(TrusSci_Clean, Degree == "Chemistry")[NOS_Items])
psych::alpha(subset(TrusSci_Clean, Degree == "English")[NOS_Items])
psych::alpha(subset(TrusSci_Clean, Degree == "History")[NOS_Items])

#### 2.2.2.- Inspection of item #6 (not featured in the manuscript) ----

# Run the alpha again:
NOS_alpha <- psych::alpha(TrusSci_Clean[NOS_Items], check.keys = FALSE)

# Now inspect only item #6:
NOS_alpha$item.stats[6, ]
NOS_alpha$alpha.drop[6, ]
# OUTPUT: Removing the item only increased the reliability slightly (raw.alpha = 0.76), so despite its problems we decided to keep it.

### 2.3.- Dimensionality ----

#### 2.3.1.- Bartlett and KMO ----
NOS_Bartlett <- cor(TrusSci_Clean[NOS_Items], use = "pairwise.complete.obs")

cortest.bartlett(NOS_Bartlett, n = nrow(TrusSci_Clean))

KMO(NOS_Bartlett)

#### 2.3.2.- Parallel analysis scree plots -----
fa.parallel(TrusSci_Clean[NOS_Items], fa = "fa", cor = "poly")

#### 2.3.3.- Exploratory factor analysis ----

# Two-factor solution:
NOS_efa2 <- fa(TrusSci_Clean[NOS_Items],
                nfactors = 2, 
                rotate = "oblimin",
                fm = "minres",
                cor = "poly") # Polychoric correlation (advisable for ordinal variables)

print(NOS_efa2, cut = 0.30)

# Three-factor solution:
NOS_efa3 <- fa(TrusSci_Clean[NOS_Items],
                nfactors = 3, 
                rotate = "oblimin",
                fm = "minres",
                cor = "poly") # Polychoric correlation (advisable for ordinal variables)

print(NOS_efa3, cut = 0.30)

# Four-factor solution:
NOS_efa4 <- fa(TrusSci_Clean[NOS_Items],
               nfactors = 4, 
               rotate = "oblimin",
               fm = "minres",
               cor = "poly") # Polychoric correlation (advisable for ordinal variables)

print(NOS_efa4, cut = 0.30)

# Comparing factor structures:
NOS_efa2$RMSEA
NOS_efa3$RMSEA
NOS_efa4$RMSEA

NOS_efa2$TLI
NOS_efa3$TLI
NOS_efa4$TLI

NOS_efa2$rms
NOS_efa3$rms
NOS_efa4$rms

NOS_efa2$Vaccounted
NOS_efa3$Vaccounted
NOS_efa4$Vaccounted

NOS_efa2$Phi
NOS_efa3$Phi
NOS_efa4$Phi
# OUTPUT: The 4-factor solution is the one that performs best.

#### 2.3.4.- Information table (4-factor solution) ----

# Specify item meanings and themes:
NOS_ItemInfo <- tibble::tribble(
  ~Item, ~Meaning, ~Theme,
  "NOS_01_f", "To be accepted, scientific theories must be supported by much evidence", "Theory support",
  "NOS_02_r", "New hypotheses are basically wild guesses; scientists just dream them up", "Theory support",
  "NOS_03_f", "Accepted scientific theories are well-supported explanations for a broad set of natural phenomena", "Theory limits",
  "NOS_04_r", "Theories are [not] basically hunches; they have [not yet] accumulated enough supporting evidence to be considered hypotheses", "Theory limits",
  "NOS_05_f", "The same hypothesis or theory is often tested in many different ways", "Testing",
  "NOS_06_r", "Scientific investigations could not proceed without laboratory experiments", "Testing",
  "NOS_07_f", "The process of science is nonlinear; each step can lead to many possible next steps", "Nonlinearity",
  "NOS_08_r", "Scientists always follow the same step-by-step scientific method", "Nonlinearity",
  "NOS_09_f", "Scientific knowledge is built through a complex process that relies, in part, on observations of nature", "Construction",
  "NOS_10_r", "Scientific knowledge [not] is deduced directly from observations of nature", "Construction",
  "NOS_11_f", "Scientific theories are subject to ongoing testing and revision", "Provisionality",
  "NOS_12_r", "Scientific theories based on accurate experimentation will [not] be changed", "Provisionality",
  "NOS_13_f", "Scientific investigations usually lead to additional questions for further investigation", "Continuity",
  "NOS_14_r", "Scientific investigations usually [don't] come to a definitive end, allowing the science to move on to a brand new question", "Continuity",
  "NOS_15_f", "The aim of scientific testing is to figure out which explanation for a phenomenon is most likely to be correct", "Comparison",
  "NOS_16_r", "Scientists usually investigate one hypothesis thoroughly before thinking about alternative explanations", "Comparison",
  "NOS_17_f", "Scientists use their imagination and creativity when they come up with new experiments, hypotheses, and theories", "Creativity",
  "NOS_18_r", "Scientists do not use their imagination and creativity because these can interfere with objectivity", "Creativity",
  "NOS_19_f", "The scientific community is essential to the process and progress of science", "Community",
  "NOS_20_r", "Unlike many other professions, science is almost always a solitary endeavor", "Community",
  "NOS_21_f", "Everyday problems and observations frequently inspire scientific investigations", "Applications",
  "NOS_22_r", "Science is pure; scientists strive to do their work without considering its potential applications", "Applications",
  "NOS_23_f", "Individual scientists are influenced by their societies and cultures, and this, in turn, influences their scientific work", "Society & culture",
  "NOS_24_r", "Scientific research is not influenced by society and culture because scientists are trained to conduct “pure”, unbiased studies", "Society & culture")

# Extract the EFA results:
NOS_Loadings <-
  as.data.frame(unclass(NOS_efa4$loadings)) |>
  rownames_to_column("Item") |>
  mutate(
    h2 = NOS_efa4$communality,
    u2 = NOS_efa4$uniquenesses)

# Create the table:
NOS_EFA_Table <-
  NOS_ItemInfo |>
  left_join(NOS_Loadings, by = "Item") |>
  mutate(
    across(c(MR1:MR4, h2, u2), ~round(.x, 2)))

# Suppress loadings below 0.3 for better visualization:
NOS_EFA_Table <-
  NOS_EFA_Table |>
  mutate(
    across(
      MR1:MR4,
      ~ifelse(abs(.) < .30, "", sprintf("%.2f", .))))

print(NOS_EFA_Table, n = 24)

#### 2.3.5.- Reliability of factors ----

# Create item lists:
NOS_Factor1_Items <- c("NOS_01_f", "NOS_02_r", "NOS_03_f", "NOS_04_r", "NOS_05_f",
                       "NOS_06_r", "NOS_07_f", "NOS_09_f", "NOS_11_f", "NOS_13_f",
                       "NOS_15_f", "NOS_19_f", "NOS_20_r", "NOS_21_f")

NOS_Factor2_Items <- c("NOS_17_f", "NOS_18_r")
NOS_Factor3_Items <- c("NOS_23_f", "NOS_24_r")
NOS_Factor4_Items <- c("NOS_10_r", "NOS_12_r", "NOS_14_r", "NOS_16_r", 
                       "NOS_22_r")

# Cronbach's alpha:
NOS_Factor1_alpha <- psych::alpha(TrusSci_Clean[NOS_Factor1_Items], check.keys = FALSE)
NOS_Factor2_alpha <- psych::alpha(TrusSci_Clean[NOS_Factor2_Items], check.keys = FALSE)
NOS_Factor3_alpha <- psych::alpha(TrusSci_Clean[NOS_Factor3_Items], check.keys = FALSE)
NOS_Factor4_alpha <- psych::alpha(TrusSci_Clean[NOS_Factor4_Items], check.keys = FALSE)

NOS_Factor1_alpha 
NOS_Factor2_alpha
NOS_Factor3_alpha
NOS_Factor4_alpha

# Mcdonald's Omega:
NOS_Factor1_omega <- psych::omega(TrusSci_Clean[NOS_Factor1_Items], plot = FALSE)
NOS_Factor2_omega <- psych::omega(TrusSci_Clean[NOS_Factor2_Items], plot = FALSE)
NOS_Factor3_omega <- psych::omega(TrusSci_Clean[NOS_Factor3_Items], plot = FALSE)
NOS_Factor4_omega <- psych::omega(TrusSci_Clean[NOS_Factor4_Items], plot = FALSE)

NOS_Factor1_omega
NOS_Factor2_omega
NOS_Factor3_omega
NOS_Factor4_omega

## 3.- Duke Religion (DUREL) index ----

### 3.1.- Item descriptives ----

# Create a category of DUREL items:
DUREL_Items <- grep("^DUREL_[0-9]", names(TrusSci_Clean), value = TRUE) 

# Provide summary statistics:
psych::describe(TrusSci_Clean[DUREL_Items])

# Create total score:
TrusSci_Clean <- TrusSci_Clean |>
  mutate(
    DUREL_Total = rowMeans(
      pick(matches("^DUREL_[0-9]{2}$")), na.rm = TRUE))

# Summary statistics of total test score:
psych::describe(TrusSci_Clean$DUREL_Total)

# Separating test subscales:
TrusSci_Clean <- TrusSci_Clean |> 
  mutate(
    DUREL_Org = DUREL_01, # Institutional religiosity
    DUREL_Beh = DUREL_02, # Behavioral religiosity
    DUREL_Intrins = rowMeans(across(c(DUREL_03, DUREL_04, DUREL_05)), na.rm = TRUE)) # Intrinsic religiosity

### 3.2.- Reliability (intrinsic religiosity subscale) ----

#### 3.2.1.- Cronbach's alpha ----
psych::alpha(TrusSci_Clean[c("DUREL_03", "DUREL_04", "DUREL_05")], check.keys = FALSE)

#### 3.2.2.- Inter-item correlations ----
psych::polychoric(TrusSci_Clean[c("DUREL_03", "DUREL_04", "DUREL_05")])$rho
