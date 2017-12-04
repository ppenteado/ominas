footprint.pro
===================================================================================================



























footprint
________________________________________________________________________________________________________________________





.. code:: IDL

 result = footprint(cd, bx, slop=slop, corners=corners, hit_indices=hit_indices, image_pts=image_pts, body_p=body_p, sample=sample)



Description
-----------
	Computes the footprint of a camera on a given body.










Returns
-------

	Array (nhit) of pointers to inertial footprint points for each body hit.
	Zero is returned if no bodies are hit.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




cd
-----------------------------------------------------------------------------

*in* 

	Camera descripor.  Only one allowed.





bx
-----------------------------------------------------------------------------

*in* 

	Body descriptors.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _slop
- slop *in* 

	Number of pixels by which to expand the image in each
			direction.




.. _corners
- corners *in* 

Array(2,2) giving corers of image region to consider.




.. _hit\_indices
- hit\_indices 

Array (nhit) of bx indices.




.. _image\_pts
- image\_pts *in* 

Footprint points in the image frame.




.. _body\_p
- body\_p 

	Array (nhit) of pointers to body footprint points for
			each body hit.




.. _sample
- sample *in* 

	Sampling rate; default is 1 pixel.















History
-------

       Written by:     Spitale		5/2014





















