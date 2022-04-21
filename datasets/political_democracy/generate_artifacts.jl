using Pkg.Artifacts
include(joinpath(pwd(), "helper.jl"))

artifact_toml = joinpath(pwd(), "Artifacts.toml")
src_dir = joinpath(@__DIR__, "csv")
tarball_dir = joinpath(@__DIR__, "compressed")

new_artifact("political_democracy", artifact_toml, src_dir, tarball_dir, "data.csv", "data.csv")

new_artifact("political_democracy_fiml", artifact_toml, src_dir, tarball_dir, "data_fiml.csv", "data_fiml.csv")

new_artifact("political_democracy_solution", artifact_toml, src_dir, tarball_dir, "data.csv", "data.csv")

new_artifact("political_democracy_solution_mean", artifact_toml, src_dir, tarball_dir, "data.csv", "data.csv")

new_artifact("political_democracy_solution_fiml", artifact_toml, src_dir, tarball_dir, "data.csv", "data.csv")