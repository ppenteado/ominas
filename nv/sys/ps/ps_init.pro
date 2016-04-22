;=============================================================================
;+
; NAME:
;	ps_init
;
;
; PURPOSE:
;	Creates and initializes a points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	ps = ps_init()
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	name:		Data set name.
;
;	desc:		Data set description.
;
;	input:		Description of input data used to produce these points.
;
;	points:		Image points.
;
;	vectors:	Inertial vectors.
;
;	flags:		Point-by-point flag array.
;
;	data:		Point-by-point data array.
;
;	tags:		Tags for point-by-point data.
;
;	assoc_idp:	IDP of an associated descriptor.
;
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Newly created and initialized point structure.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 11/2015
;	
;-
;=============================================================================
function ps_init, crd=crd, ptd=ptd, $
@ps__keywords.include
end_keywords

 if(NOT keyword_set(ptd)) then ptd = {points_struct}
 ptd.class = 'POINT'
 ptd.abbrev = 'PNT'


 if(keyword_set(crd)) then ptd.crd = crd $
 else ptd.crd=cor_init_descriptors(1, $
@cor__keywords.include
end_keywords)


 ;-----------------------
 ; desc
 ;-----------------------
 if(keyword_set(desc)) then ptd.desc = desc

 ;-----------------------
 ; input
 ;-----------------------
 if(keyword_set(input)) then ptd.input = input

 ;-----------------------
 ; points
 ;-----------------------
 if(keyword_set(points)) then $
  begin
   ptd.points_p = nv_ptr_new(points)

   dim = size(points, /dim)
   ndim = n_elements(dim)
   nv = (nt = 1)
   if(ndim GT 1) then nv = dim[1]
   if(ndim GT 2) then nt = dim[2]
  end

 ;-----------------------
 ; vectors
 ;-----------------------
 if(keyword_set(vectors)) then $
  begin
   ptd.vectors_p = nv_ptr_new(vectors)

   dim = size(vectors, /dim)
   ndim = n_elements(dim)
   nvv = (ntv = 1)
   nvv = dim[0]
   if(ndim GT 2) then ntv = dim[2]

   if(NOT keyword_set(nv)) then $
    begin
     nv = nvv
     nt = ntv
    end $
   else if((nvv NE nv) OR (ntv NE nt)) then nv_message, name='ps_init', $
                                       'Incompatible vector array dimensions.'
  end

 ;-----------------------
 ; flags
 ;-----------------------
 if(NOT defined(flags)) then $
           if(keyword_set(nv)) then flags = bytarr(nv)

 if(defined(flags)) then $
  begin
   ptd.flags_p = nv_ptr_new(flags)

   dim = [1]
   if(n_elements(flags) GT 1) then dim = size(flags, /dim)
   ndim = n_elements(dim)
   nvf = dim[0]
   ntf = 1
   if(ndim GT 1) then ntf = dim[1]

   if(NOT keyword_set(nv)) then $
    begin
     nv = nvf
     nt = ntf
    end $
   else if((nvf NE nv) OR (ntf NE nt)) then nv_message, name='ps_init', $
                                          'Incompatible flag array dimensions.'
  end


 ;--------------------------
 ; point-by-point data
 ;--------------------------
 if(keyword_set(data)) then $
  begin
   ptd.data_p = nv_ptr_new(data)

   dim = size(data, /dim)
   ndim = n_elements(dim)
   nvd = (ntd = 1)
   ndat = dim[0]
   if(ndim GT 1) then nvd = dim[1]
   if(ndim GT 2) then ntd = dim[2]

   if(NOT keyword_set(nv)) then $
    begin
     nv = nvd
     nt = ntd
    end $
   else if((nvd NE nv) OR (ntd NE nt)) then nv_message, name='ps_init', $
                            'Incompatible point-by-point data array dimensions.'
  end


 ;--------------------------
 ; point-by-point data tags
 ;--------------------------
 if(keyword_set(tags)) then $
  begin
   ptd.tags_p = nv_ptr_new(tags)

   dim = size(tags, /dim)
   ndim = n_elements(dim)
   nvt = dim[0]

   if(keyword_set(ndat)) then $
       if(nvt NE ndat) then nv_message, name='ps_init', $
                                       'Incompatible tags array dimensions.'
  end


 ;--------------------------
 ; dimensions
 ;--------------------------
 ptd.nv = (ptd.nt = 0)
 if(keyword_set(nv)) then ptd.nv = nv
 if(keyword_set(nt)) then ptd.nt = nt


 ;-----------------------
 ; ptd pointer
 ;-----------------------
 ptdp = ptrarr(1)
 nv_rereference, ptdp, ptd



 return, ptdp
end
;===========================================================================



