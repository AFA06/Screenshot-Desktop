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

test('screenshot each display', t => {
    if (screenshot.availableDisplays) {
      return screenshot.availableDisplays().then(displays => {
        checkDisplays(t, displays);
  
        displays.forEach(display => {
          screenshot(display.id);
        });
      });
    } else {
      t.pass();
    }
  });
  
  test('screenshot to a file', t => {
    t.plan(1);
    const tmpName = temp.path({ suffix: '.jpg' });
    return screenshot({ filename: tmpName }).then(() => {
      t.truthy(existsSync(tmpName));
      unlinkSync(tmpName);  // Clean up after test
    });
  });
  
  test('screenshot to a specific folder', t => {
    t.plan(1);
    const tmpName = `${screenshotFolder}/screenshot.jpg`;  // Use the correct path
    console.log('Saving screenshot to:', tmpName);
  
    return screenshot({ filename: tmpName }).then(() => {
      console.log('File exists:', existsSync(tmpName));
      t.truthy(existsSync(tmpName));  // Check if the screenshot was saved
      unlinkSync(tmpName);  // Clean up after test
    }).catch(err => {
      console.error('Error taking screenshot:', err);
    });
  }); 

test('parse display output', t => {
    if (screenshot.EXAMPLE_DISPLAYS_OUTPUT && screenshot.parseDisplaysOutput) {
      const disps = screenshot.parseDisplaysOutput(screenshot.EXAMPLE_DISPLAYS_OUTPUT);
      checkDisplays(t, disps);
    }
  });
  
  