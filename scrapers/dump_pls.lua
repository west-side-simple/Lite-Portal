-- скрапер-агрегатор TVS для загрузки плейлиста "Помойка+Чекер" самообновляемых бесплатных листов из интернета (26.10.24)
-- Copyright © 2020-2025 AnZo | Идея AnZo, основа Timofejj, чистка от дублей Wafee, правка и реализация BM&West_side
-- ## Переименовать каналы ##
	local filter = {
	{'", ", 2×2','2х2'},
	{'", ", Карусель','Карусель'},
	{'", ", Матч! ТВ','Матч! ТВ'},
	{'", ", РЕН ТВ','РЕН ТВ'},
	{'", ", Россия К','Россия К'},
	{'", ", СТС','СТС'},
	{'", ", СТС Love','СТС Love'},
	{'", ", ТВ 3','ТВ 3'},
	{'", ", ТНТ4','ТНТ4'},
	{'", ", Че','Че'},
	}
-- ## Переименовать группы ##
	local filter_grp = {
	{'DITV','Прочее'},
	{'Fashion','Развлекательные'},
	{'»Детские»,','Детские'},
	{'»Развлекательные»,','Развлекательные'},
	{'»Россия»','Федеральные'},
	{'»Россия»,','Федеральные'},
	{'»Спорт»,','Спорт'},
	{'Армения','Иностранные'},
	{'БОЛЬШОЙ ЭФИР','Спорт'},
	{'Взрослые [ВХОД СТРОГО 18+]','Взрослые'},
	{'Детские - Том и Джерри','Детские'},
	{'Женские','Развлекательные'},
	{'Зарубежные','Иностранные'},
	{'ИНФО','Информационные'},
	{'КИНОЗАЛЫ','Кино'},
	{'Кино и сериалы','Кино'},
	{'Кинозалы 2','Кино'},
	{'Кинозалы A-Media','Кино'},
	{'Кинозалы BCU [нестабильные]','Кино'},
	{'Кинозалы BOX [нестабильные]','Кино'},
	{'Кинозалы CineMan [нестабильные]','Кино'},
	{'Кинозалы CPS','Кино'},
	{'Кинозалы Clarity4k','Кино'},
	{'Кинозалы Clarity4K [нестабильные]','Кино'},
	{'Кинозалы High Network','Кино'},
	{'Кинозалы MM [нестабильные]','Кино'},
	{'Кинозалы PG','Кино'},
	{'Кинозалы Velilla TV','Кино'},
	{'Кинозалы ПерсикТВ','Кино'},
	{'Кинозалы ПерсикТВ [нестабильные]','Кино'},
	{'Кинозалы','Кино'},
	{'Кухня','Познавательные'},
	{'Музыкальные','Музыка'},
	{'Мультфильмы','Детские'},
	{'Национальные','Региональные'},
	{'Наш спорт','Спорт'},
	{'Новости','Информационные'},
	{'Общероссийские','Федеральные'},
	{'Общие','Федеральные'},
	{'ПЕРСИК ТВ','Прочее'},
	{'Политические','Информационные'},
	{'Природа','Познавательные'},
	{'Региoнальные','Региональные'},
	{'Релакс','Развлекательные'},
	{'Религиозные','Развлекательные'},
	{'Религия','Познавательные'},
	{'Спортивные','Спорт'},
	{'Федеральные плюс','Федеральные'},
	{'Хобби','Развлекательные'},
	{'Чебурашка ТВ','Прочее'},
	{'Эфирные','Федеральные'},
	}

	module('dump_pls', package.seeall)
	local my_src_name = 'Помойка+'
