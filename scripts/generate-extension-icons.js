import sharp from 'sharp';
import fs from 'fs';
import path from 'path';

const sourceIcon = path.resolve('public/icons/favicon.png');
const outDir = path.resolve('public/icons/extension');

if (!fs.existsSync(outDir)) {
  fs.mkdirSync(outDir, { recursive: true });
}

const sizes = [16, 32, 48, 128];

async function generate() {
  for (const size of sizes) {
    const dest = path.join(outDir, `icon-${size}.png`);
    await sharp(sourceIcon)
      .resize(size, size)
      .png()
      .toFile(dest);
    console.log(`Generated ${dest} (${size}x${size})`);
  }
}

generate().catch(err => {
  console.error(err);
  process.exit(1);
});
