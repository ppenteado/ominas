;=============================================================================
;+
; NAME:
;	pg_trim
;
;
; PURPOSE:
;	For each given object, excludes points contained in the given region
;	by setting the PTD_MASK_INVISIBLE.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_trim, dd, object_ptd, region
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor containing the image.
;
;	object_ptd:	Array (n_objects) of POINT containing the
;			image points to be trimmed.
;
;	region:		Array of subscripts of image points to be trimmed.
;
;  OUTPUT:
;	object_ptd:	The input points are be modified on return.
;
;
; KEYWORDS:
;  INPUT: 
;	mask:		Mask to use instead of PTD_MASK_INVISIBLE.
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
pro pg_trim, dd, object_ptd, region, mask=mask, off=off
@pnt_include.pro

 if(region[0] EQ -1) then return
 if(NOT keyword_set(mask)) then mask = PTD_MASK_INVISIBLE

 n_objects = n_elements(object_ptd)

 ;----------------------------
 ; determine image size
 ;----------------------------
 xsize = !d.x_size
 ysize = !d.y_size
 device = 1

 if(keyword_set(dd)) then $
  begin
   image = dat_data(dd)
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
   points = pnt_points(object_ptd[i])
   flags = pnt_flags(object_ptd[i])

   if(keyword_set(flags) AND keyword_set(points)) then $
    begin
     if(device) then $
      points = (convert_coord(/data, /to_device, points))[0:1,*]

     nn = pnt_nv(object_ptd[i])
     nt = pnt_nt(object_ptd[i])
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
       pnt_set_flags, object_ptd[i], flags
      end
    end

  end


end
;=============================================================================
