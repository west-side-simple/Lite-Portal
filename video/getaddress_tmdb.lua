-- видеоскрипт воспроизведения контента по tmdb_id,tv (09/04/25)
-- author west_side

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('^tmdb_id=') 
	and not inAdr:match('themoviedb%.org/movie/%d+') 
	and not inAdr:match('themoviedb%.org/tv/%d+') then
		return
	end
	
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''

local function check_thumb(url,session)
	local rc, answer = m_simpleTV.Http.Request(session,{url=url})
	if rc == 200 then return true end
	m_simpleTV.Http.Close(session)
	return
end

local function get_thumb()
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local url = 'https://api.ninsel.ws/embed/imdb/' .. m_simpleTV.User.TVPortal.get.imdb
	local rc, answer = m_simpleTV.Http.Request(session,{url=url})
	if rc == 200 and answer then
		local all_data = answer:match('preview: %{(.-)%}%,')
		if not all_data then
			m_simpleTV.Http.Close(session)
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
			return
		end
		local src = src_pre .. src_id .. '/desktop/thumb-'
		local check = check_thumb(src .. firstNum .. '.webp',session)
		if not check then return end
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
			handlerInfo.luaFunction = 'PositionThumbs_TMDB'
			handlerInfo.regexString = ''
			handlerInfo.sizeFactor = 0.15
			handlerInfo.backColor = ARGB(255, 0, 0, 0)
			handlerInfo.textColor = ARGB(215, 255, 215, 0)
			handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
			handlerInfo.marginBottom = 0
			handlerInfo.showPreviewWhileSeek = true
			handlerInfo.clearImgCacheOnStop = false
			handlerInfo.minImageWidth = 16
			handlerInfo.minImageHeight = 9
			m_simpleTV.User.TVPortal.get.TMDB.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
		end
		m_simpleTV.Http.Close(session)
	end
	m_simpleTV.Http.Close(session)
end

function PositionThumbs_TMDB(queryType, address, forTime)
	if not m_simpleTV.User.TVPortal.get then return true end
	if queryType == 'testAddress' and m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo then
	 if string.match(address, "/lite/zetflix") or
	 string.match(address, "videoframe1%.com/embed/")
	 then return true end
	 return false
	end
	if queryType == 'getThumbs' then
			if not m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo or m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo == nil then
			 return true
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

local function imdbid(tmdbtvid)
--	debug_in_file('tv tmdb_id: ' .. tmdbtvid .. '\n','c://1/tmdb_id.txt')
	--fix
	if tonumber(tmdbtvid) == 120724 then return 'tt15307130' end
	if tonumber(tmdbtvid) == 64281 then return 'tt0245602' end
	if tonumber(tmdbtvid) == 222216 then return 'tt27053234' end
	--
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url_im = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. tmdbtvid .. decode64('L2V4dGVybmFsX2lkcz9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJV')
	local rc6,answer_im = m_simpleTV.Http.Request(session,{url=url_im})

		if rc6~=200 then
		return ''
		end
		require('json')
		answer_im = answer_im:gsub('(%[%])', '"nil"')
		local tab_im = json.decode(answer_im)

		if tab_im and tab_im.imdb_id then
		return tab_im.imdb_id
		else
		return ''
		end
end

local function Get_current_global(tmdbid,tv)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local urltm, titul_tmdb_media, tmdb_media
	if tonumber(tv) == 0 then
		urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ=='):gsub('=ru','=ru')
	elseif tonumber(tv) == 1 then
		urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ=='):gsub('=ru','=ru')
	end
	local rc3,answertm = m_simpleTV.Http.Request(session,{url=urltm})
	if rc3~=200 then
	  m_simpleTV.Http.Close(session)
	  return
	end
	require('json')
	answertm = answertm:gsub('(%[%])', '"nil"')
	local tab = json.decode(answertm)
	local poster, background, overview, ru_name, year
	if tab.poster_path and tab.poster_path ~= 'null' then
	poster = tab.poster_path
	poster = 'http://image.tmdb.org/t/p/original' .. poster
	else poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/no-img.png'
	end
	if tab.backdrop_path and tab.backdrop_path ~= 'null'
	then
	background = tab.backdrop_path
	background = 'http://image.tmdb.org/t/p/original' .. background
	else background = poster
	end
	overview = tab.overview or ''
	ru_name = tab.title or tab.name or tab.original_title or tab.original_name or 'TMDB'
	year = tab.release_date or tab.first_air_date
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end

	local imdb_id
	if tab.seasons then
		imdb_id = imdbid(tmdbid)
	else
		imdb_id = tab.imdb_id
	end
	m_simpleTV.User.TVPortal.get.imdb = imdb_id
	m_simpleTV.User.TVPortal.get.title = ru_name
	m_simpleTV.User.TVPortal.get.year = year
	m_simpleTV.User.TVPortal.get.background = background
	m_simpleTV.User.TVPortal.get.overview = overview
	m_simpleTV.User.TVPortal.get.poster = poster
