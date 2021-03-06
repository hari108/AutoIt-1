; *** WSUS Offline Update 6.8.1 - Generator ***
; ***      Author: T. Wittrock, Kiel        ***
; ***    USB-Option added by Ch. Riedel     ***
; ***  Dialog scaling added by Th. Baisch   ***

#include <GUIConstants.au3>

Dim Const $caption                = "WSUS Offline Update 6.8.1"
Dim Const $title                  = $caption & " - Generator"
Dim Const $donationURL            = "http://www.wsusoffline.net/donate.html"
Dim Const $downloadLogFile        = "download.log"

; Registry constants
Dim Const $reg_key_fontdpi        = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontDPI"
Dim Const $reg_key_windowmetrics  = "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics"
Dim Const $reg_val_applieddpi     = "AppliedDPI"
Dim Const $reg_val_logpixels      = "LogPixels"

; Message box return codes
Dim Const $msgbox_btn_ok          = 1
Dim Const $msgbox_btn_cancel      = 2
Dim Const $msgbox_btn_abort       = 3
Dim Const $msgbox_btn_retry       = 4
Dim Const $msgbox_btn_ignore      = 5
Dim Const $msgbox_btn_yes         = 6
Dim Const $msgbox_btn_no          = 7
Dim Const $msgbox_btn_tryagain    = 10
Dim Const $msgbox_btn_continue    = 11

; Defaults
Dim Const $default_logpixels      = 96

; INI file constants
Dim Const $ini_section_wxp        = "Windows XP"
Dim Const $ini_section_w2k3       = "Windows Server 2003"
Dim Const $ini_section_w2k3_x64   = "Windows Server 2003 x64"
Dim Const $ini_section_w60        = "Windows Vista"
Dim Const $ini_section_w60_x64    = "Windows Vista x64"
Dim Const $ini_section_w61        = "Windows 7"
Dim Const $ini_section_w61_x64    = "Windows Server 2008 R2"
Dim Const $ini_section_oxp        = "Office XP"
Dim Const $ini_section_o2k3       = "Office 2003"
Dim Const $ini_section_o2k7       = "Office 2007"
Dim Const $ini_section_ofc        = "Office"
Dim Const $ini_section_iso        = "ISO Images"
Dim Const $ini_section_usb        = "USB Images"
Dim Const $ini_section_opts       = "Options"
Dim Const $ini_section_misc       = "Miscellaneous"
Dim Const $enabled                = "Enabled"
Dim Const $disabled               = "Disabled"
Dim Const $lang_token_glb         = "glb"
Dim Const $lang_token_enu         = "enu"
Dim Const $lang_token_fra         = "fra"
Dim Const $lang_token_esn         = "esn"
Dim Const $lang_token_jpn         = "jpn"
Dim Const $lang_token_kor         = "kor"
Dim Const $lang_token_rus         = "rus"
Dim Const $lang_token_ptg         = "ptg"
Dim Const $lang_token_ptb         = "ptb"
Dim Const $lang_token_deu         = "deu"
Dim Const $lang_token_nld         = "nld"
Dim Const $lang_token_ita         = "ita"
Dim Const $lang_token_chs         = "chs"
Dim Const $lang_token_cht         = "cht"
Dim Const $lang_token_plk         = "plk"
Dim Const $lang_token_hun         = "hun"
Dim Const $lang_token_csy         = "csy"
Dim Const $lang_token_sve         = "sve"
Dim Const $lang_token_trk         = "trk"
Dim Const $lang_token_ell         = "ell"
Dim Const $lang_token_ara         = "ara"
Dim Const $lang_token_heb         = "heb"
Dim Const $lang_token_dan         = "dan"
Dim Const $lang_token_nor         = "nor"
Dim Const $lang_token_fin         = "fin"
Dim Const $iso_token_cd           = "single"
Dim Const $iso_token_dvd          = "cross-platform"
Dim Const $usb_token_copy         = "copy"
Dim Const $usb_token_path         = "path"
Dim Const $opts_token_includesp   = "includesp"
Dim Const $opts_token_dotnet      = "includedotnet"
Dim Const $opts_token_msse        = "includemsse"
Dim Const $opts_token_wddefs      = "includewddefs"
Dim Const $opts_token_cleanup     = "cleanupdownloads"
Dim Const $opts_token_verify      = "verifydownloads"
Dim Const $misc_token_proxy       = "proxy"
Dim Const $misc_token_wsus        = "wsus"
Dim Const $misc_token_wsus_proxy  = "wsusbyproxy"
Dim Const $misc_token_wsus_trans  = "transferwsus"
Dim Const $misc_token_chkver      = "checkouversion"
Dim Const $misc_token_minimize    = "minimizeondownload"
Dim Const $misc_token_showdonate  = "showdonate"
Dim Const $misc_token_clt_wustat  = "WUStatusServer"

; Paths
Dim Const $paths_rel_structure    = "\bin\,\client\bin\,\client\cmd\,\client\exclude\,\client\opt\,\client\static\,\cmd\,\exclude\,\iso\,\log\,\static\,\xslt\"
Dim Const $path_rel_builddate     = "\client\builddate.txt"
Dim Const $path_rel_clientini     = "\client\UpdateInstaller.ini"

Dim $maindlg, $inifilename, $tabitemfocused, $includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $buildlbl
Dim $usbcopy, $usblbl, $usbpath, $usbfsf, $skipdownload, $shutdown, $btn_start, $btn_proxy, $btn_wsus, $btn_donate, $btn_exit, $proxy, $wsus, $dummy
Dim $wxp_enu, $w2k3_enu, $w2k3_x64_enu, $oxp_enu, $o2k3_enu, $o2k7_enu  ; English
Dim $wxp_fra, $w2k3_fra, $w2k3_x64_fra, $oxp_fra, $o2k3_fra, $o2k7_fra  ; French
Dim $wxp_esn, $w2k3_esn, $w2k3_x64_esn, $oxp_esn, $o2k3_esn, $o2k7_esn  ; Spanish
Dim $wxp_jpn, $w2k3_jpn, $w2k3_x64_jpn, $oxp_jpn, $o2k3_jpn, $o2k7_jpn  ; Japanese
Dim $wxp_kor, $w2k3_kor, $w2k3_x64_kor, $oxp_kor, $o2k3_kor, $o2k7_kor  ; Korean
Dim $wxp_rus, $w2k3_rus, $w2k3_x64_rus, $oxp_rus, $o2k3_rus, $o2k7_rus  ; Russian
Dim $wxp_ptg, $w2k3_ptg, $oxp_ptg, $o2k3_ptg, $o2k7_ptg ; Portuguese
Dim $wxp_ptb, $w2k3_ptb, $w2k3_x64_ptb, $oxp_ptb, $o2k3_ptb, $o2k7_ptb  ; Brazilian
Dim $wxp_deu, $w2k3_deu, $w2k3_x64_deu, $oxp_deu, $o2k3_deu, $o2k7_deu  ; German
Dim $wxp_nld, $w2k3_nld, $oxp_nld, $o2k3_nld, $o2k7_nld ; Dutch
Dim $wxp_ita, $w2k3_ita, $oxp_ita, $o2k3_ita, $o2k7_ita ; Italian
Dim $wxp_chs, $w2k3_chs, $oxp_chs, $o2k3_chs, $o2k7_chs ; Chinese simplified
Dim $wxp_cht, $w2k3_cht, $oxp_cht, $o2k3_cht, $o2k7_cht ; Chinese traditional
Dim $wxp_plk, $w2k3_plk, $oxp_plk, $o2k3_plk, $o2k7_plk ; Polish
Dim $wxp_hun, $w2k3_hun, $oxp_hun, $o2k3_hun, $o2k7_hun ; Hungarian
Dim $wxp_csy, $w2k3_csy, $oxp_csy, $o2k3_csy, $o2k7_csy ; Czech
Dim $wxp_sve, $w2k3_sve, $oxp_sve, $o2k3_sve, $o2k7_sve ; Swedish
Dim $wxp_trk, $w2k3_trk, $oxp_trk, $o2k3_trk, $o2k7_trk ; Turkish
Dim $wxp_ell, $w2k3_ell, $oxp_ell, $o2k3_ell, $o2k7_ell ; Greek
Dim $wxp_ara, $w2k3_ara, $oxp_ara, $o2k3_ara, $o2k7_ara ; Arabic
Dim $wxp_heb, $w2k3_heb, $oxp_heb, $o2k3_heb, $o2k7_heb ; Hebrew
Dim $wxp_dan, $w2k3_dan, $oxp_dan, $o2k3_dan, $o2k7_dan ; Danish
Dim $wxp_nor, $w2k3_nor, $oxp_nor, $o2k3_nor, $o2k7_nor ; Norwegian
Dim $wxp_fin, $w2k3_fin, $oxp_fin, $o2k3_fin, $o2k7_fin ; Finnish
Dim $w60_glb, $w60_x64_glb                              ; Windows Vista / Windows Server 2008 (global)  
Dim $w61_glb, $w61_x64_glb                              ; Windows 7 / Windows Server 2008 R2 (global)  
Dim $ofc_glb                                            ; Office (global)  

Dim $dlgheight, $groupwidth, $groupheight, $txtwidth, $txtheight, $slimheight, $btnwidth, $btnheight, $txtxoffset, $txtyoffset, $txtxpos, $txtypos

Func ShowGUIInGerman()
  If ($CmdLine[0] > 0) Then
    Switch StringLower($CmdLine[1])
      Case "enu"
        Return False
      Case "deu"
        Return True
    EndSwitch
  EndIf
  Return ( (@OSLang = "0007") OR (@OSLang = "0407") OR (@OSLang = "0807") OR (@OSLang = "0C07") OR (@OSLang = "1007") OR (@OSLang = "1407") )
EndFunc

Func DirectoryStructureExists()
Dim $result, $arr_dirs, $i

  $result = True
  $arr_dirs = StringSplit($paths_rel_structure, ",")
  For $i = 1 to $arr_dirs[0]
    $result = $result AND FileExists(@ScriptDir & $arr_dirs[$i])
  Next
  Return $result
EndFunc

Func LastDownloadRun()
Dim $result

  $result = FileReadLine(@ScriptDir & $path_rel_builddate)
  If @error Then
    If ShowGUIInGerman() Then
      $result = "[Kein]"
    Else
      $result = "[None]"
    EndIf
  EndIf
  Return $result
EndFunc

Func ClientIniFileName()
  Return @ScriptDir & $path_rel_clientini
EndFunc

Func LanguageCaption($token, $german)
  Switch $token
    Case $lang_token_enu
      If $german Then
        Return "Englisch"
      Else
        Return "English"
      EndIf
    Case $lang_token_fra
      If $german Then
        Return "Franz�sisch"
      Else
        Return "French"
      EndIf
    Case $lang_token_esn
      If $german Then
        Return "Spanisch"
      Else
        Return "Spanish"
      EndIf
    Case $lang_token_jpn
      If $german Then
        Return "Japanisch"
      Else
        Return "Japanese"
      EndIf
    Case $lang_token_kor
      If $german Then
        Return "Koreanisch"
      Else
        Return "Korean"
      EndIf
    Case $lang_token_rus
      If $german Then
        Return "Russisch"
      Else
        Return "Russian"
      EndIf
    Case $lang_token_ptg
      If $german Then
        Return "Portugiesisch"
      Else
        Return "Portuguese"
      EndIf
    Case $lang_token_ptb
      If $german Then
        Return "Brasilianisch"
      Else
        Return "Brazilian"
      EndIf
    Case $lang_token_deu
      If $german Then
        Return "Deutsch"
      Else
        Return "German"
      EndIf
    Case $lang_token_nld
      If $german Then
        Return "Niederl�ndisch"
      Else
        Return "Dutch"
      EndIf
    Case $lang_token_ita
      If $german Then
        Return "Italienisch"
      Else
        Return "Italian"
      EndIf
    Case $lang_token_chs
      If $german Then
        Return "Chin. (simpl.)"
      Else
        Return "Chinese (s.)"
      EndIf
    Case $lang_token_cht
      If $german Then
        Return "Chin. (trad.)"
      Else
        Return "Chinese (tr.)"
      EndIf
    Case $lang_token_plk
      If $german Then
        Return "Polnisch"
      Else
        Return "Polish"
      EndIf
    Case $lang_token_hun
      If $german Then
        Return "Ungarisch"
      Else
        Return "Hungarian"
      EndIf
    Case $lang_token_csy
      If $german Then
        Return "Tschechisch"
      Else
        Return "Czech"
      EndIf
    Case $lang_token_sve
      If $german Then
        Return "Schwedisch"
      Else
        Return "Swedish"
      EndIf
    Case $lang_token_trk
      If $german Then
        Return "T�rkisch"
      Else
        Return "Turkish"
      EndIf
    Case $lang_token_ell
      If $german Then
        Return "Griechisch"
      Else
        Return "Greek"
      EndIf
    Case $lang_token_ara
      If $german Then
        Return "Arabisch"
      Else
        Return "Arabic"
      EndIf
    Case $lang_token_heb
      If $german Then
        Return "Hebr�isch"
      Else
        Return "Hebrew"
      EndIf
    Case $lang_token_dan
      If $german Then
        Return "D�nisch"
      Else
        Return "Danish"
      EndIf
    Case $lang_token_nor
      If $german Then
        Return "Norwegisch"
      Else
        Return "Norwegian"
      EndIf
    Case $lang_token_fin
      If $german Then
        Return "Finnisch"
      Else
        Return "Finnish"
      EndIf
    Case Else
      Return ""
  EndSwitch
EndFunc

Func IsCheckBoxChecked($chkbox)
  Return BitAND(GUICtrlRead($chkbox), $GUI_CHECKED) = $GUI_CHECKED
EndFunc

Func CheckBoxStateToString($chkbox)
  If IsCheckBoxChecked($chkbox) Then
    Return $enabled
  Else
    Return $disabled
  EndIf
EndFunc

