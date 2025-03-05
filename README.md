# Screenshot Capturer

A simple, promise-based Node.js library for capturing screenshots of your local machine. It supports multiple platforms and outputs screenshots as JPG (default) or PNG.

## Features

- **Multi/Cross Platform Support**
  - **Linux:** Requires ImageMagick. Install with `apt-get install imagemagick`.
  - **macOS:** No dependencies required.
  - **Windows:** No dependencies required.
  
- **Promise-Based API:** Works with `.then()` and `.catch()` for asynchronous execution.
- **Output Formats:** By default, screenshots are saved in JPG format, but PNG is also supported.

## Install

To install this package, run:

```bash
npm install --save screenshot-desktop



Usage

Capture a Screenshot (Default Format: JPG)

const screenshot = require('screenshot-desktop');

screenshot().then((img) => {
  // img: Buffer containing JPG screenshot
  // You can save, process, or display this image
}).catch((err) => {
  console.error('Error capturing screenshot:', err);
});


Capture a Screenshot in PNG Format

const screenshot = require('screenshot-desktop');

screenshot({ format: 'png' }).then((img) => {
  // img: Buffer containing PNG screenshot
}).catch((err) => {
  console.error('Error capturing screenshot:', err);
});


Capture a Screenshot from a Specific Display

const screenshot = require('screenshot-desktop');

screenshot.listDisplays().then((displays) => {
  // displays: [{ id, name }, { id, name }]
  screenshot({ screen: displays[displays.length - 1].id })
    .then((img) => {
      // img: Buffer of screenshot from the last display
    });
});

Capture Screenshots from All Displays

const screenshot = require('screenshot-desktop');

screenshot.all().then((imgs) => {
  // imgs: an array of Buffers, one for each screen
});

Save Screenshot to a File

const screenshot = require('screenshot-desktop');

screenshot({ filename: 'screenshot.jpg' }).then((imgPath) => {
  // imgPath: Absolute path to the saved screenshot file
  console.log('Screenshot saved at:', imgPath);
}).catch((err) => {
  console.error('Error saving screenshot:', err);
});


Save Screenshot to a Specific Location

const screenshot = require('screenshot-desktop');

// Absolute path to save the screenshot
screenshot({ filename: '/Users/yourname/Desktop/screenshot.png' }).then((imgPath) => {
  console.log('Screenshot saved at:', imgPath);
});


Screenshot Options

filename (Optional): Path (absolute or relative) to save the screenshot file.
format (Optional): Output format. Valid values are png or jpg. Default is jpg.
screen (Optional): Select a specific screen (by id) for the screenshot (works with multiple displays).
linuxLibrary (Optional): Only for Linux. Choose between scrot or imagemagick as the library to use for capturing screenshots. Note that scrot does not support format or screen selection.


Contributing
If you want to contribute to this project, feel free to fork it, make improvements, and submit pull requests.
