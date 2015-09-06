; NSIS script NSIS-2
; Install

SetCompressor /SOLID lzma
SetCompressorDictSize 8

; --------------------
; HEADER SIZE: 100064
; START HEADER SIZE: 300
; MAX STRING LENGTH: 1024
; STRING CHARS: 45378

OutFile [NSIS].exe
!include WinMessages.nsh

InstallDirRegKey HKCU Software\Nmap ""
LicenseBkColor /windows


; --------------------
; LANG TABLES: 1
; LANG STRINGS: 87

Name Nmap
BrandingText "Nullsoft Install System v2.46"

; LANG: 1033
LangString LSTR_0 1033 "Nullsoft Install System v2.46"
LangString LSTR_1 1033 "$(LSTR_2) Setup"
LangString LSTR_2 1033 Nmap
LangString LSTR_3 1033 "Space available: "
LangString LSTR_4 1033 "Space required: "
LangString LSTR_5 1033 "Can't write: "
LangString LSTR_6 1033 "Copy failed"
LangString LSTR_7 1033 "Copy to "
LangString LSTR_8 1033 "Could not find symbol: "
LangString LSTR_9 1033 "Could not load: "
LangString LSTR_10 1033 "Create folder: "
LangString LSTR_11 1033 "Create shortcut: "
LangString LSTR_12 1033 "Created uninstaller: "
LangString LSTR_13 1033 "Delete file: "
LangString LSTR_14 1033 "Delete on reboot: "
LangString LSTR_15 1033 "Error creating shortcut: "
LangString LSTR_16 1033 "Error creating: "
LangString LSTR_17 1033 "Error decompressing data! Corrupted installer?"
LangString LSTR_20 1033 "Execute: "
LangString LSTR_21 1033 "Extract: "
LangString LSTR_22 1033 "Extract: error writing to file "
LangString LSTR_23 1033 "Installer corrupted: invalid opcode"
LangString LSTR_24 1033 "No OLE for: "
LangString LSTR_25 1033 "Output folder: "
LangString LSTR_26 1033 "Remove folder: "
LangString LSTR_29 1033 "Skipped: "
LangString LSTR_30 1033 "Copy Details To Clipboard"
LangString LSTR_32 1033 B
LangString LSTR_33 1033 K
LangString LSTR_34 1033 M
LangString LSTR_35 1033 G
LangString LSTR_36 1033 "If you accept the terms of the agreement, click I Agree to continue. You must accept the agreement to install $(LSTR_86)."
LangString LSTR_37 1033 "License Agreement"
LangString LSTR_38 1033 "Please review the license terms before installing $(LSTR_86)."
LangString LSTR_39 1033 "Press Page Down to see the rest of the agreement."
LangString LSTR_40 1033 "Choose Components"
LangString LSTR_41 1033 "Choose which features of $(LSTR_86) you want to install."
LangString LSTR_42 1033 Description
LangString LSTR_43 1033 "Position your mouse over a component to see its description."
LangString LSTR_44 1033 "Choose Install Location"
LangString LSTR_45 1033 "Choose the folder in which to install $(LSTR_86)."
LangString LSTR_46 1033 Installing
LangString LSTR_47 1033 "Please wait while $(LSTR_86) is being installed."
LangString LSTR_48 1033 "Installation Complete"
LangString LSTR_49 1033 "Setup was completed successfully."
LangString LSTR_50 1033 "Installation Aborted"
LangString LSTR_51 1033 "Setup was not completed successfully."
LangString LSTR_52 1033 "MS Shell Dlg"
LangString LSTR_53 1033 8
LangString LSTR_54 1033 "Are you sure you want to quit $(LSTR_2) Setup?"
LangString LSTR_55 1033 "Error opening file for writing: $\r$\n$\r$\n$0$\r$\n$\r$\nClick Abort to stop the installation,$\r$\nRetry to try again, or$\r$\nIgnore to skip this file."
LangString LSTR_56 1033 0
LangString LSTR_57 1033 "Installs Nmap executable, NSE scripts and Visual C++ 2013 runtime components"
LangString LSTR_58 1033 "Installs WinPcap 4.1.3 (required for most Nmap scans unless it is already installed)"
LangString LSTR_59 1033 "Registers Nmap path to System path so you can execute it from any directory"
LangString LSTR_60 1033 "Modifies Windows registry values to improve TCP connect scan performance.  Recommended."
LangString LSTR_61 1033 "Installs Zenmap, the official Nmap graphical user interface, and Visual C++ 2008 runtime components.  Recommended."
LangString LSTR_62 1033 "Installs Ncat, Nmap's Netcat replacement."
LangString LSTR_63 1033 "Installs Ndiff, a tool for comparing Nmap XML files."
LangString LSTR_64 1033 "Installs Nping, a packet generation tool."
LangString LSTR_65 1033 "Installs nmap-update, an updater for architecture-independent files."
LangString LSTR_66 1033 Custom
LangString LSTR_67 1033 Cancel
LangString LSTR_68 1033 "< &Back"
LangString LSTR_69 1033 "I &Agree"
LangString LSTR_70 1033 "Click Next to continue."
LangString LSTR_71 1033 "Check the components you want to install and uncheck the components you don't want to install. $_CLICK"
LangString LSTR_72 1033 "Select the type of install:"
LangString LSTR_73 1033 "Or, select the optional components you wish to install:"
LangString LSTR_74 1033 "Select components to install:"
LangString LSTR_75 1033 "&Next >"
LangString LSTR_76 1033 "Setup will install $(LSTR_86) in the following folder. To install in a different folder, click Browse and select another folder. $_CLICK"
LangString LSTR_77 1033 "Destination Folder"
LangString LSTR_78 1033 B&rowse...
LangString LSTR_79 1033 "Select the folder to install $(LSTR_86) in:"
LangString LSTR_80 1033 &Install
LangString LSTR_81 1033 "Click Install to start the installation."
LangString LSTR_82 1033 "Show &details"
LangString LSTR_83 1033 Completed
LangString LSTR_84 1033 " "
LangString LSTR_85 1033 &Close
LangString LSTR_86 1033 Nmap


; --------------------
; VARIABLES: 7

Var _0_
Var _1_
Var _2_
Var _3_
Var _4_
Var _5_
Var _6_


InstType $(LSTR_66)    ;  Custom
InstallDir $PROGRAMFILES\Nmap
; install_directory_auto_append = Nmap
; wininit = $WINDIR\wininit.ini


; --------------------
; PAGES: 7

; Page 0
Page license func_90 func_95 func_99 /ENABLECANCEL
  LicenseText $(LSTR_36) $(LSTR_69)    ;  "If you accept the terms of the agreement, click I Agree to continue. You must accept the agreement to install $(LSTR_86)." "I &Agree" Nmap
  LicenseData [LICENSE].txt

; Page 1
Page components func_100 func_105 func_116 /ENABLECANCEL
  ComponentsText $(LSTR_71) $(LSTR_72) $(LSTR_73)    ;  "Check the components you want to install and uncheck the components you don't want to install. $_CLICK" "Select the type of install:" "Or, select the optional components you wish to install:"

; Page 2
Page directory func_117 func_122 func_123 /ENABLECANCEL
  DirText $(LSTR_76) $(LSTR_77) $(LSTR_78) $(LSTR_79)    ;  "Setup will install $(LSTR_86) in the following folder. To install in a different folder, click Browse and select another folder. $_CLICK" "Destination Folder" B&rowse... "Select the folder to install $(LSTR_86) in:" Nmap Nmap
  DirVar $CMDLINE

; Page 3
Page instfiles func_124 func_129 func_130
  CompletedText $(LSTR_83)    ;  Completed
  DetailsButtonText $(LSTR_82)    ;  "Show &details"

/*
; Page 4
Page COMPLETED
*/

; Page 5
Page custom func_161 func_175 /ENABLECANCEL

; Page 6
Page custom func_185 func_198


; --------------------
; SECTIONS: 9
; COMMANDS: 1575

Function func_0
  Exch $0
    ; Push $0
    ; Exch
    ; Pop $0
  Push $1
  Push $2
  Push $3
  IfFileExists $0\*.* 0 label_50
  ReadEnvStr $1 PATH
  Push $1;
  Push $0;
  Call func_64
  Pop $2
  StrCmp $2 "" 0 label_50
  Push $1;
  Push $0\;
  Call func_64
  Pop $2
  StrCmp $2 "" 0 label_50
  GetFullPathName /SHORT $3 $0
  Push $1;
  Push $3;
  Call func_64
  Pop $2
  StrCmp $2 "" 0 label_50
  Push $1;
  Push $3\;
  Call func_64
  Pop $2
  StrCmp $2 "" 0 label_50
  Call func_55
  Pop $1
  StrCmp $1 1 label_42
  StrCpy $1 $WINDIR 2
  FileOpen $1 $1\autoexec.bat a
  FileSeek $1 -1 END
  FileReadByte $1 $2
  IntCmp $2 26 0 label_38 label_38
  FileSeek $1 -1 END
