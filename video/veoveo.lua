-- видеоскрипт для балансера VeoVeo (16.08.25)
-- author west_side
	if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
	if m_simpleTV.Control.CurrentAddress:match('^tmdb_id=') or m_simpleTV.Control.CurrentAddress:match('^https?://ex%-fs%.%a+')
	then return end
	if not m_simpleTV.Control.CurrentAddress:match('/lite/veoveo')
	then return end
	local inAdr = m_simpleTV.Control.CurrentAddress
	--:gsub('rjson=False&','')
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.VV then
		m_simpleTV.User.VV = {}
	end
	if not m_simpleTV.User.TMDB then
		m_simpleTV.User.TMDB = {}
	end
	if not m_simpleTV.User.EXFS then
		m_simpleTV.User.EXFS = {}
	end
	if not m_simpleTV.User.TVPortal then
		m_simpleTV.User.TVPortal = {}
	end
	m_simpleTV.User.TMDB.Id = nil
	m_simpleTV.User.TMDB.tv = nil
	m_simpleTV.User.VV.id_imdb = nil
	m_simpleTV.User.VV.kpid = nil
	m_simpleTV.User.VV.CurAddress = inAdr
	m_simpleTV.User.VV.DelayedAddress = nil
	m_simpleTV.User.VV.PositionThumbsHandler = nil
	m_simpleTV.User.TVPortal.balanser = 'VideoDB'
	m_simpleTV.User.westSide.PortalTable = true
	m_simpleTV.User.VV.Scheme = inAdr:match('&scheme=(.-)$')
	m_simpleTV.User.EXFS.CurAddress = m_simpleTV.User.VV.Scheme
	
	m_simpleTV.Control.CurrentTitle_UTF8 = m_simpleTV.User.EXFS.title:gsub(' %- Украинский','') .. ' (' .. m_simpleTV.User.EXFS.year .. ')'
	
local function externalids(id)
	if not id then return end
	local embed
	if id:match('^(tt%d+)$') then
		embed = 'imdb_id=' .. id
	elseif id:match('^(%d+)$') then
		embed = 'kinopoisk_id=' .. id
	end
	if id == 'tt0086333' then return '77264' end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = 'https://api.manhan.one/externalids?' .. embed
	local rc, answer = m_simpleTV.Http.Request(session,{url=url})
	m_simpleTV.Http.Close(session)
	if rc == 200 then
		if id:match('^(tt%d+)$') then
			return answer:match('"kinopoisk_id":"(%d+)"') or ''
		elseif id:match('^(%d+)$') then
			return answer:match('"imdb_id":"(tt%d+)"') or ''
		end
	end
	return ''
end

	local kp_id = inAdr:match('kinopoisk_id=(%d+)') or ''
	local imdb_id = inAdr:match('imdb_id=(tt%d+)') or ''
	
-- id
	if kp_id == '' and imdb_id == '' then
		return
	elseif kp_id == '' then
		kp_id = externalids(imdb_id)
	elseif imdb_id == '' then
		imdb_id = externalids(kp_id)	
	end
-----

	if not (
	kp_id
	and kp_id~= ''
	and tonumber(kp_id)
	and m_simpleTV.User.VV.kpid
	and tonumber(kp_id) == tonumber(m_simpleTV.User.VV.kpid)
	or
	imdb_id
	and imdb_id~= ''
	and m_simpleTV.User.VV.imdbid
	and imdb_id == m_simpleTV.User.VV.imdbid
	) then
		m_simpleTV.User.VV.serial = nil		
	end

	m_simpleTV.User.VV.kpid = kp_id
	m_simpleTV.User.VV.imdbid = imdb_id	

	local season, episode = inAdr:match('&s=(%d+).-&e=(%d+)')

--	if not season or not episode then season = 1 episode = 1 end
---------------------------------block thumb
local function check_thumb(url, session)
	local rc, answer = m_simpleTV.Http.Request(session,{url=url})
	if rc == 200 then return true end
