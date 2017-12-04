get\_limb\_profile\_outline\_linear.pro
===================================================================================================



























get\_limb\_profile\_outline\_linear
________________________________________________________________________________________________________________________





.. code:: IDL

 result = get_limb_profile_outline_linear(cd, gbx, alt=alt, az0=az0, rim=rim, points=points, nalt=nalt, nrim=nrim, inertial=inertial, save_rims=save_rims, scan_alt=scan_alt, scan_rim=scan_rim, limb_pts_body=limb_pts_body, graphic=graphic)



Description
-----------
       Generates an outline of a rectangular limb sector.









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





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _alt
- alt 



.. _az0
- az0 



.. _rim
- rim 



.. _points
- points 



.. _nalt
- nalt 



.. _nrim
- nrim 



.. _inertial
- inertial 

Inertial vectors corresponding to the limb sector
			outline points.





.. _save\_rims
- save\_rims 



.. _scan\_alt
- scan\_alt 



.. _scan\_rim
- scan\_rim 



.. _limb\_pts\_body
- limb\_pts\_body 



.. _graphic
- graphic 













History
-------

       Written by:     Spitale, 1/2009





















