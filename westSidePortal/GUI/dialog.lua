-- SergeyVS, west_side 27.06.22
require("westSidePortal")

----------------------------------------------------------------------
local function escapeJSString(str)
 if str == nil then return nil end
 str = string.gsub(str,'\\','\\\\')
 str = string.gsub(str,'"','\\"')
 str = string.gsub(str,'\n','\\n')
 str = string.gsub(str,'\r','\\r')
 return str
end
----------------------------------------------------------------------
local function translateHtml(Object)
  m_simpleTV.Dialog.ExecScript(Object,'doTranslate();')
end
----------------------------------------------------------------------
function mess(Object, mes)
m_simpleTV.OSD.ShowMessageT({text = 'Portal info: ' .. tostring(mes), color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
end
----------------------------------------------------------------------
function setSearch(Object, search)
m_simpleTV.Config.SetValue('search/media',tostring(m_simpleTV.Common.toPercentEncoding(search)),'LiteConf.ini')
end
----------------------------------------------------------------------
function baseInit(Object)

 local scr = 'setViewMode(' ..  tostring(westSidePortal.isEmbedded()) .. ')'

 m_simpleTV.Dialog.ExecScript(Object,scr)
 if westSidePortal.isSavePosition() and not westSidePortal.isEmbedded() then
  m_simpleTV.Dialog.SetOnCloseEvent(Object,'westSidePortalDialogCloseEvent')
 end
end
----------------------------------------------------------------------
function OnNavigateComplete(Object)
  translateHtml(Object)
  baseInit(Object)
end
----------------------------------------------------------------------
function westSidePortalDialogRequestClose(Object)
 m_simpleTV.Dialog.Close(Object)
end
----------------------------------------------------------------------
function westSidePortalDialogCloseEvent(Object)
 if westSidePortal.isSavePosition() and not westSidePortal.isEmbedded() then
  westSidePortal.savePosition(m_simpleTV.Dialog.GetWindowPos(Object))
 end
end
----------------------------------------------------------------------
function search_all()
m_simpleTV.Control.ExecuteAction(37)
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local search_ini = getConfigVal('search/media') or ''
	local tt1={
	{'TMDb',''},
	{'EX-FS',''},
	{'Rezka',''},
	{'Filmix',''},
	{'KinoGo',''},
	{'UA',''},
	{'Kinopub',''},
	{'YouTube',''},
	{'VideoCDN',''},
	}

  local t1={}
  for i=1,#tt1 do
    t1[i] = {}
    t1[i].Id = i
    t1[i].Name = tt1[i][1]
	t1[i].Action = tt1[i][2]
  end
  t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
  t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Search Lite Portal: ' .. m_simpleTV.Common.fromPercentEncoding(search_ini),0,t1,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
  if t1[id].Name == 'TMDb' then search_tmdb()
  elseif t1[id].Name == 'EX-FS' then search_media()
  elseif t1[id].Name == 'Rezka' then search_rezka()
  elseif t1[id].Name == 'Filmix' then search_filmix_media()
  elseif t1[id].Name == 'KinoGo' then search_kinogo()
  elseif t1[id].Name == 'UA' then search_ua()
  elseif t1[id].Name == 'Kinopub' then show_select('https://kino.pub/item/search?query=' .. search_ini)
  elseif t1[id].Name == 'YouTube' then search_youtube()
  elseif t1[id].Name == 'VideoCDN' then m_simpleTV.Control.PlayAddress('*' .. m_simpleTV.Common.UTF8ToMultiByte(m_simpleTV.Common.fromPercentEncoding(search_ini)))
  end
  end
  if ret == 3 then
   search()
  end
  if ret == 2 then
   run_westSide_portal()
  end
end