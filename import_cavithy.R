  # ------------------------------------------------------------------------
  #
  # Title : Import cavithy
  #    By : PhM
  #  Date : 2026-07-02
  #
  #  ------------------------------------------------------------------------

  rm(list = ls())
  library(baseph)
  library(janitor)
  library(readODS)
  library(lubridate)
  library(tidyverse)
  library(labelled)

importc <- function()
  rm(list = ls())
nn <- c("", " ", "NA", "K", "D", "")


tt <- read_ods("datas/.ods", sheet = 1, na = nn) |>
  clean_names() |>
  #  mutate(across(ends_with("dte"), dmy)) |>
  mutate(across(is.character, as.factor)) |>
  mutate(across(starts_with("date"), ymd))


#
save(tt, file = "datas/cavithy.RData")
}
  #
  # --------------
  #
  load("datas/cavithy.RData")
