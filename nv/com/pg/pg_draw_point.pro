;=============================================================================
;+
; NAME:
;	pg_draw_point
;
;
; PURPOSE:
;	Draws points from the given POINT on the current graphics
;	window using the current data coordinate system.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_draw_point, object_ptd
;
;
; ARGUMENTS:
;  INPUT:
;	object_ptd:	Array of POINT containing image points
;			to be plotted in the current data coordinate system.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	literal:	All of the following input keywords accept an array
;			where each element corresponds to an element in the
;			object_ptd array.  By default, if the keyword array is
;			shorter than the object_ptd array, then the last element
;	  		is used to fill out the array.  /literal suppresses
;			this behavior and causes unspecified elements to
;			take their default values.
;
;	colors:		Array of plotting colors.  Default is !color.  String
;			names will be converted using the ct<string>()
;			functions.  Labels are also plotted in this color.
;			If one element, then all points are plotted in this
;			color; if multiple elements, and object_ptd also
;			has multiple elements, each color will be assigned to 
;			all elements in the corresponding array (see /literal);
;			if mulitple elements, and object_ptd has only one
;			element, then each color will be assigned to each 
;			element of th object_ptd array.
;
;	shades:		Array of plotting shades.  Default is 1.0.
;
;	label_shade:	Array of plotting shades for labels.  Default is 1.0.
;
;	shades:		Array of plotting shades.  Default is 1.0.
;
;	psyms:		Array of plotting symbols.  Default is 3.
;
;	thick:		Array of plotting thicknesses.  Default is 1.
;
;	line:		Array of linestyles.  Default is 0.
;
;	psizes:		Array of plotting symbol sizes.  Default is 1.0.
;
;	csizes:		Array of character sizes.  Default is 1.0.
;
;	cthicks:	Array of character thicknesses.  Default is 1.0.
;
;	corient:	Array of character orientations.  Default is 1.0.
;
;	plabels:	Array of object labels.  Default is ''. 
;
;	label_points:	If set, plabels will be applied element-by-element to
;			each point in each points array instead of once
;			to each object.
;
;	align:		Label alignment.  See XYOUTS.
;
;	wnum:		Window number in which to draw.
;
;	xormode:	If set, XOR graphics mode is used for drawing.
;
;	print:		Message to print before plotting.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	NONE
;
;
; EXAMPLE:
;	The following command draws and labels a lavender 'limb' and a red
;	'ring' (assuming that the points have already been computed):
;
;	pg_draw_point, [limb_ptd, ring_ptd], color=[ctpurple(), ctred()], $
;	         plabels=['LIMB','RING']
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998 (pg_draw)
;	Renamed pg_draw_point: Spitale, 9/2005
;	
;-
;=============================================================================



;=============================================================================
; pgdp_draw
;
;=============================================================================
pro pgdp_draw, points, $
            colors, psyms, psizes, thick, line, $
            csizes, cthicks, corient, align, plabel_offset, label_colors, $
            label_points=label_points, plabels=plabels
 

 p = (convert_coord(points, /data, /to_device))[0:1,*]
 w = in_image(0, p, slop=1, $
    corners=transpose([transpose([0,0]), transpose([!d.x_size-1,!d.y_size-1])]))

 if(w[0] NE -1) then $
  begin
   ;-----------------------
   ; plot visible points
   ;-----------------------
   color = colors

   plots, points, psym=psyms, $
	   symsize=psizes, color=color, thick=thick, line=line, noclip=0

   ;-----------------------
   ; plot point labels
   ;-----------------------
   if(keyword_set(plabels)) then $
    begin
     if(keyword_set(label_points)) then $
      begin
       labels = plabels
       xyouts, points[0,*]+plabel_offset[0], $
	     points[1,*]+plabel_offset[1], $
	     labels, color=label_colors, $
	     charsize=csizes, charthick=cthicks, orient=corient, $
	     noclip=0, align=align
      end $
     else $
      begin
       xyouts, points[0,0]+plabel_offset[0], $
		 points[1,0]+plabel_offset[1], $
		 plabels, color=label_colors, $
		 charsize=csizes, charthick=cthicks, orient=corient, $
		 noclip=0, align=align
      end 
    end
  end


end
;=============================================================================




;=============================================================================
; pgdp_fill
;
;=============================================================================
function pgdp_fill, _val, n_objects, def=def, all=all

 if(n_elements(_val) NE 0 AND all) then $
      val=fill_array(n_objects, val=_val) $
 else val=fill_array(n_objects, val=_val, def=def)

 return, val
end
;=============================================================================




;=============================================================================
; pg_draw_point
;
;=============================================================================
pro pg_draw_point, _pp, literal=literal, $
             colors=_colors, psyms=_psyms, psizes=_psizes, plabels=_plabels, $
             xormode=xormode, csizes=_csizes, cthicks=_cthicks, wnum=wnum, shades=shades, $
             label_points=label_points, thick=_thick, line=_line, print=print, $
             label_shade=label_shade, align=_align, corient=_corient, label_color=label_color, $
             shade_threshold=shade_threshold
