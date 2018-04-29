#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <String.au3>
#include <EditConstants.au3>
#include <GUIEdit.au3>
#include <Math.au3>

HotKeySet ("{end}","info")
$letter = _StringBetween ( "[a][b][c][d][e][f][0][1][2][3][4][5][6][7][8][9]", "[", "]")
$lettertry = -1
Func captcha()
;~ 	_IELoadWait($oIE)
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
;~ 	ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", $final)
MsgBox (0,$final,$final)
	If $x < $count Then
		$x=$x+8
		$lettertry = -1
		captcha()
	EndIf
	If $x > $count Then
	$lettertry = -1
	resume()
	EndIf
EndFunc

Func info()
	$xpix = -1
	$x1 = 12
	$x2 = $x1 + 199
	$y1 = 109
	$y2 = $y1 + 49		
	Do		
		$xpix = $xpix+1
		$pix = PixelSearch ($x2-$xpix,$y1,$x2-$xpix,$y2,13693136)
	Until Not @error
	Global $x = $pix[0]-37
	$xpix = -1
	Do
		$xpix = $xpix+1
		$pix = PixelSearch ($x1,$y2-$xpix,$x2,$y2-$xpix,13693136)
	Until Not @error
	Global $y = $pix[1]-9
	
	Global $count = $x + 31
	MsgBox (0, $x & "," & $y, $count)
	captcha()
EndFunc
			
Func resume()
	While 1
	WEnd
EndFunc
			
			resume()