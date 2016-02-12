;=============================================================================
;+
; NAME:
; 	ps_write
;
;
; PURPOSE:
; 	Writes a point structure to a file.
;
;
; CATEGORY:
; 	NV/ps
;
;
; CALLING SEQUENCE:
; 	ps_write, filename, ps
;
;
; ARGUMENTS:
;  INPUT:
; 	filename:	Name of the point structure file to write.
;
;	ps:		Points structure to write.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
; 	bin:	If set, a binary point structure file is written;
; 		not currently implemented.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; SEE ALSO:
;	ps_read
;
;
; MODIFICATION HISTORY:
;  Spitale, 11/2015; 	Adapted from pgs_write_ps
; 
;-
;=============================================================================
pro ps_write, filename, psp, bin=bin
 nv_notify, psp, type = 1
 ps = nv_dereference(psp)

 openw, unit, filename, /get_lun

 printf, unit, 'protocol 1.1'
 if(keyword_set(bin)) then printf, unit, 'binary'

 nps = n_elements(ps)
 printf, unit, 'nps = ' + strtrim(nps,2)

 ;---------------------------------------------
 ; add each points structure
 ;---------------------------------------------
 for i=0, nps-1 do $
  begin
   ;- - - - - - - - - - - - - - - - -
   ; descriptive info
   ;- - - - - - - - - - - - - - - - -
   printf, unit
   printf, unit, 'name = ' + ps[i].name
   printf, unit, ' desc = ' + ps[i].desc
   printf, unit, ' input = ' + ps[i].input


   n = ps_nv(ps[i])
   printf, unit, ' n = ' + strtrim(n,2)

   ;- - - - - - - - - - - - - - - - -
   ; image points
   ;- - - - - - - - - - - - - - - - -
   if(ptr_valid(ps[i].points_p)) then $
    begin
     printf, unit, ' points:'

     points = *ps[i].points_p
     if(keyword_set(bin)) then writeu, unit, points $
     else $
      printf, unit, '  ' + strtrim(points[0,*],2) + ' ' + $
                           strtrim(points[1,*],2) 
    end

   ;- - - - - - - - - - - - - - - - -
   ; vectors
   ;- - - - - - - - - - - - - - - - -
   if(ptr_valid(ps[i].vectors_p)) then $
    begin
     printf, unit, ' vectors:' 

     vectors = *ps[i].vectors_p
     if(keyword_set(bin)) then writeu, unit, vectors $
     else $
      printf, unit, '  ' + tr( strtrim(vectors[*,0],2) + ' ' + $
                               strtrim(vectors[*,1],2) + ' ' + $
                               strtrim(vectors[*,2],2) )
    end

   ;- - - - - - - - - - - - - - - - -
   ; point data
   ;- - - - - - - - - - - - - - - - -
   if(ptr_valid(ps[i].data_p)) then $
    begin
     data = *ps[i].data_p
     s = size(data)
     ndim = s[0]

     if(ndim EQ 1) then data = tr(data)
     s = size(data)
     ndim = s[0]

     if(ndim GT 2) then nv_message, name='ps_write', $
                           'Point data may have no more than 2 dimensions.'
     s = s[1:s[0]]
     w = where(s EQ n)
     if(w[0] EQ -1) then nv_message, name='ps_write', $
                                                 'Inconsistent point data.'
     nn = 1
     ww = where(s NE n)
     if(ww[0] NE -1) then nn = s[ww]

     printf, unit, ' point data:', nn

     if(keyword_set(bin)) then writeu, unit, data $
     else $
      begin
       data_s = strtrim(data,2)
       if(ndim NE 1) then  $
        begin
         if(w[0] EQ 0) then data_s = tr(data_s)
         bb = byte(data_s + ' ')
         sbb = size(bb)
         bbb = reform(bb, sbb[1]*sbb[2], sbb[3])
         ww = where(bbb EQ 0)
         if(ww[0] NE -1) then bbb[ww] = byte(' ')
         data_s = string(bbb)
        end

       printf, unit, '  ' + tr(data_s)
      end
    end

   ;- - - - - - - - - - - - - - - - -
   ; generic user data
   ;- - - - - - - - - - - - - - - - -
   if(ptr_valid(ps[i].udata_tlp)) then $
    begin
     printf, unit, ' udata:'
     tag_list_write, ps[i].udata_tlp, unit=unit, bin=bin
    end


   ;- - - - - - - - - - - - - - - - -
   ; point-by-point user data
   ;- - - - - - - - - - - - - - - - -
   if(ptr_valid(ps[i].tags_p)) then $
    begin
     printf, unit, ' tags:'
     printf, unit, '  ' + tr(strtrim(*ps[i].tags_p,2))
    end

   ;- - - - - - - - - - - - - - - - -
   ; flags
   ;- - - - - - - - - - - - - - - - -
   if(ptr_valid(ps[i].flags_p)) then $
    begin
     printf, unit, ' flags:'

     flags = fix(*ps[i].flags_p)
     if(keyword_set(bin)) then writeu, unit, flags $
     else printf, unit, '  ' + tr(strtrim(flags,2))
    end
  end

 close, unit
 free_lun, unit

end
;===========================================================================