@pnt_include.pro

 if(keyword_set(print)) then print, print

 if(NOT keyword_set(_pp)) then return
 pp = reform(_pp)

 if(NOT keyword_set(label_shade)) then label_shade = 1.0
 if(NOT defined(_colors)) then _colors = ctwhite()
 if(keyword_set(wnum)) then wset, wnum


 ;---------------------------------------
 ; set up colors
 ;---------------------------------------
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

 xx = (convert_coord(double([0,5]), double([0,5]), /device, /to_data))[0:1,*]
 plabel_offset = abs([xx[0,0]-xx[0,1], xx[1,0]-xx[1,1]])
 all = NOT keyword_set(literal)



 ;------------------------------------------------------
 ; if inputs given as points array, draw and return
 ;------------------------------------------------------
 type = size(pp, /type)
 if(type NE 11) then $
  begin
   pgdp_draw, pp, $
       _colors, _psyms, _psizes, _thick, _line, $
       _csizes, _cthicks, _corient, _align, plabel_offset, label_colors, $
       label_points=label_points, plabels=plabels
   return
  end




 ;---------------------------------------------------------
 ; for POINT input, draw one-at-a-time
 ;---------------------------------------------------------
 pp = pnt_cull(pp, /nofree)
 n_objects = n_elements(pp)

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; if only one POINT given, but any attribute has 
 ; more than one element, explode the POINT object
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
 nval = 0
 if(n_objects EQ 1) then $
  begin
   nval = max([n_elements(_psyms), $
               n_elements(_psizes), $
               n_elements(_corient), $
               n_elements(_csizes), $
               n_elements(_cthicks), $
               n_elements(_align), $
               n_elements(_thick), $
               n_elements(_line), $
               n_elements(_plabels), $
               n_elements(_colors)])
   if(nval GT 1) then pp = pnt_explode(pp)
  end

 n_objects = n_elements(pp)


 ;- - - - - - - - - - - - - - - - -
 ; fill out attribute arrays
 ;- - - - - - - - - - - - - - - - -
 psyms = pgdp_fill(_psyms, n_objects, def=3, all=all)
 psizes = pgdp_fill(_psizes, n_objects, def=1.0, all=all)
 corient = pgdp_fill(_corient, n_objects, def=1.0, all=all)
 csizes = pgdp_fill(_csizes, n_objects, def=1.0, all=all)
 cthicks = pgdp_fill(_cthicks, n_objects, def=1.0, all=all)
 align = pgdp_fill(_align, n_objects, def=0.0, all=all)
 thick = pgdp_fill(_thick, n_objects, def=1, all=all)
 line = pgdp_fill(_line, n_objects, def=0, all=all)
 plabels = pgdp_fill(_plabels, n_objects, def='', all=all)
 colors = pgdp_fill(_colors, n_objects, def=!p.color, all=all)
 label_colors = pgdp_fill(label_colors*label_shade, n_objects, def=!p.color, all=all)


 if(keyword_set(xormode)) then device, set_graphics=6
;psyms = -psyms

 ;- - - - - - - - - - - - - - - - -
 ; plot arrays
 ;- - - - - - - - - - - - - - - - -
 for i=0, n_objects-1 do $
  begin
   ;- - - - - - - - - - - - - - - - -
   ; visible, unselected points
   ;- - - - - - - - - - - - - - - - -
   points = pnt_points(pp[i], /visible, /unselected, segments=segments)

   if(keyword_set(points)) then $
    begin

     for j=0, n_elements(segments)-1 do $
       pgdp_draw, points[*,segments[j].start:segments[j].stop], $
         colors[i], psyms[i], psizes[i], thick[i], line[i], $
         csizes[i], cthicks[i], corient[i], align[i], plabel_offset, label_colors[i], $
         label_points=label_points, plabels=plabels[i]

    end

   ;- - - - - - - - - - - - - - - - -
   ; visible, selected points
   ;- - - - - - - - - - - - - - - - -
   points = pnt_points(pp[i], /visible, /selected, segments=segments)

   if(keyword_set(points)) then $
    begin
     size = psizes[i]
     psym = psyms[i]
     th = thick[i]

     if(psym EQ 3) then $
      begin
       psym = 4
       size = 0.5
      end $
     else th = th*2 

     for j=0, n_elements(segments)-1 do $
       pgdp_draw, points[*,segments[j].start:segments[j].stop], $
         colors[i], psym, size, th, line[i], $
         csizes[i], cthicks[i], corient[i], align[i], plabel_offset, label_colors[i], $
         label_points=label_points, plabels=plabels[i]

    end

  end


 if(nval GT 1) then nv_free, pp
 if(keyword_set(xormode)) then device, set_graphics=3
end
;=============================================================================
