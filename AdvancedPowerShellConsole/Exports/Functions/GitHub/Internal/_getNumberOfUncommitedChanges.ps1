function _getNumberOfUncommitedChanges {
    return (& git status --porcelain 2>$null | Measure-Object -Line | Select-Object -ExpandProperty Lines)
}