end

	local tmdb_id, tv, retAdr = inAdr:match('^tmdb_id=(.-)&tv=(.-)&(.-)$')
	if inAdr:match('themoviedb%.org/movie/%d+') then tv = 0 tmdb_id = inAdr:match('themoviedb%.org/movie/(%d+)') end
	if inAdr:match('themoviedb%.org/tv/%d+')  then tv = 1 tmdb_id = inAdr:match('themoviedb%.org/tv/(%d+)') end

	if not retAdr then
		m_simpleTV.Control.SetTitle('TMDB')
		m_simpleTV.Control.CurrentTitle_UTF8 = 'TMDB'
		m_simpleTV.Control.CurrentAdress = 'wait'
		return tmdb_info_for_stena(tmdb_id, tv)
	end

--	m_simpleTV.OSD.ShowMessage_UTF8(tmdb_id .. '/' .. tv)
	if not m_simpleTV.User.westSide then
		m_simpleTV.User.westSide = {}
	end
	if not m_simpleTV.User.filmix then
		m_simpleTV.User.filmix = {}
	end
	if not m_simpleTV.User.rezka then
		m_simpleTV.User.rezka = {}
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
	if not m_simpleTV.User.TVPortal.cor.TMDB then
		m_simpleTV.User.TVPortal.cor.TMDB = {}
	end
	m_simpleTV.User.filmix.CurAddress = nil
	m_simpleTV.User.rezka.CurAddress = nil
	m_simpleTV.User.rezka.ThumbsInfo = nil
	m_simpleTV.User.TVPortal.get.TMDB.ThumbsInfo = nil
	local is_continuous = false
	if m_simpleTV.User.TVPortal.cor.TMDB.Id and tonumber(m_simpleTV.User.TVPortal.cor.TMDB.Id) == tonumber(tmdb_id) and tonumber(tv) == 0 then is_continuous = true end
	m_simpleTV.User.TVPortal.get.TMDB.Id = tmdb_id
	m_simpleTV.User.TVPortal.get.TMDB.tv = tv
	m_simpleTV.User.TVPortal.cor.TMDB.Id = tmdb_id
	m_simpleTV.User.TVPortal.cor.TMDB.tv = tv
	m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.TVPortal.get.TMDB.Id .. ',' .. m_simpleTV.User.TVPortal.get.TMDB.tv

	Get_current_global(m_simpleTV.User.TVPortal.get.TMDB.Id, m_simpleTV.User.TVPortal.get.TMDB.tv)

	if m_simpleTV.User.TVPortal.get.imdb then
		get_thumb()
	end

	local title = m_simpleTV.User.TVPortal.get.title .. ' (' .. m_simpleTV.User.TVPortal.get.year .. ')'
	
	add_to_history_tmdb(inAdr, title, m_simpleTV.User.TVPortal.get.poster)
	
	if not retAdr:match('https://api%.manhan%.one/proxy/') then
		m_simpleTV.Control.CurrentTitle_UTF8 = title
		m_simpleTV.Control.SetTitle(title)
	else
		m_simpleTV.User.TVPortal.balanser = 'VideoDB'
	end

	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAddress = retAdr

	local t = {}
	t.BackColor = 0
	t.BackColorEnd = 255
	t.PictFileName = m_simpleTV.User.TVPortal.get.background
	t.TypeBackColor = 0
	t.UseLogo = 3
	t.Once = 1
	t.Blur = 0
	m_simpleTV.Interface.SetBackground(t)

	m_simpleTV.Control.ChangeChannelLogo(m_simpleTV.User.TVPortal.get.background:gsub('original','w533_and_h300_bestv2') , m_simpleTV.Control.ChannelID)

	info_fox(m_simpleTV.User.TVPortal.get.title,m_simpleTV.User.TVPortal.get.year,m_simpleTV.User.TVPortal.get.background)
	if retAdr:match('https://www%.youtube%.com/watch?v=') then m_simpleTV.User.TVPortal.balanser = 'Youtube' end
	if retAdr == '' then
		if m_simpleTV.User.TVPortal.get.imdb and m_simpleTV.User.TVPortal.get.imdb ~= '' then
			return m_simpleTV.Control.SetNewAddressT({address = 'https://www.imdb.com/title/' .. m_simpleTV.User.TVPortal.get.imdb, title = m_simpleTV.User.TVPortal.get.title .. ' (' .. m_simpleTV.User.TVPortal.get.year .. ')', position = 0})
		else
			m_simpleTV.Control.CurrentAdress = 'wait'
			return media_info_tmdb(tmdb_id, tv)
		end
	end
	if is_continuous == true then
		m_simpleTV.Control.SetNewAddress(retAdr)
	else
		m_simpleTV.Control.SetNewAddress(retAdr,0)
	end
