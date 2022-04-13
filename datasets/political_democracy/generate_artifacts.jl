using Pkg.Artifacts
include(joinpath(pwd(), "helper.jl"))

artifact_toml = joinpath(pwd(), "Artifacts.toml")
src_dir = joinpath(@__DIR__, "csv")
tarball_dir = joinpath(@__DIR__, "compressed")

new_artifact("political_democracy", artifact_toml, src_dir, tarball_dir, "data.csv", "data.csv")