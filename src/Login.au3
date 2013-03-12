#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>

#comments-start
# ===== USB Verification System =====
#
# Author: Nathan Taylor
# Date: 3/10/2013
#
# Required Files     		
# Folder: Directory	
#
# This is the Login file for a USB 
# verification system which requires
# a password for use of a USB.
# You'll need the rest of the files
# included in the distribution of 
# this program for the code to work.
# ===================================
#comments-end

Global Const $EM_SETCUEBANNER = 0x1501

Local $sInput, $sPassword, $iError, $iAttempts

$sPassword = "bastion"
$iAttempts = 0

While $iError <> 1
   $iAttempts += 1
   
   $sInput = InputBox("Password Verification", "This device is encrypted. Please enter your password to access the device." &  _
		 @CRLF & @CRLF & "Do not attempt to bypass this screen, any attempts to cicrumvent security will result in a complete wipe of the device." & _
		 @CRLF & @CRLF & "If this device was found please email nathan_taylor@clarkalc.net", "", "*", 255, 233)
		 
   $iError = @Error

   If $sInput == "" Or $sInput <> $sPassword Then 
	  MsgBox(1, "Incorrect Password", "You have entered an incorrect password." & _
		 @CRLF & @CRLF & "Please make another attempt.")
   Else
	  MsgBox(1, "Correct Password", "Welcome back sir." & _
		 @CRLF & @CRLF & "Your file directory has been revealed.")
	  Run("attrib -s -h " & @ScriptDir & "\Directory")
	  Exit
   EndIf
		 
   If Mod($iAttempts, 5) == 0 Then 
	  While RequireCaptcha() <> True 
	  WEnd
   EndIf
WEnd

Func RequireCaptcha()
   Local $iCaptcha = Int(Random(111111, 999999))
   $hCaptchaUI= GUICreate("CAPTCHA Phrase", 348, 192, 506, 490)
   $hCaptchaLabel = GUICtrlCreateLabel($iCaptcha, 8, 8, 332, 89, $SS_CENTER)
   GUICtrlSetFont($hCaptchaLabel, 60)
   GUICtrlCreateLabel("You have entered an incorrect login too many times." & _
		 @CRLF & "For verification please enter the combination of numbers above.", 8, 112, 332, 33)
   $hInput = GUICtrlCreateInput("", 8, 160, 249, 21, $SS_CENTER)
   GUICtrlSendMsg($hInput, $EM_SETCUEBANNER, True, "Enter the Captcha phrase here.")
   $hOk = GUICtrlCreateButton("OK", 264, 160, 75, 25)
   GUISetState(@SW_SHOW)
   
   While 1
	  $sMsg = GUIGetMsg()
	  Switch $sMsg
		 Case $hOk
			If GUICtrlRead($hInput) <> $iCaptcha Then 
			   MsgBox(1, "Incorrect CAPTCHA", "The numbers you entered were incorrect." & _
			   @CRLF & "Please make another attempt.")
			   GUIDelete($hCaptchaUI)	   
			   Return False
			Else
			   GUIDelete($hCaptchaUI)	
			   Return True
			EndIf
		 Case $GUI_EVENT_CLOSE
			Exit
	  EndSwitch
   WEnd
EndFunc