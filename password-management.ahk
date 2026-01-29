#Requires AutoHotkey v2.0

; TODO
; - Start the script after double clicking and listening to BACKSPACE
; - 


; Keep the script running indefinitely because we want to use the tray icon to launch it
Persistent(true)

; Set an icon for the system tray (a key pad)
TraySetIcon("shell32.dll", 48)

; Slow down typing
SendMode("Event") ; Event, Input, or Play (only Event work with SetKeyDelay)
SetKeyDelay(100)  ; 100ms delay between each character

; Ask for password at startup
passwordInputBox := InputBox("Enter your password:", "Password Input")

; Check if user cancelled
if passwordInputBox.Result = "Cancel" {
    ExitApp()
}

; Store the password
savedPassword := passwordInputBox.Value

Tray := A_TrayMenu                          ; For convenience.
Tray.Delete()                               ; Delete all default menu items
Tray.Add("Type password", AutoTypePassword) ; Menu item to auto type the password
Tray.Default := "Type password"             ; Set as default (double click)
Tray.Add()                                  ; Separator
Tray.Add("Exit", (*) => ExitApp())          ; Menu item for exit

; Type the password after BACKSPACE is pressed
AutoTypePassword(*) {
    TrayTip("Password management", "Waiting for BACKSPACE")
    KeyWait("Backspace", "D T5") ; Wait up to 5 seconds for the BACKSPACE to be pressed
    Send(savedPassword)
}