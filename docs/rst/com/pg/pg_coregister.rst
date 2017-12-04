pg\_coregister.pro
===================================================================================================



























pg\_coregister
________________________________________________________________________________________________________________________





.. code:: IDL

 pg_coregister, dd, cd=cd, bx=bx, gd=gd, shift=shift, center=center, p=p, xshift=xshift, wrap=wrap, subpixel=subpixel, no_shift=no_shift



Description
-----------
	Using the given geometry information, shifts the given images so as
	to center the given bodies at the same pixel in each image, or aligns
	images based on pointing.



	The given data and camera descriptors are modified: the images are
	shifted and the camera descriptor optic axes are changed accordingly.


 STATUS:
	Complete













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

Array of data descriptors giving images to shift.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _cd
- cd *in* 

Array of camera descripors, one for each input image.




.. _bx
- bx *in* 

Array of descriptors of any superclass of BODY, one for each
		input image.




.. _gd
- gd *in* 

Generic descriptor containing the camera and body
		descriptors or an array of generic descriptors, one for each
		input image.




.. _shift
- shift 

Offset applied to each image.





.. _center
- center *in* 

Image coordinates at which to center each body.  By default,
		the average center among all the bodies is used.  If this input
		contains a single element, it is taken as the index of the
		input image to use as the reference.




.. _p
- p *in* 

Array (1,3) giving surface coordinates at which to center
		each body.




.. _xshift
- xshift *in* 

Additional image offset by which to shift each image.




.. _wrap
- wrap *in* 

If set shifted pixels are wrapped to the opposite side
		of the image.




.. _subpixel
- subpixel *in* 

By default, each image is shifted by an integer number of
		  pixels in each direction. If this keyword is set, the
		  image is interpolated onto a new pixel grid such that the
		  sub-pixel shift is obtained.  (Not currently implemented)




.. _no\_shift
- no\_shift 













History
-------

 	Written by:	Spitale, 11/2002





















