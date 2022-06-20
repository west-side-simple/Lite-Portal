-- скрапер TVS для загрузки плейлиста "Сериалы 2" (13/01/22)
-- base script nexterr, mod west_side
-- ## необходим ##
-- видоскрипт: videocdn.lua
-- ##
	module('serials_kinopoisk_2_pls', package.seeall)
	local my_src_name = 'Сериалы 2'
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '..\\Channel\\logo\\Icons\\serials.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 0, RefreshButton = 0, AutoBuild = 0, show_progress = 1, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 0, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function showMess(str, color, showT)
		local t = {text = '🎞 ' .. str, color = color, showTime = showT or (1000 * 5), id = 'channelName'}
		m_simpleTV.OSD.ShowMessageT(t)
	end
	local function LoadFromSite()
		require 'json'
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:85.0) Gecko/20100101 Firefox/85.0')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
--		showMess('«Сериалы 2» загрузка ...', ARGB(255, 153, 255, 153), 1200000)
		local t, i = {}, 1
			local function getTbl(t, k, tab)
				local j = 1
					while tab.data[j] and tab.data[j].iframe_src do
						local kinopoisk_id = tab.data[j].kinopoisk_id or ''
						
						local adr = tab.data[j].iframe_src

							t[k] = {}
							t[k].address = 'https:' .. adr:gsub('^https%:', '')
							if kinopoisk_id ~= '' then
							t[k].logo = string.format('https://st.kp.yandex.net/images/film_iphone/iphone360_%s.jpg', kinopoisk_id)
							end
							local year = tab.data[j].start_date or '0'
							year = year:match('(%d+)%-')
							year = year:gsub('2918', '2018')
							if tonumber(year) <= 1950 then t[k].group = '1950 года и ранее' end
							if tonumber(year) > 1950 and tonumber(year) <= 1970  then t[k].group = '1951 - 1970 года' end
							if tonumber(year) > 1970 and tonumber(year) <= 1980  then t[k].group = '1971 - 1980 года' end
							if tonumber(year) > 1980 and tonumber(year) <= 1991  then t[k].group = '1981 - 1991 года' end
							if tonumber(year) > 1991 and tonumber(year) <= 2000  then t[k].group = '1992 - 2000 года' end
							if tonumber(year) > 2000 and tonumber(year) <= 2005  then t[k].group = '2001 - 2005 года' end
							if tonumber(year) > 2005 and tonumber(year) <= 2010  then t[k].group = '2006 - 2010 года' end
							if tonumber(year) > 2010 and tonumber(year) <= 2015  then t[k].group = '2011 - 2015 года' end
							if tonumber(year) == 2016 then t[k].group = '2016 года' end
							if tonumber(year) == 2017 then t[k].group = '2017 года' end
							if tonumber(year) == 2018 then t[k].group = '2018 года' end
							if tonumber(year) == 2019 then t[k].group = '2019 года' end
							if tonumber(year) == 2020 then t[k].group = '2020 года' end
							if tonumber(year) > 2020 then t[k].group = '2021 года и далее' end

							t[k].name = tab.data[j].ru_title:gsub('"', '%%22')
							t[k].name = t[k].name .. ' (' .. year .. ')'
							local n, t1 = 1, {}
							while true do
							if not (tab.data[j].translations and tab.data[j].translations[n] and tab.data[j].translations[n].title) then break end

							t1[n] = {}
							t1[n].perevod = tab.data[j].translations[n].title
							if t1[n].perevod:match('Кубик') then t[k].group = 'Переводы Кубик в Кубе' end
							if t1[n].perevod:match('Гоблин') then t[k].group = 'Переводы Гоблина' end
							if t1[n].perevod:match('Кураж') then t[k].group = 'Переводы Кураж-Бамбей' end
							if t1[n].perevod:match('Карцев') then t[k].group = 'Переводы Карцев' end
							if t1[n].perevod:match('Санаев') then t[k].group = 'Переводы Санаев' end
							if t1[n].perevod:match('Дольский') then t[k].group = 'Переводы Дольский' end
							if t1[n].perevod:match('Михалёв') then t[k].group = 'Переводы Михалёв' end
							if t1[n].perevod:match('Хлопушка') then t[k].group = 'Переводы Хлопушка' end
							if t1[n].perevod:match('Гланц') then t[k].group = 'Переводы Гланц и Королева' end
							if t1[n].perevod:match('Сербин') then t[k].group = 'Переводы Сербин' end
							if t1[n].perevod:match('Володарский') then t[k].group = 'Переводы Володарский' end
							if t1[n].perevod:match('Мишин') then t[k].group = 'Переводы Мишин' end
							if t1[n].perevod:match('Гаврилов') then t[k].group = 'Переводы Гаврилов' end
							if t1[n].perevod:match('Визгунов') then t[k].group = 'Переводы Визгунов' end
							if t1[n].perevod:match('Горчаков') then t[k].group = 'Переводы Горчаков' end

							n = n + 1

							end

							if kinopoisk_id == '' and imdb_id == '' then t[k].group = 'Без ID' end
							if kinopoisk_id == '' and imdb_id ~= '' then t[k].group = 'Без ID Кинопоиска' end
							if kinopoisk_id ~= '' and imdb_id == '' then t[k].group = 'Без ID IMDb' end

							

							k = k + 1

						j = j + 1
					end
			 return t, k
			end
			for c = 1, 600 do
			if c==1 then t1=os.time() end
				local url = string.format(decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHYtc2VyaWVzP2FwaV90b2tlbj1XMk52TDg2YTM0S2cyb0pYTVRmOHE2N2dzZ2tLdXphcCZsaW1pdD0yNSZwYWdlPSVz'), c)
				local rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc == 200 and answer:match('"id"') then
				if c==1 then t1=os.time() inpage = answer:match('last_page_url.-page=(%d+)') end
					answer = answer:gsub('%[%]', '""')
					local tab = json.decode(answer)
					if tab and tab.data then
						t, i = getTbl(t, i, tab)
					end
				else
				t2=os.time()
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/poisk.png"', text = 'Время загрузки ' .. t2-t1 .. ' сек. Приятного просмотра', color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
				 break
				end
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/progress1/p' .. math.floor(c/inpage*100+0.5) .. '.png"', text = ' - общий прогресс загрузки: ' .. c, color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
			end
		m_simpleTV.Http.Close(session)
			if #t == 0 then return end
			local t1 = table_reverse (t)
			for a = 1,#t1 do
			if a<=20
			then
			t1[a].group = 'Последние поступления'
			end
			end
	 return t1
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite()
			if not t_pls then
				showMess(Source.name .. ': ошибка загрузки плейлиста', ARGB(255, 255, 102, 0))
			 return
			end
		showMess(Source.name .. ' (' .. #t_pls .. ')', ARGB(255, 255, 255, 255))
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')