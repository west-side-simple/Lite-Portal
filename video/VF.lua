-- видеоскрипт для балансера VF (19.04.25)
-- author west_side

	if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
	if m_simpleTV.Control.CurrentAddress:match('^tmdb_id=')
	then return end
	if not m_simpleTV.Control.CurrentAddress:match('^https?://.-videoframe1%.com/embed.+')
	then return end
	local inAdr = m_simpleTV.Control.CurrentAddress
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.VF then
		m_simpleTV.User.VF = {}
	end
	if not m_simpleTV.User.TMDB then
		m_simpleTV.User.TMDB = {}
	end
	if not m_simpleTV.User.TVPortal then
		m_simpleTV.User.TVPortal = {}
	end
	if not m_simpleTV.User.TVPortal.get then
		m_simpleTV.User.TVPortal.get = {}
	end
	if not m_simpleTV.User.TVPortal.get.TMDB then
		m_simpleTV.User.TVPortal.get.TMDB = {}
	end
	if not m_simpleTV.User.TVPortal.cor then
		m_simpleTV.User.TVPortal.cor = {}
	end
	m_simpleTV.User.TMDB.Id = nil
	m_simpleTV.User.TMDB.tv = nil
	m_simpleTV.User.VF.id_imdb = nil
	m_simpleTV.User.VF.kpid = nil
	m_simpleTV.User.VF.CurAddress = inAdr
	m_simpleTV.User.VF.DelayedAddress = nil
	m_simpleTV.User.TVPortal.balanser = 'Vibix'
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_np = getConfigVal('perevod/vf') or ''
	if not getConfigVal('perevod/vf') then setConfigVal('perevod/vf','') end

local function check_thumb(url,session)
	local rc, answer = m_simpleTV.Http.Request(session,{url=url})
	if rc == 200 then return true end
	m_simpleTV.Http.Close(session)
	return
end

local function get_id_for_episode(answer, season, episode)
	local id
	local all_data = answer:match('seasons:(.-)\n')
	if all_data then
		require('json')
		all_data = all_data:gsub('%[%]', '"nil"'):gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/')
		local tab = json.decode(all_data)
		if not tab then
			return
		end
		local t, i, j = {}, 1, 1
		while true do
			if not tab[j] or not tab[j].season then break end
			local k = 1
			while true do
				t[i] = {}
				t[i].season = tab[j].season
				if not tab[j].episodes[k] or not tab[j].episodes[k].episode or not tab[j].episodes[k].videoKey then break end
				t[i].episode = tab[j].episodes[k].episode
				t[i].videoKey = tab[j].episodes[k].videoKey
				if tonumber(season) == t[i].season and tonumber(episode) == tonumber(t[i].episode) then
					return t[i].videoKey
				end
				k = k + 1
				i = i + 1
			end
			j = j + 1
		end
	end
	return
end

local function get_thumb(season, episode)
	local url
	if m_simpleTV.User.VF.id_imdb then
		url = 'https://api.ninsel.ws/embed/imdb/' .. m_simpleTV.User.VF.id_imdb
	elseif m_simpleTV.User.VF.kpid then
		url = 'https://api.ninsel.ws/embed/kp/' .. m_simpleTV.User.VF.kpid
	else
		return
	end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local rc, answer = m_simpleTV.Http.Request(session,{url=url})
	if rc == 200 and answer then
		local all_data = answer:match('preview: %{(.-)%}%,')
		if not all_data then
			m_simpleTV.Http.Close(session)
			if not m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler then
				local handlerInfo = {}
				handlerInfo.luaFunction = 'PositionThumbs_VF'
				handlerInfo.regexString = 'videoframe1\.com/embed'
				handlerInfo.sizeFactor = 0.15
				handlerInfo.backColor = ARGB(191, 30, 33, 61)
				handlerInfo.textColor = ARGB(255, 255, 215, 0)
				handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
				handlerInfo.marginBottom = 5
				handlerInfo.showPreviewWhileSeek = false
				handlerInfo.clearImgCacheOnStop = false
				handlerInfo.minImageWidth = 0
				handlerInfo.minImageHeight = 0
				m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
			end
			return
		end
		local interval = all_data:match("interval:.-(%d+)")
		local width = all_data:match("width:.-(%d+)")
		local height = all_data:match("height:.-(%d+)")
		local spriteSize = all_data:match("spriteSize:.-(%d+)")
		local src_pre, src_id = all_data:match("src:.-'(.-)'.-(%d+)")
		local firstNum = all_data:match("firstNum:.-(%d+)")
