;=============================================================================
;+
; NAME: 
;	pg_draw_vector
;
;
;
; PURPOSE: 
;         Draws vectors on an image from a source towards a
;         target. Very useful for locating off-image objects 
;         (planets, say) in an image for referencing.  By default,
;         vectors are foreshortened to their projections onto the image
;         plane so that vectors with large  out-of-plane components
;         will be shorter.  (This can be deactivated with the
;         /noshorten keyword.)  Also by default, vectors that point
;         away from the camera will be drawn as dotted lines while
;         vectors which point towards the camera will be drawn solid.
;         (This can be controlled with the /solid keyword.)
;
;
;
; CATEGORY: 
;         NV/PG
;
;
; CALLING SEQUENCE: 
;                 pg_draw_vector, sources, targets,
;                 (cd=cd| gd=gd)[, /literal, thick=thick, lengths=lengths,
;                  colors=colors, plabels=plabels, csizes=csizes]
;
;
;
; INPUTS:
;        sources:         Inertial positions of sources.  Either an array
;                         of column vectors (nv x 3 x nt) or an array of 
;                         points structures containing the inertial vectors.  
;
;        targets:         Inertial positions of targets, or inertial unit
;                         vectors giving directions to targets.  Either an 
;                         array of column vectors (nv x 3 xnt) or an array 
;                         of points structures.  There must either be a single 
;                         target point or a one-to-one match between source 
;                         and target points.
;                         
;
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;
;       cd or gd        A camera descriptor or a generic descriptor
;                       containing a camera descriptor.  Required unless
;			source and target given as image points.
;
;	literal:	All of the following input keywords accept an array
;			where each element corresponds to an element in the
;			object_ps array.  By default, if the keyword array is
;			shorter than the object_ps array, then the last element
;	  		is used to fill out the array.  /literal suppresses
;			this behavior and causes unspecified elements to
;			take their default values
;
;       lengths:        Lengths of the vectors.  (Default: 50 pixels)
;
;       thick:         Line thicknesses.  (Default: 1)
;
;       colors:         Colors to use in drawing.  (Default: current
;                       default color)
;
;       plabels:         Text with which to label vectors.  (Default:
;                       no label)
;
;       csizes:      Character sizes for plabels.  (Default: 1)
;        
;       solid:         All lines are to be drawn solid (linestyle=0)
;                       rather than allow vectors pointing into the
;                       image plane to be dotted.
;
;       noshorten:     If set, vectors will not be foreshortened
;                       depending on how much they point into/out
;                       of the image plane.
;
;       fixedheads:     If set, arrowheads will not be scaled to
;                        match the foreshortening of the vector.
;
; OUTPUTS:
;        None
;
;
; EXAMPLE:
;       Say moon_points is a point structure containing the center
;       data for the four Galilean satellites and jupiter_points has
;       Jupiter's center data.  Then
;
;       IDL> pg_draw_vector, moon_points, jupiter_points, colors=[100, $
;             150, 200, 250], thick=1.25, length=70, plabels="Jupiter", $
;             csizes=1.5
;
;       will draw vectors from each towards the planet.  Conversely, 
;
;       IDL> pg_draw_vector, jupiter_points, moon_points, colors=[100, $
;             150, 200, 250], thick=1.25, length=70, plabels=["Io", "Europa", $
;             "Ganymede", "Callisto"], csizes=1.5
;
;       will draw vectors from Jupiter's center towards each moon,
;       labelling each by the moon's name.
;
;
; MODIFICATION HISTORY:
;
;     Written: John W. Weiss, 5/05
;     Consolidated some functionality into plot_arrow; Spitale 9/2005
;          
;
;-
;=============================================================================
pro pg_draw_vector, source, target, cd=cd, gd=gd, literal=literal, $
    lengths=_lengths, plabels=_plabels, colors=_colors, thick=_thick, $
    csizes=_csizes, wnum=wnum, noshorten=noshorten, solid=solid, $
    fixedheads=fixedheads, winglength=winglength, draw_wnum=draw_wnum, $
    shades=shades, label_shade=label_shade, label_color=label_color, $
    shade_threshold=shade_threshold

