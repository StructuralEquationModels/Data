using Pkg.Artifacts
include(joinpath(pwd(), "helper.jl"))

artifact_toml = joinpath(pwd(), "Artifacts.toml")
src_dir = joinpath(@__DIR__, "csv")
tarball_dir = joinpath(@__DIR__, "compressed")

new_artifact("holzinger_swineford", artifact_toml, src_dir, tarball_dir, "data.csv", "data.csv")

new_artifact("holzinger_swineford_missing", artifact_toml, src_dir, tarball_dir, "data_fiml.csv", "data_fiml.csv")

new_artifact(
    "holzinger_swineford_solution", 
    artifact_toml, src_dir, tarball_dir, 
    "holzinger_swineford_solution", 
    "fitmeasures_ml.csv",
    "fitmeasures_ls.csv",
    "fitmeasures_fiml.csv",
    "parameter_estimates_ml.csv",
    "parameter_estimates_ls.csv",
    "parameter_estimates_fiml.csv")