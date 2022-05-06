-- видеоскрипт для сайта http://www.kinopoisk.ru (06/05/22)
-- Copyright © 2017-2021 Nexterr | https://github.com/Nexterr/simpleTV
-- mod west_side (add VB, ZF, Videoapi) - (06/05/22)
-- ## необходимы ##
-- видеоскрипты: yandex-vod.lua, kodik.lua, filmix.lua, videoframe.lua, seasonvar.lua
-- iviru.lua, videocdn.lua, hdvb-vb.lua, collaps.lua, cdnmovies.lua, voidboost.lua, videoapi.lua, zetflix.lua
-- ## открывает подобные ссылки ##
-- https://www.kinopoisk.ru/film/5928
-- https://www.kinopoisk.ru/level/1/film/46225/sr/1/
-- https://www.kinopoisk.ru/level/1/film/942397/sr/1/
-- https://www.kinopoisk.ru/film/336434
-- https://www.kinopoisk.ru/film/4-mushketera-sharlo-1973-60498/sr/1/
-- https://www.kinopoisk.ru/images/film_big/946897.jpg
-- https://www.kinopoisk.ru/film/535341/watch/?from_block=Фильмы%20из%20Топ-250&
-- https://hd.kinopoisk.ru/film/456c0edc4049d31da56036a9ae1484f4
-- http://rating.kinopoisk.ru/7378.gif
-- https://www.kinopoisk.ru/series/733493/
-- ## адрес сайта (зеркала) filmix.ac ##
local filmixsite = m_simpleTV.Config.GetValue('zerkalo/filmix', 'LiteConf.ini') or 'https://filmix.ac'
-- 'https://filmix.life' (пример)
-- ## прокси для Seasonvar ##
local proxy = ''
-- '' - нет
-- 'https://proxy-nossl.antizapret.prostovpn.org:29976' (пример)
-- ## источники ##
local tname = {}
if not m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini') or tonumber(m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini')) == 1 then
-- сокращенная база
tname = {
-- сортировать: поменять порядок строк
-- отключить: поставить в начале строки --
 'Videocdn',
 'VB',
 'ZF',
 'Videoapi',  
-- 'Filmix',
-- 'CDN Movies',
-- 'Videoframe',
-- 'Hdvb',
-- 'Collaps',
-- 'Kodik',
-- 'КиноПоиск онлайн',
-- 'Seasonvar',
-- 'ivi',
	}
-- ##
elseif tonumber(m_simpleTV.Config.GetValue('mediabaze', 'LiteConf.ini')) == 2 then
-- полная база
tname = {
-- сортировать: поменять порядок строк
-- отключить: поставить в начале строки --
 'Videocdn',
 'VB',
 'ZF', 
-- 'Filmix',
 'CDN Movies',
 'Videoframe',
 'Hdvb',
 'Collaps',
 'Kodik',
 'Videoapi',   
-- 'КиноПоиск онлайн',
-- 'Seasonvar',
-- 'ivi',
	}
-- ##
end
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('^https?://[%w%.]*kinopoisk%.ru/.+') then return end
	local inAdr = m_simpleTV.Control.CurrentAddress
		if not inAdr:match('/film')
			and not inAdr:match('//rating%.')
			and not inAdr:match('/series/')
		then
		 return
		end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = '', TypeBackColor = 0, UseLogo = 0, Once = 1})
	end
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
-- ## убрать ThumbsInfo
		if m_simpleTV.User.Rezka and m_simpleTV.User.Rezka.ThumbsInfo then m_simpleTV.User.Rezka.ThumbsInfo = nil end
