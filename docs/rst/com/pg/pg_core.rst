pg\_core.pro
===================================================================================================



























pg\_core
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_core(dd, outline_ptd, cd=cd, gd=gd, distance=distance, interp=interp, arg_interp=arg_interp, sigma=sigma, profile=profile, image_pts=image_pts, bg=bg)



Description
-----------
	Generates a dn profile through a cube, or stack of images.









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

 Data descriptor(s).





outline\_ptd
-----------------------------------------------------------------------------

*in* 

  POINT descriptor giving the outline of the region to plot,
                as produced by the pg_select_region.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _cd
- cd *in* 

Camera descriptor.  Needed for sinc interpolation. (to get PSF)




.. _gd
- gd *in* 

  Optional generic descriptor containing cd.




.. _distance
- distance 

 Array giving the distance, in pixels, along the profile.




.. _interp
- interp *in* 

  Type of interpolation to use.  Options are:
               'nearest', 'mean', 'bilinear', 'cubic', 'sinc'.




.. _arg\_interp
- arg\_interp *in* 

  Arguments to pass to the interpolation function.





.. _sigma
- sigma 

  Array giving the standard deviation at each point in the
		profile.




.. _profile
- profile 

  The profile.




.. _image\_pts
- image\_pts 

 Image point for each point along the profile.





.. _bg
- bg *in* 

Uniform value to subtract from profile.














History
-------

       Written by:     Spitale, 7/2016





















