pg\_draw\_vector.pro
===================================================================================================



























pg\_draw\_vector
________________________________________________________________________________________________________________________





.. code:: IDL

 pg_draw_vector, source, target, cd=cd, dd=dd, gd=gd, literal=literal, lengths=lengths, plabels=plabels, colors=colors, thick=thick, csizes=csizes, wnum=wnum, noshorten=noshorten, solid=solid, fixedheads=fixedheads, winglength=winglength, draw_wnum=draw_wnum, shades=shades, label_shade=label_shade, label_color=label_color, shade_threshold=shade_threshold



Description
-----------
         Draws vectors on an image from a source towards a
         target. Very useful for locating off-image objects
         (planets, say) in an image for referencing.  By default,
         vectors are foreshortened to their projections onto the image
         plane so that vectors with large  out-of-plane components
         will be shorter.  (This can be deactivated with the
         /noshorten keyword.)  Also by default, vectors that point
         away from the camera will be drawn as dotted lines while
         vectors which point towards the camera will be drawn solid.
         (This can be controlled with the /solid keyword.)














+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




source
-----------------------------------------------------------------------------






target
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _cd
- cd 



.. _dd
- dd 



.. _gd
- gd 



.. _literal
- literal *in* 

All of the following input keywords accept an array
			where each element corresponds to an element in the
			object_ptd array.  By default, if the keyword array is
			shorter than the object_ptd array, then the last element
	  		is used to fill out the array.  /literal suppresses
			this behavior and causes unspecified elements to
			take their default values




.. _lengths
- lengths *in* 

       Lengths of the vectors.  (Default: 50 pixels)




.. _plabels
- plabels *in* 

        Text with which to label vectors.  (Default:
                       no label)




.. _colors
- colors *in* 

        Colors to use in drawing.  (Default: current
                       default color)




.. _thick
- thick *in* 

        Line thicknesses.  (Default: 1)




.. _csizes
- csizes *in* 

     Character sizes for plabels.  (Default: 1)




.. _wnum
- wnum 



.. _noshorten
- noshorten *in* 

    If set, vectors will not be foreshortened
                       depending on how much they point into/out
                       of the image plane.




.. _solid
- solid *in* 

        All lines are to be drawn solid (linestyle=0)
                       rather than allow vectors pointing into the
                       image plane to be dotted.




.. _fixedheads
- fixedheads *in* 

    If set, arrowheads will not be scaled to
                        match the foreshortening of the vector.




.. _winglength
- winglength 



.. _draw\_wnum
- draw\_wnum 



.. _shades
- shades 



.. _label\_shade
- label\_shade 



.. _label\_color
- label\_color 



.. _shade\_threshold
- shade\_threshold 







Examples
--------

.. code:: IDL

       Say moon_points is a POINT object containing the center
       data for the four Galilean satellites and jupiter_points has
       Jupiter's center data.  Then

       IDL> pg_draw_vector, moon_points, jupiter_points, colors=[100, $
             150, 200, 250], thick=1.25, length=70, plabels="Jupiter", $
             csizes=1.5

       will draw vectors from each towards the planet.  Conversely,

       IDL> pg_draw_vector, jupiter_points, moon_points, colors=[100, $
             150, 200, 250], thick=1.25, length=70, plabels=["Io", "Europa", $
             "Ganymede", "Callisto"], csizes=1.5

       will draw vectors from Jupiter's center towards each moon,
       labelling each by the moon's name.










History
-------


     Written: John W. Weiss, 5/05
     Consolidated some functionality into plot_arrow; Spitale 9/2005






















