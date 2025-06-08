<?php

namespace WP\Skin\Includes;

class Theme
{
    private static Theme $instance;
    private Vite $vite;

    private function __construct()
    {
        $this->initVite();
        add_action('wp_enqueue_scripts', [$this, 'enqueueAssets']);
        add_action('admin_head', [$this, 'adminStyleOverride']);
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

    public function adminStyleOverride(): void
    {
        echo '<style>#rediscache .sidebar-column { display: none !important; }</style>';
    }

    public static function init(): Theme
    {
        return self::$instance ??= new self();
    }
}
