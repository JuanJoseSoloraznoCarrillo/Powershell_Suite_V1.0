#REQUIRES -Version 1.0
<#
.SYNOPSIS
	GitComCom is a module created to facilte the git commands in powershell.
.DESCRIPTION
	There are many commands that you can use with the powershell profile.
.NOTES
    File Name      : GitComCom.psm1
    Author         : Solorzano, Juan Jose (uiv06924)
    Prerequisite   : PowerShell V1
#>
#------ Importing PS1 Modules ------#
$exe_path = Get-Location
Set-Location $HOME
$root_path = Get-Location
$modules_path = $root_path.Path + '\Documents\WindowsPowerShell\lib\{0}.psm1'
Import-Module -Name ($modules_path -f "Helpers") -DisableNameChecking
Set-Location $exe_path
#--------- MAIN FUNCTION <prompt> -----------#
function Write-BranchName () {
	$marks = "<{}>";
    try {
        $branch = git rev-parse --abbrev-ref HEAD
		if($null -eq $branch){$marks = ""}
        if ($branch -eq "HEAD") 
		{
            # we're probably in detached HEAD state, so print the SHA
            $branch = git rev-parse --short HEAD
            Write-Host $marks.Replace("{}",$branch) -ForegroundColor "red" -NoNewLine `
        }
        else 
		{
            # we're on an actual branch, so print it
			if(git status --porcelain | where {$_ -match '^\?\?' })
			{
				# Untracked files exist
				Write-Host $marks.Replace("{}","**$branch") -ForegroundColor "blue" -NoNewLine `
			}
			elseif(git status --porcelain | where {$_ -notmatch '^\?\?'})
			{
				# uncommitted changes
				Write-Host $marks.Replace("{}","++$branch") -ForegroundColor "blue" -NoNewLine `
			}
			else
			{
				# tree is clean
				Write-Host $marks.Replace("{}",$branch) -ForegroundColor "blue" -NoNewLine `
			}
        }
    } 
	catch 
	{
        # we'll end up here if we're in a newly initiated git repo
        Write-Host "" -ForegroundColor "yellow" -NoNewLine `
    }
}

function mbr{
	$br_name = git rev-parse --abbrev-ref HEAD
	return $br_name
}
function Git-Graph{
    echo "************************************************"
    echo "            GIT GRAPH VIEW "
    echo "************************************************"
	git log --all --decorate --oneline --graph
}
function Git-Branch {
	[CmdletBinding()]
    param (
        [string]$n, #the branch name given
		[switch]$s #search all branches
    )
	$all_branches = git branch -a
	$idx = 0 
	$branches_name = @()
	if($n){
		$name = $n
		foreach($branch in $all_branches){
			if($branch.Contains($name))
			{
				$branch = $branch.replace("remotes/origin/","")
				git checkout $branch.Trim()
				break
			}
		}
	}
	elseif($s){
		foreach($br in $all_branches)
		{	
			Write-Host $idx ':' $br.replace('remotes/origin/','') -ForegroundColor "green" 
			$branches_name += $br
			$idx = $idx + 1
		}
		setBra($branches_name)
	}
	else{
		echo "[help] Usages:"
		echo "Git-Bran -n <[the branch's name or the Jira card number]> -s <shows all branches>"
		echo ">> Git-Bra -n 'SETV-####' | >> Git-Bra -n 'ewdt' "
		echo ">> Git-Bra -s"
	}
}

function SetBra($branches) {
	$idx = read-host "[+] Select branch number"
	if($idx)
	{
		if($branches[$idx].Contains("*"))
		{
			$branch = $branches[$idx].replace("* ","")
		}else
		{
			$branch = $branches[$idx].replace("remotes/origin/","")
		}
		Set-Clipboard $branch.Trim()
		git checkout $branch.Trim()
	}
}

function Repo($repo) {
	try {
		$repo=$repo.ToUpper()  
		$None=$false
	}
	catch {
		Write-Output "Which repo???"
		$None=$true
	}
	if(-not $None){
	    if($repo -eq "")
	    {
	        return 
	    }
	    elseif($repo -eq "") 
	    {
	        return 
	    }
	    elseif($repo -eq "") 
	    {
	        return 
	    }
	    elseif($repo -eq "")
	    {
	        return 
	    }
	    elseif ($repo -eq ""){
	        return 
	    }
		elseif($repo -eq ""){
			return 
		}
		elseif($repo -eq ""){
			return 
		}
		elseif($repo -eq ""){
			return 
		}
		elseif($repo -eq "") {
			return 
		}
		elseif($repo -eq ""){
			return 
		}
	    else{echo "Repository <$repo> don't found !!!!!!!!!"}
	}
}

function Ignore{
	[CmdletBinding()]
    param ([string]$folder)
	if($folder){
		$output = whereis -item $folder -verbose $false
		if($output.GetType().BaseType.Name -eq 'Array'){
			foreach($item in $output){
				if(-not $item.contains('out')){
					$output = $item
					break
				}
			}
		}
		$add_string = $output + "\*"
		Write-Host ">>Adding: $add_string"
		git add $add_string
		Write-Host ">> adding $folder to git tracking. (done)"
	}
	else {
		echo "[!] >>The folder for commit is needed."
	}
}

function Git-Push{
	[CmdletBinding()]
    param (
		[string]$folder,
        [string]$commit
    )
    Write-Host ">> git pull --all (done)"
    git pull --all
	if($folder){
		Ignore $folder
	}else{
    	git add "."
        Write-Host ">> git add --all (done)"
	}
	if($commit){
    	git commit -m $commit
    	Write-Output ">> commit added: '$commit'"
        Write-Host "-------------------------------------------------------------"
    	git push origin (mbr)
	}
	else {
		Write-Output "push command needs to have a commit!!!"
	}
}
