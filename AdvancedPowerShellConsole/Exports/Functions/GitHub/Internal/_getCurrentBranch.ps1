function _getCurrentBranch {
    return (& git rev-parse --abbrev-ref HEAD)
}