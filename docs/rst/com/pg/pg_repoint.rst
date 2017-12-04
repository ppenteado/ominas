pg\_repoint.pro
===================================================================================================



























pg\_repoint
________________________________________________________________________________________________________________________





.. code:: IDL

 pg_repoint, _arg, _dtheta, cd=cd, gd=gd, axis_ptd=axis_ptd, bore_cd=bore_cd, bore_rot=bore_rot, bore_dxy=bore_dxy, absolute=absolute



Description
-----------
	Modifies the camera orientation matrix based on the given image
	coordinate translation and rotation.



	pg_repoint adds its name to the task list of each given camera
	descriptor.


 STATUS:
	Complete


 SEE ALSO:
	pg_fit, pg_drag













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




\_arg
-----------------------------------------------------------------------------

*in* 

	Array (2,1,nt) or (2,1) specifying the translation as
			[dx,dy] in pixels.

				or

			Array of POINT objects; mainly useful with the /absolute
			option.

				or

			Array of new pointing vectors (1,3,nt).





\_dtheta
-----------------------------------------------------------------------------

*in* 

	Array (nt) specfying the rotation angle in radians.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _cd
- cd *in* 

 If given, the camera descriptor is modified with a new
		 orientation matrix.




.. _gd
- gd *in* 

 If given in this way, the camera descriptor contained in the
		 generic descriptor is modified with a new orientation matrix.





.. _axis\_ptd
- axis\_ptd *in* 

POINT containing a single image point
		 to be used as the axis of rotation.  Default is the camera
		 optic axis.




.. _bore\_cd
- bore\_cd *in* 

 Array (nt) of camera descriptors from which to copy the
		  new orientation instead of using dxy, dtheta, and axis_ptd.




.. _bore\_rot
- bore\_rot *in* 

If given, the orientation from bore_cd will be rotated
		  using this rotation matrix (3,3) before being copied.




.. _bore\_dxy
- bore\_dxy *in* 

Boresight offset in pixels.




.. _absolute
- absolute *in* 

If set, the dxy argument represents an absolute image
		  position rather than an offset.














History
-------

 	Written by:	Spitale, 2/1998





















