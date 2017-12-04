pg\_hide.pro
===================================================================================================









	Hides the given points with respect to each given object and observer
	using the hide methods of the given bodies.



	The flags arrays in point_ptd are modified.



	For each object in point_ptd, hidden points are computed and
	PTD_MASK_INVISIBLE in the POINT is set.  No points are
	removed from the array.








Examples
___________

.. code:: IDL

	The following command hides all points which are behind a planet as
	seen by the camera:

	pg_hide, point_ptd, cd=cd, bx=pd

	In this call, pd is a planet descriptor, and cd is a camera descriptor.


 STATUS:
	Complete


 SEE ALSO:
	pg_hide_limb
















History
-------

 	Written by:	Spitale, 3/2017, generalized pg_hide_globe and pg_hide_disk















