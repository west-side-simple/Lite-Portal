-- TVS scraper to download playlist "CDN API" (08/05/22)
-- base script nexterr, mod west_side
-- ## needed ##
-- vidoscript: videoapi.lua
-- ##
	module('cdnapi_imdb_pls', package.seeall)
	local my_src_name = 'CDN API'
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
--		showMess('«Фильмы 2» загрузка ...', ARGB(255, 153, 255, 153), 600000)
		local t, i = {}, 1
			local function getTbl(t, k, tab)
				local j = 1
					while tab.data[j] and tab.data[j].iframe_src do
						local imdb_id = tab.data[j].imdb_id or ''
						local adr = tab.data[j].iframe_src
						local type = tab.data[j].type
						local year = tab.data[j].year or '0'
						year = year:match('(%d+)%-')
						local group = ''
							t[k] = {}
							t[k].address = 'https:' .. adr:gsub('^https%:', '') .. '&embed=' .. imdb_id
							t[k].logo = ''

							if tonumber(year) <= 1950 then group = '1950 and after' end
							if tonumber(year) > 1950 and tonumber(year) <= 1970  then group = '1951 - 1970' end
							if tonumber(year) > 1970 and tonumber(year) <= 1980  then group = '1971 - 1980' end
							if tonumber(year) > 1980 and tonumber(year) <= 1991  then group = '1981 - 1991' end
							if tonumber(year) > 1991 and tonumber(year) <= 2000  then group = '1992 - 2000' end
							if tonumber(year) > 2000 and tonumber(year) <= 2005  then group = '2001 - 2005' end
							if tonumber(year) > 2005 and tonumber(year) <= 2010  then group = '2006 - 2010' end
							if tonumber(year) > 2010 and tonumber(year) <= 2015  then group = '2011 - 2015' end
							if tonumber(year) == 2016 then group = '2016' end
							if tonumber(year) == 2017 then group = '2017' end
							if tonumber(year) == 2018 then group = '2018' end
							if tonumber(year) == 2019 then group = '2019' end
							if tonumber(year) == 2020 then group = '2020' end
							if tonumber(year) == 2021 then group = '2021' end
							if tonumber(year) > 2021 then group = '2022 and last' end
							if type == 'movie' then
							t[k].group = type .. ': ' .. group
							else
							t[k].group = type
							end
							t[k].name = tab.data[j].title:gsub('"', '%%22')
							t[k].name = t[k].name .. ' (' .. year .. ')'

							k = k + 1

						j = j + 1
					end
			 return t, k
			end
			local url = decode64('aHR0cHM6Ly81MTAyLnN2ZXRhY2RuLmluL2FwaS9zaG9ydD9hcGlfdG9rZW49d3pzWEdZM21wQWR3RG40cDJqSUNITmJPMXRkZFdEZjI=')
			local rc, answer = m_simpleTV.Http.Request(session, {url = url})
			local inpage = answer:match('last_page_url.-page=(%d+)')
			for c = 1, tonumber(inpage) do

				local url = string.format(decode64('aHR0cHM6Ly81MTAyLnN2ZXRhY2RuLmluL2FwaS9zaG9ydD9hcGlfdG9rZW49d3pzWEdZM21wQWR3RG40cDJqSUNITmJPMXRkZFdEZjImcGFnZT0lcw=='), c)
				local rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc == 200 and answer:match('"id"') then
				if c==1 then t1=os.time() end
					answer = answer:gsub('%[%]', '""')
					local tab = json.decode(answer)
					if tab and tab.data then
						t, i = getTbl(t, i, tab)
					end
				else
				t2=os.time()
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/poisk.png"', text = 'Time ' .. t2-t1 .. ' s. Happy viewing', color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
				 break
				end
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/progress1/p' .. math.floor(c/inpage*100+0.5) .. '.png"', text = ' - overall download progress: ' .. c, color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
				if c == tonumber(inpage) then
				t2=os.time()
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/poisk.png"', text = 'Time ' .. t2-t1 .. ' s. Happy viewing', color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
				end
			end
		m_simpleTV.Http.Close(session)
			if #t == 0 then return end
			local t1 = table_reverse (t)
			for a = 1,#t1 do
			if a<=20
			then
			t1[a].group = 'Last content'
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
				showMess(Source.name .. ': playlist loading error', ARGB(255, 255, 102, 0))
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