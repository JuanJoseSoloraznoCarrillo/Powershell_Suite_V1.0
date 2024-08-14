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
function get-chn{
    [CmdletBinding()]
    param([switch]$h)
    $str = "01000000d08c9ddf0115d1118c7a00c04fc297eb0100000003453cfbdae41042b7543b18001aa2e800000000020000000000106600000001000020000000f8f7eb25b946a75a11f858642f508a904e86a4e33fe2e9b63e827180bd6f210c000000000e8000000002000020000000af852df1ed3378677bbc5ebbf386e1f3f72d84fa17a15df48ddba64e1a4131a330000000d01505cd7a67c5011e580402df7426635c9ae71b51f4fb6e3f6a15b602d37a4271fb3db3ad261a8305dcb5221f725f2b400000001a3c53a7b593781e874f3fa56d7666f1a3a705b5eddd5bb59402a89f5b310b7069b9ebec371b46f3fc793fe3e44b55639f2318176d9ae535e1824478b9542814"
    Set-Clipboard (decode $str)
    if($h){return}
    else{return decode $str}
}
function get-bln{
    [CmdletBinding()]
    param([switch]$h)
    $str = "01000000d08c9ddf0115d1118c7a00c04fc297eb0100000003453cfbdae41042b7543b18001aa2e800000000020000000000106600000001000020000000c36e5b1ee803977f2c9a1233f86e7710a03ecf46368505cf68662e483ee3c87d000000000e8000000002000020000000b1718d395c50e30b75e6cc426cb3a66e58da0801f41f277dcd3c2e0bf84e836040000000f354d16451120f94c982385646976a1dd1d376c3a7d19e7985ee8f667695360aab9082adbd04cb45d24a58e2cb34743a39ba7236df7325af215c745b6d440b8d40000000606ed0abccd55f6db83cb90396f08e99dc2d0450bededf40e5ecb1bad8fc0e7678eb113d53e929c113d3462e715854446245a55cc93f9b36f17e77ea0c219383"
    Set-Clipboard (decode $str)
    if($h){return}
    else{return decode $str}
} 
function get-gdl{
    [CmdletBinding()]
    param([switch]$h)
    $str = "01000000d08c9ddf0115d1118c7a00c04fc297eb0100000003453cfbdae41042b7543b18001aa2e8000000000200000000001066000000010000200000009604af4ede671b70850d8420ca5719e0adb5b9a4c99a91fb8db90e52afda2c99000000000e80000000020000200000005c453934aecde71842c11feadb77e9c12de1385436d135f9f149b4947208c5834000000088c07b817a87db38c51253f2d4401c0a808298c5e91b98ca3beaefd4be083c2d4a358b389e6b96f4b865f73414219ee19f370c79d9061b51485a628c86898cef400000004e1167414d840d9f8d68008ce56b3be716e5998ef2ec3c90a8372329cd9a7eed009c747b3047cfe856b48e578efe9e66b138f035f1d1942d64999bda207c7f5e"
    Set-Clipboard (decode $str)
    if($h){return}
    else{return decode $str}
}
function get-abh{ 
    [CmdletBinding()]
    param([switch]$h)
    if($h){get-gdl -h}
    else{get-gdl} 
}
function get-rgb {
    [CmdletBinding()]
    param([switch]$h)
    $str = "01000000d08c9ddf0115d1118c7a00c04fc297eb0100000003453cfbdae41042b7543b18001aa2e80000000002000000000010660000000100002000000092d9df2b4f8d7be970d422826e7c3bf5961310e4115853db60103ffb0e89b238000000000e800000000200002000000011423c0d2aef48f94efa736533820c64eecb23263f98dfbf10cc4643ef40fe6830000000c4b7b74ee8b964904edf9fdc00425d7157d2b05a7c0e261fd044026daa37f924502374f464fad2fc66ba244f96db96cf400000001261e264bbee339a1646f5bd02c753f283bfdcb224a8b86452a93a1bb2e9b48441f60be5c3a21964e2e9f4df1c7352e3f798838a19c0bf19c30f3e8100c8613e"
    Set-Clipboard (decode $str)
    if($h){return}
    else{return decode $str}
}
