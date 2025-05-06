import '../css/app.css';

import Alpine from "alpinejs";

declare global {
  interface Window {
    Alpine: typeof Alpine;
  }
}

console.log("Hello, Wordpress!");
window.Alpine = Alpine;

Alpine.start();
