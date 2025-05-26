-- скрапер TVS для загрузки плейлиста "DENMS TV - select" http://iptvin.ru/ (27/03/25)
-- логин, пароль установить в 'Password Manager', для ID - denms

-- ## Переименовать каналы ##
local filter = {
	{'1000', 'TV1000'},
	{'1000 Action', 'TV1000 Action'},
	{'1000 Comedy', 'ViP Comedy'},
	{'1000 Megahit', 'ViP Megahit'},
	{'1000 Premium', 'ViP Premiere'},
	{'1000 Русское кино', 'TV1000 Русское кино'},
	{'Крым 1', 'Первый Крымский (Симферополь)'},
	{'Че ТВ', 'Че'},
	{'Ералаш', 'ЕРАЛАШ HD'},
	{'Наука 2', 'Наука'},
	{'5 Канал', '5 Канал Украина'},
	{'Дважды два канал (2x2)', '2x2'},
	{'Сетанта Спорт Плюс', 'Setanta Sports+'},
	{'ТРО союз', 'БелРос'},
	{'Fox live', 'Fox Life'},
	{'Кино HD', 'Кинопремьера'},
	{'Комедия', 'Кинокомедия'},
	}
-- ##

	module('denms0_pls', package.seeall)
	local my_src_name = 'DENMS TV - select (A)'

	local function ProcessFilterTableLocal(t)
		if not type(t) == 'table' then return end
		for i = 1, #t do
			t[i].name = tvs_core.tvs_clear_double_space(t[i].name)
			for _, ff in ipairs(filter) do
				if (type(ff) == 'table' and t[i].name == ff[1]) then
					t[i].name = ff[2]
				end
			end
		end
	 return t
	end
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '../Channel/logo/icons/denms.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, LogoTVG = 0}, STV = {add = 0, ExtFilter = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, HDGroup = 1, AutoSearch = 1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	
local function select_zerkalo_DNS()
	local cur_zer = m_simpleTV.Config.GetValue("zerkalo/denisoft","LiteConf.ini") or "http://iptv.denms.ru/?"
  	local zer={
	{"http://iptvin.ru/p/?","http://iptvin.ru/p/?"},
	{"http://iptv.iptvin.ru/?","http://iptv.iptvin.ru/?"},
	{"http://iptv.denms.ru/?","http://iptv.denms.ru/?"},
	{"http://www.denms.ru/p/?","http://www.denms.ru/p/?"},
	{"http://denms.ru/p/?","http://denms.ru/p/?"},
	{"http://iptvin.tplinkdns.com/p/?","http://iptvin.tplinkdns.com/p/?"},
	{"http://overlay.iptvin.online/?","http://overlay.iptvin.online/?"},
	}
    local t1={}
    for i=1,#zer do
		t1[i] = {}
		t1[i].Id = i
		t1[i].Name = zer[i][2]
		t1[i].Action = zer[i][1]
		if cur_zer == zer[i][1] then cur_id = i-1 end
    end
    local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('IPTVin.Ru - select zerkalo',cur_id or 0,t1,9000,1+4+8)
    if id==nil then 
		return cur_zer 
    end
    if ret == 1 then
	    m_simpleTV.Config.SetValue("zerkalo/denisoft",t1[id].Action,"LiteConf.ini")
	    return t1[id].Action
    end	
end	
	local function LoadFromSite(pls, pls_name)
		local url
		local cur_zer
		local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('denms') end, err)
		if not login or not password or login == '' or password == '' then 
			return m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './work/Channel/logo/icons/denms.png"', text = ' Внесите данные в менеджере паролей для ID denms', color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
		else
			cur_zer = select_zerkalo_DNS()
		end

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) ApplewebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 16000)
		local rc, answer, answer1, pll, plt
		if pls == 'all' then
