function new_artifact(name, artifact_toml, csv_dir, tarball_dir, args...)
    # Query the `Artifacts.toml` file for the hash bound to the name "political_democracy"
    # new_hash = artifact_hash(name, artifact_toml)

    new_hash = create_artifact() do artifact_dir
        # move files into the artifact directory
        for arg in args
            cp(joinpath(csv_dir, arg), joinpath(artifact_dir, arg))
        end
    end

    bind_artifact!(artifact_toml, name, new_hash; force = true, lazy = true)

    new_gz_hash = Dict{Any, String}()
    for arg in args
        push!(new_gz_hash, arg => archive_artifact(new_hash, joinpath(tarball_dir, arg*".tar.gz")))
    end

    return new_gz_hash, new_hash
end

