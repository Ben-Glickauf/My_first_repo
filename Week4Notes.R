
### Creating Contingency Tables

# Categorical Data Summaries

library(tidyverse)
library(readxl)
app_data <- read_excel("app_data.xlsx", sheet = 1)
app_data <- app_data |>
  mutate(BMI = as.numeric(BMI),
         US_Number = as.character(US_Number),
         SexF = factor(Sex, levels = c("female", "male"), labels = c("Female", "Male")),
         DiagnosisF = as.factor(Diagnosis),
         SeverityF = as.factor(Severity))
app_data


# Via BaseR
table(app_data$SexF)
table(app_data$SexF, useNA = "always")
table(app_data$SexF, app_data$DiagnosisF)

two_way_sex_diag <- table(app_data$SexF, app_data$DiagnosisF)
two_way_sex_diag[,1]

table(app_data$SexF, app_data$DiagnosisF, app_data$SeverityF)
three_way <- table(app_data$SexF, app_data$DiagnosisF, app_data$SeverityF)
three_way
three_way[, , "uncomplicated"]
#or
three_way[, , 2]

three_way[, 2, 2]

#Lastly, just note that you can supply a data frame instead of the individual vectors.
table(app_data[, c("SexF", "DiagnosisF")])



# Via the tidyverse

app_data |>
  group_by(SexF) |>
  summarize(count = n())

app_data |>
  drop_na(SexF) |>
  group_by(SexF) |>
  summarize(count = n())

app_data |>
  drop_na(SexF, DiagnosisF) |>
  group_by(SexF, DiagnosisF) |>
  summarize(count = n())


# Nice. But that isn’t in the best way for viewing (i.e. a wider format would be more compact for displaying). Let’s use tidyr::pivot_wider() to fix that!

app_data |>
  drop_na(SexF, DiagnosisF) |>
  group_by(SexF, DiagnosisF) |>
  summarize(count = n()) |>
  pivot_wider(names_from = DiagnosisF, values_from = count)


app_data |>
  drop_na(SexF, DiagnosisF, SeverityF) |>
  group_by(SexF, DiagnosisF, SeverityF) |>
  summarize(count = n())

app_data |>
  drop_na(SexF, DiagnosisF, SeverityF) |>
  group_by(SexF, DiagnosisF, SeverityF) |>
  summarize(count = n()) |>
  pivot_wider(names_from = SeverityF, values_from = count)


# Making it Pretty

library(gt)

# We can use the gt() and tab_header() functions (among other things) to easily create nicer looking tables!

gt(app_data[1:10,] |>
  select(Age, Sex, Height, Severity, Diagnosis)) |>
  tab_header(title = "First 10 rows of Data",
             subtitle = "Data describes attributes of hospitalized patients")

app_data |>
  drop_na(SexF, DiagnosisF, SeverityF) |>
  group_by(SexF, DiagnosisF, SeverityF) |>
  summarize(count = n(), .groups = "drop") |>
  pivot_wider(names_from = SeverityF, values_from = count) |>
  gt(groupname_col = "SexF") |> 
  tab_header(title = "Patient Diagnosis by Severity",
             subtitle = "Stratified by Biological Sex") 

app_data |>
  drop_na(SexF, DiagnosisF, SeverityF) |>
  group_by(SexF, DiagnosisF, SeverityF) |>
  summarize(count = n(), .groups = "drop") |>
  pivot_wider(names_from = SeverityF, values_from = count) |>
  gt(groupname_col = "SexF") |> 
  tab_header(
    title = "Patient Diagnosis by Severity",
    subtitle = "Stratified by Biological Sex") |>
  cols_label(
    DiagnosisF = "Diagnosis",
    complicated = "Complicated",
    uncomplicated = "Uncomplicated"
  ) 


# We can use other functions such as sub_missing() to change the NA values and put a better label above the Complicated/Uncomplicated column headers with tab_spanner().

app_data |>
  drop_na(SexF, DiagnosisF, SeverityF) |>
  group_by(SexF, DiagnosisF, SeverityF) |>
  summarize(count = n(), .groups = "drop") |>
  pivot_wider(names_from = SeverityF, values_from = count) |>
  gt(groupname_col = "SexF") |> 
  tab_header(
    title = "Patient Diagnosis by Severity",
    subtitle = "Stratified by Biological Sex") |>
  cols_label(
    DiagnosisF = "Diagnosis",
    complicated = "Complicated",
    uncomplicated = "Uncomplicated") |>
  sub_missing(
    columns = everything(),
    missing_text = "0") |>
  tab_spanner(
    label = "Severity Levels",
    columns = c(complicated, uncomplicated)) 


