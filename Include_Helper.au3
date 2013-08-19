#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_OutFile=Include_Helper.exe
#AutoIt3Wrapper_icon=Include_Helper.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_Comment=-
#AutoIt3Wrapper_Res_Description=Include_Helper.exe
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=n
#AutoIt3Wrapper_Res_LegalCopyright=AZJIO
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_Field=Version|0.1
#AutoIt3Wrapper_Res_Field=Build|2011.08.08
#AutoIt3Wrapper_Res_Field=Coded by|AZJIO
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


;  @AZJIO 8.08.2011

#cs
Notepad++\shortcuts.xml

<Command name="Include_Helper" Ctrl="yes" Alt="no" Shift="no" Key="118">"$(NPP_DIRECTORY)\..\AutoIt3.exe" "$(NPP_DIRECTORY)\Instrument_azjio\Include_Helper.au3" "$(FULL_CURRENT_PATH)"</Command>


SciTE\Properties\au3.properties

# 39 Include_Helper
command.39.*.au3="$(autoit3dir)\autoit3.exe" "$(SciteDefaultHome)\Instrument_azjio\Include_Helper.au3" "$(FilePath)"
command.name.39.*.au3=Include_Helper
command.save.before.39.*.au3=1
command.is.filter.39.*.au3=1
command.shortcut.39.*.au3=Ctrl+F7
#ce

#include <Array.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>

#NoTrayIcon

; En
$LngFOD='Locate your script'
$LngClp='Copy to Clipboard'
$LngTmr='time'
$LngTm2='sec'
$LngFSF='Select Folder Containing Include Files'
$LngMsB1='Error'
$LngMsB2='Files not found'
$LngMsB3='Remove the old database file to create a new'
$LngMsB4='Message'
$LngMsB5='"Constants" and "Functions" is not found'
$LngMsB6='Functions and variables are not'
$LngAll='All'
$LngMsn='Missing'
$LngUnn='Unnecessary'
$LngAtS='Everything in script'
$LngMtS='Add missing'
$LngUtS='Remove excess'
$LngAtSH='Removes from  script, all of the "Include"'&@CRLF&'and adds to the beginning of the script a list of "'&$LngAll&'"'
$LngMtSH='Adds to the beginning of the script a list of "'&$LngMsn&'"'
$LngUtSH='Deletes from a script "Include"'&@CRLF&'specified in the "'&$LngUnn&'"'
$LngLog='Statistics selection'
$LngUpd='v'
$LngUpdH='Update database file'&@CRLF&'Include_Helper_Data.txt'

$Lang_dll = DllOpen("kernel32.dll")
$UserIntLang=DllCall ( $Lang_dll, "int", "GetUserDefaultUILanguage" )
If Not @error Then $UserIntLang=Hex($UserIntLang[0],4)
DllClose($Lang_dll)

; Ru
; если русская локализация, то русский язык
If $UserIntLang = 0419 Then
	$LngFOD='Выберите ваш скрипт'
	$LngClp='В буфер'
	$LngTmr='время'
	$LngTm2='сек'
	$LngFSF='Выбрать папку Include'
	$LngMsB1='Ошибка'
	$LngMsB2='Файлы не найдены'
	$LngMsB3='Удалите старый файл базы, чтобы создался новый'
	$LngMsB4='Сообщение'
	$LngMsB5='Конастанты и функции не найдены'
	$LngMsB6='Отсутствуют функции и переменные в файле'
	$LngAll='Все'
	$LngMsn='Недостающие'
	$LngUnn='Лишние'
	$LngAtS='Все в скрипт'
	$LngMtS='Добавить недостающие'
	$LngUtS='Удалить лишние'
	$LngAtSH='Удаляет из скрипта все Include'&@CRLF&'и добавляет в начало список "'&$LngAll&'"'
	$LngMtSH='Добавляет в начало скрипта'&@CRLF&'список "'&$LngMsn&'"'
	$LngUtSH='Удаляет из скрипта Include'&@CRLF&'указанные в списке "'&$LngUnn&'"'
	$LngLog='Статистика отбора'
	$LngUpd='v'
	$LngUpdH='Обновить файл базы'&@CRLF&'Include_Helper_Data.txt'
EndIf

Global $StatLog=''
; Global $aConstantsData

If $CmdLine[0]>0 Then
	$Path_AU3 = $CmdLine[1]
