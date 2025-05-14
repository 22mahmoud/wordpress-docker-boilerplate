<?php get_header() ?>

<div class="text-xl">Mahmoud Ashraf!</div>

<div x-data="{ count: 0 }">
    <button x-on:click="count++">Increment</button>
    <span x-text="count"></span>
</div>

<?php if (have_posts()) : ?>
    <?php while (have_posts()) : ?>
        <?php the_post(); ?>
        <div> <?php the_title('<h1>'); ?> </div>
        <div> <?php the_content(); ?> </div>
    <?php endwhile ?>
<?php else : ?>
    <article>
        <p>Nothing to see.</p>
    </article>
<?php endif ?>

<?php get_footer() ?>
