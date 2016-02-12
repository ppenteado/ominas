;=============================================================================
;+
; NAME:
;	bod_init_descriptors
;
;
; PURPOSE:
;	Init method for the BODY class.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bd = bod_init_descriptors(n)
;
;
; ARGUMENTS:
;  INPUT:
;	n:	Number of descriptors to create.
;
;  OUTPUT: NONE
;
;
; KEYWORDS (in addition to those accepted by all superclasses):
;  INPUT:  
;	bd:	Body descriptor(s) to initialize, instead of creating a new one.
;
;	crd:	Core descriptor(s) to pass to cor_init_descriptors.
;
;	time:	Array (n) of times, at body position, at which each descriptor 
;		is valid.
;
;	opaque:	Array (n) of flags describing whether each body is "easily 
;		visible".  
;
;	orient:	Array (3,3,n) of orientation matrices, transforming body to 
;		inertial for each body.
;
;	avel:	Array (ndv,3,n) of angular velocity vectors for each body. 
;
;	pos:	Array (ndv,3,n) of position vectors for each body. 
;
;	vel:	Array (ndv,3,n) of velocity vectors for each body. 
;
;	libv:	Array (ndv,3,n) of libration vectors for each body. 
;
;	lib:	Array (ndv,n) of libration phases for each body. 
;
;	dlibdt:	Array (ndv,n) of libration frequencies for each body. 
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Newly created or or freshly initialized body descriptors, depending
;	on the presence of the bd keyword.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
function bod_init_descriptors, n, crd=crd, bd=bd, $
@bod__keywords.include
end_keywords
@nv_lib.include

 if(NOT keyword_set(n)) then n = n_elements(bd)

 if(NOT keyword_set(bd)) then bd=replicate({body_descriptor}, n)
 bd.class=decrapify(make_array(n, val='BODY'))
 bd.abbrev=decrapify(make_array(n, val='BOD'))

 if(keyword_set(crd)) then bd.crd = crd $
 else bd.crd=cor_init_descriptors(n, $
@cor__keywords.include
end_keywords)

 bd.opaque = 1
 if(defined(opaque)) then bd.opaque=decrapify(opaque)

 if(keyword_set(time)) then bd.time=decrapify(time)
 if(keyword_set(pos)) then bd.pos=pos
 if(keyword_set(vel)) then bd.vel[0:(size(vel))[1]-1,*,*]=vel
 if(keyword_set(avel)) then bd.avel[0:(size(avel))[1]-1,*,*]=avel
 if(keyword_set(libv)) then bd.libv[0:(size(libv))[1]-1,*,*]=libv
 if(keyword_set(dlibdt)) then bd.dlibdt[0:(size(dlibdt))[1]-1,*]=dlibdt
 if(keyword_set(lib)) then bd.lib[0:(size(lib))[1]-1,*]=lib

 if(NOT keyword_set(orient)) then $
  begin
   orient = [tr([1d,0d,0d]), tr([0d,1d,0d]), tr([0d,0d,1d])]
   orient = orient[linegen3z(3,3,n)]
  end
 


 if(keyword_set(orient)) then $
   begin
    bd.orient=orient
    if(n EQ 1) then bd.orientT=transpose(orient) $
    else bd.orientT=transpose(orient, [1,0,2])
   end


 bdp = ptrarr(n)
 nv_rereference, bdp, bd


 return, bdp
end
;===========================================================================



