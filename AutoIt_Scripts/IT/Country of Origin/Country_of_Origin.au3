$file = FileOpen("COFO.TXT", 0)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

; Variables
$startdate = "121807"
$enddate = "123115"

; Read in lines of text until the EOF is reached
	WinActivate("Session A - [24 x 80]", "")
	Send("PROD")
	Send("{ENTER}")
	Send("{TAB}")
	Send("BLANK")
	Send("{TAB}")
	Send("{TAB}")
	
While 1
    $line = FileReadLine($file)
    If @error = -1 Then ExitLoop
	$clean = StringStripWS($line, 8)  
	$array = StringSplit($clean, ",")
    WinActivate("Session A - [24 x 80]", "")
	Send($array[1])
	Send("{ENTER}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	SEND($array[2])
	Send("{numpadadd}")
	Send("{ENTER}")
	Send("{ENTER}")
	Send("{F12}")
	Send("{F12}")
	Send("{F12}")
	
Wend




FileClose($file)