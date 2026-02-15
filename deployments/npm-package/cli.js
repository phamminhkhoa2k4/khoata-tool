#!/usr/bin/env node

const { spawn } = require('child_process');
const path = require('path');

const platform = process.platform;
const ext = platform === 'win32' ? '.exe' : '';
const binName = `ag-khoata-bin${ext}`;
const binPath = path.join(__dirname, 'bin', binName);

const args = process.argv.slice(2);

const child = spawn(binPath, args, { stdio: 'inherit' });

child.on('close', (code) => {
  process.exit(code);
});

child.on('error', (err) => {
  console.error('Failed to start subprocess:', err);
  process.exit(1);
});
