-- видеоскрипт воспроизведения контента по tmdb_id,tv (07/12/23)
-- author west_side

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('^tmdb_id=') then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''

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

	m_simpleTV.User.TVPortal.get.title = ru_name
	m_simpleTV.User.TVPortal.get.year = year
	m_simpleTV.User.TVPortal.get.background = background
	m_simpleTV.User.TVPortal.get.overview = overview
end

	local tmdb_id, tv, retAdr = inAdr:match('^tmdb_id=(.-)&tv=(.-)&(.-)$')
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
	local is_continuous = false
	if m_simpleTV.User.TVPortal.cor.TMDB.Id and tonumber(m_simpleTV.User.TVPortal.cor.TMDB.Id) == tonumber(tmdb_id) and tonumber(tv) == 0 then is_continuous = true end
	m_simpleTV.User.TVPortal.get.TMDB.Id = tmdb_id
	m_simpleTV.User.TVPortal.get.TMDB.tv = tv
	m_simpleTV.User.TVPortal.cor.TMDB.Id = tmdb_id
	m_simpleTV.User.TVPortal.cor.TMDB.tv = tv	
	m_simpleTV.User.westSide.PortalTable = m_simpleTV.User.TVPortal.get.TMDB.Id .. ',' .. m_simpleTV.User.TVPortal.get.TMDB.tv

	Get_current_global(m_simpleTV.User.TVPortal.get.TMDB.Id, m_simpleTV.User.TVPortal.get.TMDB.tv)

	local title = m_simpleTV.User.TVPortal.get.title .. ' (' .. m_simpleTV.User.TVPortal.get.year .. ')'

	m_simpleTV.Control.CurrentTitle_UTF8 = title
	m_simpleTV.Control.SetTitle(title)
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
	
	if is_continuous == true then
		m_simpleTV.Control.SetNewAddress(retAdr)
	else
		m_simpleTV.Control.SetNewAddress(retAdr,0)
	end
	
