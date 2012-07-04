Newton's Revenge
================

A platformer for the #SitoJAM game jam, developed by Jorge Diz and Rodrigo Álvarez in June 2012, using Lua and the Löve framework.

Topics for the competition, as chosen by Sebastián Rodríguez, were `ninjas` and `gravity`. Participants also decided to add a mention to the `3x2` concept.


How to run
----------

Install the [Löve framework](https://love2d.org/) and then use it to run the `.love` file inside the `dist` folder. For a while, you may find ready-to-play distributables for OSX and Windows at [my homepage](http://diz.es/newtons/).

How to play
-----------

Use the keyboard arrows. I think it's better to discover the mechanics by playing with it, but if you like spoilers, here they go:

* The objective is to survive the longest possible.
* Move the ninja to avoid the apples. They are zombie apples and they kill you. You have three lives.
* Objects will phase to the other side when crossing the screen limits, except apples, that die when do so in the lowest platform (the ninja will phase normally)

Sure you want to go on reading?

* The ninja can walk on any horizontal surface. That includes the ceiling. Try it.
* Prisoners will raise your prisoner counter (duh). Think of it as an score.
* Slowpokes will slow down the apples (for a while)
* Katanas turn you into an apple-killing supersaiyan (for a while too).
* Trollfaces... are unreliable on their effects ;)

And there's another special thing that I won't tell. Less reading, more playing.

How it was done
---------------

As mentioned, we used the [Löve framework](https://love2d.org/), and the [hump](http://vrld.github.com/hump/), [HardonCollider](http://vrld.github.com/HardonCollider/) and [AdvTiledLoader](https://github.com/Kadoba/Advanced-Tiled-Loader) libraries (as well as [Tiled](http://www.mapeditor.org/) for the map).

We used graphical and musical assets from the following sources:

* Map made with the [tileset from Silveira Neto](http://silveiraneto.net/2009/07/31/my-free-tileset-version-10/)
* Prisoner sprite from [Metal Slug 2](http://en.wikipedia.org/wiki/Metal_Slug)
* [Apple sprite](http://applepoo.deviantart.com/art/Apple-Sprite-90448767) by ApplePoo
* Slowpoke music from Propellerheads (["Spybreak! (Short one)"](http://en.wikipedia.org/wiki/Spybreak!))
* New life soundbite taken from the [Super Mario games](http://en.wikipedia.org/wiki/Super_Mario)
* Prisoner soundbite taken from the [Wario games](http://en.wikipedia.org/wiki/Wario_Series)

Unfortunately we lost track of the sources for other elements of the game, if you recognize them, please let us know to update this list!

A big thanks to all the people writing diverse documentations and the folks at the Löve forums, which we consulted thoroughly. Special shot out to [Headchant](http://www.headchant.com/), whose [tutorial](http://www.headchant.com/2012/01/06/tutorial-creating-a-platformer-with-love-part-1/) gave us a direction for our first steps.
