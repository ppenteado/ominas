;=============================================================================
;+
; NAME:
;	pg_trim
;
;
; PURPOSE:
;	For each given object, excludes points contained in the given region
;	by setting the PS_MASK_INVISIBLE.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_trim, dd, object_ps, region
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor containing the image.
;
;	object_ps:	Array (n_objects) of points_struct containing the
;			image points to be trimmed.
;
;	region:		Array of subscripts of image points to be trimmed.
;
;  OUTPUT:
;	object_ps:	The input points are be modified on return.
;
;
; KEYWORDS:
;  INPUT: 
;	mask:		Mask to use instead of PS_MASK_INVISIBLE.
;
;	off:		If set, the masked flag bit will be turned off.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	pg_select
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
pro pg_trim, dd, object_ps, region, mask=mask, off=off
@ps_include.pro

 if(region[0] EQ -1) then return
 if(NOT keyword_set(mask)) then mask = PS_MASK_INVISIBLE

 n_objects = n_elements(object_ps)

 ;----------------------------
 ; determine image size
 ;----------------------------
 xsize = !d.x_size
 ysize = !d.y_size
 device = 1

 if(keyword_set(dd)) then $
  begin
   image = nv_data(dd)
   s = size(image)
   xsize = s[1]
   ysize = s[2]
   device = 0
  end

 ;----------------------------
 ; trim each object
 ;----------------------------
 for i=0, n_objects-1 do $
  begin
   ;----------------------------------------------
   ; determine subscripts of elements not to trim
   ;----------------------------------------------
   points = ps_points(object_ps[i])
   flags = ps_flags(object_ps[i])

   if(keyword_set(flags) AND keyword_set(points)) then $
    begin
     if(device) then $
      points = (convert_coord(/data, /to_device, points))[0:1,*]

     nn = ps_nv(object_ps[i])
     nt = ps_nt(object_ps[i])
     points = reform(points, 2,nn*nt, /overwrite)
     flags = reform(flags, nn*nt, /overwrite)

     w = trim_region(points, region, xsize, ysize)

     ;-------------------------------------
     ; trim the points and vectors arrays
     ;-------------------------------------
     if(w[0] NE -1) then $
      begin
       if(NOT keyword_set(off)) then flags[w] = flags[w] OR mask $
       else flags[w] = flags[w] AND NOT mask
       flags = reform(flags, nn,nt, /overwrite)
       ps_set_flags, object_ps[i], flags
      end
    end

  end


end
;=============================================================================
