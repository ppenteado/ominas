grift.pro
===================================================================================================



























grift
________________________________________________________________________________________________________________________





.. code:: IDL

 grift, arg, plane=plane, pn=pn, all=all, active=active, grn=grn, gd=gd, dd=dd, cd=cd, md=md, pd=pd, rd=rd, sd=sd, std=std, ard=ard, ltd=ltd, od=od, bx=bx, bbx=bbx, dkx=dkx, limb_ptd=limb_ptd, ring_ptd=ring_ptd, star_ptd=star_ptd, station_ptd=station_ptd, array_ptd=array_ptd, term_ptd=term_ptd, plgrid_ptd=plgrid_ptd, center_ptd=center_ptd, shadow_ptd=shadow_ptd, reflection_ptd=reflection_ptd, object_ptd=object_ptd, tie_ptd=tie_ptd, curve_ptd=curve_ptd, _ref_extra=_ref_extra



Description
-----------
	External access to GRIM data.  Purloins object and array references
	from GRIM so that they may be manipulated on the command line or by an
	external agent.  The returned descriptors allow direct access to the
	memory images of GRIM's objects, so any changes made affect the
	objects that GRIM is using.  GRIM monitors those objects and updates
	itself whenever a change occurs.













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




arg
-----------------------------------------------------------------------------

*in* 

GRIM window number or GRIM data struture.  If not given, the
		most recently accessed grim instance is used.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _plane
- plane *in* 

Grim plane structure(s) instead of giving pn.  Note all planes
		must belong to the same grim instance.




.. _pn
- pn *in* 

Plane number(s) to access.  If not given, then current plane
		is used.




.. _all
- all *in* 

If set, all planes are used.




.. _active
- active *in* 

If set, only active memebrs of the selected objects are
		returned.




.. _grn
- grn 



.. _gd
- gd 

Generic descriptor containing all of GRIM's descriptors.
		For multiple planes, a list is returned with each element
		corresponding to a plane.

	<xd>:	Any descriptor maintained by GRIM.

	<xdx>:	Returnds all descriptors containing the given class, e.g.,
		bx, gbx, dkx.   Not implemented.

	<overlay>_ptd:
		POINT object giving the points for the overlay of type <overlay>.




.. _dd
- dd 



.. _cd
- cd 



.. _md
- md 



.. _pd
- pd 



.. _rd
- rd 



.. _sd
- sd 



.. _std
- std 



.. _ard
- ard 



.. _ltd
- ltd 



.. _od
- od 



.. _bx
- bx 



.. _bbx
- bbx 



.. _dkx
- dkx 



.. _limb\_ptd
- limb\_ptd 



.. _ring\_ptd
- ring\_ptd 



.. _star\_ptd
- star\_ptd 



.. _station\_ptd
- station\_ptd 



.. _array\_ptd
- array\_ptd 



.. _term\_ptd
- term\_ptd 



.. _plgrid\_ptd
- plgrid\_ptd 



.. _center\_ptd
- center\_ptd 



.. _shadow\_ptd
- shadow\_ptd 



.. _reflection\_ptd
- reflection\_ptd 



.. _object\_ptd
- object\_ptd 


		POINT object giving all overlay points.




.. _tie\_ptd
- tie\_ptd 


		POINT object giving the tie points.  For multiple planes, a
		list is returned with each element corresponding to a plane.




.. _curve\_ptd
- curve\_ptd 


		POINT object giving the curve points.  For multiple planes, a
		list is returned with each element corresponding to a plane.





.. _\_ref\_extra
- \_ref\_extra 







Examples
--------

.. code:: IDL

	(1) Open a GRIM window, load an image, and compute limb points.

	(2) At the command line, type:

		IDL> grift, cd=cd
		IDL> pg_repoint, [50,50], 0d, cd=cd

	GRIM should detect the change to the camera descriptor and update
	itself by recomputing the limb points and refreshing the display.


 SEE ALSO:
	grim, graft










History
-------

 	Written by:	Spitale, 7/2002





















