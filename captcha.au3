#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <String.au3>
#include <EditConstants.au3>
#include <GUIEdit.au3>
#include <Math.au3>
HotKeySet ( "{end}","captcha")
HotKeySet ( "{esc}","esc")

Func reset()
	$lettertry = -1
	$x=93
	$y=125
EndFunc

Func reload()
	$lettertry = -1
EndFunc

Func esc()
	Exit
EndFunc



$letter = _StringBetween ( "[a][b][c][d][e][f][0][1][2][3][4][5][6][7][8][9]", "[", "]")
$lettertry = -1
$x=93
$y=125

Func captcha()
	$lettertry = $lettertry+1
	$colums = 0
	Do
		For $rows = 0 To 5
			$first = PixelGetColor ($x+$rows,$y+$colums)
			$second = IniRead ("Captcha.ini",$letter[$lettertry],$colums+1,"")
			$second= _StringBetween ($second,"[","]")
			If $first = $second[$rows] Then
			Else
				captcha()
			EndIf
		Next
		$colums = $colums + 1
	Until $colums = 10
	$final = $letter[$lettertry]
	MsgBox (0,$final,$final)
	If $x < 124 Then
		$x=$x+8
		reload()
		captcha()
	EndIf
	If $x > 124 Then
	reset()
	snooze()
	EndIf
EndFunc

Func snooze()
	While 1
	WEnd
EndFunc
snooze()