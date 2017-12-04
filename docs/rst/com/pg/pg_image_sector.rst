pg\_image\_sector.pro
===================================================================================================



























pg\_image\_sector
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_image_sector(sample=sample, win_num=win_num, width=width, restore=restore, p0=p0, p1=p1, xor_graphics=xor_graphics, color=color, silent=silent, corners=corners)



Description
-----------
	Allows the user to select a rectangular image region, with an
	arbitrary tilt, by clicking and dragging.  A rectangle is selected
	using the left mouse button and a line of zero width is selected
	using the right moise button.









Returns
-------

      POINT containing points on the sector outline.  The point
      spacing is determined by the sample keyword.

 ORIGINAL AUTHOR : J. Spitale ; 6/2005









Keywords
--------


.. _sample
- sample *in* 

    Pixel grid sampling to use instead of 1.




.. _win\_num
- win\_num *in* 

    Window number of IDL graphics window in which to select
                   box, default is current window.




.. _width
- width *in* 

    Width of box instead of letting the user select.




.. _restore
- restore *in* 

    Do not leave the box in the image.




.. _p0
- p0 *in* 

    First corner of box.  If set, then the routine immediately
                   begins to drag from that point until a button is released.




.. _p1
- p1 *in* 

    Endpoint.  If given, p0 must also be given and is taken
                   as the starting point for a line along which to scan.
                   In this case, the user does not select the box manually.
                   Scan width is one pixel unless 'width' is specified,
                   and is centered on the line from p0 to p1.




.. _xor\_graphics
- xor\_graphics *in* 

    If set, the sector outline is drawn and erased using xor
                   graphics instead of a pixmap.




.. _color
- color *in* 

    Color to use for rectangle, default is !color.




.. _silent
- silent *in* 

    If set, messages are suppressed.





.. _corners
- corners *in* 

    If set, then p0 and p1 are taken as the corners of
                   the box, and the user is not prompted to select one.























