; ####################################################################################
; ##                                                                                ##
; ##                              YAPILANDIRMA VERİLERİ                             ##
; ##                                                                                ##
; ####################################################################################

; UTF-8 with BOM

; ------------------------------- Development Settings -------------------------------
DEBUG := True

; ----------------------------------- App Settings -----------------------------------
APP_ICON = 🌱
APP_NAME = YHotkeys
APP_DESCRIPTION = Kısayol Yöneticisi
APP_OWNER = YEmreAk
APP_PAGE = https://yhotkeys.yemreak.com

; -------------------------------- Data dir settings ---------------------------------
DIR_NAME := A_AppData . "\" . APP_NAME
DIR_ICON := DIR_NAME . "\Icons"

; --------------------------------- Update settings ----------------------------------
VERSION = 2.4.3.2b
API_RELEASE = https://api.github.com/repos/yedhrab/YHotkeys/releases/latest

PATH_EXE = %DIR_NAME%\YHotkeys.exe
PATH_UPDATER = %DIR_NAME%\YUpdater.exe
PATH_INSTALLER = %DIR_NAME%\YInstaller.exe

CLEAN_INSTALL := True

; --------------------------------- Windows settings ---------------------------------
HIDDEN_WINDOWS := []
PINNED_WINDOWS := []
LAST_ACTIVE_WINDOW_ID := ""

TRANSPARENT_PINNED = 220
TRANSPARENT_NORMAL = 255

; ---------------------------------- Menu settings -----------------------------------
TIP_MENU := APP_ICON . " " . APP_NAME . " - " . APP_DESCRIPTION " ~ " . APP_OWNER . " (v" . VERSION . ")"

ICON_APP := "seedling.ico"
ICON_DEFAULT := "default.ico"
ICON_CLEAR := "clear.ico"
ICON_CLOSE := "close.ico"
ICON_UPDATE := "update.ico"
ICON_MORE := "details.ico"
ICON_HOTKEY := "hotkeys.ico"
ICON_DOC := "doc.ico"

TITLE_CLOSE := "Çıkış"
TITLE_CLEAR := "Temizle"
TITLE_UPDATE := "Güncelle"
TITLE_MORE := "Detaylar"
TITLE_HOTKEYS := "Kısayollar"
TITLE_DOC := "Dokümantasyon"

MENU_TRAY := "tray"
MENU_MORE := "Detaylar"
