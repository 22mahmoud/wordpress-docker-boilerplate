<?php

/**
 * Customize S3 Uploads settings.
 *
 * - Modifies the S3 client parameters to use a custom endpoint and path-style requests.
 * - Sets attachments as private if the environment is 'production'.
 */

add_filter("s3_uploads_s3_client_params", function ($params) {
    $params['endpoint'] = S3_UPLOADS_ENDPOINT;
    $params["use_path_style_endpoint"] = true;
    $params['debug'] = false;

    return $params;
});

if (WP_ENV === 'production') {
    add_filter('s3_uploads_is_attachment_private', '__return_true');
}
