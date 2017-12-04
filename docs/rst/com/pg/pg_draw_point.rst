pg\_draw\_point.pro
===================================================================================================









	Draws points from the given POINT on the current graphics
	window using the current data coordinate system.








Examples
___________

.. code:: IDL

	The following command draws and labels a lavender 'limb' and a red
	'ring' (assuming that the points have already been computed):

	pg_draw_point, [limb_ptd, ring_ptd], color=[ctpurple(), ctred()], $
	         plabels=['LIMB','RING']


 STATUS:
	Complete
















History
-------

 	Written by:	Spitale, 1/1998 (pg_draw)
	Renamed pg_draw_point: Spitale, 9/2005