label_38:
  FileWrite $1 "$\r$\nSET PATH=%PATH%;$3$\r$\n"
  FileClose $1
  SetRebootFlag true
  Goto label_50
label_42:
  ReadRegStr $1 HKCU Environment PATH
  StrCpy $2 $1 1 -1
  StrCmp $2 ";" 0 label_46
  StrCpy $1 $1 -1
label_46:
  StrCmp $1 "" label_48
  StrCpy $0 $1;$0
label_48:
  WriteRegExpandStr HKCU Environment PATH $0
  SendMessage 0xFFFF 0x001A 0 STR:Environment /TIMEOUT=5000
label_50:
  Pop $3
  Pop $2
  Pop $1
  Pop $0
FunctionEnd


Function func_55
  Push $0
  ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  StrCmp $0 "" 0 label_61
  Pop $0
  Push 0
  Return

label_61:
  Pop $0
  Push 1
FunctionEnd


Function func_64
  Exch $R1
    ; Push $R1
    ; Exch
    ; Pop $R1
  Exch
  Exch $R2
    ; Push $R2
    ; Exch
    ; Pop $R2
  Push $R3
  Push $R4
  Push $R5
  StrLen $R3 $R1
  StrCpy $R4 0
label_76:
  StrCpy $R5 $R2 $R3 $R4
  StrCmp $R5 $R1 label_81
  StrCmp $R5 "" label_81
  IntOp $R4 $R4 + 1
  Goto label_76
label_81:
  StrCpy $R1 $R2 "" $R4
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch $R1
    ; Push $R1
    ; Exch
    ; Pop $R1
FunctionEnd


Function func_90    ; Page 0, Pre
  GetDlgItem $_0_ $HWNDPARENT 1037
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_37)    ;  "License Agreement"
  GetDlgItem $_0_ $HWNDPARENT 1038
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_38)    ;  "Please review the license terms before installing $(LSTR_86)." Nmap
FunctionEnd


Function func_95    ; Page 0, Show
  FindWindow $_0_ "#32770" "" $HWNDPARENT
  GetDlgItem $_0_ $_0_ 1040
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_39)    ;  "Press Page Down to see the rest of the agreement."
FunctionEnd


Function func_99    ; Page 0, Leave
FunctionEnd


Function func_100    ; Page 1, Pre
  GetDlgItem $_0_ $HWNDPARENT 1037
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_40)    ;  "Choose Components"
  GetDlgItem $_0_ $HWNDPARENT 1038
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_41)    ;  "Choose which features of $(LSTR_86) you want to install." Nmap
FunctionEnd


Function func_105    ; Page 1, Show
  FindWindow $_0_ "#32770" "" $HWNDPARENT
  GetDlgItem $_0_ $_0_ 1042
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_42)    ;  Description
  FindWindow $_0_ "#32770" "" $HWNDPARENT
  GetDlgItem $_0_ $_0_ 1043
  EnableWindow $_0_ 0
  FindWindow $_0_ "#32770" "" $HWNDPARENT
  GetDlgItem $_0_ $_0_ 1043
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_43)    ;  "Position your mouse over a component to see its description."
  StrCpy $_2_ $(LSTR_43)    ;  "Position your mouse over a component to see its description."
FunctionEnd


Function func_116    ; Page 1, Leave
FunctionEnd


Function func_117    ; Page 2, Pre
  GetDlgItem $_0_ $HWNDPARENT 1037
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_44)    ;  "Choose Install Location"
  GetDlgItem $_0_ $HWNDPARENT 1038
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_45)    ;  "Choose the folder in which to install $(LSTR_86)." Nmap
FunctionEnd


Function func_122    ; Page 2, Show
FunctionEnd


Function func_123    ; Page 2, Leave
FunctionEnd


Function func_124    ; Page 3, Pre
  GetDlgItem $_0_ $HWNDPARENT 1037
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_46)    ;  Installing
  GetDlgItem $_0_ $HWNDPARENT 1038
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_47)    ;  "Please wait while $(LSTR_86) is being installed." Nmap
FunctionEnd


Function func_129    ; Page 3, Show
FunctionEnd


Function func_130    ; Page 3, Leave
  IfAbort label_136
  GetDlgItem $_0_ $HWNDPARENT 1037
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_48)    ;  "Installation Complete"
  GetDlgItem $_0_ $HWNDPARENT 1038
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_49)    ;  "Setup was completed successfully."
  Goto label_140
label_136:
  GetDlgItem $_0_ $HWNDPARENT 1037
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_50)    ;  "Installation Aborted"
  GetDlgItem $_0_ $HWNDPARENT 1038
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_51)    ;  "Setup was not completed successfully."
label_140:
  IfAbort label_141
label_141:
FunctionEnd


Function .onGUIInit
  GetDlgItem $_0_ $HWNDPARENT 1037
  CreateFont $_1_ $(LSTR_52) $(LSTR_53) 700    ;  "MS Shell Dlg" 8
  SendMessage $_0_ ${WM_SETFONT} $_1_ 0
  SetCtlColors $_0_ "" 0xFFFFFF
  GetDlgItem $_0_ $HWNDPARENT 1038
  SetCtlColors $_0_ "" 0xFFFFFF
  GetDlgItem $_0_ $HWNDPARENT 1034
  SetCtlColors $_0_ "" 0xFFFFFF
  GetDlgItem $_0_ $HWNDPARENT 1039
  SetCtlColors $_0_ "" 0xFFFFFF
  GetDlgItem $_0_ $HWNDPARENT 1028
  SetCtlColors $_0_ /BRANDING ""
  GetDlgItem $_0_ $HWNDPARENT 1256
  SetCtlColors $_0_ /BRANDING ""
  SendMessage $_0_ ${WM_SETTEXT} 0 "STR:$(LSTR_0) "    ;  "Nullsoft Install System v2.46"
FunctionEnd


Function .onUserAbort
  MessageBox MB_YESNO|MB_ICONEXCLAMATION $(LSTR_54) IDYES label_160    ;  "Are you sure you want to quit $(LSTR_2) Setup?" Nmap
  Abort
label_160:
FunctionEnd


Function func_161    ; Page 5, Pre
  StrCmp $_3_ "" label_174
  GetDlgItem $_0_ $HWNDPARENT 1037
  SendMessage $_0_ ${WM_SETTEXT} 0 "STR:Create Shortcuts"
  GetDlgItem $_0_ $HWNDPARENT 1038
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:
  Push $0
  InstallOptions::dialog $PLUGINSDIR\shortcuts.ini
    ; Call Initialize_____Plugins
    ; SetOverwrite off
    ; File $PLUGINSDIR\InstallOptions.dll
    ; SetDetailsPrint lastused
    ; Push $PLUGINSDIR\shortcuts.ini
    ; CallInstDLL $PLUGINSDIR\InstallOptions.dll dialog
  Pop $0
  Pop $0
label_174:
FunctionEnd


Function func_175    ; Page 5, Leave
  StrCmp $_3_ "" label_184
  SetOutPath $INSTDIR
  ReadINIStr $0 $PLUGINSDIR\shortcuts.ini "Field 1" State
  StrCmp $0 0 label_180
  CreateShortCut "$DESKTOP\Nmap - Zenmap GUI.lnk" $INSTDIR\zenmap.exe
label_180:
  ReadINIStr $0 $PLUGINSDIR\shortcuts.ini "Field 2" State
  StrCmp $0 0 label_184
  CreateDirectory $SMPROGRAMS\Nmap
  CreateShortCut "$SMPROGRAMS\Nmap\Nmap - Zenmap GUI.lnk" $INSTDIR\zenmap.exe
label_184:
FunctionEnd


Function func_185    ; Page 6, Pre
  GetDlgItem $_0_ $HWNDPARENT 1037
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:Finished
  GetDlgItem $_0_ $HWNDPARENT 1038
  SendMessage $_0_ ${WM_SETTEXT} 0 "STR:Thank you for installing Nmap"
  Push $0
  InstallOptions::dialog $PLUGINSDIR\final.ini
    ; Call Initialize_____Plugins
    ; AllowSkipFiles off
    ; File $PLUGINSDIR\InstallOptions.dll
    ; SetDetailsPrint lastused
    ; Push $PLUGINSDIR\final.ini
    ; CallInstDLL $PLUGINSDIR\InstallOptions.dll dialog
  Pop $0
  Pop $0
FunctionEnd


Function func_198    ; Page 6, Leave
FunctionEnd