--	local sqlstr = "DELETE FROM Channels WHERE ExtFilter IN ( SELECT Id FROM ExtFilter WHERE Name='".. my_src_name .."' );"
--		m_simpleTV.Database.ExecuteSql(sqlstr, true)
--		m_simpleTV.PlayList.Refresh()

	function GetSettings()
	 return {name = my_src_name, sortname = '9', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '..\\Channel\\logo\\Icons\\deniz.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 1, show_progress = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 1, FilterGR = 1, GetGroup = 1, LogoTVG = 1}, STV = {add = 1, ExtFilter = 1, FilterCH = 1, FilterGR = 1, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoSearchEPG	= 1, AutoSearchLogo = 1, UseTvgIdTag = 1, UseLocalLogoOnly = 0, AutoNumber = 1, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, DeleteBeforeLoad = 1, RemoveDupCH = 1, SkipDuplicate = 1, UseUpdateID = 0, TypeSkip = 0, TypeFind = 0, TypeMedia = 0, TypeFindUseGr = 0}}
	end

	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function ProcessFilterTableLocal(t)
		if not type(t) == 'table' then return end
		for i = 1, #t do
			t[i].name = tvs_core.tvs_clear_double_space(t[i].name)
			for _, ff in ipairs(filter) do
				if (type(ff) == 'table' and t[i].name == ff[1]) then
					t[i].name = ff[2]
				end
			end
			t[i].group = tvs_core.tvs_clear_double_space(t[i].group)
			for _, fg in ipairs(filter_grp) do
				if (type(fg) == 'table' and t[i].group == fg[1]) then
					t[i].group = fg[2]
				end
			end
		end
	 return t
	end

	local function xren(s)
		if not s then
			return ''
		end
		s = s:lower()
		s = s:gsub('*', '')
		s = s:gsub('%s+', ' ')
		s = s:gsub('^%s*(.-)%s*$', '%1')
		local a = {
				{'А', 'а'}, {'Б', 'б'}, {'В', 'в'}, {'Г', 'г'}, {'Д', 'д'}, {'Е', 'е'}, {'Ж', 'ж'}, {'З', 'з'},
				{'И', 'и'},	{'Й', 'й'}, {'К', 'к'}, {'Л', 'л'}, {'М', 'м'}, {'Н', 'н'}, {'О', 'о'}, {'П', 'п'},
				{'Р', 'р'}, {'С', 'с'},	{'Т', 'т'}, {'Ч', 'ч'}, {'Ш', 'ш'}, {'Щ', 'щ'}, {'Х', 'х'}, {'Э', 'э'},
				{'Ю', 'ю'}, {'Я', 'я'}, {'Ь', 'ь'},	{'Ъ', 'ъ'}, {'Ё', 'е'},	{'ё', 'е'}, {'Ф', 'ф'}, {'Ц', 'ц'},
				{'У', 'у'}, {'Ы', 'ы'}, -- russian
				{'A', 'a'}, {'B', 'b'}, {'C', 'c'}, {'D', 'd'}, {'E', 'e'}, {'F', 'f'}, {'G', 'g'}, {'H', 'h'},
				{'I', 'i'},	{'J', 'j'}, {'K', 'k'}, {'L', 'l'}, {'M', 'm'}, {'N', 'n'}, {'O', 'o'}, {'P', 'p'},
				{'Q', 'q'}, {'R', 'r'},	{'S', 's'}, {'T', 't'}, {'U', 'u'}, {'V', 'v'}, {'W', 'w'}, {'X', 'x'},
				{'Y', 'y'}, {'Z', 'z'},	-- english
				}
		for _, v in pairs(a) do
			s = s:gsub(v[1], v[2])
		end
		return s
	end

	local function examination(t, n, is, timeout_ex, type_sorting, mess)
		local start_time = os.time()
		local current_time
		local current_delta
		if type_sorting then
			if type_sorting == 1 then
				table.sort(t, function(a, b) return xren(a.Name):gsub(' (%d)$',' 0%1'):gsub(' (%d) ',' 0%1 ') < xren(b.Name):gsub(' (%d)$',' 0%1'):gsub(' (%d) ',' 0%1 ') end)
			end
			if type_sorting == 2 then
				table.sort(t, function(a, b) return xren(a.Name):gsub(' (%d)$',' 0%1'):gsub(' (%d) ',' 0%1 ') > xren(b.Name):gsub(' (%d)$',' 0%1'):gsub(' (%d) ',' 0%1 ') end)
			end
			if type_sorting == 3 then
				table.sort(t, function(a, b) return a.Address < b.Address end)
			end
			if type_sorting == 4 then
				table.sort(t, function(a, b) return a.Address > b.Address end)
			end
		end
		if not is then return t end
		local session1 = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) ApplewebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session1 then return end
		m_simpleTV.Http.SetTimeout(session1, (timeout_ex or 1000))
		local t1, t2, i = {}, {}, 1
        for k = 1, n do
			local rc2, answer2 = m_simpleTV.Http.Request(session1, {url = t[k].address})
			t1[k] = {}
			t2[i] = {}
			if rc2 ~= 200 and rc2 ~= 302 then
				t1[k].name = '❌ ' .. t[k].name
			else
				t1[k].name = '✅ ' .. t[k].name
				t2[i].name = t[k].name
				t2[i].address = t[k].address
				t2[i].group = t[k].group
				t2[i].logo = t[k].logo
				t2[i].RawM3UString = t[k].RawM3UString
				i = i + 1
			end
			current_time = os.time()
			current_delta = current_time - start_time
			if k > 9 then
				if k == n then
					m_simpleTV.OSD.ShowMessageT({text = 'Результаты проверки:\nВремя сканирования: ' .. math.floor (current_delta/60) .. ' минут ' .. (current_delta - math.floor (current_delta/60)*60) .. ' секунд)\nРабочих каналов: ' .. #t2 .. '\n-----------------------------------------------------------------\n', showTime = 1000 * 5})
					debug_in_file(mess .. '\nРезультаты проверки:\nВремя сканирования: ' .. math.floor (current_delta/60) .. ' минут ' .. (current_delta - math.floor (current_delta/60)*60) .. ' секунд)\nРабочих каналов: ' .. #t2 .. '\n-----------------------------------------------------------------\n')
				elseif current_delta < 10 then
					m_simpleTV.OSD.ShowMessageT({text = mess .. 'Внимание! Идёт проверка каналов: ' .. k .. ' из ' .. n .. '\nДо окончания проверки ~' .. math.floor (timeout_ex*(n-k)/1000/60) .. ' минут ' .. (timeout_ex*(n-k)/1000 - math.floor (timeout_ex*(n-k)/1000/60)*60) .. ' секунд' .. '\n-----------------------------------------------------------------\n' .. t1[k].name .. '\n', color = ARGB(255, 229, 158, 31), showTime = 1000 * 5})
				else
					m_simpleTV.OSD.ShowMessageT({text = 'Внимание! Идёт проверка каналов: ' .. k .. ' из ' .. n .. '\nДо окончания проверки: ~ ' .. math.floor (timeout_ex*(n-k)/1000/60) .. ' мин ' .. (timeout_ex*(n-k)/1000 - math.floor (timeout_ex*(n-k)/1000/60)*60) .. ' сек' .. '\n-----------------------------------------------------------------\n' .. t1[k].name .. '\n' .. t1[k-1].name .. '\n' .. t1[k-2].name .. '\n' .. t1[k-3].name .. '\n' .. t1[k-4].name .. '\n' .. t1[k-5].name .. '\n' .. t1[k-6].name .. '\n' .. t1[k-7].name .. '\n' .. t1[k-8].name .. '\n' .. t1[k-9].name, color = ARGB(255, 135, 206, 250), showTime = 1000 * 5})
				end
			end
			k = k + 1
		end
		m_simpleTV.Http.Close(session1)
	return t2
	end

	local function MakeCatchupStr(str)
		local catchup = str:match('(catchup=".-")') or  str:match('(catchup%-type=".-")')
		local d = str:match('tvg%-rec="(%d+)') or str:match('catchup%-days="(%d+)') or str:match('timeshift="(%d+)')
		local days = d and 'catchup-days="' ..d..'"' or nil
		local source = str:match('(catchup%-source=".-")')
		if d and tonumber(d)>0 and not str:find('catchup=') then catchup = 'catchup="shift"' end
		local raw = ''
		if catchup then raw = raw .. catchup  end
		if days then raw = raw ..' ' .. days end
		if source then raw = raw .. ' '..source end
		return raw
	end

	local function LoadFromSite(is, timeout_ex, sorting)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) ApplewebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 60000)
        local url
        pll={
--     {"aHR0cHM6Ly9wYm94LnN1L1hZWmsydkFUZE1LTC5tM3U","DiTV"},
        {"aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2JsYWNrYmlyZHN0dWRpb3J1cy9Mb2dhbmV0WElQVFYvbWFpbi9Mb2dhbmV0WEFsbC5tM3U","LoganetXAll"},
        {"aHR0cHM6Ly9jbGNrLnJ1LzNGNlpoaA","Mr.Credo"},
        {"aHR0cHM6Ly9pcHR2c2hhcmVkLnVjb3oubmV0L0lQVFZfU0hBUkVELm0zdQ","IPTV_SHARED"},
        {"aHR0cHM6Ly9jbGNrLnJ1LzNGVHBFQw","texno Zona TV"},
        {"aHR0cHM6Ly92ZXJhbnpvLnJ1L290aGVyL2Fuem8ubTN1","Reserves"},
--        {"aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL05leHRlcnItb3JpZ2luL3NpbXBsZVRWLVBsYXlsaXN0cy9tYWluL3JlZ2lvbnM","regions"},
--        {"aHR0cHM6Ly9iaXQubHkvM05oeUwyMA","Плюш"},
--        {"aHR0cDovL2RtaTN5LXR2LnJ1L2lwdHYvUGxheWxpc3QtMDUubTN1","dmiTry"},
--        {"aHR0cHM6Ly9zbWFydHR2bmV3cy5ydS9hcHBzL2lwdHZjaGFubmVscy5tM3U=","Тест 5"},
--        {"aHR0cDovL2JsdWVjcmFic3R2LmRvLmFtL0ZyZWUubTN1","BlueCrabs"},
--        {"aHR0cHM6Ly93d3cudmVyYW56by5ydS9vdGhlci90Zy5tM3U=","Тест 6"},
}
        plt, answer, txtstr = {}, '', ''
        for j = 1,#pll do
			plt[j] = {}
			plt[j].act = pll[j][1]
			plt[j].name = pll[j][2]
			url = plt[j].act
			m_simpleTV.OSD.ShowMessageT({text = 'Загрузка плейлистов: ' .. j .. ' из ' .. #pll, color = ARGB(255, 0, 255, 0), showTime = 1000 * 30})
			rc, answer1 = m_simpleTV.Http.Request(session, {url = decode64(url)})
			if answer1 and answer1:match('^#EXTM3U') then
				answer1 = answer1:gsub('%#EXTVLCOPT.-\n','')
				answer1 = answer1:gsub('#EXTINF','# \n#EXTINF')
				answer1 = answer1 .. '\n# \n'
				answer = answer1 .. answer
				txtstr = txtstr .. 'Плейлист ' .. j .. ' из ' .. #pll .. ' - ' .. plt[j].name .. ': Ок!\n'
			else
				txtstr = txtstr .. 'Плейлист ' .. j .. ' из ' .. #pll .. ' - ' .. plt[j].name .. ': Error!\n'
			end
			j = j + 1
        end
		m_simpleTV.OSD.ShowMessageT({text = 'Результат загрузки плейлистов:\n-----------------------------------------------------------------\n' .. txtstr, color = ARGB(255, 255, 192, 203), showTime = 1000 * 10})
		m_simpleTV.Http.Close(session)
--		m_simpleTV.Common.Sleep(3000)
        local t, t1, i = {}, {}, 1
		for w in answer:gmatch('%#EXTINF:.-[\r\n]http.-[\r\n]') do
           -- debug_in_file(i..'. *********************')
           -- debug_in_file(w)
           -- debug_in_file('----------')
		   
            local title = w:match(',(.-)[\r\n]')
            local adr = w:match('[\r\n](http.-)[\r\n]') or w:match('[\r\n](rtmp.-)[\r\n]')
            local logo = w:match('tvg%-logo="(.-)"')
			local RawM3UString = w:match('#EXTINF:(.-)[\r\n]'):gsub('duration', 'offset')
			--[[
			local days = RawM3UString:match('tvg%-rec="(%d)') or RawM3UString:match('catchup%-days="(%d)') or RawM3UString:match('timeshift="(%d)')
			if days and tonumber(days) > 0 then
				if not RawM3UString:match('catchup=".-"') then
					RawM3UString = RawM3UString .. ' ' .. 'catchup="shift"'
				end
			end
			]]
			RawM3UString = MakeCatchupStr(RawM3UString)
            if not adr or not title then break end
			t[i] = {}
			t[i].name = title
			t[i].address = adr
			t[i].group = w:match('group%-title="([^"]+)') or 'Новые каналы'
			t[i].logo = logo
			t[i].RawM3UString = RawM3UString
			--[[
            debug_in_file("name = ".. (t[i].name or 'nil') )
            debug_in_file("adr = ".. (t[i].address or 'nil') )
            debug_in_file("logo = ".. (t[i].logo or 'nil') )
            debug_in_file("group = ".. (t[i].group or 'nil') )
			debug_in_file("RawM3UString = ".. (RawM3UString or 'nil'))
			]]
			i = i + 1
			--if i>700 then break end
		end
		t1 = examination(t, #t, is, timeout_ex, sorting, 'Результат загрузки плейлистов:\n-----------------------------------------------------------------\n' .. txtstr .. 'Агрегировано каналов: ' .. #t .. ' из ' .. #pll .. ' плейлистов')
        if #t1 == 0 then return end
		local hash, tab = {}, {}
		for i = 1, #t1 do
			if t1[i].address and not hash[t1[i].address]
			then
				tab[#tab + 1] = t1[i]
				hash[t1[i].address] = true
			end
		end
		if #tab == 0 then return end
		return tab
    end

	function GetList(UpdateID, m3u_file)
		if not UpdateID then return end
		if not m3u_file then return end
		if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
--------------параметры
		local is = true -- true or false - флаг проверки
		local timeout_ex = 1000 -- 1000, 2000, ... - timeout ожидание отклика потока
		local sorting = false -- сортировка: false or 1 - ABC or 2 - inv_ABC or 3 - adr or 4 - inv_adr
-----------------------
		local t_pls = LoadFromSite(is, timeout_ex, sorting)
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
		debug_in_file('\n\n\n\n+++++++++++++++++++++++')
		debug_in_file(m3ustr)
		local handle = io.open(m3u_file, 'w+')
		if not handle then return end
		handle:write(m3ustr)
		handle:close()
		return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')