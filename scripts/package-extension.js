import { execSync } from 'child_process';
import fs from 'fs';
import path from 'path';

const buildDir = path.resolve('build');
const zipFile = path.resolve(buildDir, 'pak-ludo-chrome-extension.zip');

if (fs.existsSync(zipFile)) {
  fs.unlinkSync(zipFile);
}

try {
  if (process.platform === 'win32') {
    execSync(`powershell -Command "Compress-Archive -Path '${buildDir}\\*' -DestinationPath '${zipFile}' -Force"`, {
      stdio: 'inherit',
    });
  } else {
    execSync(`cd "${buildDir}" && zip -r "${zipFile}" ./*`, {
      stdio: 'inherit',
    });
  }
  console.log(`\n🎉 Successfully packaged Chrome Extension to:\n${zipFile}\n`);
} catch (err) {
  console.error('Error packaging zip:', err);
  process.exit(1);
}
