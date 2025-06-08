<?php

declare(strict_types=1);

namespace WP\NextGenImagePlugin;

class Plugin
{
    private static Plugin $instance;

    private function __construct()
    {
        $this->enqueueFilters();
    }

    private function enqueueFilters(): void
    {
        add_filter('wp_handle_upload', [$this, 'wpHandleUpload'], 10, 1);
        add_filter('wp_generate_attachment_metadata', [$this, 'wpGenerateAttachmentMetadata'], 10, 2);
        add_filter('wp_content_img_tag', [$this, 'wpContentImageTag'], 10, 3);
    }

    /**
     * Filter the file array after upload.
     *
     * @param array{file: string, url: string, type: string} $file
     * @return array{file: string, url: string, type: string}
     */
    public function wpHandleUpload(array $file): array
    {
        return $file;
    }


    /**
     * Filters the generated attachment meta data.
     *
     * @param array<int, mixed> $metadata
     * @param int $attachmentId
     * @return array<int, mixed>
     */
    public function wpGenerateAttachmentMetadata(array $metadata, int $attachmentId): array
    {
        return $metadata;
    }

    /**
     * Filters an img tag within the content for a given context.
     *
     * @param string $image
     * @param string $context
     * @param int $id
     * @return string
     */
    public function wpContentImageTag(string $image, string $context, int $id): string
    {
        return $image;
    }

    public static function init(): Plugin
    {
        return self::$instance ??= new self();
    }
}
