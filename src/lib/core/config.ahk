; ####################################################################################
; ##                                                                                ##
; ##                              YAPILANDIRMA VERİLERİ                             ##
; ##                                                                                ##
; ####################################################################################

; UTF-8 with BOM

DEBUG := False

; Core Settings
APP_NAME := "YHotkeys"
DIR_NAME := A_AppData . "\" . APP_NAME
DIR_ICON := DIR_NAME . "\Icons"

VERSION = 2.4.0.1
API_RELEASE = https://api.github.com/repos/yedhrab/YHotkeys/releases/latest
PATH_UPDATER = %DIR_NAME%\updater.exe

; Gizlenmiş pencelerin ID'si (Ini file olabilir)
HIDDEN_WINDOWS := []
PINNED_WINDOWS := []

; Menu config
ICON_APP := "seedling.ico"
ICON_DEFAULT := "default.ico"
ICON_CLEAR := "clear.ico"
ICON_CLOSE := "close.ico"
ICON_UPDATE := "update.ico"

TITLE_CLOSE := "Çıkış"
TITLE_CLEAR := "Temizle"
TITLE_UPDATE := "Güncelle"

TRANSPARENT_PINNED = 220
TRANSPARENT_NORMAL = 255
