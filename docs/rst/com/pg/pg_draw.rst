pg\_draw.pro
===================================================================================================



























pg\_draw
________________________________________________________________________________________________________________________





.. code:: IDL

 pg_draw, object_ptd, target_ptd, literal=literal, colors=colors, shades=shades, psyms=psyms, psizes=psizes, plabels=plabels, xormode=xormode, csizes=csizes, cthicks=cthicks, wnum=wnum, label_shade=label_shade, label_points=label_points, thick=thick, line=line, print=print, cd=cd, gd=gd, corient=corient, lengths=lengths, align=align, noshorten=noshorten, solid=solid, fixedheads=fixedheads, winglength=winglength, graphics=graphics, label_color=label_color, shade_threshold=shade_threshold



Description
-----------
	Calls pg_draw_point or pg_draw_vector depending on the input arrays.
	pg_draw_point is called is only one argument is given.  Otherwise,
	it assumed that a source and target are given and pg_draw_vector is
	called.













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




object\_ptd
-----------------------------------------------------------------------------

*in* 

Array of POINT containing image points
			to be plotted in the current data coordinate system.
			Or inertial vectors to be used as vector sources.
			May also be an array of image points or inertial
			vectors.





target\_ptd
-----------------------------------------------------------------------------

*in* 

Array of POINTs giving the inertial
			positions of vector targets.  May also be an
			array of inertial vectors.  If this argument is
			present, then vectors are drawn instead of points.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _literal
- literal 



.. _colors
- colors 



.. _shades
- shades 



.. _psyms
- psyms 



.. _psizes
- psizes 



.. _plabels
- plabels 



.. _xormode
- xormode 



.. _csizes
- csizes 



.. _cthicks
- cthicks 



.. _wnum
- wnum 



.. _label\_shade
- label\_shade 



.. _label\_points
- label\_points 



.. _thick
- thick 



.. _line
- line 



.. _print
- print 



.. _cd
- cd 



.. _gd
- gd 



.. _corient
- corient 



.. _lengths
- lengths 



.. _align
- align 



.. _noshorten
- noshorten 



.. _solid
- solid 



.. _fixedheads
- fixedheads 



.. _winglength
- winglength 



.. _graphics
- graphics 



.. _label\_color
- label\_color 



.. _shade\_threshold
- shade\_threshold 













History
-------

 	Written by:	Spitale, 9/2005





















