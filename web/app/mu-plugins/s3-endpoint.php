<?php

add_filter("s3_uploads_s3_client_params", function ($params) {
    $params["endpoint"] = S3_UPLOADS_ENDPOINT;
    $params["use_path_style_endpoint"] = true;
    $params['debug'] = false;
    return $params;
});

add_filter('s3_uploads_is_attachment_private', '__return_true');
