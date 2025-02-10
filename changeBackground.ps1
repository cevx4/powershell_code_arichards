$WallpaperPath = "C:\Windows\Web\Wallpaper\ThemeC\img31.jpg"

# Set the wallpaper
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $WallpaperPath

# Use ActiveDesktop to force update
$Desktop = New-Object -ComObject Shell.Application
$Desktop.MinimizeAll()
Start-Sleep -Seconds 1
$Desktop.UndoMinimizeAll()

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@ -Language CSharp

[Wallpaper]::SystemParametersInfo(0x14, 0, $WallpaperPath, 0x01 -bor 0x02)

Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value 2
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value 0

Stop-Process -Name explorer -Force
Start-Process explorer
