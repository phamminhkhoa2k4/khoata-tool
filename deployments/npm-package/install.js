const fs = require('fs');
const path = require('path');
const https = require('https');

// Configuration
const REPO = 'phamminhkhoa2k4/khoata-tool';
const BINARY_NAME = 'ag-khoata';
const VERSION = 'latest'; // Or specific version like 'v1.0.0'

// Detect OS and Architecture
const platform = process.platform;
const arch = process.arch;

let osName = '';
let archName = '';
let ext = '';

if (platform === 'win32') {
  osName = 'windows';
  ext = '.exe';
} else if (platform === 'linux') {
  osName = 'linux';
} else if (platform === 'darwin') {
  osName = 'darwin';
} else {
  console.error(`Unsupported platform: ${platform}`);
  process.exit(1);
}

if (arch === 'x64') {
  archName = 'amd64';
} else if (arch === 'arm64') {
  archName = 'arm64';
} else {
  console.error(`Unsupported architecture: ${arch}`);
  process.exit(1);
}

const fileName = `${BINARY_NAME}-${osName}-${archName}${ext}`;
const downloadUrl = `https://github.com/${REPO}/releases/${VERSION === 'latest' ? 'latest/download' : 'download/' + VERSION}/${fileName}`;

const binDir = path.join(__dirname, 'bin');
// We save it always as 'ag-khoata-bin.exe' or 'ag-khoata-bin' to be called by cli.js
const targetName = `ag-khoata-bin${ext}`;
const binPath = path.join(binDir, targetName);

// Ensure bin directory exists
if (!fs.existsSync(binDir)) {
  fs.mkdirSync(binDir);
}

console.log(`Downloading ${BINARY_NAME} for ${osName}/${archName}...`);
console.log(`URL: ${downloadUrl}`);

const file = fs.createWriteStream(binPath);

function followRedirects(url, dest, callback) {
    https.get(url, (response) => {
        if (response.statusCode >= 300 && response.statusCode < 400 && response.headers.location) {
            followRedirects(response.headers.location, dest, callback);
        } else if (response.statusCode !== 200) {
            callback(new Error(`Failed to download binary. Status code: ${response.statusCode}`));
        } else {
            response.pipe(dest);
            dest.on('finish', () => {
                dest.close(callback);
            });
        }
    }).on('error', (err) => {
        fs.unlink(binPath, () => {}); // Delete the file async. (But we don't check for failure)
        callback(err);
    });
}

followRedirects(downloadUrl, file, (err) => {
    if (err) {
        console.error(`Error downloading binary: ${err.message}`);
        console.error(`Please ensure a release exists on GitHub.`);
        if (fs.existsSync(binPath)) fs.unlinkSync(binPath);
        process.exit(1);
    }
    
    // Make executable on unix
    if (platform !== 'win32') {
        fs.chmodSync(binPath, 0o755);
    }
    
    console.log(`Successfully installed ${BINARY_NAME}!`);
});
