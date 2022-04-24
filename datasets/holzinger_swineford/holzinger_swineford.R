library(dplyr)
library(lavaan)

set.seed(62372)

model <- '  visual  =~ x1 + x2 + x3
            textual =~ x4 + x5 + x6
            speed   =~ x7 + x8 + x9 '

data <- HolzingerSwineford1939

fit_ml <- cfa(model,
           data,
           group = "school",
           group.equal = c("loadings"),
           likelihood = "wishart",
           information = "observed",
           meanstructure = FALSE)

fit_ls <- cfa(model,
           data,
           group = "school",
           group.equal = c("loadings"),
           estimator = "GLS",
           information = "observed",
           meanstructure = FALSE)

par_ml <- select(parTable(fit_ml), lhs, op, rhs, est, start, free, se, group)
par_ls <- select(parTable(fit_ls), lhs, op, rhs, est, start, free, se, group)

measures_ml <- fitMeasures(fit_ml)
measures_ls <- fitMeasures(fit_ls)

write.csv(par_ml, "datasets/holzinger_swineford/csv/parameter_estimates_ml.csv", row.names = FALSE)
write.csv(par_ls, "datasets/holzinger_swineford/csv/parameter_estimates_ls.csv", row.names = FALSE)
write.csv(data, "datasets/holzinger_swineford/csv/data.csv", row.names = FALSE)

write.csv(measures_ml, "datasets/holzinger_swineford/csv/fitmeasures_ml.csv")
write.csv(measures_ls, "datasets/holzinger_swineford/csv/fitmeasures_ls.csv")

# fiml
p_miss <- 0.2
n_obs <- nrow(data)

data_miss <- mutate(data,
    across(
        starts_with("x"),
        ~ifelse(rbinom(n_obs, 1, p_miss), NA, .x)
        )
    )

fit_ml <- cfa(model,
           data_miss,
           missing = "fiml",
           group = "school",
           group.equal = c("loadings"),
           information = "observed")

par_ml <- select(parTable(fit_ml), lhs, op, rhs, est, start, free, se, group)
measures_ml <- fitMeasures(fit_ml)

write.csv(par_ml, "datasets/holzinger_swineford/csv/parameter_estimates_fiml.csv", row.names = FALSE)
write.csv(data_miss, "datasets/holzinger_swineford/csv/data_fiml.csv", row.names = FALSE)
write.csv(measures_ml, "datasets/holzinger_swineford/csv/fitmeasures_fiml.csv")