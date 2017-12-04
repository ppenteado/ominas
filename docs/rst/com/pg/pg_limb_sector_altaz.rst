pg\_limb\_sector\_altaz.pro
===================================================================================================



























pg\_limb\_sector\_altaz
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_limb_sector_altaz(alt, _az, cd=cd, gbx=gbx, gd=gd, dkd=dkd, sample=sample, nodsk=nodsk, altitudes=altitudes, azimuths=azimuths, limb_pts_body=limb_pts_body, cw=cw, naz=naz, nalt=nalt, graphic=graphic)



Description
-----------
	Constructs a limb sector outline for use with pg_profile_ring given
	altitude and azimuth bounds.









Returns
-------

      POINT containing points on the sector outline.  The point
      spacing is determined by the sample keyword.  The POINT objects
      also contains the disk coordinate for each point, relative to the
      returned disk descriptor, and the user fields 'nrad' and 'nlon'
      giving the number of points in altitude and azimuth.

 KNOWN BUGS:
	The sector flips when it hits zero azimuth rather than retaining a
	consistent sense.


 ORIGINAL AUTHOR :
	Spitale; 8/2006









+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




alt
-----------------------------------------------------------------------------

*in* 

2-elements array giving the lower and upper altitude bounds
		for the sector.





\_az
-----------------------------------------------------------------------------

*in* 

2-elements array giving the lower and upper azimuth bounds
		for the sector in radians, reliative to the skyplane
		projection of the planet's north pole.





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

    Generic descriptor containing the above descriptors.




.. _dkd
- dkd 

    Disk descriptor in the skyplane, centered on the planet
                   with 0 axis along the skyplane projection of the north
                   pole.  For use with pg_profile_ring.




.. _sample
- sample *in* 

    Sets the grid sampling in pixels.  Default is one.




.. _nodsk
- nodsk *in* 

    If set, skyplane disk image points will not be included
                   in the output POINT.




.. _altitudes
- altitudes 

Array giving altitude at each sample.




.. _azimuths
- azimuths 

Array giving azimuth at each sample.




.. _limb\_pts\_body
- limb\_pts\_body 

Body coordinates of each limb points on planet surface.






.. _cw
- cw *in* 

    If set, azimuths are assumed to increase in the clockwise
                   direction.




.. _naz
- naz *in* 

    Total number of samples in the azimuthal direction.
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
























