pg\_profile\_ring.pro
===================================================================================================



























pg\_profile\_ring
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_profile_ring(dd, outline_ptd, cd=cd, dkx=dkx, gd=gd, azimuthal=azimuthal, sigma=sigma, width=width, nn=nn, bin=bin, dsk_pts=dsk_pts, im_pts=im_pts, interp=interp, arg_interp=arg_interp, profile=profile, bg=bg)



Description
-----------
	Generates radial or longitudinal ring profiles from the given image
	using an image outline.


	The image points of the sector outline are first calculated.  If
       /outline is selected then this is output.  If not, then the
       /azimuthal keyword determines if this is a radius or longitude
       profile.  The radius and longitude spacing for profile is then is
       determined. If n_lon or n_rad is given, then these are used.  If not,
       then the outline is used to determine the spacing in radius and
       longitude so that the maximum spacing is a pixel.  If oversamp is
       given then the number of samples is multiplied by this factor.
       Then the image is sampled with this radius x longitude grid and
       the dn interpolated with the routine image_interp at each point.
       The dn's are then averaged along the requested profile direction.
       If /bin keyword is selected then the image is not interpolated but
       rather each pixel is binned in a histogram with the calculated
       spacing.










Returns
-------

	Two data descriptors: the first contains the profile; the second contains
	the profile sigma.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

Data descriptor.





outline\_ptd
-----------------------------------------------------------------------------

*in* 

   POINT giving the outline of the sector to plot,
                      as produced by the pg_ring_sector.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _cd
- cd *in* 

Camera descriptor.




.. _dkx
- dkx *in* 

  Disk descriptor.




.. _gd
- gd *in* 

  Generic descriptor, if used, cd and dkx taken from it unless
               overriden by cd and dkx arguments.




.. _azimuthal
- azimuthal *in* 

  If set, the plot is longitudinal instead of radial.




.. _sigma
- sigma 

  Array giving the standard deviation at each point in the
		profile.




.. _width
- width 

  Array giving the width of the scan, in pixels along the
               averaging direction, at each point in the profile.




.. _nn
- nn 

  Number of image samples averaged into each profile point.




.. _bin
- bin *in* 

   If set, pixels in sector are binned according to
               radius or longitude rather than dn averaged at equal
               radius or longitude spacing




.. _dsk\_pts
- dsk\_pts 

Array of disk coordinates corresponding to each value in the
		returned dn profile.




.. _im\_pts
- im\_pts 

Array of image coordinates corresponding to each value in the
		returned dn profile.




.. _interp
- interp *in* 

   Type of interpolation to use: 'nearest', 'bilinear', 'cubic',
               or 'sinc'.  'sinc' is the default.




.. _arg\_interp
- arg\_interp *in* 

  Arguments to pass to the interpolation function.




.. _profile
- profile 

  The profile.




.. _bg
- bg *in* 

Uniform value to subtract from profile.








Examples
--------

.. code:: IDL

     lon = [175.,177.]
     rad = [65000000.,138000000.]
     outline_ptd = pg_ring_sector(cd=cd, dkx=rd, rad=rad, lon=lon)
     pg_draw, outline_ptd

     profile = pg_profile_ring(dd, cd=cd, dkx=rd, $
                                          outline_ptd, dsk_pts=dsk_pts)
     window, /free, xs=500, ys=300
     plot, dsk_pts[*,0], profile










History
-------

       Written by:     Vance Haemmerle & Spitale, 6/1998
	Modified to use outline_ptd instead of (rad,lon): Spitale 5/2005





















