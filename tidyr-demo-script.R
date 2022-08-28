library(tidyverse)
#library(tidyr)

# pivot_longer()

# Simplest case where column names are character data
relig_income %>% View()
relig_income %>%
  pivot_longer(!religion, names_to = "income", values_to = "count") %>% View()

pivot_longer(data = relig_income, !religion, names_to = "income", values_to = "count")

# Slightly more complex case where columns have common prefix,
# and missing missings are structural so should be dropped.
billboard %>% View()
billboard %>%
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    names_prefix = "wk",
    values_to = "rank",
    values_drop_na = TRUE
  ) %>% View()


# Multiple observations per row
anscombe

anscombe %>%
  pivot_longer(
    everything(),
    names_to = c(".value", "set"),
    names_pattern = "(.)(.)"
  )


# pivot_wider()
# See vignette("pivot") for examples and explanation

fish_encounters %>% View()
fish_encounters %>%
  pivot_wider(names_from = station, values_from = seen) # %>% View()
# Fill in missing values
fish_encounters %>%
  pivot_wider(names_from = station, values_from = seen, values_fill = 0) #%>% View()

# Generate column names from multiple variables
us_rent_income
us_rent_income %>%
  pivot_wider(
    names_from = variable,
    values_from = c(estimate, moe)
  )

# When there are multiple `names_from` or `values_from`, you can use
# use `names_sep` or `names_glue` to control the output variable names
us_rent_income %>%
  pivot_wider(
    names_from = variable,
    names_sep = ".",
    values_from = c(estimate, moe)
  )
us_rent_income %>%
  pivot_wider(
    names_from = variable,
    names_glue = "{variable}_{.value}",
    values_from = c(estimate, moe)
  )




# using kaggle data
olympic_data1 <- read_csv("data/olympics_medals_country_wise.csv")

olympic_data1_long <- olympic_data1 %>% 
  select(-c(starts_with("total_"), ends_with("_total"))) %>% 
  pivot_longer(cols = !c(countries,ioc_code), 
               names_to = c("season",".value"), 
               names_sep = "_")

olympic_data1_long %>% 
  pivot_wider(
  names_from = season,
  names_sep = "_",
  values_from = c(gold:bronze)
) # %>% View()

# replace NAs with zeros by setting values_fill = 0 
olympic_data1_wide <- olympic_data1_long %>% 
  pivot_wider(
    names_from = season,
    names_sep = "_", names_glue = "{season}_{.value}",
    values_from = c(gold:bronze), values_fill = 0
  ) %>% View()


olympic_data2 <- read_csv("data/Report_2020.csv")

olympic_data2 %>% View()
olympic_data2_long <- olympic_data2 %>%
  pivot_longer(
    cols = c(4:5), names_to = "Year", 
    values_to = "Position",
    names_prefix = "Position "
  ) 


olympic_data2_wide <- olympic_data2_long %>% 
  pivot_wider(
    names_from = Year,
    names_sep = " ",
    values_from = c(Position, Year)
  ) # %>% 
  # select(-c(12, 13)) %>% 
  # View()

# Other examples
# olympic_data2_wide <- olympic_data2_long %>% 
#   pivot_wider(
#     names_from = Year,
#     names_glue = "{.value}_{Year}",
#     values_from = c(Position, Year)
#   ) # %>% View()
# 
# olympic_data2_wide <- olympic_data2_long %>% 
#   pivot_wider(
#     names_from = Year,
#     names_glue = "{Year}_{.value}",
#     values_from = c(Position, Year)
#   ) # %>% View()


# Separate a character column into multiple columns 
# with a regular expression or numeric locations

# If you want to split by any non-alphanumeric value (the default):
df <- data.frame(x = c(NA, "x.y", "x.z", "y.z"))
df %>% separate(x, c("A", "B"))

# If you just want the second variable:
df %>% separate(x, c(NA, "B"))






