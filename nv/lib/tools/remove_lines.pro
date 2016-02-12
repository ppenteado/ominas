;===========================================================================
; remove_lines
;
;===========================================================================
function remove_lines, ps, lines, slop=slop
@ps_include.pro

 if(NOT keyword__set(lines)) then return, ps
 if(NOT keyword__set(slop)) then slop = 1

 nlines = n_elements(lines)/2

 p = ps_points(ps)
 f = ps_flags(ps)

 for i=0, nlines-1 do $
  begin
   w = where((p[1,*] GE lines[0,i]-slop) AND (p[1,*] LE lines[1,i]+slop))
   if(w[0] NE -1) then ww = append_array(ww, w)
  end

 if(keyword__set(ww)) then f[ww] = f[ww] OR PS_MASK_INVISIBLE
 ps_set, ps, p=p, f=f

 return, ps
end
;===========================================================================



