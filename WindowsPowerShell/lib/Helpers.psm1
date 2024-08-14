#REQUIRES -Version 1.0
<#
.SYNOPSIS
	Helpers is a module created to facilte commands in powershell.
.DESCRIPTION
	There are many commands that you can use with the powershell profile.
.NOTES
    File Name      : GitComCom.psm1
    Author         : Solorzano, Juan Jose (uiv06924)
    Prerequisite   : PowerShell V1
#>

function del-pyc {
	$command = "del *.pyc /s"
	Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList "/C", $command
	Start-Sleep -Seconds 1
	Clear-Host
}
function doc {
	param ($file)
}
function del-recurse($item){
	$command = "del $item /s"
	Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList "/C", $command
    Clear-Host
}

function profile {
	set-location 'C:\Users\uiv06924\Documents\WindowsPowerShell\'
}

function bash {
    $curr_location = get-location
    $curr_location = $curr_location.path
    set-location "C:\Program Files\Git\bin\"
    .\bash.exe
    set-location $curr_location
}
function onedrive {
	Set-Location 'C:\Users\uiv06924\OneDrive - Vitesco Technologies'
}
function frepo{
	set-location "C:\Users\uids7040\git"
}
function Edge($page) {
	try {
		$temp_dir = Get-Location
		Set-Location "C:\Program Files (x86)\Microsoft\Edge\Application\"
		Start-Process "msedge.exe" $page 
		Set-Location $temp_dir.Path
	}
	catch {
		Start-Process "msedge.exe"
		Set-Location $temp_dir.Path
	}
}

function New-TaImplementation {
	<#
	.SYNOPSIS
		This functions is used to created new files for a new TA implementation.

	.DESCRIPTION
		Usage: New-TaImplementation [-parentFolder] [-filesName] [-project]
		Args:
			Write-Host "  [-parentFolder]: The folder where will be create the files, e.g. 'ISR' or 'core'."
        	Write-Host "  [-filesName]: The IRS or functionality name, e.g. 'Leakage' or 'core'."
        	jWrite-Host "  [-project]: The project name, e.g. 'ECU' or 'BMS'. If none, ECU is set."
        	Write-Host "Example: New-TaImplementation -parentFolder 'core' -filesName 'ewdt' -project 'ECU'"
		Exmple:
		    New-TaImplementation -parentFolder 'core' -filesName 'ewdt' -project 'ECU'.
			
	.PARAMETER ParameterName
		[-parentFolder]: The folder where will be create the files, e.g. 'ISR' or 'core'.
        [-filesName]: The IRS or functionality name, e.g. 'Leakage' or 'core'.
        [-project]: The project name, e.g. 'ECU' or 'BMS'. If none, ECU is set.

	.EXAMPLE
		New-TaImplementation -parentFolder 'core' -filesName 'ewdt' -project 'ECU'.

	.NOTES
	   Additional notes or information.
	#>
	[CmdletBinding()]
	param (
		[string]$parentFolder,
		[string]$filesName,
		[string]$project,
		[switch]$h
	)
	if ($h) {
        # Display help information
        Write-Host "Usage: New-TaImplementation [-parentFolder] [-filesName] [-project] [-h]"
        Write-Host "  [-parentFolder]: The folder where will be create the files, e.g. 'ISR' or 'core'."
        Write-Host "  [-filesName]: The IRS or functionality name, e.g. 'Leakage' or 'core'."
        Write-Host "  [-project]: The project name, e.g. 'ECU' or 'BMS'. If none, ECU is set."
        Write-Host "Example: New-TaImplementation -parentFolder 'core' -filesName 'ewdt' -project 'ECU'"
        return
    }
	if($null -ne $parentFolder){
		if($project -eq "ecu"){
			$zip_name = "ECU" 
		}
		elseif ($project -eq "bms") {
			$zip_name = "BMS"
		}
		else{$zip_name = "ECU"}
		$cwd = Get-Location
		$dirs = ls
		if($cwd.Path.Contains('work\ta') -or $dirs.Name.Contains('work')){
			$path = whereis -item $parentFolder -nV
			if($path){
				echo $path
				$psprofile = $PROFILE
				$lib_ps_path = $psprofile.replace('Microsoft.PowerShell_profile.ps1','lib')
				cp "$lib_ps_path\$zip_name.7z" $path
			}
			try {
				$current_location = pwd		
				cd $path
				if(-not $filesName){
					$filesName = "XXXX"
				}
				7z e "$zip_name.7z" -o"$filesName"
				rm "$zip_name.7z"
				Start-Sleep -Milliseconds 30
				cd $filesName
				$funct_items = ls
				foreach($item in $funct_items){
					if($item.Name.contains('XXXX')){
						mv $item $item.Name.replace('XXXX',$filesName)
					}
				}
				ls
				cd $current_location
			}
			catch {
			}
		}else{
			echo "No Suite Folder"
		}
	}else{
		echo "Type functionality is needed."
	}
	
}

