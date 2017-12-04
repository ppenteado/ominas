pg\_ring\_sector\_oblique.pro
===================================================================================================



























pg\_ring\_sector\_oblique
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_ring_sector_oblique(cd=cd, dkx=dkx, gd=gd, lon=lon, sample=sample, win_num=win_num, restore=restore, slope=slope, p0=p0, xor_graphics=xor_graphics, color=color, silent=silent, nodsk=nodsk)



Description
-----------
	Allows the user to select a ring sector by clicking and dragging.
	The top and bottom of the sector are defined along lines of constant
	radius, while the sides are perpendicular to the image-projected
	radial direction.









Returns
-------

      POINT containing points on the sector outline.  The point
      spacing is determined by the sample keyword.  The POINT object
      also contains the disk coordinate for each point and the user fields
      'nrad' and 'nlon' giving the number of points in radius and longitude.

 KNOWN BUGS:
	The sector flips when it hits zero azimuth rather than retaining a
	consistent sense.


 ORIGINAL AUTHOR : J. Spitale ; 5/2005









Keywords
--------


.. _cd
- cd *in* 

    Camera descriptor.




.. _dkx
- dkx *in* 

    Disk descriptor describing the ring.




.. _gd
- gd *in* 

    Generic descriptor containnig the above descriptors.




.. _lon
- lon 



.. _sample
- sample *in* 

    Grid sampling, default is 1.




.. _win\_num
- win\_num *in* 

    Window number of IDL graphics window in which to select
                   box, default is current window.




.. _restore
- restore *in* 

    Do not leave the box in the image.




.. _slope
- slope *in* 

    This keyword allows the longitude to vary from the
                   perpendicular direction as a function of radius as:
                   lon = slope*(rad - rad0).




.. _p0
- p0 *in* 

    First corner of box.  If set, then the routine immediately
                   begins to drag from that point until a button is released.




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




.. _nodsk
- nodsk *in* 

    If set, image points will not be included in the output
                   POINT.























