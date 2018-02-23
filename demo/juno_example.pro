compile_opt idl2,logical_predicate

;read data
;dd=dat_read('JNCE_2017139_06C00114_V01-raw.png')
;dd=dat_read('JNCE_2018038_11C00050_V01-raw.png')
;dd=dat_read('JNCE_2017033_04C00100_V01-raw.png')
dd=dat_read('data/JNCE_2017192_07C00059_V01-raw.png')

;get camera, planet, sun descriptors
cd=pg_get_cameras(dd,/tr_nosort)
nframes=n_elements(cd)
ddn=replicate(dd,nframes)

;create 2d data descriptors for use in the map routines
da=dat_data(dd)
for i=0,nframes-1 do begin
  print,i,':'
  ddn[i]=nv_clone(dd[0])
  dat_set_data,ddn[i],da[*,*,i]
endfor

;planet and sun descriptors
pd=pg_get_planets(ddn,od=cd,name='JUPITER',/tr_nosort)
sd=pg_get_stars(ddn,od=cd,name='SUN',/tr_nosort)

;calculate limbs
gd=replicate({cd:obj_new(),gbx:obj_new(),ltd:obj_new()},nframes)
gd.cd=cd
gd.gbx=pd
gd.ltd=sd

limb_ps=objarr(nframes)
edge_ps=objarr(nframes)
for i=0,nframes-1 do limb_ps[i]=pg_limb(gd=gd[i])
for i=0,nframes-1 do edge_ps[i]=pg_edges(ddn[i],edge=2)

;find which frame shows the most limb and edge pixels
limbpts=lonarr(nframes)
edgepts=lonarr(nframes)
for i=0,nframes-1 do begin
  pnt=pnt_points(limb_ps[i])
  w=where((pnt[0,*] ge 0) and (pnt[1,*] ge 0) and (pnt[0,*] le 1648) and (pnt[1,*] le 127),c)
  limbpts[i]=c
  pnt=pnt_points(edge_ps[i])
  w=where((pnt[0,*] ge 0) and (pnt[1,*] ge 0) and (pnt[0,*] le 1648) and (pnt[1,*] le 127),c)
  edgepts[i]=c  
endfor
!null=max(limbpts,maxlimb)
w=where(edgepts lt 20000)
!null=max(edgepts[w],maxedge)
maxedge=w[maxedge]


;make some images with the limb
tvim,dat_data(ddn[maxlimb]),/new
pg_draw,limb_ps[maxlimb],color='red'
pg_draw,edge_ps[maxlimb],color='green'

tvim,dat_data(ddn[maxedge]),/new
pg_draw,limb_ps[maxedge],color='red'
pg_draw,edge_ps[maxedge],color='green'


;dxy=pg_farfit(ddn[maxedge],edge_ps[maxedge],[limb_ps[maxedge]])

;create very low res full disk mosaic
map_xsize = 1000*2
map_ysize = 500*2

md = pg_get_maps(/over ,gbx = pd[0], name='JUPITER',projection='RECTANGULAR',$
  fn_data=ptr_new(),size=[map_xsize,map_ysize],origin=[map_xsize,map_ysize]/2)
dd_map = objarr(nframes)

;project each frame
for i=0, nframes-1 do begin
  print,'mapping ',i
  dd_map[i] = pg_map(ddn[i], md=md, gd=gd[i], aux=['EMM'])
endfor

;make the mosaic for each channel
ddm=objarr(3)
for i=0,2 do ddm[i]=pg_mosaic(dd_map[0+i:-1:3],mosaic=mosaic,comb='mean',data={x:1, emm0:cos(90d*!dpi/180d)})
ddim=dblarr(map_xsize,map_ysize,3)

;make the RGB image - note that band order for the camera is BGR
for i=0,2 do ddim[*,*,2-i]=dat_data(ddm[i])


end