compile_opt IDL2


 if(NOT keyword_set(_colors)) then _colors = ctwhite()
 if(NOT defined(winglength)) then winglength = 0.10
 if(NOT keyword_set(label_shade)) then label_shade = 1.0


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, gd, cd=cd

 if(not keyword__set(cd)) then nv_message, name="pg_draw_vector", $
   "A camera descriptor (or a generic descriptor containing a camera descriptor) is required for this routine."


 ;------------------------------------------------------------
 ; Check to make sure all required parameters were passed.
 ;------------------------------------------------------------
 if(not keyword__set(source)) then return
 if(not keyword__set(target)) then return


 color_type = size(_colors, /type)
 if(color_type EQ 7) then $
  begin
    nn = n_elements(_colors)
    colors = lonarr(nn)
    if(NOT keyword_set(shades)) then shades = make_array(nn, val=1.0)
    for i=0, nn-1 do colors[i] = call_function('ct'+strlowcase(_colors[i]), shades[i])

    label_colors = lonarr(nn)
     if(keyword_set(label_color)) then lc = make_array(nn, val=label_color) $
     else lc = _colors

    for i=0, nn-1 do label_colors[i] = $
        call_function('ct'+strlowcase(lc[i]), shades[i]*label_shade)

    _colors = colors
  end
 if(NOT keyword_set(label_colors)) then label_colors = _colors


 ;---------------------------------------------
 ; If they passed a window number, set it.
 ;---------------------------------------------
 if(keyword__set(wnum)) then wset, wnum


 ;-------------------------------------------------------------------
 ; If the literal flag isn't thrown, go ahead and extrapolate the
 ; keyword arrays.
 ;-------------------------------------------------------------------
 all = not keyword_set(literal)


 ;------------------------------------------------------------
 ; Determine if the source is a point-structure or an array
 ;------------------------------------------------------------
 if(size(source, /type) EQ 10) then begin
    n = n_elements(source)
    for i = 0, n-1 do begin
        v = ps_points(source[i])
        source_v = append_array(source_v, v)
    endfor
 endif else begin
    source_v = source
 endelse


 ;------------------------------------------------------------
 ; Determine if the target is a point-structure or an array
 ;------------------------------------------------------------
 if(size(target, /type) EQ 8) then begin
    n = n_elements(target)
    for i = 0, n-1 do begin
        v = ps_points(target[i])
        target_v = append_array(target_v, v)
    endfor
 endif else begin
    target_v = target
 endelse


 ;---------------------------------------------------------------------
 ; If necessary, replicate the target array to match the source array
 ;---------------------------------------------------------------------
 nsources = n_elements(source_v)/3
 ntargets = n_elements(target_v)/3

 if(nsources ne ntargets) then begin
    if(nsources eq 1) then begin
        source_v = source_v##make_array(ntargets, val=1d)
    endif else if(ntargets eq 1) then begin 
        target_v = target_v##make_array(nsources, val=1d)
    endif else begin 
        nv_message, name='pg_draw_vector', 'Source and Target arrays have incompatible sizes.'
    endelse
 endif
 nv = n_elements(source_v)/3


 ;------------------------------------------------------------
 ; Take care of filling up the arrays with the keyword values
 ;------------------------------------------------------------
 if(n_elements(_colors) NE 0 AND all) then $
  begin
   colors=fill_array(nv, val=_colors)
   label_colors=fill_array(nv, val=label_colors)
  end $
 else $
   colors=(label_colors=(fill_array(nv, val=_colors, def=!p.color)))

 if(n_elements(_thick) NE 0 AND all) then $
   thick=fill_array(nv, val=_thick) $
 else thick=fill_array(nv, val=_thick, def=1)

 if(n_elements(_lengths) NE 0 AND all) then $
   lengths=fill_array(nv, val=_lengths) $
 else lengths=fill_array(nv, val=_lengths, def=75.0)

 if(n_elements(_plabels) NE 0 AND all) then $
   plabels=fill_array(nv, val=_plabels) $
 else plabels=fill_array(nv, val=_plabels, def='', /string)

 if(n_elements(_csizes) NE 0 AND all) then $
   csizes=fill_array(nv, val=_csizes) $
 else csizes=fill_array(nv, val=_csizes, def=1.0)


 ;------------------------------------------------------------
 ; Define a few constants
 ;------------------------------------------------------------
 rad_per_pix = (cam_scale(cd))[0]
 wing_spread = !pi/6.0           ; A 30-degree angle between arrow spine 
                                 ; and wings

 cam_pos = bod_pos(cd) ## make_array(nv, val=1D)
 source_to_cam = cam_pos-source_v
                                 ; This distance from the source to the
                                 ; camera.
 dist = (v_mag(source_to_cam))[0]

 source_to_cam = v_unit(source_to_cam)

                                 ; Matrices make the math easier
 epsilon = 1.0E-3                ; Tolerance for determining whether the 
                                 ; target is unit length


 ;-----------------------------------------------
 ; compute directions if necessary
 ;-----------------------------------------------
 if((abs(v_mag(target_v[0,*]) - 1d))[0] LT epsilon) then begin
    v = target_v
 endif else begin
    v = target_v - source_v
 endelse


 ;-------------------------------------------------------------------
 ; Determine linestyles: by default, vectors into the image plane are
 ; dotted
 ;-------------------------------------------------------------------
 linestyles = bytarr(nv)
 w = where(v_inner(v, source_to_cam) LT 0.0)
 if((w[0] NE -1) and (not keyword_set(solid))) then linestyles[w] = 1


 ;--------------------------------------------------------------------
 ; Compute vector lengths and then ensure that none of them are too
 ; small.
 ;--------------------------------------------------------------------
 vec_lengths = v_mag(v)
 w = where(vec_lengths LE epsilon)
 if(w[0] ne -1) then vec_lengths[w] = epsilon/2.0


        
                                ; Use the scale and the camera-source
                                ; distance to rescale the vector

 rescales = dist*rad_per_pix*lengths/vec_lengths
 rescales = rescales[linegen3y(nv,3,1)]
 v = v * rescales

 ; Angle between the source-camera vector and the inertial vector
 alpha = v_angle(source_to_cam, v)


 ;---------------------------------------------------------------------
 ; If either of these keywords are set, we'll need a rescaling so that
 ; the final vectors and/or vector heads aren't foreshoretened
 ;---------------------------------------------------------------------
 if(keyword_set(noshorten) or keyword_set(fixedheads)) then begin
                                ; Reciprocal of sines of those angles,
                                ; which we will then inflate to do
                                ; array-of-vector math on
    lengthening = 1.0/sin(alpha)
    lengthening = lengthening[linegen3y(nv, 3, 1)]
 endif

                                ; If the user set the /noshorten flag,
                                ; then rescale the vector to be
                                ; length[i], with no for
                                ; foreshortening.
 if(keyword_set(noshorten)) then begin
    v = v*lengthening
 endif        


 ;------------------------------------------------------------
 ; compute image positions
 ;------------------------------------------------------------
 tails  = inertial_to_image_pos(cd, source_v)
 heads  = inertial_to_image_pos(cd, source_v + v)


 ;------------------------------------------------------------
 ; compute arrowhead dimensions
 ;------------------------------------------------------------
 hsizes = winglength * lengths

 hangles = make_array(nv, val=!dpi/6d)
 if(NOT keyword_set(fixedheads)) then $
   hangles = hangles + abs(cos(alpha))*(!dpi/2d - hangles)


 ;------------------------------------------------------------
 ; Plot the vectors and the labels
 ;------------------------------------------------------------
 for i=0, nv-1 do begin
  if(vec_lengths[i] GE epsilon) then $
   plot_arrow, tails[*,i], heads[*,i], draw_wnum=draw_wnum, $
               color=colors[i], thick=thick[i], linestyle=linestyles[i], $
               label=plabels[i], hsize=hsizes[i], angle=hangles[i], $
               lcolor=label_colors[i], lsize=csizes[i]
 end


end
;=============================================================================

