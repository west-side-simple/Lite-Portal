--menu west_side 22.03.22

function run_youtube_portal()

m_simpleTV.Control.ExecuteAction(37)

local tt={
{"YouTube главная страница","https://www.youtube.com","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube список подписок >>","https://www.youtube.com/feed/channels","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube список подписок (ленты каналов - RSS feed) >>","https://www.youtube.com/feed/rss_channels","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube подписки >>","https://www.youtube.com/feed/subscriptions","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube в тренде","https://www.youtube.com/feed/trending","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube история просмотра","https://www.youtube.com/feed/history","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube понравившиеся","https://www.youtube.com/playlist?list=LL","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube понравившиеся (музыка)","https://www.youtube.com/playlist?list=LM","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
{"YouTube отложенный просмотр","https://www.youtube.com/playlist?list=WL","./luaScr/user/show_mi/menuYT.png",' - автор Nexterr'},
}

  local t={}
  for i=1,#tt do
    t[i] = {}
    t[i].Id = i
    t[i].Name = tt[i][1]
    t[i].Action = tt[i][2]
	t[i].InfoPanelLogo = tt[i][3]
	t[i].InfoPanelTitle = 'Guide (необходимо использовать cookies)'
	t[i].InfoPanelDesc = 'Guide (необходимо использовать cookies)' .. tt[i][4]
	t[i].InfoPanelShowTime = 9000
  end

  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Youtube menu',0,t,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
    m_simpleTV.Control.PlayAddressT({address = t[id].Action})
  end

  end

function highlight()
m_simpleTV.Control.ExecuteAction(37)
local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end
local tt2={
{'Youtube канал SimpleTV M24WS','https://youtube.com/playlist?list=PL0OszcisBIjOax3iduZNSGfvuMj8NAyMj'},


}

  local t2={}
  for i=1,#tt2 do
    t2[i] = {}
    t2[i].Id = i
    t2[i].Name = tt2[i][1]
	t2[i].Address = tt2[i][2]
  end
  local cur_id = 0
  if getConfigVal('highlight') then cur_id = tonumber(getConfigVal('highlight'))-1 end
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Highlight',cur_id or 0,t2,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
	setConfigVal('highlight',id)
	m_simpleTV.Control.PlayAddressT({address = t2[id].Address})
  end
end

--[[
 local t={}
 t.utf8 = true
 t.name = 'Youtube меню'
 t.luastring = 'run_youtube_portal()'
 t.lua_as_scr = true
 t.submenu = 'Youtube by Nexterr'
 t.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuYT.png'
 t.key = string.byte('I')
 t.ctrlkey = 4
 t.location = 0
 t.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuYT.png'
 m_simpleTV.Interface.AddExtMenuT(t)--]]