Else
	$Path_AU3 = FileOpenDialog($LngFOD, @WorkingDir, "AutoIt Script (*.au3)", 1)
	If @error Then Exit
EndIf

Global $Path=@ScriptDir&'\Include_Helper_Data.txt'
If Not FileExists($Path) Then _CreateData()
$timer = TimerInit()

Global $DataFile = FileRead($Path)
$aDataFile = StringSplit($DataFile, @CRLF&'|'&@CRLF, 1)
If @error Or Not(IsArray($aDataFile) And $aDataFile[0]=4) Then
	MsgBox(0, $LngMsB1, $LngMsB3)
	Exit
EndIf
$aConstantsData = StringSplit($aDataFile[1], @CRLF, 1)
$aFunctionsData = StringSplit($aDataFile[2], @CRLF, 1)
$aIncludeData = StringSplit($aDataFile[4], @CRLF, 1)
$DataFile = $aDataFile[3]

$script_text = FileRead($Path_AU3)
_stripComments($script_text) ; удаление комментариев
$script_text = StringRegExpReplace($script_text, '_[\r\n]+', '') ; удаление переносов строк
; $script_text=StringRegExpReplace($script_text, '(\r\n){2,}', '\1')
; $script_text = StringStripWS($script_text, 3)
$Include_script=StringRegExp($script_text, '(?i)(?=\A|\s)\s*#include\s*[\x3c\x22\x27]*([^\r\n]+?\.au3)', 3) ; возвращает include указанные в скрипте

$Include=''
$exist=0
$a=_Search_Var($script_text) ; возвращает строку переменных скрипта в одном экземпляре
If Not @error Then
	For $i = 1 to $aConstantsData[0]
		$tmp=_Search_Include($aConstantsData[$i]&$a)
		If Not @error Then $Include&=$tmp&';'
	Next
	$exist=1
EndIf

$a=_Search_Fun1($script_text) ; возвращает массив без повторов
If @error And $exist=0 Then
	MsgBox(0, $LngMsB1, 'Нет функций и переменных')
	Exit
EndIf

$text=StringRegExp($script_text, '(?mi)^\h*Func\h+(\w+)', 3) ; добавляем функции скрипта
$DataFile&=';'&_ArrayToString($text, ';')

$a=_Search_Fun2($a) ; возвращает функции в строке исключая стандартные функции и функции скрипта

For $i = 1 to $aFunctionsData[0]
	$tmp=_Search_Include($aFunctionsData[$i]&$a)
	If Not @error Then $Include&=$tmp&';'
Next
$Include=StringTrimRight($Include, 1)

; Минимизировать количество Include
Dim $b[$aIncludeData[0]+1][2]
$b[0][0]=$aIncludeData[0]
For $i = 1 to $aIncludeData[0]
	$tmp=StringRegExp($aIncludeData[$i], '(?i)^(.*?);(.*)$', 3)
	If Not @error Then
		$b[$i][0]=$tmp[0]
		$b[$i][1]=';'&$tmp[1]&';'
	EndIf
Next
$z=';'&$Include&';'
$aInclude = StringSplit($Include, ';')
If Not @error Then
	For $i = 1 to $aInclude[0]
		If $aInclude[$i]<>'' Then
			$aInd = _ArrayFindAll($b, ';'&$aInclude[$i]&';', 1, 0, 0, 1, 1)
			If Not @error Then
				For $n= 0 to UBound($aInd)-1
					If StringInStr($z, ';'&$b[$aInd[$n]][0]&';') Then
						$z=StringReplace($z, ';'&$aInclude[$i]&';', ';')
						For $j= 1 to $aInclude[0]
							If $b[$aInd[$n]][0]=$aInclude[$j] Then $aInclude[$j]=''
						Next
						ExitLoop
					EndIf
				Next
			EndIf
		EndIf
	Next
EndIf
$z=StringTrimLeft($z, 1)
$Include=StringTrimRight($z, 1)
; конец

$kol=0
; все
$IncludeAll=''
$IncludeAll0=''
$kA=0
$aInclude = StringSplit($Include, ';')
If Not @error Then
	$kA=$aInclude[0]
	For $i = 1 to $kA
		$IncludeAll0&='#include <'&$aInclude[$i]&'>'&@CRLF
	Next
	$IncludeAll&=@CRLF&$LngAll&@CRLF&$IncludeAll0
	$kol+=$kA
