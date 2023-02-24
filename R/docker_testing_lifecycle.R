# dockr <- list(environment_name = "rtest")
# class(dockr) <- "Dockr"

docker_run_cmd <- function(command, environment_name = "rtest") {
    return(paste(
        "docker run",
        "--name rtest-container",
        "--env R_LIBS=/root/.R/site-library",
        "-v rtest-site-library:/root/.R/site-library",
        "rtest-image ",
        command
    ))
}

# Clear everything
dockr_reset_environment <- function(environment_name = "rtest") {
    cmd <- paste(
        "docker container rm rtest-container",
        "docker volume rm rtest-site-library",
        "docker image rm -f rtest-image",
        sep = ";"
    )
    system(
        cmd
    )
}
# Rebuild Docker image
dockr_rebuild_image <- function(..., environment_name = "rtest") {
    cmd <- paste(
        ...,
        "docker build -t rtest-image . -f tests/docker/Dockerfile",
        sep = ";"
    )
    system(cmd)
}

# Install R dependencies
dockr_install_r_deps <- function(environment_name = "rtest") {
    cmd <- paste(
        "docker container kill rtest-container",
        "docker container rm rtest-container",
        docker_run_cmd("cd /package && ./install_deps.sh"),
        sep = ";"
    )
    system(
        cmd
    )
}

# Run tests
dockr_test <- function(environment_name = "rtest") {
    cmd <- paste(
        "docker container kill rtest-container",
        "docker container rm rtest-container",
        docker_run_cmd("cd /package && ./run_tests.sh"),
        sep = ";"
    )
    system(
        cmd
    )
}
# R CMD Check
dockr_cmd_check <- function(environment_name = "rtest") {
    cmd <- paste(
        "docker container kill rtest-container",
        "docker container rm rtest-container",
        docker_run_cmd("cd /package && ./check.sh"),
        sep = ";"
    )
    system(
        cmd
    )
}
