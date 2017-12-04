stellab\_pos.pro
===================================================================================================



























stellab\_pos
________________________________________________________________________________________________________________________





.. code:: IDL

 result = stellab_pos(pos, vel, c=c, axis=axis, theta=theta, fast=fast)



Description
-----------
	Corrects positions for stellar aberration.










Returns
-------

	Array (nv,3) of corrected position vectors.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




pos
-----------------------------------------------------------------------------

*in* 

Array (nv,3) of target inertial position vectors to be
		corrected.





vel
-----------------------------------------------------------------------------

*in* 

Array (nv,3) of observer inertial velocity vectors.
		Note observer is assumed to be at the origin.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _c
- c *in* 

Speed of light.




.. _axis
- axis 

Array (nv,3) of rotation axes corresponding to each
		correction.




.. _theta
- theta 

Array (nv) of rotation angles corresponding to each
		correction.





.. _fast
- fast 













History
-------

       Written by:     Spitale





















