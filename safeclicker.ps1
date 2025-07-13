# ──[ ASCII Art Banner ]───────────────────────────────────────────────
$asciiArt = @"
****************************************************************************************************
 ________  ________  ________ _______                                 
|\   ____\|\   __  \|\  _____\\  ___ \                                
\ \  \___|\ \  \|\  \ \  \__/\ \   __/|                               
 \ \_____  \ \   __  \ \   __\\ \  \_|/__                             
  \|____|\  \ \  \ \  \ \  \_| \ \  \_|\ \                            
    ____\_\  \ \__\ \__\ \__\   \ \_______\                           
   |\_________\|__|\|__|\|__|    \|_______|                           
   \|_________|                                                       
                                                                      
 ________  ___       ___  ________  ___  __    _______   ________     
|\   ____\|\  \     |\  \|\   ____\|\  \|\  \ |\  ___ \ |\   __  \    
\ \  \___|\ \  \    \ \  \ \  \___|\ \  \/  /|\ \   __/|\ \  \|\  \   
 \ \  \    \ \  \    \ \  \ \  \    \ \   ___  \ \  \_|/_\ \   _  _\  
  \ \  \____\ \  \____\ \  \ \  \____\ \  \\ \  \ \  \_|\ \ \  \\  \| 
   \ \_______\ \_______\ \__\ \_______\ \__\\ \__\ \_______\ \__\\ _\ 
    \|_______|\|_______|\|__|\|_______|\|__| \|__|\|_______|\|__|\|__|
"@

Write-Host $asciiArt
Write-Host "`Welcome to SafeClicker click safely and not get banned`n"
Write-Host "`nPress F2 to toggle click multiplier ON/OFF. Press Ctrl+C to exit.`n"

# ──[ Clicker Code ]───────────────────────────────────────────────────

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class UserInput {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);

    [DllImport("user32.dll", CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
    public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);

    public const int MOUSEEVENTF_LEFTDOWN = 0x02;
    public const int MOUSEEVENTF_LEFTUP = 0x04;

    public const int VK_F2 = 0x71;
    public const int VK_LBUTTON = 0x01;

    public static bool IsKeyPressed(int vKey) {
        return (GetAsyncKeyState(vKey) & 0x8000) != 0;
    }

    public static void Click() {
        mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
        mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
    }
}
"@

$multiplier = 3  # Number of clicks per physical click
$running = $false
$lastF2State = $false
$lastLButtonState = $false

while ($true) {
    Start-Sleep -Milliseconds 10

    $f2Pressed = [UserInput]::IsKeyPressed([UserInput]::VK_F2)
    $lButtonPressed = [UserInput]::IsKeyPressed([UserInput]::VK_LBUTTON)

    if ($f2Pressed -and -not $lastF2State) {
        $running = -not $running
        if ($running) {
            Write-Host "SafeClicker's clickboost is ON"
        } else {
            Write-Host "SafeClicker's clickboost is OFF"
        }
    }
    $lastF2State = $f2Pressed

    if ($running -and $lButtonPressed -and -not $lastLButtonState) {
        for ($i = 1; $i -lt $multiplier; $i++) {
            [UserInput]::Click()
            Start-Sleep -Milliseconds 20
        }
    }

    $lastLButtonState = $lButtonPressed
}
