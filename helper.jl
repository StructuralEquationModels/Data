function new_artifact(name, artifact_toml, src_dir, tarball_dir, tarball_name, args...; commit = true)
    # Query the `Artifacts.toml` file for the hash bound to the name "political_democracy"
    # new_hash = artifact_hash(name, artifact_toml)

    new_hash = create_artifact() do artifact_dir
        # move files into the artifact directory
        for arg in args
            cp(joinpath(src_dir, arg), joinpath(artifact_dir, arg))
        end
    end

    tarball_hash = archive_artifact(new_hash, joinpath(tarball_dir, tarball_name*".tar.gz"))

    if commit
        message = "update $name"
        run(`git add .`)
        run(`git commit -m $message`)
        commit_hash = readchomp(`git rev-parse HEAD`)
    else
        commit_hash = ""
    end

    bind_artifact!(
        artifact_toml, 
        name, 
        new_hash; 
        force = true, 
        lazy = true, 
        download_info = [(joinpath(download_root, commit_hash, replace(tarball_dir, pwd()*"/" => ""), tarball_name*".tar.gz"), tarball_hash)]
    )

    if commit
        message = "update toml entry of $name"
        run(`git add -u`)
        run(`git commit -m $message`)
    end

end

download_root = "https://github.com/StructuralEquationModels/Data/raw/"