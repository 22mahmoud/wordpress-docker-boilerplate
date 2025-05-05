import fs from "node:fs";
import path from "node:path";
import laravel from "laravel-vite-plugin";
import { defineConfig } from "vite";

export default defineConfig({
  plugins: [laravel({ input: ["./resources/js/app.ts"] })],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "resources"),
    },
  },
  build: {
    assetsDir: ".",
    outDir: "dist",
    emptyOutDir: true,
  },
  server: {
    host: "0.0.0.0",
    port: 5173,
    strictPort: true,

    // https: {
    //   key: fs.readFileSync("/etc/ssl/certs/dev.local-key.pem"),
    //   cert: fs.readFileSync("/etc/ssl/certs/dev.local.pem"),
    // },

    // hmr: {
    //   host: "dev.local",
    // },
    hmr: {
      host: "localhost",
      port: 5173,
      protocol: "ws",
    },
    cors: {
      origin: "*",
    },
  },
});