Section "Nmap Core Files" ; Section_0
  ; AddSize 20606
  StrCpy $R0 $INSTDIR "" -2
  StrCmp $R0 :\ label_215
  StrCpy $R0 $INSTDIR "" -14
  StrCmp $R0 "\Program Files" label_215
  StrCpy $R0 $INSTDIR "" -8
  StrCmp $R0 \Windows label_215
  StrCpy $R0 $INSTDIR "" -6
  StrCmp $R0 \WinNT label_215
  StrCpy $R0 $INSTDIR "" -9
  StrCmp $R0 \system32 label_215
  StrCpy $R0 $INSTDIR "" -8
  StrCmp $R0 \Desktop label_215
  StrCpy $R0 $INSTDIR "" -22
  StrCmp $R0 "\Documents and Settings" label_215
  StrCpy $R0 $INSTDIR "" -13
  StrCmp $R0 "\My Documents" label_215 label_217
label_215:
  MessageBox MB_YESNO "It may not be safe to uninstall the previous installation of Nmap from the directory '$INSTDIR'.$\r$\nContinue anyway (not recommended)?" IDYES label_217
  Abort "Install aborted by user"
label_217:
  RMDir /r $INSTDIR\nselib
  RMDir /r $INSTDIR\nselib-bin
  RMDir /r $INSTDIR\scripts
  RMDir /r $INSTDIR\zenmap
  RMDir /r $INSTDIR\py2exe
  RMDir /r $INSTDIR\share
  RMDir /r $INSTDIR\licenses
  SetOutPath $INSTDIR
  SetOverwrite on
  AllowSkipFiles on
  File CHANGELOG
  File COPYING
  File nmap-mac-prefixes
  File nmap-os-db
  File nmap-payloads
  File nmap-protocols
  File nmap-rpc
  File nmap-service-probes
  File nmap-services
  File nmap.exe
  File nse_main.lua
  File nmap.xsl
  File nmap_performance.reg
  File README-WIN32
  File 3rd-party-licenses.txt
  StrCpy $_OUTDIR $OUTDIR
  SetOutPath $_OUTDIR\licenses
  File BSD-simplified
  File LGPL-2
  File LGPL-2.1
  File MIT
  File MPL-1.1
  File OpenSSL.txt
  SetOutPath $_OUTDIR
  File libeay32.dll
  File ssleay32.dll
  StrCpy $_OUTDIR $OUTDIR
  SetOutPath $_OUTDIR\ndiff\scripts
  File ndiff
  SetOutPath $_OUTDIR\scripts
  File acarsd-info.nse
  File address-info.nse
  File afp-brute.nse
  File afp-ls.nse
  File afp-path-vuln.nse
  File afp-serverinfo.nse
  File afp-showmount.nse
  File ajp-auth.nse
  File ajp-brute.nse
  File ajp-headers.nse
  File ajp-methods.nse
  File ajp-request.nse
  File allseeingeye-info.nse
  File amqp-info.nse
  File asn-query.nse
  File auth-owners.nse
  File auth-spoof.nse
  File backorifice-brute.nse
  File backorifice-info.nse
  File bacnet-info.nse
  File banner.nse
  File bitcoin-getaddr.nse
  File bitcoin-info.nse
  File bitcoinrpc-info.nse
  File bittorrent-discovery.nse
  File bjnp-discover.nse
  File broadcast-ataoe-discover.nse
  File broadcast-avahi-dos.nse
  File broadcast-bjnp-discover.nse
  File broadcast-db2-discover.nse
  File broadcast-dhcp-discover.nse
  File broadcast-dhcp6-discover.nse
  File broadcast-dns-service-discovery.nse
  File broadcast-dropbox-listener.nse
  File broadcast-eigrp-discovery.nse
  File broadcast-igmp-discovery.nse
  File broadcast-listener.nse
  File broadcast-ms-sql-discover.nse
  File broadcast-netbios-master-browser.nse
  File broadcast-networker-discover.nse
  File broadcast-novell-locate.nse
  File broadcast-pc-anywhere.nse
  File broadcast-pc-duo.nse
  File broadcast-pim-discovery.nse
  File broadcast-ping.nse
  File broadcast-pppoe-discover.nse
  File broadcast-rip-discover.nse
  File broadcast-ripng-discover.nse
  File broadcast-sybase-asa-discover.nse
  File broadcast-tellstick-discover.nse
  File broadcast-upnp-info.nse
  File broadcast-versant-locate.nse
  File broadcast-wake-on-lan.nse
  File broadcast-wpad-discover.nse
  File broadcast-wsdd-discover.nse
  File broadcast-xdmcp-discover.nse
  File cassandra-brute.nse
  File cassandra-info.nse
  File cccam-version.nse
  File citrix-brute-xml.nse
  File citrix-enum-apps-xml.nse
  File citrix-enum-apps.nse
  File citrix-enum-servers-xml.nse
  File citrix-enum-servers.nse
  File couchdb-databases.nse
  File couchdb-stats.nse
  File creds-summary.nse
  File cups-info.nse
  File cups-queue-info.nse
  File cvs-brute-repository.nse
  File cvs-brute.nse
  File daap-get-library.nse
  File daytime.nse
  File db2-das-info.nse
  File dhcp-discover.nse
  File dict-info.nse
  File distcc-cve2004-2687.nse
  File dns-blacklist.nse
  File dns-brute.nse
  File dns-cache-snoop.nse
  File dns-check-zone.nse
  File dns-client-subnet-scan.nse
  File dns-fuzz.nse
  File dns-ip6-arpa-scan.nse
  File dns-nsec-enum.nse
  File dns-nsec3-enum.nse
  File dns-nsid.nse
  File dns-random-srcport.nse
  File dns-random-txid.nse
  File dns-recursion.nse
  File dns-service-discovery.nse
  File dns-srv-enum.nse
  File dns-update.nse
  File dns-zeustracker.nse
  File dns-zone-transfer.nse
  File docker-version.nse
  File domcon-brute.nse
  File domcon-cmd.nse
  File domino-enum-users.nse
  File dpap-brute.nse
  File drda-brute.nse
  File drda-info.nse
  File duplicates.nse
  File eap-info.nse
  File enip-info.nse
  File epmd-info.nse
  File eppc-enum-processes.nse
  File fcrdns.nse
  File finger.nse
  File firewalk.nse
  File firewall-bypass.nse
  File flume-master-info.nse
  File freelancer-info.nse
  File ftp-anon.nse
  File ftp-bounce.nse
  File ftp-brute.nse
  File ftp-libopie.nse
  File ftp-proftpd-backdoor.nse
  File ftp-vsftpd-backdoor.nse
  File ftp-vuln-cve2010-4221.nse
  File ganglia-info.nse
  File giop-info.nse
  File gkrellm-info.nse
  File gopher-ls.nse
  File gpsd-info.nse
  File hadoop-datanode-info.nse
  File hadoop-jobtracker-info.nse
  File hadoop-namenode-info.nse
  File hadoop-secondary-namenode-info.nse
  File hadoop-tasktracker-info.nse
  File hbase-master-info.nse
  File hbase-region-info.nse
  File hddtemp-info.nse
  File hostmap-bfk.nse
  File hostmap-ip2hosts.nse
  File hostmap-robtex.nse
  File http-adobe-coldfusion-apsa1301.nse
  File http-affiliate-id.nse
  File http-apache-negotiation.nse
  File http-auth-finder.nse
  File http-auth.nse
  File http-avaya-ipoffice-users.nse
  File http-awstatstotals-exec.nse
  File http-axis2-dir-traversal.nse
  File http-backup-finder.nse
  File http-barracuda-dir-traversal.nse
  File http-brute.nse
  File http-cakephp-version.nse
  File http-chrono.nse
  File http-cisco-anyconnect.nse
  File http-coldfusion-subzero.nse
  File http-comments-displayer.nse
  File http-config-backup.nse
  File http-cors.nse
  File http-crossdomainxml.nse
  File http-csrf.nse
  File http-date.nse
  File http-default-accounts.nse
  File http-devframework.nse
  File http-dlink-backdoor.nse
  File http-dombased-xss.nse
  File http-domino-enum-passwords.nse
  File http-drupal-enum-users.nse
  File http-drupal-modules.nse
  File http-email-harvest.nse
  File http-enum.nse
  File http-errors.nse
  File http-exif-spider.nse
  File http-favicon.nse
  File http-feed.nse
  File http-fileupload-exploiter.nse
  File http-form-brute.nse
  File http-form-fuzzer.nse
  File http-frontpage-login.nse
  File http-generator.nse
  File http-git.nse
  File http-gitweb-projects-enum.nse
  File http-google-malware.nse
  File http-grep.nse
  File http-headers.nse
  File http-huawei-hg5xx-vuln.nse
  File http-icloud-findmyiphone.nse
  File http-icloud-sendmsg.nse
  File http-iis-short-name-brute.nse
  File http-iis-webdav-vuln.nse
  File http-joomla-brute.nse
  File http-litespeed-sourcecode-download.nse
  File http-majordomo2-dir-traversal.nse
  File http-malware-host.nse
  File http-method-tamper.nse
  File http-methods.nse
  File http-mobileversion-checker.nse
  File http-ntlm-info.nse
  File http-open-proxy.nse
  File http-open-redirect.nse
  File http-passwd.nse
  File http-php-version.nse
  File http-phpmyadmin-dir-traversal.nse
  File http-phpself-xss.nse
  File http-proxy-brute.nse
  File http-put.nse
  File http-qnap-nas-info.nse
  File http-referer-checker.nse
  File http-rfi-spider.nse
  File http-robots.txt.nse
  File http-robtex-reverse-ip.nse
  File http-robtex-shared-ns.nse
  File http-server-header.nse
  File http-shellshock.nse
  File http-sitemap-generator.nse
  File http-slowloris-check.nse
  File http-slowloris.nse
  File http-sql-injection.nse
  File http-stored-xss.nse
  File http-title.nse
  File http-tplink-dir-traversal.nse
  File http-trace.nse
  File http-traceroute.nse
  File http-unsafe-output-escaping.nse
  File http-useragent-tester.nse
  File http-userdir-enum.nse
  File http-vhosts.nse
  File http-virustotal.nse
  File http-vlcstreamer-ls.nse
  File http-vmware-path-vuln.nse
  File http-vuln-cve2006-3392.nse
  File http-vuln-cve2009-3960.nse
  File http-vuln-cve2010-0738.nse
  File http-vuln-cve2010-2861.nse
  File http-vuln-cve2011-3192.nse
  File http-vuln-cve2011-3368.nse
  File http-vuln-cve2012-1823.nse
  File http-vuln-cve2013-0156.nse
  File http-vuln-cve2013-7091.nse
  File http-vuln-cve2014-2126.nse
  File http-vuln-cve2014-2127.nse
  File http-vuln-cve2014-2128.nse
  File http-vuln-cve2014-2129.nse
  File http-vuln-cve2015-1427.nse
  File http-vuln-cve2015-1635.nse
  File http-vuln-misfortune-cookie.nse
  File http-vuln-wnr1000-creds.nse
  File http-waf-detect.nse
  File http-waf-fingerprint.nse
  File http-wordpress-brute.nse
  File http-wordpress-enum.nse
  File http-wordpress-users.nse
  File http-xssed.nse
  File iax2-brute.nse
  File iax2-version.nse
  File icap-info.nse
  File ike-version.nse
  File imap-brute.nse
  File imap-capabilities.nse
  File informix-brute.nse
  File informix-query.nse
  File informix-tables.nse
  File ip-forwarding.nse
  File ip-geolocation-geobytes.nse
  File ip-geolocation-geoplugin.nse
  File ip-geolocation-ipinfodb.nse
  File ip-geolocation-maxmind.nse
  File ipidseq.nse
  File ipv6-node-info.nse
  File ipv6-ra-flood.nse
  File irc-botnet-channels.nse
  File irc-brute.nse
  File irc-info.nse
  File irc-sasl-brute.nse
  File irc-unrealircd-backdoor.nse
  File iscsi-brute.nse
  File iscsi-info.nse
  File isns-info.nse
  File jdwp-exec.nse
  File jdwp-info.nse
  File jdwp-inject.nse
  File jdwp-version.nse
  File krb5-enum-users.nse
  File ldap-brute.nse
  File ldap-novell-getpass.nse
  File ldap-rootdse.nse
  File ldap-search.nse
  File lexmark-config.nse
  File llmnr-resolve.nse
  File lltd-discovery.nse
  File maxdb-info.nse
  File mcafee-epo-agent.nse
  File membase-brute.nse
  File membase-http-info.nse
  File memcached-info.nse
  File metasploit-info.nse
  File metasploit-msgrpc-brute.nse
  File metasploit-xmlrpc-brute.nse
  File mikrotik-routeros-brute.nse
  File mmouse-brute.nse
  File mmouse-exec.nse
  File modbus-discover.nse
  File mongodb-brute.nse
  File mongodb-databases.nse
  File mongodb-info.nse
  File mrinfo.nse
  File ms-sql-brute.nse
  File ms-sql-config.nse
  File ms-sql-dac.nse
  File ms-sql-dump-hashes.nse
  File ms-sql-empty-password.nse
  File ms-sql-hasdbaccess.nse
  File ms-sql-info.nse
  File ms-sql-query.nse
  File ms-sql-tables.nse
  File ms-sql-xp-cmdshell.nse
  File msrpc-enum.nse
  File mtrace.nse
  File murmur-version.nse
  File mysql-audit.nse
  File mysql-brute.nse
  File mysql-databases.nse
  File mysql-dump-hashes.nse
  File mysql-empty-password.nse
  File mysql-enum.nse
  File mysql-info.nse
  File mysql-query.nse
  File mysql-users.nse
  File mysql-variables.nse
  File mysql-vuln-cve2012-2122.nse
  File nat-pmp-info.nse
  File nat-pmp-mapport.nse
  File nbstat.nse
  File ncp-enum-users.nse
  File ncp-serverinfo.nse
  File ndmp-fs-info.nse
  File ndmp-version.nse
  File nessus-brute.nse
  File nessus-xmlrpc-brute.nse
  File netbus-auth-bypass.nse
  File netbus-brute.nse
  File netbus-info.nse
  File netbus-version.nse
  File nexpose-brute.nse
  File nfs-ls.nse
  File nfs-showmount.nse
  File nfs-statfs.nse
  File nping-brute.nse
  File nrpe-enum.nse
  File ntp-info.nse
  File ntp-monlist.nse
  File omp2-brute.nse
  File omp2-enum-targets.nse
  File omron-info.nse
  File openlookup-info.nse
  File openvas-otp-brute.nse
  File oracle-brute-stealth.nse
  File oracle-brute.nse
  File oracle-enum-users.nse
  File oracle-sid-brute.nse
  File ovs-agent-version.nse
  File p2p-conficker.nse
  File path-mtu.nse
  File pcanywhere-brute.nse
  File pgsql-brute.nse
  File pjl-ready-message.nse
  File pop3-brute.nse
  File pop3-capabilities.nse
  File pptp-version.nse
  File qconn-exec.nse
  File qscan.nse
  File quake1-info.nse
  File quake3-info.nse
  File quake3-master-getservers.nse
  File rdp-enum-encryption.nse
  File rdp-vuln-ms12-020.nse
  File realvnc-auth-bypass.nse
  File redis-brute.nse
  File redis-info.nse
  File resolveall.nse
  File reverse-index.nse
  File rexec-brute.nse
  File rfc868-time.nse
  File riak-http-info.nse
  File rlogin-brute.nse
  File rmi-dumpregistry.nse
  File rmi-vuln-classloader.nse
  File rpc-grind.nse
  File rpcap-brute.nse
  File rpcap-info.nse
  File rpcinfo.nse
  File rsync-brute.nse
  File rsync-list-modules.nse
  File rtsp-methods.nse
  File rtsp-url-brute.nse
  File s7-info.nse
  File samba-vuln-cve-2012-1182.nse
  File script.db
  File servicetags.nse
  File sip-brute.nse
  File sip-call-spoof.nse
  File sip-enum-users.nse
  File sip-methods.nse
  File skypev2-version.nse
  File smb-brute.nse
  File smb-check-vulns.nse
  File smb-enum-domains.nse
  File smb-enum-groups.nse
  File smb-enum-processes.nse
  File smb-enum-sessions.nse
  File smb-enum-shares.nse
  File smb-enum-users.nse
  File smb-flood.nse
  File smb-ls.nse
  File smb-mbenum.nse
  File smb-os-discovery.nse
  File smb-print-text.nse
  File smb-psexec.nse
  File smb-security-mode.nse
  File smb-server-stats.nse
  File smb-system-info.nse
  File smb-vuln-ms10-054.nse
  File smb-vuln-ms10-061.nse
  File smbv2-enabled.nse
  File smtp-brute.nse
  File smtp-commands.nse
  File smtp-enum-users.nse
  File smtp-open-relay.nse
  File smtp-strangeport.nse
  File smtp-vuln-cve2010-4344.nse
  File smtp-vuln-cve2011-1720.nse
  File smtp-vuln-cve2011-1764.nse
  File sniffer-detect.nse
  File snmp-brute.nse
  File snmp-hh3c-logins.nse
  File snmp-info.nse
  File snmp-interfaces.nse
  File snmp-ios-config.nse
  File snmp-netstat.nse
  File snmp-processes.nse
  File snmp-sysdescr.nse
  File snmp-win32-services.nse
  File snmp-win32-shares.nse
  File snmp-win32-software.nse
  File snmp-win32-users.nse
  File socks-auth-info.nse
  File socks-brute.nse
  File socks-open-proxy.nse
  File ssh-hostkey.nse
  File ssh2-enum-algos.nse
  File sshv1.nse
  File ssl-ccs-injection.nse
  File ssl-cert.nse
  File ssl-date.nse
  File ssl-enum-ciphers.nse
  File ssl-google-cert-catalog.nse
  File ssl-heartbleed.nse
  File ssl-known-key.nse
  File ssl-poodle.nse
  File sslv2.nse
  File sstp-discover.nse
  File stun-info.nse
  File stun-version.nse
  File stuxnet-detect.nse
  File supermicro-ipmi-conf.nse
  File svn-brute.nse
  File targets-asn.nse
  File targets-ipv6-map4to6.nse
  File targets-ipv6-multicast-echo.nse
  File targets-ipv6-multicast-invalid-dst.nse
  File targets-ipv6-multicast-mld.nse
  File targets-ipv6-multicast-slaac.nse
  File targets-ipv6-wordlist.nse
  File targets-sniffer.nse
  File targets-traceroute.nse
  File teamspeak2-version.nse
  File telnet-brute.nse
  File telnet-encryption.nse
  File tftp-enum.nse
  File tls-nextprotoneg.nse
  File traceroute-geolocation.nse
  File unittest.nse
  File unusual-port.nse
  File upnp-info.nse
  File url-snarf.nse
  File ventrilo-info.nse
  File versant-info.nse
  File vmauthd-brute.nse
  File vnc-brute.nse
  File vnc-info.nse
  File voldemort-info.nse
  File vuze-dht-info.nse
  File wdb-version.nse
  File weblogic-t3-info.nse
  File whois-domain.nse
  File whois-ip.nse
  File wsdd-discover.nse
  File x11-access.nse
  File xdmcp-discover.nse
  File xmpp-brute.nse
  File xmpp-info.nse
  SetOutPath $_OUTDIR
  StrCpy $_OUTDIR $OUTDIR
  SetOutPath $_OUTDIR\nselib
  File afp.lua
  File ajp.lua
  File amqp.lua
  File anyconnect.lua
  File asn1.lua
  File base32.lua
  File base64.lua
  File bin.luadoc
  File bit.luadoc
  File bitcoin.lua
  File bittorrent.lua
  File bjnp.lua
  File brute.lua
  File cassandra.lua
  File citrixxml.lua
  File comm.lua
  File creds.lua
  File cvs.lua
  File datafiles.lua
  File dhcp.lua
  File dhcp6.lua
  File dns.lua
  File dnsbl.lua
  File dnssd.lua
  File drda.lua
  File eap.lua
  File eigrp.lua
  File formulas.lua
  File ftp.lua
  File giop.lua
  File gps.lua
  File http.lua
  File httpspider.lua
  File iax2.lua
  File ike.lua
  File imap.lua
  File informix.lua
  File ipOps.lua
  File ipp.lua
  File iscsi.lua
  File isns.lua
  File jdwp.lua
  File json.lua
  File ldap.lua
  File lfs.luadoc
  File listop.lua
  File lpeg-utility.lua
  File match.lua
  File membase.lua
  File mobileme.lua
  File mongodb.lua
  File msrpc.lua
  File msrpcperformance.lua
  File msrpctypes.lua
  File mssql.lua
  File mysql.lua
  File natpmp.lua
  File ncp.lua
  File ndmp.lua
  File netbios.lua
  File nmap.luadoc
  File nrpc.lua
  File nsedebug.lua
  File omp2.lua
  File openssl.luadoc
  File ospf.lua
  File packet.lua
  File pcre.luadoc
  File pgsql.lua
  File pop3.lua
  File pppoe.lua
  File proxy.lua
  File rdp.lua
  File re.lua
  File redis.lua
  File rmi.lua
  File rpc.lua
  File rpcap.lua
  File rsync.lua
  File rtsp.lua
  File sasl.lua
  File shortport.lua
  File sip.lua
  File smb.lua
  File smbauth.lua
  File smtp.lua
  File snmp.lua
  File socks.lua
  File srvloc.lua
  File ssh1.lua
  File ssh2.lua
  File sslcert.lua
  File stdnse.lua
  File strbuf.lua
  File strict.lua
  File stun.lua
  File tab.lua
  File target.lua
  File tftp.lua
  File tls.lua
  File tns.lua
  File unicode.lua
  File unittest.lua
  File unpwdb.lua
  File upnp.lua
  File url.lua
  File versant.lua
  File vnc.lua
  File vulns.lua
  File vuzedht.lua
  File wsdd.lua
  File xdmcp.lua
  File xmpp.lua
  SetOutPath $_OUTDIR\nselib\data
  File dns-srv-names
  File drupal-modules.lst
  File enterprise_numbers.txt
  File favicon-db
  File http-default-accounts-fingerprints.lua
  File http-devframework-fingerprints.lua
  File http-fingerprints.lua
  File http-folders.txt
  File http-sql-errors.lst
  File http-web-files-extensions.lst
  File ike-fingerprints.lua
  File mgroupnames.db
  File mysql-cis.audit
  File oracle-default-accounts.lst
  File oracle-sids
  File packetdecoders.lua
  File passwords.lst
  File pixel.gif
  File rtsp-urls.txt
  File snmpcommunities.lst
  File ssl-fingerprints
  File targets-ipv6-wordlist
  File tftplist.txt
  File usernames.lst
  File vhosts-default.lst
  File vhosts-full.lst
  File wp-plugins.lst
  File wp-themes.lst
  SetOutPath $_OUTDIR\nselib\data\jdwp-class
  File JDWPExecCmd.class
  File JDWPExecCmd.java
  File JDWPSystemInfo.class
  File JDWPSystemInfo.java
  File README.txt
  SetOutPath $_OUTDIR\nselib\data\psexec
  File README
  File backdoor.lua
  File default.lua
  File drives.lua
  File examples.lua
  File experimental.lua
  File network.lua
  File nmap_service.c
  File nmap_service.vcproj
  File pwdump.lua
  SetOutPath $_OUTDIR
  File icon1.ico
  WriteRegStr HKCU Software\Nmap "" $INSTDIR
  Call func_1376
  Call func_1416
