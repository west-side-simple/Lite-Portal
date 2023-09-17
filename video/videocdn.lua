-- видеоскрипт для видеобалансера "videocdn" https://videocdn.tv (01/07/22)
-- Copyright © 2017-2022 Nexterr | https://github.com/Nexterr-origin/simpleTV-Scripts
-- mod - west_side (30/04/23)
-- ## открывает подобные ссылки ##
-- https://32.svetacdn.in/fnXOUDB9nNSO?kp_id=5928
-- https://32.tvmovies.in/fnXOUDB9nNSO/tv-series/92
-- https://32.tvmovies.in/fnXOUDB9nNSO/movie/22080
-- http://32.svetacdn.in/fnXOUDB9nNSO/movie/36905
-- ## домен ##
local domen = 'https://567886534688564.svetacdn.in'
-- '' - по умолчанию
-- 'http://58.svetacdn.in' (пример)
-- ## прокси ##
local proxy = ''
-- '' - нет
-- 'https://proxy-nossl.antizapret.prostovpn.org:29976' (пример)
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('^https?://[%w%.]*videocdn%.')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://.-/fnXOUDB9nNSO')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://.-/PXk2QGbvEVmS')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://.-/CtpKt94RDwED')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://.-/Z9w3z4ZBIQxF')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://.-/z3jFqN8Tz3Ta')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://.-/33cHYTFTAlwP')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://.-/fz41ePu9lzFL')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://.-/SZLMKH3vCY0W')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://.-/ra5OAHwotvWa')
--			and not m_simpleTV.Control.CurrentAddress:match('^https?://[%w%.]*svetacdn%.')
			and not m_simpleTV.Control.CurrentAddress:match('^$videocdn')
		then
		 return
		end
	local inAdr = m_simpleTV.Control.CurrentAddress
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36', proxy, false)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	if domen ~= '' then
		inAdr = inAdr:gsub('^https?://.-/', domen .. '/')
	end
	htmlEntities = require 'htmlEntities'
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	if inAdr:match('^$videocdn') or not inAdr:match('&kinopoisk') then
		if m_simpleTV.Control.MainMode == 0 then
			m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = '', TypeBackColor = 0, UseLogo = 0, Once = 1})
		end
	end
local function imdbid(kpid)
	if kpid == '77264' then return 'tt0086333','Шерлок Холмс и доктор Ватсон: Сокровища Агры','1983' end
	local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPW9TN1d6dk5meGU0SzhPY3NQanBBSVU2WHUwMVNpMGZtJmtpbm9wb2lza19pZD0=') .. kpid
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
		if rc5~=200 then
		return '','',''
		end
		require('json')
		answer_vn = answer_vn:gsub('(%[%])', '"nil"')
		local tab_vn = json.decode(answer_vn)
		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].imdb_id and tab_vn.data[1].imdb_id ~= 'null' and tab_vn.data[1].year then
		return tab_vn.data[1].imdb_id or '', tab_vn.data[1].title or '',tab_vn.data[1].year:match('%d%d%d%d') or ''
		elseif tab_vn and tab_vn.data and tab_vn.data[1] and ( not tab_vn.data[1].imdb_id or tab_vn.data[1].imdb_id ~= 'null') then
		return '', tab_vn.data[1].title or '',tab_vn.data[1].year:match('%d%d%d%d') or ''
		else return '','',''
		end
end
local function bg_imdb_id(imdb_id)
	local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
	local rc5,answerd = m_simpleTV.Http.Request(session,{url=urld})
	if rc5~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	require('json')
	answerd = answerd:gsub('(%[%])', '"nil"')
	local tab = json.decode(answerd)
	local background, name_tmdb, year_tmdb, overview_tmdb, tv, id = '', '', '', '', 0, ''
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then background = '' else
	if tab.movie_results[1] then
	background = tab.movie_results[1].backdrop_path or ''
	name_tmdb = tab.movie_results[1].title or ''
	year_tmdb = tab.movie_results[1].release_date or ''
	overview_tmdb = tab.movie_results[1].overview or ''
	tv = 0
	id = tab.movie_results[1].id
	elseif tab.tv_results[1] then
	background = tab.tv_results[1].backdrop_path or ''
	name_tmdb = tab.tv_results[1].name or ''
	year_tmdb = tab.tv_results[1].first_air_date or ''
	overview_tmdb = tab.tv_results[1].overview or ''
	tv = 1
	id = tab.tv_results[1].id
	end
	end
	if year_tmdb and year_tmdb ~= '' then
	year_tmdb = year_tmdb:match('%d%d%d%d')
	else year_tmdb = 0 end
	if background and background ~= nil and background ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background end
	if background == nil then background = '' end
	return background, name_tmdb, year_tmdb, overview_tmdb, tv, id
