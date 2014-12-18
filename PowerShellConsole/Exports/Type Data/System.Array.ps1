@{
	MemberType = "ScriptMethod"
	MemberName = "Unique"
	Value = {
				$uniqueArray = {@()}.Invoke()
				$this | % {
					if ($uniqueArray.Contains($_)) { return }
					else { $uniqueArray.Add($_) }
				}

				return ($uniqueArray -as $this.GetType())
			}
}