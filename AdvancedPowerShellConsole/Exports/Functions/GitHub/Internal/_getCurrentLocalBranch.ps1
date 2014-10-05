function _getCurrentLocalBranch {
    return (& git rev-parse --abbrev-ref HEAD)
}