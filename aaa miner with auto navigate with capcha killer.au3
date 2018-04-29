#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <String.au3>
#include <EditConstants.au3>
#include <GUIEdit.au3>
#include <Math.au3>

$letter = _StringBetween ( "[a][b][c][d][e][f][0][1][2][3][4][5][6][7][8][9]", "[", "]")
$lettertry = -1
$x=289;282
$y =210

$autoright = False
$autoup = False
$autodown = False
$autoleft = False

Func reset()
	$lettertry = -1
	$x=289;282
	$y=210
	$count = $x + 31
EndFunc

Func reload()
	$lettertry = -1
EndFunc

Func captcha()
	_IELoadWait($oIE)
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
	ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", $final)
	If $x < $count Then
		$x=$x+8
		reload()
		captcha()
	EndIf
	If $x > $count Then
	reset()
	resume()
	EndIf
EndFunc

Func resume()
	If $autoleft = True Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{enter}")
		_IELoadWait($oIE)
		$autoleft = False
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{left}")
		_IELoadWait($oIE)
		autoleft()
		EndIf
	If $autoup = True Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{enter}")
		_IELoadWait($oIE)
		$autoup = False
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{up}")
		_IELoadWait($oIE)
		autoup()
		EndIf
	If $autodown = True Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{enter}")
		_IELoadWait($oIE)
		$autodown = False
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{down}")
		_IELoadWait($oIE)
		autodown()
		EndIf
	If $autoright = True Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{enter}")
		_IELoadWait($oIE)
		$autoright = False
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{right}")
		_IELoadWait($oIE)
		autoright()
	EndIf
EndFunc

HotKeySet("{esc}", "esc")
Func esc()
	Exit
EndFunc
;~ ---------------------------------------------------------------------------------------------------------------------------------
$gui = GUICreate("The Pit", 230, 352)
$labelemail = GUICtrlCreateLabel("Email:", 5, 5, 50)
GUICtrlSetFont(-1, 12, 400, 6, "arial")
$email = GUICtrlCreateCombo("", 55, 5, 170)
;~ ---------------------------------------------------------------------------------------------------------------------------------
$ini = IniReadSectionNames("aaaaccouts.ini")
If Not @error Then
	For $i = 1 To $ini[0] Step +1
		GUICtrlSetData($email, $ini[$i])
	Next