Func IsOlderOfficeChecked()
  Return (IsCheckBoxChecked($oxp_enu) OR IsCheckBoxChecked($o2k3_enu) OR IsCheckBoxChecked($o2k7_enu) _
       OR IsCheckBoxChecked($oxp_fra) OR IsCheckBoxChecked($o2k3_fra) OR IsCheckBoxChecked($o2k7_fra) _
       OR IsCheckBoxChecked($oxp_esn) OR IsCheckBoxChecked($o2k3_esn) OR IsCheckBoxChecked($o2k7_esn) _
       OR IsCheckBoxChecked($oxp_jpn) OR IsCheckBoxChecked($o2k3_jpn) OR IsCheckBoxChecked($o2k7_jpn) _
       OR IsCheckBoxChecked($oxp_kor) OR IsCheckBoxChecked($o2k3_kor) OR IsCheckBoxChecked($o2k7_kor) _
       OR IsCheckBoxChecked($oxp_rus) OR IsCheckBoxChecked($o2k3_rus) OR IsCheckBoxChecked($o2k7_rus) _
       OR IsCheckBoxChecked($oxp_ptg) OR IsCheckBoxChecked($o2k3_ptg) OR IsCheckBoxChecked($o2k7_ptg) _
       OR IsCheckBoxChecked($oxp_ptb) OR IsCheckBoxChecked($o2k3_ptb) OR IsCheckBoxChecked($o2k7_ptb) _
       OR IsCheckBoxChecked($oxp_deu) OR IsCheckBoxChecked($o2k3_deu) OR IsCheckBoxChecked($o2k7_deu) _
       OR IsCheckBoxChecked($oxp_nld) OR IsCheckBoxChecked($o2k3_nld) OR IsCheckBoxChecked($o2k7_nld) _
       OR IsCheckBoxChecked($oxp_ita) OR IsCheckBoxChecked($o2k3_ita) OR IsCheckBoxChecked($o2k7_ita) _
       OR IsCheckBoxChecked($oxp_chs) OR IsCheckBoxChecked($o2k3_chs) OR IsCheckBoxChecked($o2k7_chs) _
       OR IsCheckBoxChecked($oxp_cht) OR IsCheckBoxChecked($o2k3_cht) OR IsCheckBoxChecked($o2k7_cht) _
       OR IsCheckBoxChecked($oxp_plk) OR IsCheckBoxChecked($o2k3_plk) OR IsCheckBoxChecked($o2k7_plk) _
       OR IsCheckBoxChecked($oxp_hun) OR IsCheckBoxChecked($o2k3_hun) OR IsCheckBoxChecked($o2k7_hun) _
       OR IsCheckBoxChecked($oxp_csy) OR IsCheckBoxChecked($o2k3_csy) OR IsCheckBoxChecked($o2k7_csy) _
       OR IsCheckBoxChecked($oxp_sve) OR IsCheckBoxChecked($o2k3_sve) OR IsCheckBoxChecked($o2k7_sve) _
       OR IsCheckBoxChecked($oxp_trk) OR IsCheckBoxChecked($o2k3_trk) OR IsCheckBoxChecked($o2k7_trk) _
       OR IsCheckBoxChecked($oxp_ell) OR IsCheckBoxChecked($o2k3_ell) OR IsCheckBoxChecked($o2k7_ell) _
       OR IsCheckBoxChecked($oxp_ara) OR IsCheckBoxChecked($o2k3_ara) OR IsCheckBoxChecked($o2k7_ara) _
       OR IsCheckBoxChecked($oxp_heb) OR IsCheckBoxChecked($o2k3_heb) OR IsCheckBoxChecked($o2k7_heb) _
       OR IsCheckBoxChecked($oxp_dan) OR IsCheckBoxChecked($o2k3_dan) OR IsCheckBoxChecked($o2k7_dan) _
       OR IsCheckBoxChecked($oxp_nor) OR IsCheckBoxChecked($o2k3_nor) OR IsCheckBoxChecked($o2k7_nor) _
       OR IsCheckBoxChecked($oxp_fin) OR IsCheckBoxChecked($o2k3_fin) OR IsCheckBoxChecked($o2k7_fin) )
EndFunc

Func SwitchDownloadGUI($state)
  GUICtrlSetState($wxp_enu, $state)
  GUICtrlSetState($w2k3_enu, $state)
  GUICtrlSetState($w2k3_x64_enu, $state)
  GUICtrlSetState($wxp_fra, $state)
  GUICtrlSetState($w2k3_fra, $state)
  GUICtrlSetState($w2k3_x64_fra, $state)
  GUICtrlSetState($wxp_esn, $state)
  GUICtrlSetState($w2k3_esn, $state)
  GUICtrlSetState($w2k3_x64_esn, $state)
  GUICtrlSetState($wxp_jpn, $state)
  GUICtrlSetState($w2k3_jpn, $state)
  GUICtrlSetState($w2k3_x64_jpn, $state)
  GUICtrlSetState($wxp_kor, $state)
  GUICtrlSetState($w2k3_kor, $state)
  GUICtrlSetState($w2k3_x64_kor, $state)
  GUICtrlSetState($wxp_rus, $state)
  GUICtrlSetState($w2k3_rus, $state)
  GUICtrlSetState($w2k3_x64_rus, $state)
  GUICtrlSetState($wxp_ptg, $state)
  GUICtrlSetState($w2k3_ptg, $state)
  GUICtrlSetState($wxp_ptb, $state)
  GUICtrlSetState($w2k3_ptb, $state)
  GUICtrlSetState($w2k3_x64_ptb, $state)
  GUICtrlSetState($wxp_deu, $state)
  GUICtrlSetState($w2k3_deu, $state)
  GUICtrlSetState($w2k3_x64_deu, $state)
  GUICtrlSetState($wxp_nld, $state)
  GUICtrlSetState($w2k3_nld, $state)
  GUICtrlSetState($wxp_ita, $state)
  GUICtrlSetState($w2k3_ita, $state)
  GUICtrlSetState($wxp_chs, $state)
  GUICtrlSetState($w2k3_chs, $state)
  GUICtrlSetState($wxp_cht, $state)
  GUICtrlSetState($w2k3_cht, $state)
  GUICtrlSetState($wxp_plk, $state)
  GUICtrlSetState($w2k3_plk, $state)
  GUICtrlSetState($wxp_hun, $state)
  GUICtrlSetState($w2k3_hun, $state)
  GUICtrlSetState($wxp_csy, $state)
  GUICtrlSetState($w2k3_csy, $state)
  GUICtrlSetState($wxp_sve, $state)
  GUICtrlSetState($w2k3_sve, $state)
  GUICtrlSetState($wxp_trk, $state)
  GUICtrlSetState($w2k3_trk, $state)
  GUICtrlSetState($wxp_ell, $state)
;  GUICtrlSetState($w2k3_ell, $state)
  GUICtrlSetState($wxp_ara, $state)
;  GUICtrlSetState($w2k3_ara, $state)
  GUICtrlSetState($wxp_heb, $state)
;  GUICtrlSetState($w2k3_heb, $state)
  GUICtrlSetState($wxp_dan, $state)
;  GUICtrlSetState($w2k3_dan, $state)
  GUICtrlSetState($wxp_nor, $state)
;  GUICtrlSetState($w2k3_nor, $state)
  GUICtrlSetState($wxp_fin, $state)
;  GUICtrlSetState($w2k3_fin, $state)
  GUICtrlSetState($w60_glb, $state)
  GUICtrlSetState($w60_x64_glb, $state)
  GUICtrlSetState($w61_glb, $state)
  GUICtrlSetState($w61_x64_glb, $state)

  GUICtrlSetState($oxp_enu, $state)
  GUICtrlSetState($o2k3_enu, $state)
  GUICtrlSetState($o2k7_enu, $state)
  GUICtrlSetState($oxp_fra, $state)
  GUICtrlSetState($o2k3_fra, $state)
  GUICtrlSetState($o2k7_fra, $state)
  GUICtrlSetState($oxp_esn, $state)
  GUICtrlSetState($o2k3_esn, $state)
  GUICtrlSetState($o2k7_esn, $state)
  GUICtrlSetState($oxp_jpn, $state)
  GUICtrlSetState($o2k3_jpn, $state)
  GUICtrlSetState($o2k7_jpn, $state)
  GUICtrlSetState($oxp_kor, $state)
  GUICtrlSetState($o2k3_kor, $state)
  GUICtrlSetState($o2k7_kor, $state)
  GUICtrlSetState($oxp_rus, $state)
  GUICtrlSetState($o2k3_rus, $state)
  GUICtrlSetState($o2k7_rus, $state)
  GUICtrlSetState($oxp_ptg, $state)
  GUICtrlSetState($o2k3_ptg, $state)
  GUICtrlSetState($o2k7_ptg, $state)
  GUICtrlSetState($oxp_ptb, $state)
  GUICtrlSetState($o2k3_ptb, $state)
  GUICtrlSetState($o2k7_ptb, $state)
  GUICtrlSetState($oxp_deu, $state)
  GUICtrlSetState($o2k3_deu, $state)
  GUICtrlSetState($o2k7_deu, $state)
  GUICtrlSetState($oxp_nld, $state)
  GUICtrlSetState($o2k3_nld, $state)
  GUICtrlSetState($o2k7_nld, $state)
  GUICtrlSetState($oxp_ita, $state)
  GUICtrlSetState($o2k3_ita, $state)
  GUICtrlSetState($o2k7_ita, $state)
  GUICtrlSetState($oxp_chs, $state)
  GUICtrlSetState($o2k3_chs, $state)
  GUICtrlSetState($o2k7_chs, $state)
  GUICtrlSetState($oxp_cht, $state)
  GUICtrlSetState($o2k3_cht, $state)
  GUICtrlSetState($o2k7_cht, $state)
  GUICtrlSetState($oxp_plk, $state)
  GUICtrlSetState($o2k3_plk, $state)
  GUICtrlSetState($o2k7_plk, $state)
  GUICtrlSetState($oxp_hun, $state)
  GUICtrlSetState($o2k3_hun, $state)
  GUICtrlSetState($o2k7_hun, $state)
  GUICtrlSetState($oxp_csy, $state)
  GUICtrlSetState($o2k3_csy, $state)
  GUICtrlSetState($o2k7_csy, $state)
  GUICtrlSetState($oxp_sve, $state)
  GUICtrlSetState($o2k3_sve, $state)
  GUICtrlSetState($o2k7_sve, $state)
  GUICtrlSetState($oxp_trk, $state)
  GUICtrlSetState($o2k3_trk, $state)
  GUICtrlSetState($o2k7_trk, $state)
  GUICtrlSetState($oxp_ell, $state)
  GUICtrlSetState($o2k3_ell, $state)
  GUICtrlSetState($o2k7_ell, $state)
  GUICtrlSetState($oxp_ara, $state)
  GUICtrlSetState($o2k3_ara, $state)
  GUICtrlSetState($o2k7_ara, $state)
  GUICtrlSetState($oxp_heb, $state)
  GUICtrlSetState($o2k3_heb, $state)
  GUICtrlSetState($o2k7_heb, $state)
  GUICtrlSetState($oxp_dan, $state)
  GUICtrlSetState($o2k3_dan, $state)
  GUICtrlSetState($o2k7_dan, $state)
  GUICtrlSetState($oxp_nor, $state)
  GUICtrlSetState($o2k3_nor, $state)
  GUICtrlSetState($o2k7_nor, $state)
  GUICtrlSetState($oxp_fin, $state)
  GUICtrlSetState($o2k3_fin, $state)
  GUICtrlSetState($o2k7_fin, $state)
  Return 0
EndFunc

Func DisableGUI()

  SwitchDownloadGUI($GUI_DISABLE)
  GUICtrlSetState($ofc_glb, $GUI_DISABLE)

  GUICtrlSetState($cleanupdownloads, $GUI_DISABLE)
  GUICtrlSetState($verifydownloads, $GUI_DISABLE)
  GUICtrlSetState($includesp, $GUI_DISABLE)
  GUICtrlSetState($dotnet, $GUI_DISABLE)
  GUICtrlSetState($msse, $GUI_DISABLE)
  GUICtrlSetState($wddefs, $GUI_DISABLE)

  GUICtrlSetState($cdiso, $GUI_DISABLE)
  GUICtrlSetState($dvdiso, $GUI_DISABLE)
  GUICtrlSetState($usbcopy, $GUI_DISABLE)
  GUICtrlSetState($usblbl, $GUI_DISABLE)
  GUICtrlSetState($usbpath, $GUI_DISABLE)
  GUICtrlSetState($usbfsf, $GUI_DISABLE)

  GUICtrlSetState($btn_start, $GUI_DISABLE)
  GUICtrlSetState($skipdownload, $GUI_DISABLE)
  GUICtrlSetState($shutdown, $GUI_DISABLE)
  GUICtrlSetState($btn_proxy, $GUI_DISABLE)
  GUICtrlSetState($btn_wsus, $GUI_DISABLE)
  GUICtrlSetState($btn_donate, $GUI_DISABLE)
  GUICtrlSetState($btn_exit, $GUI_DISABLE)

  Return 0
EndFunc

Func EnableGUI()

  SwitchDownloadGUI($GUI_ENABLE)
  If NOT IsOlderOfficeChecked() Then
    GUICtrlSetState($ofc_glb, $GUI_ENABLE)
  EndIf
  
  If NOT IsCheckBoxChecked($skipdownload) Then
    GUICtrlSetState($cleanupdownloads, $GUI_ENABLE)
    GUICtrlSetState($verifydownloads, $GUI_ENABLE)
  EndIf
  GUICtrlSetState($includesp, $GUI_ENABLE)
  GUICtrlSetState($dotnet, $GUI_ENABLE)
  GUICtrlSetState($msse, $GUI_ENABLE)
  GUICtrlSetState($wddefs, $GUI_ENABLE)
  GUICtrlSetState($cdiso, $GUI_ENABLE)
  GUICtrlSetState($dvdiso, $GUI_ENABLE)
  GUICtrlSetState($usbcopy, $GUI_ENABLE)
  If IsCheckBoxChecked($usbcopy) Then
    GUICtrlSetState($usblbl, $GUI_ENABLE)
    GUICtrlSetState($usbpath, $GUI_ENABLE)
    GUICtrlSetState($usbfsf, $GUI_ENABLE)
  EndIf
  GUICtrlSetState($btn_start, $GUI_ENABLE)
  GUICtrlSetState($skipdownload, $GUI_ENABLE)
  If NOT IsCheckBoxChecked($skipdownload) Then
    GUICtrlSetState($shutdown, $GUI_ENABLE)
  EndIf
  GUICtrlSetState($btn_proxy, $GUI_ENABLE)
  GUICtrlSetState($btn_wsus, $GUI_ENABLE)
  GUICtrlSetState($btn_donate, $GUI_ENABLE)
  GUICtrlSetState($btn_exit, $GUI_ENABLE)

  Return 0
EndFunc

Func DetermineDownloadSwitches($chkbox_includesp, $chkbox_dotnet, $chkbox_msse, $chkbox_wddefs, $chkbox_cleanupdownloads, $chkbox_verifydownloads, $chkbox_cdiso, $chkbox_dvdiso, $str_proxy, $str_wsus)
Dim $result = ""

  If NOT IsCheckBoxChecked($chkbox_includesp) Then
    $result = $result & " /excludesp"
  EndIf
  If IsCheckBoxChecked($chkbox_dotnet) Then
    $result = $result & " /includedotnet"
  EndIf
  If IsCheckBoxChecked($chkbox_msse) Then
    $result = $result & " /includemsse"
  EndIf
  If IsCheckBoxChecked($chkbox_wddefs) Then
    $result = $result & " /includewddefs"
  EndIf
  If NOT IsCheckBoxChecked($chkbox_cleanupdownloads) Then
    $result = $result & " /nocleanup"
  EndIf
  If IsCheckBoxChecked($chkbox_verifydownloads) Then
    $result = $result & " /verify"
  EndIf
  $result = $result & " /exitonerror"
  If NOT (IsCheckBoxChecked($chkbox_cdiso) OR IsCheckBoxChecked($chkbox_dvdiso)) Then
    $result = $result & " /skipmkisofs"
  EndIf
  If $str_proxy <> "" Then
    $result = $result & " /proxy " & $str_proxy
  EndIf
  If $str_wsus <> "" Then
    $result = $result & " /wsus " & $str_wsus
  EndIf
  If IniRead($inifilename, $ini_section_misc, $misc_token_wsus_proxy, $disabled) = $enabled Then
    $result = $result & " /wsusbyproxy"
  EndIf
  Return $result
EndFunc

Func DetermineISOSwitches($chkbox_includesp, $chkbox_dotnet, $chkbox_msse, $chkbox_wddefs)
Dim $result = ""

  If NOT IsCheckBoxChecked($chkbox_includesp) Then
    $result = $result & " /excludesp"
  EndIf
  If IsCheckBoxChecked($chkbox_dotnet) Then
    $result = $result & " /includedotnet"
  EndIf
  If IsCheckBoxChecked($chkbox_msse) Then
    $result = $result & " /includemsse"
  EndIf
  If IsCheckBoxChecked($chkbox_wddefs) Then
    $result = $result & " /includewddefs"
  EndIf
  Return $result