EndIf

; недостющие
$Missing=''
$Missing0=''
$kM=0
$aMissing=_Missing($Include_script, $aInclude)
If Not @error Then
	$kM=UBound($aMissing)
	For $i = 0 to $kM-1
		$Missing0&='#include <'&$aMissing[$i]&'>'&@CRLF
	Next
	$Missing&=@CRLF&$LngMsn&@CRLF&$Missing0
	$kol+=$kM
EndIf

; лишние
$Unnecessary=''
$Unnecessary0=''
$kU=0
$aUnnecessary=_Unnecessary($aInclude, $Include_script)
If Not @error Then
	$kU=UBound($aUnnecessary)
	For $i = 0 to $kU-1
		$Unnecessary0&='#include <'&$aUnnecessary[$i]&'>'&@CRLF
	Next
	$Unnecessary&=@CRLF&$LngUnn&@CRLF&$Unnecessary0
	$kol+=$kU
EndIf
$kol+=5

If $kol >20 Then $kol = 25
$h=$kol*15+65
If $h<205 Then $h=170
GUICtrlSetResizing(-1,  802)
$GUI=GUICreate('Include Helper AZJIO', 420, $h, -1, -1, $WS_OVERLAPPEDWINDOW)
If Not @compiled Then GUISetIcon(@ScriptDir&'\Include_Helper.ico')

$BtnAtC = GUICtrlCreateButton('^', 260, 10, 20, 24)
GUICtrlSetResizing(-1, 4 + 32 + 256 + 512)
GUICtrlSetTip(-1, $LngClp)

$BtnAtS = GUICtrlCreateButton($LngAtS, 285, 10, 130, 24)
GUICtrlSetResizing(-1, 4 + 32 + 256 + 512)
GUICtrlSetTip(-1, $LngAtSH)
If $kA = 0 Then
	GUICtrlSetState($BtnAtC, $GUI_DISABLE)
	GUICtrlSetState($BtnAtS, $GUI_DISABLE)
EndIf

$BtnMtC = GUICtrlCreateButton('^', 260, 40, 20, 24)
GUICtrlSetResizing(-1, 4 + 32 + 256 + 512)
GUICtrlSetTip(-1, $LngClp)

$BtnMtS = GUICtrlCreateButton($LngMtS, 285, 40, 130, 24)
GUICtrlSetResizing(-1, 4 + 32 + 256 + 512)
GUICtrlSetTip(-1, $LngMtSH)
If $kM = 0 Then
	GUICtrlSetState($BtnMtC, $GUI_DISABLE)
	GUICtrlSetState($BtnMtS, $GUI_DISABLE)
EndIf

$BtnUtC = GUICtrlCreateButton('^', 260, 70, 20, 24)
GUICtrlSetResizing(-1, 4 + 32 + 256 + 512)
GUICtrlSetTip(-1, $LngClp)

$BtnUtS = GUICtrlCreateButton($LngUtS, 285, 70, 130, 24)
GUICtrlSetResizing(-1, 4 + 32 + 256 + 512)
GUICtrlSetTip(-1, $LngUtSH)
If $kU = 0 Then
	GUICtrlSetState($BtnUtC, $GUI_DISABLE)
	GUICtrlSetState($BtnUtS, $GUI_DISABLE)
EndIf

GUICtrlCreateLabel($LngTmr&' : '&Round(TimerDiff($timer) / 1000, 2) & ' '&$LngTm2&@CRLF&StringRegExpReplace($Path_AU3, '(^.*)\\(.*)$', '\2'), 260, 100, 183, 34, 0xC)
GUICtrlSetResizing(-1, 4 + 32 + 256 + 512)

$BtnLog = GUICtrlCreateButton($LngLog, 260, 140, 130, 24)
GUICtrlSetResizing(-1, 4 + 32 + 256 + 512)

$BtnUpd = GUICtrlCreateButton($LngUpd, 395, 140, 20, 24)
GUICtrlSetResizing(-1, 4 + 32 + 256 + 512)
GUICtrlSetTip(-1, $LngUpdH)

$Edit1 = GUICtrlCreateEdit("", 5, 5, 250, $h-10)
GUICtrlSetResizing(-1, 2+4+32+64)
GUICtrlSetData(-1, $IncludeAll&$Missing&$Unnecessary)

