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
  c
  (
   010 1",  "010 56,  "00 14" , "01 06 ", "0 017", "0606 ", "0 038  ", "06   74",
    02039",  "04078",  "02040"   "04086"  "02043 , "01093 "  "01052"  , "06097",  "02102",
  "02103", "02  104", "0 6111  "
, "
06"
)


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

save(demog, atcd, bio1, ttconsupp,
  visiteJ01, visiteJ02, visiteJ1, visiteJ2, visit5 visitem2, visitem
3
,
  file = "datas/cavithy.R
Da
ta"
)
load("datas/cavithy.RData")
