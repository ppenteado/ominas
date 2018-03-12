compile_opt idl2,logical_predicate

;read data
;dd=dat_read('JNCE_2017139_06C00114_V01-raw.png')
;dd=dat_read('JNCE_2018038_11C00050_V01-raw.png')
;dd=dat_read('JNCE_2017033_04C00100_V01-raw.png')
dd=dat_read(getenv('OMINAS_DIR')+'/demo/data/JNCE_2017192_07C00059_V01-raw.png')

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
map_xsize = 1000
map_ysize = 500

md=pg_get_maps(/over ,gbx = pd[0], name='JUPITER',projection='RECTANGULAR',$
  fn_data=ptr_new(),size=[map_xsize,map_ysize],origin=[map_xsize,map_ysize]/2,$
  range=[[-0.5d0,0.5d0],[-1d0,1d0]]*!dpi)


;project each frame
dd_map = objarr(nframes)
mos=dblarr(map_xsize,map_ysize,3) ;array for the 3 mosaics
counts=lonarr(map_xsize,map_ysize,3)
np=lonarr(nframes)
mapslr=bytarr(map_xsize,map_ysize,nframes)
for icol=0,2 do begin
  ;array for the count of how many pixels were added
  count=lonarr(map_xsize,map_ysize) 
  ;array where each frame is added to
  most=dblarr(map_xsize,map_ysize)
  for i=icol,nframes-1,3 do begin
    mtmp=pg_map(ddn[i],md=md,gd=gd[i],map=maptmp)
  
    ;dd_map[i]=mtmp
    
    ;add frame to mosaic, so it can be thrown away
    mapslr[*,*,i]=maptmp ne maptmp[0]*0
    w=where(mapslr[*,*,i],c)
    np[i]=c
    if c then begin
      count[w]+=1
      most[w]+=maptmp[w]      
    endif
    print,'mapped ',i,c
  endfor
  w=where(count,c)
  if c then most[w]/=count[w]
  mos[*,*,2-icol]=most
  counts[*,*,2-icol]=count
endfor


;now, use that low res mosaic to determine coverage for high res
;find area where covered by all 3 bands
countc=total((counts gt 0),3) eq 3
w=where(countc,c)
ai=array_indices(countc,w)

xrange=minmax(ai[0,*])
yrange=minmax(ai[1,*])

;limit latitude to bewtween +-75degrees
latlimit=75d0
xrangelim=fix([floor(map_xsize*((90-latlimit)/180)),ceil(map_xsize*((90+latlimit)/180)-1)])
xrange[0]=max([xrange[0],xrangelim[0]])
xrange[1]=min([xrange[1],xrangelim[1]])

new_range=map_image_to_map(md,[[xrange[0],yrange[0]],[xrange[1],yrange[1]]])
;new_range is [[minlat,minlon],[maxlat,maxlon]]
nmap_xsize=xrange[1]-xrange[0]+1
nmap_ysize=yrange[1]-yrange[0]+1
mapslr=mapslr[xrange[0]:xrange[1],yrange[0]:yrange[1],*]

;resolution scale factor for the high res maps
mfac=64 ;needs to be less than 63 so that the value nmap_xsize*nmap_ysize is LONG
nmap_xsize*=mfac
nmap_ysize*=mfac

;build the high res map descriptor
nmd=pg_get_maps(/over ,gbx = pd[0], name='JUPITER',projection='RECTANGULAR',$
  fn_data=ptr_new(),size=[nmap_xsize,nmap_ysize],origin=[nmap_xsize,nmap_ysize]/2,$
  center=mean(new_range,dimension=2),$
  units=[map_ysize*1d0/nmap_ysize,map_xsize*1d0/nmap_xsize],scale=mfac)
;map_set_range,nmd,newrange


;project each frame
ndd_map=objarr(nframes)
nmos=dblarr(nmap_xsize,nmap_ysize,3) ;array for the 3 mosaics
ncounts=lonarr(nmap_xsize,nmap_ysize,3)
ddm=objarr(3)
ndd_maps=[list(),list(),list()]
s=replicate(1,3,3)
t00=systime(/seconds)
for icol=0,2 do begin ;loop on filters
  ;array for the count of how many pixels were added
  ncount=lonarr(nmap_xsize,nmap_ysize)
  ;array where each frame is added to
  nmost=dblarr(nmap_xsize,nmap_ysize)
  for i=icol,nframes-1,3 do begin ;loop on frames for each filter
    t=systime(/seconds)
    if (np[i] eq 0) then continue ;skip frame if nothing to map
    mapr=mapslr[*,*,i]
    maprd=dilate(mapr,s)
    maprd=congrid(maprd,nmap_xsize,nmap_ysize)
    roi=where(maprd)
    mtmp=pg_map(ddn[i],md=nmd,gd=gd[i],map=maptmp,roi=roi,pc_xsize=nmap_xsize,pc_ysize=nmap_ysize)
    ;keep frame, to use in pg_mosaic - will use a lot more time and memory
    (ndd_maps[icol]).add,mtmp ; comment this line to turn off pg_mosaic algorithm
    ;add frame to mosaic, so it can be thrown away
    w=where(maptmp ne maptmp[0]*0,c)
    if c then begin
      ncount[w]+=1
      nmost[w]+=maptmp[w]
    endif
    print,'mapped frame ',strtrim(i,2),' with ',strtrim(c,2),' pixels in ',strtrim(systime(/seconds)-t,2),' s'
  endfor
  
  ;make the mosaic for the channel using just data array
  w=where(ncount,c)
  if c then nmost[w]/=ncount[w]
  nmos[*,*,2-icol]=nmost
  ncounts[*,*,2-icol]=ncount
  
  ;make the mosaic for the channel using ddm
  if n_elements(ndd_maps[icol]) then ddm[icol]=pg_mosaic((ndd_maps[icol]).toarray(),mosaic=mosaic,comb='mean')
  ;throw away the maps for this band
  ltmp=ndd_maps[icol]
  ndd_maps[icol]=obj_new()
  for ind=0,n_elements(ltmp)-1 do ltmp[ind]=obj_new() 
endfor
t01=systime(/seconds)
print,'hi res loop done in ',strtrim(t01-t00,2),' s'
 
;make the RGB image - note that band order for the camera is BGR
if obj_valid(ddm[0])  then begin
  ddim=dblarr(nmap_xsize,nmap_ysize,3)
  for i=0,2 do ddim[*,*,2-i]=dat_data(ddm[i])
endif

;remap onto full map
fmap_xsize=map_xsize*mfac
fmap_ysize=map_ysize*mfac
fmd=pg_get_maps(/over ,gbx = pd[0], name='JUPITER',projection='RECTANGULAR',$
  fn_data=ptr_new(),size=[fmap_xsize,fmap_ysize],origin=[fmap_xsize,fmap_ysize]/2,$
  units=[map_ysize*1d0/fmap_ysize,map_xsize*1d0/fmap_xsize],scale=mfac)

for i=0,2 do dat_set_data,ddm[i],nmos[*,*,i]
ddf=objarr(3)
;divide pc_size by 8 so the peices can fit in memory
for i=0,2 do ddf[i]=pg_map(ddm[i],md=fmd,cd=cd,map=maptmp,pc_xsize=fmap_xsize/8,pc_ysize=fmap_ysize/8)

;make the RGB image - note that band order for the camera is BGR
if obj_valid(ddf[0])  then begin
  ddif=dblarr(nmap_xsize,nmap_ysize,3)
  for i=0,2 do ddif[*,*,2-i]=dat_data(ddf[i])
endif

end
