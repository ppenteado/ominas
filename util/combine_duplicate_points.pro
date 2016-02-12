;===========================================================================
; combine_duplicate_points
;
;===========================================================================
function combine_duplicate_points, _p, epsilon=epsilon

 p = _p

 if(NOT keyword__set(epsilon)) then epsilon = 1d 
 epsilon2 = epsilon^2
 np = n_elements(p)/2 

 ;-------------------------------------------------------
 ; compute distances between each pair of points
 ;-------------------------------------------------------
 i = lindgen(np)#make_array(np,val=1)
 j = transpose(i)

 x = p[0,*] & y = p[1,*]

 xdiff = x[i] - x[j]
 ydiff = y[i] - y[j]
 r2diff = xdiff^2 + ydiff^2

 ;-----------------------------------------------------------------------
 ; find points within epsilon of each other
 ;-----------------------------------------------------------------------
 w = where(r2diff LT epsilon2)
 if(w[0] EQ -1) then return, p

 nw = n_elements(w)
 ii = w / np	
 
 rm = bytarr(np)
 for l=0, np-1 do if(NOT rm[l]) then $
  begin
   ww = where(ii EQ l)
   if(ww[0] NE -1) then $
    begin
     nww = n_elements(ww)
     if(nww GT 1) then $
      begin
       ww = w[ww] mod np
       www = where(ww GT l)
       if(www[0] NE -1) then rm[ww[www]] = 1
      end
    end
  end

 rmi = where(rm EQ 1)
 if(n_elements(rmi) EQ np) then return, 0

 if(rmi[0] EQ -1) then return, p

 px = rm_list_item(p[0,*], rmi)
 py = rm_list_item(p[1,*], rmi)

 return, [transpose(px), transpose(py)]
end
;===========================================================================