GUISetState()
GUIRegisterMsg(0x0024, "WM_GETMINMAXINFO")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case -3
			Exit
		Case $BtnUpd
			If FileExists($Path) Then
				FileSetAttrib($Path, "-RASHT")
				FileDelete($Path)
			EndIf
			_CreateData()
		Case $BtnLog
			MsgBox(8192+262144, $LngLog, $StatLog)
		Case $BtnAtC
			ClipPut(StringTrimRight($IncludeAll0, 4))
		Case $BtnMtC
			ClipPut(StringTrimRight($Missing0, 4))
		Case $BtnUtC
			ClipPut(StringTrimRight($Unnecessary0, 4))
		Case $BtnAtS
			$tmp=FileRead($Path_AU3)
			$tmp=StringRegExpReplace($tmp, '(?i)(?=\A|\s)(\s*#include\s*[\x3c\x22\x27]*[^\r\n]+?\.au3[\x3e\x22\x27])', '')
			$file = FileOpen($Path_AU3, 2)
			FileWrite($file, $IncludeAll0&$tmp)
			FileClose($file)
			GUICtrlSetState($BtnAtS, $GUI_DISABLE)
		Case $BtnMtS
			$tmp=FileRead($Path_AU3)
			$file = FileOpen($Path_AU3, 2)
			FileWrite($file, $Missing0&$tmp)
			FileClose($file)
			GUICtrlSetState($BtnMtS, $GUI_DISABLE)
		Case $BtnUtS
			$tmp=FileRead($Path_AU3)
			$tmp1=''
			For $i = 0 to UBound($aUnnecessary)-1
				$tmp1&=StringTrimRight($aUnnecessary[$i], 4)&'|'
			Next
			$tmp=StringRegExpReplace($tmp, '(?i)(?=\A|\s)(\s*#include\s*[\x3c\x22\x27]*('&StringTrimRight($tmp1, 1)&')\.au3[\x3e\x22\x27])', '')
			$file = FileOpen($Path_AU3, 2)
			FileWrite($file, $tmp)
			FileClose($file)
			GUICtrlSetState($BtnUtS, $GUI_DISABLE)
	EndSwitch
WEnd

Func _Missing($b, $a)
	Local $k
	Assign('/', 1, 1)
	For $i = 0 To UBound($b)-1
		Assign($b[$i]&'/', Eval($b[$i]&'/')+1, 1)
	Next
	$k=0
	For $i = 1 To $a[0]
		Assign($a[$i]&'/', Eval($a[$i]&'/')+1, 1)
		If Eval($a[$i]&'/') = 1 Then
			$a[$k]=$a[$i]
			$k+=1
		EndIf
	Next
	If $k = 0 Then Return SetError(1)
	ReDim $a[$k]
	Return $a
EndFunc

Func _Unnecessary($b, $a)
	Local $k
	Assign('/', 1, 1)
	For $i = 1 To $b[0]
		Assign($b[$i]&'/', Eval($b[$i]&'/')+1, 1)
	Next
	$k=0
	For $i = 0 To UBound($a) -1
		Assign($a[$i]&'/', Eval($a[$i]&'/')+1, 1)
		If Eval($a[$i]&'/') = 1 Then
			$a[$k]=$a[$i]
			$k+=1
		EndIf
	Next
	If $k = 0 Then Return SetError(1)
	ReDim $a[$k]
	Return $a
EndFunc

Func _Search_Include($text)
	Assign('/', 3, 1)
	Local $a = StringSplit($text, ';')
	If Not @error Then
		For $i = 2 To UBound($a) -1
			Assign($a[$i]&'/', Eval($a[$i]&'/')+1, 1)
			If Eval($a[$i]&'/') = 2 Then
				$StatLog&=$a[1]&' - '&$a[$i]&@CRLF
				Return $a[1]
			EndIf
		Next
		Return SetError(1)
	Else
		Return SetError(1)
	EndIf
EndFunc

