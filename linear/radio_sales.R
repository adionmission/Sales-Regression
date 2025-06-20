# Code written by Aditya Kakde, owner of account @Onnamission

library(tidyverse)
library(janitor)


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

radio = data_clean$radio

sales = data_clean$sales

data_clean %>%
  ggplot(aes(radio, sales)) + 
  geom_point(aes(color = radio, size = sales), alpha = 0.5) + 
  geom_smooth(method = "lm", se = FALSE) + 
  labs(x = "Radio Listening", 
       y = "Sales", 
       title = "Effect of radio listening on sales") + 
  theme_bw() + 
  theme(plot.title = element_text(size = 60),
        axis.title.x = element_text(size = 30),
        axis.title.y = element_text(size = 30),
        axis.text.x = element_text(size = 18),
        axis.text.y = element_text(size = 18))


# using linear regression

model = lm(sales ~ radio, data = data_clean)

summary(model)
