function Open-TodoFile {
    param(
        $Path = (Join-Path $ProfileConfig.General.UserFolder "Todo.txt"),
        [ValidateSet("Atom", "Code", "Default")]$Editor = "Default"
    )
    
    Edit-CustomTextEditor -Path $Path -CreateFile -Editor $Editor
}