Func _Search_Var($text)
	Assign('/', 1, 1)
	Local $z, $k, $a
	$z = StringRegExp($text & @CRLF, '(?i)(?<=Const \$)(\w+)', 3) ; исключает константы
	If Not @error Then
		For $i = 0 To UBound($z) -1
			Assign($z[$i]&'/', Eval($z[$i]&'/')+1, 1)
		Next
	EndIf
	$a = StringRegExp($text & @CRLF, '(?<=\$)\w+', 3) ; исключает повторы
	If Not @error Then
		$k=''
		For $i = 0 To UBound($a) -1
			Assign($a[$i]&'/', Eval($a[$i]&'/')+1, 1)
			If Eval($a[$i]&'/') = 1 Then
				$k&=';'&$a[$i]
			EndIf
		Next
		Return $k
	Else
		Return SetError(1)
	EndIf
EndFunc

Func _Search_Fun2($a)
	Local $k, $b
	Assign('/', 1, 1)
	$b = StringSplit($DataFile, ';')
	If Not @error Then
		For $i = 1 To $b[0]
			Assign($b[$i]&'/', Eval($b[$i]&'/')+1, 1)
		Next
		$k=''
		For $i = 0 To UBound($a) -1
			Assign($a[$i]&'/', Eval($a[$i]&'/')+1, 1)
			If Eval($a[$i]&'/') = 1 Then
				$k&=';'&$a[$i]
			EndIf
		Next
		Return $k
	Else
		Return SetError(1)
	EndIf
EndFunc

Func _Search_Fun1($text)
	Assign('/', 1, 1)
	Local $a = StringRegExp($text, '(\w+)\h*\([^*]', 3)
	If Not @error Then
		$k=0
		For $i = 0 To UBound($a) -1
			Assign($a[$i]&'/', Eval($a[$i]&'/')+1, 1)
			If Eval($a[$i]&'/') = 1 Then
				$a[$k]=$a[$i]
				$k+=1
			EndIf
		Next
		ReDim $a[$k]
		Return $a
	Else
		Return SetError(1)
	EndIf
EndFunc