end
local function title_translate(translate)
	require 'lfs'
	local rc, answer, name_translate
	local url = 'aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHJhbnNsYXRpb25zP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbQ=='
	local t,i,page = {},1,1
	local str = ''
	local filePath = m_simpleTV.MainScriptDir .. 'user/westSidePortal/core/db_tr.txt' -- DB translations
	local fhandle = io.open(filePath, 'r')
	if not fhandle then
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 60000)
		for page = 1,22 do
			rc, answer = m_simpleTV.Http.Request(session, {url = decode64(url) .. '&page=' .. page .. '&limit=100'})
			require('json')
			if not answer then return end
			answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
			local tab = json.decode(answer)
			local j = 1
			if not tab or not tab.data or not tab.data[1] then return end
			while true do
			if not tab.data[j] then break end
				t[i]={}
				t[i].Id = i
				t[i].Name = unescape3(tab.data[j].smart_title)
				t[i].Action = tab.data[j].id
				t[i].InfoPanelTitle = unescape3(tab.data[j].title)
				if tonumber(t[i].Action) == tonumber(translate) then name_translate = unescape3(t[i].InfoPanelTitle) end
				str = str .. '\n/' .. t[i].Action .. '/' .. t[i].Name .. '/' .. t[i].InfoPanelTitle .. '/'
				i = i + 1
				j = j + 1
			end
			page = page + 1
		end
		m_simpleTV.Http.Close(session)
		fhandle = io.open(filePath, 'w+')
		if fhandle then
			fhandle:write(str)
			fhandle:close()
		end
	else
		fhandle = io.open(filePath, 'r')
		answer = fhandle:read('*a')
		fhandle:close()
		for w in answer:gmatch('/.-/\n') do
			t[i]={}
			t[i].Id = i
			t[i].Name = w:match('^/.-/(.-)/')
			t[i].Action = w:match('^/(.-)/')
			t[i].InfoPanelTitle = w:match('^/.-/.-/(.-)/')
			if tonumber(t[i].Action) == tonumber(translate) then return unescape3(t[i].InfoPanelTitle) end
			i = i + 1
		end
		return 'Озвучка - ' .. translate
	end
