import react from '@vitejs/plugin-react';
import * as path from 'path';
import { defineConfig } from 'vite';

export default defineConfig(({ command }: any) => {
  const isDev = command !== "bulid";
  if (isDev) {
    // Terminate the watcher when Phoenix quits
    process.stdin.on("close", () => {
      process.exit(0);
    });

    process.stdin.resume();
  }
  return {
    resolve: {
      alias:{
        "$": path.resolve(__dirname, "./src"),
        "$sass": path.resolve(__dirname, "./src/sass"),
        "$queries": path.resolve(__dirname, "./src/operations/queries"),
        "$components": path.resolve(__dirname, "./src/components"),
        "$pages": path.resolve(__dirname, "./src/pages"),
      }
    },
    publicDir: "static",
    plugins: [react()],
    build: {
      target: "esnext", // build for recent browsers
      outDir: "../priv/static", // emit assets to priv/static
      emptyOutDir: true,
      sourcemap: isDev,
      manifest: false,
      rollupOptions: {
        input: {
          main: "src/main.tsx"
        },
        output: {
          entryFileNames: "assets/[name].js", // remove hash
          chunkFileNames: "assets/[name].js",
          assetFileNames: "assets/[name][extname]"
        }
      },
    },
  }
})
