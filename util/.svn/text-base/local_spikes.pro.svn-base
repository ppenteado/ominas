;=============================================================================
; local_spikes
;
;=============================================================================
function local_spikes, image, pp, nsig, scale, f=f

 width = f*scale

 p = long(pp)
 s = size(image)
 w_2 = long(width/2)
 s_2 = long(scale/2)

 ;-------------------------------------------------
 ; adjust center so subimages stay within image
 ;-------------------------------------------------
 p[0] = (p[0]) > (w_2+1)
 p[0] = (p[0]) < (s[1]-w_2-1)
 p[1] = (p[1]) > (w_2+1)
 p[1] = (p[1]) < (s[2]-w_2-1)

 ;-------------------------------------------------
 ; extract subimages
 ;-------------------------------------------------
 local_image = image[p[0]-w_2:p[0]+w_2, p[1]-w_2:p[1]+w_2]
 sub_image = image[pp[0]-s_2:pp[0]+s_2, pp[1]-s_2:pp[1]+s_2]

 ;-----------------------------------------------------
 ; flag all points greater than nsig above local mean
 ;-----------------------------------------------------
 sig = stdev(local_image, mean)
 w = where(sub_image GT mean+nsig*sig)

 if(w[0] EQ -1) then return, 0

 q = w_to_xy(sub_image, w)
 q[0,*] = q[0,*] + pp[0]-s_2
 q[1,*] = q[1,*] + pp[1]-s_2

 return, q
end
;=============================================================================
