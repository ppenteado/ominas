graft.pro
===================================================================================================



























graft
________________________________________________________________________________________________________________________





.. code:: IDL

 graft, arg, psym=psym, symsize=symsize, color=color, tag=tag, pn=pn, grn=grn



Description
-----------
	Grafts POINT arrays into GRIM.













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




arg
-----------------------------------------------------------------------------

*in* 

POINT object or array of image points.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _psym
- psym *in* 

 Plotting symbol.






.. _symsize
- symsize *in* 

Plotting symbol size.




.. _color
- color *in* 

 Plotting color.




.. _tag
- tag *in* 

 If given, the array is added as user data with this tag name.




.. _pn
- pn *in* 

 Plane number to access.  If not given, then current plane
		 is used.




.. _grn
- grn *in* 

 ID of GRIM instance to use.  If not given, then current one
		 is used.








Examples
--------

.. code:: IDL

	(1) Open a GRIM window, load an image, and compute planet centers.

	(2) At the command line, type:

		IDL> grift, gd=gd
		IDL> limb_ptd = pg_limb(gd=gd, gbx=gd.pd)
		IDL> graft, limb_ptd

	GRIM should plot the new overlay.


 SEE ALSO:
	grim, grift










History
-------

 	Written by:	Spitale





















