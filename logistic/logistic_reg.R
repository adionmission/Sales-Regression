# Code written by Aditya Kakde, owner of account @Onnamission

library(tidyverse)
library(janitor)
library(caTools)
library(ggpubr)


# setting path and reading data

print(getwd())
setwd("D:/Projects/Sales-Regression-Analysis")
print(getwd())

df = read.csv("dataset/bank-full.csv", sep=";")

View(df)


# data pipeline

data_clean = df %>%
  drop_na() %>%
  janitor::clean_names()

View(data_clean)


# Remaining Columns

colnames(data_clean) = c("age",
                        "job",
                        "marital",
                        "education",
                        "credit_default",
                        "balance",
                        "house_loan",
                        "personal_loan",
                        "contact",
                        "days",
                        "month",
                        "duration",
                        "campaign",
                        "pdays",
                        "previous",
                        "poutcome",
                        "term_deposit")

View(data_clean)


# changing term deposit from yes-no to 1-0

data_clean$term_deposit[data_clean$term_deposit == "yes"] = 1

data_clean$term_deposit[data_clean$term_deposit == "no"] = 0

View(data_clean)


# converting data type

sapply(data_clean, class)

data_clean$term_deposit = as.numeric(data_clean$term_deposit)

data_clean$balance = as.numeric(data_clean$balance)

data_clean$campaign = as.numeric(data_clean$campaign)

sapply(data_clean, class)


# split the dataset

split = sample.split(data_clean, SplitRatio = 0.8)

train = subset(data_clean, split == TRUE)

test = subset(data_clean, split == FALSE)


# Logistic Regression Summary

balance = data_clean$balance

campaign = data_clean$campaign

termd = data_clean$term_deposit

model = glm(termd ~ balance + campaign, 
            family = "binomial", 
            data = data_clean)

summary(model)


# running the test data

res = predict(model, test, type="response")

res = predict(model, train, type="response")


# Accuracy

confmatrix = table(Predected = res > 0.5, Actual = train$term_deposit)

print(confmatrix)

(confmatrix[[1, 1]] + confmatrix[[2, 2]]) / sum(confmatrix)


# graphical representation

# plot for balance - term_deposit
p1 = ggplot(data_clean, aes(balance, termd)) + 
  geom_point(color = "blue") + 
  geom_smooth(method = "glm",
              se = FALSE, 
              color="red",
              method.args = list(family = binomial)) +
  labs(x = "Balance per year", 
       y = "Term Deposit", 
       title = "Relation of balance with term deposit") + 
  theme_bw() + 
  theme(plot.title = element_text(size = 55),
        axis.title.x = element_text(size = 23),
        axis.title.y = element_text(size = 23),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14))

# plot for campaign - term_deposit
p2 = ggplot(data_clean, aes(campaign, termd)) + 
  geom_point(color = "brown") + 
  geom_smooth(method = "glm",
              se = FALSE, 
              color="green",
              method.args = list(family = binomial)) +
  labs(x = "Number of contacts performed during the campaign", 
       y = "Term Deposit", 
       title = "Relation of campaign with term deposit") + 
  theme_bw() + 
  theme(plot.title = element_text(size = 55),
        axis.title.x = element_text(size = 23),
        axis.title.y = element_text(size = 23),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14))

# combining them
ggarrange(p1, p2, nrow = 2, labels = "AUTO")
