#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <Misc.au3>
#include <Array.au3>

; регистрация нажатия ESC для выхода из программы
HotKeySet("{ESC}", "Terminate")

; Инициализация тикера
$symbPrev = ""

; "Вечный" цикл отображения окна формы
While 1

   ; Берем видимый текст с активного окна
   Local $hActiveText = WinGetText("[ACTIVE]", "")

   ConsoleWrite("AT" & $hActiveText & @CRLF)

   ; Сравниваем полученную выше строку с известным значением WinGetText() для фильтров Madscan
   If StringInStr($hActiveText, "toolStripContainer1") = 2 Then

	  ConsoleWrite("MS: " & $hActiveText & @CRLF)

	  ; Если активное окно - это фильтр Madscan, то посылаем ему Ctrl+C для копирования в буфер всей строки, которая под мышкой
      Send("{CTRLDOWN}C{CTRLUP}")

	  ; Убираем из строки часть из времени алерта (которое в американском формате, например 1:13 PM)
      Local $Clip = StringRegExpReplace (ClipGet(), ":\d+\s[A|P]M", "", 0)

      ; Выбираем из отстатка строки тикер
      Local $TickerArray = StringRegExp($Clip, '([A-Z|\.\-\+]+)\s', 1, 1)
      Local $Ticker = _ArrayToString($TickerArray, "")
	  ConsoleWrite("$TickerArray: " & $TickerArray & @CRLF)
	  ConsoleWrite("$Ticker: " & $Ticker & @CRLF)

	  ; Обновляем $symbPrev
	  $symbPrev = $Ticker

	  ; Активируем окно Level2 в Arche
       _WinWaitActivate("[CLASS:SunAwtFrame]", "")
      Local $hLevelII = ControlGetHandle("[CLASS:SunAwtFrame]", "", "")
	  ;ConsoleWrite("$hLevelII: " & $hLevelII & @CRLF)
	  ; ControlClick("", "", "[CLASS:SunAwtFrame]", "left", 2, 106, 66)
      ControlSend ("", "", $hLevelII, $Ticker & "{ENTER}", 0)
	  ConsoleWrite("@error: " & @error & @CRLF)

   EndIf

   ; Если нажата правая клавиша мышки - выход из цикла
   If _IsPressed("02") Then
      ExitLoop
   EndIf

	; Снятие нагрузки с процессора
	Sleep(500)

WEnd

; Функция активации окна
Func _WinWaitActivate($title,$text,$timeout=0)
    WinWait($title,$text,$timeout)
    If Not WinActive($title,$text) Then WinActivate($title,$text)
    WinWaitActive($title,$text,$timeout)
 EndFunc

; Выход из программы
Func Terminate()
    Exit 0
 EndFunc

