pg\_limb\_sector\_linear.pro
===================================================================================================



























pg\_limb\_sector\_linear
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_limb_sector_linear(alt, _rim, az0, cd=cd, gbx=gbx, gd=gd, sample=sample, altitudes=altitudes, rims=rims, nrim=nrim, nalt=nalt, graphic=graphic)



Description
-----------
	Constructs a limb sector outline for use with pg_profile_image, given
	altitude and length bounds.  The sector is rectangular, being tangent
	to the limb at a given azimuth.









Returns
-------

      POINT object containing points on the sector outline.  The point
      spacing is determined by the sample keyword.  The POINT object
      also contains the user fields 'nl' and 'nw' giving the number of points
      in altitude and r.

 KNOWN BUGS:
	The sector flips when it hits zero azimuth rather than retaining a
	consistent sense.


 ORIGINAL AUTHOR :
	Spitale; 1/2009









+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




alt
-----------------------------------------------------------------------------

*in* 

2-elements array giving the lower and upper altitude bounds
		for the sector.





\_rim
-----------------------------------------------------------------------------

*in* 

2-element array giving the image-coordinate cylidrical coordinates
		of the the ends of the sector.





az0
-----------------------------------------------------------------------------

*in* 

Azimuth of the sector tangent point.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _cd
- cd *in* 

    Camera descriptor.




.. _gbx
- gbx *in* 

    Globe descriptor giving the planet about whose limb
                   the scan will be extracted.




.. _gd
- gd *in* 

    Generic descriptor containig the above descriptors.




.. _sample
- sample *in* 

    Sets the grid sampling in pixels.  Default is one.




.. _altitudes
- altitudes 

Array giving altitude at each sample.





.. _rims
- rims 

Array giving azimuth at each sample.




.. _nrim
- nrim *in* 

    Total number of samples in the scan direction.
                   Determined by the 'sample' keyword by default.




.. _nalt
- nalt *in* 

    Total number of samples in the altitude direction.
                   Determined by the 'sample' keyword by default.




.. _graphic
- graphic *in* 

    If set, the sector is computed in the planetographic
                   sense, i.e., lines of constant azimuth extend along
                   the local surface normal direction instead of the radial
                   direction.
























