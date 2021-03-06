#Include <File.au3>
#Include <Array.au3>
#include <Debug.au3>
#Include <RPDv2.au3>
#Include <Date.au3>

_debugSetup ( "Debug!")

Global $NewOrderFile, $onum = "", $line = "", $arrTemp = 0
$oshipmethod = 0
$NewOrders = FileOpen("NEW_ORDERS.TXT", 0)
$cctype = 0
$visaNum = "4111111111111111"
$amexNum = "378282246310005"
$discNum = "6011111111111117"
$masterNum = "5555555555554444"
$paypalcc = "38000000000006"
$googlecheckoutcc = "3566111111111113"
$ground = 0
$2day = 0
$3day = 0
$pri = 0
$freeship = 0
Dim $oldtemplog

Func setupasw()
WinActivate("Session A - [24 x 80]", "")
	Send("go asw")
	Send("{ENTER}")
	Send("go sales1")
	Send("{ENTER}")
	Send("1")
	Send("{ENTER}")
	Send("JDB")
	Send("{TAB}")
	Send("{TAB}")
	Send("JDB")
	Send("{TAB}")
	Send("{TAB}")
	Send("JB")
; End ASW Setup Section
EndFunc

Func splitnow()

If _FileReadToArray("NEW_ORDERS.TXT", $NewOrderFile) == 0 Then
    MsgBox(0,"error", "Error reading in file.")
    Exit
EndIf


For $curLine = 1 To $NewOrderfile[0]

    ;clean and split the current line
    $line = StringSplit(StringStripWS($NewOrderFile[$curLine],7), ",")

    If $onum <> $line[1] Then
        ;the order number is different
        $onum = $line[1]

        ;send the array for the last order number on for processing
        ;added isArray check to prevent sending on the first loop
        If IsArray($arrTemp) Then
            processOrders($arrTemp)
        EndIf

        ;start a new temp array for the new order number
        Dim $arrTemp[1] = [$NewOrderFile[$curLine]]

    Else
        ;the order number is the same, add the line to the temp array for the current order number
        _ArrayAdd($arrTemp,$NewOrderFile[$curLine])
    EndIf

Next

;send along the last order number after the FOR loop hits the last line in the file
If UBound($arrTemp) Then
    processOrders($arrTemp)
EndIf

EndFunc

Func processOrders($arrOrders)

    ;work with array $arrOrders here, all elements will be lines with the same order number
    ; ( $arrOrders is array of plain text lines, each element is an entire line from the file )
    ; _ArrayDisplay($arrOrders)

	sleep(1000)


    For $order In $arrOrders

            $order = StringSplit(StringStripWS($order,7), ",")

            WinActivate("Session A - [24 x 80]", "")

				Send("{ENTER}")
                Send($order[18])  ; item number
                Send("{NUMPADADD}")
                Send($order[20])  ; item qty
                Send("{NUMPADADD}")
                Send("{TAB}")
                Send("{TAB}")
                Send("{TAB}")
                Send("{TAB}")
                Send($order[21])  ; per item price
                Send("{NUMPADADD}")

			Next

			dship($order)
EndFunc

Func dship(ByRef $order)

Send("{ENTER}")

	If StringInStr($order[11], "Ground") Then
		$oshipmethod = 300
	EndIf

	If StringInStr($order[11], "2nd Day") Then
		$oshipmethod = 210
	EndIf

	If StringInStr($order[11], "3 Day") Then
		$oshipmethod = 220
	EndIf

	If StringInStr($order[11], "Priority Mail") Then
		$oshipmethod = 910
	EndIf

	If StringInStr($order[11], "Free Shipping") Then
		$oshipmethod = 100
	EndIf

	f9($order)

EndFunc

