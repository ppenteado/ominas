get\_ring\_profile.pro
===================================================================================================



























get\_ring\_profile
________________________________________________________________________________________________________________________





.. code:: IDL

 result = get_ring_profile(image, cd, dkd, lon_pts, rad_pts, azimuthal=azimuthal, interp=interp, im_pts=im_pts, dx=dx, dsk_pts=dsk_pts, sigma=sigma, width=width, nn=nn, arg_interp=arg_interp)



Description
-----------
       Generates a ring profile in radius or longitude.



       The profile is calculated by applying a grid of (radius, longitude)
       given by rad and lon on a ring sector, interpolating the dn in
       the image, and averaging along a direction to give a radius profile,
       or a longitudinal profile.

 STATUS:
       Completed.










Returns
-------

       An array of averaged dn values that match the given rad or
       match the given lon if /azimuthal selected.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




image
-----------------------------------------------------------------------------

*in* 

     The image to scan





cd
-----------------------------------------------------------------------------

*in* 

     Camera descriptor





dkd
-----------------------------------------------------------------------------

*in* 

     Disk descriptor





lon\_pts
-----------------------------------------------------------------------------






rad\_pts
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _azimuthal
- azimuthal *in* 

     If set, a longitudinal scan is done instead.




.. _interp
- interp 



.. _im\_pts
- im\_pts 



.. _dx
- dx 



.. _dsk\_pts
- dsk\_pts 



.. _sigma
- sigma 



.. _width
- width 



.. _nn
- nn 



.. _arg\_interp
- arg\_interp 













History
-------

       Written by:     Haemmerle, 6/1998





















