;===========================================================================
; remove_lines
;
;===========================================================================
function remove_lines, ptd, lines, slop=slop
@pnt_include.pro

 if(NOT keyword__set(lines)) then return, ptd
 if(NOT keyword__set(slop)) then slop = 1

 nlines = n_elements(lines)/2

 p = pnt_points(ptd)
 f = pnt_flags(ptd)

 for i=0, nlines-1 do $
  begin
   w = where((p[1,*] GE lines[0,i]-slop) AND (p[1,*] LE lines[1,i]+slop))
   if(w[0] NE -1) then ww = append_array(ww, w)
  end

 if(keyword__set(ww)) then f[ww] = f[ww] OR PTD_MASK_INVISIBLE
 pnt_set, ptd, p=p, f=f

 return, ptd
end
;===========================================================================



