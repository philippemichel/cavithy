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
  "demog", "atcd", "bio1", "supplem",
  "visiteJ01", "visiteJ02", "visiteJ1", "visiteJ2", "visiteJ15",
  "visitem2", "visitem3"
)
fe <- seq(1, 23, by = 2)
exclus <-
  c(
    "01011", "01056", "02102",
    "01014 ", "0106 3", "02103",
    "010 17", "06 069", "02104",
    "0 2038", " 06074", "06111",
    "02039", "04078", "06120",
    "02040 ", "04086", "06121",
    "020 43", "01093", "06128",
    "01052", "06097"
  )
ittm <- as.factor(paste0("0", c(
  "03022",
  "01031",
  "01024",
  "01108",
  "06087",
  "03013",
  "01020",
  "01133"
)))
pp <- as.factor(c("030 22", "01031"))

for (i in 1:11) {
  print(nf[i])
  f1 <- fe[i]
  f2 <- f1 + 1
  zz <- read_ods("datas/cavithy.ods",
    sheet = f1,
    na = c("", " ", "NA", "D", "K", "
  NC", "Non disponible")
  ) |>
    clean_names() |>
    dplyr::filter_out(subjid %in% exclus) |>
    mutate(across(ends_with("dte"), ~ dmy(.x))) |>
    mutate(across(is.character, ~ as.factor(.x))) |>
    mutate(across(
      ends_with("on"),
      ~ as.character(.x)
    )) |>
    mutate(across(
      ends_with("on"),
      ~ replace_na(.x, "no")
    )) |>
    mutate(across(is.character, ~ as.factor(.x))) |>
    mutate(across(
      ends_with("on"),
      ~ fct_expand(.x, "yes")
    ))
  #
  bn <- read_ods("datas/cavithy.ods", sheet = f2)
  var_label(zz) <- bn$nom
  assign(nf[i], zz)
  zz <- zz |>
    select(!ends_with("prec")) |>
    select(!ends_with("hr"))
}
#
demog <- demog |>
  mutate(taille = as.numeric(as.character(taille))) |>
  mutate(pds = as.numeric(as.character(pds))) |>
  select(!initconcat)
bn <- read_ods("datas/cavithy.ods", sheet = 2)
var_label(demog) <- bn$nom[1:6]
#
# Randomisation & critères d'analyse
#
random <- read_ods("datas/cavithy.ods", sheet = "random", na = "NA") |>
  drop_na(bras)
zz <- as_tibble(str_split_fixed(random$idcar, "-", 3)) |>
  mutate(id = replace_when(
    V2,
    str_length(V2) == 2 ~ paste0("0", V2)
  )) |>
  mutate(id = paste0(V1, id))
random <- random |>
  mutate(subjid = zz$id) |>
  mutate(across(is.character, ~ as.factor(.x))) |>
  mutate(ittm = as.factor(ifelse(subjid %in% ittm, "no", "yes"))) |>
  mutate(pp = as.factor(ifelse(subjid %in% pp, "no", "yes")))

zz <- random |>
  select(subjid, bras)
demog <- left_join(zz, demog, by = "subjid")
bio1 <- left_join(zz, bio1, by = "subjid")
atcd <- left_join(zz, atcd, by = "subjid") |>
  remove_empty(which = "cols")
supplem <- left_join(zz, supplem, by = "subjid")
visiteJ01 <- left_join(zz, visiteJ01, by = "subjid")
visiteJ02 <- left_join(zz, visiteJ02, by = "subjid")
visiteJ1 <- left_join(zz, visiteJ1, by = "subjid")
visiteJ2 <- left_join(zz, visiteJ2, by = "subjid")
visiteJ15 <- left_join(zz, visiteJ15, by = "subjid")
visitem2 <- left_join(zz, visitem2, by = "subjid")
visitem3 <- left_join(zz, visitem3, by = "subjid")
rm(zz)
#
save(demog, atcd, bio1, supplem,
  visiteJ01, visiteJ02, visiteJ1, visiteJ2, visiteJ15, visitem2, visitem3,
  file = "datas/cavithy.RData"
)
load("datas/cavithy.RData")