--		
		pll={
		{"nsk","Ростелеком, Новосибирск"},
		{"kya","Ростелеком, Красноярск"},
		{"tgl","Infoline, Тольятти"},
		{"ttknsk","Транстелеком, Новосибирск"},
		{"ntk","Новотелеком, Новосибирск"},
		{"i5gorsk","Post Ltd, Пятигорск, Ессентуки"},
		{"peers","Плейлист  Peers"},
		{"svyazllc","Svyaz LLC, Усть-Кут"},
		{"rt-omsk","sibnet3 (Барнаул)"},
		{"activtv","ActivTV"},
		{"web1t","web1"},
		{"web2-m","web2"},
		{"web3-3","web3"},
		{"web4","web4"},
--		{"web5","web5"},
		{"web6i","web6"},
		{"web7","web7"},
		{"web8","web8"},
		{"web9u","web9"},
		{"web10","web10"},
		{"web11-4","web11"},
		{"web12","web12"},
		{"web13","web13"},
		{"web14-a4","web14"},
		{"web15-d","web15"},
		{"web16v","web16"},
		{"web17z","web17"},
		{"web18l","web18"},
		{"web19","web19"},
		{"web20","web20"},
		{"webcompilie","webcompilie"},
		{"webcompilie2","webcompilie2"},
}
		plt, answer = {}, ''
		for j = 1,#pll do
			plt[j] = {}
			plt[j].act = pll[j][1]
			plt[j].name = pll[j][2]
			url = cur_zer .. plt[j].act .. '&' .. login .. '&' .. password
			rc, answer1 = m_simpleTV.Http.Request(session, {url = url})
			if answer1 then
				answer1 = answer1 .. '\n'
				answer = answer1 .. answer
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.Common.GetMainPath(2) .. './work/Channel/logo/icons/denms.png"', text = ' загрузка плейлиста ' .. j .. ' из ' .. #pll .. ' - ' .. plt[j].name, color = ARGB(255, 127, 63, 255), showTime = 1000 * 30})
			end
			j = j + 1
		end
--		
		else
			rc, answer = m_simpleTV.Http.Request(session, {url = cur_zer .. pls .. '&' .. login .. '&' .. password})
			m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
			answer = answer .. '\n'
		end
		local t, i = {}, 1
		for w in answer:gmatch('%#EXTINF:.-\n.-\n') do
			local title = w:match(',(.-)\n')
			local adr = w:match('\n(.-)\n')
			local logo = w:match('tvg%-logo="(.-)"')				
				if not adr or not title then break end
			t[i] = {}
			t[i].name = title
			t[i].address = adr
			t[i].group = w:match('group%-title="([^"]+)') or 'DENMS TV'
			if title:match('^-') then t[i].group = 'DENMS TV - update' end
			t[i].logo = logo
			i = i + 1
		end
		if i == 1 then return end
		return t
	end
	
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local pll={
		{"nsk","Ростелеком, Новосибирск"},
		{"kya","Ростелеком, Красноярск"},
		{"tgl","Infoline, Тольятти"},
		{"ttknsk","Транстелеком, Новосибирск"},
		{"ntk","Новотелеком, Новосибирск"},
		{"i5gorsk","Post Ltd, Пятигорск, Ессентуки"},
		{"peers","Плейлист  Peers"},
		{"svyazllc","Svyaz LLC, Усть-Кут"},
		{"rt-omsk","sibnet3 (Барнаул)"},
		{"activtv","ActivTV"},
		{"web1t","web1"},
		{"web2-m","web2"},
		{"web3-3","web3"},
		{"web4","web4"},
--		{"web5","web5"},
		{"web6i","web6"},
		{"web7","web7"},
		{"web8","web8"},
		{"web9u","web9"},
		{"web10","web10"},
		{"web11-4","web11"},
		{"web12","web12"},
		{"web13","web13"},
		{"web14-a4","web14"},
		{"web15-d","web15"},
		{"web16v","web16"},
		{"web17z","web17"},
		{"web18l","web18"},
		{"web19","web19"},
		{"web20","web20"},
		{"webcompilie","webcompilie"},
		{"webcompilie2","webcompilie2"},
		{"all","все плейлисты"},	
}

  local t={}
  for i=1,#pll do
    t[i] = {}
    t[i].Id = i
    t[i].Name = pll[i][2]
    t[i].Action = pll[i][1]
  end

  local playlist, pls_name
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('IPTVin.Ru - select playlist',0,t,9000,1+4+8)
  if id==nil then return end
  if ret == 1 then
   playlist = t[id].Action
   pls_name = t[id].Name
  end
		local t_pls = LoadFromSite(playlist, pls_name)
		
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' ошибка загрузки плейлиста'
											, color = ARGB(255, 255, 100, 0)
											, showTime = 1000 * 5
											, id = 'channelName'})
			 return
			end
			if t_pls == 0 then
				m_simpleTV.OSD.ShowMessageT({text = 'логин/пароль установить\nв дополнении "Password Manager"\для id - denms'
											, color = ARGB(255, 255, 100, 0)
											, showTime = 1000 * 5
											, id = 'channelName'})
			 return
			end
		m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' / ' .. pls_name .. ' (' .. #t_pls .. ')'
									, color = ARGB(255, 155, 255, 155)
									, showTime = 1000 * 5
									, id = 'channelName'})
		t_pls = ProcessFilterTableLocal(t_pls)
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')