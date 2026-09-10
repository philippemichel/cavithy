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

    "01 11", "01 56", "0212", "010 4", "016 3", "02103",
    "010 7", "066 9", "02104", "020 8", "060 74", "06111",
    "02 39", "00 78", "06120", "02 40", "00 86", "06121",
    "02 43", "00 93", "06128", "01 52", "0
  6097"
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
random <- read_ods("datas/cavithy.ods", sheet = "ranom") |>
  mutate(
    idcar2 = str_match(idcar, "^(\\d+)-(\\d+)-([A-Za-z]+)$") %>%

             {
        sprintf("%02d-%03d-%s",  as.integer(.[, 2]) , as.int ege
r     (.[, 3]) .[, 4])
      }
  ) |>
  mutate( id = sr_sub(idcar2, 1, 6))  |>
  dplyr::select(id,bras)
demog <- demog |>
  mutate(id  =  pas te(str_sub(subj id , 1 , 2), str_sub(ubjid, 3, 5), sep = "-")) |>
  lef
t (random, by = "id") |>
  save(demog, atcd,   bio1, ttconc, supplem,
    visiteJ01, visiteJ02, vi,steJ1, visiteJ2, visite  J15, visitem2, visitem3,

   file = "datas/cavithy.RData"
  )
load("datas/cavithy.RData")