EndIf
;~ ---------------------------------------------------------------------------------------------------------------------------------
GUICtrlCreatePic ("pit.jpg",5,160,222,182)
;~ ---------------------------------------------------------------------------------------------------------------------------------
$remember_me = GUICtrlCreateCheckbox("Remember Me", 5, 35, 170)
GUICtrlSetFont(-1, 12, 400, 6, "arial")
;~ GUICtrlSetState  ($remember_me,$GUI_CHECKED)
;~ ---------------------------------------------------------------------------------------------------------------------------------
$labelpass = GUICtrlCreateLabel("Pass:", 5, 65, 50)
GUICtrlSetFont(-1, 12, 400, 6, "arial")
$pass = GUICtrlCreateInput("", 55, 65, 170, 22, $ES_PASSWORD)
;~ ---------------------------------------------------------------------------------------------------------------------------------
$save_password = GUICtrlCreateCheckbox("Save Password", 5, 95, 170)
GUICtrlSetFont(-1, 12, 400, 6, "arial")
;~ ---------------------------------------------------------------------------------------------------------------------------------
$submit = GUICtrlCreateButton("Submit", 5, 125, 110)
GUICtrlSetFont(-1, 12, 400, 6, "arial")
;~ ---------------------------------------------------------------------------------------------------------------------------------
$cancel = GUICtrlCreateButton("Cancel", 115, 125, 110)
GUICtrlSetFont(-1, 12, 400, 6, "arial")
;~ ---------------------------------------------------------------------------------------------------------------------------------
GUISetState()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $email
			$read = GUICtrlRead($email)
			$read = IniRead("aaaaccouts.ini", $read, "pass", "")
			$length = StringLen($read)
			If $length > 0 Then
				GUICtrlSetState($save_password, $GUI_CHECKED)
				GUICtrlSetState($pass, $GUI_focus)
				GUICtrlSetState($save_password, $GUI_ENABLE)
			EndIf
			If $length = 0 Then
				GUICtrlSetState($pass, $GUI_focus)
			EndIf
			GUICtrlSetData($pass, $read)
			GUICtrlSetState($remember_me, $GUI_CHECKED)
		Case $remember_me
			$state = GUICtrlRead($remember_me)
			If $state = 4 Then
				GUICtrlSetState($save_password, $GUI_UNCHECKED)
				GUICtrlSetState($save_password, $GUI_DISABLE)
			EndIf
			$state = GUICtrlRead($remember_me)
			If $state = 1 Then
				GUICtrlSetState($save_password, $GUI_ENABLE)
			EndIf
		Case $submit
			$email1 = GUICtrlRead($email)
			$remember_me1 = GUICtrlRead($remember_me)
			$pass1 = GUICtrlRead($pass)
			$save_password1 = GUICtrlRead($save_password)
			$length = StringLen($email1)
			If $length < 3 Then
				ContinueLoop
			EndIf
			$length = StringLen($pass1)
			If $length = 6 Then
				ContinueLoop
			EndIf
			If $remember_me1 = 1 Then
				IniWrite("aaaaccouts.ini", $email1, "email", $email1)
			EndIf
			If $save_password1 = 1 Then
				IniWrite("aaaaccouts.ini", $email1, "pass", $pass1)
			EndIf
			If $remember_me1 = 4 Then
				IniDelete("aaaaccouts.ini", $email1)
			EndIf
			If $save_password1 = 4 Then
				IniDelete("aaaaccouts.ini", $email1, "pass")
			EndIf
			ExitLoop
		Case $cancel
			Exit
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd
;~ --------------------------------------------------------------------------------------------------------------------------------
GUICtrlDelete($email)
GUICtrlDelete($remember_me)
GUICtrlDelete($pass)
GUICtrlDelete($save_password)
GUICtrlDelete($submit)
GUICtrlDelete($cancel)
GUICtrlDelete($labelpass)
GUICtrlDelete($labelemail)
;~ --------------------------------------------------------------------------------------------------------------------------------
;~ --------------------------------------------------------------------------------------------------------------------------------
;~ --------------------------------------------------------------------------------------------------------------------------------
;~ --------------------------------------------------------------------------------------------------------------------------------
;~ --------------------------------------------------------------------------------------------------------------------------------
WinMove($gui, "", 0, 0, 800, 600)
;~ --------------------------------------------------------------------------------------------------------------------------------
$oIE = ObjCreate("Shell.Explorer.2")
GUICtrlCreateObj($oIE, 0, 0, 793, 495)
$oIE.navigate("alienaa.com")
_IELoadWait($oIE)
GUISetState()
;~ --------------------------------------------------------------------------------------------------------------------------------
$ylabel=0
Do
	For $xlabel=0 To 75 Step 5
		GUICtrlCreateLabel ("t",700+$xlabel,500+$ylabel,5,5)
		GUICtrlSetBkColor ( -1, 0xECE9D8 )
		GUICtrlSetColor ( -1, 0xECE9D8)
	Next
$ylabel=$ylabel+5
Until $ylabel=60
;~ --------------------------------------------------------------------------------------------------------------------------------
;~ --------------------------------------------------------------------------------------------------------------------------------


;~ --------------------------------------------------------------------------------------------------------------------------------
;~ --------------------------------------------------------------------------------------------------------------------------------

GUICtrlCreatePic ("aaalogo.jpg",5,500,690,65)
;~ --------------------------------------------------------------------------------------------------------------------------------
$levelnumber=GUICtrlCreateLabel("Level: ", 715, 555,1000,1000)
;~ --------------------------------------------------------------------------------------------------------------------------------
$oForm = _IEFormGetObjByName($oIE, "alien")
$oText = _IEFormElementGetObjByName($oForm, "email")
_IEFormElementSetValue($oText, $email1)
;~ --------------------------------------------------------------------------------------------------------------------------------
$oForm = _IEGetObjByName($oIE, "alien")
$oText = _IEFormElementGetObjByName($oForm, "pass")
_IEFormElementSetValue($oText, $pass1)
;~ --------------------------------------------------------------------------------------------------------------------------------
$var1 = -1
Do
	$var1 = $var1 + 1
	$oInputs = _IETagNameGetCollection($oIE, "input", $var1)
Until $oInputs.value = "login"
_IEAction($oInputs, "click")
_IELoadWait($oIE)
;~ --------------------------------------------------------------------------------------------------------------------------------
HotKeySet("{=}", "map")
HotKeySet("{up}", "up")
HotKeySet("{down}", "down")
HotKeySet("{left}", "left")
HotKeySet("{right}", "right")
$captchapass = False

