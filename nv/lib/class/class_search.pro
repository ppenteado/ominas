;===========================================================================
; class_search
;
; This routine is meant to called internally only.
;
; All objects must belong to the same class since only the first object
; is searched.
;
; returns -1 if class not found
;
;===========================================================================
function class_search, ods, class, od_super=od_super

 n = n_elements(ods)

 od = ods

 i=0
 while(od[0].class NE class) do $
  begin
   if(NOT ptr_valid(od[0].(0))) then return, -1
   if(size(*(od[0].(0)), /type) NE 8) then return, -1
   od_super = od
   od = make_array(n, val=*(od[0].(0)))
   for j=0, n-1 do od[j] = *(od_super[j].(0))
   i = i + 1
  end


 return, i
end
;===========================================================================



