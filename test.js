const test = require('ava');
const { existsSync, unlinkSync, mkdirSync } = require('fs');
const temp = require('temp');
const screenshot = require('.');

// Ensure the screenshots folder exists
const screenshotFolder = '/Users/macbook/Documents/Screenshoot_Capture/screenshot-desktop';
if (!existsSync(screenshotFolder)) {
  mkdirSync(screenshotFolder, { recursive: true });
}

test.before(async () => {
  return screenshot.listDisplays().then(displays => {
    console.log('Displays:', JSON.stringify(displays, null, 2), '\n');
  });
});

test('screenshot', t => {
  t.plan(1);
  return screenshot().then(img => {
    t.truthy(Buffer.isBuffer(img));
  });
});
// here we go 

function checkDisplays(t, displays) {
  t.truthy(Array.isArray(displays));
  displays.forEach(disp => {
    t.truthy(disp.name);
    t.truthy(disp.id !== undefined);
  });
}
