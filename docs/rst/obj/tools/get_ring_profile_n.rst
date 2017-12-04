get\_ring\_profile\_n.pro
===================================================================================================



























get\_ring\_profile\_n
________________________________________________________________________________________________________________________





.. code:: IDL

 result = get_ring_profile_n(outline_pts, cd, dkd, lon, rad, oversamp=oversamp)



Description
-----------
       Calculate the number of points in radius and longitude for
       a ring profile.



       Routine goes along the radial and longitudinal edges of a ring
       profile sector and calculates the minimum spacing between the
       points in image space, then derives the n_rad and n_lon points
       to make the minimum spacing 1 pixel.  If the oversamp parameter
       is given, the numbers are multiplied by this factor.

 STATUS:
       Completed.










Returns
-------

       Array containg n_rad and n_lon to be used by get_ring_profile() or
       get_ring_profile_bin().










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




outline\_pts
-----------------------------------------------------------------------------

*in* 

   Outline sector image points which are the result
                       of calling get_ring_profile_outline()





cd
-----------------------------------------------------------------------------

*in* 

   Camera descriptor





dkd
-----------------------------------------------------------------------------

*in* 

   Disk descriptor





lon
-----------------------------------------------------------------------------

*in* 

   Equally spaced longitude array





rad
-----------------------------------------------------------------------------

*in* 

   Equally spaced radius array





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _oversamp
- oversamp *in* 

   Oversample factor compared to regular calculation of
                       radius and longitude spacing which would put maximum
                       spacing at 1 pixel.














History
-------

       Written by:     Haemmerle, 6/1998





















