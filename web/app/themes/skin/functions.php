<?php

function enqueue_assets(): void
{
    wp_enqueue_script_module('vite-client', 'http://localhost:5173/@vite/client', array(), null);
    wp_enqueue_script_module(
        'mawi-theme-scripts',
        'http://localhost:5173/resources/js/app.ts',
        array( 'vite-client' ),
        null
    );
}

add_action('wp_enqueue_scripts', 'enqueue_assets');
