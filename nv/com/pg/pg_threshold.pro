;=============================================================================
;+
; NAME:
;	pg_threshold
;
;
; PURPOSE:
;	Excludes points whose associated data lie outside of specified
;	thresholds by setting the PTD_MASK_INVISIBLE.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_threshold, object_ptd, tag=tag, max=max, min=min
;
;
; ARGUMENTS:
;  INPUT:
;	object_ptd:	Array (n_objects) of POINT giving the
;			points to be thresholded.
;
;  OUTPUT:
;	object_ptd:	Modified array of POINT.  PTD_MASK_INVISIBLE
;			is set for all excluded points.
;
;
; KEYWORDS:
;  INPUT:
;	tag:		Tag name for user data array to threshold.  Default
;			is 'scan_cc'.
;
;	max:		Upper threshold - values greater than this will be
;			excluded.
;
;	min:		Lower threshold - values less than this will be
;			excluded.
;
;	relative:	If set, the max and min arguments will be taken as 
;			fractions of the maximum value in the array.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; SIDE EFFECTS:
;	The input argument object_ptd is modified.
;
;
; RESTRICTIONS:
;	xx
;
;
; PROCEDURE:
;	The thresholding is performed by cc_threshold.  See the documentation
;	for that routine for details.
;
;
; EXAMPLE:
;	xx
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/1998
;	
;-
;=============================================================================
pro pg_threshold, scan_ptd, tag=tag, min=min, max=max, relative=relative
@pnt_include.pro

 n_objects=n_elements(scan_ptd)

 if(n_elements(min) EQ 0) then min = 0.5
 if(n_elements(min) NE n_objects) then min = make_array(n_objects, val=min[0])

 if(n_elements(max) EQ 0) then max = 1.5
 if(n_elements(max) NE n_objects) then max = make_array(n_objects, val=max[0])

 if(NOT keyword__set(tag)) then tag='scan_cc'


 ;----------------------------
 ; threshold all objects
 ;----------------------------
 for i=0, n_objects-1 do if(pnt_valid(scan_ptd[i])) then $
  begin
   pnt_get, scan_ptd[i], data=scan_data, flags=flags, tags=tags

   sub = -1
   if(keyword__set(tags)) then sub = where(tags EQ tag)
   if(sub[0] NE -1) then $
    begin
     ;---------------------------------
     ; get correlation coefficients
     ;---------------------------------
     cc = scan_data[sub[0],*]

     ;--------------------
     ; apply thresholds
     ;--------------------
     w = cc_threshold(cc, min=min[i], max=max[i], relative=relative)

     if(w[0] NE -1) then $
      begin
       flags[w]=flags[w] OR PTD_MASK_INVISIBLE
       pnt_set_flags, scan_ptd[i], flags
      end

    end
  end



end
;=============================================================================
