/*
EmojiMenu.ahk uses the Hotkey combination CTRL+ALT+E to search the EmojiInsert.ahk Hotstring file. 
Select the keyword, execute the Hotkey, and a menu of matching emojis pops up. Click a menu item
to insert the emoji into any UTF-8 supported document or Web page. Edit the EmojiInsert.ahk file
to change activating Hotstrings and add categories after a semicolon ( ; ).

This version of EmojiMenu.ahk captures matching records in a variable (EmojiItems), then sorts the variable
before inserting the matched items into the menu. This gives a menu in alphabetical order.

Discussed in the blog at:
https://jacksautohotkeyblog.wordpress.com/2018/07/02/put-your-emoji-hotstrings-in-a-pop-up-menu-autohotkey-trick
and other blogs.

*/

#^ş::
    OldClipboard:= ClipboardAll
    Clipboard:= ""
    Send, ^c ; copies selected text
    ClipWait 0
    If ErrorLevel
    {
        ToolTip, 🐛 Hata oluştu,,,20
        Sleep, 1000
        ToolTip,,,,20
        Return
    }
    
    EmojiItems := ""
    Loop, read, %DIR_SCRIPTS%\yemoji.ahk
    {
        If InStr(A_LoopReadLine,Trim(Clipboard)) and (A_LoopReadLine ~= "::")
        {
            Emoji := StrSplit(A_LoopReadLine , ":")
            Icon := StrSplit(Emoji[6], ";")
            EmojiItems := EmojiItems . Emoji[4] . " | " . Trim(Icon[1]) . "`n"
        }
    } 
    Sort, EmojiItems, U
    
    ItemCount := 0
    Loop, Parse, EmojiItems , `n
    {
        If ItemCount = 20
        {
            Menu, EmojiMenu, add, % A_LoopField, InsertEmoji, +BarBreak
            ItemCount := 1
        } 
        Else
        {
            Menu, EmojiMenu, add, % A_LoopField, InsertEmoji
            ItemCount++
        }
        
    }
    
    If ItemCount
    {
        Menu, EmojiMenu, Show
        ; After selection or cancelation, the script deletes the menu.
        Menu, EmojiMenu, DeleteAll
    }
    Else {
        ToolTip, 😢 Emoji bulunamadı,,,19
        Sleep, 1000
        ToolTip,,,,19
    }
    
    ; Restore the old Clipboard contents.
    Clipboard := OldClipboard
Return

InsertEmoji:
    
    EmojiIcon := StrSplit(A_ThisMenuItem , "|")
    
    SendInput, % Trim(EmojiIcon[2])
    
Return
