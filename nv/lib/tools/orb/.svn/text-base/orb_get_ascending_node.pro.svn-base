;===========================================================================
; orb_get_ascending_node
;
;  Returns inertial vectors.
;
;  Note the call to orb_inertialize may cause a recursive call to this routine
; 
;===========================================================================
function orb_get_ascending_node, xd, frame_bd, arbitrary=w, ref=ref, safe=safe

; epsilon = 1d-14
; epsilon = 1d-7
 epsilon = 1d-12

 nt = n_elements(xd)

 iframe_bd = frame_bd
 if(NOT keyword_set(safe)) then iframe_bd = orb_inertialize(frame_bd)

 bd = class_extract(xd, 'BODY')
 zz = (bod_orient(bd))[2,*,*]					; 1 x 3 x nt
 xx = (bod_orient(bd))[0,*,*]					; 1 x 3 x nt

 if(n_elements(iframe_bd) EQ 1) then $
  begin
   iframe_zz = (bod_orient(iframe_bd))[2,*]##make_array(nt, val=1d) ; nt x 3
   iframe_zz = reform(transpose(iframe_zz), 1,3,nt, /over)	  ; 1 x 3 x nt
   iframe_xx = (bod_orient(iframe_bd))[0,*]##make_array(nt, val=1d) ; nt x 3
   iframe_xx = reform(transpose(iframe_xx), 1,3,nt, /over)	  ; 1 x 3 x nt
  end $
 else $
  begin
   iframe_zz = (bod_orient(iframe_bd))[2,*,*]			; 1 x 3 x nt
   iframe_xx = (bod_orient(iframe_bd))[0,*,*]			; 1 x 3 x nt
  end

 if(NOT keyword_set(ref)) then ref = iframe_xx

 dot = v_inner(iframe_zz, zz)

 node = dblarr(1,3,nt)

 ;--------------------------------------------
 ; try to detect zero-inclination case
 ;--------------------------------------------
 ww = where(abs(dot-1d) GE epsilon)
; if(ww[0] NE -1) then node[0,*,ww] = v_unit(v_cross(iframe_zz[0,*,ww], zz[0,*,ww]))
 if(ww[0] NE -1) then node[0,*,ww] = v_unit(v_cross(iframe_zz[0,*,ww], zz[0,*,ww]))

 w = where(abs(dot-1d) LT epsilon)
 if(w[0] NE -1) then node[0,*,w] = ref[0,*,w]

 ;--------------------------------------------------------
 ; if we still have a degeneracy problem, then fix it
 ;--------------------------------------------------------
 test = total(node,2)
 if(nt GT 1) then test = total(test,1)
 www = complement(test, where(finite(test)))  
 if(www[0] NE -1) then node[0,*,www] = ref[0,*,www]
 www = where(test EQ 0)
 if(www[0] NE -1) then node[0,*,www] = ref[0,*,www]


 if(NOT keyword_set(safe)) then nv_free, iframe_bd

 return, node
end
;===========================================================================



;===========================================================================
; orb_get_ascending_node
;
;  Returns inertial vectors.
;
;===========================================================================
function _orb_get_ascending_node, xd, frame_bd, arbitrary=w, ref=ref

 nt = n_elements(xd)

 epsilon = 1d-15

 bd = class_extract(xd, 'BODY')
 zz = (bod_orient(bd))[2,*,*]					; 1 x 3 x nt
 xx = (bod_orient(bd))[0,*,*]					; 1 x 3 x nt

 if(NOT keyword_set(ref)) then  ref = xx

 if(n_elements(frame_bd) EQ 1) then $
  begin
   frame_zz = (bod_orient(frame_bd))[2,*]##make_array(nt, val=1d) ; nt x 3
   frame_zz = reform(transpose(frame_zz), 1,3,nt, /over)	  ; 1 x 3 x nt
   frame_xx = (bod_orient(frame_bd))[0,*]##make_array(nt, val=1d) ; nt x 3
   frame_xx = reform(transpose(frame_xx), 1,3,nt, /over)	  ; 1 x 3 x nt
  end $
 else $
  begin
   frame_zz = (bod_orient(frame_bd))[2,*,*]			; 1 x 3 x nt
   frame_xx = (bod_orient(frame_bd))[0,*,*]			; 1 x 3 x nt
  end

 dot = v_inner(frame_zz, zz)

 node = dblarr(1,3,nt)
 w = where(abs(dot-1d) LT epsilon)
 ww = where(abs(dot-1d) GE epsilon)
 if(ww[0] NE -1) then $
  begin
   sub = colgen(1,3,nt, ww) 
   vc = v_cross(frame_zz[sub], zz[sub])

   www = where(v_mag(vc) LT epsilon)
   if(www[0] NE -1) then $
    begin
     ss = colgen(1,3,nt, ww[www]) 
     node[ss] = frame_xx[ss] 
    end

   www = where(v_mag(vc) GE epsilon) 
   if(www[0] NE -1) then $
    begin
     ss = colgen(1,3,nt, ww[www]) 
     node[ss] = v_unit(vc[ww[www],*])
;     node[ss] = v_unit(vc)
    end

;   node[sub] = v_unit(vc)
  end

 if(w[0] NE -1) then $
  begin
   sub = colgen(1,3,nt, w) 
;   node[sub] = xx[sub]
   node[sub] = ref[sub]
  end


 return, node
end
;===========================================================================
