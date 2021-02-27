# maternitypants

Maternitypants is a jquery plugin written in coffeescript that gives applications edit-in-place functionality, 
but with an expandable textarea that grows as you type.

I found this useful as I was creating an experimental web app that enabled customizable "sticky notes" alongside of song lyrics.

Note that this is quite out of date (in large part because of the wonderful advances in javascript since 2012!), but am leaving it up in case anyone finds it useful.

## Technical Inspiration

I was using the jeditable (https://github.com/tuupola/jquery_jeditable) plugin for one of my projects, but often
found myself needing more space in my inputs/textareas for users to fill out their responses.  I attempted to use 
ExpandingTextareas (https://github.com/bgrins/ExpandingTextareas) in combination with jeditable, but the marriage 
was a tenuous one.  Since I didn't need a lot of the extra (but great!) functionality that jeditable provides, I 
decided to build my own jquery plugin to arrange a better marriage.

## Name inspiration

My lovely (and then very pregnant) wife

## Notes

* Not very well tested yet (see issues list)
* Expands to take up 100% of height and width of surrounding div, so set your parent height/widths accordingly
* Doesn't deal with textarea padding that well just yet
* Doesn't include buttons for save/cancel like jeditable (I didn't need them)
* Doesn't allow post back to server on submit (I didn't need it)

## Thanks

Many thinks to @tuupola and @bgrins, which I based this plugin's functionality and code off of, to @neilj whose 
alistapart article (http://www.alistapart.com/articles/expanding-text-areas-made-elegant/) made this plugin 
(or at least half of it) possible, and @minijs, whose code helped me set up a jquery plugin in coffeescript 
(though, I later found his boilerplate https://github.com/miniJs/miniBoilerplate that's even better).

