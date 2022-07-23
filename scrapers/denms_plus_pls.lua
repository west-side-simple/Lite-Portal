-- скрапер TVS для загрузки плейлиста "DENMS TV" http://denms.tplinkdns.com/ (22/07/21)
-- логин, пароль установить в 'Password Manager', для ID - denms

-- ## Переименовать каналы ##
local filter = {
	{'Наука', 'Наука UA'},
	}
-- ##

	module('denms_plus_pls', package.seeall)
	local my_src_name = 'DENMS TV - StarNet (A)'
	
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
		
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
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '../Channel/logo/extFiltersLogo/denms.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function findtok()
	local url= decode64('aHR0cHM6Ly90b2tlbi5zdGIubWQvYXBpL0ZsdXNzb25pYy9zdHJlYW0vTklDS0VMT0RFT05fSDI2NC9tZXRhZGF0YS5qc29u')
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc~=200 then
		return ''
		end
		require('json')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
		if tab and tab.variants and tab.variants[1] and tab.variants[1].url then
		return tab.variants[1].url:gsub('^.-token=','')
		else
		return ''
		end
	end

	local function LoadFromFile(pls, pls_name)
		local answer
			local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('denms') end, err)
		if not login or not password or login == '' or password == '' then return
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './work/Channel/logo/extFiltersLogo/denms.png"', text = ' Внесите данные в менеджере паролей для ID denms', color = ARGB(255, 127, 63, 255), showTime = 1000 * 60})
		else
	local search = 'starnet-md.m3u'
	local path = m_simpleTV.MainScriptDir .. 'user/TVSources/core/' .. search
	local file = io.open(path, 'r')
	if not file then
	m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.Common.GetMainPath(2) .. './work/Channel/logo/extFiltersLogo/denms.png"', text = ' необходимо скачать файл ' .. m_simpleTV.MainScriptDir .. 'user/TVSources/core/starnet-md.m3u', color = ARGB(255, 127, 63, 255), showTime = 1000 * 30})
	answer = '' else
	answer = file:read('*a')
	file:close()
	end
	end


		local tok = findtok()
		answer = answer .. '\n'
		local t, i = {}, 1

			for w in answer:gmatch('%#EXTINF:.-\n.-\n') do
				local title = w:match(',(.-)\n')
				local adr = w:match('\n(.-)\n')
				local logo = w:match('tvg%-logo="(.-)"')
					if not adr or not title then break end
				t[i] = {}
				t[i].name = title
				t[i].address = adr .. tok
				t[i].group = w:match('group%-title="([^"]+)') or 'DENMS TV'
				t[i].RawM3UString = w:match('(catchup.-),')
				t[i].logo = logo
				if not pls:match('18') or pls:match('18') and t[i].group ~= 'Эротика' then
				i = i + 1
				end
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
--		{"nsk","Ростелеком, Новосибирск"},
--		{"tsn-full","tsn, полная версия"},
--		{"tsn-1-18","tsn, без 18+"},
		{"full","полная версия"},
		{"minus 18","без 18+"},
}

  local t={}
  for i=1,#pll do
    t[i] = {}
    t[i].Id = i
    t[i].Name = pll[i][2]
    t[i].Action = pll[i][1]
  end

  local playlist, pls_name
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('IPTVin.Ru StarNet - select playlist',0,t,9000,1+4+8)
  if id==nil then return end
  if ret == 1 then
   playlist = t[id].Action
   pls_name = t[id].Name
  end
		local t_pls = LoadFromFile(playlist, pls_name)
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