# Lastly, there are functions for changing the font, width, etc. (tab_options()) and there are easy ways to change themes for the table (opt_stylize()).

app_data |>
  drop_na(SexF, DiagnosisF, SeverityF) |>
  group_by(SexF, DiagnosisF, SeverityF) |>
  summarize(count = n(), .groups = "drop") |>
  pivot_wider(names_from = SeverityF, values_from = count) |>
  gt(groupname_col = "SexF") |>
  tab_header(
    title = "Patient Diagnosis by Severity",
    subtitle = "Stratified by Biological Sex") |>
  cols_label(
    DiagnosisF = "Diagnosis",
    complicated = "Complicated",
    uncomplicated = "Uncomplicated") |>
  fmt_missing(
    columns = everything(),
    missing_text = "0") |>
  tab_spanner(
    label = "Severity Levels",
    columns = c(complicated, uncomplicated)) |>
  tab_options(
    row_group.font.weight = "bold",
    table.width = pct(80)) |>
  opt_stylize(style = 1, color = "blue")



### ggplot Themes

library(tidyverse)
library(readxl)
app_data <- read_excel("app_data.xlsx", sheet = 1)
app_data <- app_data |>
  mutate(BMI = as.numeric(BMI),
         US_Number = as.character(US_Number),
         SexF = factor(Sex, levels = c("female", "male"), labels = c("Female", "Male")),
         DiagnosisF = as.factor(Diagnosis),
         SeverityF = as.factor(Severity))

g <- ggplot(app_data |> 
              drop_na(RBC_Count, Weight, Diagnosis) |> 
              filter(RBC_Count < 8), 
            aes(x = Weight, y = RBC_Count, color = Diagnosis))
g_scatter <- g + geom_point() +  
  geom_smooth(method = lm) 
g_scatter

g_scatter +
  theme_linedraw()

# you can define your own custom theme very easily. For instance, below we create a theme ‘object’ called t (theme courtesy of a former student, John Hinic) which modifies a theme from the ggthemes package 

t <- ggthemes::theme_clean() + 
  theme(plot.background = element_rect(color = NA),
        axis.title = element_text(size = 14, face = "bold"),
        axis.text = element_text(size = 11),
        legend.background = element_rect(color = NA),
        legend.position = 'top',
        legend.justification.top = 'left',
        legend.location = 'plot',
        legend.text = element_text(size = 12),
        legend.margin = margin(0, 0, 0, 0),
        plot.title.position = 'plot',
        strip.text = element_text(size = 14, face = "bold"))

# Now we can apply this theme using the usual + syntax from ggplot2.

g_scatter + t


## patchwork Package

# We saw that we can use facet_wrap() and facet_grid() to make plots laid out in a pretty nice way. However, this generally is done using the same type of plot across a categorical variable. Sometimes we want to put different plot types next to each other.

# The patchwork package (likely must be installed to use) is a great package for putting ggplots next to each other in useful ways! We can simply use + to separate plot objects we want next to each other.

library(patchwork)
g_scatter_custom <- g_scatter + t
g_density <- g + 
  geom_density_2d() +
  t
g_density + g_scatter_custom


# We can also place a plot below others if we want using (objects...)/(objects).

g2 <- ggplot(app_data |> 
               drop_na(RBC_Count, Weight, Diagnosis) |> 
               filter(RBC_Count < 8, Diagnosis == "appendicitis"), 
             aes(x = Weight, y = RBC_Count))
g_density_append <- g2 + 
  geom_density_2d(color = "red") + 
  t
g3 <- ggplot(app_data |> 
               drop_na(RBC_Count, Weight, Diagnosis) |> 
               filter(RBC_Count < 8, Diagnosis == "no appendicitis"), 
             aes(x = Weight, y = RBC_Count))
g_density_noappend <- g3 + 
  geom_density_2d() + 
  t
(g_density_append + g_density_noappend)/g_scatter_custom

