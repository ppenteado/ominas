;==============================================================================
; orb_plot
;
;
;==============================================================================
pro orb_plot, cd, _rd, frame_bx

 n = 1000d

 rd = nv_clone(_rd)
 bod_set_pos, rd, bod_pos(frame_bx)

 sma = orb_get_sma(rd)
 ecc = orb_get_ecc(rd)
 dmadt = orb_get_dmadt(rd)

 Q = (sma*(1d - ecc))[0]

 ;-------------------------------------------------
 ; plot axes
 ;-------------------------------------------------
 origin = bod_pos(rd)
 origins = origin##make_array(3,val=1d)
 plot_inertial, cd, origins, Q*bod_orient(bod_inertial()), $
                                  col=ctwhite(), th=1, labels=['0','1','2']
 plot_inertial, cd, origins, Q*bod_orient(frame_bx), $
                                  col=ctyellow(), th=1, labels=['0','1','2']

 iframe_bx = orb_inertialize(frame_bx)
 plot_inertial, cd, origins, Q*bod_orient(iframe_bx), $
                                  col=ctcyan(), th=1, labels=['0','1','2']

 ;-------------------------------------------------
 ; plot orbit points
 ;-------------------------------------------------
 f = lindgen(n) / n * 2d*!dpi
 orb_pts_inertial = tr(orb_to_cartesian(rd, f=f))

 org = origin ## make_array(n,val=1d)
 zz = (bod_orient(frame_bx))[2,*] ## make_array(n,val=1d)

 w = where(v_inner(orb_pts_inertial - org, zz) LT 0)
 orb_pts_image = degen(inertial_to_image_pos(cd, orb_pts_inertial))

 plots, orb_pts_image, col=ctblue()
 if(w[0] NE -1) then plots, orb_pts_image[*,w], col=ctpurple()


 ;-------------------------------------------------
 ; plot elements
 ;-------------------------------------------------
 plot_inertial, cd, origin, $
                        Q*orb_get_ascending_node(rd, frame_bx), col=ctpurple()

 orient = bod_orient(rd)
 plot_inertial, cd, origin, Q*orient[0,*], col=ctgreen() 
 plot_inertial, cd, origin, Q*orient[2,*], col=ctred() 

 pt_inertial = orb_to_cartesian(rd)
 pt_image = degen(inertial_to_image_pos(cd, pt_inertial))
 plots, pt_image, col=ctwhite(), psym=4



 rdt = nv_clone(rd)
 dt = -2d*!dpi/dmadt /100d
 ntail = 4 

 for i=0, ntail-1 do $
  begin
   mat = orb_evolve_ma(rdt, dt)
   orb_set_ma, rdt, mat

   pt_inertial = orb_to_cartesian(rdt)
   pt_image = degen(inertial_to_image_pos(cd, pt_inertial))
   plots, pt_image, col=ctwhite(), psym=4, symsize=0.5
  end

 nv_free, rdt


 ;-------------------------------------------------
 ; print, legend
 ;-------------------------------------------------
 print,    'Blue:		orbit points above frame x-y plane'
 print,    'White:		inertial axes'
 print,    'Yellow:		frame axes'
 print,    'Cyan:		inertialized frame axes'
 print,    'Purple:		ascending node'
 print,    'Green:		periapse'
 print,    'Red:		orbit normal'



 nv_free, rd
end
;==============================================================================
