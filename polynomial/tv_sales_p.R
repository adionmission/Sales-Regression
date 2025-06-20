# Code written by Aditya Kakde, owner of account @Onnamission

library(tidyverse)
library(janitor)
library(ggpubr)


# setting path and reading data

print(getwd())
setwd("D:/Projects/Customer")
print(getwd())

df = read.csv("dataset/advertising.csv")

View(df)


# data pipeline

data_clean = df %>%
  drop_na() %>%
  janitor::clean_names() %>%
  subset(select = -c(x))

View(data_clean)


# plotting graph

tv = data_clean$tv

sales = data_clean$sales


# using polynomial regression

model1 = lm(sales ~ poly(tv, degree = 2, raw = TRUE), data = data_clean)

model2 = lm(sales ~ poly(tv, degree = 3, raw = TRUE), data = data_clean)

summary(model1)

summary(model2)


# plotting the graph

p1 = ggplot(data_clean, aes(x=tv, y=sales)) + 
  geom_point(aes(color = tv, size = sales), alpha = 0.5) + 
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE, colour = "red") +
  labs(x = "TV Watching", 
       y = "Sales", 
       title = "Effect of tv watching on sales",
       subtitle = "Square Polynomial") + 
  theme_bw() + 
  theme(plot.title = element_text(size = 40),
        plot.subtitle = element_text(size = 18),
        axis.title.x = element_text(size = 22),
        axis.title.y = element_text(size = 22),
        axis.text.x = element_text(size = 15),
        axis.text.y = element_text(size = 15))

p2 = ggplot(data_clean, aes(x=tv, y=sales)) + 
  geom_point(aes(color = tv, size = sales), alpha = 0.5) + 
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), se = FALSE, colour = "red") +
  labs(x = "TV Watching", 
       y = "Sales", 
       title = "Effect of tv watching on sales",
       subtitle = "Cubic Polynomial") + 
  theme_bw() + 
  theme(plot.title = element_text(size = 40),
        plot.subtitle = element_text(size = 18),
        axis.title.x = element_text(size = 22),
        axis.title.y = element_text(size = 22),
        axis.text.x = element_text(size = 15),
        axis.text.y = element_text(size = 15))

# combining them

ggarrange(p1, p2, ncol = 2, labels = "AUTO")
