###
# Signes cliniques
# 08/10/2026
###

cac <- function(df){
  df |>
  mutate(cac =  calcium - 0.025 * (album - 40))
}

cac(visiteJ01)


t.test(visiteJ01$calcium, visiteJ2$calcium, paired = TRUE)


ll <- lmer(cac~ jj +(jj| bras), data = visit)

summary(ll)
