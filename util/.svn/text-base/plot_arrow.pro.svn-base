;=============================================================================
; plot_arrow
;
;  p0, p1 image points of source, target respectively
;  angle in radians
;
;  lpos is fractional distance along vector to center of label
;
;=============================================================================
pro plot_arrow, p0, p1, hsize=hsize, angle=angle, $
                         color=color, linestyle=linestyle, thick=thick, $
                         label=label, lpos=lpos, loffset=loffset, lsize=lsize, $
                         lrot=lrot, draw_wnum=draw_wnum, lcolor=lcolor

 if(NOT keyword_set(loffset)) then loffset = 0.1
 if(NOT keyword_set(lpos)) then lpos = 1.1
 if(NOT keyword_set(angle)) then angle = !dpi/6d
 if(NOT keyword_set(hsize)) then hsize = 10
 if(NOT keyword_set(color)) then color = ctwhite()
 if(NOT keyword_set(linestyle)) then linestyle = 0
 if(NOT keyword_set(thick)) then thick = 1
 if(NOT keyword_set(lcolor)) then lcolor = color

 ;-------------------------------------------
 ; compute the line
 ;-------------------------------------------
 pp0 = (convert_coord(double(p0[0]), double(p0[1]), /data, /to_device))[0:1]
 pp1 = (convert_coord(double(p1[0]), double(p1[1]), /data, /to_device))[0:1]


 ;-------------------------------------------
 ; compute the head
 ;-------------------------------------------
 theta = atan(p1[1] - p0[1], p1[0] - p0[0])
 angle1 = theta + angle
 angle2 = theta - angle

 q1 = [p1[0]-hsize*cos(angle1), p1[1]-hsize*sin(angle1)]
 q2 = [p1[0]-hsize*cos(angle2), p1[1]-hsize*sin(angle2)]
 qq1 = (convert_coord(double(q1[0]), double(q1[1]), /data, /to_device))[0:1]
 qq2 = (convert_coord(double(q2[0]), double(q2[1]), /data, /to_device))[0:1]


 ;-------------------------------------------
 ; compute the label position
 ;-------------------------------------------
 if(keyword_set(label)) then $
  begin
   len = p_mag(p1-p0)

   lx = p0[0] + loffset*len*sin(theta)
   ly = p0[1] - loffset*len*cos(theta)

   lx = lx + lpos*len*cos(theta)
   ly = ly + lpos*len*sin(theta)

   if(keyword_set(lrot)) then orient=-theta*180d/!dpi

   lxy = (convert_coord(double(lx), double(ly), /data, /to_device))[0:1]
   lxx = lxy[0]
   lyy = lxy[1]
  end


 ;-------------------------------------------
 ; draw
 ;-------------------------------------------
 wnum = !d.window
 if(defined(draw_wnum)) then wset, draw_wnum

 plots, [pp0[0], pp1[0]], [pp0[1], pp1[1]], $
         color=color, linestyle=linestyle, thick=thick, /device

 plots, [pp1[0], qq1[0]], [pp1[1], qq1[1]], $
         color=color, linestyle=linestyle, thick=thick, /device
 plots, [pp1[0], qq2[0]], [pp1[1], qq2[1]], $
         color=color, linestyle=linestyle, thick=thick, /device

 if(keyword_set(label)) then $
   xyouts, lxx, lyy, label, align=0.5, $
              orient=orient, charsize=lsize, color=lcolor, /device

 wset, wnum
end
;=============================================================================
