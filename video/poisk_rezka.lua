-- видеоскрипт поиска медиаконтента на видеобалансере Rezka (16/06/22)
-- autor westSide
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not m_simpleTV.Control.CurrentAddress:match('^#')
		then
		 return
		end

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101 Firefox/96.0')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)

-------------------------------------------------------------------
function UpdatePersonRezka()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
if package.loaded['tvs_core'] and package.loaded['tvs_func'] then
    local tmp_sources = tvs_core.tvs_GetSourceParam() or {}
    for SID, v in pairs(tmp_sources) do
         if v.name:find('PERSONS')
		 then
		    tvs_core.UpdateSource(SID, false)
            tvs_func.OSD_mess('', -2)
         end
    end
end
end

function GetTranslate(inAdr1)
m_simpleTV.Control.SetNewAddress(inAdr1, m_simpleTV.Control.GetPosition())
end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

local function bg_imdb_id(imdb_id)
--#!!nexterr code!!#--
local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
if rc1~=200 then
  m_simpleTV.Http.Close(session)
  return
end
require('json')
answerd = answerd:gsub('(%[%])', '"nil"')
local tab = json.decode(answerd)
local background = ''
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then background = '' else
	if tab.movie_results[1] then
	background = tab.movie_results[1].backdrop_path or ''
	poster = tab.movie_results[1].poster_path or ''
	elseif tab.tv_results[1] then
	background = tab.tv_results[1].backdrop_path or ''
	poster = tab.tv_results[1].poster_path or ''
	end
	if background and background ~= nil and background ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background end
	if poster and poster ~= '' then poster = 'http://image.tmdb.org/t/p/original' .. poster end
	if poster and poster ~= '' and background == '' then background = poster end
    end
	if background == nil then background = '' end
	return background
end

local function bg_poster_title(title, year)

local urld = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&year=' .. year
local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
if rc1~=200 then
  m_simpleTV.Http.Close(session)
  return
end
require('json')
answerd = answerd:gsub('(%[%])', '"nil"')
local tab = json.decode(answerd)
	if not tab or not tab.results[1]
	then
	local urld2 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&first_air_date_year=' .. year
local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
if rc2~=200 then
  m_simpleTV.Http.Close(session)
  return
end
require('json')
answerd2 = answerd2:gsub('(%[%])', '"nil"')

local tab = json.decode(answerd2)
	if not tab or not tab.results[1]
	then
	background, poster, overview, rating, count, ru_name, orig_name, promo, genre, country, slogan, tmid = '', '', '', '', '', '', '', '', '', '', '', ''
	else
	if tab.results[1].poster_path and tab.results[1].poster_path ~= 'null' then
	poster = tab.results[1].poster_path
	poster = 'http://image.tmdb.org/t/p/original' .. poster
	else poster = logo
	end
	if tab.results[1].backdrop_path and tab.results[1].backdrop_path ~= 'null'
	then
	background = tab.results[1].backdrop_path
	background = 'http://image.tmdb.org/t/p/original' .. background
	else background = logo
	end

	overview = tab.results[1].overview
	rating = tab.results[1].vote_average
	count = tab.results[1].vote_count
	ru_name = tab.results[1].name
	orig_name = tab.results[1].original_name
	tmid = tab.results[1].id
	promo, genre, country, slogan = '', 'сериал', '', ''

end
	else
	if tab.results[1].poster_path and tab.results[1].poster_path ~= 'null' then
	poster = tab.results[1].poster_path
	poster = 'http://image.tmdb.org/t/p/original' .. poster
	else poster = logo
	end
	if tab.results[1].backdrop_path and tab.results[1].backdrop_path ~= 'null'
	then
	background = tab.results[1].backdrop_path
	background = 'http://image.tmdb.org/t/p/original' .. background
	else background = logo
	end

	overview = tab.results[1].overview
	rating = tab.results[1].vote_average
	count = tab.results[1].vote_count
	ru_name = tab.results[1].title
	orig_name = tab.results[1].original_title
	tmid = tab.results[1].id
