library(tidyverse)
library(ggbreak)

tt <- read_delim("preliminaire/Thyroide1.csv")  |>
    mutate_if(is.character,as.factor)

tt  |>
    dplyr::select(Uvedose, starts_with("Calcé"))  |>
    pivot_longer(2:4)  |>
        mutate(name = as.numeric(str_sub(name, -1)))  |>
    ggplot() +
    aes(x = name, y = value, col = Uvedose) +
    geom_jitter(width = 0.01) +
    geom_smooth() +
    geom_hline(yintercept = 2.2) +
    scale_x_break(c(2.2,2.8)) + # Pour faire la coupure si affichage de mois etc.
    scale_x_continuous(breaks = 1:3, labels = paste0("J",1:3))
