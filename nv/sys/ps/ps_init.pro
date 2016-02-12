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
;	uname:		String giving the name of a user data array.  If the name 
;			exists, then the corresponding user data array is 
;			replaced.  Otherwise, a new array is created with this 
;			name. 
;
;	udata:		New user data array.
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
function ps_init, $
   name=name, $
   desc=desc, $
   input=input, $
   points=points, $
   vectors=vectors, $
   flags=flags, $
   tags=tags, data=data, $
   assoc_idp=assoc_idp, $
   uname=uname, udata=udata

 ps = {points_struct}

 ;-----------------------
 ; ID pointer
 ;-----------------------
 ps.idp = nv_ptr_new(0)

 ;-----------------------
 ; name
 ;-----------------------
 if(keyword_set(name)) then ps.name = name

 ;-----------------------
 ; desc
 ;-----------------------
 if(keyword_set(desc)) then ps.desc = desc

 ;-----------------------
 ; input
 ;-----------------------
 if(keyword_set(input)) then ps.input = input

 ;-----------------------
 ; points
 ;-----------------------
 if(keyword_set(points)) then $
  begin
   ps.points_p = nv_ptr_new(points)

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
   ps.vectors_p = nv_ptr_new(vectors)

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
   ps.flags_p = nv_ptr_new(flags)

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
   ps.data_p = nv_ptr_new(data)

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
   ps.tags_p = nv_ptr_new(tags)

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
 ps.nv = (ps.nt = 0)
 if(keyword_set(nv)) then ps.nv = nv
 if(keyword_set(nt)) then ps.nt = nt


 ;--------------------------
 ; user data
 ;--------------------------
 if(defined(udata)) then $
  begin
   if(NOT keyword_set(uname)) then ps.udata_tlp = udata $
   else $
    begin
     tlp = ps.udata_tlp
     tag_list_set, tlp, uname, udata
     ps.udata_tlp = tlp
    end
  end


 ;-----------------------
 ; ps pointer
 ;-----------------------
 psp = ptrarr(1)
 nv_rereference, psp, ps



 return, psp
end
;===========================================================================



