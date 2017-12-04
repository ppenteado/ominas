pg\_limb\_sector.pro
===================================================================================================



























pg\_limb\_sector
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_limb_sector(cd=cd, gbx=gbx, gd=gd, lon=lon, sample=sample, win_num=win_num, restore=restore, p0=p0, xor_graphics=xor_graphics, color=color, silent=silent, nodsk=nodsk, dkd=dkd, altitudes=altitudes, azimuths=azimuths, limb_pts_body=limb_pts_body, cw=cw)



Description
-----------
	Allows the user to select an image sector along lines of constant
 	azimuth and altitude above a planet by clicking and dragging.









Returns
-------

      POINT containing points on the sector outline.  The point
      spacing is determined by the sample keyword.  The POINT object
      also contains the disk coordinate for each point, relative to the
      returned disk descriptor, and the user fields 'nrad' and 'nlon'
      giving the number of points in altitude and azimuth.

 KNOWN BUGS:
	The sector flips when it hits zero azimuth rather than retaining a
	consistent sense.


 MODIFICATION HISTORY :
	Spitale; 8/2006		original version









Keywords
--------


.. _cd
- cd *in* 

    Camera descriptor.




.. _gbx
- gbx *in* 

    Globe descriptor for the planet whose limb is to be
                   scanned.




.. _gd
- gd *in* 

    Generic descriptor containnig the above descriptors.




.. _lon
- lon 



.. _sample
- sample *in* 

    Sets the grid sampling in pixels.  Default is one.




.. _win\_num
- win\_num *in* 

    Window number of IDL graphics window in which to select
                   box, default is current window.




.. _restore
- restore *in* 

    Do not leave the box in the image.




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

    If set, skyplane disk image points will not be included
                   in the output POINT.




.. _dkd
- dkd 

     Disk desriptor in the skyplane, centered on the planet
                   with 0 axis along the skyplane projection of the north
                   pole.  For use with pg_profile_ring.




.. _altitudes
- altitudes 

Array giving altitude at each sample.




.. _azimuths
- azimuths 

Array giving azimuth at each sample.




.. _limb\_pts\_body
- limb\_pts\_body 

Body coordinates of each limb points on planet surface.





.. _cw
- cw *in* 

    If set, azimuths are assumed to increase in the clockwise
                   direction.























