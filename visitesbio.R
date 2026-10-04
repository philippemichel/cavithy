# Cac = Camesurée - 0,025 (A - 40)

J00 <- visiteJ01$opdte
J01 <- visiteJ1$visitdte - J00
J02 <- visiteJ2$visitdte - J00
J15 <- visiteJ15$visitedte - J00
M3 <- visitem3$visitdte - J00

bj01 <- visiteJ1 |>
  dplyr::select(subjid, bras, calcium, albumin, phosphat) |>
  mutate(cacor = calcium - 0.025 * (albumin - 40)) |>
  mutate(jj = "J01")
bj02 <- visiteJ2 |>
  dplyr::select(subjid, bras, calcium, albumin, phosphat) |>
  mutate(cacor = calcium - 0.025 * (albumin - 40)) |>
  mutate(jj = "J02")
bj15 <- visiteJ15 |>
  dplyr::select(subjid, bras, calcium, albumin, phosphat) |>
  mutate(cacor = calcium - 0.025 * (albumin - 40)) |>
  mutate(jj = "J15")
bm3 <- visitem3 |>
  dplyr::select(subjid, bras, calcium, albumin, phosphat) |>
  mutate(cacor = calcium - 0.025 * (albumin - 40)) |>
  mutate(jj = "M3")

visit <- bind_rows(bj01, bj02, bj15, bm3) |>
  mutate(jj = as.factor(jj))

visit |>
  na.omit() |>
  ggplot(aes(x = jj, y = cacor, fill = bras)) +
  geom_boxplot() +
  labs(
    title = "Calcémie corrigée selon les visites",
    x = "Visite",
    y = "Calcium corrigé (mmol/L)"
  ) +
  theme_minimal()

boxplot(visit$cacor)
