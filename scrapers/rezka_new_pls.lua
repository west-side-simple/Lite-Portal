-- скрапер TVS для загрузки плейлиста "Rezka NEW" https://rezkery.com (20/03/25)

	module('rezka_new_pls', package.seeall)
	local my_src_name = 'Rezka NEW'

	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://static.hdrezka.ac/templates/hdrezka/images/avatar.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3, RemoveDupCH = 0}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	
	local function Get_request_start()
		local t, i = {}, 1
		local answer0 = ''
		local zerkalo = m_simpleTV.Config.GetValue('zerkalo/rezka','LiteConf.ini') or ''
		if zerkalo == '' then zerkalo = 'https://hdrezka.ag/' end
		for j = 1,4 do
			m_simpleTV.Common.Sleep(2000)
			local session = m_simpleTV.Http.New('Mozilla/5.0')
			if not session then return end
			m_simpleTV.Http.SetTimeout(session, 4000)			
			local url = zerkalo .. 'engine/ajax/get_newest_slider_content.php'
			local body = 'id=' .. tostring(j):gsub('4', '82')
			local headers = 'X-Requested-With: XMLHttpRequest\nCookie: '
			local rc, answer = m_simpleTV.Http.Request(session, {url = url, method = 'post', body = body, headers = headers})
			answer0 = answer0 .. '\n' .. answer
--			debug_in_file(answer .. '\n~~~~~~~~~~\n', 'c://1/req_rezka.txt')
			m_simpleTV.Http.Close(session)
		end
			for w in answer0:gmatch('data%-id=.-<div class="misc">.-</div>') do
				local logo, group, adr, name, title = w:match('<img src="(.-)".-<i class="entity">(.-)</i>.-<a href="(.-)">(.-)</a>.-<div class="misc">(.-)<')
				if not adr or not name then break end
				t[i] = {}
				t[i].name = name .. ' (' .. (title:match('%d%d%d%d') or 0) .. ')'
				t[i].logo = logo
				t[i].address =  zerkalo .. adr:gsub('^http.-//.-/','')
				t[i].group = (group .. 'ы'):gsub('Анимеы','Аниме')
				t[i].video_title = title
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
		local t_pls = Get_request_start()
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

		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')