function Open-TodoFile {
    param(
        $Path = (Join-Path $ProfileConfig.General.UserFolder "Todo.txt")
    )
    
    Edit-CustomTextEditor -Path $Path -CreateFile
}