Func f9(ByRef $order)

	WinActivate("Session A - [24 x 80]", "")
	Send("{F9}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
;	Send($order[1])  ; Invoice-Prefix
	Send($order[1])  ; Invoice Num
	Send("{NUMPADADD}")
;;;;;;;;;;;;;  NEW TOP SECTION ;;;;;;;;;;;;;;;

	If StringInStr($order[13], "5") Then   ; array[13] is paymethodtype
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
		Send("{TAB}")
		Send("{TAB}")
		Send("{TAB}")
		Send("{TAB}")
		Send("{TAB}")
		Send("{TAB}")
		Send("GG")
		Send("{NUMPADADD}")
		Send("{ENTER}")
	EndIf
	If StringInStr($order[13], "4") Then
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
		Send("{TAB}")
		Send("{TAB}")
		Send("{TAB}")
		Send("{TAB}")
		Send("{TAB}")
		Send("{TAB}")
		Send("PP")
		Send("{NUMPADADD}")
		Send("{ENTER}")
		Send("{ENTER}")
	Else
		Send("{ENTER}")
	EndIf

		If $oshipmethod=300 Then
			Send("{TAB}")
			Send("{TAB}")
			Send("{TAB}")
			Send("{TAB}")
			Send("{TAB}")
			Send("{TAB}")
			Send("{TAB}")
			Send($order[10])  ; shipping cost
			Send("{NUMPADADD}")
			Send("{ENTER}")
			Send("{ENTER}")
		Else
			Send("{TAB}")
			Send("{TAB}")
			Send($oshipmethod)
			Send("{ENTER}")
			Send("{TAB}")
			Send("{TAB}")
			Send("{TAB}")
			Send("{TAB}")
			Send("{TAB}")
			Send("{TAB}")
			Send("{TAB}")
			Send($order[10])  ; shipping cost
			Send("{NUMPADADD}")
			Send("{ENTER}")
			Send("{ENTER}")
		EndIf

	resellercheck($order)
EndFunc

; NEW SECTION : RESELLER_CHECK BEGIN

Func resellercheck(ByRef $order)
	If StringInStr($order[9], "CA") And $order[15] = 0 Then
			f8reseller($order)
		Else
			f8($order)
		EndIf
EndFunc

; NEW SECTION : RESELLER_CHECK END

Func f8(ByRef $order)

	WinActivate("Session A - [24 x 80]", "")

	Send("{F8}")
	Send("{TAB}")
	Send("1")
	Send("{ENTER}")
	Send("{TAB}")
	Send("999")
	Send("{NUMPADADD}")
	Send($order[2])  ; first name
	Send("{SPACE}")
	Send($order[3])  ; last name
	Send("{NUMPADADD}")
	Send($order[5])  ; shipping address Line 1
	Send("{NUMPADADD}")
	Send($order[6])  ; shipping address Line 2
	Send("{NUMPADADD}")
	Send($order[4])  ; Company name
	Send("{NUMPADADD}")
	Send($order[7])  ; City
	Send("{NUMPADADD}")
	Send($order[9])  ; State
	Send("{NUMPADADD}")
	Send($order[8])  ; Zip
	Send("{NUMPADADD}")
	Send("{ENTER}")
	WinWait("Session A - [24 x 80]", "")
	Send("{ENTER}")
	WinWait("Session A - [24 x 80]", "")
	Send("{F6}")
	Send("{ENTER}")
	WinWait("Session A - [24 x 80]", "")
	Send("{F12}")
dpay($order)
EndFunc

Func f8reseller(ByRef $order)

	WinActivate("Session A - [24 x 80]", "")

	Send("{F8}")
	Send("{TAB}")
	Send("1")
	Send("{ENTER}")
	Send("{TAB}")
	Send("999")
	Send("{NUMPADADD}")
	Send($order[2])  ; first name
	Send("{SPACE}")
	Send($order[3])  ; last name
	Send("{NUMPADADD}")
	Send($order[5])  ; shipping address Line 1
	Send("{NUMPADADD}")
	Send($order[6])  ; shipping address Line 2
	Send("{NUMPADADD}")
	Send($order[4])  ; Company name
	Send("{NUMPADADD}")
	Send($order[7])  ; City
	Send("{NUMPADADD}")
	Send($order[9])  ; State
	Send("{NUMPADADD}")
	Send($order[8])  ; Zip
	Send("{NUMPADADD}")
	Send("NOTAX")
	Send("{NUMPADADD}")
	Send("{ENTER}")
	WinWait("Session A - [24 x 80]", "")
	Send("{ENTER}")
	WinWait("Session A - [24 x 80]", "")
	Send("{F6}")
	Send("{ENTER}")
	WinWait("Session A - [24 x 80]", "")
	Send("{F12}")
dpay($order)
EndFunc

Func dpay(ByRef $order)


	If StringInStr($order[13], "5") Then   ; array[14] is paymethodtype
		$cctype = $googlecheckoutcc
		gcheckout($order)
	EndIf

	If StringInStr($order[12], "Visa") and StringInStr($order[13], "2") Then  ; array[13] is cardtype if present
		$cctype = $visaNum
		ccheckout($order)
	EndIf
	If StringInStr($order[12], "American Express") and StringInStr($order[13], "2") Then
		$cctype = $amexNum
		ccheckout($order)
	EndIf
	If StringInStr($order[12], "Discover") and StringInStr($order[13], "2") Then
		$cctype = $discNum
		ccheckout($order)
	EndIf
	If StringInStr($order[12], "Mastercard") and StringInStr($order[13], "2") Then
		$cctype = $masterNum
		ccheckout($order)
	EndIf

	If StringInStr($order[13], "4") Then ;and StringInStr($array[14], "") Then
		$cctype = $paypalcc
		pcheckout($order)
	EndIf
EndFunc

Func cataxfix($order)


	If StringInStr($order[9], "CA") Then
		Do
		$continue = MsgBox(0, "CA TAX FIX", "CA Tax Detected, Verify Rounding and Click 'OK'.")
		Until $continue = 1
	EndIf
EndFunc

Func gcheckout(ByRef $order)

	WinActivate("Session A - [24 x 80]", "")

	Send("{F7}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send($order[14])  ; array[15] is order total $ amount
	Send("{NUMPADADD}")
	Send($cctype)
	Send("{NUMPADADD}")
	Send("1213")
	Send("{NUMPADADD}")
	Send("{TAB}")
	Send("1")
	cataxfix($order)
	Send("{ENTER}")
	Send("{F12}")
	Send("+{TAB}")
	Send("+{TAB}")
	Send("22")
	Send("{ENTER}")

;	If $order[14] > 100 Then
;		Send(".")
;		Send("{ENTER}")
;		Send("*** HIGH VALUE ORDER ***")
;		Send("{ENTER}")
;	EndIf
;
;	If $order[16] = "" Then
;		Send("{F12}")
;		Send("{F12}")
;	Else
;		Send(".")
;		Send("{ENTER}")
;		Send("*** CUSTOMER COMMENT ***")
;		Send("{ENTER}")
;		Send("{F12}")
;		Send("{F12}")
;	EndIf
;
;	orderlog($order)
;
	oriskassessment($order)

EndFunc

Func ccheckout(ByRef $order)

	WinActivate("Session A - [24 x 80]", "")

	Send("{F7}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send($order[14])  ; array[15] is order total $ amount
	Send("{NUMPADADD}")
	Send($cctype)
	Send("{NUMPADADD}")
	Send("1213")
	Send("{NUMPADADD}")
	Send("{TAB}")
	Send("1")
	cataxfix($order)
	Send("{ENTER}")
	Send("{F12}")
	Send("+{TAB}")
	Send("+{TAB}")
	Send("22")
	Send("{ENTER}")

;	If $order[14] > 100 Then
;		Send(".")
;		Send("{ENTER}")
;		Send("*** HIGH VALUE ORDER ***")
;		Send("{ENTER}")
;	EndIf
;
;	If $order[16] = "" Then
;		Send("{F12}")
;		Send("{F12}")
;	Else
;		Send(".")
;		Send("{ENTER}")
;		Send("*** CUSTOMER COMMENT ***")
;		Send("{ENTER}")
;		Send("{F12}")
;		Send("{F12}")
;	EndIf
;
;	orderlog($order)
;
	oriskassessment($order)

EndFunc

Func pcheckout(ByRef $order)

	WinActivate("Session A - [24 x 80]", "")

	Send("{F7}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send($order[14])  ; array[15] is order total $ amount
	Send("{NUMPADADD}")
	Send($cctype)
	Send("{NUMPADADD}")
	Send("1213")
	Send("{NUMPADADD}")
	Send("{TAB}")
	Send("1")
	cataxfix($order)
	Send("{ENTER}")
	Send("{F12}")
	Send("+{TAB}")
	Send("+{TAB}")
	Send("22")
	Send("{ENTER}")

	oriskassessment($order)

EndFunc

Func oriskassessment(ByRef $order)
	$cleanbilladd = StringStripWS($order[17], 8)
	$cleanshipadd = StringStripWS($order[5], 8)
		If $cleanbilladd <> $cleanshipadd Or $order[14] > 100 Or $oshipmethod = 210 Or $oshipmethod = 220 Then
			Send(".")
			Send("{ENTER}")
			Send("*** HIGH RISK ORDER ***")
			Send("{ENTER}")
		EndIf
		If $cleanbilladd <> $cleanshipadd Then
			Send("          Failed Address Match")
			Send("{ENTER}")
		EndIf
		If	$order[14] > 100 Then
			Send("          High Value")
			Send("{ENTER}")
		EndIf
		If $oshipmethod = 210 Or $oshipmethod = 220 Then
			Send("          Expedited Shipping")
			Send("{ENTER}")
		EndIf
		If $order[16] = "" Then
			Send("{F12}")
			Send("{F12}")
		Else
			Send(".")
			Send("{ENTER}")
			Send("*** CUSTOMER COMMENT ***")
			Send("{ENTER}")
			Send("{F12}")
			Send("{F12}")
		EndIf

	orderlog($order)

EndFunc

;;;;;;;; LOG SECTION ;;;;;;;;;;;

;;;;;;;;; ORDER PROCESSED LOG BEGIN ;;;;;;;;;;;

Func orderlog(ByRef $order)
	$logfile = FileOpen("orderlog.txt", 1)
		FileWriteLine($logfile, $order[1] & " " & _DateTimeFormat(_NowCalc(),0))
		FileClose($logfile)
		countshipping($order)
	EndFunc

Func beginbatch()
	$logfile = FileOpen("orderlog.txt", 1)
		FileWriteLine($logfile, "~~~~~~~ START BATCH ~~~~~~~ " & _DateTimeFormat(_NowCalc(),0))
		FileClose($logfile)
	EndFunc

Func endbatch()
	$logfile = FileOpen("orderlog.txt", 1)
		FileWriteLine($logfile, "~~~~~~~ FINISH BATCH ~~~~~~~ " & _DateTimeFormat(_NowCalc(),0))
		FileClose($logfile)
	EndFunc

;;;;;;;;; ORDER PROCCESSED LOG END ;;;;;;;;;;

;;;;;;;;; SHIPMENT LOG BEGIN ;;;;;;;;;;

Func beginshiplog()
	$shiplog = FileOpen("shipmentlog.txt", 1)
		FileWriteLine($shiplog, "~~~~~~~ START BATCH ~~~~~~~ " & _DateTimeFormat(_NowCalc(),0))
		FileClose($shiplog)
	EndFunc

Func shipmentlog()

	$shiplog = FileOpen("shipmentlog.txt", 1)
	FileWriteLine($shiplog, "UPS GROUND ....... = "&$ground&"")
	FileWriteLine($shiplog, "UPS 2 DAY ........ = "&$2day&"")
	FileWriteLine($shiplog, "UPS 3 DAY ........ = "&$3day&"")
	FileWriteLine($shiplog, "USPS PRIORITY MAIL = "&$pri&"")
	FileWriteLine($shiplog, "FREE SHIPPING .... = "&$freeship&"")
	FileClose($shiplog)

EndFunc

Func countshipping(ByRef $order)

	If StringInStr($order[11], "Ground") Then
		$ground = $ground + 1
	EndIf
	If StringInStr($order[11], "2nd Day") Then
		$2day = $2day + 1
	EndIf
	If StringInStr($order[11], "3 Day") Then
		$3day = $3day + 1
	EndIf
	If StringInStr($order[11], "Priority Mail") Then
		$pri = $pri + 1
	EndIf
	If StringInStr($order[11], "Free Shipping") Then
		$freeship = $freeship + 1
	EndIf

	$templogfile = FileOpen("templog.txt", 2)
		FileWriteLine($templogfile, $ground)
		FileWriteLine($templogfile, $2day)
		FileWriteLine($templogfile, $3day)
		FileWriteLine($templogfile, $pri)
		FileWriteLine($templogfile, $freeship)
	FileClose($templogfile)

EndFunc

Func endshiplog()
	$shiplog = FileOpen("shipmentlog.txt", 1)
		FileWriteLine($shiplog, "~~~~~~~ FINISH BATCH ~~~~~~~ " & _DateTimeFormat(_NowCalc(),0))
		FileClose($shiplog)
		MsgBox(0, "~~~~ Batch Shipment Log ~~~~", "UPS GROUND ............. = "&$ground&"" & @CRLF & "UPS 2 DAY ................ = "&$2day&"" & @CRLF & "UPS 3 DAY ................ = "&$3day&"" & @CRLF & "USPS PRIORITY MAIL ... = "&$pri&"" & @CRLF & "FREE SHIPPING .......... = "&$freeship&"")
	EndFunc

Func cleartemplog()  ; clear temp log file function
	$question = MsgBox(4, "NEW BATCH?", "Purge Temp Files and Start New Batch?")
	If $question = 6 Then
		$templog = FileOpen("templog.txt", 2)
		FileClose($templog)
	EndIf
	If $question = 7 Then
		$templog = FileOpen("templog.txt", 0)
		$ground = FileReadLine($templog)
		$2day = FileReadLine($templog)
		$3day = FileReadLine($templog)
		$pri = FileReadLine($templog)
		$freeship = FileReadLine($templog)
		FileClose($templog)
	EndIf
EndFunc

;;;;;;;;; SHIPMENT LOG END ;;;;;;;;;;;

cleartemplog()
beginbatch()
beginshiplog()
setupasw()
splitnow()
endbatch()
shipmentlog()
endshiplog()