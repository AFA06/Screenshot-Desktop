// 2>nul||@goto :batch
/*
:batch
@echo off
setlocal enableDelayedExpansion

:: find csc.exe
set "csc="
for /r "%SystemRoot%\Microsoft.NET\Framework\" %%# in ("*csc.exe") do  set "csc=%%#"

if not exist "%csc%" (
   echo no .net framework installed
   exit /b 10
)

if not exist "%~n0.exe" (
   call %csc% /nologo /r:"Microsoft.VisualBasic.dll" /win32manifest:"app.manifest" /out:"%~n0.exe" "%~dpsfnx0" || (
      exit /b !errorlevel!
   )
)
%~n0.exe %*
endlocal & exit /b %errorlevel%

*/

// reference
// https://gallery.technet.microsoft.com/scriptcenter/eeff544a-f690-4f6b-a586-11eea6fc5eb8

using System;
using System.Runtime.InteropServices;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;
using Microsoft.VisualBasic;

/// Provides functions to capture the entire screen, or a particular window, and save it to a file.

public class ScreenCapture
{

    static String deviceName = "";
    static Image capturedImage = null;

    /// Creates an Image object containing a screen shot the active window

    public Image CaptureActiveWindow()
    {
        return CaptureWindow(User32.GetForegroundWindow());
    }

    /// Creates an Image object containing a screen shot of the entire desktop

    public Image CaptureScreen()
    {
        if (!deviceName.Equals(""))
        {
            CaptureSpecificWindow();
            if (capturedImage != null)
            {
                return capturedImage;
            }
            Console.WriteLine("Unable to capture image... using main display");
        }
        return CaptureWindow(User32.GetDesktopWindow());
    }
}