--		debug_in_file(all_data .. '\n' .. interval .. '\n' .. width .. '\n' .. height .. '\n' .. spriteSize .. '\n' .. firstNum .. '\n' .. src_pre .. '\n' .. src_id .. '\n' .. src_pre .. src_id .. '/desktop/thumb-' .. '\n')
		if not src_pre or not src_id or not interval or not width or not height or not spriteSize or not firstNum then
			m_simpleTV.Http.Close(session)
			if not m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler then
				local handlerInfo = {}
				handlerInfo.luaFunction = 'PositionThumbs_VF'
				handlerInfo.regexString = 'videoframe1\.com/embed'
				handlerInfo.sizeFactor = 0.15
				handlerInfo.backColor = ARGB(191, 30, 33, 61)
				handlerInfo.textColor = ARGB(255, 255, 215, 0)
				handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
				handlerInfo.marginBottom = 5
				handlerInfo.showPreviewWhileSeek = false
				handlerInfo.clearImgCacheOnStop = false
				handlerInfo.minImageWidth = 0
				handlerInfo.minImageHeight = 0
				m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
			end
			return
		end
		if season and episode then src_id = get_id_for_episode(answer,season,episode) or src_id end
		local src = src_pre .. src_id .. '/desktop/thumb-'
		local check = check_thumb(src .. firstNum .. '.webp',session)
		if not check then
			m_simpleTV.Http.Close(session)
			if not m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler then
				local handlerInfo = {}
				handlerInfo.luaFunction = 'PositionThumbs_VF'
				handlerInfo.regexString = 'videoframe1\.com/embed'
				handlerInfo.sizeFactor = 0.15
				handlerInfo.backColor = ARGB(191, 30, 33, 61)
				handlerInfo.textColor = ARGB(255, 255, 215, 0)
				handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
				handlerInfo.marginBottom = 5
				handlerInfo.showPreviewWhileSeek = false
				handlerInfo.clearImgCacheOnStop = false
				handlerInfo.minImageWidth = 0
				handlerInfo.minImageHeight = 0
				m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
			end
			return
		end
			--[[interval: 5,
			width: 160, height: 90,
			spriteSize: 100, rowSize: 10,
			src: 'https://img.zcvh.net/'+  920021  +'/desktop/thumb-${spriteNum}.webp',
			firstNum: 1, pad: 1]]

		if m_simpleTV.Control.MainMode ~= 0 then return end

		m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo = {}
		m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.samplingFrequency = interval * 1000
		m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.thumbsPerImage = spriteSize
		m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.thumbWidth = width
		m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.thumbHeight = height
		m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.urlPattern = src
		m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.firstNum = firstNum

		if not m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler then
			local handlerInfo = {}
			handlerInfo.luaFunction = 'PositionThumbs_VF'
			handlerInfo.regexString = 'videoframe1\.com/embed'
			handlerInfo.sizeFactor = 0.15
			handlerInfo.backColor = ARGB(191, 26, 22, 42)
			handlerInfo.textColor = ARGB(255, 255, 215, 0)
			handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
			handlerInfo.marginBottom = 5
			handlerInfo.showPreviewWhileSeek = false
			handlerInfo.clearImgCacheOnStop = false
			handlerInfo.minImageWidth = width
			handlerInfo.minImageHeight = height
			m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
		end
		m_simpleTV.Http.Close(session)
	else
		if not m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler then
			local handlerInfo = {}
			handlerInfo.luaFunction = 'PositionThumbs_VF'
			handlerInfo.regexString = 'videoframe1\.com/embed'
			handlerInfo.sizeFactor = 0.15
			handlerInfo.backColor = ARGB(191, 30, 33, 61)
			handlerInfo.textColor = ARGB(255, 255, 215, 0)
			handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
			handlerInfo.marginBottom = 5
			handlerInfo.showPreviewWhileSeek = false
			handlerInfo.clearImgCacheOnStop = false
			handlerInfo.minImageWidth = 0
			handlerInfo.minImageHeight = 0
			m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
		end
		m_simpleTV.Http.Close(session)
		return
	end
end

function PositionThumbs_VF(queryType, address, forTime)
	if not m_simpleTV.User.TVPortal.get then return true end
