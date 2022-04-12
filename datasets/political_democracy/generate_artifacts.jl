using Pkg.Artifacts
include(joinpath(pwd(), "helper.jl"))

artifact_toml = joinpath(pwd(), "Artifacts.toml")
csv_dir = joinpath(@__DIR__, "csv")
tarball_dir = joinpath(@__DIR__, "compressed")

gz_hash, new_hash = new_artifact("political_democracy", artifact_toml, csv_dir, tarball_dir, "data.csv")



cp(joinpath(csv_dir, "data.csv"), joinpath(csv_dir, "parameter_estimates_ls.csv"))