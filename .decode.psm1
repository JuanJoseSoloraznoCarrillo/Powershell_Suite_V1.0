#NOTE:
# this script should be in the home directory.
# set the home directory as default path by:
# %windir%\System32\rundll32.exe sysdm.cpl,EditEnvironmentVariables
# usage:
#  PS> $code = codegen "mycode"
#  PS> $decodification = decode $code 
#  PS> echo $decodification  --> output: "mycode"

$SEED=0000 #the seed has been modified.
$TOKEN = @{
    u = [Char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    l = [Char[]]'abcdefghijklmnopqrstuvwxyz'
    n = [Char[]]'0123456789'
    s = [Char[]]'!"#$%&''()*+,-.:;<=>?@[\]_~'
}
function codegen([string]$target){
	if($target){
		$output=$target
        $upper = Get-Random -SetSeed $SEED -Count 1 -InputObject $TOKEN.u
        $lower = Get-Random -SetSeed $SEED -Count 1 -InputObject $TOKEN.l
        $number = Get-Random -SetSeed $SEED -Count 1 -InputObject $TOKEN.n
        $special = Get-Random -SetSeed $SEED -Count 1 -InputObject $TOKEN.s
        $part1 = -join ($output[0..(([math]::ceiling($output.Length/2))-1)])
        $part2 = -join ($output[(([math]::ceiling($output.Length/2)))..$output.Length])
        $string = $part1+$upper+$lower+$part2+$special+$number
        $str_codifed = (Get-Random -SetSeed $SEED -Count 15 -InputObject $string) -join ''
		return ($str_codifed | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString)
	}
}
function decode($pass){
	if($pass){
	    $code = $pass | ConvertTo-SecureString
	    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($code)
	    $decodeStr = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        $upper = Get-Random -SetSeed $SEED -Count 1 -InputObject $TOKEN.u
        $lower = Get-Random -SetSeed $SEED -Count 1 -InputObject $TOKEN.l
        $number = Get-Random -SetSeed $SEED -Count 1 -InputObject $TOKEN.n
        $special = Get-Random -SetSeed $SEED -Count 1 -InputObject $TOKEN.s
        $part1 = -join ($decodeStr[0..((($decodeStr.Length)/2)-1)])
        $part2 = -join ($decodeStr[(($decodeStr.Length)/2)..$decodeStr.Length])
        $i1 = $decodeStr.IndexOf($upper)
        $i2 = $decodeStr.IndexOf($lower)
        $i3 = $decodeStr.IndexOf($special) #no needed for decodefication.
        $i4 = $decodeStr.IndexOf($number)
        return -join ($part1[0..($i1-1)] + $part2[0..($part2.length -3)])
	}
}
function get-textPlain{
    [CmdletBinding()]
    param([switch]$h)
    $str = "[here the encode data generated with the codegen function]"
    Set-Clipboard (decode $str) # decode the string and set the clipboard
    if($h){return}
    else{return decode $str}
}