--	promo, genre, country, slogan = promo_tm(tmid)
end
	return overview
end

	local function findpersonIdByName(person)
	local urlt = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvcGVyc29uP2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmcGFnZT0xJmluY2x1ZGVfYWR1bHQ9ZmFsc2UmcXVlcnk9') .. m_simpleTV.Common.toPercentEncoding(person)
	local id, name, logo
	local rc, answert = m_simpleTV.Http.Request(session, {url = urlt})
	if rc~=200 then
	return '','',''
	end
	require('json')
	answert = answert:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert)

	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name
	then
	return '','','' end


	local rus = tab.results[1].name or ''
	local department = tab.results[1].known_for_department or ''
	department = department:gsub('Acting','Актёрское искусство: '):gsub('Directing','Режиссура: '):gsub('Writing','Сценарист: '):gsub('Creating','Продюсер: ')
	local poster
	if tab.results[1].profile_path and tab.results[1].profile_path ~= 'null' then
	poster = tab.results[1].profile_path
	poster = 'http://image.tmdb.org/t/p/w180_and_h180_face' .. poster
	else poster = './luaScr/user/show_mi/no-img.png'
	end
	local known_for
	if tab.results[1].known_for and tab.results[1].known_for ~= 'nil' and (tab.results[1].known_for[1].title or tab.results[1].known_for[1].name)then
	known_for = tab.results[1].known_for[1].title or tab.results[1].known_for[1].name
	if tab.results[1].known_for[2] and (tab.results[1].known_for[2].title or tab.results[1].known_for[2].name) then
	known_for = known_for .. ', ' .. (tab.results[1].known_for[2].title or tab.results[1].known_for[2].name)
	end
	if tab.results[1].known_for[3] and (tab.results[1].known_for[3].title or tab.results[1].known_for[3].name) then
	known_for = known_for .. ', ' .. (tab.results[1].known_for[3].title or tab.results[1].known_for[3].name)
	end
	else
	known_for = ''
	end

	return poster, rus, department .. known_for
	end

	local function infodesc_rezka(adr1)
		local rc3,answeradr = m_simpleTV.Http.Request(session,{url=adr1})
		if rc3~=200 then
			m_simpleTV.Http.Close(session)
		return ''
		end
		overview = answeradr:match('"og:description" content="(.-)"%s*/>') or ''
		return overview
	end

	local function GetPersonTable(inAdr3)

	local rc1, answer = m_simpleTV.Http.Request(session, {url = inAdr3})
		if rc1 ~= 200 then
			m_simpleTV.Http.Close(session)
		 return
		end

	answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')

	local titlel = answer:match('<h1 itemprop="name">([^<]+)') or 'HDrezka'
	local year = answer:match('/year/.-">(%d%d%d%d)') or 0
	titlel = titlel:gsub(' /.-$','') .. ' (' .. year .. ')'
	local poster = answer:match('"og:image" content="([^"]+)') or 'https://static.hdrezka.ac/templates/hdrezka/images/avatar.png'

	if answer:match('<span class="b%-post__info_rates imdb"><a href="/help/.-" target="_blank" rel="nofollow">IMDb</a>') then
	imdb_id = answer:match('<span class="b%-post__info_rates imdb"><a href="/help/(.-)/"')
	imdb_id = decode64(imdb_id)
	if imdb_id then
	imdb_id = imdb_id:gsub('%%3A', ':'):gsub('%%2F', '/')
	imdb_id = imdb_id:match('imdb%.com/title/(tt.-)/.-$')
	tmdb_background = bg_imdb_id(imdb_id)
	poster = tmdb_background
	end
	else tmdb_background = '' imdb_id = '' poisk_tmdb = '' end

	if m_simpleTV.Control.MainMode == 0 then
	if tmdb_background == '' then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = poster, TypeBackColor = 0, UseLogo = 3, Once = 1})
	else
		poster = tmdb_background
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = tmdb_background, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	end

	local i, t = 1, {}

	for w in answer:gmatch('<span class="person%-name%-item".-</span>') do
	local person_work, person_adr, person = w:match('itemprop="(.-)".-<a href="(.-)".-itemprop="name">(.-)</span>')

	if not person or not person_adr or not person_work then break end
	t[i] = {}
	t[i].Id = i
	t[i].Name = person:gsub('&laquo;',''):gsub('&raquo;','') .. ' (' .. person_work .. ')'
	t[i].Address = person_adr
	t[i].InfoPanelLogo,t[i].InfoPanelName,t[i].InfoPanelTitle = findpersonIdByName(person)
	if t[i].InfoPanelName and t[i].InfoPanelName ~= '' then
	t[i].InfoPanelName = person:gsub('&laquo;',''):gsub('&raquo;','') .. ' (' .. t[i].InfoPanelName .. ')' .. ' - ' .. person_work
	end
	t[i].InfoPanelShowTime = 30000
	i=i+1
	end

	return titlel, poster, t, i-1
	end

	local function GetPersonWork(inAdr2)

	local urld2 = inAdr2
	local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
	if rc2~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	answerd2 = answerd2:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local title = answerd2:match('<h1><span class="t1" itemprop="name">(.-)</span>')
	local poster = answerd2:match('<ul class="b%-person__gallery_list"> <li><a href="(.-)"') or answerd2:match('<meta property="og:image" content="(.-)"') or 'https://hdrezka.by/themes/default/public/mobile/logo.png'
	local poster1 = answerd2:match('<meta property="og:image" content="(.-)"') or 'https://hdrezka.by/themes/default/public/mobile/logo.png'
	local uselogo = 3
	if poster:match('/i/share%.jpg') then poster = 'https://hdrezka.by/themes/default/public/mobile/logo.png' uselogo = 1 end
	if poster1:match('/i/share%.jpg') then poster1 = 'https://hdrezka.by/themes/default/public/mobile/logo.png' end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = poster, TypeBackColor = 0, UseLogo = uselogo, Once = 1})
	end
	local t, i = {}, 1
	for w in answerd2:gmatch('<div class="b%-content__inline_item.-</div> </div></div>') do

	local logo, group, adr, name, title = w:match('<img src="(.-)".-<span class="(.-)".-<a href="(.-)">(.-)</a> <div class="misc">(.-)<')

	if not adr or not name then break end
	t[i] = {}
	t[i].Id = i
	t[i].Name = name .. ' (' .. title .. ') - ' .. group:gsub('cat ','')
	t[i].Address = adr
	t[i].InfoPanelLogo = logo
	t[i].InfoPanelName = 'Rezka info: ' .. name .. ' (' .. title .. ')'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = bg_poster_title(name, title:match('%d%d%d%d'))
	i=i+1
	end

	return t, title, poster1, i-1
	end

	local function find_rezka(rezka_search,con)

	local zerkalo = m_simpleTV.Config.GetValue('zerkalo/rezka',"LiteConf.ini") or ''
	if zerkalo == '' then
	zerkalo = 'https://rezka.ag/'
	end
		local function infodesc_rezka(adr1)
		local rc3,answeradr = m_simpleTV.Http.Request(session,{url=adr1})
		if rc3~=200 then
			m_simpleTV.Http.Close(session)
		return
		end
		overview = answeradr:match('"og:description" content="(.-)"%s*/>') or ''
		return overview
		end

	local urld2 = zerkalo .. 'search?do=search&subaction=search&q=' .. m_simpleTV.Common.toPercentEncoding(rezka_search:gsub('%-',' '))
	local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
	if rc2~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	if not answerd2:match('<div class="b%-content__inline_item".-</div> </div></div>')then
	rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
	if rc2~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	end
	answerd2 = answerd2:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local t, i = {}, 1
	for w in answerd2:gmatch('<div class="b%-content__inline_item".-</div> </div></div>') do

	local logo, group, adr, name, title = w:match('<img src="(.-)".-<i class="entity">(.-)</i>.-<a href="(.-)">(.-)</a> <div>(.-)<')

	if not adr or not name then break end

	if tonumber(con) == 1 and group == 'Фильм'
	or tonumber(con) == 2 and group == 'Сериал'
	or tonumber(con) == 3 and group == 'Мультфильм'
	or tonumber(con) == 4 and group == 'Аниме'
	then

	t[i] = {}
	t[i].Id = i
	t[i].Name = name .. ' (' .. title .. ')'
	t[i].Address = adr
	t[i].InfoPanelLogo = logo
	t[i].InfoPanelName = 'Rezka info: ' .. name .. ' (' .. title .. ')'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = infodesc_rezka(t[i].Address)

	i = i + 1
	end
	end
	return t, i-1
	end

	rezka_search = inAdr:match('^#(.-)$')
	local logo='https://static.hdrezka.ac/templates/hdrezka/images/avatar.png'
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = 'https://hdrezka.by/themes/default/public/mobile/logo.png', TypeBackColor = 0, UseLogo = 1, Once = 1})
		m_simpleTV.Control.ChangeChannelLogo(logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	end

	if not inAdr:match('^#http') then

	rezka_search = m_simpleTV.Common.multiByteToUTF8(rezka_search,1251)

		if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelName('Search Rezka: ' .. m_simpleTV.Common.multiByteToUTF8(inAdr:gsub('^#',''),1251), m_simpleTV.Control.ChannelID, false)
		end

	m_simpleTV.Control.SetTitle('Search Rezka: ' .. m_simpleTV.Common.multiByteToUTF8(inAdr:gsub('^#',''),1251))

	local t1, nm1 = find_rezka(rezka_search,1)
	local t2, nm2 = find_rezka(rezka_search,2)
	local t3, nm3 = find_rezka(rezka_search,3)
	local t4, nm5 = find_rezka(rezka_search,4)
	local retAdr = ''

	local tt = {
	{"Фильмы","","./luaScr/user/show_mi/films2.png",""},
	{"Сериалы","","./luaScr/user/show_mi/serials2.png",""},
	{"Мультфильмы","","./luaScr/user/show_mi/mult2.png",""},
	{"Аниме","","./luaScr/user/show_mi/anime2.png",""},
	}
		if not t1 or not t2 or not t3 or not t4 then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
	local t={}
  for i=1,#tt do
    t[i] = {}
    t[i].Id = i
	if i == 1 then
    t[i].Name = tt[i][1] .. ' (' .. nm1 .. ')'
	elseif i == 2 then
    t[i].Name = tt[i][1] .. ' (' .. nm2 .. ')'
	elseif i == 3 then
    t[i].Name = tt[i][1] .. ' (' .. nm3 .. ')'
	elseif i == 4 then
    t[i].Name = tt[i][1] .. ' (' .. nm5 .. ')'
	end
    t[i].Action = tt[i][2]
	t[i].InfoPanelLogo = tt[i][3]
	t[i].InfoPanelTitle = tt[i][4]
	t[i].InfoPanelShowTime = 12000
  end
	t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 Filmix '}
	t.ExtButton0 = {ButtonEnable = true, ButtonName = '🔎 TMDb '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 Выберите категорию поиска: ' .. rezka_search,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr:gsub('^#','=')
		end
		if ret == 3 then
		retAdr = inAdr:gsub('^#','?')
		end
  if ret == 1 then

	if id == 1 then

	t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 фильмы: ' .. rezka_search, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		m_simpleTV.Control.CurrentTitle_UTF8 = t1[id].Name
		m_simpleTV.Control.ChangeChannelLogo(t1[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		retAdr = t1[id].Address
	end

	elseif id == 2 then

	t2.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t2.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 сериалы: ' .. rezka_search, 0, t2, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		m_simpleTV.Control.CurrentTitle_UTF8 = t2[id].Name
		m_simpleTV.Control.ChangeChannelLogo(t2[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		retAdr = t2[id].Address
	end

	elseif id == 3 then

	t3.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t3.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 мультфильмы: ' .. rezka_search, 0, t3, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		m_simpleTV.Control.CurrentTitle_UTF8 = t3[id].Name
		m_simpleTV.Control.ChangeChannelLogo(t3[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		retAdr = t3[id].Address
	end

	elseif id == 4 then

	t4.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t4.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 аниме: ' .. rezka_search, 0, t4, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		m_simpleTV.Control.CurrentTitle_UTF8 = t4[id].Name
		m_simpleTV.Control.ChangeChannelLogo(t4[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		retAdr = t4[id].Address
	end
	end
	end
	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = retAdr
	dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\video\\video.lua')

	elseif inAdr:match('^#https') and not inAdr:match('/person/') then

	local title1, poster, t1, nm1 = GetPersonTable(inAdr:gsub('^#',''))
		if not t1 or not title1 or not nm1 then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)

--		 return
		end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelName('Персоны: ' .. title1, m_simpleTV.Control.ChannelID, false)
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	end
	t1.ExtButton1 = {ButtonEnable = true, ButtonName = 'Play'}
	t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 персоны: ' .. title1, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
		GetTranslate(rezka_search)
--			m_simpleTV.Control.ExecuteAction(37)
--			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		m_simpleTV.Control.CurrentTitle_UTF8 = t1[id].Name
		local t1id = id
		local t2 = GetPersonWork(t1[id].Address)
		if t2 ~= '' then
		local hash, res = {}, {}
		for i = 1, #t2 do
			t2[i].Address = tostring(t2[i].Address)
			if not hash[t2[i].Address] then
				res[#res + 1] = t2[i]
				hash[t2[i].Address] = true
			end
		end
			local AutoNumberFormat, FilterType
			if #res > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		--	id=id or 1
		res.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		res.ExtButton1 = {ButtonEnable = true, ButtonName = '💾'}
		res.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 ' .. t1[id].Name, 0, res, 30000, 1 + 4 + 8 + 2)
	if ret == 3 then
		setConfigVal('person/rezka',t1[t1id].Address)
		UpdatePersonRezka()
		retAdr = inAdr
	end
	if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		m_simpleTV.Control.CurrentTitle_UTF8 = res[id].Name
		m_simpleTV.Control.ChangeChannelLogo(res[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		retAdr = res[id].Address
	end

	end
	end
	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = retAdr
	dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\video\\video.lua')
	-- debug_in_file(retAdr .. '\n')
	elseif inAdr:match('^#http') and inAdr:match('/person/') then

		local t2, title, poster1, nm2 = GetPersonWork(rezka_search)
		if not t2 or not title then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
--		 return
		end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelName(title, m_simpleTV.Control.ChannelID, false)
		m_simpleTV.Control.ChangeChannelLogo(poster1, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	end
		m_simpleTV.Control.CurrentTitle_UTF8 = title
		if t2 ~= '' then
		local hash, res = {}, {}
		for i = 1, #t2 do
			t2[i].Address = tostring(t2[i].Address)
			if not hash[t2[i].Address] then
				res[#res + 1] = t2[i]
				hash[t2[i].Address] = true
			end
		end
			local AutoNumberFormat, FilterType
			if #res > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end

		res.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}

	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 ' .. title .. ' (' .. nm2 .. ')', 0, res, 30000, 1 + 4 + 8 + 2)

	if ret == 1 then
--		m_simpleTV.Control.CurrentTitle_UTF8 = res[id].Name
--		m_simpleTV.Control.ChangeChannelLogo(res[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		retAdr = res[id].Address
	end
	if ret == -1 or not id then
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.Control.ExecuteAction(11)
	 return
	end
	end

	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = retAdr
	m_simpleTV.Control.PlayAddress(retAdr)
--	dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\video\\video.lua')
	-- debug_in_file(retAdr .. '\n')
	end
