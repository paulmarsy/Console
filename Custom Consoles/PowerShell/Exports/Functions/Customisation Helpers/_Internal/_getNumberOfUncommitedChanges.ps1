function _getNumberOfUncommitedChanges {
    $output = & git status --porcelain 2>$null | Measure-Object -Line | Select-Object -ExpandProperty Lines
    if ($LASTEXITCODE -ne 0) { throw "Git command returned exit code: $LASTEXITCODE" }
    return $output
}