SectionEnd


Section "Register Nmap Path" ; Section_1
  Push $INSTDIR
  Call func_0
SectionEnd


Section "WinPcap 4.1.3" ; Section_2
  ; AddSize 423
  SetOutPath $INSTDIR
  File winpcap-nmap-4.13.exe
  IfSilent label_925 label_1061
label_925:
  StrCpy $1 ""
  Call :label_928
  Goto label_961
label_928:
  StrCmp $CMDLINE "" 0 label_931
  Push ""
  Return

label_931:
  Push $0
  Push $1
  Push $2
  Push $3
  StrLen $1 $CMDLINE
  StrCpy $2 2
  StrCpy $3 $CMDLINE 1
  StrCmp $3 $\" label_940
  StrCpy $3 " "
label_940:
  IntCmp $2 $1 label_944 0 label_944
  StrCpy $0 $CMDLINE 1 $2
  IntOp $2 $2 + 1
  StrCmp $3 $0 0 label_940
label_944:
  IntCmp $2 $1 label_949 0 label_949
  StrCpy $0 $CMDLINE 1 $2
  StrCmp $0 " " 0 label_949
  IntOp $2 $2 + 1
  Goto label_944
label_949:
  StrCpy $0 $CMDLINE "" $2
label_950:
  StrCpy $1 $0 1 -1
  StrCmp $1 " " 0 label_954
  StrCpy $0 $0 -1
  Goto label_950