_IELinkClickByText($oIE, "The Pit")
_IELoadWait($oIE)


$sText = _IEBodyReadText ($oIE)
$level=_StringBetween  ($sText,"You can use items, look at your map, or read your logbook. If you're feeling particularly strung out, you can walk out of the pit, but that'll cost you ", " motivation.")
GUICtrlSetData ($levelnumber,"Level: " & $level[0])
;~ --------------------------------------------------------------------------------------------------------------------------------
Func map()
	ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{m}")
	_IELoadWait($oIE)
$oImgs = _IEImgGetCollection ($oIE)
GUICtrlSetBkColor ( 4, 0x998675)
GUICtrlSetData (4,"t")
GUICtrlSetColor ( 4, 0x998675)
$id=5
For $oImg In $oImgs
	If $oImg.src = "http://www.alienaa.com/images/aaa/art/here.gif" Then
		GUICtrlSetBkColor ( $id, 0xFF0000)
		GUICtrlSetData ($id,"h")
		GUICtrlSetColor ( $id, 0xFF0000)
		$id=$id+1
	EndIf
	If $oImg.src = "http://www.alienaa.com/images/aaa/art/taken.gif" Then
		GUICtrlSetBkColor ( $id, 0x998675)
		GUICtrlSetData ($id,"t")
		GUICtrlSetColor ( $id, 0x998675)
		$id=$id+1
	EndIf
	If $oImg.src = "http://www.alienaa.com/images/aaa/art/free.gif" Then
		GUICtrlSetBkColor ( $id, 0xFFFFFF)
		GUICtrlSetData ($id,"f")
		GUICtrlSetColor ( $id, 0xFFFFFF)
		$id=$id+1
		EndIf
	Next
EndFunc
map()
;~ --------------------------------------------------------------------------------------------------------------------------------
$light=false
$dark=false
Func down()
	$down=3
	Do
		$down=$down+1
		$here=GUICtrlRead ($down)
	Until $here = "h"
	$below=GUICtrlRead($down+16)
	If $below = "f" Then
		GUICtrlSetBkColor ( $down+16, 0xFF0000)
		GUICtrlSetData ($down+16,"h")
		GUICtrlSetColor ( $down+16, 0xFF0000)
		GUICtrlSetBkColor ( $down, 0xFFFFFF)
		GUICtrlSetData ($down,"f")
		GUICtrlSetColor ( $down, 0xFFFFFF)
		$sText = _IEBodyReadText ($oIE)
		$level=_StringBetween  ($sText,"You can use items, look at your map, or read your logbook. If you're feeling particularly strung out, you can walk out of the pit, but that'll cost you ", " motivation.")
		GUICtrlSetData ($levelnumber,"Level: " & $level[0])
	EndIf
EndFunc
;~ --------------------------------------------------------------------------------------------------------------------------------
Func right()
	$down=3
	Do
		$down=$down+1
		$here=GUICtrlRead ($down)
	Until $here = "h"
	$below=GUICtrlRead($down+1)
	If $below = "f" Then
		GUICtrlSetBkColor ( $down+1, 0xFF0000)
		GUICtrlSetData ($down+1,"h")
		GUICtrlSetColor ( $down+1, 0xFF0000)
		GUICtrlSetBkColor ( $down, 0xFFFFFF)
		GUICtrlSetData ($down,"f")
		GUICtrlSetColor ( $down, 0xFFFFFF)
		$sText = _IEBodyReadText ($oIE)
		$level=_StringBetween  ($sText,"You can use items, look at your map, or read your logbook. If you're feeling particularly strung out, you can walk out of the pit, but that'll cost you ", " motivation.")
		GUICtrlSetData ($levelnumber,"Level: " & $level[0])
		$light=false
		$dark=false
	EndIf
