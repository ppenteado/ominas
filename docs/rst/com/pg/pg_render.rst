pg\_render.pro
===================================================================================================



























pg\_render
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_render(cd=cd, ltd=ltd, bx=bx, ddmap=ddmap, md=md, dd=dd, gd=gd, sample=sample, pc_size=pc_size, show=show, pht_min=pht_min, no_pht=no_pht, map=map, standoff=standoff, limit_source=limit_source, nodd=nodd, psf=psf, npsf=npsf, numbra=numbra, no_secondary=no_secondary, image_ptd=image_ptd, mask_width=mask_width, no_maps=no_maps, no_mask=no_mask)



Description
-----------
	Performs rendering on an array of bodies.














Returns
-------

	Data descriptor containing the rendered image.










Keywords
--------


.. _cd
- cd *in* 

      Camera descriptor.




.. _ltd
- ltd *in* 

        Star descriptor for the Sun.




.. _bx
- bx *in* 

      Array of object descriptors; must be a subclass of BODY.




.. _ddmap
- ddmap *in* 

       Array of data descriptors containing the body maps,
	              one for each body.  If not given, maps are loaded using
		      pg_load_maps.




.. _md
- md *in* 

          Array of map descriptors for each ddmap.




.. _dd
- dd *in* 

	Data descriptor containing a generic descriptor to use
			if gd not given.




.. _gd
- gd *in* 

	Generic descriptor.  If given, the descriptor inputs
			are taken from this structure if not explicitly given.




.. _sample
- sample *in* 

      Amount by which to subsample pixels.




.. _pc\_size
- pc\_size *in* 

     To save memory, the projection is performed in pieces
	              of this size.  Default is 65536.




.. _show
- show 



.. _pht\_min
- pht\_min *in* 

     Minimum value to assign to photometric output.





.. _no\_pht
- no\_pht 



.. _map
- map 

       2-D array containing the rendered scene.





.. _standoff
- standoff *in* 

    If given, secondary vectors are advanced by this distance
	              before tracing in order to avoid hitting target bodies
	              through round-off error.




.. _limit\_source
- limit\_source *in* 

If set, secondary vectors originating on a given
	              body are not considered for targets that are the
	              same body.  Default is on.




.. _nodd
- nodd *in* 

        If set, no data descrptor is produced.  The return value
	              is zero and the rendering is returned via the IMAGE
	              keyword.




.. _psf
- psf *in* 

         If set, the rendering is convolved with a point-spread
	              function.  If /psf, then the PSF is obtained via cd; if
	              psf is a 2D array, then is is used as the PSF.




.. _npsf
- npsf *in* 

        Width of psf array to use if PSF is obtained via cd.
	              Default is 10.




.. _numbra
- numbra *in* 

      Number of rays to trace to the secondary bodies.
	              Default is 1.  The first ray is traced to the body
	              center; wach additional ray is traced to a random point
	              within the body.




.. _no\_secondary
- no\_secondary *in* 

If set, no secondary ray tracing is performed,
	              resulting in no shadows.




.. _image\_ptd
- image\_ptd *in* 

   POINT or array with image points
	              specifying the grid to trace.  If not set, the entire
	              image described by cd is used.  The array can have
	              dimensions of (2,np) or (2,nx,ny).  If the latter,
	              the output map will have dimensions (nx,ny).  Note
	              that a PSF cannot be applied if nx and ny are not known.




.. _mask\_width
- mask\_width *in* 

  Width of trace mask.  Default is 512.  If set to zero,
	              no masking is performed.




.. _no\_maps
- no\_maps *in* 

     If set, maps are not loaded.




.. _no\_mask
- no\_mask *in* 

     If set, a mask is not used.








Examples
--------

.. code:: IDL



 STATUS:
	Complete










History
-------

 	Written by:	Spitale





















