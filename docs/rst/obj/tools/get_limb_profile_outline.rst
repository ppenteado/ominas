get\_limb\_profile\_outline.pro
===================================================================================================



























get\_limb\_profile\_outline
________________________________________________________________________________________________________________________





.. code:: IDL

 result = get_limb_profile_outline(cd, gbx, points, alt=alt, az=az, nalt=nalt, naz=naz, inertial=inertial, dkd=dkd, save_azs=save_azs, scan_alt=scan_alt, scan_az=scan_az, limb_pts_body=limb_pts_body, graphic=graphic)



Description
-----------
       Generates an outline of a limb sector.









Returns
-------

       Array of image points defining the outline of the sector.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




cd
-----------------------------------------------------------------------------

*in* 

Camera descriptor.





gbx
-----------------------------------------------------------------------------

*in* 

Globe descriptor.





points
-----------------------------------------------------------------------------

*in* 

Array (2,2) of image points defining opposite corners
		of the sector.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _alt
- alt 



.. _az
- az 



.. _nalt
- nalt 



.. _naz
- naz 



.. _inertial
- inertial 

Inertial vectors corresponding to the limb sector
			outline points.




.. _dkd
- dkd 

Disk descriptor corresponding to the skyplane.





.. _save\_azs
- save\_azs 



.. _scan\_alt
- scan\_alt 



.. _scan\_az
- scan\_az 



.. _limb\_pts\_body
- limb\_pts\_body 



.. _graphic
- graphic 













History
-------

       Written by:     Spitale, 8/2006





















