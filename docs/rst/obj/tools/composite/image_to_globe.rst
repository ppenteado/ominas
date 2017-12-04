image\_to\_globe.pro
===================================================================================================



























image\_to\_globe
________________________________________________________________________________________________________________________





.. code:: IDL

 result = image_to_globe(cd, gbx, p, body_pts=body_pts, discriminant=discriminant, valid=valid)



Description
-----------
       Transforms points in image coordinates to body globe coordinates










Returns
-------

       Array (nv x 3 x nt) of globe positions.

 STATUS:
       Completed.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




cd
-----------------------------------------------------------------------------

*in* 

      Array of nt camera or map descriptors.





gbx
-----------------------------------------------------------------------------

*in* 

     Array of nt object descriptors (of type GLOBE).





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



.. _valid
- valid 






















