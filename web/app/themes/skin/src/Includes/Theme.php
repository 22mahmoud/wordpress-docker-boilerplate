<?php

namespace WP\Skin\Includes;

class Theme
{
    private static ?Theme $instance = null;
    private ?Vite $vite = null;

    private function __construct()
    {
        $this->initVite();
        add_action('wp_enqueue_scripts', [$this, 'enqueueAssets']);
    }

    public function enqueueAssets(): void
    {
        $this->vite->enqueueVite();
    }

    private function initVite(): void
    {
        $this->vite = new Vite(
            distPath: 'dist',
            entry: "resources/js/app.ts",
        );
    }

    public static function init(): Theme
    {
        self::$instance ??= new self();
        return self::$instance;
    }
}