--[[	if queryType == 'testAddress' and m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo then
	 return false
	end--]]
	if queryType == 'getThumbs' then
			if not m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo or m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo == nil then
			 return false
			end
		local imgLen = m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.samplingFrequency * m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.thumbsPerImage
		local index = math.floor(forTime / imgLen)
		local t = {}
		t.playAddress = address
		t.url = m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.urlPattern .. (m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.firstNum + index) .. '.webp'
		t.httpParams = {}
		t.httpParams.extHeader = 'referer:' .. address
		t.elementWidth = m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.thumbWidth
		t.elementHeight = m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.thumbHeight
		t.startTime = index * imgLen
		t.length = imgLen
		t.elementsPerImage = m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo.thumbsPerImage
		t.marginLeft = 0
		t.marginRight = 0
		t.marginTop = 0
		t.marginBottom = 0
		m_simpleTV.PositionThumbs.AppendThumb(t)
	 return true
	end
end

	local function Get_Vibix_title(id)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then
			return false
		end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local url = 'https://vibix.org/api/v1/catalog/data?draw=1&search[value]=' .. id
		local rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'post', headers = m_simpleTV.User.VF.headers})
		if rc~=200 then
			m_simpleTV.Http.Close(session)
			return false
		end
		answer = unescape3(answer):gsub('\n', ' '):gsub('"\\"', '"«'):gsub('\\"', '»')
		local name = answer:match('"name":"(.-)"')
		local year = answer:match('"year":.-"(.-)"') or ''
		m_simpleTV.Http.Close(session)
		if name and year then
			return name, year
		end
		m_simpleTV.Http.Close(session)
		return false
	end

	local function get_all_content(file_all, inAdr, current_np)
		require('json')
		local answer = file_all:gsub('%[%]', '"nil"'):gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/')
		local tab = json.decode(answer)
		if not tab then
			return false
		end
		local t, i, m, current_ep, current_p = {}, 1, 1, 1, 1
		local retAdr
		while true do
			if not tab[i] then
				break
			end
			if tab[i].title then
				local season_name = tab[i].title
				local j = 1
				while true do
					if not tab[i].folder[j] then
						break
					end
					if tab[i].folder[j].title then
						local episode_name = tab[i].folder[j].title:gsub('Серия','Эпизод')
						t[m] = {}
						t[m].Id = m
						t[m].Name = season_name .. ', ' .. episode_name
						t[m].Address = inAdr:gsub('&s=.-$','') .. '&s=' .. season_name:match('(%d+)') .. '&e=' .. episode_name:match('(%d+)')
						if t[m].Address == inAdr or not inAdr:match('&s=%d+&e=%d+') and m == 1 then
							current_ep = m
							m_simpleTV.User.VF.TabPerevod = {}
							local k = 1
							while true do
								if not tab[i].folder[j].folder[k] then
									break
								end
								if tab[i].folder[j].folder[k].title then
									local translate = tab[i].folder[j].folder[k].title
									local file = tab[i].folder[j].folder[k].file
									retAdr = tab[i].folder[j].folder[1].file
									m_simpleTV.User.VF.TabPerevod[k] = {}
									m_simpleTV.User.VF.TabPerevod[k].Id = k
									m_simpleTV.User.VF.TabPerevod[k].Address = file
									m_simpleTV.User.VF.TabPerevod[k].Name = translate
									if m_simpleTV.User.VF.TabPerevod[k].Name == current_np then
										current_p = k
										retAdr = file
									end
								end
								k = k + 1
							end
						end
						m = m + 1
					end
					j = j + 1
				end
			end
			i = i + 1
		end
		m_simpleTV.User.VF.titleTab = t
		setConfigVal('perevod/vf', m_simpleTV.User.VF.TabPerevod[current_p].Name)
		return current_ep, current_p, retAdr
	end

	local function kinopoisk_id(imdb_id)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 4000)
		local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJmltZGJfaWQ9') .. imdb_id
		local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
			if rc5~=200 then
				return false
			end
			require('json')
			answer_vn = answer_vn:gsub('(%[%])', '"nil"')
			local tab_vn = json.decode(answer_vn)
			if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].kp_id then
				return tab_vn.data[1].kp_id
			end
		return false
	end

	local function Get_ZF(id)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 4000)
		local url = decode64('aHR0cHM6Ly9oaWR4bGdsay5kZXBsb3kuY3gvbGl0ZS96ZXRmbGl4P2tpbm9wb2lza19pZD0=') .. id
		local rc,answer = m_simpleTV.Http.Request(session,{url = url})

	--	debug_in_file(url .. '\n' .. answer,'c://1/deb_zf.txt')
		if rc==200 and answer:match('data%-json') then
			m_simpleTV.Http.Close(session)
			return url
		end
		m_simpleTV.Common.Sleep(1000)
		rc,answer = m_simpleTV.Http.Request(session,{url = url})
		if rc==200 and answer:match('data%-json') then
			m_simpleTV.Http.Close(session)
			return url
		end
		m_simpleTV.Http.Close(session)
		return false
	end

	local function get_logo_yandex(kp_id)
	if not kp_id then return end
		local url = 'https://st.kp.yandex.net/images/film_big/' .. kp_id .. '.jpg'
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then
			return false
		end
		m_simpleTV.Http.SetTimeout(session, 3000)
		m_simpleTV.Http.SetTLSProtocol(session, 'TLS1_2')
		m_simpleTV.Http.EnableLocalCache(session)
		local rc,answer = m_simpleTV.Http.Request(session,{url=url, writeinfile = true})
		m_simpleTV.Http.Close(session)
		return answer
	end

	local function imdbid(kpid)
	if not kpid then return end
	if tonumber(kpid)== 1101239 then return 'tt15307130','Реализация',2019,1 end
	local tv = 0
	local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPW9TN1d6dk5meGU0SzhPY3NQanBBSVU2WHUwMVNpMGZtJmtpbm9wb2lza19pZD0=') .. kpid
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then	return false end
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
		if rc5~=200 then
		if tonumber(kpid) == 231141 then return 'tt0435978','','',1 end
		url_vn = decode64('aHR0cHM6Ly9hcGkuYWxsb2hhLnR2Lz90b2tlbj0wNDk0MWE5YTNjYTNhYzE2ZTJiNDMyNzM0N2JiYzEma3A9') .. kpid
		rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
		if rc5==200 and answer_vn:match('"id_imdb":"(tt%d+)') then
		if answer_vn:match('"seasons":') then tv = 1 end
		return answer_vn:match('"id_imdb":"(tt%d+)'),'','',tv
		end
		return '','','',0
		end
		require('json')
		answer_vn = answer_vn:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
		local tab_vn = json.decode(answer_vn)
		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].content_type and tab_vn.data[1].content_type == 'tv-series' then tv = 1 end
		local kostyl
		if tonumber(kpid) == 1309418 then kostyl = 'tt15325406' tv = 1 end
		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].imdb_id and tab_vn.data[1].imdb_id ~= 'null' and tab_vn.data[1].year then
		return kostyl or tab_vn.data[1].imdb_id or '', unescape3(tab_vn.data[1].title) or '',tab_vn.data[1].year:match('%d%d%d%d') or '', tv
		elseif tab_vn and tab_vn.data and tab_vn.data[1] and ( not tab_vn.data[1].imdb_id or tab_vn.data[1].imdb_id == '') then
		return kostyl or '', unescape3(tab_vn.data[1].title) or '',tab_vn.data[1].year:match('%d%d%d%d') or '', tv
		else return '','','',0
		end
	end

	local function bg_imdb_id(imdb_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then	return false end
	local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ=')

	local rc5,answerd = m_simpleTV.Http.Request(session,{url=urld})
--	debug_in_file(urld .. ' ' .. rc5 .. '\n' .. answerd .. '\n')
	if rc5~=200 then
		m_simpleTV.Http.Close(session)
	return '', '', '', '', '', ''
	end
	require('json')
	answerd = answerd:gsub('(%[%])', '"nil"')
	local tab = json.decode(answerd)
	local background, name_tmdb, tmdb_id, tv, year_tmdb, overview_tmdb = '', '', '', 0, '', ''
	if imdb_id == 'tt27053234' then
	tab.tv_results = {}
	tab.tv_results[1] = {}
	tab.tv_results[1].backdrop_path = "/vkwkX6x7ymz0w6ibmYdmSx38MrJ.jpg"
	tab.tv_results[1].poster_path = "/f7gsprOjZZXuD4cXOQaAiFO4v04.jpg"
	tab.tv_results[1].name = "Призвание"
	tab.tv_results[1].first_air_date = "2021-03-13"
	tab.tv_results[1].overview = "Середина 80-х, Москва. Старшего оперуполномоченного МУРа Владимира Чеянова назначают начальником следственной группы по одному резонансному делу — об убийстве семьи Лошкарёвых. Тела отца, его пожилой матери и старшего сына нашли в собственной квартире в Москве."
	tab.tv_results[1].id = 222216
	end
	if imdb_id == 'tt13496050' then
	tab.tv_results = {}
	tab.tv_results[1] = {}
	tab.tv_results[1].backdrop_path = "/1KbB8eNZfxCspZ3iBGntTqh8V7G.jpg"
	tab.tv_results[1].poster_path = "/1WC3DwHG7B00hcgBNo2G9ppDnC9.jpg"
	tab.tv_results[1].name = "Казанова"
	tab.tv_results[1].first_air_date = "2020-11-19"
	tab.tv_results[1].overview = "Побег не задается. Казанова решает, что им с Эллой нужно разделиться, и едет на попутке в Выборг. Подполковник Бескрылов очень недоволен: результатов нет, Казанова не найден, ограбленный директор завода из Пскова пожаловался руководству, и им дают две недели на то, чтобы появились хоть какие-то результаты.  Шмаков и Новгородцева едут в Псков. Шмаков понимает, что с Новгородцевой что-то происходит. Казанова по наводке приезжает в Ленинград и, представившись поэтом, внедряется в круги прогрессивных творческих людей. Ему необходимо во что бы то ни стало найти возможность уехать за границу. На квартирнике он знакомится с дочерью шведского консула Ингрид и снова делает «ставку» на свое обаяние, перед которым пока не устояла ни одна женщина…"
	tab.tv_results[1].id = 112349
	end
	if imdb_id == 'tt34422564' then
	tab.tv_results = {}
	tab.tv_results[1] = {}
	tab.tv_results[1].backdrop_path = "/q20c7O6kQLJVBrpjwGcd7RT4kEB.jpg"
	tab.tv_results[1].poster_path = "/17pN2J3FQqtzA1VIAUXGnHqufmJ.jpg"
	tab.tv_results[1].name = "Женщина с котом и детективом"
	tab.tv_results[1].first_air_date = "2022-06-10"
	tab.tv_results[1].overview = "Юлия Логинова — стоматолог и начинающий писатель детективов. Недавно у нее вышел первый роман, получивший много положительных отзывов от читателей. Поклонники ждут новую книгу, но есть нюанс. Бойфренд Логиновой — следователь СК Денис Потапов — считает, что первая книга написана благодаря его рассказам и советам, и хочет получить свою часть пирога и быть соавтором книги. Из-за этого Денис и Юлия ссорятся, и Юлия остается без источника вдохновения для новых детективных историй. Вскоре Юлия становится невольной свидетельницей убийства. У нее появляется возможность непосредственно поучаствовать в расследовании."
	tab.tv_results[1].id = 234007
	end
	if imdb_id == 'tt15307130' then
	tab.tv_results = {}
	tab.tv_results[1] = {}
	tab.tv_results[1].backdrop_path = "/vVUNtiF2Ncnyq4DpK4iAOGrgnHS.jpg"
	tab.tv_results[1].poster_path = "/8VMftUs6jYduri1zYdUWDsV43eZ.jpg"
	tab.tv_results[1].name = "Реализация"
	tab.tv_results[1].first_air_date = "2019-03-11"
	tab.tv_results[1].overview = "Опытного розыскника из Великого Новгорода с необычной фамилией Красавéц после конфликта с криминальным бизнесменом переводят на должность простого участкового в Центральный район Петербурга. Всё, что хочет теперь Красавец — это тихо и мирно дослужить до пенсии. Но каждый раз, неожиданно для себя, оказывается в эпицентре преступных событий. То он втянут в разборки между криминальным авторитетом и коллегами из УМВД, то ищет похищенного начальника главка, то ловит неуловимого киллера."
	tab.tv_results[1].id = 120724
	end
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path and not tab.movie_results[1].poster_path
	and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path and not tab.tv_results[1].poster_path
	then return '', '', '', '', '', ''
	else
	if tab.movie_results[1] and imdb_id ~= 'tt0078655' and imdb_id ~= 'tt2317100' and imdb_id ~= 'tt0108778' then

	background = tab.movie_results[1].backdrop_path or ''
	background1 = tab.movie_results[1].poster_path or ''
	name_tmdb = tab.movie_results[1].title or ''
	year_tmdb = tab.movie_results[1].release_date or ''
	overview_tmdb = tab.movie_results[1].overview or ''
	tmdb_id = tab.movie_results[1].id
	elseif tab.tv_results[1] then
	background = tab.tv_results[1].backdrop_path or ''
	background1 = tab.tv_results[1].poster_path or ''
	name_tmdb = tab.tv_results[1].name or ''
	year_tmdb = tab.tv_results[1].first_air_date or ''
	overview_tmdb = tab.tv_results[1].overview or ''
	tmdb_id = tab.tv_results[1].id
	tv = 1
	end
	end
	if year_tmdb and year_tmdb ~= '' then
	year_tmdb = year_tmdb:match('%d%d%d%d')
	else year_tmdb = 0 end
	if background and background ~= nil and background ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background
	elseif background1 and background1 ~= nil and background1 ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background1 end
	if background == nil then background = '' end

	m_simpleTV.User.TMDB.Id = tmdb_id
	m_simpleTV.User.TMDB.tv = tv
	m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.TMDB.Id .. ',' .. m_simpleTV.User.TMDB.tv

	m_simpleTV.User.filmix.CurAddress = nil
	m_simpleTV.User.rezka.CurAddress = nil
	m_simpleTV.User.rezka.ThumbsInfo = nil
	m_simpleTV.User.TVPortal.get.TMDB.Id = tmdb_id
	m_simpleTV.User.TVPortal.get.TMDB.tv = tv
	m_simpleTV.User.TVPortal.get.imdb = imdb_id

	info_fox(name_tmdb,year_tmdb,background)
	return background, name_tmdb, year_tmdb, overview_tmdb, tmdb_id, tv
	end

	local function VFIndex(t)
		local lastQuality = tonumber(m_simpleTV.Config.GetValue('vf_qlty') or 5000)
		local index = #t
			for i = 1, #t do
				if t[i].qlty >= lastQuality then
					index = i
				 break
				end
			end
		if index > 1 then
			if t[index].qlty > lastQuality then
				index = index - 1
			end
		end
	 return index
	end

	local function GetVFAdr(urls)
		if not urls then return end
		local t, i = {}, 1
		local qlty, adr
		for qlty, adr in urls:gmatch('%[(.-)%](http.-%.mp4)') do
			if not qlty:match('%d+') then break end
			t[i] = {}
			t[i].Address = adr
			t[i].Name = qlty
			t[i].qlty = tonumber(qlty:gsub('4k','2160p'):gsub('Preview','180p'):match('(%d+)p'))
			i = i + 1
		end
		if i == 1 then return end
		table.sort(t, function(a, b) return a.qlty < b.qlty end)
		for i = 1, #t do
			t[i].Id = i
			t[i].Address = t[i].Address:gsub('^https://', 'http://') .. '$OPT:NO-STIMESHIFT$OPT:demux=mp4,any'
		end
		m_simpleTV.User.VF.Tab = t
		local index = VFIndex(t)
	 return t[index].Address
	end

	function perevod_VF()
		local t = m_simpleTV.User.VF.TabPerevod
		if not t then return end
		if #t > 0 then
			local current_p = 1
			for i = 1,#t do
				if t[i].Name == getConfigVal('perevod/vf') then current_p = i end
				i = i + 1
			end
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_VF()'}
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(' 🔊 Перевод ', current_p - 1, t, 5000, 1 + 4 + 8 + 2)
			if ret == 1 then
				setConfigVal('perevod/vf', t[id].Name)
				local episode = m_simpleTV.User.VF.CurAddress:match('&e=(%d+)')
				if episode then
					episode = '&e=' .. episode
					m_simpleTV.Control.SetNewAddressT({address = t[id].Address .. episode, position = m_simpleTV.Control.GetPosition()})
				else
					episode = ''
					m_simpleTV.Control.Restart()
				end
			end
			if ret == 3 then
				Qlty_VF()
			end
		end
	end

	function Qlty_VF()
		m_simpleTV.Control.ExecuteAction(36, 0)
		local t = m_simpleTV.User.VF.Tab
			if not t then return end
		local index = VFIndex(t)
		if m_simpleTV.User.VF.zf_bal then
			t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ZF ', ButtonScript = ''}
		end
		if getConfigVal('perevod/vf') ~= '' and m_simpleTV.User.VF.TabPerevod and #m_simpleTV.User.VF.TabPerevod > 1 then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_VF()'}
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 1 + 4 + 8 + 2)
		if m_simpleTV.User.VF.isVideo == false then
			if m_simpleTV.User.VF.DelayedAddress then
				m_simpleTV.Control.ExecuteAction(108)
			else
				m_simpleTV.Control.ExecuteAction(37)
			end
		else
			m_simpleTV.Control.ExecuteAction(37)
		end
		if ret == 1 then
			m_simpleTV.Control.SetNewAddress(t[id].Address, m_simpleTV.Control.GetPosition())
			m_simpleTV.Config.SetValue('vf_qlty', t[id].qlty)
		end
		if ret == 2 then
			m_simpleTV.Control.PlayAddressT({address=m_simpleTV.User.VF.zf_bal, position=m_simpleTV.Control.GetPosition()})
		end
		if ret == 3 then
			perevod_VF()
		end
	end

	local kpid = inAdr:match('id=(%d+)')
	local id_imdb = inAdr:match('id=(tt%d+)')
	if not kpid and id_imdb then
		kpid = kinopoisk_id(id_imdb)
	end
	m_simpleTV.User.VF.kpid = kpid
	m_simpleTV.User.VF.id_imdb = id_imdb

	local season,episode=m_simpleTV.User.VF.CurAddress:match('&s=(%d+).-&e=(%d+)')

	local logo, title, year, overview, tmdbid, tv
	if id_imdb and id_imdb~= '' and bg_imdb_id(id_imdb) and bg_imdb_id(id_imdb)~= '' then
		logo, title, year, overview, tmdbid, tv = bg_imdb_id(id_imdb)
	end
	if (not title or title=='') and (kpid or id_imdb) then
		if kpid then logo = get_logo_yandex(kpid) end
		title, year = Get_Vibix_title(kpid or id_imdb)
	end
	if year and year ~= '' and year ~= 0 then year = ', ' .. year else year = '' end
	if inAdr:match('/embed%-serials/') then
		if not season or not episode then
			if not season then season = 1 end
			if not episode then episode = 1 end
		end
		if id_imdb or kpid then
			get_thumb(season, episode)
		end
		if tonumber(kpid) == 77381 or tonumber(kpid) == 94103 or tonumber(kpid) == 77388 or tonumber(kpid) == 77385 or tonumber(kpid) == 77387 or tonumber(kpid) == 77386 or tonumber(kpid) == 426306 or tonumber(kpid) == 426309 or tonumber(kpid) == 420337 or tonumber(kpid) == 426310 then
			local t3 =
				{
				{1,5,'Барон',77381,'tt0245602',2000},
				{2,10,'Адвокат',94103,'tt0394150',2000},
				{3,8,'Крах Антибиотика',77388,'tt0368589',2001},
				{4,7,'Арестант',77385,'tt0368588',2003},
				{5,5,'Опер',77387,'tt0368590',2003},
				{6,7,'Журналист',77386,'tt0368591',2003},
				{7,12,'Передел',426306,'tt5031866',2005},
				{8,12,'Терминал',426309,'tt4791006',2006},
				{9,12,'Голландский Пассаж',420337,'tt4810954',2006},
				{10,12,'Расплата',426310,'tt4786988',2007},
				}

			for i=1,#t3 do
				if t3[tonumber(i)][4] == tonumber(kpid) then
					title = 'Бандитский Петербург. ' .. t3[tonumber(i)][3] .. ' (Серия ' .. episode .. ')'
					year = t3[tonumber(i)][6]
					break
				end
			end

			m_simpleTV.User.TMDB.Id = 64281
			m_simpleTV.User.TMDB.tv = 1
			m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.TMDB.Id .. ',' .. m_simpleTV.User.TMDB.tv
			if not m_simpleTV.User.TVPortal then
				m_simpleTV.User.TVPortal = {}
			end
			if not m_simpleTV.User.TVPortal.get then
				m_simpleTV.User.TVPortal.get = {}
			end
			if not m_simpleTV.User.TVPortal.get.TMDB then
				m_simpleTV.User.TVPortal.get.TMDB = {}
			end
			if not m_simpleTV.User.TVPortal.cor then
				m_simpleTV.User.TVPortal.cor = {}
			end
			m_simpleTV.User.filmix.CurAddress = nil
			m_simpleTV.User.rezka.CurAddress = nil
			m_simpleTV.User.TVPortal.get.TMDB.Id = 64281
			m_simpleTV.User.TVPortal.get.TMDB.tv = 1
			info_fox('Бандитский Петербург',2000,'')
		else
			title = (title or 'VF') .. ' (Сезон ' .. season .. ', Эпизод ' .. episode .. ')'
		end
	end
