<?php

declare(strict_types=1);

namespace WP\Skin\Includes;

class Vite
{
    private string $distUrl;
    private string $manifestPath;

    public function __construct(
        private string $entry,
        private string $distPath,
        private string $host = "http://localhost:5173",
    ) {
        $this->distUrl = sprintf("%s/%s", get_template_directory_uri(), $this->distPath);
        $this->manifestPath = sprintf(
            "%s/%s/.vite/manifest.json",
            get_template_directory(),
            $this->distPath
        );
    }

    public function enqueueVite(): void
    {
        WP_ENV === 'development'
            ? $this->enqueueDevVite()
            : $this->enqueueProdVite();
    }

    private function getDevClientURI(): string
    {
        return sprintf('%s/@vite/client', $this->host);
    }

    private function getDevScriptURI(): string
    {
        return sprintf('%s/%s', $this->host, $this->entry);
    }

    private function enqueueDevVite(): void
    {
        wp_enqueue_script_module('vite-client', $this->getDevClientURI(), [], null);
        wp_enqueue_script_module('skin-theme-scripts', $this->getDevScriptURI(), [], null);
    }

    private function enqueueProdVite(): void
    {
        if (!file_exists($this->manifestPath)) {
            error_log('Vite manifest file not found: ' . $this->manifestPath);
            return ;
        }

        $manifestJson = file_get_contents($this->manifestPath);
        if (!$manifestJson) {
            error_log('Failed to read Vite manifest file: ' . $this->manifestPath);
            return;
        }


        $manifest = json_decode($manifestJson, true);

        if (!isset($manifest[$this->entry])) {
            error_log('Invalid or missing entry in Vite manifest: ' . $this->entry);
            return;
        }

        $data = $manifest[$this->entry];

        foreach ($data['css'] ?? [] as $index => $cssFile) {
            wp_enqueue_style(
                'skin-theme-style-' . $index,
                "{$this->distUrl}/{$cssFile}",
                [],
                null
            );
        }

        if (!empty($data['file'])) {
            wp_enqueue_script_module(
                'skin-theme-scripts',
                "{$this->distUrl}/{$data['file']}",
                [],
                null
            );
        }

        foreach ($data['imports'] ?? [] as $import) {
            if (!empty($manifest[$import]['file'])) {
                wp_enqueue_script_module(
                    'skin-theme-import-' . md5($import),
                    "{$this->distUrl}/{$manifest[$import]['file']}",
                    [],
                    null
                );
            }
        }
    }
}