--	m_simpleTV.Http.Close(session)
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
--	local url = 'https://api' .. os.time() .. '.synchroncode.com/embed/'
	local url = 'https://api.kinogram.best/embed/'
	if m_simpleTV.User.VV.kpid and m_simpleTV.User.VV.kpid ~= '' then
		url = url .. 'kp/' .. m_simpleTV.User.VV.kpid
	elseif m_simpleTV.User.VV.imdbid and m_simpleTV.User.VV.imdbid ~= '' then
		url = 'https://api' .. os.time() .. '.synchroncode.com/embed/imdb/' .. m_simpleTV.User.VV.imdbid	
	else
		return false
	end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		return false
	end
	m_simpleTV.Http.SetTimeout(session, 6000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: api.synchroncode.com'})
	if rc == 200 and answer then
		local all_data = answer:match('preview: %{(.-)%}%,')
		if not all_data then
			m_simpleTV.Http.Close(session)
			if not m_simpleTV.User.VV.PositionThumbsHandler then
				local handlerInfo = {}
				handlerInfo.luaFunction = 'PositionThumbs_VV'
				handlerInfo.regexString = '/lite/veoveo|/movies/files/episodes/'
				handlerInfo.sizeFactor = 0.15
				handlerInfo.backColor = ARGB(191, 30, 33, 61)
				handlerInfo.textColor = ARGB(255, 255, 215, 0)
				handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
				handlerInfo.marginBottom = 5
				handlerInfo.showPreviewWhileSeek = false
				handlerInfo.clearImgCacheOnStop = false
				handlerInfo.minImageWidth = 0
				handlerInfo.minImageHeight = 0
				m_simpleTV.User.VV.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
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
			if not m_simpleTV.User.VV.PositionThumbsHandler then
				local handlerInfo = {}
				handlerInfo.luaFunction = 'PositionThumbs_VV'
				handlerInfo.regexString = '/lite/veoveo|/movies/files/episodes/'
				handlerInfo.sizeFactor = 0.12
				handlerInfo.backColor = ARGB(191, 30, 33, 61)
				handlerInfo.textColor = ARGB(255, 255, 215, 0)
				handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
				handlerInfo.marginBottom = 5
				handlerInfo.showPreviewWhileSeek = false
				handlerInfo.clearImgCacheOnStop = false
				handlerInfo.minImageWidth = 0
				handlerInfo.minImageHeight = 0
				m_simpleTV.User.VV.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
			end
			return
		end
		if season and episode then src_id = get_id_for_episode(answer,season,episode) or src_id end
		local src = src_pre .. src_id .. '/desktop/'
		local check = check_thumb(src .. firstNum .. '.webp',session)
		if not check then
			m_simpleTV.Http.Close(session)
			if not m_simpleTV.User.VV.PositionThumbsHandler then
				local handlerInfo = {}
				handlerInfo.luaFunction = 'PositionThumbs_VV'
				handlerInfo.regexString = '/lite/veoveo|/movies/files/episodes/'
				handlerInfo.sizeFactor = 0.12
				handlerInfo.backColor = ARGB(191, 30, 33, 61)
				handlerInfo.textColor = ARGB(255, 255, 215, 0)
				handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
				handlerInfo.marginBottom = 5
				handlerInfo.showPreviewWhileSeek = false
				handlerInfo.clearImgCacheOnStop = false
				handlerInfo.minImageWidth = 0
				handlerInfo.minImageHeight = 0
				m_simpleTV.User.VV.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
			end
			return
		end
			--[[interval: 5,
			width: 160, height: 90,
			spriteSize: 100, rowSize: 10,
			src: 'https://img.zcvh.net/'+  920021  +'/desktop/thumb-${spriteNum}.webp',
			firstNum: 1, pad: 1]]

		if m_simpleTV.Control.MainMode ~= 0 then return end

		m_simpleTV.User.VV.ThumbsInfo = {}
		m_simpleTV.User.VV.ThumbsInfo.samplingFrequency = interval * 1000
		m_simpleTV.User.VV.ThumbsInfo.thumbsPerImage = spriteSize
		m_simpleTV.User.VV.ThumbsInfo.thumbWidth = width
		m_simpleTV.User.VV.ThumbsInfo.thumbHeight = height
		m_simpleTV.User.VV.ThumbsInfo.urlPattern = src
		m_simpleTV.User.VV.ThumbsInfo.firstNum = firstNum

		if not m_simpleTV.User.VV.PositionThumbsHandler then
			local handlerInfo = {}
			handlerInfo.luaFunction = 'PositionThumbs_VV'
			handlerInfo.regexString = '/lite/veoveo|/movies/files/episodes/'
			handlerInfo.sizeFactor = 0.12
			handlerInfo.backColor = ARGB(191, 26, 22, 42)
			if m_simpleTV.User.TVPortal.isTEXTonTHUMB then 			
			handlerInfo.textColor = ARGB(222, 253, 234, 168)
			handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
			else			
			handlerInfo.textColor = ARGB(0, 253, 234, 168)
			handlerInfo.glowParams = 'glow="0" samples="0" extent="0" color="0x00000000"'
			end
			handlerInfo.marginBottom = 5
			handlerInfo.showPreviewWhileSeek = false
			handlerInfo.clearImgCacheOnStop = false
			handlerInfo.minImageWidth = width
			handlerInfo.minImageHeight = height
			m_simpleTV.User.VV.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
		end
		m_simpleTV.Http.Close(session)
	else
		if not m_simpleTV.User.VV.PositionThumbsHandler then
			local handlerInfo = {}
			handlerInfo.luaFunction = 'PositionThumbs_VV'
			handlerInfo.regexString = '/lite/veoveo|/movies/files/episodes/'
			handlerInfo.sizeFactor = 0.12
			handlerInfo.backColor = ARGB(191, 30, 33, 61)
			handlerInfo.textColor = ARGB(255, 255, 215, 0)
			handlerInfo.glowParams = 'glow="7" samples="5" extent="4" color="0xB0000000"'
			handlerInfo.marginBottom = 5
			handlerInfo.showPreviewWhileSeek = false
			handlerInfo.clearImgCacheOnStop = false
			handlerInfo.minImageWidth = 0
			handlerInfo.minImageHeight = 0
			m_simpleTV.User.VV.PositionThumbsHandler = m_simpleTV.PositionThumbs.AddHandler(handlerInfo)
		end
		m_simpleTV.Http.Close(session)
		return
	end
end

function PositionThumbs_VV(queryType, address, forTime)
	if not m_simpleTV.User.VV then return true end
----[[
	if queryType == 'testAddress' and not m_simpleTV.User.VV.ThumbsInfo then
	 return false
	end--]]
	if queryType == 'getThumbs' then
			if not m_simpleTV.User.VV or not m_simpleTV.User.VV.ThumbsInfo or m_simpleTV.User.VV.ThumbsInfo == nil then
			 return false
			end
		local imgLen = m_simpleTV.User.VV.ThumbsInfo.samplingFrequency * m_simpleTV.User.VV.ThumbsInfo.thumbsPerImage
		local index = math.floor(forTime / imgLen)
		local t = {}
		t.playAddress = address
		t.url = m_simpleTV.User.VV.ThumbsInfo.urlPattern .. (m_simpleTV.User.VV.ThumbsInfo.firstNum + index) .. '.webp'
		t.httpParams = {}
		t.httpParams.extHeader = 'referer:' .. address
		t.elementWidth = m_simpleTV.User.VV.ThumbsInfo.thumbWidth
		t.elementHeight = m_simpleTV.User.VV.ThumbsInfo.thumbHeight
		t.startTime = index * imgLen
		t.length = imgLen
		t.elementsPerImage = m_simpleTV.User.VV.ThumbsInfo.thumbsPerImage
		t.marginLeft = 0
		t.marginRight = 0
		t.marginTop = 0
		t.marginBottom = 0
		m_simpleTV.PositionThumbs.AppendThumb(t)
	 return true
	end
end
---------------------------------end block thumb
---------------------------------block serial
local function Get_VeoVeo_Serial()
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local url = 'https://p01--lampac--9dxms589q2gt.code.run/lite/veoveo?' .. 'kinopoisk_id=' .. m_simpleTV.User.VV.kpid .. '&imdb_id=' .. m_simpleTV.User.VV.imdbid
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})	
--	debug_in_file(rc .. ' ' .. url .. '\n' .. (answer or 'NOT') .. '\n')
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
	local t,i = {},1
	if answer:match('"method":"play"') then
		t[1]={}
		t[1].Id=1
		t[1].Name='VeoVeo'
		t[1].Address1=answer:match('"url":"(.-)"')
		t[1].Address=url
	else
