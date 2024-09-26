if(!require("tidyverse")) install.packages("tidyverse")

# Let's start with Fare Revenue
library(tidyverse)
if(!file.exists("2022_fare_revenue.xlsx")){
  # This should work _in theory_ but in practice it's still a bit finicky
  # If it doesn't work for you, download this file 'by hand' in your
  # browser and save it as "2022_fare_revenue.xlsx" in your project
  # directory.
  download.file("http://www.transit.dot.gov/sites/fta.dot.gov/files/2024-04/2022%20Fare%20Revenue.xlsx", 
                destfile="2022_fare_revenue.xlsx", 
                quiet=FALSE, 
                method="wget")
}
FARES <- readxl::read_xlsx("2022_fare_revenue.xlsx") |>
  select(-`State/Parent NTD ID`, 
         -`Reporter Type`,
         -`Reporting Module`,
         -`TOS`,
         -`Passenger Paid Fares`,
         -`Organization Paid Fares`) |>
  filter(`Expense Type` == "Funds Earned During Period") |>
  select(-`Expense Type`) |>
  group_by(`NTD ID`,       # Sum over different `TOS` for the same `Mode`
           `Agency Name`,  # These are direct operated and sub-contracted 
           `Mode`) |>      # of the same transit modality
  # Not a big effect in most munis (significant DO
  # tends to get rid of sub-contractors), but we'll sum
  # to unify different passenger experiences
  summarize(`Total Fares` = sum(`Total Fares`)) |>
  ungroup()

# Next, expenses
if(!file.exists("2022_expenses.csv")){
  # This should work _in theory_ but in practice it's still a bit finicky
  # If it doesn't work for you, download this file 'by hand' in your
  # browser and save it as "2022_expenses.csv" in your project
  # directory.
  download.file("https://data.transportation.gov/api/views/dkxx-zjd6/rows.csv?date=20231102&accessType=DOWNLOAD&bom=true&format=true", 
                destfile="2022_expenses.csv", 
                quiet=FALSE, 
                method="wget")
}
EXPENSES <- readr::read_csv("2022_expenses.csv") |>
  select(`NTD ID`, 
         `Agency`,
         `Total`, 
         `Mode`) |>
  mutate(`NTD ID` = as.integer(`NTD ID`)) |>
  rename(Expenses = Total) |>
  group_by(`NTD ID`, `Mode`) |>
  summarize(Expenses = sum(Expenses)) |>
  ungroup()

FINANCIALS <- inner_join(FARES, EXPENSES, join_by(`NTD ID`, `Mode`))
library(tidyverse)
if(!file.exists("2022_fare_revenue.xlsx")){
    # This should work _in theory_ but in practice it's still a bit finicky
    # If it doesn't work for you, download this file 'by hand' in your
    # browser and save it as "2022_fare_revenue.xlsx" in your project
    # directory.
    download.file("http://www.transit.dot.gov/sites/fta.dot.gov/files/2024-04/2022%20Fare%20Revenue.xlsx", 
                  destfile="2022_fare_revenue.xlsx", 
                  quiet=FALSE, 
                  method="wget"FARES <- readxl::read_xlsx("2022_fare_revenue.xlsx") |>
    select(-`State/Parent NTD ID`, 
           -`Reporter Type`,
           EXPENSES <- readr::read_csv("2022_expenses.csv") |>
             select(`NTD ID`, 
                    `Agency`,
                    `Total`, 
                    `Mode`) |>
             mutate(`NTD ID` = as.integer(`NTD ID`)) |>
             rename(Expenses = Total) |>
             group_by(`NTD ID`, `Mode`) |>
             summarize(Expenses = sum(Expenses)) |>
             ungroup()
           
           FINANCIALS <- inner_join(FARES, EXPENSES, join_by(`NTD ID`, `Mode`))                       # Not a big effect in most munis (significant DO
                             # tends to get rid of sub-contractors), but we'll sum
                             # to unify different passenger experiences
    summarize(`Total Fares` = sum(`Total Fares`)) |>
    ungroup())
}