label_954:
  Pop $3
  Pop $2
  Pop $1
  Exch $0
    ; Push $0
    ; Exch
    ; Pop $0
  Return

label_961:
  Pop $R0
  ClearErrors
  Push $R0
  Push /NPFSTARTUP=
  Call :label_967
  Goto label_1056
label_967:
  Exch $1
    ; Push $1
    ; Exch
    ; Pop $1
  Exch
  Exch $0
    ; Push $0
    ; Exch
    ; Pop $0
  Exch
  Push $2
  Push $3
  Push $4
  Push $5
  Push $6
  Push $7
  ClearErrors
  StrCpy $2 $1 "" 1
  StrCpy $1 $1 1
  StrLen $3 $2
  StrCpy $7 0
label_986:
  StrCpy $4 -1
  StrCpy $6 ""
label_988:
  IntOp $4 $4 + 1
  StrCpy $5 $0 1 $4
  StrCmp $5$7 0 label_1043
  StrCmp $5 "" label_1030
  StrCmp $5 $\" 0 label_999
  StrCmp $6 "" 0 label_996
  StrCpy $6 $\"
  Goto label_988
label_996:
  StrCmp $6 $\" 0 label_999
  StrCpy $6 ""
  Goto label_988
label_999:
  StrCmp $5 ' 0 label_1006
  StrCmp $6 "" 0 label_1003
  StrCpy $6 '
  Goto label_988
