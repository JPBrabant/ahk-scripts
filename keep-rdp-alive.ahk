#Requires AutoHotkey v2.0

; === Parameters ===
endHour := 16
minDelay := 240000  ; 4 min
maxDelay := 295000  ; 4 min 55 sec

; === Global variables ===
timer := Random(minDelay, maxDelay)

; === Start the repeating timer ===
SetTimer(KeepAlive, timer)

; === Timer function ===
KeepAlive() {
    global endHour, minDelay, maxDelay, timer

    ; Exit if workday is over and Remote Desktop is not open
    if A_Hour >= endHour && !WinExist("Remote Desktop") {
        ExitApp
    }

    ; If Remote Desktop is open, activate and send a key
    if WinExist("Remote Desktop") {
        try {
            WinActivate()
            Sleep(500)

            fKeyNum := Random(13, 24)
            Send("{F" fKeyNum "}")

        } catch {
            ; Do nothing if WinActivate fails
        }
    }

    ; Show tray tip with key and delay
    TrayTip("KeepAlive", "Sent F" fKeyNum " after " Round(timer / 1000 / 60, 2) " min")

    ; Schedule next run with a new random delay
    timer := Random(minDelay, maxDelay)
    SetTimer(KeepAlive, 0) ; Disable current timer
    SetTimer(KeepAlive, timer)
}