-- ##
	require 'json'
	require 'lfs'
	htmlEntities = require 'htmlEntities'
	m_simpleTV.Control.ChangeAddress= 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	if inAdr:match('hd%.kinopoisk%.ru') then
		local id = inAdr:match('hd%.kinopoisk%.ru/film/(%x+)')
			if not id then return end
		local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://api.ott.kinopoisk.ru/v7/hd/content/' .. id .. '/metadata'})
			if rc ~= 200 then
				m_simpleTV.Http.Close(session)
			 return
			end
		id = answer:match('"kpId":(%d+)')
			if not id then return end
		inAdr = 'https://www.kinopoisk.ru/film/' .. id
	end
	inAdr = inAdr:gsub('/watch/.+', ''):gsub('/watch%?.+', ''):gsub('/sr/.+', '')
	local kpid = inAdr:match('.+%-(%d+)') or inAdr:match('/film//?(%d+)') or inAdr:match('%d+')
		if not kpid then return end
	local turl, svar, t, rett, Rt = {}, {}, {}, {}, {}
	local rc, answer, retAdr, title, orig_title, year, kp_r, imdb_r, zonaAbuse, zonaUrl, zonaSerial, zonaId, zonaDesc, logourl, eng_title, languages_imdb
	local usvar, i, u = 1, 1, 1
	local function unescape_html(str)
	 return htmlEntities.decode(str)
	end
	local function answerdget(url)
		if url:match('widget%.kinopoisk%.ru') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			local filmId = answer:match('"filmId":"([^"]+)')
				if not filmId then return end
			rc, answer = m_simpleTV.Http.Request(session, {url = 'https://frontend.vh.yandex.ru/v23/player/' .. filmId .. '.json?locale=ru'})
				if rc ~= 200 then return end
				if not answer:match('"stream_type":"HLS","url":"%a') then return end
			return url
		elseif url:match('PXk2QGbvEVmS') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return url
		elseif url:match('kNKj47MkBgLS') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return url	
		elseif url:match('cdnmovies%.net') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return answer:match('"iframe_src":"([^"]+)')
		elseif url:match('ivi%.ru') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url .. m_simpleTV.Common.toPercentEncoding(title) ..'&from=0&to=5&app_version=870&paid_type=AVOD'})
				if rc ~= 200 or (rc == 200 and not answer:match('^{')) then return end
			local tab = json.decode(answer:gsub('%[%]', '""'))
				if not tab or not tab.result then return end
			local i = 1
			local idivi, kpidivi, drmivi, Adrivi
				while true do
						if not tab.result[i] then break end
					kpidivi = tab.result[i].kp_id or 0
					drmivi = tab.result[i].drm_only or false
					idivi = tab.result[i].id
						if kpidivi == tonumber(kpid) and drmivi == false and idivi then Adrivi = 'https://www.ivi.ru/kinopoisk=' .. idivi break end
					i = i + 1
				end
			return Adrivi
		elseif url:match('kodikapi%.com') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return answer:match('"link":"([^"]+)')
		elseif url:match('filmix') then
			local filmix_title
			if title and #title > 2 then
				filmix_title = title
			end
				if not filmix_title then return end
			local sessionFilmix = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0')
				if not sessionFilmix then return end
			m_simpleTV.Http.SetTimeout(sessionFilmix, 8000)
			local ratimdbot, ratkinot, ratimdbdo, ratkindo, yearot, yeardo = '', '', '', '', '', ''
			if imdb_r > 0 then
				ratimdbot = imdb_r - 1
				ratimdbdo = imdb_r + 1
			end
			if kp_r > 0 then
				ratkinot = kp_r - 1
				ratkindo = kp_r + 1
			end
			local cat = '&film=on'
			if zonaSerial then
				cat = '&serials=on'
			end
			if year > 0 then
				yearot = year - 1
				yeardo = year + 1
			end
			local namei = filmix_title:gsub('%?$', ''):gsub('.-`', ''):gsub('*', ''):gsub('«', '"'):gsub('»', '"')
			local filmixurl = filmixsite .. '/search'
			local headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. filmixurl
			local body = 'scf=fx&story=' .. m_simpleTV.Common.toPercentEncoding(namei) .. '&search_start=0&do=search&subaction=search&years_ot=' .. yearot .. '&years_do=' .. yeardo .. '&kpi_ot=' .. ratkinot .. '&kpi_do=' .. ratkindo .. '&imdb_ot=' .. ratimdbot .. '&imdb_do=' .. ratimdbdo .. '&sort_name=asc&undefined=asc&sort_date=&sort_favorite=' .. cat
			local rc, answer = m_simpleTV.Http.Request(sessionFilmix, {body = body, url = filmixsite .. '/engine/ajax/sphinx_search.php', method = 'post', headers = headers})
			m_simpleTV.Http.Close(sessionFilmix)
				if rc ~= 200 or (rc == 200 and (answer:match('^<h3>')
					or not answer:match('<div class="name%-block"')))
				then
				 return
				end
			return answer
		elseif url:match('seasonvar%.ru') then
				if not zonaSerial then return end
			local svarnamei = orig_title:gsub('[!?]', ' '):gsub('ё', 'е')
			local sessionsvar
			if proxy ~= '' then
				sessionsvar = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:84.0) Gecko/20100101 Firefox/84.0', proxy, false)
					if not sessionsvar then return end
			end
			rc, answer = m_simpleTV.Http.Request((sessionsvar or session), {url = url .. m_simpleTV.Common.toPercentEncoding(svarnamei)})
				if rc ~= 200 or (rc == 200 and (answer:match('"query":""') or answer:match('"data":null'))) then
					if sessionsvar then
						m_simpleTV.Http.Close(sessionsvar)
					end
				 return
				end
				if answer:match('"data":%[""%]') or answer:match('"data":%["",""%]') then
					svarnamei = title:gsub('[!?]', ' '):gsub('ё', 'е')
					rc, answer = m_simpleTV.Http.Request((sessionsvar or session), {url = url .. m_simpleTV.Common.toPercentEncoding(svarnamei)})
						if rc ~= 200 or (rc == 200 and (answer:match('"query":""') or answer:match('"data":%[""%]') or answer:match('"data":%["",""%]'))) then
							if sessionsvar then
								m_simpleTV.Http.Close(sessionsvar)
							end
						 return
						end
				end
			if sessionsvar then
				m_simpleTV.Http.Close(sessionsvar)
			end
				if not answer:match('^{') then return end
			local t = json.decode(answer:gsub('%[%]', '""'):gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'))
				if not t then return end
			local a, j = {}, 1
				while true do
						if not t.data[j] or not t.suggestions.valu[j] or t.data[j] == '' then break end
					a[j] = {}
					a[j].Id = j
					a[j].rkpsv = t.suggestions.kp[j]:match('>(.-)<') or 0
					a[j].Name = unescape3(t.suggestions.valu[j])
					a[j].Address = 'http://seasonvar.ru/' .. t.data[j]
					j = j + 1
				end
				if j == 1 then return end
			local i, rkpsv, svarkptch = 1
				svarnamei = svarnamei:gsub('%%', string.char(37))
				for _, v in pairs(a) do
					rkpsv = tonumber(v.rkpsv)
					svarkptch = 0.1
					if kp_r > 0 then
						if svarname == 0 then
							if (rkpsv >= (kp_r - svarkptch) and rkpsv <= (kp_r + svarkptch)) and not a[i].Name:match('<span style') and (a[i].Name:match('/%s*' .. svarnamei .. '$') or a[i].Name:match('/%s*' .. svarnamei .. '%s')) then v.Id = usvar svar[usvar] = v usvar = usvar + 1 end
						else
							if (rkpsv >= (kp_r - svarkptch) and rkpsv <= (kp_r + svarkptch)) and not a[i].Name:match('<span style') and a[i].Name:match(svarnamei) then v.Id = usvar svar[usvar] = v usvar = usvar + 1 end
						end
					else
						if svarname == 0 then
							if not a[i].Name:match('<span style') and (a[i].Name:match('/%s*' .. svarnamei .. '$') or a[i].Name:match('/%s*' .. svarnamei .. '%s')) then v.Id = usvar svar[usvar] = v usvar = usvar + 1 end
						else
							if not a[i].Name:match('<span style') and a[i].Name:match(svarnamei) then v.Id = usvar svar[usvar] = v usvar = usvar + 1 end
						end
					end
				end
			if usvar == 1 then
				svar, i = {}, 1
				for _, v in pairs(a) do svar[i] = v i = i + 1 end
			end
			return true
		elseif url:match('iframe%.video') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return answer:match('"path":"([^"]+)')
		elseif url:match('synchroncode') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: api.synchroncode.com'})
				if rc ~= 200 then return end
				if answer:match('embedHost') then
				 return url
				end
		elseif url:match('vb17121coramclean') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return answer:match('"iframe_url":"([^"]+)')
		elseif url:match('voidboost') then
			rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc ~= 200 then return end
			return url
		elseif url:match('zetflix') then
			rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'get', headers = 'User-agent: Mozilla/5.0 (Windows NT 10.0; rv:97.0) Gecko/20100101 Firefox/97.0\nReferer: https://hdi.zetflix.online/iplayer/player.php'})
				if rc ~= 200 or answer:match('video_not_found') then return end
			return url
		end
	 return
	end
	local function getAdr(answer, url)
		if url:match('iframe%.video') then
			return answer
		elseif url:match('ivi%.ru') then
			return answer
		elseif url:match('PXk2QGbvEVmS') then
			return answer
		elseif url:match('kNKj47MkBgLS') then
			return answer	
		elseif url:match('cdnmovies%.net') then
			return answer
		elseif url:match('kodikapi%.com') then
			return answer
		elseif url:match('widget%.kinopoisk%.ru') then
			return answer
		elseif url:match('filmix') then
			local i, f = 1, {}
			for ww in answer:gmatch('<div class="name%-block">(.-)</div>') do
				f[i] = {}
				f[i].Id = i
				local name = ww:match('title="([^"]+)')
				f[i].Name = unescape_html(name)
				f[i].Address = ww:match('href="([^"]+)')
				i = i + 1
			end
			if m_simpleTV.User.paramScriptForSkin_buttonPrev then
				f.ExtButton1 = {ButtonEnable = true, ButtonImageCx = 30, ButtonImageCy= 30, ButtonImage = m_simpleTV.User.paramScriptForSkin_buttonPrev}
			else
				f.ExtButton1 = {ButtonEnable = true, ButtonName = '🢀'}
			end
			if m_simpleTV.User.paramScriptForSkin_buttonOk then
				f.OkButton = {ButtonImageCx = 30, ButtonImageCy= 30, ButtonImage = m_simpleTV.User.paramScriptForSkin_buttonOk}
			end
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено на Filmix', 0, f, 10000, 1 + 2)
				if ret == 3 then
				 return -1
				end
			id = id or 1
			return f[id].Address
		elseif url:match('seasonvar%.ru') then
			if m_simpleTV.User.paramScriptForSkin_buttonOk then
				svar.OkButton = {ButtonImageCx = 30, ButtonImageCy= 30, ButtonImage = m_simpleTV.User.paramScriptForSkin_buttonOk}
			end
			if m_simpleTV.User.paramScriptForSkin_buttonPrev then
				svar.ExtButton1 = {ButtonEnable = true, ButtonImageCx = 30, ButtonImageCy= 30, ButtonImage = m_simpleTV.User.paramScriptForSkin_buttonPrev}
			else
				svar.ExtButton1 = {ButtonEnable = true, ButtonName = '🢀'}
			end
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Найдено на Seasonvar', 0, svar, 10000, 1 + 2)
				if ret == 3 then
				 return -1
				end
			id = id or 1
			return svar[id].Address
		elseif url:match('synchroncode') then
			return url
		elseif url:match('vb17121coramclean') then
			return answer
		elseif url:match('voidboost') then
			return answer
		elseif url:match('zetflix') then
			return answer
		end
	 return
	end
	local function getlogo()
		local session2 = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:84.0) Gecko/20100101 Firefox/84.0', nil, true)
			if not session2 then return end
		m_simpleTV.Http.SetTimeout(session2, 8000)
		local url = 'https://st.kp.yandex.net/images/film_iphone/iphone360_' .. kpid .. '.jpg'
		m_simpleTV.Http.SetRedirectAllow(session2, false)
		local rc, answer = m_simpleTV.Http.Request(session2, {url = url})
		local raw = m_simpleTV.Http.GetRawHeader(session2) or ''
		m_simpleTV.Http.Close(session2)
		if rc == 200
			or (rc == 302 and not raw:match('no%-poster%.gif'))
		then
			logourl = url
			m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = logourl, TypeBackColor = 0, UseLogo = 3, Once = 1})
		else
			url = 'https://www.iphones.ru/wp-content/uploads/2020/06/orig-1240x630.png'
			logourl = url
			m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = url, TypeBackColor = 0, UseLogo = 3, Once = 1})
		end
	end
	local function imdbid(kpid)
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
	local background, name_tmdb, year_tmdb, overview_tmdb = '', '', '', ''
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then return '', '', '', '' else
	if tab.movie_results[1] then
	background = tab.movie_results[1].backdrop_path or ''
	name_tmdb = tab.movie_results[1].title or ''
	year_tmdb = tab.movie_results[1].release_date or ''
	overview_tmdb = tab.movie_results[1].overview or ''
	elseif tab.tv_results[1] then
	background = tab.tv_results[1].backdrop_path or ''
	name_tmdb = tab.tv_results[1].name or ''
	year_tmdb = tab.tv_results[1].first_air_date or ''
	overview_tmdb = tab.tv_results[1].overview or ''
	end
	end
	if year_tmdb and year_tmdb ~= '' then
	year_tmdb = year_tmdb:match('%d%d%d%d')
	else year_tmdb = 0 end
	if background and background ~= nil and background ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background end
	if background == nil then background = '' end
	return background, name_tmdb, year_tmdb, overview_tmdb
	end
	local background, id_imdb, name_tmdb, year_tmdb, overview_tmdb
	if imdbid(kpid)
		then
		id_imdb, title, year = imdbid(kpid)
		if id_imdb ~= '' and bg_imdb_id(id_imdb)~= '' then
		background, name_tmdb, year_tmdb, overview_tmdb = bg_imdb_id(id_imdb)
		end
	end
	if background and background~= ''
		then
		logourl = background
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = background, TypeBackColor = 0, UseLogo = 3, Once = 1})
		else
		getlogo()
	end
	if not title or title and title == '' then title = name_tmdb or 'Кинопоиск' end
	if not year or year and year == '' then year = year_tmdb or '' end
	m_simpleTV.Control.CurrentTitle_UTF8 = title .. ' (' .. year .. ')'
	m_simpleTV.Control.SetTitle(title .. ' (' .. year .. ')')
	local function setMenu()
		local logo_k = logourl or 'https://avatars.mds.yandex.net/get-zen-logos/200214/pub_595fb4431410c3258a91bf55_5af1c6e63dceb755566a70a2/xxh'
		m_simpleTV.Control.ChangeChannelLogo(logo_k, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		for i = 1, #tname do
			if tname[i] == 'Videoframe' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9pZnJhbWUudmlkZW8vYXBpL3YyL3NlYXJjaD9rcD0') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'Kodik' then
				turl[i] = {adr = decode64('aHR0cDovL2tvZGlrYXBpLmNvbS9nZXQtcGxheWVyP3Rva2VuPTQ0N2QxNzllODc1ZWZlNDQyMTdmMjBkMWVlMjE0NmJlJmtpbm9wb2lza0lEPQ') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'КиноПоиск онлайн' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9vdHQtd2lkZ2V0Lmtpbm9wb2lzay5ydS9raW5vcG9pc2suanNvbj9lcGlzb2RlPSZzZWFzb249JmZyb209a3AmaXNNb2JpbGU9MCZrcElkPQ==') .. kpid, tTitle = 'Фильмы и сериалы с Яндекс.Эфир', tLogo = 'https://www.torpedo.ru/upload/resize_cache/iblock/cad/325_325_1/caddb19b51cd12166d1261700046a8f7.png'}
			elseif tname[i] == 'ZonaMobi' then
				turl[i] = {adr = decode64('em9uYXNlYXJjaC5jb20vc29sci9tb3ZpZQ=='), tTitle = 'Фильмы и сериалы с Zona.mobi', tLogo = 'http://zona-sait.ru/wp-content/uploads/2017/11/logo.png'}
			elseif tname[i] == 'Filmix' then
				turl[i] = {adr = filmixsite .. decode64('L2VuZ2luZS9hamF4L3NwaGlueF9zZWFyY2gucGhw'), tTitle = 'Фильмы и сериалы с Filmix.ac', tLogo = logo_k}
			elseif tname[i] == 'Seasonvar' then
				turl[i] = {adr = decode64('aHR0cDovL3NlYXNvbnZhci5ydS9hdXRvY29tcGxldGUucGhwP3F1ZXJ5PQ=='), tTitle = 'Сериалы с Seasonvar.ru', tLogo = 'http://hostingkartinok.com/uploads/images/2011/09/af3d6033d255a3e36a6094a5ba74ebb7.png'}
			elseif tname[i] == 'ivi' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9hcGkuaXZpLnJ1L21vYmlsZWFwaS9zZWFyY2gvdjUvP2ZpZWxkcz1rcF9pZCxpZCxkcm1fb25seSZmYWtlPTAmcXVlcnk9'), tTitle = 'Фильмы и сериалы с ivi.ru', tLogo = 'http://saledeal.ru/wp-content/uploads/2019/09/ivi.png'}
			elseif tname[i] == 'Videocdn' then
				turl[i] = {adr = decode64('aHR0cHM6Ly84MjA5LnN2ZXRhY2RuLmluL1BYazJRR2J2RVZtUz9rcF9pZD0') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'Videoapi' then
				turl[i] = {adr = decode64('aHR0cHM6Ly81MTAyLnN2ZXRhY2RuLmluL2tOS2o0N01rQmdMUz9pbWRiX2lkPQ==') .. id_imdb, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}	
			elseif tname[i] == 'Collaps' then
				turl[i] = {adr = 'http://api.' .. os.time() .. decode64('LmRlbGl2ZW1iZC53cy9lbWJlZC9rcC8') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'CDN Movies' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9jZG5tb3ZpZXMubmV0L2FwaT90b2tlbj0wYWVmZDdjMWQ2ZjY0YzAzNzRjYmE4ZmRiZTZmOTE2MyZraW5vcG9pc2tfaWQ9') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = 'https://raw.githubusercontent.com/Nexterr-origin/simpleTV-Images/main/cdnmovie.png'}
			elseif tname[i] == 'Hdvb' then
				turl[i] = {adr = decode64('aHR0cHM6Ly92YjE3MTIxY29yYW1jbGVhbi5wdy9hcGkvdmlkZW9zLmpzb24/dG9rZW49Yzk5NjZiOTQ3ZGEyZjNjMjliMzBjMGUwZGNjYTZjZjQmaWRfa3A9') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'VB' then
				turl[i] = {adr = decode64('aHR0cHM6Ly92b2lkYm9vc3QubmV0L2VtYmVkLw') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			elseif tname[i] == 'ZF' then
				turl[i] = {adr = decode64('aHR0cHM6Ly9oZGkuemV0ZmxpeC5vbmxpbmUvaXBsYXllci92aWRlb2RiLnBocD9rcD0=') .. kpid, tTitle = 'Большая база фильмов и сериалов', tLogo = logo_k}
			end
		end
	end
	local function menu()
		for i = 1, #tname do
			t[i] = {}
			t[i].Name = tname[i]
			if not id_imdb or id_imdb ~= '' or id_imdb and id_imdb == '' and tname[i] ~= 'Videoapi' then
			t[i].answer = answerdget(turl[i].adr)
			t[i].Address = turl[i].adr
			end
			if background and name_tmdb and year_tmdb and overview_tmdb then
				t[i].InfoPanelTitle = overview_tmdb
				t[i].InfoPanelName = name_tmdb .. ' (' .. year_tmdb .. ')'
				t[i].InfoPanelLogo = logourl or 'https://avatars.mds.yandex.net/get-zen-logos/200214/pub_595fb4431410c3258a91bf55_5af1c6e63dceb755566a70a2/xxh'
			else
				t[i].InfoPanelName = title .. ' (' .. year .. ')'
				t[i].InfoPanelTitle = turl[i].tTitle
				t[i].InfoPanelLogo = turl[i].tLogo
			end
			t[i].InfoPanelShowTime = 30000
		end
		for _, v in pairs(t) do
			if v.answer then v.Id = u rett[u] = v u = u + 1 end
		end
	end
	local function selectmenu()
		rett.ExtParams = {FilterType = 2}

			rett.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 Rezka'}

		m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🎞 ' .. title .. ' (' .. year .. ')', 0, rett, 8000, 1 + 2)
			if ret == 3 then
				m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(title),'LiteConf.ini')
				search_rezka()
			end

		id = id or 1
		retAdr = getAdr(rett[id].answer, rett[id].Address)

		if retAdr == -1 then
			selectmenu()
		end
	end
	setMenu()
	menu()
	if #rett == 0 then
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Kinopoisk: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		search_all()
	 return
	end
	selectmenu()
	if not retAdr or retAdr == 0 then
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'Kinopoisk: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		search_all()
	 return
	end
	m_simpleTV.Control.CurrentTitle_UTF8 = title .. ' (' .. year .. ')'
	m_simpleTV.Control.SetTitle(title .. ' (' .. year .. ')')
	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.ChangeAddress = 'No'
	retAdr = retAdr:gsub('\\/', '/')
	retAdr = retAdr:gsub('^//', 'http://')
	if retAdr:match('svetacdn%.') then retAdr = retAdr .. '&embed=' .. kpid end
	m_simpleTV.Control.CurrentAddress = retAdr
	dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\video\\video.lua')
-- debug_in_file(retAdr .. '\n')