function Mlink ($target, $link){
	New-Item -Force -Path $link -ItemType SymbolicLink -Value $target
}
function b($n){

	$back_patern = '../'
	$multiplier = $n
	# Empty string to store the result.
	$total_back = ''

	if($null -eq $n){
		Set-Location $back_patern
	}
	else{
		# Repeating the string.
		for ($i = 1; $i -le $multiplier; $i++) {
		    $total_back += $back_patern
		}
		Set-Location $total_back
	}
}

function ll {
	Get-ChildItem -Force | Sort-Object Extension
}

function re {
	powershell.exe
}

function delete ($item){
    rm -Force -Recurse $item
}

function get-variables {
	return "%windir%\System32\rundll32.exe sysdm.cpl,EditEnvironmentVariables"	
}

function edge {
	param($target)
	try 
	{
	    start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" $target    
	}
	catch {
	    start-Process "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
	}	
}

function vi {
	[CmdletBinding()]
    param ([string]$file,[switch]$w)
	try{
		# Remove the ./ character 
		if($file.Contains('.\')){$file=$file.replace('.\','')}
	}catch{}
	$temp_path = Get-Location
	$root_file = $temp_path.Path +'\'+ $file
	Set-Location "C:\Program Files\Git\usr\bin\" 
	if($w){
		Start-Process "vim.exe"$root_file
	}else{
		.\vim.exe $root_file
	}
	Set-Location $temp_path.path
}
#####################################################
#get the parameters by console line
#####################################################
function whereis{
	[CmdletBinding()]
    param([string]$item,[string]$path,[switch]$nV,[switch]$setClipboard)

	#Constants
	$vvv = "
		------------- Searching for < $item > -------------
		----- you can stop the search using 'ctr+c' -----
	searching...
	"
	$help_str = "Parameters:
		-item:: the file that you want to search
		-path:: the location where you want to search
		-vvv:: it shows the information"

	#Search the file.
	if($item -And -not $path){
		$ret_path = Get-ChildItem -Force -Filter $item -Recurse 2> $null
	}
	elseif($item -and $path){
		$ret_path = Get-ChildItem -Force -Path $path -Filter $item -Recurse 2> $null
	}	
	else
	{
		help $MyInvocation.MyCommand.Name
		Write-Host $help_str
	}
	##### returns #####
	if(-not $ret_path){
		return "[!]>> '$item' NOT FOUND !!!!!"
	}
	if(-not $nV){
		Write-Host $vvv
		Write-Host "Item found at:"
		if($ret_path.GetType().FullName -eq 'System.IO.FileInfo'){
			Set-Clipboard $ret_path.FullName
		}
		if($setClipboard){
			$i = 0
			foreach($_path in $ret_path){
				$i++
				Write-Host "[$i]>>"$_path.FullName
			}
			$idx = Read-Host "Select the number of the desire path"
			if($idx){
				if($ret_path[$idx-1]){Set-Clipboard $ret_path[$idx-1].FullName.trim()}
				else{"$idx not in the array."}
			}
		}else{
			return $ret_path.FullName
		}
	}
	else{
		return $ret_path.FullName
	}
}

function Insert-line($filePath,$stringToFind,$insertedString){
	# Specify the string you want to insert with a line break
	$insertedString = "`r`n$insertedString"  # Use `r`n for a line break
	$fileContent = Get-Content -Path $filePath
	# Find the line number that contains the specified string
	$lineNumber = 1
	foreach ($line in $fileContent) {
    	if ($line.contains($stringToFind)) {
        		break
    		}
    	$lineNumber++
	}
	# Check if the string was found
	if ($lineNumber -le $fileContent.Count) {
    # Insert the string with a line break after the line that contains the specified string
		if($lineNumber -eq 1){
    		$fileContent[$lineNumber - 1] += $insertedString
		}else{
			$class_name = $fileContent[$lineNumber-2]
    		$fileContent[$lineNumber - 2] += $insertedString
		}
	} else {
    	Write-Host "String '$stringToFind' not found in file."
	}
	# Write the modified content back to the file
	$fileContent | Set-Content -Path $filePath
	try {
		return $class_name.split()[1].split(':')[0].Split('(')[0]
	}
	catch {
		return
	}
}

function Del-line($filePath,$stringToFind){
	# Specify the string you want to insert with a line break
	$insertedString = ""  # Use `r`n for a line break
	$fileContent = Get-Content -Path $filePath
	# Find the line number that contains the specified string
	$lineNumber = 1
	foreach ($line in $fileContent) {
    	if ($line.contains($stringToFind)) {
        		break
    		}
    	$lineNumber++
	}
	# Check if the string was found
	if ($lineNumber -le $fileContent.Count) {
    # Insert the string with a line break after the line that contains the specified string
		if($lineNumber -eq 1){
    		$fileContent[$lineNumber-1] += $insertedString
		}else{
    		$fileContent[$lineNumber - 2] += $insertedString
		}
	} else {
    	Write-Host "String '$stringToFind' not found in file."
	}
	# Write the modified content back to the file
	$fileContent | Set-Content -Path $filePath
}

function get-passwd([string]$target){
	if($target){
		if($target.Contains("BLN")){get-bln -h}
		elseif($target.Contains("CHN")){get-chn -h}
		elseif($target.Contains("GDL")){get-gdl -h}
		elseif($target.Contains("ABH")){get-abh -h}
		elseif($target.Contains("RGB")){get-rgb -h}
		else {"[!] $target no found"}
	}else{
		echo "[!] Parameter needed"
	}
}
function infpath($file){
    $temp_loc = get-location
	$root_file = $temp_loc.Path +'\'+ $file
    set-location 'C:\Program Files (x86)\Microsoft Office\Office15'
    start-process 'INFOPATH.EXE' $root_file
    set-location $temp_loc
}

function Set-PyEnv() {
	echo "*********************************************************************"
	echo "*********************************************************************"
	echo "		Wellcome to Python environment :) "
	echo "*********************************************************************"
	echo "[!] Searching for Python interperter..."
	echo " "
	Start-Sleep -Seconds 0.6
	$pythonPaths = Get-Command python*.exe -All
	$pythonPaths = $pythonPaths | Sort-Object
	if ($pythonPaths) {
		$cnt=0
	    Write-Host "Python is installed in the following locations:"
	    foreach ($path in $pythonPaths) {
	        Write-Host "  $cnt-"$path.Source
			$cnt++
	    }
		echo " "
		$interpreter = Read-Host "Select a python interperter"
		echo ""
		$tst = $pythonPaths[$interpreter].Source
		$lib = "Lib"
		$site_module = "\site.py"
		$ta_module = "\own_env.py"
		$py_exe = $pythonPaths[$interpreter].Name
		$py_rootpath = $pythonPaths[$interpreter].Source
		$py_path = $py_rootpath.replace($py_exe,'')
		$py_lib = $py_path + $lib 
		$py_lib_dir = $py_lib + $ta_module
		$site_path = $py_lib + $site_module
		$ta_file = ($PROFILE | Split-Path) + "\lib\own_env"
		cp $ta_file $py_lib_dir 
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo "[+] '$py_rootpath' has been updated."
		echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
		echo ""
	} else {
	    Write-Host "Python is not installed or not in the system's PATH."
	}
}


function Get-Size
{
 param([string]$item)
 echo "$((gci -path $item -recurse | measure-object -property length -sum).sum /1gb)"
}

function cpright {
	[CmdletBinding()]
    param([string]$file)
	$docstring = '# -*- coding: UTF-8 -*-
*****************************************************#
'
	if($file){
		if(-not $file.Contains('.py')){
			$file = "$file.py"
		}
		$file_path = whereis $file -nV
		Insert-line $file_path "#{cpright}#" $docstring
	}else{
		Write-Host "[!] A file name is required."
	}
}
