<?php

/**
 * Plugin Name:       Blocks
 * Description:       Example block scaffolded with Create Block tool.
 * Version:           0.1.0
 * Requires at least: 6.7
 * Requires PHP:      7.4
 * Author:            The WordPress Contributors
 * License:           GPL-2.0-or-later
 * License URI:       https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain:       blocks
 *
 * @package Wp
 */

if (!defined('ABSPATH')) {
    exit;
}

function wp_blocks_block_init()
{
    if (function_exists('wp_register_block_types_from_metadata_collection')) {
        wp_register_block_types_from_metadata_collection(__DIR__ . '/build', __DIR__ . '/build/blocks-manifest.php');
        return;
    }

    if (function_exists('wp_register_block_metadata_collection')) {
        wp_register_block_metadata_collection(__DIR__ . '/build', __DIR__ . '/build/blocks-manifest.php');
    }

    $manifestData = require __DIR__ . '/build/blocks-manifest.php';
    foreach (array_keys($manifestData) as $blockType) {
        register_block_type(__DIR__ . "/build/{$blockType}");
    }
}

add_action('init', 'wp_blocks_block_init');
