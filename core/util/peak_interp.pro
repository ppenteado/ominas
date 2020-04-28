;===============================================================================
; peak_interp
;
;  Finds x coordinate of max using a parabolic interpolation.
;
;===============================================================================
function peak_interp, _x, _y, min=min, ymax=ymax, width=width, alpha=alpha, $
            status=status, nsig=nsig

 status = -1
 if(NOT keyword_set(alpha)) then alpha = 0.5d
 if(NOT keyword_set(nsig)) then nsig = 1d


 ;------------------------------------------------------
 ; find raw peak
 ;------------------------------------------------------
 x = _x & y = _y
 n = n_elements(x)

 done = 0
 while(NOT done) do $
  begin
   y1 = max(y)
   if(keyword_set(min)) then y1 = min(y)
   w = where(y EQ y1)

   if(w[0] EQ 0) then $
    begin
     y = y[1:*] 
     x = x[1:*]
    end $
   else if(w[0] EQ n-1) then $
    begin
     y = y[0:n-2]
     x = x[0:n-2]
    end $
   else done = 1

   n = n_elements(x)
   if(n LT 3) then return, 0
  end


 ;----------------------------------------
 ; find interpolated peak
 ;----------------------------------------
 x1 = x[w]
 x2 = x[w-1]
 x3 = x[w+1]

 y2 = y[w-1]
 y3 = y[w+1]

 a = ((x2-x3)*(y1-y2) - (x1-x2)*(y2-y3)) / $
     ((x2-x3)*(x1^2-x2^2) - (x1-x2)*(x2^2-x3^2))
 
 b = ((x2^2-x3^2)*(y1-y2) - (x1^2-x2^2)*(y2-y3)) / $
     ((x2^2-x3^2)*(x1-x2) - (x1^2-x2^2)*(x2-x3))

 c = y1 - a*x1^2 - b*x1

 xmax = (-b/(2d*a))[0]
 ymax = (a*xmax^2 + b*xmax + c)[0]


 ;-------------------------------------------------------------------
 ; width of parabola at height alpha*ymax
 ;-------------------------------------------------------------------
 if(arg_present(width)) then width = sqrt((1d - alpha)*(b^2 - 4d*a*c))/a


 ;-----------------------------------------------
 ; noise threshold
 ;-----------------------------------------------
 sig = stdev(y-smooth(y,2))
 y0 = y[where(x LT xmax)]
 y1 = y[where(x GT xmax)]

 if((ymax-min(y0) LT nsig*sig) OR (ymax-min(y1) LT nsig*sig)) then return, 0



 status = 0
 return, xmax
end
;===============================================================================
