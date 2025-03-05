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


/// Creates an Image object containing a screen shot of a specific window

    private Image CaptureWindow(IntPtr handle)
    {
        // get te hDC of the target window
        IntPtr hdcSrc = User32.GetWindowDC(handle);
        // get the size
        User32.RECT windowRect = new User32.RECT();
        User32.GetWindowRect(handle, ref windowRect);

        Image img = CaptureWindowFromDC(handle, hdcSrc, windowRect);
        User32.ReleaseDC(handle, hdcSrc);
        return img;
    }
private static Image CaptureWindowFromDC(IntPtr handle, IntPtr hdcSrc, User32.RECT windowRect){
        // get the size
        int width = windowRect.right - windowRect.left;
        int height = windowRect.bottom - windowRect.top;
        // create a device context we can copy to
        IntPtr hdcDest = GDI32.CreateCompatibleDC(hdcSrc);
        // create a bitmap we can copy it to,
        // using GetDeviceCaps to get the width/height
        IntPtr hBitmap = GDI32.CreateCompatibleBitmap(hdcSrc, width, height);
        // select the bitmap object
        IntPtr hOld = GDI32.SelectObject(hdcDest, hBitmap);
        // bitblt over
        GDI32.BitBlt(hdcDest, 0, 0, width, height, hdcSrc, windowRect.left, windowRect.top, GDI32.SRCCOPY);
        // restore selection
        GDI32.SelectObject(hdcDest, hOld);
        // clean up
        GDI32.DeleteDC(hdcDest);
        // get a .NET image object for it
        Image img = Image.FromHbitmap(hBitmap);
        // free up the Bitmap object
        GDI32.DeleteObject(hBitmap);
        return img;
    }


public void CaptureActiveWindowToFile(string filename, ImageFormat format)
    {
        Image img = CaptureActiveWindow();
        img.Save(filename, format);
    }

    public void CaptureScreenToFile(string filename, ImageFormat format)
    {
        Image img = CaptureScreen();
        img.Save(filename, format);
    }

    static bool fullscreen = true;
    static String file = "screenshot.bmp";
    static System.Drawing.Imaging.ImageFormat format = System.Drawing.Imaging.ImageFormat.Bmp;
    static String windowTitle = "";
    static List<MonitorInfoWithHandle> _monitorInfos;

    static void parseArguments()
    {
        String[] arguments = Environment.GetCommandLineArgs();
        if (arguments.Length == 1)
        {
            printHelp();
            Environment.Exit(0);
        }
        if (arguments[1].ToLower().Equals("/h") || arguments[1].ToLower().Equals("/help"))
        {
            printHelp();
            Environment.Exit(0);
        }
        if (arguments[1].ToLower().Equals("/l") || arguments[1].ToLower().Equals("/list"))
        {
            PrintMonitorInfo();
            Environment.Exit(0);
        }

        file = arguments[1];
        Dictionary<String, System.Drawing.Imaging.ImageFormat> formats =
        new Dictionary<String, System.Drawing.Imaging.ImageFormat>();

        formats.Add("bmp", System.Drawing.Imaging.ImageFormat.Bmp);
        formats.Add("emf", System.Drawing.Imaging.ImageFormat.Emf);
        formats.Add("exif", System.Drawing.Imaging.ImageFormat.Exif);
        formats.Add("jpg", System.Drawing.Imaging.ImageFormat.Jpeg);
        formats.Add("jpeg", System.Drawing.Imaging.ImageFormat.Jpeg);
        formats.Add("gif", System.Drawing.Imaging.ImageFormat.Gif);
        formats.Add("png", System.Drawing.Imaging.ImageFormat.Png);
        formats.Add("tiff", System.Drawing.Imaging.ImageFormat.Tiff);
        formats.Add("wmf", System.Drawing.Imaging.ImageFormat.Wmf);


}