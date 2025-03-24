<#
Module description: This module is used to customize the PowerShell interface.
Author: Solorzano, Juan Jose.
Date: 2021-06-01
NOTE: This script was developed for Windows PowerShell v1.0
#>
Clear-Host #clear the console every time when the script is called.
#------ Importing PS1 Modules ------#
$exe_path = Get-Location
Set-Location $HOME
$root_path = Get-Location
$modules_path = $root_path.Path + '\Documents\WindowsPowerShell\lib\{0}.psm1'
Import-Module -Name ($modules_path -f "GitComCom") -DisableNameChecking
Import-Module -Name ($modules_path -f "Helpers") -DisableNameChecking
Import-Module -Name ($modules_path -f "Remote") -DisableNameChecking
Import-Module -Name ($modules_path -f "vs-suite") -DisableNameChecking
$module_name = ($HOME + "\{0}.psm1" -f ".decode")
$module_exists = [System.IO.File]::Exists($module_name)
if($module_exists){Import-Module -Name $module_name -DisableNameChecking}
Set-Location $exe_path
# prompt function
function prompt {
	$Host.UI.RawUI.WindowTitle = (Get-Location).Path
	Set-PSReadLineOption -Colors @{ Command = 'green' }
	$currentDir = (Convert-Path .)
	#-------- Set same working path ------#
	Invoke-Starship
	#-------- Home Status --------#
	if ($currentDir.Contains($HOME)) {
		$currentDir = $currentDir.Replace($HOME, "~ ")
	}
	#-------- TA Suite Status --------#
    if($currentDir.Contains("work\ta") -or $currentDir.Contains(("work"))){
        $ta_dir = $currentDir
        $ta = $ta_dir.ToString()
        $ta_split = $ta.Split('\')
        $lenght = $ta_split.Length
        $work_idx = $ta_split.IndexOf("work")
        if($currentDir.Contains("work")){
            $init = $work_idx
        }else{
            $init = $work_idx+2
        }
        $suite_dir = $ta_split[$work_idx-1]
        $tst = $ta_split[$init..($lenght)]
        $new_path = @($suite_dir)+$tst
        $currentDir =  "..$($new_path -join '\')"#"..\$suite_dir"
    }
	#----- Git Branch Status -------#
	if (Test-Path .git) {
		Write-Host ("" + $currentDir + "\\") -NoNewLine `
		-ForegroundColor 13
		Write-BranchName
		Write-Host ("-->") -NoNewLine `
		-ForegroundColor 10
			return " "
    }
	else
	{
		Write-Host ("" + $currentDir+"\\") -NoNewLine `
		-ForegroundColor 13
		Write-BranchName
		Write-Host ("-->") -NoNewLine `
		-ForegroundColor 10
			return " "
	}
}
function Invoke-Starship{
  $loc = $executionContext.SessionState.Path.CurrentLocation;
  $prompt = "$([char]27)]9;12$([char]7)"
  if ($loc.Provider.Name -eq "FileSystem")
  {
    $prompt += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
  }
  $host.ui.Write($prompt)
}
