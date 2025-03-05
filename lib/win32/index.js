const exec = require('child_process').exec
const temp = require('temp')
const path = require('path')
const utils = require('../utils')
const fs = require('fs')
const os = require('os')

const {
  readAndUnlinkP,
  defaultAll
} = utils

function copyToTemp () {
  const tmpBat = path.join(os.tmpdir(), 'screenCapture', 'screenCapture_1.3.2.bat')
  const tmpManifest = path.join(os.tmpdir(), 'screenCapture', 'app.manifest')
  const includeBat = path.join(__dirname, 'screenCapture_1.3.2.bat').replace('app.asar', 'app.asar.unpacked')
  const includeManifest = path.join(__dirname, 'app.manifest').replace('app.asar', 'app.asar.unpacked')
  if (!fs.existsSync(tmpBat)) {
    const tmpDir = path.join(os.tmpdir(), 'screenCapture')
    if (!fs.existsSync(tmpDir)) {
      fs.mkdirSync(tmpDir)
    }
    const sourceData = {
      bat: fs.readFileSync(includeBat),
      manifest: fs.readFileSync(includeManifest)
    }
    fs.writeFileSync(tmpBat, sourceData.bat)
    fs.writeFileSync(tmpManifest, sourceData.manifest)
  }
  return tmpBat
}

function windowsSnapshot (options = {}) {
    return new Promise((resolve, reject) => {
      const displayName = options.screen
      const format = options.format || 'jpg'
      const tmpPath = temp.path({
        suffix: `.${format}`
      })
      const imgPath = path.resolve(options.filename || tmpPath)
  
      const displayChoice = displayName ? ` /d "${displayName}"` : ''
  
      const tmpBat = copyToTemp()
  
      exec('"' + tmpBat + '" "' + imgPath + '" ' + displayChoice, {
        cwd: path.join(os.tmpdir(), 'screenCapture'),
        windowsHide: true
      }, (err, stdout) => {
        if (err) {
          return reject(err)
        } else {
          if (options.filename) {
            resolve(imgPath)
          } else {
            readAndUnlinkP(tmpPath)
              .then(resolve)
              .catch(reject)
          }
        }
      })
    })
  }
  