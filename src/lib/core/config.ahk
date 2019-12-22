; ####################################################################################
; ##                                                                                ##
; ##                              YAPILANDIRMA VERİLERİ                             ##
; ##                                                                                ##
; ####################################################################################

; UTF-8 with BOM

; ------------------------------- Development Settings -------------------------------
DEBUG := False

; ----------------------------------- App Settings -----------------------------------
APP_NAME := "YHotkeys"
APP_PAGE = https://yhotkeys.yemreak.com

; -------------------------------- Data dir settings ---------------------------------
DIR_NAME := A_AppData . "\" . APP_NAME
DIR_ICON := DIR_NAME . "\Icons"

; --------------------------------- Update settings ----------------------------------
VERSION = 2.4.0.2
API_RELEASE = https://api.github.com/repos/yedhrab/YHotkeys/releases/latest
PATH_UPDATER = %DIR_NAME%\updater.exe

; --------------------------------- Windows settings ---------------------------------
HIDDEN_WINDOWS := []
PINNED_WINDOWS := []

TRANSPARENT_PINNED = 220
TRANSPARENT_NORMAL = 255

; ---------------------------------- Menu settings -----------------------------------
ICON_APP := "seedling.ico"
ICON_DEFAULT := "default.ico"
ICON_CLEAR := "clear.ico"
ICON_CLOSE := "close.ico"
ICON_UPDATE := "update.ico"

TITLE_CLOSE := "Çıkış"
TITLE_CLEAR := "Temizle"
TITLE_UPDATE := "Güncelle"