end
	local psevdotv
	if inAdr:match('PARAMS=psevdotv') then
		psevdotv = true
	end
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''

	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.Videocdn then
		m_simpleTV.User.Videocdn = {}
	end
	if not m_simpleTV.User.TMDB then
		m_simpleTV.User.TMDB = {}
	end
	if not m_simpleTV.User.Videocdn.qlty then
		m_simpleTV.User.Videocdn.qlty = tonumber(m_simpleTV.Config.GetValue('Videocdn_qlty') or '10000')
	end
	if not inAdr:match('^$videocdn') then
	m_simpleTV.User.Videocdn.translate = nil
	m_simpleTV.User.Videocdn.title_translate = nil
	m_simpleTV.User.Videocdn.TranslateTable = nil
	m_simpleTV.User.Videocdn.title = nil
	m_simpleTV.User.Videocdn.year = nil
	m_simpleTV.User.Videocdn.embed = nil
	m_simpleTV.User.Videocdn.overview = nil
	m_simpleTV.User.TMDB.Id = nil
	m_simpleTV.User.TMDB.tv = nil
	end
	local translate = inAdr:match('%?translation=(%d+)')
	if translate then
	m_simpleTV.User.Videocdn.translate = translate
	m_simpleTV.User.Videocdn.title_translate = title_translate(translate)
	end
	local imdb_id, kp_id
	if inAdr:match('&embed=') or inAdr:match('kp_id=')
	then m_simpleTV.User.Videocdn.embed = inAdr:match('&embed=(.-)$') or inAdr:match('kp_id=(.-)$')
	end
	inAdr = inAdr:gsub('%?translation=.-$', ''):gsub('&embed=.-$', ''):gsub('&block.-$', '')
	if not inAdr:match('^$videocdn') then
	m_simpleTV.User.Videocdn.adr = inAdr
	end
	if m_simpleTV.User.Videocdn.embed then
	imdb_id = m_simpleTV.User.Videocdn.embed:match('tt%d+')
	if not imdb_id then kp_id = m_simpleTV.User.Videocdn.embed:match('(%d+)') end
	end
	local title_v, year_v
	if kp_id then imdb_id, title_v, year_v = imdbid(kp_id) end
	local logo = 'https://www.videocdn.tv/favicon.png'
	if imdb_id and imdb_id~='' and bg_imdb_id(imdb_id) and bg_imdb_id(imdb_id)~='' then
	m_simpleTV.User.Videocdn.background, m_simpleTV.User.Videocdn.title, m_simpleTV.User.Videocdn.year, m_simpleTV.User.Videocdn.overview, m_simpleTV.User.TMDB.tv, m_simpleTV.User.TMDB.Id = bg_imdb_id(imdb_id)
	m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.TMDB.Id .. ',' .. m_simpleTV.User.TMDB.tv
	m_simpleTV.Control.ChangeChannelLogo(m_simpleTV.User.Videocdn.background, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = m_simpleTV.User.Videocdn.background, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	if not m_simpleTV.User.Videocdn.title and not m_simpleTV.User.Videocdn.year then
		m_simpleTV.User.Videocdn.title = title_v
		m_simpleTV.User.Videocdn.year = year_v
	end
--	if not m_simpleTV.User.Videocdn.background or m_simpleTV.User.Videocdn.background=='' then
--		m_simpleTV.Control.ChangeChannelLogo(logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
--	end
	local title
	if m_simpleTV.User.Videocdn.Tabletitle then
		local index = m_simpleTV.Control.GetMultiAddressIndex()
		if index then
			title = m_simpleTV.User.Videocdn.title or 'Videocdn' .. ' - ' .. m_simpleTV.User.Videocdn.Tabletitle[index].Name
		end
	end
	local function ShowInfo(s)
		local q = {}
			q.once = 1
			q.zorder = 0
			q.cx = 0
			q.cy = 0
			q.id = 'AK_INFO_TEXT'
			q.class = 'TEXT'
			q.align = 0x0202
			q.top = 0
			q.color = 0xFFFFFFF0
			q.font_italic = 0
			q.font_addheight = 6
			q.padding = 20
			q.textparam = 1 + 4
			q.text = s
			q.background = 0
			q.backcolor0 = 0x90000000
		m_simpleTV.OSD.AddElement(q)
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('AK_INFO_TEXT')
		end
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('AK_INFO_TEXT')
		end
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('AK_INFO_TEXT')
		end
		m_simpleTV.OSD.RemoveElement('AK_INFO_TEXT')
	end
	local function GetMaxResolutionIndex(t)
		local index
		for u = 1, #t do
				if t[u].qlty and m_simpleTV.User.Videocdn.qlty < t[u].qlty then break end
			index = u
		end
	 return index or 1
	end
	local function decodeUrl(n)
		local t, j = {}, 1
			for i = 1, #n, 3 do
				t[j] = {}
				t[j] = n:sub(i, i + 2)
				j = j + 1
			end
		n = '\\u0' .. table.concat(t, '\\u0')
	 return	unescape3(n)
	end
	local function GetQualityFromAddress(url, title)
		url = url:gsub('^$videocdn', '')
		local du = url:match('#(%w+)')
		if du then
			url = decodeUrl(du)
		else
			url = url:gsub('^%[', '')
		end
		local t = {}
			for adr in url:gmatch('%](//.-%.mp4)') do
				local qlty = adr:match('/(%d+)%.mp4')
				if qlty then
					t[#t + 1] = {}
					t[#t].qlty = tonumber(qlty)
					t[#t].Address = adr:gsub('^//', 'https://')
					t[#t].Name = qlty .. 'p'
--	debug_in_file(t[#t].Name .. ' ' .. t[#t].Address .. '\n',m_simpleTV.MainScriptDir .. 'user/westSide/answer.txt')
				end
			end
			if #t == 0 then return end
--[[		local adr1080 = t[1].Address:gsub('/%d+.mp4', '/1080.mp4')
		local rc, answer = m_simpleTV.Http.Request(session, {url = adr1080, method = 'head'})
		if rc == 200 then
			t[#t + 1] = {}
			t[#t].qlty = 1080
			t[#t].Address = adr1080
			t[#t].Name = '1080p'
			end--]]
		table.sort(t, function(a, b) return a.qlty < b.qlty end)
		local hash, tab = {}, {}
			for i = 1, #t do
				if not hash[t[i].qlty] then
					tab[#tab + 1] = t[i]
					hash[t[i].qlty] = true
				end
			end
		for i = 1, #tab do
			tab[i].Id = i
			tab[i].Address = tab[i].Address .. '$OPT:NO-STIMESHIFT'
--	debug_in_file(tab[i].Address .. '\n',m_simpleTV.MainScriptDir .. 'user/westSide/answer.txt')
			if psevdotv then
				local videoTitle = title:gsub('.-:', '')
				local k = tab[i].qlty
				tab[i].Address = tab[i].Address .. '$OPT:NO-SEEKABLE$OPT:sub-source=marq$OPT:marq-opacity=70$OPT:marq-size=' .. (0.03 * k) .. '$OPT:marq-position=6$OPT:marq-x=' .. (0.02 * k) .. '$OPT:marq-y=' .. (0.01 * k) .. '$OPT:marq-marquee=' .. m_simpleTV.Common.UTF8ToMultiByte(videoTitle)
			end
		end
		m_simpleTV.User.Videocdn.Table = tab
		local index = GetMaxResolutionIndex(tab)
		m_simpleTV.User.Videocdn.Index = index
	 return tab[index].Address
	end
	local function SaveVideocdnPlaylist()
		if m_simpleTV.User.Videocdn.Tabletitle then
			local t = m_simpleTV.User.Videocdn.Tabletitle
			if #t > 250 then
				m_simpleTV.OSD.ShowMessageT({text = 'Сохранение плейлиста ...', color = 0xff9bffff, showTime = 1000 * 30, id = 'channelName'})
			end
			local header = m_simpleTV.User.Videocdn.title
			local adr, name
			local m3ustr = '#EXTM3U $ExtFilter="Videocdn" $BorpasFileFormat="1"\n'
				for i = 1, #t do
					name = t[i].Name
					adr = t[i].Address:gsub('^$videocdn', '')
					adr = GetQualityFromAddress(adr)
					m3ustr = m3ustr .. '#EXTINF:-1 group-title="' .. header .. '",' .. name .. '\n' .. adr:gsub('$OPT:.+', '') .. '\n'
				end
			header = m_simpleTV.Common.UTF8ToMultiByte(header)
			header = header:gsub('%c', ''):gsub('[\\/"%*:<>%|%?]+', ' '):gsub('%s+', ' '):gsub('^%s*', ''):gsub('%s*$', '')
			local fileEnd = ' (Videocdn ' .. os.date('%d.%m.%y') ..').m3u'
			local folder = m_simpleTV.Common.GetMainPath(1) .. m_simpleTV.Common.UTF8ToMultiByte('сохраненые плейлисты/')
			lfs.mkdir(folder)
			local folderAk = folder .. 'Videocdn/'
			lfs.mkdir(folderAk)
			local filePath = folderAk .. header .. fileEnd
			local fhandle = io.open(filePath, 'w+')
			m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 1, id = 'channelName'})
			if fhandle then
				fhandle:write(m3ustr)
				fhandle:close()
				ShowInfo('плейлист сохранен в файл\n' .. m_simpleTV.Common.multiByteToUTF8(header) .. '\nв папку\n' .. m_simpleTV.Common.multiByteToUTF8(folderAk))
			else
				ShowInfo('невозможно сохранить плейлист')
			end
		end
	end
	local function play(retAdr, title)

		retAdr = GetQualityFromAddress(retAdr, title)
			if not retAdr then return end
		local extOpt
		if psevdotv then
			m_simpleTV.OSD.ShowMessageT({text = title, showTime = 1000 * 5, id = 'channelName'})
			m_simpleTV.Control.SetTitle(title)
		else
			m_simpleTV.OSD.ShowMessageT({text = title, color = 0xff9999ff, showTime = 1000 * 5, id = 'channelName'})
			m_simpleTV.Control.CurrentTitle_UTF8 = title
		end

		m_simpleTV.Control.CurrentAddress = retAdr

-- debug_in_file(retAdr .. '\n')
	end
	function Qlty_Videocdn()
		local t = m_simpleTV.User.Videocdn.Table
			if not t then return end
		local index = m_simpleTV.User.Videocdn.Index
		if not m_simpleTV.User.Videocdn.isVideo then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 💾 ', ButtonScript = 'SaveVideocdnPlaylist()'}
		end
		if m_simpleTV.User.Videocdn.TranslateTable then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 Озвучка VideoCDN ', ButtonScript = 'Tr_all()'}
		else
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ✕ ', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		end
		if #t > 0 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество VideoCDN', index - 1, t, 10000, 1 + 4 + 2)
			if ret == 1 then
				m_simpleTV.User.Videocdn.Index = id
				m_simpleTV.Control.SetNewAddress(t[id].Address, m_simpleTV.Control.GetPosition())
				m_simpleTV.Config.SetValue('Videocdn_qlty', t[id].qlty)
				m_simpleTV.User.Videocdn.qlty = t[id].qlty
			end
			if ret == 2 then
				SaveVideocdnPlaylist()
			end
			if ret == 3 then
				if m_simpleTV.User.Videocdn.TranslateTable then
					Tr_all()
				else
					m_simpleTV.Control.ExecuteAction(37)
				end
			end
		end
	end
	function Tr_all()
	local t1 = m_simpleTV.User.Videocdn.TranslateTable
	if not t1 then return end
	local t,current_id = {},1
	for i = 1,#t1 do
	t[i] = {}
	t[i].Id = i
	if tonumber(t1[i].Address) == tonumber(m_simpleTV.User.Videocdn.translate) then current_id = i end
	if m_simpleTV.User.Videocdn.embed then
	t[i].Address = m_simpleTV.User.Videocdn.adr .. '?translation=' .. t1[i].Address .. '&embed=' .. m_simpleTV.User.Videocdn.embed
	else
	t[i].Address = m_simpleTV.User.Videocdn.adr .. '?translation=' .. t1[i].Address
	end
	t[i].Name = t1[i].Name
	end
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ Качество ', ButtonScript = 'Qlty_Videocdn()'}
	if m_simpleTV.User.Videocdn.translate then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 VideoCDN озвучки ', ButtonScript = 'type_cdntr(\'&translation=' .. m_simpleTV.User.Videocdn.translate .. '\')'}
	end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔊 Озвучка VideoCDN', tonumber(current_id)-1, t, 5000, 1 + 4 + 2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.SetNewAddress(t[id].Address, m_simpleTV.Control.GetPosition())
		end
		if ret == 2 then
			Qlty_Videocdn()
		end
		if ret == 3 then
			type_cdntr('&translation=' .. m_simpleTV.User.Videocdn.translate)
		end
	end
	m_simpleTV.User.Videocdn.isVideo = false
		if inAdr:match('^$videocdn') then
			play(inAdr, title)
		 return
		end
	inAdr = inAdr:gsub('&kinopoisk', ''):gsub('%?block=%w+', '')
	m_simpleTV.User.Videocdn.Tabletitle = nil
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr:gsub('$OPT:.+', ''), headers = 'Referer: https://www.videocdn.tv/'})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
	answer = htmlEntities.decode(answer)
	answer = answer:gsub('\\\\\\/', '/')
	answer = answer:gsub('\\"', '"')
	answer = unescape3(answer)
	answer = answer:gsub('\\', '')
--	debug_in_file(answer .. '\n',m_simpleTV.MainScriptDir .. 'user/westSide/answer.txt')
	title = answer:match('<title>([^<]+)') or answer:match('id="title" value="([^"]+)')
	if not title or title == '' then
	if m_simpleTV.User.Videocdn.title and m_simpleTV.User.Videocdn.year then
	title = m_simpleTV.User.Videocdn.title .. ' (' .. m_simpleTV.User.Videocdn.year .. ')'
	else
	title = m_simpleTV.Control.CurrentTitle_UTF8
	end
	end
	m_simpleTV.Control.SetTitle(title)
	local tv_series = answer:match('value="tv_series"') or answer:match('value="show_tv_series"') or answer:match('value="anime_tv_series"')
	local transl
	local tr = answer:match('<div class="translations".-</div>')
	debug_in_file((tr or 'NOT') .. '\n',m_simpleTV.MainScriptDir .. 'user/westSide/answertr.txt')
	if tr then
		tr = tr:gsub('<template class="__cf_email__" data%-cfemail="%x+">%[email.-%]</template>', 'MUZOBOZ@')
				local t = {}
		local selected
			for w in tr:gmatch('<option.-</option>') do
				local adr = w:match('value="([^"]+)')
				local name = w:match('>([^<]+)')
				if adr and name and not name:match('^%s*@%s*$') then
					t[#t + 1] = {}
					t[#t].Name = name:gsub('<template.-template>', 'неизвестно'):gsub('&amp;', '&')
					t[#t].Address = adr
					if w:match('"selected"') then
						selected = #t - 1
					end
				end
			end
			if #t == 0 then return end
		if not selected or selected < 0 then
			selected = 0
		end
		if tv_series and #t > 1 then
			table.remove(t, 1)
		end
			for i = 1, #t do
				t[i].Id = i
			end
		m_simpleTV.User.Videocdn.TranslateTable = t
		if #t > 1 then
			local _, id
			if not psevdotv and not translate then
				_, id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите озвучку - ' .. title, selected, t, 10000, 1 + 2 + 4 + 8)
			end
			id = id or selected + 1
			transl = translate or t[id].Address
		else
			transl = t[1].Address
		end
	end
	transl = translate or transl or '%d+'
	translate = transl
	m_simpleTV.User.Videocdn.translate = translate
	m_simpleTV.User.Videocdn.title_translate = title_translate(translate):gsub('%) %(',', '):gsub('%)',''):gsub('%(',''):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'):gsub(' закадровый','')
	if m_simpleTV.User.Videocdn.title_translate:match('Озвучка %-') then
		m_simpleTV.User.Videocdn.title_translate = answer:match('<option value="' .. m_simpleTV.User.Videocdn.translate .. '" >(.-)</option>')
		or 'Озвучка'
	end
	m_simpleTV.User.Videocdn.title_translate = m_simpleTV.User.Videocdn.title_translate:gsub('<template.-template>', 'неизвестно'):gsub('&amp;', '&'):gsub('\n		               	','')
	local answer = answer:match('id="files" value=\'(.-)\'')
		if not answer then return end
--	debug_in_file(answer .. '\n',m_simpleTV.MainScriptDir .. 'user/westSide/answer.txt')
	if tv_series then
		answer = answer:match('"' .. transl .. '":(%[.-%}%]%}%])')
--	debug_in_file(answer .. '\n',m_simpleTV.MainScriptDir .. 'user/westSide/answer.txt')
			if not answer then return end
		require 'json'
		local du = answer:match('#(%w+)')
		if du then
			answer = decodeUrl(du)
		end
		answer = answer:gsub('%[%]', '""')
		local tab = json.decode(answer)
			if not tab then return end
		local season_title = ''
		local t, i = {}, 1
		if tab[1] and tab[1].folder then
			local s, j, seson = {}, 1
				while true do
						if not tab[j] then break end
					s[j] = {}
					s[j].Id = j
					s[j].Name = unescape3(tab[j].comment)
					s[j].Address = j
					j = j + 1
				end
				if j == 1 then return end
			if j > 2 then
				local _, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, s, 10000, 1)
				id = id or 1
				seson = s[id].Address
				season_title = ' ' .. s[id].Name
			else
				seson = s[1].Address
				local ses = s[1].Name:match('%d+') or '0'
				if tonumber(ses) > 1 then
					season_title = ' ' .. s[1].Name
				end
			end
			if not tab[1].folder[1].file then
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="https://www.videocdn.tv/favicon.png"', text = 'VideoCDN: озвучка недоступна', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			return Tr_all() end
				while true do
						if not tab[seson].folder[i] then break end
					t[i] = {}
					t[i].Id = i
					t[i].Name = tab[seson].folder[i].comment:gsub('<i>.-</i>', ''):gsub('<br>', '')
					t[i].Address = '$videocdn' .. tab[seson].folder[i].file
					if m_simpleTV.User.Videocdn.overview then
					t[i].InfoPanelName = m_simpleTV.User.Videocdn.title
					t[i].InfoPanelTitle = m_simpleTV.User.Videocdn.overview
					t[i].InfoPanelLogo = m_simpleTV.User.Videocdn.background
					end
					i = i + 1
				end
				if i == 1 then return end
		elseif tab[1] and tab[1].file then
				while true do
						if not tab[i] then break end
					t[i] = {}
					t[i].Id = i
					t[i].Name = tab[i].comment:gsub('<i>.-</i>', ''):gsub('<br>', '')
					t[i].Address = '$videocdn' .. tab[i].file
					if m_simpleTV.User.Videocdn.overview then
					t[i].InfoPanelName = m_simpleTV.User.Videocdn.title
					t[i].InfoPanelTitle = m_simpleTV.User.Videocdn.overview
					t[i].InfoPanelLogo = m_simpleTV.User.Videocdn.background
					end
					i = i + 1
				end
				if i == 1 then return end
		else
				season_title = ' (' .. unescape3(tab.comment) .. ')'
				while true do
						if not tab.folder[i] then break end
					t[i] = {}
					t[i].Id = i
					t[i].Name = tab.folder[i].comment:gsub('<i>.-</i>', ''):gsub('<br>', '')
					t[i].Address = '$videocdn' .. tab.folder[i].file
					if m_simpleTV.User.Videocdn.overview then
					t[i].InfoPanelName = m_simpleTV.User.Videocdn.title
					t[i].InfoPanelTitle = m_simpleTV.User.Videocdn.overview
					t[i].InfoPanelLogo = m_simpleTV.User.Videocdn.background
					end
					i = i + 1
				end
				if i == 1 then return end
		end
		m_simpleTV.User.Videocdn.Tabletitle = t
			if m_simpleTV.User.Videocdn.TranslateTable and translate then
				t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'Tr_all()'}
			elseif m_simpleTV.User.Videocdn.translate then
				t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 VideoCDN озвучки ', ButtonScript = 'type_cdntr(\'&translation=' .. m_simpleTV.User.Videocdn.translate .. '\')'}
			else
				t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ✕ ', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
			end
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_Videocdn()'}
			t.ExtParams = {FilterType = 2, StopOnError = 1, StopAfterPlay = 1, PlayMode = 0}
		local p = 0
		if i == 2 then
			p = 32
			m_simpleTV.User.Videocdn.isVideo = true
		end
		title = title .. season_title
		m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 15000, p + 64)
		inAdr = t[1].Address
		m_simpleTV.User.Videocdn.title = title
		title = title .. ' - ' .. m_simpleTV.User.Videocdn.Tabletitle[1].Name
	else
		inAdr = answer:match('"' .. transl .. '":"([^"]+)')
--	debug_in_file(inAdr .. '\n',m_simpleTV.MainScriptDir .. 'user/westSide/answer.txt')
			if not inAdr then return end
		if psevdotv then
			local t = m_simpleTV.Control.GetCurrentChannelInfo()
			if t
				and t.MultiHeader
				and t.MultiName
			then
				title = t.MultiHeader .. ': ' .. t.MultiName
			end
		end
		local t1 = {}
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Name = title
		t1[1].Address = inAdr
		if m_simpleTV.User.Videocdn.overview then
		t1[1].InfoPanelName = m_simpleTV.User.Videocdn.title .. ' (' .. m_simpleTV.User.Videocdn.year .. ')' .. ((' - ' .. m_simpleTV.User.Videocdn.title_translate) or '')
		t1[1].InfoPanelTitle = m_simpleTV.User.Videocdn.overview
		t1[1].InfoPanelLogo = m_simpleTV.User.Videocdn.background
		end
		if not psevdotv then
				if m_simpleTV.User.Videocdn.TranslateTable and translate then
					t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'Tr_all()'}
				elseif m_simpleTV.User.Videocdn.translate then
					t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 VideoCDN озвучки ', ButtonScript = 'type_cdntr(\'&translation=' .. m_simpleTV.User.Videocdn.translate .. '\')'}
				else
					t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' ✕ ', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
				end
				t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_Videocdn()'}
				m_simpleTV.OSD.ShowSelect_UTF8('Videocdn', 0, t1, 5000, 32 + 64 + 128)
		end
		m_simpleTV.User.Videocdn.isVideo = true

	end
	play(inAdr, title .. ((' - ' .. m_simpleTV.User.Videocdn.title_translate) or ''))
