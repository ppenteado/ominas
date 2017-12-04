image\_to\_surface.pro
===================================================================================================



























image\_to\_surface
________________________________________________________________________________________________________________________





.. code:: IDL

 result = image_to_surface(cd, bx, p, body_pts=body_pts, discriminant=discriminant, hit=hit, valid=valid)



Description
-----------
       Transforms points in image coordinates to surface coordinates.










Returns
-------

       Array (nv x 3 x nt) of surface points.  In the case of a camera descriptor, ray
	tracing is used.

 STATUS:
       Completed.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




cd
-----------------------------------------------------------------------------

*in* 

     Array of nt camera or map descriptor





bx
-----------------------------------------------------------------------------

*in* 

     Array of nt object descriptors (subclass of BODY).





p
-----------------------------------------------------------------------------

*in* 

      Array (2 x nv x nt) of image points.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _body\_pts
- body\_pts 



.. _discriminant
- discriminant 



.. _hit
- hit 



.. _valid
- valid 






