; создание файла функций и констант Include_Helper_Data.txt при первом запуске программы
Func _CreateData()
	Local $sAutoIt_Path, $ConstantsData, $search, $file, $text

	If $CmdLine[0]>1 Then
		$sAutoIt_Path = $CmdLine[2]
	Else
		$sAutoIt_Path = RegRead("HKLM\SOFTWARE\AutoIt v3\AutoIt", "InstallDir")
		If @error Or Not FileExists($sAutoIt_Path) Then
			$sAutoIt_Path = RegRead('HKCU\Software\AutoIt v3\Autoit', 'Include')
			If @error Or Not FileExists($sAutoIt_Path) Then
				$sAutoIt_Path = FileSelectFolder($LngFSF, '')
				If @error Then Exit
			EndIf
		Else
			$sAutoIt_Path&="\Include"
		EndIf
	EndIf

	$size = DirGetSize($sAutoIt_Path, 3)

	$FunctionsData=''
	$ConstantsData=''
	$IncludeData=''
	$search = FileFindFirstFile($sAutoIt_Path&"\*.au3")
	If $search = -1 Then
		MsgBox(0, $LngMsB1, $LngMsB2)
		Exit
	EndIf

	ProgressOn("", "Create Data", "", -1, -1, 3)


	$KolF=0
	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		$KolF+=1
		ProgressSet(Int(100/$size[1]*$KolF), $KolF&' / '&$size[1]& ' '&$file)

		; If $file = 'GUIConstants.au3' Then $file = 'GUIConstantsEx.au3'
		$text=FileRead($sAutoIt_Path&'\'&$file)
		_stripComments($text)

		$tmp = StringRight($file, 13)
		$text2=StringRegExp($text, '(?i)(?=\A|\s)\s*#include\s*[\x3c\x22\x27]*([^\r\n]+?\.au3)', 3) ;возвращает include указанные в скрипте
		If Not @error Then $IncludeData&=$file&';'&_ArrayToString($text2, ';')&@CRLF

		; константы извлекаются только из файлов *Constants.au3 (исключение GUIConstantsEx.au3)
		If $tmp = 'Constants.au3' Or $tmp = 'nstantsEx.au3' Then
			$text2=StringRegExp($text, '(?i)(?<=Global Const \$)\w+', 3)
			If Not @error Then $ConstantsData&=$file&';'&_ArrayToString($text2, ';')&@CRLF
		Else
			; функции извлекаются только из файлов не являющиеся файлами констант. Внутренние функции начинающиеся с "__" игнорируются
			If StringInStr($text, 'GUIRegisterMsg') Then $tmp = StringRegExp($text, '(?i)GUIRegisterMsg\s*\(\s*\$\w+\s*,\s*[\x22\x27](\w+)', 3)

			$text2=StringRegExp($text, '(?mi)^\h*Func\h+(\w+)', 3)
			If Not @error Then
				$text2=_Del_re($text2)
				If IsArray($tmp) Then
					For $i = 0 to UBound($tmp)-1
						$text2=StringReplace($text2&';', ';'&$tmp[$i]&';', ';')
					Next
				EndIf
				$text2=StringRegExpReplace($text2&';', ';__\w+?(?=;)', '')
				$text2=StringRegExpReplace($text2, ';{2,}', ';')
				$text2=StringTrimRight($text2, 1)
				$FunctionsData&=$file&$text2&@CRLF
			EndIf
		EndIf
	WEnd
	FileClose($search)

	If $ConstantsData='' And $FunctionsData='' Then
		MsgBox(0, $LngMsB1, $LngMsB5)
		Exit
	EndIf
; список стандартных функций взят из "AutoIt3\SciTE\Properties\au3.keywords.properties"
; не у всех может оказаться SciTE, поэтому скопировал список
$properties=StringRegExpReplace($sAutoIt_Path, '(^.*\\)(.*)$', '\1')&'SciTE\Properties\au3.keywords.properties'
If FileExists($properties) Then
	$properties = FileRead($properties)
	$properties=StringRegExpReplace($properties, '(?si)(?:.*?au3\.keywords\.functions=)(.*?)(?:au3\.keywords\.udfs.*)', '\1')
	$properties=StringRegExpReplace($properties, '[\s\\]+', ';')
	$FunctionsStr=StringTrimRight($properties, 1)&@CRLF
Else
$FunctionsStr='abs;acos;adlibregister;adlibunregister;asc;ascw;asin;assign;atan;autoitsetoption;autoitwingettitle;autoitwinsettitle;beep;binary;binarylen;binarymid;binarytostring;bitand;bitnot;bitor;bitrotate;bitshift;bitxor;blockinput;break;call;cdtray;ceiling;chr;chrw;clipget;clipput;consoleread;consolewrite;consolewriteerror;controlclick;controlcommand;controldisable;controlenable;controlfocus;controlgetfocus;controlgethandle;controlgetpos;controlgettext;controlhide;controllistview;controlmove;controlsend;controlsettext;controlshow;controltreeview;cos;dec;dircopy;dircreate;dirgetsize;dirmove;dirremove;dllcall;dllcallbackfree;dllcallbackgetptr;dllcallbackregister;dllclose;dllopen;dllstructcreate;dllstructgetdata;dllstructgetptr;dllstructgetsize;dllstructsetdata;drivegetdrive;drivegetfilesystem;drivegetlabel;drivegetserial;drivegettype;drivemapadd;drivemapdel;drivemapget;drivesetlabel;drivespacefree;drivespacetotal;drivestatus;envget;envset;envupdate;eval;execute;exp;filechangedir;fileclose;filecopy;filecreatentfslink;filecreateshortcut;filedelete;fileexists;filefindfirstfile;filefindnextfile;fileflush;filegetattrib;filegetencoding;filegetlongname;filegetpos;filegetshortcut;filegetshortname;filegetsize;filegettime;filegetversion;fileinstall;filemove;fileopen;fileopendialog;fileread;filereadline;filerecycle;filerecycleempty;filesavedialog;fileselectfolder;filesetattrib;filesetpos;filesettime;filewrite;filewriteline;floor;ftpsetproxy;guicreate;guictrlcreateavi;guictrlcreatebutton;guictrlcreatecheckbox;guictrlcreatecombo;guictrlcreatecontextmenu;guictrlcreatedate;guictrlcreatedummy;guictrlcreateedit;guictrlcreategraphic;guictrlcreategroup;guictrlcreateicon;guictrlcreateinput;guictrlcreatelabel;guictrlcreatelist;guictrlcreatelistview;guictrlcreatelistviewitem;guictrlcreatemenu;guictrlcreatemenuitem;guictrlcreatemonthcal;guictrlcreateobj;guictrlcreatepic;guictrlcreateprogress;guictrlcreateradio;guictrlcreateslider;guictrlcreatetab;guictrlcreatetabitem;guictrlcreatetreeview;guictrlcreatetreeviewitem;guictrlcreateupdown;guictrldelete;guictrlgethandle;guictrlgetstate;guictrlread;guictrlrecvmsg;guictrlregisterlistviewsort;guictrlsendmsg;guictrlsendtodummy;guictrlsetbkcolor;guictrlsetcolor;guictrlsetcursor;guictrlsetdata;guictrlsetdefbkcolor;guictrlsetdefcolor;guictrlsetfont;guictrlsetgraphic;guictrlsetimage;guictrlsetlimit;guictrlsetonevent;guictrlsetpos;guictrlsetresizing;guictrlsetstate;guictrlsetstyle;guictrlsettip;guidelete;guigetcursorinfo;guigetmsg;guigetstyle;guiregistermsg;guisetaccelerators;guisetbkcolor;'
$FunctionsStr&='guisetcoord;guisetcursor;guisetfont;guisethelp;guiseticon;guisetonevent;guisetstate;guisetstyle;guistartgroup;guiswitch;hex;hotkeyset;httpsetproxy;httpsetuseragent;hwnd;inetclose;inetget;inetgetinfo;inetgetsize;inetread;inidelete;iniread;inireadsection;inireadsectionnames;inirenamesection;iniwrite;iniwritesection;inputbox;int;isadmin;isarray;isbinary;isbool;isdeclared;isdllstruct;isfloat;ishwnd;isint;iskeyword;isnumber;isobj;isptr;isstring;log;memgetstats;mod;mouseclick;mouseclickdrag;mousedown;mousegetcursor;mousegetpos;mousemove;mouseup;mousewheel;msgbox;number;objcreate;objevent;objevent;objget;objname;onautoitexitregister;onautoitexitunregister;opt;ping;pixelchecksum;pixelgetcolor;pixelsearch;pluginclose;pluginopen;processclose;processexists;processgetstats;processlist;processsetpriority;processwait;processwaitclose;progressoff;progresson;progressset;ptr;random;regdelete;regenumkey;regenumval;regread;regwrite;round;run;runas;runaswait;runwait;send;sendkeepactive;seterror;setextended;shellexecute;shellexecutewait;shutdown;sin;sleep;soundplay;soundsetwavevolume;splashimageon;splashoff;splashtexton;sqrt;srandom;statusbargettext;stderrread;stdinwrite;stdioclose;stdoutread;string;stringaddcr;stringcompare;stringformat;stringfromasciiarray;stringinstr;stringisalnum;stringisalpha;stringisascii;stringisdigit;stringisfloat;stringisint;stringislower;stringisspace;stringisupper;stringisxdigit;stringleft;stringlen;stringlower;stringmid;stringregexp;stringregexpreplace;stringreplace;stringright;stringsplit;stringstripcr;stringstripws;stringtoasciiarray;stringtobinary;stringtrimleft;stringtrimright;stringupper;tan;tcpaccept;tcpclosesocket;tcpconnect;tcplisten;tcpnametoip;tcprecv;tcpsend;tcpshutdown;tcpstartup;timerdiff;timerinit;tooltip;traycreateitem;traycreatemenu;traygetmsg;trayitemdelete;trayitemgethandle;trayitemgetstate;trayitemgettext;trayitemsetonevent;trayitemsetstate;trayitemsettext;traysetclick;trayseticon;traysetonevent;traysetpauseicon;traysetstate;traysettooltip;traytip;ubound;udpbind;udpclosesocket;udpopen;udprecv;udpsend;udpshutdown;udpstartup;vargettype;winactivate;winactive;winclose;winexists;winflash;wingetcaretpos;wingetclasslist;wingetclientsize;wingethandle;wingetpos;wingetprocess;wingetstate;wingettext;wingettitle;winkill;winlist;winmenuselectitem;winminimizeall;winminimizeallundo;winmove;winsetontop;winsetstate;winsettitle;winsettrans;winwait;winwaitactive;winwaitclose;winwaitnotactive'&@CRLF
EndIf

	_MaxIncludeData($IncludeData) ; добавляет вложенные Include

	$file = FileOpen($Path, 2)
	FileWrite($file, $ConstantsData&'|'&@CRLF&$FunctionsData&'|'&@CRLF&$FunctionsStr&'|'&@CRLF&$IncludeData)
	FileClose($file)
	ProgressOff()
EndFunc

Func _MaxIncludeData(ByRef $a)
	$a = StringTrimRight($a, 2)
	$a = StringSplit($a, @CRLF, 1)
	Local $b[$a[0]+1][3]
	$b[0][0]=$a[0]
	For $i = 1 to $a[0]
		$tmp=StringRegExp($a[$i], '(?i)^(.*?);(.*)$', 3)
		If Not @error Then
			$b[$i][0]=$tmp[0]
			$b[$i][1]=$tmp[1]
			$b[$i][2]=StringLen($b[$i][1])
		EndIf
	Next
	$TrRe=0
	$KolRe=0
	While $KolRe<10 ; цикл не более 10 повторов с выходом при неизменном результате массива $b
		For $i = 1 to $b[0][0]
			For $j = 1 to $b[0][0]
				If $i<>$j And StringInStr(';'&$b[$j][1]&';', ';'&$b[$i][0]&';') Then
					$b[$j][1]&=';'&$b[$i][1]
					$b[$j][1]=_Del_Re_MaxInc($b[$j][1])
					$tmp=StringLen($b[$j][1])
					If $tmp>$b[$j][2] Then
						$TrRe=1
						$b[$j][2]=$tmp
					EndIf
				EndIf
			Next
		Next
		If $TrRe = 0 Then ExitLoop
		$TrRe = 0
		$KolRe+=1
	WEnd

	$a=''
	For $i = 1 to $b[0][0]
		$a&=$b[$i][0]&';'&$b[$i][1]&@CRLF
	Next
EndFunc

Func _Del_Re_MaxInc($a)
	Assign('/', 1, 1)
	$a = StringSplit($a, ';')
	Local $k=''
	For $i = 1 To $a[0]
		Assign($a[$i]&'/', Eval($a[$i]&'/')+1, 1)
		If Eval($a[$i]&'/') = 1 Then
			$k&=$a[$i]&';'
		EndIf
	Next
	Return StringTrimRight($k, 1)
EndFunc

Func _Del_re($a)
	Assign('/', 1, 1)
	Local $k=''
	For $i = 0 To UBound($a) -1
		Assign($a[$i]&'/', Eval($a[$i]&'/')+1, 1)
		If Eval($a[$i]&'/') = 1 Then
			$k&=';'&$a[$i]
		EndIf
	Next
	Return $k
EndFunc

Func WM_GETMINMAXINFO($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg, $wParam
	If $hWnd = $GUI Then
		Local $tMINMAXINFO = DllStructCreate("int;int;" & _
				"int MaxSizeX; int MaxSizeY;" & _
				"int MaxPositionX;int MaxPositionY;" & _
				"int MinTrackSizeX; int MinTrackSizeY;" & _
				"int MaxTrackSizeX; int MaxTrackSizeY", _
				$lParam)
		DllStructSetData($tMINMAXINFO, "MinTrackSizeX", 390)
		DllStructSetData($tMINMAXINFO, "MinTrackSizeY", 205)
	EndIf
EndFunc

; заимствовано из "Organize Includes"
Func _stripComments(ByRef $string)
	;Author: Prog@ndy
	$string = StringReplace(StringReplace($string, "#comments-start", "#cs", 0, 2), "#comments-end", "#ce", 0, 2)
	$string = StringRegExpReplace($string, "(?si)(\v|\A)\h*#cs\b.*?\v\h*#ce\b", '') ; remove simple block comments (мод AZJIO)
	#region remove nested block-comments
	Local $match, $depth, $offset, $start, $CommentsAfterce
	While 1
		$depth = 0
		$match = StringRegExp($string, "(?im)^\h*#cs\b", 1)
		$start = @extended
		If @error Then ExitLoop
		Do
			$match = StringRegExp($string, "(?im)^\h*#c([se])\b", 1, $offset)
			$offset = @extended
			Select
				Case @error
					Return False
				Case $match[0] = "e"
					$depth -= 1
				Case Else
					$depth += 1
			EndSelect
		Until $depth < 1

		$string = StringLeft($string, $start - 4) & StringRegExpReplace(StringMid($string, $offset), ".*", '', 1)
;~         $string = StringLeft($string, $start-4) & StringMid($string, $offset)
	WEnd
	#endregion remove nested block-comments
	$string = StringRegExpReplace($string, '(?m)^((?:[^''";]*([''"]).*?\2)*[^;]*);.*$', '\1') ; remove one-line comments
	Return True
EndFunc   ;==>_stripComments
