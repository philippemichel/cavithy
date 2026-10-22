

op <- visiteJ02 |>
  dplyr::select(subjid,parathy,curz6,adenomon) |>
  left_join(clinp, by = "subjid") |>
  dplyr::select(subjid:bras, Diagnostic,hypocalc)

op |>
  dplyr::select(!c(subjid,Diagnostic,hypocalc)) |>
  tbl_summary(by= bras,
              missing = "no") |>
  add_overall() |>
  add_p(test = everything() ~ "fisher.test") |>
  bold_p(t = 0.03) |>
  add_ci() |>
  modify_header(label = "**Signe**") |>
  modify_spanning_header(c("stat_1", "stat_2") ~ "**Bras**") |>
  bold_labels() |>
  pexptabph(exp = expx, nomfich = classeur , nomsheet =
              "techop", lg = TRUE)