-------------------------
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local rc,answer = m_simpleTV.Http.Request(session,{url = inAdr:gsub('&.-$','')})
	if rc~=200 or not answer then return end
-------------------------
	local title1 = answer:match('<title>(.-)</title>')
	if title == '' then title = nil end
	if not title then title = title1 end
	m_simpleTV.User.VF.titleTab = nil
	m_simpleTV.User.VF.isVideo = nil
	m_simpleTV.User.VF.zf_bal = nil
--	m_simpleTV.Control.CurrentTitle_UTF8 = (title or m_simpleTV.Control.CurrentTitle_UTF8 or 'Vibix') .. year
--	m_simpleTV.Control.SetTitle((title or m_simpleTV.Control.CurrentTitle_UTF8 or 'Vibix') .. year)

	local zf_b
	if kpid then
		zf_b = Get_ZF(kpid)
		if zf_b then
		if season then zf_b = zf_b .. '&s=' .. season end
		if episode then zf_b = zf_b .. '&e=' .. episode end
		m_simpleTV.User.VF.zf_bal = zf_b
		end
	end

	local retAdr
	retAdr = answer:match('new Playerjs%((.-)%);')
	retAdr = retAdr:gsub('&#179;','³')
		if not retAdr then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'VF: Медиаконтент не доступен', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			m_simpleTV.Control.ExecuteAction(11)
			return
		end
		if retAdr == '' then
			m_simpleTV.Control.ExecuteAction(102, 1)
			return
		end
		local t1,i,current_p = {},1,1
		local poster = retAdr:match('poster:.-"(.-)"')
		local file_all = retAdr:gsub('^.-%,file:',''):gsub('%,poster.-$',''):gsub('%}$','')
		if m_simpleTV.Control.MainMode == 0 then
			m_simpleTV.Control.ChangeChannelLogo((logo or poster or ''), m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
			if logo then
			m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = poster or logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
			end
		end

		local tr,file

	if inAdr:match('/embed/') then
		if id_imdb or kpid then
			get_thumb()
		end
		for w in file_all:gmatch('%{.-%}') do
			tr,file = w:match('"title":"(.-)"%,"file":"(.-)"')
			if not tr or not file then break end
			t1[i]={}
			t1[i].Id = i
			t1[i].Address = file
			t1[i].Name = tr
			if t1[i].Name == getConfigVal('perevod/vf') then
				current_p = i
				is_perevod = true
			end
			i=i+1
		end
		m_simpleTV.User.VF.TabPerevod = t1
		if i > 2 then
			if current_p then
			retAdr = t1[tonumber(current_p)].Address
			title = (title or m_simpleTV.Control.CurrentTitle_UTF8 or 'Vibix') .. ' - ' .. t1[tonumber(current_p)].Name
			else
				retAdr = t1[1].Address
				current_p = 1
				setConfigVal('perevod/vf', t1[1].Name)
				title = (title or m_simpleTV.Control.CurrentTitle_UTF8 or 'Vibix') .. ' - ' .. t1[1].Name
			end
		elseif i == 2 then
			retAdr = t1[1].Address
			current_p = 1
			setConfigVal('perevod/vf', t1[1].Name)
			title = (title or m_simpleTV.Control.CurrentTitle_UTF8 or 'Vibix') .. ' - ' .. t1[1].Name
		else
			return
		end
		retAdr = GetVFAdr(retAdr)
	end

	local t,current_ep = {},1

	if inAdr:match('/embed%-serials/') then
		current_ep, current_p, retAdr = get_all_content(file_all, inAdr, current_np)
		m_simpleTV.Control.CurrentTitle_UTF8 = (title or m_simpleTV.Control.CurrentTitle_UTF8 or title1 or 'Vibix') .. year .. ' - ' .. getConfigVal('perevod/vf')
		t = m_simpleTV.User.VF.titleTab
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_VF()'}
		if getConfigVal('perevod/vf') ~= '' and m_simpleTV.User.VF.TabPerevod and #m_simpleTV.User.VF.TabPerevod > 1 then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_VF()'}
		end
		m_simpleTV.OSD.ShowSelect_UTF8('VF: ' .. (title or 'Vibix'), current_ep - 1, t, 10000, 32)
		retAdr = GetVFAdr(retAdr)
		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.Control.CurrentAddress = retAdr
		return
	else
		if current_np then
			m_simpleTV.Control.CurrentTitle_UTF8 = (title or m_simpleTV.Control.CurrentTitle_UTF8 or 'Vibix') .. year	m_simpleTV.Control.SetTitle((title or m_simpleTV.Control.CurrentTitle_UTF8 or 'Vibix') .. year)
		end
		t[1] = {}
		t[1].Id = 1
		t[1].Name = title:gsub(' %- $','')
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' ⚙ ', ButtonScript = 'Qlty_VF()'}
		if getConfigVal('perevod/vf') ~= '' and m_simpleTV.User.VF.TabPerevod and #m_simpleTV.User.VF.TabPerevod > 1 then
			t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔊 ', ButtonScript = 'perevod_VF()'}
		end
		m_simpleTV.OSD.ShowSelect_UTF8('VF: ' .. (title:gsub('^.- %- ','') or ''), 0, t, 8000, 32 + 64 + 128)
	end

	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.CurrentAddress = retAdr
--  debug_in_file(retAdr .. '\n')