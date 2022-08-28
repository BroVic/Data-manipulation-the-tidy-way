library(tidyverse)
# library(dplyr)
### Selection features 
# - :, !, & and |, c()  

olympic_data2_long %>% 
  select(Country,`ISO Code`,Region,Position,Year) %>% View()

olympic_data2_long %>% 
  select(1:3,12:13)

olympic_data2_long %>% 
  select(Country,`ISO Code`,Region,Position,Year)

olympic_data2_wide %>% 
  select(-`Year 2020`, -`Year 2019`) %>% View()

olympic_data2_wide %>% 
  select(!c(`Year 2020`, `Year 2019`)) %>% View()

# wrong
olympic_data2_wide %>%
  select(!`Year 2020`, !`Year 2019`) %>% View()


### Helpers functions
# - everything(),last_col(),starts_with(),ends_with(),contains(),matches(),
# all_of(), any_of(), where(), num_range()

olympic_data2_wide %>% 
  select(everything()) %>% View()


olympic_data2_wide %>% 
  select(last_col()) %>% View()


olympic_data2_wide %>% 
  # select the last column before the last 5 columns
  select(last_col(5)) %>% View()

olympic_data2_wide %>% 
  # select the first to the column before the last 5 columns
  select(1:last_col(5)) %>% View()

olympic_data2_wide %>% 
  # select the first to the column before the last 5 columns
  select(-c(Situation:`Year 2019`)) %>% View()


olympic_data1 %>% 
  # column name starts with sum
  select(starts_with("sum")) %>% View()

olympic_data1 %>% 
  # column name starts with sum
  select(starts_with("summer")) %>% View()

olympic_data1 %>% 
  # columns name starts with summer or winter
  select(starts_with(c("summer", "winter"))) %>% View()

olympic_data1 %>% 
  # columns name ends with total
  select(!ends_with("total")) %>% View()

olympic_data1 %>% 
  select(starts_with(c("summer", "winter")) & !ends_with("total")) %>% 
  View()

olympic_data1 %>% 
  # columns name contains "in" i.e. countries, winter_
  # what is the output?
  select(contains("in")) %>% View()

olympic_data1 %>% 
  # columns name contains "ter" 
  # what is the output?
  select(contains("ter")) %>% View()

olympic_data1 %>% 
  # columns name contains "u" i.e. countries, winter_
  # what is the output?
  select(contains("u")) %>% View()


# interpreted as a regular expression
olympic_data1 %>% select(matches("ter|tot")) %>% View()

billboard %>% select(num_range("wk", 10:15))

olympic_data1 %>% select(where(is.numeric)) %>% View()


# slice()
# Return the last row i.e.Similar to tail(olympic_data1, 1):
olympic_data1 %>% slice(n())

tail(olympic_data1, 1)
# return all rows from row 5 to the last row
olympic_data1 %>% slice(5:n())

# Rows can be dropped with negative indices:
# Drop first 4 rows
slice(olympic_data1, -(1:4))


# rename()
rename(olympic_data1, Countries = countries)

olympic_data1 %>%
  rename(Countries = countries,
         IOC_Code = ioc_code) %>% View()

olympic_data1 %>%
  rename(c(Countries = countries,
           IOC_Code = ioc_code)) %>% View()

olympic_data1 %>% 
  rename_with(toupper)
olympic_data1 %>% 
  rename_with(toupper, starts_with(c("summer","winter"))) %>% View()

## mutate()
# Newly created variables are available immediately
olympic_data1_long %>%
  mutate(
    total_medals = rowSums(olympic_data1_long[,c(5:7)])
  )
#olympic_data1_long %>% select(max(ncol(olympic_data1_long)))

# As well as adding new variables, you can use mutate() to
# remove variables and modify existing variables.
olympic_data1_long %>%
  mutate(
    participations = NULL,
    # rowSums(.)
    total_medals = rowSums(olympic_data1_long[,c(5:7)])
  )

olympic_data1_long$participations <- NULL

# Use across() with mutate() to apply a transformation
# to multiple columns in a tibble.
olympic_data1_long %>%
  select(1:3) %>%
  mutate(across(where(is.character), as.factor))

# By default, new columns are placed on the far right.
# override with `.before` or `.after`
olympic_data1_long %>%
  mutate(
    total_medals = rowSums(olympic_data1_long[,c(4:6)]),
    # rowSums(.)
    pct_gold_medals = replace_na((gold/total_medals)*100, 0), .before = 1
  )

# wrong
# olympic_data1_long %>%
#   mutate(
#     total_medals = rowSums(olympic_data1_long[,c(5:7)]), .after = -1,
#     # rowSums(.)
#     pct_gold_medals = replace_na((gold/total_medals)*100, 0), .before = 1
#   )

# correct
olympic_data1_long %>%
  mutate(
    participations = NULL,
    # place after the last column
    total_medals = rowSums(olympic_data1_long[,c(4:6)]), .after = -1) %>% 
  mutate(pct_gold_medals = replace_na((gold/total_medals)*100, 0), .before = 1
  ) %>% View()


# filter()

# Filtering by one criterion
filter(olympic_data1_long, season == "winter")
filter(olympic_data1_long, gold > 20)

# Filtering by multiple criteria within a single logical expression
filter(olympic_data1_long, season == "winter" & gold > 20)
filter(olympic_data1_long, season == "winter" | gold > 20)

# When multiple expressions are used, they are combined using &
filter(olympic_data1_long, season == "winter", gold > 20)


# The filtering operation may yield different results on grouped
# tibbles because the expressions are computed within groups.
#
# The following filters rows where `gold` is greater than the
# global average:
olympic_data1_long %>% filter(gold > mean(gold, na.rm = TRUE))

# Whereas this keeps rows with `mass` greater than the gender
# average:
olympic_data1_long %>% group_by(season) %>% filter(gold > mean(gold, na.rm = TRUE))


# Efficiently count the number of unique values in a set of vectors
# n_distinct(..., na.rm = FALSE)  
# better replacement for length(unique(x)), takes care of NAs
n_distinct(olympic_data1_long$countries)


count()

distinct()

# summarise()
### Useful functions

# Center: mean(), median()
olympic_data1_long %>%
  group_by(season) %>%
  summarise(avg_no_gold = mean(gold), 
            avg_no_silver = mean(silver), 
            avg_no_bronze = mean(bronze))


# arrange()
olympic_data1_long %>%
  mutate(
    total_medals = rowSums(olympic_data1_long[,c(5:7)]), .after = 2) %>% 
  arrange(total_medals)
  # arrange(desc(total_medals))













