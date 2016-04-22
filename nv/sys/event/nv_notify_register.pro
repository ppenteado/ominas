;=============================================================================
;+
; NAME:
;	nv_notify_register
;
;
; PURPOSE:
;	Register descriptor event handlers.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_notify_register, xd, handler, type, data=data
;
;
; ARGUMENTS:
;  INPUT:
;	xd:		Array of descriptors.
;
;	handler:	Name of event handler functions.  If only one element, 
;			then this function will be registered for every given
;			descriptor.  Otherwise must have the same number of
;			elements as xd.
;
;	type:		Type of data event to respond to:
;			 0 - set value
;			 1 - get value
;			0 is default.  If only one element, then this type 
;			will be registered for every given descriptor. 
;			Otherwise must have the same number of elements as xd.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	data:		Arbitrary user data to associate with events on these
;			descriptors.  A pointer to this data is allocated and
;			returned in the 'data_p' field of the event structure.
;			Note that only one descriptor xd may be specified
;			per call when using this argument.
;
;	scalar_data:	Scalar user data to associate with events on these
;			descriptors.  This data is returned in the 'data'
;			field of the event structure.
;
;	compress:	Event compression flag.  
;
;  OUTPUT:
;	NONE
;
;
; RETURN:
;	NONE
;
;
; COMMON BLOCKS:
;	nv_notify_block
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	nv_notify_unregister
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/2002
;	
;-
;=============================================================================
pro nv_notify_register, _xd, handler, type, data=data, $
                 scalar_data=scalar_data, compress=compress
@nv_notify_block.common
@nv.include

 ;------------------------------------------------------------------
 ; first flush event buffer to ensure that the new handler 
 ; does not receive events that occurred before it was registered
 ;------------------------------------------------------------------
 nv_flush


 dynamic = 0
 if(size(_xd, /type) NE 10) then $
  begin
   xd = nv_ptr_new(_xd)
   dynamic = 1
  end $
 else xd = _xd

 if(NOT keyword_set(type)) then type = 0

 ;-----------------------------------------------
 ; set up new list item
 ;-----------------------------------------------
 idp = cor_idp(xd, /noevent)
 n = n_elements(idp)

 if(n_elements(handler) EQ 1) then handler = make_array(n, val=handler)
 if(n_elements(type) EQ 1) then type = make_array(n, val=type)

 items = replicate({nv_notify_list_struct}, n)

 if(keyword_set(data)) then items.data_p = nv_ptr_new(data)
 items.idp = idp
 items.xd = xd
 items.dynamic = dynamic
 items.handler = handler
 if(NOT defined(compress)) then $
  begin
   w = where(type EQ 0)
   if(w[0] NE -1) then items[w].compress = 1
  end $
 else items.compress = compress
 if(keyword_set(scalar_data)) then items.data = scalar_data
 if(keyword_set(type)) then items.type = type

 ;-----------------------------------------------
 ; add handler to list
 ;-----------------------------------------------
 list = append_array(list, items)


end
;=============================================================================