--	answer = answer:gsub('\n%s+','\n')
	
		for url in answer:gmatch('"url".-"(.-)"') do

			local rc1, answer1 = m_simpleTV.Http.Request(session, {url = url})
--			debug_in_file(rc1 .. ' ' .. url .. '\n' .. answer1 .. '\n')
			for w in answer1:gmatch('<div class="videos__item videos__movie selector.-</div></div>') do
				local s,e,url1,title = w:match(' s="(.-)".- e="(.-)".-"url".-"(.-)".-"videos__item%-title">(.-)</div>')
				
				t[i]={}
				t[i].Id=i
				t[i].Name='Сезон '..s.. ' Эпизод ' ..e.. ' - ' .. title
				t[i].Address1=url1
				t[i].Address=url:gsub('&s=.-$','')..'&s='..s..'&e='..e..'&scheme='..(m_simpleTV.User.VV.Scheme or '')
--				debug_in_file('s='..s.. ' e='..e.. ' '..title.. '\n' .. url1 .. '\n' .. t[i].Address .. '\n')
				i=i+1
			end
		end
	end
	m_simpleTV.User.VV.serial = t
	return
end
---------------------------------end block serial
	info_fox(m_simpleTV.User.EXFS.title:gsub(' %- Украинский',''),m_simpleTV.User.EXFS.year,m_simpleTV.User.EXFS.logo)
	if m_simpleTV.User.VV.serial == nil then		
		Get_VeoVeo_Serial()
	end	
	local current_episode = 1
	for i = 1, #m_simpleTV.User.VV.serial do		
		if m_simpleTV.User.VV.serial[i].Address == inAdr then
			current_episode = i
		end
	end
	get_thumb(season, episode)
	m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.Control.CurrentTitle_UTF8, tonumber(current_episode)-1, m_simpleTV.User.VV.serial, 10000, 32)
--		debug_in_file(retAdr .. '\n')
		local retAdr = m_simpleTV.User.VV.serial[tonumber(current_episode)].Address1		
		m_simpleTV.Control.SetTitle(m_simpleTV.Control.CurrentTitle_UTF8 .. ' - ' .. m_simpleTV.User.VV.serial[tonumber(current_episode)].Name)
		m_simpleTV.Control.ChangeAdress = 'Yes'
		m_simpleTV.Control.CurrentAddress = retAdr
