get\_ring\_profile\_bin.pro
===================================================================================================



























get\_ring\_profile\_bin
________________________________________________________________________________________________________________________





.. code:: IDL

 result = get_ring_profile_bin(image, cd, dkd, lon_pts, rad_pts, slope=slope, azimuthal=azimuthal)



Description
-----------
       Generates a ring profile in radius or longitude using binning.



       A ring sector polygon is calculated from the given dlon and rad
       arrays.  All the pixels of the image within this polygon are
       binned in an equally-spaced histogram in radius or longitude.


       The dlon and rad arrays are treated as equally spaced, that is,
       the binsize is calculated by dividing the spacing in radius by
       number of points minus one.

 STATUS:
       Completed.










Returns
-------

       An array of averaged dn values that match the given rad or
       match the given dlon if /azimuthal selected.










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


.. _slope
- slope 



.. _azimuthal
- azimuthal *in* 

     If set, a longitudinal scan is done instead.














History
-------

       Written by:     Haemmerle, 6/1998





















