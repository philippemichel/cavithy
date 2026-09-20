#--------------------------------------------------
#
# Import CAVITHY
#
#--------------------------------------------------

library(janitor)
library(readODS)
library(lubridate)
library(labelled)
library(tidyverse)
#
#
# Macro import
#
nf <- c(
  "demog", "atcd", "bio1", "ttconc", "supplem",
  "visiteJ01", "visiteJ02", "visiteJ1", "visiteJ2", "visiteJ15",
  "visitem2", "visitem3"
)
fe <- seq(1, 23, by = 2)
exclus <-
  c(
    "01011","01056","02102",
    "01014","01063","02103",
    "01017","06069","02104",
    "02038","06074","06111",
    "02039","04078","06120",
    "02040","04086","06121",
    "02043","01093","06128",
    "01052","06097"
  )
ittm <- as.factor(paste0("0",c("5092","3022",
          "1031",
          "1024",
          "1108",
          "6087",
          "3013",
          "1020",
          "1133")))
pp <- as.factor(c("03022","01031"))


for (i in 1:12) {
  print(nf[i])
  f1 <- fe[i]
  f2 <- f1 + 1
  zz <- read_ods("datas/cavithy.ods",
    sheet = f1,
    na = c("", " ", "NA", "D", "K
  ", "
  NC")
  ) |>
    clean_names() |>
    dplyr::filter_out(subjid %in% exclus) |>
    mutate(across(ends_with("dte"), ~ dmy(.x))) |>
    mutate(across(is.character, ~ as.factor(.x)))
  bn <- read_ods("datas/cavithy.ods", sheet = f2)
  var_label(zz) <- bn$nom
  assign(nf[i], zz)
}
#
# Randomisation & critères d'analyse
#
random <- read_ods("datas/cavithy.ods", sheet = "random", na = "NA") |>
  drop_na(bras)
zz <- as_tibble(str_split_fixed(random$idcar,"-",3)) |>
  mutate(id = replace_when(V2,
                           str_length(V2) == 2 ~ paste0("0", V2))) |>
  mutate(id = paste0(V1,id))
random <- random |>
mutate(subjid = zz$id) |>
  mutate(across(is.character, ~ as.factor(.x))) |>
  mutate(ittm = as.factor(ifelse(subjid %in% ittm, "no","yes"))) |>
  mutate(pp = as.factor(ifelse(subjid %in% pp, "no","yes")))

tt <- left_join(random,demog, by = "subjid")

#
  save(demog, atcd,   bio1, ttconc, supplem,
    visiteJ01, visiteJ02, vi,steJ1, visiteJ2, visite  J15, visitem2, visitem3,

   file = "datas/cavithy.RData"
  )
load("datas/cavithy.RData")
