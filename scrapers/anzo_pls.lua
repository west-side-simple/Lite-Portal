-- скрапер-агрегатор TVS для загрузки плейлиста "Помойка" самообновляемых бесплатных листов из интернета (19.07.21)
-- Copyright © 2020-2021 AnZo | Идея AnZo, основа Timofejj, чистка от дублей Wafee, правка и реализация West_side
-- ## Переименовать каналы ##
local filter = {
	{'ZeeTV', 'Zee TV'},
	{'Время: далёкое и близкое', 'Время'},
	{'Живи', 'Живи!'},
	}
-- ##
	module('anzo_pls', package.seeall)
	local my_src_name = 'Anzo'
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
	local function showMsg(str, color)
		local t = {text = str, color = color, showTime = 1000 * 5, id = 'channelName'}
		m_simpleTV.OSD.ShowMessageT(t)
	end
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '..\\Channel\\logo\\Icons\\deniz.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 1, show_progress = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, LogoTVG = 1}, STV = {add = 0, ExtFilter = 0, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoNumber = 1, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 0, TypeFind = 1, TypeMedia = 0, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

local function LoadFromSite()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) ApplewebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 90000)
        local url
        pll={
		--{"aHR0cDovL3plZXR2Lm9ubGluZS9wbC9zbXRrLm0zdQ==","Смартотека"},
        --{"aHR0cDovL3plZXR2Lm9ubGluZS9wbC9odWIubTN1","HUB"},
        --{"aHR0cDovL3plZXR2Lm9ubGluZS9wbC9wdWIubTN1","PUB"},
        {"aHR0cHM6Ly93d3cudmVyYW56by5ydS9vdGhlci9zbXRrLm0zdQ==","smtk2"},
        {"aHR0cHM6Ly93d3cudmVyYW56by5ydS9vdGhlci9odWIubTN1","HUB2"},
        --{"aHR0cHM6Ly93d3cudmVyYW56by5ydS9vdGhlci9wdWIubTN1","PUB2"},
        {"aHR0cHM6Ly9zbWFydHR2YXBwLnJ1L2FwcC9pcHR2ZnVsbC5tM3U=","smarttvapp"},
        {"aHR0cHM6Ly9zbWFydHR2bmV3cy5ydS9hcHBzL2lwdHZjaGFubmVscy5tM3U=","smarttvnews"},
        --{"aHR0cDovL2JsdWVjcmFic3R2LmRvLmFtL0ZyZWUubTN1","BlueCrabs"},
}
        plt, answer, txtstr = {}, '', ''
        for j = 1,#pll do
        plt[j] = {}
        plt[j].act = pll[j][1]
        plt[j].name = pll[j][2]
        url = plt[j].act
        rc, answer1 = m_simpleTV.Http.Request(session, {url = decode64(url)})
        if answer1 and answer1:match('^#EXTM3U') then
		answer1 = answer1:gsub('%#EXTVLCOPT.-\n','')
		answer1 = answer1:gsub('#EXTINF','# \n#EXTINF')
		answer1 = answer1 .. '\n# \n'
        answer = answer1 .. answer
		txtstr = txtstr .. ' загрузка плейлиста ' .. j .. ' из ' .. #pll .. ' - ' .. plt[j].name .. ': удачно\n'
		else
		txtstr = txtstr .. ' загрузка плейлиста ' .. j .. ' из ' .. #pll .. ' - ' .. plt[j].name .. ': ошибка\n'
        end
        j = j+1
        end
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1" src="' .. m_simpleTV.Common.GetMainPath(2) .. './work/Channel/logo/icons/deniz.png"', text = txtstr, color = ARGB(255, 127, 63, 255), showTime = 1000 * 10})
        local t, i = {}, 1

            for w in answer:gmatch('%#EXTINF:.-%# ') do
			if not w:match('DrSerg') then
                local title = w:match(',(.-)\n')
                local adr = w:match('\n(http.-)\n') or w:match('\n(rtmp.-)\n')
                local logo = w:match('tvg%-logo="(.-)"')
                    if not adr or not title then break end
                t[i] = {}
                t[i].name = title
                t[i].address = adr
                t[i].group = w:match('group%-title="([^"]+)') or 'Новые каналы'
				if logo
				then
                 t[i].logo = logo:gsub('https?://iptvx%.one/picons/%.%./','./work/')
				else
				 logo = './work/Channel/logo/icons/deniz.png'
				end
				if title:match('Stingray') then t[i].group = 'Stingray Music' end
                i = i + 1
			end
            end
            if i == 1 then return end

			local hash, tab = {}, {}
			for i = 1, #t do
				if not hash[t[i].address]
				then
					tab[#tab + 1] = t[i]
					hash[t[i].address] = true
				end
			end

			if #tab == 0 then return end

     return tab
    end

	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
--		local outm3u,m3u5,m3u4,m3u3,m3u2,m3u1
		local Source = TVSources_var.tmp.source[UpdateID]

				local t_pls = LoadFromSite()

			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' ошибка загрузки плейлиста'
											, color = ARGB(255, 255, 100, 0)
											, showTime = 1000 * 5
											, id = 'channelName'})
			 return
			end

		m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' (' .. #t_pls .. ')'
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