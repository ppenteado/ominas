;===========================================================================
; class_insert
;
;
;===========================================================================
pro class_insert, odp, cld, class, copy=copy, noevent=noevent
 od = nv_dereference(odp)

 n = n_elements(od)
 i = class_search(od, class)

 if(i EQ -1) then return

 if(keyword__set(copy)) then $
  case i of $
   0 : nv_copy, odp, cld
   1 : nv_copy, od.(0), cld
   2 : for j=0, n-1 do $
        nv_copy, (*od[j].(0)).(0), cld[j]
   3 : for j=0, n-1 do $
        nv_copy, (*(*od[j].(0)).(0)).(0), cld[j]
   4 : for j=0, n-1 do $
        nv_copy, (*(*(*od[j].(0)).(0)).(0)).(0), cld[j]
   5 : for j=0, n-1 do $
        nv_copy, (*(*(*(*od[j].(0)).(0)).(0)).(0)).(0), cld[j]
   6 : for j=0, n-1 do $
            nv_copy, $
                         (*(*(*(*(*od[j].(0)).(0)).(0)).(0)).(0)).(0), cld[j]
   6 : for j=0, n-1 do $
            nv_copy, $
                   (*(*(*(*(*(*od[j].(0)).(0)).(0)).(0)).(0)).(0)).(0), cld[j]
   else : return
  endcase $
 else $
  case i of $
   0 : odp = cld
   1 : for j=0, n-1 do od[j].(0) = cld[j]
   2 : for j=0, n-1 do (*od[j].(0)).(0) = cld[j]
   3 : for j=0, n-1 do (*(*od[j].(0)).(0)).(0) = cld[j]
   4 : for j=0, n-1 do (*(*(*od[j].(0)).(0)).(0)).(0) = cld[j]
   5 : for j=0, n-1 do (*(*(*(*od[j].(0)).(0)).(0)).(0)).(0) = cld[j]	 
   6 : for j=0, n-1 do (*(*(*(*(*od[j].(0)).(0)).(0)).(0)).(0)).(0) = cld[j]
   7 : for j=0, n-1 do (*(*(*(*(*(*od.(0)).(0)).(0)).(0)).(0)).(0)).(0) = cld[j]
   else : return
  endcase


 nv_rereference, odp, od
 nv_notify, odp, type = 0, noevent=noevent
end
;===========================================================================



