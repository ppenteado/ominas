pg\_photom\_disk.pro
===================================================================================================



























pg\_photom\_disk
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_photom_disk(dd, outline_ptd=outline_ptd, cd=cd, dkx=dkx, ltd=ltd, gd=gd, refl_fn=refl_fn, phase_fn=phase_fn, refl_parm=refl_parm, phase_parm=phase_parm, emm_out=emm_out, inc_out=inc_out, phase_out=phase_out, overwrite=overwrite)



Description
-----------
	Photometric image correction for disk objects.










Returns
-------

	New data descriptor containing the corrected image.  The photometric
	angles emm, inc, and phase are placed in the user data arrays with
	the tags'EMM', 'INC', and 'PHASE' respectively.  Unless /overwrite is
	set, the nw descriptor is a clone of the input descriptor, with the
	relevant fields modified.


 STATUS:
	Complete










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

Data descriptor containing image to correct.






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _outline\_ptd
- outline\_ptd *in* 

POINT with image points outlining the
			region of the image to correct.  To correct the entire
			disk, this input could be generated using pg_ring().
			If this keyword is not given, the entire image is used.
			If two arrays are given, they are taken as the inner
			and outer boundaries.




.. _cd
- cd *in* 

Camera descriptor




.. _dkx
- dkx *in* 

Disk descriptor




.. _ltd
- ltd *in* 

Light descriptor




.. _gd
- gd *in* 

Generic descriptor.  If present, cd and dkx are taken from
		here if contained.




.. _refl\_fn
- refl\_fn *in* 

String naming reflectance function to use.  Default is
			'pht_minneart'.




.. _phase\_fn
- phase\_fn *in* 

String naming phase function to use.  Default is none.




.. _refl\_parm
- refl\_parm 



.. _phase\_parm
- phase\_parm 



.. _emm\_out
- emm\_out 

Image emission angles.




.. _inc\_out
- inc\_out 

Image incidence angles.




.. _phase\_out
- phase\_out 

Image phase angles.





.. _overwrite
- overwrite *in* 

If set, the output descriptor is the input descriptor
			with the relevant fields modified.














History
-------

 	Written by:	Spitale, 1/2002 (pg_photom)
	 Spitale, 6/2004:	changed to pg_photom_disk





