EndFunc
;~ --------------------------------------------------------------------------------------------------------------------------------
Func left()
	$down=3
	Do
		$down=$down+1
		$here=GUICtrlRead ($down)
	Until $here = "h"
	$below=GUICtrlRead($down-1)
	If $below = "f" Then
		GUICtrlSetBkColor ( $down-1, 0xFF0000)
		GUICtrlSetData ($down-1,"h")
		GUICtrlSetColor ( $down-1, 0xFF0000)
		GUICtrlSetBkColor ( $down, 0xFFFFFF)
		GUICtrlSetData ($down,"f")
		GUICtrlSetColor ( $down, 0xFFFFFF)
		$sText = _IEBodyReadText ($oIE)
		$level=_StringBetween  ($sText,"You can use items, look at your map, or read your logbook. If you're feeling particularly strung out, you can walk out of the pit, but that'll cost you ", " motivation.")
		GUICtrlSetData ($levelnumber,"Level: " & $level[0])
		$light=false
		$dark=false
	EndIf
EndFunc
;~ --------------------------------------------------------------------------------------------------------------------------------
Func up()
	$down=3
	Do
		$down=$down+1
		$here=GUICtrlRead ($down)
	Until $here = "h"
	$below=GUICtrlRead($down-16)
	If $below = "f" Then
		GUICtrlSetBkColor ( $down-16, 0xFF0000)
		GUICtrlSetData ($down-16,"h")
		GUICtrlSetColor ( $down-16, 0xFF0000)
		GUICtrlSetBkColor ( $down, 0xFFFFFF)
		GUICtrlSetData ($down,"f")
		GUICtrlSetColor ( $down, 0xFFFFFF)
		$sText = _IEBodyReadText ($oIE)
		$level=_StringBetween  ($sText,"You can use items, look at your map, or read your logbook. If you're feeling particularly strung out, you can walk out of the pit, but that'll cost you ", " motivation.")
		GUICtrlSetData ($levelnumber,"Level: " & $level[0])
	EndIf
EndFunc

;~ --------------------------------------------------------------------------------------------------------------------------------

Func autodown()
	$down=3
	
	Do
		$down=$down+1
		$here=GUICtrlRead ($down)
	Until $here = "h"
	
	$above=GUICtrlRead($down-16)
	$below=GUICtrlRead($down+16)
	$left=GUICtrlRead($down-1)
	$right=GUICtrlRead($down+1)
	
	$motivation=_IEBodyReadText ($oIE)
	$motivation=_StringBetween ($motivation,"Motivation: "," [get more]")
If $motivation[0] > 0 Then
	_IELinkClickByText ($oIE,"mine")
	If Not @error Then
		_IELoadWait($oIE)
		$captcha=_IEBodyReadText ($oIE)
		$captcha = StringInStr ($captcha,"captcha")
		If $captcha > 0 Then
			$autodown = True
			captcha()
		EndIf
	EndIf
EndIf
	
	_IELinkClickByText ($oIE,"down")
	If Not @error Then
		_IELoadWait($oIE)
		_IELinkClickByText ($oIE,"Onwards!")
		_IELoadWait($oIE)
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{down}")
		_IELoadWait($oIE)
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{=}")
		_IELoadWait($oIE)
		autodown()
	EndIf
	If $left = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{left}")
		_IELoadWait($oIE)
		Sleep (100)
		autoleft()
	ElseIf  $below = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{down}")
		_IELoadWait($oIE)
		Sleep (100)
		autodown()
	ElseIf $right = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{right}")
		_IELoadWait($oIE)
		Sleep (100)
		autoright()
	ElseIf $above = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{up}")
		_IELoadWait($oIE)
		Sleep (100)
		autoup()
	EndIf
EndFunc

;~ --------------------------------------------------------------------------------------------------------------------------------

Func autoleft()
	$down=3
	
	Do
		$down=$down+1
		$here=GUICtrlRead ($down)
	Until $here = "h"
	
	$above=GUICtrlRead($down-16)
	$below=GUICtrlRead($down+16)
	$left=GUICtrlRead($down-1)
	$right=GUICtrlRead($down+1)
	
	$motivation=_IEBodyReadText ($oIE)
	$motivation=_StringBetween ($motivation,"Motivation: "," [get more]")
If $motivation[0] > 0 Then
	_IELinkClickByText ($oIE,"mine")
	If Not @error Then
		_IELoadWait($oIE)
		$captcha=_IEBodyReadText ($oIE)
		$captcha = StringInStr ($captcha,"captcha")
		If $captcha > 0 Then
			$autoleft = True
			captcha()
		EndIf
	EndIf
