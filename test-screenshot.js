const test = require('ava');
const screenshot = require('.');
const { existsSync } = require('fs');
const { join } = require('path');

const filePath = join(__dirname, 'test-screenshot.jpg');

test('screenshot to file', async t => {
  await screenshot({ filename: filePath })
    .then(() => {
      console.log('Screenshot saved at:', filePath);
      console.log('File exists:', existsSync(filePath));
      t.truthy(existsSync(filePath));  // Check if the screenshot was saved
    })
    .catch(err => {
      console.error('Error taking screenshot:', err);
      t.fail('Screenshot failed'); // Fail the test if an error occurs
    });
});