label_1003:
  StrCmp $6 ' 0 label_1006
  StrCpy $6 ""
  Goto label_988
label_1006:
  StrCmp $5 ` 0 label_1013
  StrCmp $6 "" 0 label_1010
  StrCpy $6 `
  Goto label_988
label_1010:
  StrCmp $6 ` 0 label_1013
  StrCpy $6 ""
  Goto label_988
label_1013:
  StrCmp $6 $\" label_988
  StrCmp $6 ' label_988
  StrCmp $6 ` label_988
  StrCmp $5 $1 0 label_988
  StrCmp $7 0 label_1018 label_1030
label_1018:
  IntOp $4 $4 + 1
  StrCpy $5 $0 $3 $4
  StrCmp $5 "" label_1043
  StrCmp $5 $2 0 label_988
  IntOp $4 $4 + $3
  StrCpy $0 $0 "" $4
label_1024:
  StrCpy $4 $0 1
  StrCmp $4 " " 0 label_1028
  StrCpy $0 $0 "" 1
  Goto label_1024
label_1028:
  StrCpy $7 1
  Goto label_986
label_1030:
  StrCpy $0 $0 $4
label_1031:
  StrCpy $4 $0 1 -1
  StrCmp $4 " " 0 label_1035
  StrCpy $0 $0 -1
  Goto label_1031