EndIf

	If $above = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{up}")
		_IELoadWait($oIE)
		Sleep (100)
		autoup()
	ElseIf $left = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{left}")
		_IELoadWait($oIE)
		Sleep (100)
		autoleft()
	ElseIf $below = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{down}")
		_IELoadWait($oIE)
		Sleep (100)
		autodown()
	ElseIf $right = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{right}")
		_IELoadWait($oIE)
		Sleep (100)
		autoright()
	EndIf
EndFunc

;~ --------------------------------------------------------------------------------------------------------------------------------

Func autoup()
	$down=3
	
	Do
		$down=$down+1
		$here=GUICtrlRead ($down)
	Until $here = "h"
	
	$above=GUICtrlRead($down-16)
	$below=GUICtrlRead($down+16)
	$left=GUICtrlRead($down-1)
	$right=GUICtrlRead($down+1)
	
	$motivation=_IEBodyReadText ($oIE)
	$motivation=_StringBetween ($motivation,"Motivation: "," [get more]")
If $motivation[0] > 0 Then
	_IELinkClickByText ($oIE,"mine")
	If Not @error Then
		_IELoadWait($oIE)
		$captcha=_IEBodyReadText ($oIE)
		$captcha = StringInStr ($captcha,"captcha")
		If $captcha > 0 Then
			$autoup = True
			captcha()
		EndIf
	EndIf
EndIf

	_IELinkClickByText ($oIE,"up")
	If Not @error Then
		_IELoadWait($oIE)
		_IELinkClickByText ($oIE,"Onwards!")
		If Not @error Then
			_IELoadWait($oIE)
			ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{up}")
			_IELoadWait($oIE)
			ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{=}")
			_IELoadWait($oIE)
			autoup()
;~ 			autodown()
		EndIf
;~ 		_IELinkClickByText ($oIE,"Light!")
;~ 		If Not @error Then
;~ 			_IELoadWait($oIE)
;~ 			_IELinkClickByText ($oIE,"The Pit")
;~ 			_IELoadWait($oIE)
;~ 			_IELinkClickByText ($oIE,"Grain Storage")
;~ 			_IELoadWait($oIE)
;~ 			_IELinkClickByText ($oIE,"enter")
;~ 			_IELoadWait($oIE)
;~ 			ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{down}")
;~ 			_IELoadWait($oIE)
;~ 			ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{=}")
;~ 			_IELoadWait($oIE)
;~ 			autodown()
;~ 		EndIf
	EndIf

	If $right = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{right}")
		_IELoadWait($oIE)
		Sleep (100)
		autoright()
	ElseIf $above = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{up}")
		_IELoadWait($oIE)
		Sleep (100)
		autoup()
	ElseIf $left = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{left}")
		_IELoadWait($oIE)
		Sleep (100)
		autoleft()
	ElseIf $below = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{down}")
		_IELoadWait($oIE)
		Sleep (100)
		autodown()
	EndIf
EndFunc

;~ --------------------------------------------------------------------------------------------------------------------------------

Func autoright()
	$down=3
	
	Do
		$down=$down+1
		$here=GUICtrlRead ($down)
	Until $here = "h"
	
	$above=GUICtrlRead($down-16)
	$below=GUICtrlRead($down+16)
	$left=GUICtrlRead($down-1)
	$right=GUICtrlRead($down+1)
	
	$motivation=_IEBodyReadText ($oIE)
	$motivation=_StringBetween ($motivation,"Motivation: "," [get more]")
If $motivation[0] > 0 Then
	_IELinkClickByText ($oIE,"mine")
	If Not @error Then
		_IELoadWait($oIE)
		$captcha=_IEBodyReadText ($oIE)
		$captcha = StringInStr ($captcha,"captcha")
		If $captcha > 0 Then
			$autoright = True
			captcha()
		EndIf
	EndIf
EndIf

	If $below = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{down}")
		_IELoadWait($oIE)
		Sleep (100)
		autodown()
	ElseIf $right = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{right}")
		_IELoadWait($oIE)
		Sleep (100)
		autoright()
	ElseIf $above = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{up}")
		_IELoadWait($oIE)
		Sleep (100)
		autoup()
	ElseIf $left = "f" Then
		ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{left}")
		_IELoadWait($oIE)
		Sleep (100)
		autoleft()
	EndIf
EndFunc

;~ --------------------------------------------------------------------------------------------------------------------------------
While 1
	ControlSend ( $gui, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{up}")
	_IELoadWait($oIE)
	autoup()
WEnd
;~ --------------------------------------------------------------------------------------------------------------------------------
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd