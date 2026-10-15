###
# Signes cliniques
# 08/10/2026
###

cac <- function(df) {
  df |>
    mutate(cac = calcium - 0.025 * (album - 40))
}

cac(visiteJ01)


t.test(visiteJ01$calcium, visiteJ2$calcium, paired = TRUE)


ll <- glmer(hypocalc ~ Visite + (1 | bras), data = clin, family = binomial)

summary(ll)

tbl_regression(ll)


ll <- lm(cac ~ jj + bras, data = hh)


hh <- visit |>
  dplyr::filter(jj %in% c("J0 - préop", "J02")) |>
  mutate(jj = droplevels(jj)) |>
  dplyr::select(subjid, bras, jj, cac) |>
  pivot_wider(names_from = jj, values_from = cac)

fisher.test(clinp$hypocalc, clinp$bras)


xx <- function(a){
  for (i in 1:1e12){
    for (j in 1:1e12)
     { z = i*a/j
  }
}
}

a <- c(1,5,4,4,6,2,7,5,3,8)
b <- c(2,3,5,5,7,8,9,3,4,5)
tibble(a,b) |>
  ggplot(aes(x=a,y=b)) +
  geom_point()
