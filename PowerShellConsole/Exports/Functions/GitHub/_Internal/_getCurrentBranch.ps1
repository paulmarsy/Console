function _getCurrentBranch {
    $output = & git rev-parse --abbrev-ref HEAD
    if ($LASTEXITCODE -ne 0) { throw "Git command returned exit code: $LASTEXITCODE" }
    return $output
}