<?php ?>
<!doctype html>
<html lang="<?php language_attributes(); ?>">
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>
    <div class="text-xl">Mahmoud Ashraf!</div>

    <div x-data="{ count: 0 }">
        <button x-on:click="count++">Increment</button>
        <span x-text="count"></span>
    </div>

    <?php while (have_posts()) { ?>
        <?php the_post(); ?>
        <div> <?php the_title(); ?> </div>
        <div> <?php the_content(); ?> </div>
    <?php } ?>

    <?php wp_footer(); ?>
</body>

</html>