EndFunc

Func ShowLogFile()
  Run(@ComSpec & " /D /C start " & $downloadLogFile, @ScriptDir & "\log")
EndFunc

Func RunDonationSite()
  Run(@ComSpec & " /D /C start " & $donationURL)
EndFunc

Func RunVersionCheck($str_proxy)
Dim $result

  DisableGUI()
  If $str_proxy = "" Then
    $result = RunWait(@ComSpec & " /D /C CheckOUVersion.cmd /exitonerror", @ScriptDir & "\cmd", @SW_SHOWMINNOACTIVE)
  Else
    $result = RunWait(@ComSpec & " /D /C CheckOUVersion.cmd /exitonerror /proxy " & $str_proxy, @ScriptDir & "\cmd", @SW_SHOWMINNOACTIVE)
  EndIf
  If $result = 0 Then
    $result = @error
  EndIf
  If $result <> 0 Then
    If ShowGUIInGerman() Then
      $result = MsgBox(0x2023, "Versionspr�fung", "Sie setzen " & $caption & " ein. Eine neuere Version ist verf�gbar." _
                       & @LF & "M�chten Sie WSUS Offline Update nun aktualisieren?")
    Else
      $result = MsgBox(0x2023, "Version check", "You are using " & $caption & ". A newer version is available." _
                       & @LF & "Would you like to update WSUS Offline Update now?")
    EndIf
    Switch $result
      Case $msgbox_btn_yes
        $result = -1
      Case $msgbox_btn_no
        $result = 0
      Case Else
        $result = 1
    EndSwitch
  EndIf
  EnableGUI()
  Return $result
EndFunc

Func RunSelfUpdate($str_proxy)
  If $str_proxy = "" Then
    Run(@ComSpec & " /D /C UpdateOU.cmd /restartgenerator", @ScriptDir & "\cmd", @SW_SHOW)
  Else
    Run(@ComSpec & " /D /C UpdateOU.cmd /restartgenerator /proxy " & $str_proxy, @ScriptDir & "\cmd", @SW_SHOW)
  EndIf
  Return 0
EndFunc

Func RunDownloadScript($stroptions, $strswitches)
Dim $result
  
  If ShowGUIInGerman() Then
    WinSetTitle($maindlg, $maindlg, $caption & " - Lade Updates f�r " & $stroptions & "...")
  Else
    WinSetTitle($maindlg, $maindlg, $caption & " - Downloading updates for " & $stroptions & "...")
  EndIf
  DisableGUI()
  If IniRead($inifilename, $ini_section_misc, $misc_token_minimize, $disabled) = $enabled Then
    $result = RunWait(@ComSpec & " /D /C DownloadUpdates.cmd " & $stroptions & $strswitches, @ScriptDir & "\cmd", @SW_SHOWMINNOACTIVE)
  Else
    $result = RunWait(@ComSpec & " /D /C DownloadUpdates.cmd " & $stroptions & $strswitches, @ScriptDir & "\cmd", @SW_SHOW)
  EndIf
  If $result = 0 Then
    $result = @error
  EndIf
  If $result = 0 Then
    If ShowGUIInGerman() Then
      GUICtrlSetData($buildlbl, "Letzter Download: " & LastDownloadRun())
    Else
      GUICtrlSetData($buildlbl, "Last download: " & LastDownloadRun())
    EndIf
  Else
    WinSetState($maindlg, $maindlg, @SW_RESTORE)
    If ShowGUIInGerman() Then
      If MsgBox(0x2014, "Fehler", "Fehler beim Herunterladen / Verifizieren der Updates f�r " & $stroptions & "." _
                & @LF & "M�chten Sie nun die Protokolldatei ansehen?") = $msgbox_btn_yes Then
        ShowLogFile()
      EndIf
    Else
      If MsgBox(0x2014, "Error", "Error downloading / verifying updates for " & $stroptions & "." _
                & @LF & "Would you like to view the log file now?") = $msgbox_btn_yes Then
        ShowLogFile()
      EndIf
    EndIf
  EndIf
  WinSetTitle($maindlg, $maindlg, $title)
  EnableGUI()
  Return $result
EndFunc

Func RunISOCreationScript($stroptions, $strswitches)
Dim $result

  If ShowGUIInGerman() Then
    WinSetTitle($maindlg, $maindlg, $caption & " - Erstelle ISO-Image f�r " & $stroptions & "...")
  Else
    WinSetTitle($maindlg, $maindlg, $caption & " - Creating ISO image for " & $stroptions & "...")
  EndIf
  DisableGUI()
  If IniRead($inifilename, $ini_section_misc, $misc_token_minimize, $disabled) = $enabled Then
    $result = RunWait(@ComSpec & " /D /C CreateISOImage.cmd " & $stroptions & $strswitches, @ScriptDir & "\cmd", @SW_SHOWMINNOACTIVE)
  Else
    $result = RunWait(@ComSpec & " /D /C CreateISOImage.cmd " & $stroptions & $strswitches, @ScriptDir & "\cmd", @SW_SHOW)
  EndIf
  If $result = 0 Then
    $result = @error
  EndIf
  If $result <> 0 Then
    WinSetState($maindlg, $maindlg, @SW_RESTORE)
    If ShowGUIInGerman() Then
      MsgBox(0x2010, "Fehler", "Fehler beim Erstellen des ISO-Images f�r " & $stroptions & ".")
    Else
      MsgBox(0x2010, "Error", "Error creating ISO image for " & $stroptions & ".")
    EndIf
  EndIf
  WinSetTitle($maindlg, $maindlg, $title)
  EnableGUI()
  Return $result
EndFunc

