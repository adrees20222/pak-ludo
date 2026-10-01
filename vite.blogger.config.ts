import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import svgr from 'vite-plugin-svgr';
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
  ],
  build: {
    outDir: 'web/dist',
    emptyOutDir: true,
    assetsInlineLimit: 100000000, // Inlines all SVGs, PNGs, fonts, gifs as base64 Data URIs
    sourcemap: false,
    rollupOptions: {
      input: {
        main: path.resolve(__dirname, 'index.html'),
      },
      output: {
        manualChunks: undefined, // Single output bundle
        inlineDynamicImports: true,
      },
    },
  },
});
