function Open-TodoFile {
    param(
        $Path = (Join-Path $ProfileConfig.General.UserFolder "Todo.txt")
    )
    Edit-InAtom -Path $Path -CreateFile
}