label_1035:
  StrCpy $3 $0 1
  StrCpy $4 $0 1 -1
  StrCmp $3 $4 0 label_1045
  StrCmp $3 $\" label_1041
  StrCmp $3 ' label_1041
  StrCmp $3 ` 0 label_1045
label_1041:
  StrCpy $0 $0 -1 1
  Goto label_1045
label_1043:
  SetErrors
  StrCpy $0 ""
label_1045:
  Pop $7
  Pop $6
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Exch $0
    ; Push $0
    ; Exch
    ; Pop $0
  Return

label_1056:
  Pop $2
  StrCmp $2 NO 0 label_1059
  StrCpy $1 "/NPFSTARTUP=NO $1"
label_1059:
  ExecWait "$\"$INSTDIR\winpcap-nmap-4.13.exe$\" $1 /S"
  Goto label_1062
label_1061:
  ExecWait $\"$INSTDIR\winpcap-nmap-4.13.exe$\"
label_1062:
  Delete $INSTDIR\winpcap-nmap-4.13.exe
SectionEnd


Section "Network Performance Improvements" ; Section_3
  ; AddSize 1
  SetOutPath $INSTDIR
  File nmap_performance.reg
  Exec "regedt32 /S $\"$INSTDIR\nmap_performance.reg$\""
SectionEnd


Section "Zenmap (GUI Frontend)" ; Section_4
  ; AddSize 27083
  SetOutPath $INSTDIR
  File zenmap.exe
  File ZENMAP_README
  File COPYING_HIGWIDGETS
  File python27.dll
  StrCpy $_OUTDIR $OUTDIR
  SetOutPath $_OUTDIR\py2exe\share
  SetOutPath $_OUTDIR\py2exe\share\icons
  SetOutPath $_OUTDIR\py2exe\share\icons\hicolor
  File index.theme
  SetOutPath $_OUTDIR\py2exe\share\themes
  SetOutPath $_OUTDIR\py2exe\share\themes\Default
  SetOutPath $_OUTDIR\py2exe\share\themes\Default\gtk-2.0-key
  File gtkrc
  SetOutPath $_OUTDIR\py2exe\share\themes\MS-Windows
  SetOutPath $_OUTDIR\py2exe\share\themes\MS-Windows\gtk-2.0
  File gtkrc
  SetOutPath $_OUTDIR\share
  SetOutPath $_OUTDIR\share\zenmap
  SetOutPath $_OUTDIR\share\zenmap\config
  File scan_profile.usp
  File zenmap.conf
  File zenmap_version
  SetOutPath $_OUTDIR\share\zenmap\docs
  File help.html
  SetOutPath $_OUTDIR\share\zenmap\locale
  SetOutPath $_OUTDIR\share\zenmap\locale\de
  SetOutPath $_OUTDIR\share\zenmap\locale\de\LC_MESSAGES
  File zenmap.mo
  SetOutPath $_OUTDIR\share\zenmap\locale\fr
  SetOutPath $_OUTDIR\share\zenmap\locale\fr\LC_MESSAGES
  File zenmap.mo
  SetOutPath $_OUTDIR\share\zenmap\locale\hi
  SetOutPath $_OUTDIR\share\zenmap\locale\hi\LC_MESSAGES
  File zenmap.mo
  SetOutPath $_OUTDIR\share\zenmap\locale\hr
  SetOutPath $_OUTDIR\share\zenmap\locale\hr\LC_MESSAGES
  File zenmap.mo
  SetOutPath $_OUTDIR\share\zenmap\locale\it
  SetOutPath $_OUTDIR\share\zenmap\locale\it\LC_MESSAGES
  File zenmap.mo
  SetOutPath $_OUTDIR\share\zenmap\locale\ja
  SetOutPath $_OUTDIR\share\zenmap\locale\ja\LC_MESSAGES
  File zenmap.mo
  SetOutPath $_OUTDIR\share\zenmap\locale\pl
  SetOutPath $_OUTDIR\share\zenmap\locale\pl\LC_MESSAGES
  File zenmap.mo
  SetOutPath $_OUTDIR\share\zenmap\locale\pt_BR
  SetOutPath $_OUTDIR\share\zenmap\locale\pt_BR\LC_MESSAGES
  File zenmap.mo
  SetOutPath $_OUTDIR\share\zenmap\locale\ru
  SetOutPath $_OUTDIR\share\zenmap\locale\ru\LC_MESSAGES
  File zenmap.mo
  SetOutPath $_OUTDIR\share\zenmap\locale\zh
  SetOutPath $_OUTDIR\share\zenmap\locale\zh\LC_MESSAGES
  File zenmap.mo
  SetOutPath $_OUTDIR\share\zenmap\misc
  File profile_editor.xml
  SetOutPath $_OUTDIR\share\zenmap\pixmaps
  File default_32.png
  File default_75.png
  File freebsd_32.png
  File freebsd_75.png
  File irix_32.png
  File irix_75.png
  File linux_32.png
  File linux_75.png
  File macosx_32.png
  File macosx_75.png
  File openbsd_32.png
  File openbsd_75.png
  File redhat_32.png
  File redhat_75.png
  File solaris_32.png
  File solaris_75.png
  File throbber.gif
  File throbber.png
  File ubuntu_32.png
  File ubuntu_75.png
  File unknown_32.png
  File unknown_75.png
  File vl_1_32.png
  File vl_1_75.png
  File vl_2_32.png
  File vl_2_75.png
  File vl_3_32.png
  File vl_3_75.png
  File vl_4_32.png
  File vl_4_75.png
  File vl_5_32.png
  File vl_5_75.png
  File win_32.png
  File win_75.png
  File zenmap.png
  SetOutPath $_OUTDIR\share\zenmap\pixmaps\radialnet
  File border.png
  File firewall.png
  File logo.png
  File padlock.png
  File router.png
  File switch.png
  File wireless.png
  SetOutPath $_OUTDIR
  StrCpy $_OUTDIR $OUTDIR
  SetOutPath $_OUTDIR\py2exe
  File _ctypes.pyd
  File _hashlib.pyd
  File _socket.pyd
  File _sqlite3.pyd
  File _ssl.pyd
  File atk.pyd
  File bz2.pyd
  File cairo._cairo.pyd
  File freetype6.dll
  File gio._gio.pyd
  File glib._glib.pyd
  File gobject._gobject.pyd
  File gtk._gtk.pyd
  File intl.dll
  File libasprintf-0.dll
  File libatk-1.0-0.dll
  File libcairo-2.dll
  File libcairo-gobject-2.dll
  File libcairo-script-interpreter-2.dll
  File libcroco-0.6-3.dll
  File libexpat-1.dll
  File libfontconfig-1.dll
  File libgailutil-18.dll
  File libgcc_s_dw2-1.dll
  File libgdk-win32-2.0-0.dll
  File libgdk_pixbuf-2.0-0.dll
  File libgio-2.0-0.dll
  File libglade-2.0-0.dll
  File libglib-2.0-0.dll
  File libgmodule-2.0-0.dll
  File libgobject-2.0-0.dll
  File libgsf-1-114.dll
  File libgsf-win32-1-114.dll
  File libgthread-2.0-0.dll
  File libgtk-win32-2.0-0.dll
  File libpango-1.0-0.dll
  File libpangocairo-1.0-0.dll
  File libpangoft2-1.0-0.dll
  File libpangowin32-1.0-0.dll
  File libpng14-14.dll
  File library.zip
  File librsvg-2-2.dll
  File libxml2-2.dll
  File pango.pyd
  File pangocairo.pyd
  File pyexpat.pyd
  File select.pyd
  File sqlite3.dll
  File unicodedata.pyd
  File zlib1.dll
  SetOutPath $_OUTDIR\py2exe\etc
  SetOutPath $_OUTDIR\py2exe\etc\bash_completion.d
  File gdbus-bash-completion.sh
  File gsettings-bash-completion.sh
  SetOutPath $_OUTDIR\py2exe\etc\fonts
  File fonts.conf
  File fonts.dtd
  SetOutPath $_OUTDIR\py2exe\etc\gtk-2.0
  File gtk.immodules
  File gtkrc
  File im-multipress.conf
  SetOutPath $_OUTDIR\py2exe\etc\pango
  File pango.aliases
  File pango.modules
  SetOutPath $_OUTDIR\py2exe\lib
  SetOutPath $_OUTDIR\py2exe\lib\gtk-2.0
  SetOutPath $_OUTDIR\py2exe\lib\gtk-2.0\2.10.0
  SetOutPath $_OUTDIR\py2exe\lib\gtk-2.0\2.10.0\engines
  File libpixmap.dll
  File libsvg.dll
  File libwimp.dll
  SetOutPath $_OUTDIR\py2exe\lib\gtk-2.0\include
  File gdkconfig.h
  SetOutPath $_OUTDIR\py2exe\lib\gtk-2.0\modules
  File libgail.dll
  SetOutPath $_OUTDIR\py2exe\share
  SetOutPath $_OUTDIR\py2exe\share\icons
  SetOutPath $_OUTDIR\py2exe\share\icons\hicolor
  File index.theme
  SetOutPath $_OUTDIR\py2exe\share\themes
  SetOutPath $_OUTDIR\py2exe\share\themes\Default
  SetOutPath $_OUTDIR\py2exe\share\themes\Default\gtk-2.0-key
  File gtkrc
  SetOutPath $_OUTDIR\py2exe\share\themes\MS-Windows
  SetOutPath $_OUTDIR\py2exe\share\themes\MS-Windows\gtk-2.0
  File gtkrc
  SetOutPath $_OUTDIR
  StrCpy $_3_ true
  Call func_1396
  Call func_1416
SectionEnd


Section "Ncat (Modern Netcat reincarnation)" ; Section_5
  ; AddSize 629
  SetOutPath $INSTDIR
  File ncat.exe
  File ca-bundle.crt
  Call func_1376
  Call func_1416
SectionEnd


Section "Ndiff (Scan comparison tool)" ; Section_6
  ; AddSize 25912
  SetOutPath $INSTDIR
  File ndiff.exe
  File NDIFF_README
  File python27.dll
  StrCpy $_OUTDIR $OUTDIR
  SetOutPath $_OUTDIR\py2exe
  File _ctypes.pyd
  File _hashlib.pyd
  File _socket.pyd
  File _sqlite3.pyd
  File _ssl.pyd
  File atk.pyd
  File bz2.pyd
  File cairo._cairo.pyd
  File freetype6.dll
  File gio._gio.pyd
  File glib._glib.pyd
  File gobject._gobject.pyd
  File gtk._gtk.pyd
  File intl.dll
  File libasprintf-0.dll
  File libatk-1.0-0.dll
  File libcairo-2.dll
  File libcairo-gobject-2.dll
  File libcairo-script-interpreter-2.dll
  File libcroco-0.6-3.dll
  File libexpat-1.dll
  File libfontconfig-1.dll
  File libgailutil-18.dll
  File libgcc_s_dw2-1.dll
  File libgdk-win32-2.0-0.dll
  File libgdk_pixbuf-2.0-0.dll
  File libgio-2.0-0.dll
  File libglade-2.0-0.dll
  File libglib-2.0-0.dll
  File libgmodule-2.0-0.dll
  File libgobject-2.0-0.dll
  File libgsf-1-114.dll
  File libgsf-win32-1-114.dll
  File libgthread-2.0-0.dll
  File libgtk-win32-2.0-0.dll
  File libpango-1.0-0.dll
  File libpangocairo-1.0-0.dll
  File libpangoft2-1.0-0.dll
  File libpangowin32-1.0-0.dll
  File libpng14-14.dll
  File library.zip
  File librsvg-2-2.dll
  File libxml2-2.dll
  File pango.pyd
  File pangocairo.pyd
  File pyexpat.pyd
  File select.pyd
  File sqlite3.dll
  File unicodedata.pyd
  File zlib1.dll
  SetOutPath $_OUTDIR\py2exe\etc
  SetOutPath $_OUTDIR\py2exe\etc\bash_completion.d
  File gdbus-bash-completion.sh
  File gsettings-bash-completion.sh
  SetOutPath $_OUTDIR\py2exe\etc\fonts
  File fonts.conf
  File fonts.dtd
  SetOutPath $_OUTDIR\py2exe\etc\gtk-2.0
  File gtk.immodules
  File gtkrc
  File im-multipress.conf
  SetOutPath $_OUTDIR\py2exe\etc\pango
  File pango.aliases
  File pango.modules
  SetOutPath $_OUTDIR\py2exe\lib
  SetOutPath $_OUTDIR\py2exe\lib\gtk-2.0
  SetOutPath $_OUTDIR\py2exe\lib\gtk-2.0\2.10.0
  SetOutPath $_OUTDIR\py2exe\lib\gtk-2.0\2.10.0\engines
  File libpixmap.dll
  File libsvg.dll
  File libwimp.dll
  SetOutPath $_OUTDIR\py2exe\lib\gtk-2.0\include
  File gdkconfig.h
  SetOutPath $_OUTDIR\py2exe\lib\gtk-2.0\modules
  File libgail.dll
  SetOutPath $_OUTDIR\py2exe\share
  SetOutPath $_OUTDIR\py2exe\share\icons
  SetOutPath $_OUTDIR\py2exe\share\icons\hicolor
  File index.theme
  SetOutPath $_OUTDIR\py2exe\share\themes
  SetOutPath $_OUTDIR\py2exe\share\themes\Default
  SetOutPath $_OUTDIR\py2exe\share\themes\Default\gtk-2.0-key
  File gtkrc
  SetOutPath $_OUTDIR\py2exe\share\themes\MS-Windows
  SetOutPath $_OUTDIR\py2exe\share\themes\MS-Windows\gtk-2.0
  File gtkrc
  SetOutPath $_OUTDIR
  Call func_1396
  Call func_1416
SectionEnd


Section "Nping (Packet generator)" ; Section_7
  ; AddSize 310
  SetOutPath $INSTDIR
  File nping.exe
  Call func_1376
  Call func_1416
SectionEnd


Section "nmap-update (updater for architecture-independent files)" ; Section_8
  ; AddSize 2089
  SetOutPath $INSTDIR
  File nmap-update.exe
  Call func_1376
  Call func_1416
SectionEnd


Function func_1376
  StrCmp $_5_ "" 0 label_1395
  StrCpy $_5_ true
  ReadRegStr $0 HKLM SOFTWARE\Microsoft\DevDiv\vc\Servicing\12.0\RuntimeMinimum Install
  StrCmp $0 1 label_1395 label_1380
label_1380:
  ReadRegStr $0 HKLM SOFTWARE\Wow6432Node\Microsoft\DevDiv\vc\Servicing\12.0\RuntimeMinimum Install
  StrCmp $0 1 label_1395 label_1382
label_1382:
  DetailPrint "Installing Microsoft Visual C++ 2013 Redistributable"
  File vcredist_x86.exe
  ExecWait "$\"$INSTDIR\vcredist_x86.exe$\" /q" $0
  ReadRegStr $0 HKLM SOFTWARE\Microsoft\DevDiv\vc\Servicing\12.0\RuntimeMinimum Install
  StrCmp $0 1 label_1393 label_1387
label_1387:
  ReadRegStr $0 HKLM SOFTWARE\Wow6432Node\Microsoft\DevDiv\vc\Servicing\12.0\RuntimeMinimum Install
  StrCmp $0 1 label_1393 label_1389
label_1389:
  DetailPrint "Microsoft Visual C++ 2013 Redistributable failed to install"
  IfSilent label_1395 label_1391
label_1391:
  MessageBox MB_OK "Microsoft Visual C++ 2013 Redistributable Package (x86) failed to install ($INSTDIR\vcredist_x86.exe). Please ensure your system meets the minimum requirements before running the installer again."
  Goto label_1395
label_1393:
  Delete $INSTDIR\vcredist_x86.exe
  DetailPrint "Microsoft Visual C++ 2013 Redistributable was successfully installed"
label_1395:
FunctionEnd


Function func_1396
  StrCmp $_6_ "" 0 label_1415
  StrCpy $_6_ true
  ReadRegStr $0 HKLM SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9BE518E6-ECC6-35A9-88E4-87755C07200F} DisplayName
  StrCmp $0 "Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.6161" label_1415 label_1400
label_1400:
  ReadRegStr $0 HKLM SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{9BE518E6-ECC6-35A9-88E4-87755C07200F} DisplayName
  StrCmp $0 "Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.6161" label_1415 label_1402
label_1402:
  DetailPrint "Installing Microsoft Visual C++ 2008 Redistributable"
  File vcredist2008_x86.exe
  ExecWait "$\"$INSTDIR\vcredist2008_x86.exe$\" /q" $0
  ReadRegStr $0 HKLM SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9BE518E6-ECC6-35A9-88E4-87755C07200F} DisplayName
  StrCmp $0 "Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.6161" label_1413 label_1407
label_1407:
  ReadRegStr $0 HKLM SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9BE518E6-ECC6-35A9-88E4-87755C07200F} DisplayName
  StrCmp $0 "Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.6161" label_1413 label_1409
label_1409:
  DetailPrint "Microsoft Visual C++ 2008 Redistributable failed to install"
  IfSilent label_1415 label_1411
label_1411:
  MessageBox MB_OK "Microsoft Visual C++ 2008 Redistributable Package (x86) failed to install ($INSTDIR\vcredist2008_x86.exe). Please ensure your system meets the minimum requirements before running the installer again."
  Goto label_1415
label_1413:
  Delete $INSTDIR\vcredist2008_x86.exe
  DetailPrint "Microsoft Visual C++ 2008 Redistributable was successfully installed"
label_1415:
FunctionEnd


Function func_1416
  StrCmp $_4_ "" 0 label_1424
  WriteRegStr HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\Nmap DisplayName "Nmap 6.49BETA4"
  WriteRegStr HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\Nmap UninstallString $\"$INSTDIR\uninstall.exe$\"
  WriteRegStr HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\Nmap DisplayIcon $\"$INSTDIR\icon1.ico$\"
  WriteRegDWORD HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\Nmap NoModify 1
  WriteRegDWORD HKLM Software\Microsoft\Windows\CurrentVersion\Uninstall\Nmap NoRepair 1
  WriteUninstaller $INSTDIR\Uninstall.exe ;  $INSTDIR\$INSTDIR\Uninstall.exe
  StrCpy $_4_ true
label_1424:
FunctionEnd


Function .onInit
  InitPluginsDir
    ; Call Initialize_____Plugins
    ; SetDetailsPrint lastused
  File $PLUGINSDIR\shortcuts.ini
  WriteINIStr $PLUGINSDIR\shortcuts.ini Settings RTL $(LSTR_56)    ;  0
  InitPluginsDir
    ; Call Initialize_____Plugins
    ; SetDetailsPrint lastused
  File $PLUGINSDIR\final.ini
  WriteINIStr $PLUGINSDIR\final.ini Settings RTL $(LSTR_56)    ;  0
  Call :label_928
  Pop $0
  Push $0
  Push /NMAP=
  Call :label_967
  Pop $1
  StrCmp $1 NO 0 label_1443
  SectionGetFlags 0 $2
  IntOp $2 $2 & 0xFFFFFFFE
  SectionSetFlags 0 $2
label_1443:
  Push $0
  Push /REGISTERPATH=
  Call :label_967
  Pop $1
  StrCmp $1 NO 0 label_1451
  SectionGetFlags 1 $2
  IntOp $2 $2 & 0xFFFFFFFE
  SectionSetFlags 1 $2
label_1451:
  Push $0
  Push /WINPCAP=
  Call :label_967
  Pop $1
  StrCmp $1 NO 0 label_1459
  SectionGetFlags 2 $2
  IntOp $2 $2 & 0xFFFFFFFE
  SectionSetFlags 2 $2
label_1459:
  Push $0
  Push /REGISTRYMODS=
  Call :label_967
  Pop $1
  StrCmp $1 NO 0 label_1467
  SectionGetFlags 3 $2
  IntOp $2 $2 & 0xFFFFFFFE
  SectionSetFlags 3 $2
label_1467:
  Push $0
  Push /ZENMAP=
  Call :label_967
  Pop $1
  StrCmp $1 NO 0 label_1475
  SectionGetFlags 4 $2
  IntOp $2 $2 & 0xFFFFFFFE
  SectionSetFlags 4 $2
label_1475:
  Push $0
  Push /NCAT=
  Call :label_967
  Pop $1
  StrCmp $1 NO 0 label_1483
  SectionGetFlags 5 $2
  IntOp $2 $2 & 0xFFFFFFFE
  SectionSetFlags 5 $2
label_1483:
  Push $0
  Push /NDIFF=
  Call :label_967
  Pop $1
  StrCmp $1 NO 0 label_1491
  SectionGetFlags 6 $2
  IntOp $2 $2 & 0xFFFFFFFE
  SectionSetFlags 6 $2
label_1491:
  Push $0
  Push /NPING=
  Call :label_967
  Pop $1
  StrCmp $1 NO 0 label_1499
  SectionGetFlags 7 $2
  IntOp $2 $2 & 0xFFFFFFFE
  SectionSetFlags 7 $2
label_1499:
  Push $0
  Push /NMAPUPDATE=
  Call :label_967
  Pop $1
  StrCmp $1 NO 0 label_1507
  SectionGetFlags 8 $2
  IntOp $2 $2 & 0xFFFFFFFE
  SectionSetFlags 8 $2
label_1507:
FunctionEnd


Function .onMouseOverSection
  FindWindow $_0_ "#32770" "" $HWNDPARENT
  GetDlgItem $_0_ $_0_ 1043
  StrCmp $0 -1 0 label_1515
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:
  EnableWindow $_0_ 0
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$_2_
  Goto label_1560
label_1515:
  StrCmp $0 0 0 label_1520
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:
  EnableWindow $_0_ 1
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_57)    ;  "Installs Nmap executable, NSE scripts and Visual C++ 2013 runtime components"
  Goto label_1560
label_1520:
  StrCmp $0 2 0 label_1525
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:
  EnableWindow $_0_ 1
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_58)    ;  "Installs WinPcap 4.1.3 (required for most Nmap scans unless it is already installed)"
  Goto label_1560
label_1525:
  StrCmp $0 1 0 label_1530
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:
  EnableWindow $_0_ 1
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_59)    ;  "Registers Nmap path to System path so you can execute it from any directory"
  Goto label_1560
label_1530:
  StrCmp $0 3 0 label_1535
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:
  EnableWindow $_0_ 1
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_60)    ;  "Modifies Windows registry values to improve TCP connect scan performance.  Recommended."
  Goto label_1560
label_1535:
  StrCmp $0 4 0 label_1540
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:
  EnableWindow $_0_ 1
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_61)    ;  "Installs Zenmap, the official Nmap graphical user interface, and Visual C++ 2008 runtime components.  Recommended."
  Goto label_1560
label_1540:
  StrCmp $0 5 0 label_1545
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:
  EnableWindow $_0_ 1
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_62)    ;  "Installs Ncat, Nmap's Netcat replacement."
  Goto label_1560
label_1545:
  StrCmp $0 6 0 label_1550
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:
  EnableWindow $_0_ 1
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_63)    ;  "Installs Ndiff, a tool for comparing Nmap XML files."
  Goto label_1560
label_1550:
  StrCmp $0 7 0 label_1555
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:
  EnableWindow $_0_ 1
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_64)    ;  "Installs Nping, a packet generation tool."
  Goto label_1560
label_1555:
  StrCmp $0 8 0 label_1560
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:
  EnableWindow $_0_ 1
  SendMessage $_0_ ${WM_SETTEXT} 0 STR:$(LSTR_65)    ;  "Installs nmap-update, an updater for architecture-independent files."
  Goto label_1560
label_1560:
FunctionEnd


/*
Function Initialize_____Plugins
  SetDetailsPrint none
  StrCmp $PLUGINSDIR "" 0 label_1571
  Push $0
  SetErrors
  GetTempFileName $0
  Delete $0
  CreateDirectory $0
  IfErrors label_1572
  StrCpy $PLUGINSDIR $0
  Pop $0
label_1571:
  Return

label_1572:
  MessageBox MB_OK|MB_ICONSTOP "Error! Can't initialize plug-ins directory. Please try again later." /SD IDOK
  Quit
FunctionEnd
*/



; --------------------
; UNREFERENCED STRINGS:

/*
34 $PROGRAMFILES
38 CommonFilesDir
53 "$PROGRAMFILES\Common Files"
70 $COMMONFILES
*/
