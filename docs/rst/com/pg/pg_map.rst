pg\_map.pro
===================================================================================================



























pg\_map
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_map(dd, md=md, cd=cd, bx=bx, gbx=gbx, dkx=dkx, ltd=ltd, gd=gd, hide_fn=hide_fn, hide_bx=hide_bx, map=map, aux_names=aux_names, pc_xsize=pc_xsize, pc_ysize=pc_ysize, bounds=bounds, interp=interp, arg_interp=arg_interp, offset=offset, edge=edge, shear_fn=shear_fn, shear_data=shear_data, smooth=smooth, roi=roi, test_factor=test_factor)



Description
-----------
	Generates map projections.










Returns
-------

	Data descriptor containing the output map.  The instrument field is set
	to 'MAP'.  User data arrays are created for the reprojected aux_names
	arrays.


 STATUS:
	Complete


 SEE ALSO:
	pg_mosaic










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

Data descriptor containing image to be projected.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _md
- md *in* 

Map descriptor describing the projection.




.. _cd
- cd *in* 

Camera descriptor describing the image to be projected.




.. _bx
- bx *in* 

Subclass of BODY giving the body to be projected.  Can be
		GLOBE or RING.  Only bodies whose names match that in the
		map descriptor are mapped.




.. _gbx
- gbx *in* 

Globe descriptor describing the body to be projected.
		This argument is kept for compatibility with earlier
		code.  It is recommended that you use the 'bx' argument
		instead.




.. _dkx
- dkx *in* 

Disk descriptor describing the body to be projected.
		This argument is kept for compatibility with earlier
		code.  It is recommended that you use the 'bx' argument
		instead.




.. _ltd
- ltd *in* 

Star descriptor for a light source.  If given, points behind the
		terminator are excluded.




.. _gd
- gd *in* 

Generic descriptor.  If given, the above descriptor inputs
		are taken from the corresponding fields of this structure
		instead of from those keywords.




.. _hide\_fn
- hide\_fn *in* 


		String giving the name of a function whose purpose
		is to exclude hidden points from the map.  Options are:
		   pm_hide_ring
		   pm_hide_globe
		   pm_rm_globe_shadow
		   pm_rm_globe




.. _hide\_bx
- hide\_bx *in* 


		Array of BODY objects for the hide functions; one per
		function.




.. _map
- map 

For convenience, the generated map is returned here as
		well as in the returned data descriptor.





.. _aux\_names
- aux\_names *in* 


		Array (naux) giving udata names for additional data
		descriptor planes to reproject.  The dimensions of these
		planes must be the same as the image.

	pc_xsize, pc_ysize:
		The map is generated in pieces of size pc_xsize
		x pc_ysize.   Default is 100 x 100 pixels.




.. _pc\_xsize
- pc\_xsize 



.. _pc\_ysize
- pc\_ysize 



.. _bounds
- bounds *in* 


		Projection bounds specified as [lat0, lat1, lon0, lon1].




.. _interp
- interp *in* 

Type of interpolation, see image_interp_cam.




.. _arg\_interp
- arg\_interp *in* 

Interpolation argument, see image_interp_cam.




.. _offset
- offset *in* 

Offset in [lat,lon] to apply to map coordinates before
		projecting.




.. _edge
- edge *in* 

Minimum proximity to image edge.  Default is 0.




.. _shear\_fn
- shear\_fn 



.. _shear\_data
- shear\_data 



.. _smooth
- smooth *in* 

If set, the input image is smoothed before reprojection.




.. _roi
- roi *in* 

Subscripts in the output map specifying the map region
		to project, instead of the whole thing.




.. _test\_factor
- test\_factor *in* 

If set, a test map, reduced in size by this factor,
			is projected to determine the roi.  For maps with
			large blank areas, this may speed up the projection
			greatly.















History
-------

 	Written by:	Spitale, 1998
	Modified:	Daiana DiNino; 7, 2011 : test_factor





















