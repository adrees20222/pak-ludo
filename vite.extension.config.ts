import { defineConfig, normalizePath } from 'vite';
import react from '@vitejs/plugin-react';
import svgr from 'vite-plugin-svgr';
import licenses from 'rollup-plugin-license';
import { viteStaticCopy } from 'vite-plugin-static-copy';
import { version, license } from './package.json';
import path from 'node:path';

export default defineConfig({
  base: './',
  css: {
    modules: {
      localsConvention: 'camelCaseOnly',
    },
  },
  define: {
    __PAK_LUDO_VERSION__: JSON.stringify(version),
    __PAK_LUDO_LICENSE__: JSON.stringify(license),
  },
  plugins: [
    react(),
    svgr({
      svgrOptions: {
        plugins: ['@svgr/plugin-svgo', '@svgr/plugin-jsx'],
        svgoConfig: {
          plugins: ['preset-default'],
        },
      },
    }),
    viteStaticCopy({
      targets: [
        {
          src: normalizePath(path.resolve(__dirname, 'src/extension/manifest.json')),
          dest: normalizePath(path.resolve(__dirname, 'build')),
        },
        {
          src: normalizePath(path.resolve(__dirname, 'src/extension/background.js')),
          dest: normalizePath(path.resolve(__dirname, 'build')),
        },
        {
          src: normalizePath(path.resolve(__dirname, 'public/icons/extension/*')),
          dest: normalizePath(path.resolve(__dirname, 'build/icons/extension')),
        },
      ],
    }),
  ],
  build: {
    outDir: 'build',
    emptyOutDir: true,
    sourcemap: false,
    rollupOptions: {
      input: {
        main: path.resolve(__dirname, 'index.html'),
      },
    },
  },
});
