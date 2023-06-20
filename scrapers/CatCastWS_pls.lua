-- скрапер TVS для загрузки плейлистов "CatCast" https://catcast.tv/ (19/06/2023)
-- необходим видоскрипт: catcast.lua


module('CatCastWS_pls', package.seeall)
local my_src_name = 'CatCastWS'

function GetSettings()
 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://catcast.tv/assets/no-logo.svg', TypeSource = 1, TypeCoding = 1, DeleteM3U = 0, RefreshButton = 1, show_progress = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 1}, STV = {add = 1, ExtFilter = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo = 1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0}}
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
		m_simpleTV.Http.SetTimeout(session, 300000)

		local t, i = {}, 1

			local function getTbl(t, i, tab)
				local k = 1
				while tab.data.list.data[k] do
					if tab.data.list.data[k].is_online and tab.data.list.data[k].is_autopilot and not tab.data.list.data[k].need_password and not tab.data.list.data[k].is_banned then
					t[i] = {}
					t[i].name = (unescape3(tab.data.list.data[k].name:gsub('\u00a0', ' ')) .. ' '):gsub('%s+', ' '):gsub('%p', ' '):gsub('  ', ' '):gsub('%&nbsp;', ' '):gsub('u2605', '')
					t[i].id = tab.data.list.data[k].id
					t[i].video_desc = (unescape3(tab.data.list.data[k].description_text:gsub('\u00a0', ' ')) .. ' '):gsub('%s+', ' '):gsub('%p', ' '):gsub('  ', ' '):gsub('%&nbsp;', ' ') .. ' id=' .. t[i].id
					t[i].address = 'https://catcast.tv/' .. unescape3(tab.data.list.data[k].shortname)
					t[i].logo = tab.data.list.data[k].background or tab.data.list.data[k].logo
					if tab.data.list.data[k].tags and tab.data.list.data[k].tags[1] then
					local j, tags = 1, ''
					while true do
					if not (tab.data.list.data[k].tags and tab.data.list.data[k].tags[j]) then break end
					tags = tags .. ', ' .. (unescape3(tab.data.list.data[k].tags[j]:gsub('\u00a0', ' ')) .. ' '):gsub('%s+', ' '):gsub('%p', ' '):gsub('  ', ' '):gsub('%&nbsp;', ' ')
					j=j+1
					end
					t[i].video_title = tags:gsub('^, ', ''):gsub(' , ', ', ')
					if t[i].video_title:match('СССР') or t[i].video_title:match('USSR') or t[i].video_title:match('ussr') or t[i].video_title:match('ссср')
						then t[i].group = 'CastTV - USSR' t[i].group_logo = '../Channel/Logo/CatCast/СССР.png'
						elseif t[i].video_title:match('мульт') or t[i].video_title:match('дети') or t[i].video_title:match('детям') or t[i].video_title:match('детское')
						then t[i].group = 'CastTV - cartoons' t[i].group_logo = '../Channel/Logo/CatCast/Мульты.png'
						elseif t[i].video_title:match('юмор') or t[i].video_title:match('прикол')
						then t[i].group = 'CastTV - humor't[i].group_logo = '../Channel/Logo/CatCast/Юмор.png'
						elseif t[i].video_title:match('музыка') or t[i].video_title:match('Музыка') or t[i].video_title:match('песня') or t[i].video_title:match('Песня') or t[i].video_title:match('шансон') or t[i].video_title:match('music') or t[i].video_title:match('MUSIC') or t[i].video_title:match('pop') or t[i].video_title:match('POP') or t[i].video_title:match('hit') or t[i].video_title:match('HIT') or t[i].video_title:match('Hit')
						then t[i].group = 'CastTV - music' t[i].group_logo = '../Channel/Logo/CatCast/Музыка.png'
						elseif t[i].video_title:match('сериал') or t[i].video_title:match('СЕРИАЛ') or t[i].video_title:match('Сериал')
						then t[i].group = 'CastTV - series' t[i].group_logo = '../Channel/Logo/CatCast/Сериал.png'
						elseif t[i].video_title:match('кино') or t[i].video_title:match('FILM') or t[i].video_title:match('film') or t[i].video_title:match('КИНО') or t[i].video_title:match('Фильм') or t[i].video_title:match('фильм') or t[i].video_title:match('ФИЛЬМ')
						then t[i].group = 'CastTV - films' t[i].group_logo = '../Channel/Logo/CatCast/Фильмы.png'
						elseif t[i].video_title:match('игры')
						then t[i].group = 'CastTV - games' t[i].group_logo = '../Channel/Logo/CatCast/Игры.png'
						elseif t[i].video_title:match('тв') or t[i].video_title:match('ТВ') or t[i].video_title:match('Телеканал')
						then t[i].group = 'CastTV - channels' t[i].group_logo = '../Channel/Logo/CatCast/Каналы.png'
						else t[i].group = 'CastTV - other' t[i].group_logo = '../Channel/Logo/CatCast/Другие.png' end
						else t[i].group = 'CastTV' t[i].group_logo = '../Channel/Logo/CatCast/Несортированные.png' t[i].video_title = 'CastTV'
					end
--					debug_in_file( i .. '. ' .. t[i].id .. '\n', 'c://1/catcast.txt', setnew )
					i = i + 1
					end
					k = k + 1
				end
			 return t, i
			end

			for c = 1, 340 do

				local tt = {}
				tt.url = 'https://api.catcast.tv/api/channels?page=' .. c
				tt.method = 'get'
				tt.headers = 'X-Timezone-Offset: -180\nReferer: https://catcast.tv/tv/online'
				local rc, answer = m_simpleTV.Http.Request(session, tt)
				if rc ~= 200 then
				return
				end

					answer = unescape3(answer):gsub('(%[%])', '"nil"')
--					debug_in_file( 'page=' .. c .. '\n----------------------\n', 'c://1/catcast.txt', setnew )
					require 'json'
					local tab = json.decode(answer)
					if not tab.data.list.data then return end

						t, i = getTbl(t, i, tab)

				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/progress1/p' .. math.floor(c/340*100+0.5) .. '.png"', text = ' - общий прогресс загрузки: ' .. c, color = ARGB(255, 255, 255, 255), showTime = 1000 * 30})
			end

		m_simpleTV.Http.Close(session)

		if #t == 0 then return end
		local hash, t0 = {}, {}
		for i = 1, #t do
			if not hash[t[i].address]
			then
				t0[#t0 + 1] = t[i]
				hash[t[i].address] = true
			end
		end
		return t0
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