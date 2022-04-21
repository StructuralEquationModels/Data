library(dplyr)
library(lavaan)

set.seed(123)

#----lavaan----
model <-    "# measurement model
            ind60 =~ x1 + x2 + x3
            dem60 =~ y1 + y2 + y3 + y4
            dem65 =~ y5 + y6 + y7 + y8
            # regressions
            dem60 ~ ind60
            dem65 ~ ind60 + dem60
            # residual correlations
            y1 ~~ y5
            y2 ~~ y4 + y6
            y3 ~~ y7
            y4 ~~ y8
            y6 ~~ y8"

data <- PoliticalDemocracy

data <- select(data, starts_with("x"), starts_with("y"))

fit_ml <- cfa(model, data, likelihood = "wishart", do.fit = TRUE, information = "observed")
fit_ls <- cfa(model, data, estimator = "GLS", do.fit = TRUE, information = "observed")

par_ml <- select(parTable(fit_ml), lhs, op, rhs, est, start, se)
par_ls <- select(parTable(fit_ls), lhs, op, rhs, est, start, se)

measures_ml <- fitMeasures(fit_ml)
measures_ls <- fitMeasures(fit_ls)

write.csv(par_ml, "datasets/political_democracy/csv/parameter_estimates_ml.csv", row.names = FALSE)
write.csv(par_ls, "datasets/political_democracy/csv/parameter_estimates_ls.csv", row.names = FALSE)
write.csv(data, "datasets/political_democracy/csv/data.csv", row.names = FALSE)

write.csv(measures_ml, "datasets/political_democracy/csv/fitmeasures_ml.csv", row.names = FALSE)
write.csv(measures_ls, "datasets/political_democracy/csv/fitmeasures_ls.csv", row.names = FALSE)

# meanstructure
model <-    "# measurement model
            ind60 =~ x1 + x2 + x3
            dem60 =~ y1 + y2 + y3 + y4
            dem65 =~ y5 + y6 + y7 + y8
            # regressions
            dem60 ~ ind60
            dem65 ~ ind60 + dem60
            # residual correlations
            y1 ~~ y5
            y2 ~~ y4 + y6
            y3 ~~ y7
            y4 ~~ y8
            y6 ~~ y8
            # meanstructure
            y1 ~ a*1
            y2 ~ b*1
            y3 ~ c*1
            y4 ~ d*1
            y5 ~ a*1
            y6 ~ b*1
            y7 ~ c*1
            y8 ~ d*1"

fit_ml <- cfa(model, data, likelihood = "wishart", do.fit = TRUE, information = "observed")
fit_ls <- cfa(model, data, estimator = "GLS", do.fit = TRUE, information = "observed")

par_ml <- select(parTable(fit_ml), lhs, op, rhs, est, start, se)
par_ls <- select(parTable(fit_ls), lhs, op, rhs, est, start, se)

measures_ml <- fitMeasures(fit_ml)
measures_ls <- fitMeasures(fit_ls)

write.csv(par_ml, "datasets/political_democracy/csv/parameter_estimates_ml_mean.csv")
write.csv(par_ls, "datasets/political_democracy/csv/parameter_estimates_ls_mean.csv")

write.csv(measures_ml, "datasets/political_democracy/csv/fitmeasures_ml_mean.csv")
write.csv(measures_ls, "datasets/political_democracy/csv/fitmeasures_ls_mean.csv")

# fiml
p_miss <- 0.2
n_obs <- nrow(data)

data_miss <- mutate(data, 
    across(
        everything(), 
        ~ifelse(rbinom(n_obs, 1, p_miss), NA, .x)
        )
    )

fit_ml <- cfa(model, data_miss, missing = "fiml", do.fit = TRUE) # 0.44s

par_ml <- select(parTable(fit_ml), lhs, op, rhs, est, start, se)

measures_ml <- fitMeasures(fit_ml)

write.csv(par_ml, "datasets/political_democracy/csv/parameter_estimates_fiml.csv")
write.csv(data_miss, "datasets/political_democracy/csv/data_fiml.csv")
write.csv(measures_ml, "datasets/political_democracy/csv/fitmeasures_fiml.csv")
