;=============================================================================
; grim_message
;
;=============================================================================
pro grim_message, message, $
       clear=clear, suspend=suspend, restore=restore, question=question, $
       result=result
common grim_message_block, suspended

 nv_message, silent=0

 ;------------------------------------------
 ; handle keyword options
 ;------------------------------------------
 if(keyword_set(clear)) then $
  begin
   nv_message, /clear, /silent
   return
  end 

 if(keyword_set(suspend)) then $
  begin
   suspended = 1
   return
  end 

 if(keyword_set(restore)) then $
  begin
   suspended = 0
   return
  end 

 ;------------------------------------------
 ; display message unless suspended
 ;------------------------------------------
 if(keyword_set(suspended)) then return

 if(NOT keyword_set(message)) then $
  begin
   nv_message, /get, message=message
   if(NOT keyword_set(strtrim(message,2))) then return
  end 

 error = 0
 if(NOT keyword_set(question)) then error = 1

;print, message	; temporarily turn off dialog messages.  These can get annoying
;if(NOT keyword_set(question)) then return ; maybe should just pop up if not a /continue message
 result = dialog_message(message, question=question, error=error) 


end
;=============================================================================



