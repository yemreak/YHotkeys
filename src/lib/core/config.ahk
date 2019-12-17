﻿; ####################################################################################
; ##                                                                                ##
; ##                              YAPILANDIRMA VERİLERİ                             ##
; ##                                                                                ##
; ####################################################################################

; UTF-8 with BOM

; Core Settings
APP_NAME := "YHotkeys"
DIR_NAME := A_AppData . "\" . APP_NAME
VERSION = 2.3.2

; Menu config
ICON_APP := "seedling.ico"
ICON_DEFAULT := "default.ico"
ICON_CLEAR := "clear.ico"
ICON_CLOSE := "close.ico"
ICON_UPDATE := "update.ico"

TITLE_CLOSE := "Çıkış"
TITLE_CLEAR := "Temizle"
TITLE_UPDATE := "Güncelle"

TEXT_CONNECTION_ERROR := "🐞 Bağlantı hatası"
TEXT_DOWNLOAD_START := "⏱ Yükleme hazırlanıyor"
TEXT_DOWNLOADING := "✨ Yükleniyor..."
TITLE_TEXT_DOWNLOADING := "Yükleniyor"

; Update utility
NEWEST_URL = https://github.com/yedhrab/YHotkeys/raw/master/src/YHotkeys.exe
RELEASE_URL = http://github.com/yedhrab/yhotkeys/releases/latest/download/yhotkeys.exe
API_RELEASE = https://api.github.com/repos/yedhrab/YHotkeys/releases/latest
FILENAME = YHotkeys.exe