Func RunUSBCreationScript($stroptions, $strswitches, $strpath)
Dim $result

  If ShowGUIInGerman() Then
    WinSetTitle($maindlg, $maindlg, $caption & " - Kopiere Dateien f�r " & $stroptions & "...")
  Else
    WinSetTitle($maindlg, $maindlg, $caption & " - Copying files for " & $stroptions & "...")
  EndIf
  DisableGUI()
  If IniRead($inifilename, $ini_section_misc, $misc_token_minimize, $disabled) = $enabled Then
    $result = RunWait(@ComSpec & " /D /C CopyToTarget.cmd " & $stroptions & " """ & $strpath & """" & $strswitches, @ScriptDir & "\cmd", @SW_SHOWMINNOACTIVE)
  Else
    $result = RunWait(@ComSpec & " /D /C CopyToTarget.cmd " & $stroptions & " """ & $strpath & """" & $strswitches, @ScriptDir & "\cmd", @SW_SHOW)
  EndIf
  If $result = 0 Then
    $result = @error
  EndIf
  If $result <> 0 Then
    WinSetState($maindlg, $maindlg, @SW_RESTORE)
    If ShowGUIInGerman() Then
      MsgBox(0x2010, "Fehler", "Fehler beim Kopieren der Dateien f�r " & $stroptions & ".")
    Else
      MsgBox(0x2010, "Error", "Error copying files for " & $stroptions & ".")
    EndIf
  EndIf
  WinSetTitle($maindlg, $maindlg, $title)
  EnableGUI()
  Return $result
EndFunc

Func RunScripts($stroptions, $skipdl, $strdownloadswitches, $runiso, $strisoswitches, $runusb, $strusbpath)
Dim $result

  If $skipdl Then 
    $result = 0
  Else
    $result = RunDownloadScript($stroptions, $strdownloadswitches)
  EndIf
  If ( ($result = 0) AND $runiso ) Then
    $result = RunISOCreationScript($stroptions, $strisoswitches)
  EndIf
  If ( ($result = 0) AND $runusb ) Then
    $result = RunUSBCreationScript($stroptions, $strisoswitches, $strusbpath)
  EndIf
  Return $result
EndFunc

Func SaveSettings()

;  Windows XP group
  IniWrite($inifilename, $ini_section_wxp, $lang_token_enu, CheckBoxStateToString($wxp_enu))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_fra, CheckBoxStateToString($wxp_fra))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_esn, CheckBoxStateToString($wxp_esn))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_jpn, CheckBoxStateToString($wxp_jpn))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_kor, CheckBoxStateToString($wxp_kor))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_rus, CheckBoxStateToString($wxp_rus))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_ptg, CheckBoxStateToString($wxp_ptg))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_ptb, CheckBoxStateToString($wxp_ptb))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_deu, CheckBoxStateToString($wxp_deu))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_nld, CheckBoxStateToString($wxp_nld))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_ita, CheckBoxStateToString($wxp_ita))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_chs, CheckBoxStateToString($wxp_chs))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_cht, CheckBoxStateToString($wxp_cht))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_plk, CheckBoxStateToString($wxp_plk))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_hun, CheckBoxStateToString($wxp_hun))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_csy, CheckBoxStateToString($wxp_csy))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_sve, CheckBoxStateToString($wxp_sve))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_trk, CheckBoxStateToString($wxp_trk))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_ell, CheckBoxStateToString($wxp_ell))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_ara, CheckBoxStateToString($wxp_ara))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_heb, CheckBoxStateToString($wxp_heb))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_dan, CheckBoxStateToString($wxp_dan))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_nor, CheckBoxStateToString($wxp_nor))
  IniWrite($inifilename, $ini_section_wxp, $lang_token_fin, CheckBoxStateToString($wxp_fin))

;  Windows Server 2003 group
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_enu, CheckBoxStateToString($w2k3_enu))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_fra, CheckBoxStateToString($w2k3_fra))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_esn, CheckBoxStateToString($w2k3_esn))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_jpn, CheckBoxStateToString($w2k3_jpn))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_kor, CheckBoxStateToString($w2k3_kor))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_rus, CheckBoxStateToString($w2k3_rus))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_ptg, CheckBoxStateToString($w2k3_ptg))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_ptb, CheckBoxStateToString($w2k3_ptb))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_deu, CheckBoxStateToString($w2k3_deu))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_nld, CheckBoxStateToString($w2k3_nld))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_ita, CheckBoxStateToString($w2k3_ita))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_chs, CheckBoxStateToString($w2k3_chs))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_cht, CheckBoxStateToString($w2k3_cht))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_plk, CheckBoxStateToString($w2k3_plk))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_hun, CheckBoxStateToString($w2k3_hun))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_csy, CheckBoxStateToString($w2k3_csy))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_sve, CheckBoxStateToString($w2k3_sve))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_trk, CheckBoxStateToString($w2k3_trk))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_ell, CheckBoxStateToString($w2k3_ell))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_ara, CheckBoxStateToString($w2k3_ara))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_heb, CheckBoxStateToString($w2k3_heb))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_dan, CheckBoxStateToString($w2k3_dan))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_nor, CheckBoxStateToString($w2k3_nor))
  IniWrite($inifilename, $ini_section_w2k3, $lang_token_fin, CheckBoxStateToString($w2k3_fin))

;  Windows Server 2003 x64 group
  IniWrite($inifilename, $ini_section_w2k3_x64, $lang_token_enu, CheckBoxStateToString($w2k3_x64_enu))
  IniWrite($inifilename, $ini_section_w2k3_x64, $lang_token_fra, CheckBoxStateToString($w2k3_x64_fra))
  IniWrite($inifilename, $ini_section_w2k3_x64, $lang_token_esn, CheckBoxStateToString($w2k3_x64_esn))
  IniWrite($inifilename, $ini_section_w2k3_x64, $lang_token_jpn, CheckBoxStateToString($w2k3_x64_jpn))
  IniWrite($inifilename, $ini_section_w2k3_x64, $lang_token_kor, CheckBoxStateToString($w2k3_x64_kor))
  IniWrite($inifilename, $ini_section_w2k3_x64, $lang_token_rus, CheckBoxStateToString($w2k3_x64_rus))
  IniWrite($inifilename, $ini_section_w2k3_x64, $lang_token_ptb, CheckBoxStateToString($w2k3_x64_ptb))
  IniWrite($inifilename, $ini_section_w2k3_x64, $lang_token_deu, CheckBoxStateToString($w2k3_x64_deu))

;  Windows Vista / Server 2008 group
  IniWrite($inifilename, $ini_section_w60, $lang_token_glb, CheckBoxStateToString($w60_glb))
  IniWrite($inifilename, $ini_section_w60_x64, $lang_token_glb, CheckBoxStateToString($w60_x64_glb))

;  Windows 7 / Server 2008 R2 group
  IniWrite($inifilename, $ini_section_w61, $lang_token_glb, CheckBoxStateToString($w61_glb))
  IniWrite($inifilename, $ini_section_w61_x64, $lang_token_glb, CheckBoxStateToString($w61_x64_glb))

;  Office XP group
  IniWrite($inifilename, $ini_section_oxp, $lang_token_enu, CheckBoxStateToString($oxp_enu))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_fra, CheckBoxStateToString($oxp_fra))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_esn, CheckBoxStateToString($oxp_esn))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_jpn, CheckBoxStateToString($oxp_jpn))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_kor, CheckBoxStateToString($oxp_kor))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_rus, CheckBoxStateToString($oxp_rus))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_ptg, CheckBoxStateToString($oxp_ptg))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_ptb, CheckBoxStateToString($oxp_ptb))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_deu, CheckBoxStateToString($oxp_deu))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_nld, CheckBoxStateToString($oxp_nld))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_ita, CheckBoxStateToString($oxp_ita))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_chs, CheckBoxStateToString($oxp_chs))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_cht, CheckBoxStateToString($oxp_cht))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_plk, CheckBoxStateToString($oxp_plk))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_hun, CheckBoxStateToString($oxp_hun))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_csy, CheckBoxStateToString($oxp_csy))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_sve, CheckBoxStateToString($oxp_sve))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_trk, CheckBoxStateToString($oxp_trk))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_ell, CheckBoxStateToString($oxp_ell))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_ara, CheckBoxStateToString($oxp_ara))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_heb, CheckBoxStateToString($oxp_heb))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_dan, CheckBoxStateToString($oxp_dan))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_nor, CheckBoxStateToString($oxp_nor))
  IniWrite($inifilename, $ini_section_oxp, $lang_token_fin, CheckBoxStateToString($oxp_fin))

;  Office 2003 group
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_enu, CheckBoxStateToString($o2k3_enu))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_fra, CheckBoxStateToString($o2k3_fra))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_esn, CheckBoxStateToString($o2k3_esn))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_jpn, CheckBoxStateToString($o2k3_jpn))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_kor, CheckBoxStateToString($o2k3_kor))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_rus, CheckBoxStateToString($o2k3_rus))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_ptg, CheckBoxStateToString($o2k3_ptg))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_ptb, CheckBoxStateToString($o2k3_ptb))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_deu, CheckBoxStateToString($o2k3_deu))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_nld, CheckBoxStateToString($o2k3_nld))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_ita, CheckBoxStateToString($o2k3_ita))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_chs, CheckBoxStateToString($o2k3_chs))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_cht, CheckBoxStateToString($o2k3_cht))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_plk, CheckBoxStateToString($o2k3_plk))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_hun, CheckBoxStateToString($o2k3_hun))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_csy, CheckBoxStateToString($o2k3_csy))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_sve, CheckBoxStateToString($o2k3_sve))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_trk, CheckBoxStateToString($o2k3_trk))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_ell, CheckBoxStateToString($o2k3_ell))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_ara, CheckBoxStateToString($o2k3_ara))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_heb, CheckBoxStateToString($o2k3_heb))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_dan, CheckBoxStateToString($o2k3_dan))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_nor, CheckBoxStateToString($o2k3_nor))
  IniWrite($inifilename, $ini_section_o2k3, $lang_token_fin, CheckBoxStateToString($o2k3_fin))

;  Office 2007 group
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_enu, CheckBoxStateToString($o2k7_enu))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_fra, CheckBoxStateToString($o2k7_fra))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_esn, CheckBoxStateToString($o2k7_esn))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_jpn, CheckBoxStateToString($o2k7_jpn))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_kor, CheckBoxStateToString($o2k7_kor))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_rus, CheckBoxStateToString($o2k7_rus))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_ptg, CheckBoxStateToString($o2k7_ptg))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_ptb, CheckBoxStateToString($o2k7_ptb))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_deu, CheckBoxStateToString($o2k7_deu))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_nld, CheckBoxStateToString($o2k7_nld))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_ita, CheckBoxStateToString($o2k7_ita))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_chs, CheckBoxStateToString($o2k7_chs))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_cht, CheckBoxStateToString($o2k7_cht))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_plk, CheckBoxStateToString($o2k7_plk))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_hun, CheckBoxStateToString($o2k7_hun))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_csy, CheckBoxStateToString($o2k7_csy))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_sve, CheckBoxStateToString($o2k7_sve))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_trk, CheckBoxStateToString($o2k7_trk))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_ell, CheckBoxStateToString($o2k7_ell))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_ara, CheckBoxStateToString($o2k7_ara))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_heb, CheckBoxStateToString($o2k7_heb))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_dan, CheckBoxStateToString($o2k7_dan))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_nor, CheckBoxStateToString($o2k7_nor))
  IniWrite($inifilename, $ini_section_o2k7, $lang_token_fin, CheckBoxStateToString($o2k7_fin))

;  Office group
  IniWrite($inifilename, $ini_section_ofc, $lang_token_glb, CheckBoxStateToString($ofc_glb))

;  Image creation
  IniWrite($inifilename, $ini_section_iso, $iso_token_cd, CheckBoxStateToString($cdiso))
  IniWrite($inifilename, $ini_section_iso, $iso_token_dvd, CheckBoxStateToString($dvdiso))
  IniWrite($inifilename, $ini_section_usb, $usb_token_copy, CheckBoxStateToString($usbcopy))
  IniWrite($inifilename, $ini_section_usb, $usb_token_path, GUICtrlRead($usbpath))

;  Miscellaneous
  IniWrite($inifilename, $ini_section_opts, $opts_token_cleanup, CheckBoxStateToString($cleanupdownloads))
  IniWrite($inifilename, $ini_section_opts, $opts_token_verify, CheckBoxStateToString($verifydownloads))
  IniWrite($inifilename, $ini_section_opts, $opts_token_includesp, CheckBoxStateToString($includesp))
  IniWrite($inifilename, $ini_section_opts, $opts_token_dotnet, CheckBoxStateToString($dotnet))
  IniWrite($inifilename, $ini_section_opts, $opts_token_msse, CheckBoxStateToString($msse))
  IniWrite($inifilename, $ini_section_opts, $opts_token_wddefs, CheckBoxStateToString($wddefs))
  IniWrite($inifilename, $ini_section_misc, $misc_token_proxy, $proxy)
  IniWrite($inifilename, $ini_section_misc, $misc_token_wsus, $wsus)
  
  Return 0
EndFunc

Func CalcGUISize()
  Dim $reg_val
  
  $reg_val = RegRead($reg_key_windowmetrics, $reg_val_applieddpi)
  If ($reg_val = "") Then
    $reg_val = RegRead($reg_key_fontdpi, $reg_val_logpixels)
  EndIf
  If ($reg_val = "") Then
    $reg_val = $default_logpixels
  EndIf
  $dlgheight = 560 * $reg_val / $default_logpixels
  If ShowGUIInGerman() Then
    $txtwidth = 90 * $reg_val / $default_logpixels
  Else
    $txtwidth = 80 * $reg_val / $default_logpixels
  EndIf
  $txtheight = 20 * $reg_val / $default_logpixels
  $slimheight = 15 * $reg_val / $default_logpixels 
  $btnwidth = 80 * $reg_val / $default_logpixels
  $btnheight = 30 * $reg_val / $default_logpixels  
  $txtxoffset = 10 * $reg_val / $default_logpixels
  $txtyoffset = 10 * $reg_val / $default_logpixels
  Return 0
EndFunc	

;  Main Dialog
AutoItSetOption("GUICloseOnESC", 0)
AutoItSetOption("TrayAutoPause", 0)
AutoItSetOption("TrayIconHide", 1)
CalcGUISize()
$groupwidth = 8 * $txtwidth + 2 * $txtxoffset
$groupheight = 4 * $txtheight 
$maindlg = GUICreate($title, $groupwidth + 4 * $txtxoffset, $dlgheight)
GUISetFont(8.5, 400, 0, "Sans Serif")
$inifilename = StringLeft(@ScriptFullPath, StringInStr(@ScriptFullPath, ".", 0, -1)) & "ini"

;  Label
$txtxpos = $txtxoffset
$txtypos = $txtyoffset
If ShowGUIInGerman() Then
  GUICtrlCreateLabel("Lade Microsoft-Updates f�r...", $txtxpos, $txtypos, 3 * $groupwidth / 4, $txtheight)
Else
  GUICtrlCreateLabel("Download Microsoft updates for...", $txtxpos, $txtypos, 3 * $groupwidth / 4, $txtheight)
EndIf

;  Medium info group
$txtxpos = $txtxoffset + 3 * $groupwidth / 4
$txtypos = 0
If ShowGUIInGerman() Then
  GUICtrlCreateGroup("Repository-Info", $txtxpos, $txtypos, $groupwidth / 4 + 2 * $txtxoffset, 2 * $txtheight)
Else
  GUICtrlCreateGroup("Repository info", $txtxpos, $txtypos, $groupwidth / 4 + 2 * $txtxoffset, 2 * $txtheight)
EndIf
$txtxpos = $txtxpos + $txtxoffset
$txtypos = $txtypos + 1.5 * $txtyoffset + 2
If ShowGUIInGerman() Then
  $buildlbl = GUICtrlCreateLabel("Letzter Download: " & LastDownloadRun(), $txtxpos, $txtypos, $groupwidth / 4, $txtheight)
Else
  $buildlbl = GUICtrlCreateLabel("Last download: " & LastDownloadRun(), $txtxpos, $txtypos, $groupwidth / 4, $txtheight)
EndIf

;  Tab control
$txtxpos = $txtxoffset
$txtypos = $txtyoffset + $txtheight
GuiCtrlCreateTab($txtxpos, $txtypos, $groupwidth + 2 * $txtxoffset, 5 * $groupheight - 6 * $txtheight + 3.5 * $txtyoffset)

;  Operating Systems' Tab
$tabitemfocused = GuiCtrlCreateTabItem("Windows")

;  Windows XP group
$txtxpos = 2 * $txtxoffset
$txtypos = 3.5 * $txtyoffset + $txtheight
GUICtrlCreateGroup("Windows XP", $txtxpos, $txtypos, $groupwidth, $groupheight)
;  Windows XP English
$txtypos = $txtypos + 1.5 * $txtyoffset
$txtxpos = $txtxpos + $txtxoffset
$wxp_enu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_enu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_enu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP French
$txtxpos = $txtxpos + $txtwidth - 5
$wxp_fra = GUICtrlCreateCheckbox(LanguageCaption($lang_token_fra, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_fra, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Spanish
$txtxpos = $txtxpos + $txtwidth + 10
$wxp_esn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_esn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_esn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Japanese
$txtxpos = $txtxpos + $txtwidth - 5
$wxp_jpn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_jpn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_jpn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Korean
$txtxpos = $txtxpos + $txtwidth
$wxp_kor = GUICtrlCreateCheckbox(LanguageCaption($lang_token_kor, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_kor, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Russian
$txtxpos = $txtxpos + $txtwidth + 5
$wxp_rus = GUICtrlCreateCheckbox(LanguageCaption($lang_token_rus, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_rus, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Portuguese
$txtxpos = $txtxpos + $txtwidth - 10
$wxp_ptg = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ptg, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_ptg, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Brazilian
$txtxpos = $txtxpos + $txtwidth + 5
$wxp_ptb = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ptb, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_ptb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP German
$txtxpos = 3 * $txtxoffset
$txtypos = $txtypos + $txtheight
$wxp_deu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_deu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_deu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Dutch
$txtxpos = $txtxpos + $txtwidth - 5
$wxp_nld = GUICtrlCreateCheckbox(LanguageCaption($lang_token_nld, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_nld, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Italian
$txtxpos = $txtxpos + $txtwidth + 10
$wxp_ita = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ita, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_ita, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Chinese simplified
$txtxpos = $txtxpos + $txtwidth - 5
$wxp_chs = GUICtrlCreateCheckbox(LanguageCaption($lang_token_chs, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_chs, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Chinese traditional
$txtxpos = $txtxpos + $txtwidth
$wxp_cht = GUICtrlCreateCheckbox(LanguageCaption($lang_token_cht, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_cht, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Polish
$txtxpos = $txtxpos + $txtwidth + 5
$wxp_plk = GUICtrlCreateCheckbox(LanguageCaption($lang_token_plk, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_plk, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Hungarian
$txtxpos = $txtxpos + $txtwidth - 10
$wxp_hun = GUICtrlCreateCheckbox(LanguageCaption($lang_token_hun, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_hun, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Czech
$txtxpos = $txtxpos + $txtwidth + 5
$wxp_csy = GUICtrlCreateCheckbox(LanguageCaption($lang_token_csy, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_csy, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Swedish
$txtxpos = 3 * $txtxoffset
$txtypos = $txtypos + $txtheight
$wxp_sve = GUICtrlCreateCheckbox(LanguageCaption($lang_token_sve, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_sve, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Turkish
$txtxpos = $txtxpos + $txtwidth - 5
$wxp_trk = GUICtrlCreateCheckbox(LanguageCaption($lang_token_trk, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_trk, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Greek
$txtxpos = $txtxpos + $txtwidth + 10
$wxp_ell = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ell, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_ell, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Arabic
$txtxpos = $txtxpos + $txtwidth - 5
$wxp_ara = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ara, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_ara, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Hebrew
$txtxpos = $txtxpos + $txtwidth
$wxp_heb = GUICtrlCreateCheckbox(LanguageCaption($lang_token_heb, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_heb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Danish
$txtxpos = $txtxpos + $txtwidth + 5
$wxp_dan = GUICtrlCreateCheckbox(LanguageCaption($lang_token_dan, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_dan, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Norwegian
$txtxpos = $txtxpos + $txtwidth - 10
$wxp_nor = GUICtrlCreateCheckbox(LanguageCaption($lang_token_nor, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_nor, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows XP Finnish
$txtxpos = $txtxpos + $txtwidth + 5
$wxp_fin = GUICtrlCreateCheckbox(LanguageCaption($lang_token_fin, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_wxp, $lang_token_fin, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Windows Server 2003 group
$txtxpos = 2 * $txtxoffset
$txtypos = $txtypos + 2.5 * $txtyoffset
GUICtrlCreateGroup("Windows Server 2003", $txtxpos, $txtypos, $groupwidth, $groupheight)
;  Windows Server 2003 English
$txtypos = $txtypos + 1.5 * $txtyoffset
$txtxpos = $txtxpos + $txtxoffset
$w2k3_enu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_enu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_enu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 French
$txtxpos = $txtxpos + $txtwidth - 5
$w2k3_fra = GUICtrlCreateCheckbox(LanguageCaption($lang_token_fra, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_fra, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Spanish
$txtxpos = $txtxpos + $txtwidth + 10
$w2k3_esn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_esn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_esn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Japanese
$txtxpos = $txtxpos + $txtwidth - 5
$w2k3_jpn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_jpn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_jpn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Korean
$txtxpos = $txtxpos + $txtwidth
$w2k3_kor = GUICtrlCreateCheckbox(LanguageCaption($lang_token_kor, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_kor, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Russian
$txtxpos = $txtxpos + $txtwidth + 5
$w2k3_rus = GUICtrlCreateCheckbox(LanguageCaption($lang_token_rus, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_rus, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Portuguese
$txtxpos = $txtxpos + $txtwidth - 10
$w2k3_ptg = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ptg, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_ptg, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Brazilian
$txtxpos = $txtxpos + $txtwidth + 5
$w2k3_ptb = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ptb, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_ptb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 German
$txtxpos = 3 * $txtxoffset
$txtypos = $txtypos + $txtheight
$w2k3_deu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_deu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_deu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Dutch
$txtxpos = $txtxpos + $txtwidth - 5
$w2k3_nld = GUICtrlCreateCheckbox(LanguageCaption($lang_token_nld, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_nld, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Italian
$txtxpos = $txtxpos + $txtwidth + 10
$w2k3_ita = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ita, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_ita, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Chinese simplified
$txtxpos = $txtxpos + $txtwidth - 5
$w2k3_chs = GUICtrlCreateCheckbox(LanguageCaption($lang_token_chs, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_chs, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Chinese traditional
$txtxpos = $txtxpos + $txtwidth
$w2k3_cht = GUICtrlCreateCheckbox(LanguageCaption($lang_token_cht, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_cht, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Polish
$txtxpos = $txtxpos + $txtwidth + 5
$w2k3_plk = GUICtrlCreateCheckbox(LanguageCaption($lang_token_plk, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_plk, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Hungarian
$txtxpos = $txtxpos + $txtwidth - 10
$w2k3_hun = GUICtrlCreateCheckbox(LanguageCaption($lang_token_hun, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_hun, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Czech
$txtxpos = $txtxpos + $txtwidth + 5
$w2k3_csy = GUICtrlCreateCheckbox(LanguageCaption($lang_token_csy, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_csy, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Swedish
$txtxpos = 3 * $txtxoffset
$txtypos = $txtypos + $txtheight
$w2k3_sve = GUICtrlCreateCheckbox(LanguageCaption($lang_token_sve, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_sve, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Turkish
$txtxpos = $txtxpos + $txtwidth - 5
$w2k3_trk = GUICtrlCreateCheckbox(LanguageCaption($lang_token_trk, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_w2k3, $lang_token_trk, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 Greek
$txtxpos = $txtxpos + $txtwidth + 10
$w2k3_ell = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ell, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
GUICtrlSetState(-1, $GUI_UNCHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
;  Windows Server 2003 Arabic
$txtxpos = $txtxpos + $txtwidth - 5
$w2k3_ara = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ara, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
GUICtrlSetState(-1, $GUI_UNCHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
;  Windows Server 2003 Hebrew
$txtxpos = $txtxpos + $txtwidth
$w2k3_heb = GUICtrlCreateCheckbox(LanguageCaption($lang_token_heb, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
GUICtrlSetState(-1, $GUI_UNCHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
;  Windows Server 2003 Danish
$txtxpos = $txtxpos + $txtwidth + 5
$w2k3_dan = GUICtrlCreateCheckbox(LanguageCaption($lang_token_dan, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
GUICtrlSetState(-1, $GUI_UNCHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
;  Windows Server 2003 Norwegian
$txtxpos = $txtxpos + $txtwidth - 10
$w2k3_nor = GUICtrlCreateCheckbox(LanguageCaption($lang_token_nor, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
GUICtrlSetState(-1, $GUI_UNCHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
;  Windows Server 2003 Finnish
$txtxpos = $txtxpos + $txtwidth + 5
$w2k3_fin = GUICtrlCreateCheckbox(LanguageCaption($lang_token_fin, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
GUICtrlSetState(-1, $GUI_UNCHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)

;  Windows Server 2003 x64 group
$txtxpos = 2 * $txtxoffset
$txtypos = $txtypos + 2.5 * $txtyoffset
If ShowGUIInGerman() Then
  GUICtrlCreateGroup("Windows XP / Server 2003 x64-Editionen", $txtxpos, $txtypos, $groupwidth, $groupheight - 2 * $txtheight)
Else
  GUICtrlCreateGroup("Windows XP / Server 2003 x64 editions", $txtxpos, $txtypos, $groupwidth, $groupheight - 2 * $txtheight)
EndIf
;  Windows Server 2003 x64 English
$txtypos = $txtypos + 1.5 * $txtyoffset
$txtxpos = $txtxpos + $txtxoffset
$w2k3_x64_enu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_enu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3_x64, $lang_token_enu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 x64 French
$txtxpos = $txtxpos + $txtwidth - 5
$w2k3_x64_fra = GUICtrlCreateCheckbox(LanguageCaption($lang_token_fra, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_w2k3_x64, $lang_token_fra, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 x64 Spanish
$txtxpos = $txtxpos + $txtwidth + 10
$w2k3_x64_esn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_esn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3_x64, $lang_token_esn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 x64 Japanese
$txtxpos = $txtxpos + $txtwidth - 5
$w2k3_x64_jpn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_jpn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_w2k3_x64, $lang_token_jpn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 x64 Korean
$txtxpos = $txtxpos + $txtwidth
$w2k3_x64_kor = GUICtrlCreateCheckbox(LanguageCaption($lang_token_kor, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3_x64, $lang_token_kor, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 x64 Russian
$txtxpos = $txtxpos + $txtwidth + 5
$w2k3_x64_rus = GUICtrlCreateCheckbox(LanguageCaption($lang_token_rus, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_w2k3_x64, $lang_token_rus, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 x64 Brazilian
$txtxpos = $txtxpos + $txtwidth - 10
$w2k3_x64_ptb = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ptb, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_w2k3_x64, $lang_token_ptb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Server 2003 x64 German
$txtxpos = $txtxpos + $txtwidth + 5
$w2k3_x64_deu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_deu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_w2k3_x64, $lang_token_deu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Windows Vista / Server 2008 group
$txtxpos = 2 * $txtxoffset
$txtypos = $txtypos + 2.5 * $txtyoffset
GUICtrlCreateGroup("Windows Vista / Server 2008", $txtxpos, $txtypos, $groupwidth, $groupheight - 2 * $txtheight)
;  Windows Vista / Server 2008 global
$txtypos = $txtypos + 1.5 * $txtyoffset
$txtxpos = $txtxpos + $txtxoffset
If ShowGUIInGerman() Then
  $w60_glb = GUICtrlCreateCheckbox("Global (mehrsprachige Updates)", $txtxpos, $txtypos, $groupwidth / 2 - $txtxoffset, $txtheight)
Else
  $w60_glb = GUICtrlCreateCheckbox("Global (multilingual updates)", $txtxpos, $txtypos, $groupwidth / 2 - $txtxoffset, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_w60, $lang_token_glb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows Vista / Server 2008 x64 global
$txtxpos = $txtxpos + $groupwidth / 2 - $txtxoffset
If ShowGUIInGerman() Then
  $w60_x64_glb = GUICtrlCreateCheckbox("x64 Global (mehrsprachige Updates)", $txtxpos, $txtypos, $groupwidth / 2 - $txtxoffset, $txtheight)
Else
  $w60_x64_glb = GUICtrlCreateCheckbox("x64 Global (multilingual updates)", $txtxpos, $txtypos, $groupwidth / 2 - $txtxoffset, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_w60_x64, $lang_token_glb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Windows 7 / Server 2008 R2 group
$txtxpos = 2 * $txtxoffset
$txtypos = $txtypos + 2.5 * $txtyoffset
GUICtrlCreateGroup("Windows 7 / Server 2008 R2", $txtxpos, $txtypos, $groupwidth, $groupheight - 2 * $txtheight)
;  Windows 7 global
$txtypos = $txtypos + 1.5 * $txtyoffset
$txtxpos = $txtxpos + $txtxoffset
If ShowGUIInGerman() Then
  $w61_glb = GUICtrlCreateCheckbox("Global (mehrsprachige Updates)", $txtxpos, $txtypos, $groupwidth / 2 - $txtxoffset, $txtheight)
Else
  $w61_glb = GUICtrlCreateCheckbox("Global (multilingual updates)", $txtxpos, $txtypos, $groupwidth / 2 - $txtxoffset, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_w61, $lang_token_glb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Windows 7 / Server 2008 R2 x64 global
$txtxpos = $txtxpos + $groupwidth / 2 - $txtxoffset
If ShowGUIInGerman() Then
  $w61_x64_glb = GUICtrlCreateCheckbox("x64 Global (mehrsprachige Updates)", $txtxpos, $txtypos, $groupwidth / 2 - $txtxoffset, $txtheight)
Else
  $w61_x64_glb = GUICtrlCreateCheckbox("x64 Global (multilingual updates)", $txtxpos, $txtypos, $groupwidth / 2 - $txtxoffset, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_w61_x64, $lang_token_glb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Office Suites' Tab
GuiCtrlCreateTabItem("Office")

;  Office XP group
$txtxpos = 2 * $txtxoffset
$txtypos = 3.5 * $txtyoffset + $txtheight
GUICtrlCreateGroup("Office XP SP3 + Statics", $txtxpos, $txtypos, $groupwidth, $groupheight)
;  Office XP English
$txtypos = $txtypos + 1.5 * $txtyoffset
$txtxpos = $txtxpos + $txtxoffset
$oxp_enu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_enu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_enu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP French
$txtxpos = $txtxpos + $txtwidth - 5
$oxp_fra = GUICtrlCreateCheckbox(LanguageCaption($lang_token_fra, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_fra, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Spanish
$txtxpos = $txtxpos + $txtwidth + 10
$oxp_esn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_esn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_esn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Japanese
$txtxpos = $txtxpos + $txtwidth - 5
$oxp_jpn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_jpn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_jpn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Korean
$txtxpos = $txtxpos + $txtwidth
$oxp_kor = GUICtrlCreateCheckbox(LanguageCaption($lang_token_kor, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_kor, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Russian
$txtxpos = $txtxpos + $txtwidth + 5
$oxp_rus = GUICtrlCreateCheckbox(LanguageCaption($lang_token_rus, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_rus, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Portuguese
$txtxpos = $txtxpos + $txtwidth - 10
$oxp_ptg = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ptg, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_ptg, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Brazilian
$txtxpos = $txtxpos + $txtwidth + 5
$oxp_ptb = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ptb, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_ptb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP German
$txtxpos = 3 * $txtxoffset
$txtypos = $txtypos + $txtheight
$oxp_deu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_deu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_deu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Dutch
$txtxpos = $txtxpos + $txtwidth - 5
$oxp_nld = GUICtrlCreateCheckbox(LanguageCaption($lang_token_nld, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_nld, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Italian
$txtxpos = $txtxpos + $txtwidth + 10
$oxp_ita = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ita, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_ita, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Chinese simplified
$txtxpos = $txtxpos + $txtwidth - 5
$oxp_chs = GUICtrlCreateCheckbox(LanguageCaption($lang_token_chs, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_chs, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Chinese traditional
$txtxpos = $txtxpos + $txtwidth
$oxp_cht = GUICtrlCreateCheckbox(LanguageCaption($lang_token_cht, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_cht, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Polish
$txtxpos = $txtxpos + $txtwidth + 5
$oxp_plk = GUICtrlCreateCheckbox(LanguageCaption($lang_token_plk, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_plk, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Hungarian
$txtxpos = $txtxpos + $txtwidth - 10
$oxp_hun = GUICtrlCreateCheckbox(LanguageCaption($lang_token_hun, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_hun, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Czech
$txtxpos = $txtxpos + $txtwidth + 5
$oxp_csy = GUICtrlCreateCheckbox(LanguageCaption($lang_token_csy, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_csy, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Swedish
$txtxpos = 3 * $txtxoffset
$txtypos = $txtypos + $txtheight
$oxp_sve = GUICtrlCreateCheckbox(LanguageCaption($lang_token_sve, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_sve, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Turkish
$txtxpos = $txtxpos + $txtwidth - 5
$oxp_trk = GUICtrlCreateCheckbox(LanguageCaption($lang_token_trk, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_trk, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Greek
$txtxpos = $txtxpos + $txtwidth + 10
$oxp_ell = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ell, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_ell, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Arabic
$txtxpos = $txtxpos + $txtwidth - 5
$oxp_ara = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ara, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_ara, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Hebrew
$txtxpos = $txtxpos + $txtwidth
$oxp_heb = GUICtrlCreateCheckbox(LanguageCaption($lang_token_heb, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_heb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Danish
$txtxpos = $txtxpos + $txtwidth + 5
$oxp_dan = GUICtrlCreateCheckbox(LanguageCaption($lang_token_dan, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_dan, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Norwegian
$txtxpos = $txtxpos + $txtwidth - 10
$oxp_nor = GUICtrlCreateCheckbox(LanguageCaption($lang_token_nor, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_nor, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office XP Finnish
$txtxpos = $txtxpos + $txtwidth + 5
$oxp_fin = GUICtrlCreateCheckbox(LanguageCaption($lang_token_fin, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_oxp, $lang_token_fin, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Office 2003 group
$txtxpos = 2 * $txtxoffset
$txtypos = $txtypos + 2.5 * $txtyoffset
GUICtrlCreateGroup("Office 2003 SP3 + Statics", $txtxpos, $txtypos, $groupwidth, $groupheight)
;  Office 2003 English
$txtypos = $txtypos + 1.5 * $txtyoffset
$txtxpos = $txtxpos + $txtxoffset
$o2k3_enu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_enu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_enu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 French
$txtxpos = $txtxpos + $txtwidth - 5
$o2k3_fra = GUICtrlCreateCheckbox(LanguageCaption($lang_token_fra, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_fra, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Spanish
$txtxpos = $txtxpos + $txtwidth + 10
$o2k3_esn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_esn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_esn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Japanese
$txtxpos = $txtxpos + $txtwidth - 5
$o2k3_jpn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_jpn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_jpn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Korean
$txtxpos = $txtxpos + $txtwidth
$o2k3_kor = GUICtrlCreateCheckbox(LanguageCaption($lang_token_kor, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_kor, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Russian
$txtxpos = $txtxpos + $txtwidth + 5
$o2k3_rus = GUICtrlCreateCheckbox(LanguageCaption($lang_token_rus, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_rus, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Portuguese
$txtxpos = $txtxpos + $txtwidth - 10
$o2k3_ptg = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ptg, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_ptg, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Brazilian
$txtxpos = $txtxpos + $txtwidth + 5
$o2k3_ptb = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ptb, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_ptb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 German
$txtxpos = 3 * $txtxoffset
$txtypos = $txtypos + $txtheight
$o2k3_deu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_deu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_deu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Dutch
$txtxpos = $txtxpos + $txtwidth - 5
$o2k3_nld = GUICtrlCreateCheckbox(LanguageCaption($lang_token_nld, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_nld, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Italian
$txtxpos = $txtxpos + $txtwidth + 10
$o2k3_ita = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ita, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_ita, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Chinese simplified
$txtxpos = $txtxpos + $txtwidth - 5
$o2k3_chs = GUICtrlCreateCheckbox(LanguageCaption($lang_token_chs, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_chs, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Chinese traditional
$txtxpos = $txtxpos + $txtwidth
$o2k3_cht = GUICtrlCreateCheckbox(LanguageCaption($lang_token_cht, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_cht, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Polish
$txtxpos = $txtxpos + $txtwidth + 5
$o2k3_plk = GUICtrlCreateCheckbox(LanguageCaption($lang_token_plk, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_plk, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Hungarian
$txtxpos = $txtxpos + $txtwidth - 10
$o2k3_hun = GUICtrlCreateCheckbox(LanguageCaption($lang_token_hun, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_hun, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Czech
$txtxpos = $txtxpos + $txtwidth + 5
$o2k3_csy = GUICtrlCreateCheckbox(LanguageCaption($lang_token_csy, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_csy, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Swedish
$txtxpos = 3 * $txtxoffset
$txtypos = $txtypos + $txtheight
$o2k3_sve = GUICtrlCreateCheckbox(LanguageCaption($lang_token_sve, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_sve, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Turkish
$txtxpos = $txtxpos + $txtwidth - 5
$o2k3_trk = GUICtrlCreateCheckbox(LanguageCaption($lang_token_trk, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_trk, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Greek
$txtxpos = $txtxpos + $txtwidth + 10
$o2k3_ell = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ell, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_ell, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Arabic
$txtxpos = $txtxpos + $txtwidth - 5
$o2k3_ara = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ara, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_ara, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Hebrew
$txtxpos = $txtxpos + $txtwidth
$o2k3_heb = GUICtrlCreateCheckbox(LanguageCaption($lang_token_heb, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_heb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Danish
$txtxpos = $txtxpos + $txtwidth + 5
$o2k3_dan = GUICtrlCreateCheckbox(LanguageCaption($lang_token_dan, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_dan, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Norwegian
$txtxpos = $txtxpos + $txtwidth - 10
$o2k3_nor = GUICtrlCreateCheckbox(LanguageCaption($lang_token_nor, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_nor, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2003 Finnish
$txtxpos = $txtxpos + $txtwidth + 5
$o2k3_fin = GUICtrlCreateCheckbox(LanguageCaption($lang_token_fin, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k3, $lang_token_fin, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Office 2007 group
$txtxpos = 2 * $txtxoffset
$txtypos = $txtypos + 2.5 * $txtyoffset
GUICtrlCreateGroup("Office 2007 SP2 + Statics", $txtxpos, $txtypos, $groupwidth, $groupheight)
;  Office 2007 English
$txtypos = $txtypos + 1.5 * $txtyoffset
$txtxpos = $txtxpos + $txtxoffset
$o2k7_enu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_enu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_enu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 French
$txtxpos = $txtxpos + $txtwidth - 5
$o2k7_fra = GUICtrlCreateCheckbox(LanguageCaption($lang_token_fra, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_fra, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Spanish
$txtxpos = $txtxpos + $txtwidth + 10
$o2k7_esn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_esn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_esn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Japanese
$txtxpos = $txtxpos + $txtwidth - 5
$o2k7_jpn = GUICtrlCreateCheckbox(LanguageCaption($lang_token_jpn, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_jpn, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Korean
$txtxpos = $txtxpos + $txtwidth
$o2k7_kor = GUICtrlCreateCheckbox(LanguageCaption($lang_token_kor, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_kor, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Russian
$txtxpos = $txtxpos + $txtwidth + 5
$o2k7_rus = GUICtrlCreateCheckbox(LanguageCaption($lang_token_rus, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_rus, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Portuguese
$txtxpos = $txtxpos + $txtwidth - 10
$o2k7_ptg = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ptg, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_ptg, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Brazilian
$txtxpos = $txtxpos + $txtwidth + 5
$o2k7_ptb = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ptb, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_ptb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 German
$txtxpos = 3 * $txtxoffset
$txtypos = $txtypos + $txtheight
$o2k7_deu = GUICtrlCreateCheckbox(LanguageCaption($lang_token_deu, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_deu, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Dutch
$txtxpos = $txtxpos + $txtwidth - 5
$o2k7_nld = GUICtrlCreateCheckbox(LanguageCaption($lang_token_nld, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_nld, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Italian
$txtxpos = $txtxpos + $txtwidth + 10
$o2k7_ita = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ita, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_ita, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Chinese simplified
$txtxpos = $txtxpos + $txtwidth - 5
$o2k7_chs = GUICtrlCreateCheckbox(LanguageCaption($lang_token_chs, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_chs, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Chinese traditional
$txtxpos = $txtxpos + $txtwidth
$o2k7_cht = GUICtrlCreateCheckbox(LanguageCaption($lang_token_cht, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_cht, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Polish
$txtxpos = $txtxpos + $txtwidth + 5
$o2k7_plk = GUICtrlCreateCheckbox(LanguageCaption($lang_token_plk, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_plk, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Hungarian
$txtxpos = $txtxpos + $txtwidth - 10
$o2k7_hun = GUICtrlCreateCheckbox(LanguageCaption($lang_token_hun, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_hun, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Czech
$txtxpos = $txtxpos + $txtwidth + 5
$o2k7_csy = GUICtrlCreateCheckbox(LanguageCaption($lang_token_csy, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_csy, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Swedish
$txtxpos = 3 * $txtxoffset
$txtypos = $txtypos + $txtheight
$o2k7_sve = GUICtrlCreateCheckbox(LanguageCaption($lang_token_sve, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_sve, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Turkish
$txtxpos = $txtxpos + $txtwidth - 5
$o2k7_trk = GUICtrlCreateCheckbox(LanguageCaption($lang_token_trk, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_trk, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Greek
$txtxpos = $txtxpos + $txtwidth + 10
$o2k7_ell = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ell, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_ell, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Arabic
$txtxpos = $txtxpos + $txtwidth - 5
$o2k7_ara = GUICtrlCreateCheckbox(LanguageCaption($lang_token_ara, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_ara, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Hebrew
$txtxpos = $txtxpos + $txtwidth
$o2k7_heb = GUICtrlCreateCheckbox(LanguageCaption($lang_token_heb, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_heb, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Danish
$txtxpos = $txtxpos + $txtwidth + 5
$o2k7_dan = GUICtrlCreateCheckbox(LanguageCaption($lang_token_dan, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth - 10, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_dan, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Norwegian
$txtxpos = $txtxpos + $txtwidth - 10
$o2k7_nor = GUICtrlCreateCheckbox(LanguageCaption($lang_token_nor, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth + 5, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_nor, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;  Office 2007 Finnish
$txtxpos = $txtxpos + $txtwidth + 5
$o2k7_fin = GUICtrlCreateCheckbox(LanguageCaption($lang_token_fin, ShowGUIInGerman()), $txtxpos, $txtypos, $txtwidth, $txtheight)
If IniRead($inifilename, $ini_section_o2k7, $lang_token_fin, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Office group
$txtxpos = 2 * $txtxoffset
$txtypos = $txtypos + 2.5 * $txtyoffset
GUICtrlCreateGroup("Office Updates XP - 2010", $txtxpos, $txtypos, $groupwidth, $groupheight - 2 * $txtheight)
;  Office global
$txtypos = $txtypos + 1.5 * $txtyoffset
$txtxpos = $txtxpos + $txtxoffset
If ShowGUIInGerman() Then
  $ofc_glb = GUICtrlCreateCheckbox("Global (mehrsprachige Updates)", $txtxpos, $txtypos, $groupwidth - 2 * $txtxoffset, $txtheight)
Else
  $ofc_glb = GUICtrlCreateCheckbox("Global (multilingual updates)", $txtxpos, $txtypos, $groupwidth - 2 * $txtxoffset, $txtheight)
EndIf
If IsOlderOfficeChecked() Then
  GUICtrlSetState($ofc_glb, $GUI_CHECKED + $GUI_DISABLE)
Else      
  If IniRead($inifilename, $ini_section_ofc, $lang_token_glb, $disabled) = $enabled Then
    GUICtrlSetState(-1, $GUI_CHECKED)
  Else      
    GUICtrlSetState(-1, $GUI_UNCHECKED)
  EndIf
EndIf

;  End Tab item definition
GuiCtrlCreateTabItem("")
GUICtrlSetState($tabitemfocused, $GUI_SHOW)

;  Options group
$txtxpos = $txtxoffset
$txtypos = $txtypos + 4 * $txtyoffset
$txtypos = 5 * $groupheight - 6 * $txtheight + 7 * $txtyoffset
If ShowGUIInGerman() Then
  GUICtrlCreateGroup("Optionen", $txtxpos, $txtypos, $groupwidth + 2 * $txtxoffset,  $groupheight)
Else
  GUICtrlCreateGroup("Options", $txtxpos, $txtypos, $groupwidth + 2 * $txtxoffset,  $groupheight)
EndIf

;  Cleanup download directories
$txtxpos = $txtxpos + $txtxoffset
$txtypos = $txtypos + 1.5 * $txtyoffset
If ShowGUIInGerman() Then
  $cleanupdownloads = GUICtrlCreateCheckbox("Download-Verzeichnisse bereinigen", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
Else
  $cleanupdownloads = GUICtrlCreateCheckbox("Clean up download directories", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_opts, $opts_token_cleanup, $enabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Verify downloads
$txtxpos = $txtxpos + $groupwidth / 2
If ShowGUIInGerman() Then
  $verifydownloads = GUICtrlCreateCheckbox("Heruntergeladene Updates verifizieren", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
Else
  $verifydownloads = GUICtrlCreateCheckbox("Verify downloaded updates", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_opts, $opts_token_verify, $enabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Include Service Packs
$txtxpos = 2 * $txtxoffset
$txtypos = $txtypos + $txtheight
If ShowGUIInGerman() Then
  $includesp = GUICtrlCreateCheckbox("Service-Packs einschlie�en", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
Else
  $includesp = GUICtrlCreateCheckbox("Include Service Packs", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_opts, $opts_token_includesp, $enabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Include .NET Frameworks 3.5 SP1 and 4
$txtxpos = $txtxpos + $groupwidth / 2
If ShowGUIInGerman() Then
  $dotnet = GUICtrlCreateCheckbox(".NET Frameworks 3.5 SP1 und 4 einschlie�en", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
Else
  $dotnet = GUICtrlCreateCheckbox("Include .NET Frameworks 3.5 SP1 and 4", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_opts, $opts_token_dotnet, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Include Microsoft Security Essentials
$txtxpos = 2 * $txtxoffset
$txtypos = $txtypos + $txtheight
If ShowGUIInGerman() Then
  $msse = GUICtrlCreateCheckbox("Microsoft Security Essentials einschlie�en", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
Else
  $msse = GUICtrlCreateCheckbox("Include Microsoft Security Essentials", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_opts, $opts_token_msse, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  Include Windows Defender definitions
$txtxpos = $txtxpos + $groupwidth / 2
If ShowGUIInGerman() Then
  $wddefs = GUICtrlCreateCheckbox("Windows Defender-Definitionen einschlie�en", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
Else
  $wddefs = GUICtrlCreateCheckbox("Include Windows Defender definitions", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_opts, $opts_token_wddefs, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  ISO-Image group
$txtxpos = $txtxoffset
$txtypos = $txtypos + 2.5 * $txtyoffset
If ShowGUIInGerman() Then
  GUICtrlCreateGroup("Erstelle ISO-Image(s)...", $txtxpos, $txtypos, $groupwidth + 2 * $txtxoffset,  $groupheight - 2 * $txtheight)
Else
  GUICtrlCreateGroup("Create ISO image(s)...", $txtxpos, $txtypos, $groupwidth + 2 * $txtxoffset,  $groupheight - 2 * $txtheight)
EndIf

;  CD ISO image
$txtypos = $txtypos + 1.5 * $txtyoffset
$txtxpos = $txtxpos + $txtxoffset
If ShowGUIInGerman() Then
  $cdiso = GUICtrlCreateCheckbox("pro Produkt und Sprache", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
Else
  $cdiso = GUICtrlCreateCheckbox("per selected product and language", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_iso, $iso_token_cd, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  cross-platform DVD ISO image
$txtxpos = $txtxpos + $groupwidth / 2
If ShowGUIInGerman() Then
  $dvdiso = GUICtrlCreateCheckbox("pro Sprache, produkt�bergreifend (nur x86-Desktop)", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
Else
  $dvdiso = GUICtrlCreateCheckbox("per selected language, 'cross-product' (x86 Desktop only)", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_iso, $iso_token_dvd, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  USB-Image group
$txtxpos = $txtxoffset
$txtypos = $txtypos + 2.5 * $txtyoffset
If ShowGUIInGerman() Then
  GUICtrlCreateGroup("USB-Stick", $txtxpos, $txtypos, $groupwidth + 2 * $txtxoffset,  $groupheight - 2 * $txtheight)
Else
  GUICtrlCreateGroup("USB stick", $txtxpos, $txtypos, $groupwidth + 2 * $txtxoffset,  $groupheight - 2 * $txtheight)
EndIf

;  USB image
$txtypos = $txtypos + 1.5 * $txtyoffset
$txtxpos = $txtxpos + $txtxoffset
If ShowGUIInGerman() Then
  $usbcopy = GUICtrlCreateCheckbox("Kopiere Updates f�r gew�hlte Produkte ins...", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
Else
  $usbcopy = GUICtrlCreateCheckbox("Copy updates for selected products into...", $txtxpos, $txtypos, $groupwidth / 2, $txtheight)
EndIf
If IniRead($inifilename, $ini_section_usb, $usb_token_copy, $disabled) = $enabled Then
  GUICtrlSetState(-1, $GUI_CHECKED)
Else
  GUICtrlSetState(-1, $GUI_UNCHECKED)
EndIf

;  USB target
$txtxpos = $txtxpos + $groupwidth / 2
If ShowGUIInGerman() Then
  $usblbl = GUICtrlCreateLabel("Verzeichnis:", $txtxpos, $txtypos, $txtwidth - 20, $txtheight)
Else
  $usblbl = GUICtrlCreateLabel("Directory:", $txtxpos, $txtypos, $txtwidth - 20, $txtheight)
EndIf
$txtxpos = $txtxpos + $txtwidth - 20
$usbpath = GUICtrlCreateInput(IniRead($inifilename, $ini_section_usb, $usb_token_path, ""), $txtxpos, $txtypos - 2, $groupwidth / 2 - ($txtwidth - 20) - $txtheight, $txtheight)
;  USB FSF button - FileSelectFolder
$txtxpos = $txtxpos + $groupwidth / 2 - ($txtwidth - 20) - $txtheight
$usbfsf = GUICtrlCreateButton("...", $txtxpos, $txtypos - 2, $txtheight, $txtheight)
If IsCheckBoxChecked($usbcopy) Then
  GUICtrlSetState($usblbl, $GUI_ENABLE)
  GUICtrlSetState($usbpath, $GUI_ENABLE)
  GUICtrlSetState($usbfsf, $GUI_ENABLE)
Else
  GUICtrlSetState($usblbl, $GUI_DISABLE)
  GUICtrlSetState($usbpath, $GUI_DISABLE)
  GUICtrlSetState($usbfsf, $GUI_DISABLE)
EndIf

;  Start button
$txtxpos = $txtxoffset
$txtypos = $txtypos + 1.5 * $txtyoffset + $txtheight
$btn_start = GUICtrlCreateButton("Start", $txtxpos, $txtypos, $btnwidth, $btnheight)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)

;  Skip download checkbox
$txtxpos = $txtxpos + $btnwidth + $txtxoffset
If ShowGUIInGerman() Then
  $skipdownload = GUICtrlCreateCheckbox("Ohne Download", $txtxpos, $txtypos, 2 * $txtwidth, $slimheight)
Else
  $skipdownload = GUICtrlCreateCheckbox("Skip download", $txtxpos, $txtypos, 2 * $txtwidth, $slimheight)
EndIf

;  Shutdown checkbox
If ShowGUIInGerman() Then
  $shutdown = GUICtrlCreateCheckbox("Herunterfahren nach Abschluss", $txtxpos, $txtypos + $slimheight, 2 * $txtwidth, $slimheight)
Else
  $shutdown = GUICtrlCreateCheckbox("Shut down on completion", $txtxpos, $txtypos + $slimheight, 2 * $txtwidth, $slimheight)
EndIf

;  Proxy button
$txtxpos = 2* $txtxoffset + $groupwidth / 2 - $btnwidth
$btn_proxy = GUICtrlCreateButton("Proxy...", $txtxpos, $txtypos, $btnwidth, $btnheight)
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM)
$proxy = IniRead($inifilename, $ini_section_misc, $misc_token_proxy, "")

;  WSUS button
$txtxpos = 2 * $txtxoffset + $groupwidth / 2
$btn_wsus = GUICtrlCreateButton("WSUS...", $txtxpos, $txtypos, $btnwidth, $btnheight)
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM)
$wsus = IniRead($inifilename, $ini_section_misc, $misc_token_wsus, "")

;  Donate button
$txtxpos = 2.5 * $txtxoffset + 3 * $groupwidth / 4 - $btnwidth / 2
If ShowGUIInGerman() Then
  $btn_donate = GUICtrlCreateButton("Spenden...", $txtxpos, $txtypos, $btnwidth, $btnheight)
Else
  $btn_donate = GUICtrlCreateButton("Donate...", $txtxpos, $txtypos, $btnwidth, $btnheight)
EndIf
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM)
If IniRead($inifilename, $ini_section_misc, $misc_token_showdonate, $enabled) = $disabled Then
  GUICtrlSetState(-1, $GUI_HIDE)
EndIf

;  Exit button
$txtxpos = 3 * $txtxoffset + $groupwidth - $btnwidth
If ShowGUIInGerman() Then
  $btn_exit = GUICtrlCreateButton("Ende", $txtxpos, $txtypos, $btnwidth, $btnheight)
Else
  $btn_exit = GUICtrlCreateButton("Exit", $txtxpos, $txtypos, $btnwidth, $btnheight)
EndIf
GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

; GUI message loop
GUISetState()
If NOT DirectoryStructureExists() Then
  If ShowGUIInGerman() Then
    MsgBox(0x2010, "Fehler", "Die Verzeichnisstruktur ist unvollst�ndig." & @LF & "Bitte behalten Sie diese beim Entpacken des Zip-Archivs bei.")
    Exit(1)
  Else
    MsgBox(0x2010, "Error", "The directory structure is incomplete." & @LF & "Please keep this when you unpack the Zip archive.")
    Exit(1)
  EndIf
EndIf
If ( (StringRight(EnvGet("TEMP"), 1) = "\") OR (StringRight(EnvGet("TEMP"), 1) = ":") ) Then
  If ShowGUIInGerman() Then
    MsgBox(0x2010, "Fehler", "Die Umgebungsvariable TEMP" & @LF & "enth�lt einen abschlie�enden Backslash ('\')" & @LF & "oder einen abschlie�enden Doppelpunkt (':').")
    Exit(1)
  Else
    MsgBox(0x2010, "Error", "The environment variable TEMP" & @LF & "contains a trailing backslash ('\')" & @LF & "or a trailing colon (':').")
    Exit(1)
  EndIf
EndIf
While 1
  Switch GUIGetMsg()
    Case $GUI_EVENT_CLOSE   ; Window closed
      ExitLoop

    Case $btn_exit          ; Exit button pressed
      ExitLoop

    Case $oxp_enu, $o2k3_enu, $o2k7_enu, $oxp_fra, $o2k3_fra, $o2k7_fra, $oxp_esn, $o2k3_esn, $o2k7_esn, $oxp_jpn, $o2k3_jpn, $o2k7_jpn, _
         $oxp_kor, $o2k3_kor, $o2k7_kor, $oxp_rus, $o2k3_rus, $o2k7_rus, $oxp_ptg, $o2k3_ptg, $o2k7_ptg, $oxp_ptb, $o2k3_ptb, $o2k7_ptb, _
         $oxp_deu, $o2k3_deu, $o2k7_deu, $oxp_nld, $o2k3_nld, $o2k7_nld, $oxp_ita, $o2k3_ita, $o2k7_ita, $oxp_chs, $o2k3_chs, $o2k7_chs, _
         $oxp_cht, $o2k3_cht, $o2k7_cht, $oxp_plk, $o2k3_plk, $o2k7_plk, $oxp_hun, $o2k3_hun, $o2k7_hun, $oxp_csy, $o2k3_csy, $o2k7_csy, _
         $oxp_sve, $o2k3_sve, $o2k7_sve, $oxp_trk, $o2k3_trk, $o2k7_trk, $oxp_ell, $o2k3_ell, $o2k7_ell, $oxp_ara, $o2k3_ara, $o2k7_ara, _
         $oxp_heb, $o2k3_heb, $o2k7_heb, $oxp_dan, $o2k3_dan, $o2k7_dan, $oxp_nor, $o2k3_nor, $o2k7_nor, $oxp_fin, $o2k3_fin, $o2k7_fin
      If IsOlderOfficeChecked() Then
        GUICtrlSetState($ofc_glb, $GUI_CHECKED + $GUI_DISABLE)
      Else      
        GUICtrlSetState($ofc_glb, $GUI_ENABLE)
      EndIf

    Case $includesp         ; 'Include Service Packs' check box toggled
      If ( (NOT IsCheckBoxChecked($includesp)) AND IsCheckBoxChecked($cleanupdownloads) ) Then
        If ShowGUIInGerman() Then
          If MsgBox(0x2134, "Warnung", "Durch die Kombination der Optionen 'Service-Packs ausschlie�en' und" _
                               & @LF & "'Download-Verzeichnisse bereinigen' werden bereits heruntergeladene" _
                               & @LF & "Service Packs f�r die selektierten Produkte gel�scht." _
                               & @LF & "M�chten Sie fortsetzen?") = $msgbox_btn_no Then
            GUICtrlSetState($includesp, $GUI_CHECKED)
          EndIf
        Else
          If MsgBox(0x2134, "Warning", "The combination of 'Exclude Service Packs' and" _
                               & @LF & "'Clean up download directories' options will delete" _
                               & @LF & "previously downloaded Service Packs for the selected products." _
                               & @LF & "Do you wish to proceed?") = $msgbox_btn_no Then
            GUICtrlSetState($includesp, $GUI_CHECKED)
          EndIf
        EndIf
      EndIf

    Case $cleanupdownloads  ; 'Cleanup download directories' check box toggled
      If ( (NOT IsCheckBoxChecked($includesp)) AND IsCheckBoxChecked($cleanupdownloads) ) Then
        If ShowGUIInGerman() Then
          If MsgBox(0x2134, "Warnung", "Durch die Kombination der Optionen 'Service-Packs ausschlie�en' und" _
                               & @LF & "'Download-Verzeichnisse bereinigen' werden bereits heruntergeladene" _
                               & @LF & "Service Packs f�r die selektierten Produkte gel�scht." _
                               & @LF & "M�chten Sie fortsetzen?") = $msgbox_btn_no Then
            GUICtrlSetState($cleanupdownloads, $GUI_UNCHECKED)
          EndIf
        Else
          If MsgBox(0x2134, "Warning", "The combination of 'Exclude Service Packs' and" _
                               & @LF & "'Clean up download directories' options will delete" _
                               & @LF & "previously downloaded Service Packs for the selected products." _
                               & @LF & "Do you wish to proceed?") = $msgbox_btn_no Then
            GUICtrlSetState($cleanupdownloads, $GUI_UNCHECKED)
          EndIf
        EndIf
      EndIf

    Case $usbcopy           ; USB copy button pressed
      If IsCheckBoxChecked($usbcopy) Then
        GUICtrlSetState($usblbl, $GUI_ENABLE)
        GUICtrlSetState($usbpath, $GUI_ENABLE)
        GUICtrlSetState($usbfsf, $GUI_ENABLE)
      Else
        GUICtrlSetState($usblbl, $GUI_DISABLE)
        GUICtrlSetState($usbpath, $GUI_DISABLE)
        GUICtrlSetState($usbfsf, $GUI_DISABLE)
      EndIf

    Case $usbfsf            ; FSF button pressed
      If ShowGUIInGerman() Then
        $dummy = FileSelectFolder("W�hlen Sie ein Zielverzeichnis:", "", 1, GUICtrlRead($usbpath)) 
      Else
        $dummy = FileSelectFolder("Choose destination directory:", "", 1, GUICtrlRead($usbpath))
      EndIf
      If FileExists($dummy) Then
        GUICtrlSetData($usbpath, $dummy)
      EndIf

    Case $skipdownload      ; Skip download checkbox toggled
      If IsCheckBoxChecked($skipdownload) Then
        If ShowGUIInGerman() Then
          If MsgBox(0x2134, "Warnung", "Durch diese Option verhindern Sie das Herunterladen aktueller Updates." _
                               & @LF & "Dies kann ein erh�htes Sicherheitsrisiko f�r das Zielsystem bedeuten." _
                               & @LF & "M�chten Sie fortsetzen?") = $msgbox_btn_no Then
            GUICtrlSetState($skipdownload, $GUI_UNCHECKED)
          Else
            GUICtrlSetState($cleanupdownloads, $GUI_DISABLE)
            GUICtrlSetState($verifydownloads, $GUI_DISABLE)
            GUICtrlSetState($shutdown, $GUI_UNCHECKED + $GUI_DISABLE)
          EndIf
        Else
          If MsgBox(0x2134, "Warning", "This option prevents downloading of recent updates." _
                               & @LF & "This may increase security risks for the target system." _
                               & @LF & "Do you wish to proceed?") = $msgbox_btn_no Then
            GUICtrlSetState($skipdownload, $GUI_UNCHECKED)
          Else
            GUICtrlSetState($cleanupdownloads, $GUI_DISABLE)
            GUICtrlSetState($verifydownloads, $GUI_DISABLE)
            GUICtrlSetState($shutdown, $GUI_UNCHECKED + $GUI_DISABLE)
          EndIf
        EndIf
      Else
        GUICtrlSetState($cleanupdownloads, $GUI_ENABLE)
        GUICtrlSetState($verifydownloads, $GUI_ENABLE)
        GUICtrlSetState($shutdown, $GUI_ENABLE)
      EndIf

    Case $btn_proxy         ; Proxy button pressed
      If ShowGUIInGerman() Then
        $dummy = InputBox("HTTP-Proxy-Einstellung", "Bitte geben Sie die HTTP-Proxy-URL ein (Syntax:" & @LF & "http://[Benutzername:Passwort@]<Server>:<Port>):", $proxy, "", 300, 130)
      Else
        $dummy = InputBox("HTTP proxy setting", "Please enter HTTP proxy URL (syntax:" & @LF & "http://[username:password@]<server>:<port>):", $proxy, "", 280, 130)
      EndIf
      If @error = 0 Then
        $proxy = $dummy
      EndIf

    Case $btn_wsus          ; WSUS button pressed
      If ShowGUIInGerman() Then
        $dummy = InputBox("WSUS-Einstellung", "Bitte geben Sie die WSUS-URL ein" & @LF & "(Syntax: http://<Server>):", $wsus, "", 220, 130)
      Else
        $dummy = InputBox("WSUS setting", "Please enter WSUS URL" & @LF & "(syntax: http://<server>):", $wsus, "", 200, 130)
      EndIf
      If @error = 0 Then
        $wsus = $dummy
      EndIf
      
    Case $btn_donate        ; Donate button pressed
      RunDonationSite()

    Case $btn_start         ; Start button pressed
      If ( (IniRead($inifilename, $ini_section_misc, $misc_token_chkver, $enabled) = $enabled) _
       AND (NOT IsCheckBoxChecked($skipdownload)) ) Then
        Switch RunVersionCheck($proxy)
          Case -1 ; Yes
            RunSelfUpdate($proxy)
            ExitLoop
          Case 1  ; Cancel / Close
            ContinueLoop
          Case Else
        EndSwitch
      EndIf
      If ( (IniRead($inifilename, $ini_section_misc, $misc_token_wsus_trans, $disabled) = $enabled) AND ($wsus <> "") ) Then
        IniWrite(ClientIniFileName(), $ini_section_misc, $misc_token_clt_wustat, $wsus)
      Else
        IniDelete(ClientIniFileName(), $ini_section_misc, $misc_token_clt_wustat)
      EndIf
      If IniRead($inifilename, $ini_section_misc, $misc_token_minimize, $disabled) = $enabled Then
        WinSetState($maindlg, $maindlg, @SW_MINIMIZE)
      EndIf

;  Global
      If IsCheckBoxChecked($w60_glb) Then
        If RunScripts("w60 glb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w60_x64_glb) Then
        If RunScripts("w60-x64 glb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w61_glb) Then
        If RunScripts("w61 glb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w61_x64_glb) Then
        If RunScripts("w61-x64 glb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($ofc_glb) Then
        If IsOlderOfficeChecked() Then
          If RunScripts("ofc glb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
            ContinueLoop
          EndIf
        Else
          If RunScripts("ofc glb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
      EndIf

;  English
      If IsCheckBoxChecked($wxp_enu) Then
        If RunScripts("wxp enu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_enu) Then
        If RunScripts("w2k3 enu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_x64_enu) Then
        If RunScripts("w2k3-x64 enu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_enu) Then
        If RunScripts("oxp enu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_enu) Then
        If RunScripts("o2k3 enu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_enu) Then
        If RunScripts("o2k7 enu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  French
      If IsCheckBoxChecked($wxp_fra) Then
        If RunScripts("wxp fra", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_fra) Then
        If RunScripts("w2k3 fra", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_x64_fra) Then
        If RunScripts("w2k3-x64 fra", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_fra) Then
        If RunScripts("oxp fra", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_fra) Then
        If RunScripts("o2k3 fra", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_fra) Then
        If RunScripts("o2k7 fra", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Spanish
      If IsCheckBoxChecked($wxp_esn) Then
        If RunScripts("wxp esn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_esn) Then
        If RunScripts("w2k3 esn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_x64_esn) Then
        If RunScripts("w2k3-x64 esn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_esn) Then
        If RunScripts("oxp esn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_esn) Then
        If RunScripts("o2k3 esn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_esn) Then
        If RunScripts("o2k7 esn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Japanese
      If IsCheckBoxChecked($wxp_jpn) Then
        If RunScripts("wxp jpn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_jpn) Then
        If RunScripts("w2k3 jpn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_x64_jpn) Then
        If RunScripts("w2k3-x64 jpn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_jpn) Then
        If RunScripts("oxp jpn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_jpn) Then
        If RunScripts("o2k3 jpn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_jpn) Then
        If RunScripts("o2k7 jpn", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Korean
      If IsCheckBoxChecked($wxp_kor) Then
        If RunScripts("wxp kor", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_kor) Then
        If RunScripts("w2k3 kor", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_x64_kor) Then
        If RunScripts("w2k3-x64 kor", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_kor) Then
        If RunScripts("oxp kor", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_kor) Then
        If RunScripts("o2k3 kor", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_kor) Then
        If RunScripts("o2k7 kor", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Russian
      If IsCheckBoxChecked($wxp_rus) Then
        If RunScripts("wxp rus", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_rus) Then
        If RunScripts("w2k3 rus", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_x64_rus) Then
        If RunScripts("w2k3-x64 rus", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_rus) Then
        If RunScripts("oxp rus", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_rus) Then
        If RunScripts("o2k3 rus", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_rus) Then
        If RunScripts("o2k7 rus", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Portuguese
      If IsCheckBoxChecked($wxp_ptg) Then
        If RunScripts("wxp ptg", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_ptg) Then
        If RunScripts("w2k3 ptg", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_ptg) Then
        If RunScripts("oxp ptg", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_ptg) Then
        If RunScripts("o2k3 ptg", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_ptg) Then
        If RunScripts("o2k7 ptg", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Brazilian
      If IsCheckBoxChecked($wxp_ptb) Then
        If RunScripts("wxp ptb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_ptb) Then
        If RunScripts("w2k3 ptb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_x64_ptb) Then
        If RunScripts("w2k3-x64 ptb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_ptb) Then
        If RunScripts("oxp ptb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_ptb) Then
        If RunScripts("o2k3 ptb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_ptb) Then
        If RunScripts("o2k7 ptb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  German
      If IsCheckBoxChecked($wxp_deu) Then
        If RunScripts("wxp deu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_deu) Then
        If RunScripts("w2k3 deu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_x64_deu) Then
        If RunScripts("w2k3-x64 deu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_deu) Then
        If RunScripts("oxp deu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_deu) Then
        If RunScripts("o2k3 deu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_deu) Then
        If RunScripts("o2k7 deu", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Dutch
      If IsCheckBoxChecked($wxp_nld) Then
        If RunScripts("wxp nld", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_nld) Then
        If RunScripts("w2k3 nld", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_nld) Then
        If RunScripts("oxp nld", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_nld) Then
        If RunScripts("o2k3 nld", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_nld) Then
        If RunScripts("o2k7 nld", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Italian
      If IsCheckBoxChecked($wxp_ita) Then
        If RunScripts("wxp ita", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_ita) Then
        If RunScripts("w2k3 ita", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_ita) Then
        If RunScripts("oxp ita", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_ita) Then
        If RunScripts("o2k3 ita", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_ita) Then
        If RunScripts("o2k7 ita", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Chinese simplified
      If IsCheckBoxChecked($wxp_chs) Then
        If RunScripts("wxp chs", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_chs) Then
        If RunScripts("w2k3 chs", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_chs) Then
        If RunScripts("oxp chs", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_chs) Then
        If RunScripts("o2k3 chs", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_chs) Then
        If RunScripts("o2k7 chs", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Chinese traditional
      If IsCheckBoxChecked($wxp_cht) Then
        If RunScripts("wxp cht", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_cht) Then
        If RunScripts("w2k3 cht", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_cht) Then
        If RunScripts("oxp cht", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_cht) Then
        If RunScripts("o2k3 cht", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_cht) Then
        If RunScripts("o2k7 cht", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Polish
      If IsCheckBoxChecked($wxp_plk) Then
        If RunScripts("wxp plk", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_plk) Then
        If RunScripts("w2k3 plk", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_plk) Then
        If RunScripts("oxp plk", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_plk) Then
        If RunScripts("o2k3 plk", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_plk) Then
        If RunScripts("o2k7 plk", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Hungarian
      If IsCheckBoxChecked($wxp_hun) Then
        If RunScripts("wxp hun", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_hun) Then
        If RunScripts("w2k3 hun", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_hun) Then
        If RunScripts("oxp hun", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_hun) Then
        If RunScripts("o2k3 hun", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_hun) Then
        If RunScripts("o2k7 hun", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Czech
      If IsCheckBoxChecked($wxp_csy) Then
        If RunScripts("wxp csy", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_csy) Then
        If RunScripts("w2k3 csy", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_csy) Then
        If RunScripts("oxp csy", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_csy) Then
        If RunScripts("o2k3 csy", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_csy) Then
        If RunScripts("o2k7 csy", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Swedish
      If IsCheckBoxChecked($wxp_sve) Then
        If RunScripts("wxp sve", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_sve) Then
        If RunScripts("w2k3 sve", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_sve) Then
        If RunScripts("oxp sve", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_sve) Then
        If RunScripts("o2k3 sve", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_sve) Then
        If RunScripts("o2k7 sve", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Turkish
      If IsCheckBoxChecked($wxp_trk) Then
        If RunScripts("wxp trk", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($w2k3_trk) Then
        If RunScripts("w2k3 trk", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_trk) Then
        If RunScripts("oxp trk", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_trk) Then
        If RunScripts("o2k3 trk", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_trk) Then
        If RunScripts("o2k7 trk", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Greek
      If IsCheckBoxChecked($wxp_ell) Then
        If RunScripts("wxp ell", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_ell) Then
        If RunScripts("oxp ell", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_ell) Then
        If RunScripts("o2k3 ell", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_ell) Then
        If RunScripts("o2k7 ell", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Arabic
      If IsCheckBoxChecked($wxp_ara) Then
        If RunScripts("wxp ara", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_ara) Then
        If RunScripts("oxp ara", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_ara) Then
        If RunScripts("o2k3 ara", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_ara) Then
        If RunScripts("o2k7 ara", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Hebrew
      If IsCheckBoxChecked($wxp_heb) Then
        If RunScripts("wxp heb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_heb) Then
        If RunScripts("oxp heb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_heb) Then
        If RunScripts("o2k3 heb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_heb) Then
        If RunScripts("o2k7 heb", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Danish
      If IsCheckBoxChecked($wxp_dan) Then
        If RunScripts("wxp dan", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_dan) Then
        If RunScripts("oxp dan", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_dan) Then
        If RunScripts("o2k3 dan", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_dan) Then
        If RunScripts("o2k7 dan", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Norwegian
      If IsCheckBoxChecked($wxp_nor) Then
        If RunScripts("wxp nor", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_nor) Then
        If RunScripts("oxp nor", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_nor) Then
        If RunScripts("o2k3 nor", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_nor) Then
        If RunScripts("o2k7 nor", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Finnish
      If IsCheckBoxChecked($wxp_fin) Then
        If RunScripts("wxp fin", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($oxp_fin) Then
        If RunScripts("oxp fin", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k3_fin) Then
        If RunScripts("o2k3 fin", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If IsCheckBoxChecked($o2k7_fin) Then
        If RunScripts("o2k7 fin", IsCheckBoxChecked($skipdownload), DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), False, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), False, GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Create Office DVD ISO images
      If (IsCheckBoxChecked($oxp_enu) OR IsCheckBoxChecked($o2k3_enu) OR IsCheckBoxChecked($o2k7_enu)) Then
        If RunScripts("ofc enu", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_fra) OR IsCheckBoxChecked($o2k3_fra) OR IsCheckBoxChecked($o2k7_fra)) Then
        If RunScripts("ofc fra", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_esn) OR IsCheckBoxChecked($o2k3_esn) OR IsCheckBoxChecked($o2k7_esn)) Then
        If RunScripts("ofc esn", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_jpn) OR IsCheckBoxChecked($o2k3_jpn) OR IsCheckBoxChecked($o2k7_jpn)) Then
        If RunScripts("ofc jpn", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_kor) OR IsCheckBoxChecked($o2k3_kor) OR IsCheckBoxChecked($o2k7_kor)) Then
        If RunScripts("ofc kor", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_rus) OR IsCheckBoxChecked($o2k3_rus) OR IsCheckBoxChecked($o2k7_rus)) Then
        If RunScripts("ofc rus", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_ptg) OR IsCheckBoxChecked($o2k3_ptg) OR IsCheckBoxChecked($o2k7_ptg)) Then
        If RunScripts("ofc ptg", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_ptb) OR IsCheckBoxChecked($o2k3_ptb) OR IsCheckBoxChecked($o2k7_ptb)) Then
        If RunScripts("ofc ptb", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_deu) OR IsCheckBoxChecked($o2k3_deu) OR IsCheckBoxChecked($o2k7_deu)) Then
        If RunScripts("ofc deu", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_nld) OR IsCheckBoxChecked($o2k3_nld) OR IsCheckBoxChecked($o2k7_nld)) Then
        If RunScripts("ofc nld", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_ita) OR IsCheckBoxChecked($o2k3_ita) OR IsCheckBoxChecked($o2k7_ita)) Then
        If RunScripts("ofc ita", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_chs) OR IsCheckBoxChecked($o2k3_chs) OR IsCheckBoxChecked($o2k7_chs)) Then
        If RunScripts("ofc chs", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_cht) OR IsCheckBoxChecked($o2k3_cht) OR IsCheckBoxChecked($o2k7_cht)) Then
        If RunScripts("ofc cht", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_plk) OR IsCheckBoxChecked($o2k3_plk) OR IsCheckBoxChecked($o2k7_plk)) Then
        If RunScripts("ofc plk", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_hun) OR IsCheckBoxChecked($o2k3_hun) OR IsCheckBoxChecked($o2k7_hun)) Then
        If RunScripts("ofc hun", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_csy) OR IsCheckBoxChecked($o2k3_csy) OR IsCheckBoxChecked($o2k7_csy)) Then
        If RunScripts("ofc csy", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_sve) OR IsCheckBoxChecked($o2k3_sve) OR IsCheckBoxChecked($o2k7_sve)) Then
        If RunScripts("ofc sve", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_trk) OR IsCheckBoxChecked($o2k3_trk) OR IsCheckBoxChecked($o2k7_trk)) Then
        If RunScripts("ofc trk", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_ell) OR IsCheckBoxChecked($o2k3_ell) OR IsCheckBoxChecked($o2k7_ell)) Then
        If RunScripts("ofc ell", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_ara) OR IsCheckBoxChecked($o2k3_ara) OR IsCheckBoxChecked($o2k7_ara)) Then
        If RunScripts("ofc ara", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_heb) OR IsCheckBoxChecked($o2k3_heb) OR IsCheckBoxChecked($o2k7_heb)) Then
        If RunScripts("ofc heb", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_dan) OR IsCheckBoxChecked($o2k3_dan) OR IsCheckBoxChecked($o2k7_dan)) Then
        If RunScripts("ofc dan", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_nor) OR IsCheckBoxChecked($o2k3_nor) OR IsCheckBoxChecked($o2k7_nor)) Then
        If RunScripts("ofc nor", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf
      If (IsCheckBoxChecked($oxp_fin) OR IsCheckBoxChecked($o2k3_fin) OR IsCheckBoxChecked($o2k7_fin)) Then
        If RunScripts("ofc fin", True, DetermineDownloadSwitches($includesp, $dotnet, $msse, $wddefs, $cleanupdownloads, $verifydownloads, $cdiso, $dvdiso, $proxy, $wsus), IsCheckBoxChecked($cdiso), DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs), IsCheckBoxChecked($usbcopy), GUICtrlRead($usbpath)) <> 0 Then
          ContinueLoop
        EndIf
      EndIf

;  Create cross-platform DVD ISO images
      If IsCheckBoxChecked($dvdiso) Then
        If (IsCheckBoxChecked($wxp_enu) OR IsCheckBoxChecked($w2k3_enu) OR IsCheckBoxChecked($oxp_enu) OR IsCheckBoxChecked($o2k3_enu) OR IsCheckBoxChecked($o2k7_enu)) Then
          If RunISOCreationScript($lang_token_enu, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_fra) OR IsCheckBoxChecked($w2k3_fra) OR IsCheckBoxChecked($oxp_fra) OR IsCheckBoxChecked($o2k3_fra) OR IsCheckBoxChecked($o2k7_fra)) Then
          If RunISOCreationScript($lang_token_fra, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_esn) OR IsCheckBoxChecked($w2k3_esn) OR IsCheckBoxChecked($oxp_esn) OR IsCheckBoxChecked($o2k3_esn) OR IsCheckBoxChecked($o2k7_esn)) Then
          If RunISOCreationScript($lang_token_esn, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_jpn) OR IsCheckBoxChecked($w2k3_jpn) OR IsCheckBoxChecked($oxp_jpn) OR IsCheckBoxChecked($o2k3_jpn) OR IsCheckBoxChecked($o2k7_jpn)) Then
          If RunISOCreationScript($lang_token_jpn, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_kor) OR IsCheckBoxChecked($w2k3_kor) OR IsCheckBoxChecked($oxp_kor) OR IsCheckBoxChecked($o2k3_kor) OR IsCheckBoxChecked($o2k7_kor)) Then
          If RunISOCreationScript($lang_token_kor, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_rus) OR IsCheckBoxChecked($w2k3_rus) OR IsCheckBoxChecked($oxp_rus) OR IsCheckBoxChecked($o2k3_rus) OR IsCheckBoxChecked($o2k7_rus)) Then
          If RunISOCreationScript($lang_token_rus, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_ptg) OR IsCheckBoxChecked($w2k3_ptg) OR IsCheckBoxChecked($oxp_ptg) OR IsCheckBoxChecked($o2k3_ptg) OR IsCheckBoxChecked($o2k7_ptg)) Then
          If RunISOCreationScript($lang_token_ptg, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_ptb) OR IsCheckBoxChecked($w2k3_ptb) OR IsCheckBoxChecked($oxp_ptb) OR IsCheckBoxChecked($o2k3_ptb) OR IsCheckBoxChecked($o2k7_ptb)) Then
          If RunISOCreationScript($lang_token_ptb, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_deu) OR IsCheckBoxChecked($w2k3_deu) OR IsCheckBoxChecked($oxp_deu) OR IsCheckBoxChecked($o2k3_deu) OR IsCheckBoxChecked($o2k7_deu)) Then
          If RunISOCreationScript($lang_token_deu, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_nld) OR IsCheckBoxChecked($w2k3_nld) OR IsCheckBoxChecked($oxp_nld) OR IsCheckBoxChecked($o2k3_nld) OR IsCheckBoxChecked($o2k7_nld)) Then
          If RunISOCreationScript($lang_token_nld, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_ita) OR IsCheckBoxChecked($w2k3_ita) OR IsCheckBoxChecked($oxp_ita) OR IsCheckBoxChecked($o2k3_ita) OR IsCheckBoxChecked($o2k7_ita)) Then
          If RunISOCreationScript($lang_token_ita, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_chs) OR IsCheckBoxChecked($w2k3_chs) OR IsCheckBoxChecked($oxp_chs) OR IsCheckBoxChecked($o2k3_chs) OR IsCheckBoxChecked($o2k7_chs)) Then
          If RunISOCreationScript($lang_token_chs, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_cht) OR IsCheckBoxChecked($w2k3_cht) OR IsCheckBoxChecked($oxp_cht) OR IsCheckBoxChecked($o2k3_cht) OR IsCheckBoxChecked($o2k7_cht)) Then
          If RunISOCreationScript($lang_token_cht, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_plk) OR IsCheckBoxChecked($w2k3_plk) OR IsCheckBoxChecked($oxp_plk) OR IsCheckBoxChecked($o2k3_plk) OR IsCheckBoxChecked($o2k7_plk)) Then
          If RunISOCreationScript($lang_token_plk, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_hun) OR IsCheckBoxChecked($w2k3_hun) OR IsCheckBoxChecked($oxp_hun) OR IsCheckBoxChecked($o2k3_hun) OR IsCheckBoxChecked($o2k7_hun)) Then
          If RunISOCreationScript($lang_token_hun, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_csy) OR IsCheckBoxChecked($w2k3_csy) OR IsCheckBoxChecked($oxp_csy) OR IsCheckBoxChecked($o2k3_csy) OR IsCheckBoxChecked($o2k7_csy)) Then
          If RunISOCreationScript($lang_token_csy, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_sve) OR IsCheckBoxChecked($w2k3_sve) OR IsCheckBoxChecked($oxp_sve) OR IsCheckBoxChecked($o2k3_sve) OR IsCheckBoxChecked($o2k7_sve)) Then
          If RunISOCreationScript($lang_token_sve, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_trk) OR IsCheckBoxChecked($w2k3_trk) OR IsCheckBoxChecked($oxp_trk) OR IsCheckBoxChecked($o2k3_trk) OR IsCheckBoxChecked($o2k7_trk)) Then
          If RunISOCreationScript($lang_token_trk, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_ell) OR IsCheckBoxChecked($oxp_ell) OR IsCheckBoxChecked($o2k3_ell) OR IsCheckBoxChecked($o2k7_ell)) Then
          If RunISOCreationScript($lang_token_ell, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_ara) OR IsCheckBoxChecked($oxp_ara) OR IsCheckBoxChecked($o2k3_ara) OR IsCheckBoxChecked($o2k7_ara)) Then
          If RunISOCreationScript($lang_token_ara, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_heb) OR IsCheckBoxChecked($oxp_heb) OR IsCheckBoxChecked($o2k3_heb) OR IsCheckBoxChecked($o2k7_heb)) Then
          If RunISOCreationScript($lang_token_heb, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_dan) OR IsCheckBoxChecked($oxp_dan) OR IsCheckBoxChecked($o2k3_dan) OR IsCheckBoxChecked($o2k7_dan)) Then
          If RunISOCreationScript($lang_token_dan, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_nor) OR IsCheckBoxChecked($oxp_nor) OR IsCheckBoxChecked($o2k3_nor) OR IsCheckBoxChecked($o2k7_nor)) Then
          If RunISOCreationScript($lang_token_nor, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
        If (IsCheckBoxChecked($wxp_fin) OR IsCheckBoxChecked($oxp_fin) OR IsCheckBoxChecked($o2k3_fin) OR IsCheckBoxChecked($o2k7_fin)) Then
          If RunISOCreationScript($lang_token_fin, DetermineISOSwitches($includesp, $dotnet, $msse, $wddefs)) <> 0 Then
            ContinueLoop
          EndIf
        EndIf
      EndIf

;  Restore window and show success dialog
      WinSetState($maindlg, $maindlg, @SW_RESTORE)
      If IsCheckBoxChecked($skipdownload) Then 
        If ShowGUIInGerman() Then
          MsgBox(0x2040, "Info", "Image-Erstellung / Kopieren erfolgreich.")
        Else
          MsgBox(0x2040, "Info", "Image creation / copying successful.")
        EndIf
      Else
        If IsCheckBoxChecked($shutdown) Then 
          Run(@SystemDir & "\shutdown.exe /s /f /t 5", @SystemDir, @SW_HIDE)
          ExitLoop
        EndIf
        If ShowGUIInGerman() Then
          If MsgBox(0x2044, "Info", "Herunterladen / Image-Erstellung / Kopieren erfolgreich." _
                    & @LF & "M�chten Sie nun die Protokolldatei auf m�gliche Warnungen pr�fen?") = $msgbox_btn_yes Then
            ShowLogFile()
          EndIf
        Else
          If MsgBox(0x2044, "Info", "Download / image creation / copying successful." _
                    & @LF & "Would you like to check the log file for possible warnings now?") = $msgbox_btn_yes Then
            ShowLogFile()
          EndIf
        EndIf
      EndIf

  EndSwitch
WEnd
SaveSettings()
Exit
