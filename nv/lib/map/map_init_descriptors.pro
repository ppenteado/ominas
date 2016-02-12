;=============================================================================
;+
; NAME:
;	map_init_descriptors
;
;
; PURPOSE:
;	Init method for the MAP class.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	md = map_init_descriptors(n)
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
;	md:	Map descriptor(s) to initialize, instead of creating a new one.
;
;	crd:	Core descriptor(s) to pass to cor_init_descriptors.
;
;	type:	Array (1 x n) of strings giving the map types.
;
;	units:	Array (2 x n) of strings giving the map units.
;
;	size:	Array (2 x n) of strings giving the map sizes.
;
;	scale:	Array (1 x n) of strings giving the map scales.
;
;	center:	Array (2 x n) of strings giving the map centers.
;
;	origin:	Array (2 x n) of strings giving the map origins.
;
;	offset:	Array (2 x n) of strings giving the map offsets.
;
;	rotate:	Array (1 x n) of strings giving the map rotate codes.
;
;	graphic:	Array (1 x n) of strings giving the map graphic flags.
;
;	radii:	Array (3 x n) of strings giving the map ellipsoid radii.
;
;	radii:	Array (1 x n) of pointers giving the map functon data.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Newly created or or freshly initialized disk descriptors, depending
;	on the presence of the dkd keyword.
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
function map_init_descriptors, n, md=md, crd=crd, $
@map__keywords.include
end_keywords

 if(NOT keyword_set(n)) then n = n_elements(md)

 if(NOT keyword_set(md)) then md = replicate({map_descriptor}, n)
 md.class = decrapify(make_array(n, val='MAP'))
 md.abbrev=decrapify(make_array(n, val='MAP'))


 ;----------------------------------------------------------------------
 ; default size and type are [0,0] and 'NONE' respectively
 ;----------------------------------------------------------------------
 if(keyword_set(size)) then md.size = size $
 else size = lonarr(2)
 if(keyword_set(type)) then md.type = decrapify(type) $
 else type = 'NONE'


 if(keyword_set(units)) then md.units = units $
 else md.units = [1d,1d]

 ;----------------------------------------------------------------------
 ; other defaults depend on projection type
 ;----------------------------------------------------------------------
 md_default = map_lookup_defaults(md);

 origin = decrapify(origin)
 if(keyword_set(origin)) then md.origin = origin $
 else md.origin = md_default.origin

 center = decrapify(center)
 if(keyword_set(center)) then md.center = center $
 else md.center = md_default.center

 offset = decrapify(offset)
 if(keyword_set(offset)) then md.offset = offset $
 else md.offset = md_default.offset

 radii = decrapify(radii)
 if(n_elements(radii) NE 0) then md.radii = radii $ 
 else md.radii[*] = 1d

 if(keyword_set(scale)) then md.scale = decrapify(scale) $
 else md.scale = md_default.scale


 if(keyword_set(crd)) then md.crd = crd $
 else md.crd = cor_init_descriptors(n, $
@cor__keywords.include
end_keywords)


 if(keyword_set(fn_data_p)) then $
  begin
;   for i=0, n-1 do if(ptr_valid(fn_data_p[i])) then $
;    begin
;     s = size(*fn_data_p[i], type=type)
;     w = where(type EQ [6,8,9,10,11])
;     if(w[0] NE -1) then nv_message, $
;            name = 'map_init_descriptors', 'Invalid type for function data.'
;    end 

   md.fn_data_p = decrapify(fn_data_p)
  end

 if(keyword_set(graphic)) then md.graphic = decrapify(graphic)

 if(keyword_set(rotate)) then md.rotate = decrapify(rotate)


 mdp = ptrarr(n)
 nv_rereference, mdp, md



 return, mdp
end
;===========================================================================
