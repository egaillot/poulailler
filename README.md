This is a browser-revival of Nintendo's 
famous Game & Watch Mickey Mouse.

Copyright 2012 Emmanuel Gaillot (emmanuel.gaillot@gmail.com)

How to play
===========

* Clone the project.
* Open the `index.html` file in your browser.

Your goal is to catch the eggs that are about to fall 
before they do, by bringing the basket right under them.
To do so, you may press keys `e`, `c`, `i`, and `n`.  If
you don't catch a falling egg, it breaks, and you will get
penalties for that.  When Minnie is displayed on screen,
you will get only one missed point.  When she is not, you
will get two missed points.  The game is over when you have
six or more missed points.

You should not need to download additional libraries.  All 
dependencies are included in the `lib` directory of the 
project.

License
=======

Poulailler is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Poulailler is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Poulailler.  If not, see <http://www.gnu.org/licenses/>.

Acknowledgements
================

The game mechanics are directly inspired by Nintendo's Game & Watch
called Mickey Mouse.  I wanted to see if I was capable of programming it
in JavaScript.  Then I figured out it might be useful to others to see
how I did it.  In such, this project is meant for educational purpose only.

The program is written in [CoffeeScript](http://coffeescript.org), HTML 
and CSS. It uses [jQuery](http://jquery.com).  Tests are writen using the 
[Jasmine framework](http://pivotal.github.com/jasmine).

Most of what I know in JavaScript and CoffeeScript, I know from [Jonathan
Perret](https://github.com/jonathanperret).  Thank you, Jonathan.
