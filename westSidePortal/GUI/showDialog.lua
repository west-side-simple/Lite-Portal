require("westSidePortal")

local dialogObject = m_simpleTV.Dialog.FindWindowById(westSidePortal.getDialogId())
if dialogObject~=nil then   
  m_simpleTV.Dialog.SetForegroundWindow(dialogObject)
 return 
end
   
 local t ={}
 t.name = westSidePortal.tr('Portal')
 t.urlHtml = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSidePortal/GUI/dialog.html'
 t.urlLua  = 'user/westSidePortal/GUI/dialog.lua'
 t.urlLogo  = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSidePortal/GUI/img/westSidePortal.png'
   
 if westSidePortal.isEmbedded() then
   t.flags =  'FRAMELESS_MODE | NOT_MODAL | TRANSPARENT_BACKGROUND | INHERIT_OSD_FONT'
   t.childPositionParams = 'typeAlign="0x202" x="0" y="0" cx="-87" cy="-80" xb="0" yb="0" mincx="50" mincy="50"'  
 else   
  local scale = m_simpleTV.Interface.GetScale()
  if westSidePortal.isSavePosition() then
    t.x,t.y,t.cx,t.cy = westSidePortal.getPosition()
  end
  if not t.cx then t.cx = 400 * scale end
  if not t.cy then t.cy = 180 * scale  end
    
  t.minCx = 310 * scale
  t.minCy = 170 * scale
  t.flags = 'HAVE_SIZE | ALLOW_RESIZE | NOT_MODAL'
  t.flags = t.flags .. ' | NOT_TOP_ON_MAINFRAME'  --окно появится в taskbar и будет не поверх основного окна плеера
  
 end
  
 t.id = westSidePortal.getDialogId()
 m_simpleTV.Dialog.ShowT(t)
