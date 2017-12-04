pg\_linearize\_image.pro
===================================================================================================



























pg\_linearize\_image
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_linearize_image(dd, new_cd, cd=cd, gd=gd, fcp=fcp, scp=scp, scale=scale, oaxis=oaxis, size=size, pc_xsize=pc_xsize, pc_ysize=pc_ysize, image=image, interp=interp)



Description
-----------
	Reprojects an image onto a linear scale.



	The input image is divided into pieces and tranformed one piece at
	a time.  There are two modes of operation: If nmp and scp are
	given, then the image is transformed using them as control points.
	Otherwise, the image is transformed using whatever camera transformation
	is specified in the camera descriptor.


 STATUS:
	Control-point scheme not yet implemented.


 SEE ALSO:
	pg_resfit, pg_resloc










Returns
-------

	Data descriptor containing the reprojected image.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

Data descriptor containing image to be reprojected.





new\_cd
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _cd
- cd *in* 

Camera descriptor describing the image to be reprojected.




.. _gd
- gd *in* 

Generic descriptor containing the above descriptor.




.. _fcp
- fcp *in* 

Focal coordinates of known reseau locations.




.. _scp
- scp *in* 

Image coordinates in input image of detected reseau marks
		corresponding to those given by nmp.




.. _scale
- scale *in* 

2-element array giving the camera scale (radians/pixel)
		in each direction for the reprojected image.  If not given, the
		scale of the input image is used.




.. _oaxis
- oaxis *in* 

2-element array giving the image coordinates of the optic axis
		in the reprojected image.  If not given, the center of
		the reprojected image is used.




.. _size
- size *in* 

2-element array giving the size of the reprojected image.  If
		not given, the size of the input image is used.




.. _pc\_xsize
- pc\_xsize *in* 

Y-Size of each image piece.  Default is 200 pixels.




.. _pc\_ysize
- pc\_ysize 



.. _image
- image 

The output image, which is also placed in the data descriptor.





.. _interp
- interp *in* 

Type of interpolation to use.  Options are:
		'nearest', 'mean', 'bilinear', 'cubic', 'sinc'.














History
-------

 	Written by:	Spitale, 5/2002





















