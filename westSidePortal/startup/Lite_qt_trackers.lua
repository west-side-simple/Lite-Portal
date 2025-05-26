-- Плагин для трекеров lite portal 19.04.25
-- author west_side

function start_page()
		stena_clear()
		local last_adr = m_simpleTV.Config.GetValue('info/torrent','LiteConf.ini') or ''
		local tt = {
		{"","👀 Буду смотреть"},
		{"http://api.vokino.tv/v2/list?sort=popular&page=1","В тренде"},
		{"http://api.vokino.tv/v2/list?sort=updatings&page=1","Обновления"},
		{"http://api.vokino.tv/v2/list?sort=new&type=movie&page=1","Новинки фильмов"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=movie&page=1","Фильмы"},
		{"http://api.vokino.tv/v2/list?sort=new&type=serial&page=1","Новинки сериалов"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=serial&page=1","Сериалы"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=multfilm&page=1","Мультфильмы"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=multserial&page=1","Мультсериалы"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=documovie&page=1","Документальные фильмы"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=docuserial&page=1","Документальные сериалы"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=anime&page=1","Аниме"},
		{"http://api.vokino.tv/v2/list?sort=popular&type=tvshow&page=1","ТВ Шоу"},
		{"http://api.vokino.tv/v2/compilations/list?page=","💼 Подборки"},
		{"http://api.vokino.tv/v2/v4k?type=2160p.HDR&page=1","💲 4K HDR - Filmix PRO account"},
		{"http://api.vokino.tv/v2/v4k?type=2160p&page=1","💲 4K - Filmix PRO account"},
		{"http://api.vokino.tv/v2/v4k?type=2160p.DolbyVision&page=1","💲 4K DolbyVision - Filmix PRO account"},
		{"http://api.vokino.tv/v2/v4k?type=60FPS&page=1","💲️ 60FPS - Filmix PRO account"},
		{"","🔎 ПОИСК"},
		}
		local t0={}
		for i=1,#tt do
			t0[i] = {}
			t0[i].Id = i
			t0[i].Name = tt[i][2]
			t0[i].Action = tt[i][1]
		end
		if last_adr and last_adr ~= '' then
		t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info '}
		end
		t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t0[id].Name == '🔎 ПОИСК' then
				search()
			elseif t0[id].Name == '💼 Подборки' then
				content_compilation_page(1)
			elseif t0[id].Name == '👀 Буду смотреть' then
				get_see()
			else
				content_adr_page(t0[id].Action)
			end
		end
		if ret == 2 then
		content(last_adr)
		end
		if ret == 3 then
		run_westSide_portal()
		end
end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,'LiteConf.ini')
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,'LiteConf.ini')
	end

	local function find_in_see(content_id)
		local recentAddress = getConfigVal('content_id/adr') or ''
		local t,i={},1
		for w in string.gmatch(recentAddress,"[^|]+") do
			t[i] = {}
			t[i].Address = w
			if w == content_id then
				return '✅ '
			end
			i=i+1
			end
		return ''
	end

	local function get_al_t_y(title, year)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 10000)
		local url = decode64('aHR0cHM6Ly9hcGkuYXBidWdhbGwub3JnLz90b2tlbj1kMzE3NDQxMzU5ZTUwNWMzNDNjMjA2M2VkYzk3ZTc=') .. '&name=' .. m_simpleTV.Common.toPercentEncoding(title) .. '&year=' .. year
		local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc~=200 then
			m_simpleTV.Http.Close(session)
			return false
		end
		answer = unescape1(answer)
		local id_imdb = answer:match('"id_imdb":"(tt.-)"')
	--	debug_in_file(title .. ' ' .. year .. '\n' .. answer .. '\n','c://1/content.txt')
		if id_imdb then
	--	debug_in_file( 'id_imdb=' .. id_imdb .. '\n', 'c://1/content.txt')
		return id_imdb
		end
		return false
	end
--------------------------------------
function get_see()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,'LiteConf.ini')
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,'LiteConf.ini')
	end

-- wafee code for history

    local recentName = getConfigVal('content_id/title') or ''
    local recentAddress = getConfigVal('content_id/adr') or ''
	local recentLogo = getConfigVal('content_id/logo') or ''

     local t,i={},1

   if recentName~='' and recentLogo~='' and recentAddress~='' and recentIndex~='' then
     for w in string.gmatch(recentName,"[^|]+") do
       t[i] = {}
       t[i].Id = i
       t[i].Name = w
	   t[i].InfoPanelName = w
	   t[i].InfoPanelShowTime = 10000
       i=i+1
     end
     i=1
     for w in string.gmatch(recentAddress,"[^|]+") do
       t[i].Address = w
       i=i+1
     end
	 i=1
     for w in string.gmatch(recentLogo,"[^|]+") do
       t[i].InfoPanelLogo = w
       i=i+1
     end
   end
   t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🧲 Трекеры '}
   t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🗑 Cleane '}
   local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('👀 Буду смотреть',0,t,9000,1+4+8)
   if id==nil then
   run_westSide_portal()
   end
   if ret==1 then
      content(t[id].Address)
   end
   if ret==2 then
	  start_page()
   end
   if ret==3 then
      setConfigVal('content_id/title','')
	  setConfigVal('content_id/logo','')
	  setConfigVal('content_id/adr','')
	  start_page()
   end
   end

--------------------------------------
function add_to_see(adr,title,logo)

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,'LiteConf.ini')
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,'LiteConf.ini')
	end

-- wafee code for history
	local cur_max
	local max_history = m_simpleTV.Config.GetValue('openFrom/maxRecentItem','simpleTVConfig') or 15
    local recentName = getConfigVal('content_id/title') or ''
    local recentAddress = getConfigVal('content_id/adr') or ''
	local recentLogo = getConfigVal('content_id/logo') or ''
     local t={}
     local tt={}
     local i=2
	 t[1] = {}
     t[1].Id = 1
     t[1].Name = title
	 t[1].Address = adr
	 t[1].Logo = logo
   if recentName~='' and recentLogo~='' and recentAddress~='' then

     for w in string.gmatch(recentName,"[^|]+") do
       t[i] = {}
       t[i].Id = i
       t[i].Name = w
       i=i+1
     end
     i=2
     for w in string.gmatch(recentAddress,"[^|]+") do
       t[i].Address = w
       i=i+1
     end
	 i=2
     for w in string.gmatch(recentLogo,"[^|]+") do
       t[i].Logo = w
       i=i+1
     end

     local function isExistAdr()
       for i=2,#t do
         if adr==t[i].Address then
           return true, i
         end
       end
       return false
     end

     local isExist,i=isExistAdr()
     if isExist then
       table.remove(t,i)
	   table.remove(t,1)
     end

     recentName=''
     recentAddress = ''
     recentLogo = ''

	 if #t <= tonumber(max_history) then
		cur_max = #t
	 else
		cur_max = tonumber(max_history)
	 end

     for i=1,cur_max  do
      local name = t[i].Name
      recentName = recentName .. name .. '|'
      recentAddress = recentAddress .. t[i].Address .. '|'
	  recentLogo = recentLogo .. t[i].Logo .. '|'
      t[i].Id = i
--      debug_in_file('fromOSDmenu = ' .. t[i].Id .. ' ' .. t[i].Name .. ' ' .. t[i].Address .. '\n','c://1/cid.txt')
     end

	 setConfigVal('content_id/title',recentName)
	 setConfigVal('content_id/logo',recentLogo)
	 setConfigVal('content_id/adr',recentAddress)

	 else

	 setConfigVal('content_id/title',title .. '|')
	 setConfigVal('content_id/logo',logo .. '|')
	 setConfigVal('content_id/adr',adr .. '|')

   end
end

--------------------------------------
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
				{'У', 'у'}, {'Ы', 'ы'}, {':', ''}
				}
			for _, v in pairs(a) do
				s = s:gsub(v[1], v[2])
			end
	 return s
end

local function get_hdvb(title, year)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly92YjE3MTIzZmlsaXBwYWFuaWtldG9zLnB3L2FwaS92aWRlb3MuanNvbj90b2tlbj1jOTk2NmI5NDdkYTJmM2MyOWIzMGMwZTBkY2NhNmNmNCZ0aXRsZT0=') .. m_simpleTV.Common.toPercentEncoding(title)
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	answer = unescape1(answer)
--	debug_in_file(title .. ' ' .. year .. '\n' .. answer .. '\n','c://1/content.txt')
	local t = {}
		for ru_title, en_title, in_year, kp_id, tr, url in answer:gmatch('"title_ru":"(.-)".-"title_en":"(.-)".-"year":(%d%d%d%d).-"kinopoisk_id":(%d+).-"translator":"(.-)".-"iframe_url":"(.-)"') do
			if (ru_title and ru_title == title or en_title and en_title == title) and tonumber(in_year) == tonumber(year) then
				t[#t + 1] = {}
				t[#t].Id = #t
				t[#t].Address = url:gsub('\\','')
				t[#t].Name = tr
				t[#t].kp_id = kp_id
--	debug_in_file(tr .. ' ' .. url:gsub('\\','') .. '\n','c://1/content.txt')
			end
		end
	if #t ~= 0 then
--	debug_in_file( 'kp_id=' .. t[1].kp_id .. '\n', 'c://1/content.txt', setnew )
	return t, t[1].kp_id
	end
	return false
end

local function get_bazon(title, year)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly9iYXpvbi5jYy9hcGkvc2VhcmNoP3Rva2VuPTRmNmFkZGQ1MzI3YWNkZDc2OTY5Yzk3Nzk5NTM1YjE0JnRpdGxlPQ==') .. m_simpleTV.Common.toPercentEncoding(title)
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	require('json')
	answer = answer:gsub('%[%]', '"nil"'):gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/')
	local tab = json.decode(answer)
	if not tab or not tab.results then
		return false
	end
	local j = 1
	while true do
		if not tab.results[j]
		then
		break
		end
		if tab.results[j].kinopoisk_id and (tab.results[j].info and tab.results[j].info.year and math.abs( tonumber(tab.results[j].info.year) - tonumber(year) ) <= 1 and tab.results[j].info.rus and ( xren(tab.results[j].info.rus):gsub('&nbsp;', ' '):gsub('&#151;', '-'):gsub(':', ' '):gsub('%.', ' '):gsub('%-', ' '):gsub('  ', ' ') == xren(title):gsub(':', ' '):gsub('%.', ' '):gsub('%-', ' '):gsub('  ', ' ') or xren(tab.results[j].info.orig):gsub('&nbsp;', ' '):gsub('&#151;', '-'):gsub(':', ' '):gsub('%.', ' '):gsub('%-', ' '):gsub('  ', ' ') == xren(title):gsub(':', ' '):gsub('%.', ' '):gsub('%-', ' '):gsub('  ', ' '))) then
			return tab.results[j].kinopoisk_id
		end
		j = j + 1
	end
	return false
end

local function get_cdnmovies(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly9jZG5tb3ZpZXMtc3RyZWFtLm9ubGluZS9raW5vcG9pc2sv') .. kp_id .. '/iframe'
	local rc,answer = m_simpleTV.Http.Request(session,{url=url, headers = 'Referer: https://cdnmovies.net/'})
	if rc ~= 200 or (rc == 200 and not answer:match('#2')) then
		m_simpleTV.Http.Close(session)
		return false
	end
	answer = answer:gsub('\\','')
--	debug_in_file( answer .. '\n', 'c://1/cdnmovies.txt', setnew )
	return url
end

local function get_kodik(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cDovL2tvZGlrYXBpLmNvbS9nZXQtcGxheWVyP3Rva2VuPTQ0N2QxNzllODc1ZWZlNDQyMTdmMjBkMWVlMjE0NmJlJmtpbm9wb2lza0lEPQ') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	if answer:match('"link":"([^"]+)') then
		return answer:match('"link":"([^"]+)')
	end
	return false
end

local function get_voidboost(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly92b2lkYm9vc3QubmV0L2VtYmVkLw') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	return url
end

local function get_collaps(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'https://api' .. os.time() .. decode64('LnN5bmNocm9uY29kZS5jb20vZW1iZWQva3Av') .. kp_id
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, headers = 'Referer: api.synchroncode.com'})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	if answer:match('embedHost') then
		 return url
	end
	return false
end

local function get_zetflix(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly9oZGkuemV0ZmxpeC5vbmxpbmUvaXBsYXllci92aWRlb2RiLnBocD9rcD0=') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'get', headers = 'User-agent: Mozilla/5.0 (Windows NT 10.0; rv:97.0) Gecko/20100101 Firefox/97.0\nReferer: https://hdi.zetflix.online/iplayer/player.php'})
	if rc~=200 or answer:match('video_not_found') then
		m_simpleTV.Http.Close(session)
		return false
	end
	return url
end

local function get_videocdn(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = decode64('aHR0cHM6Ly84MjA5LnN2ZXRhY2RuLmluL1BYazJRR2J2RVZtUz9rcF9pZD0') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'get', headers = 'User-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36\nReferer: https://www.videocdn.tv/'})
	if rc~=200 or answer:match('video_not_found') then
		m_simpleTV.Http.Close(session)
		return false
	end
	return url
end

local function check(url)

	local token = decode64('d2luZG93c18zZWZlMGUyZDg5ZTQ3NzVhYWFjMTBiMGMxYjU0YTU3MF81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local rc,answer = m_simpleTV.Http.Request(session,{url=url .. '&token=' .. token})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return false
	end
	if answer and answer:match('"ident":".-"%,"stream_url":".-"') and answer:match('"stream_url":"(.-)"')~='' then
		if m_simpleTV.User.torrent.seria_id and answer:match('"ident":"' .. m_simpleTV.User.torrent.seria_id .. '"%,"stream_url":".-"') then
			m_simpleTV.User.torrent.is_set_position = true
			return 'content_id=' .. m_simpleTV.User.torrent.seria_id .. '&balanser=seriahd&' .. answer:match('"ident":"' .. m_simpleTV.User.torrent.seria_id .. '"%,"stream_url":"(.-)"'):gsub('\\','')
		end
		m_simpleTV.User.torrent.is_set_position = false
		return 'content_id=' .. answer:match('"ident":"(.-)"') .. '&balanser=seriahd&' .. answer:match('"stream_url":"(.-)"'):gsub('\\','')
	end
	if answer and answer:match('"stream_url":".-".-%,"ident":".-"') and answer:match('"stream_url":"(.-)"')~='' then
		if m_simpleTV.User.torrent.seria_id and answer:match('"stream_url":".-".-%,"ident":"' .. m_simpleTV.User.torrent.seria_id .. '"') then
			m_simpleTV.User.torrent.is_set_position = true
			return 'content_id=' .. m_simpleTV.User.torrent.seria_id .. '&balanser=videocdn&' .. answer:match('"stream_url":"(.-)".-%,"ident":"' .. m_simpleTV.User.torrent.seria_id .. '"'):gsub('\\','')
		end
		m_simpleTV.User.torrent.is_set_position = false
		return 'content_id=' .. answer:match('"ident":"(.-)"') .. '&balanser=videocdn&' .. answer:match('"stream_url":"(.-)"'):gsub('\\','')
	end
	if answer and answer:match('"stream_url":"(.-)"') and answer:match('"stream_url":"(.-)"')~='' then
		if m_simpleTV.User.torrent.content and answer:match('"ident":"' .. m_simpleTV.User.torrent.content .. '"') then
			m_simpleTV.User.torrent.is_set_position = true
		else
			m_simpleTV.User.torrent.is_set_position = false
		end
		return answer:match('"stream_url":"(.-)"'):gsub('\\','')
	end
	return false
end

function content_compilation_page(page)
	local token = decode64('d2luZG93c18zZWZlMGUyZDg5ZTQ3NzVhYWFjMTBiMGMxYjU0YTU3MF81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'http://api.vokino.tv/v2/compilations/list?page='
	.. page .. '&token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id or not tab.channels[1].details.name
	then
	return end
	m_simpleTV.Http.Close(session)
	local title = tab.title
	local t, i = {}, 1
	while true do
	if not tab.channels[i]
				then
				break
				end
	t[i]={}
	local id = tab.channels[i].details.id
	local name = tab.channels[i].details.name
	local poster = tab.channels[i].details.poster
	t[i].Id = i
	t[i].Name = name
	t[i].InfoPanelLogo = poster
	t[i].Address = id
	t[i].InfoPanelName = name
    i=i+1
	end
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = title .. ' (стр. ' .. page .. ')'
		if next_pg <= 36 then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg > 0 then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
		else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
		end

		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		content_compilation(t[id].Address)
		end
		if ret == 2 then
		if tonumber(prev_pg) > 0 then
		content_compilation_page(tonumber(page)-1)
		else
		start_page()
		end
		end
		if ret == 3 then
		content_compilation_page(tonumber(page)+1)
		end
end

function content_compilation(list_id)
	local token = decode64('d2luZG93c18zZWZlMGUyZDg5ZTQ3NzVhYWFjMTBiMGMxYjU0YTU3MF81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'http://api.vokino.tv/v2/compilations/content/'	.. list_id
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id or not tab.channels[1].details.name
	then
	return end
	m_simpleTV.Http.Close(session)
	local title = tab.title
	local t, i = {}, 1
	while true do
	if not tab.channels[i]
				then
				break
				end
	t[i]={}
	local id = tab.channels[i].details.id
	local name = tab.channels[i].details.name
	local poster = tab.channels[i].details.poster
	local originalname = tab.channels[i].details.originalname
	local released = tab.channels[i].details.released
	local about = tab.channels[i].details.about
	local genre = tab.channels[i].details.genre
	local type = tab.channels[i].details.type
	t[i].Id = i
	t[i].Name = find_in_see(id) .. name .. ' (' .. released .. ') - ' .. type
	t[i].InfoPanelLogo = poster
	t[i].Address = id
	t[i].InfoPanelName = name .. ' / ' .. originalname .. ' (' .. released .. ') ' .. genre
	t[i].InfoPanelTitle = about
    i=i+1
	end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = 'Подборки '}
		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		content(t[id].Address)
		end
		if ret == 2 then
		content_compilation_page(1)
		end
end

function content(content_id)
	local token = decode64('d2luZG93c18zZWZlMGUyZDg5ZTQ3NzVhYWFjMTBiMGMxYjU0YTU3MF81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'http://api.vokino.tv/v2/view/'	.. content_id .. '?token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
	if rc~=200 or answer and answer:match('"success":false') then
		m_simpleTV.Http.Close(session)
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/liteportal.png"', text = 'Медиаконтент недоступен', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		start_page()
		return
	end
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.torrent then
		m_simpleTV.User.torrent = {}
	end
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
	else tooltip_body = 'bgcolor="#182633"'
	end
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.details or not tab.details.id or not tab.details.name
	then
	return end
	m_simpleTV.Http.Close(session)
	local id = tab.details.id
	local name = tab.details.name
	local poster = tab.details.poster
	local background = tab.details.bg_poster.backdrop
	if poster then poster = poster:gsub('w600_and_h900','w300_and_h450')
		else poster = m_simpleTV.MainScriptDir .. 'user/westSide/icons/liteportal.png'
	end
	if background then background = background:gsub('original','w500')
		else background = m_simpleTV.MainScriptDir .. 'user/westSide/icons/liteportal.png'
	end
	local originalname = tab.details.originalname or ''
	local released = tab.details.released or ''
	local duration = tab.details.duration or ''
	local director = tab.details.director or ''
	local country = tab.details.country or ''
	local about = tab.details.about or ''
	local genre = tab.details.genre or ''
	local age = tab.details.age or 0
	local rating_kp = tab.details.rating_kp or 0
	local rating_imdb = tab.details.rating_imdb or 0
	local tag = ''
	local is_tv = tab.details.is_tv
	if tab.details.tags and tab.details.tags[1] then
		tag = ', ' .. tab.details.tags[1]
	end
	if tab.details.tags and tab.details.tags[2] then
		tag = tag .. ', ' .. tab.details.tags[2]
	end
	local videodesc= '<table width="100%" border="0"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="300"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h4><font color=#00FA9A>' .. name .. '</font></h4><h5><font color=#BBBBBB>' .. originalname .. '</font></h5><h5><font color=#EBEBEB>' ..  country .. ' • </font><font color=#E0FFFF>' .. released .. '</font></h5><h5><font color=#EBEBEB>' .. genre .. '</font> • ' .. age .. '+</h5><h5>Кинопоиск: ' .. rating_kp .. ', IMDB: ' .. rating_imdb .. '</h5><h5><font color=#E0FFFF>' .. duration .. '</font></h5><h5>Режиссеры: <font color=#EBEBEB>' .. director .. '</font></h5><h5><font color=#EBEBEB>' .. about .. '</font></h5></td></tr></table>'
	videodesc = videodesc:gsub('"', '\"')
	local title = name:gsub(' $','') .. ' (' .. released .. ')'
		local t,j={},2
		t[1] = {}
		t[1].Id = 1
		t[1].Address = content_id
		t[1].Name = find_in_see(content_id) .. '.: info :.'
		t[1].InfoPanelLogo = background
		t[1].InfoPanelName =  name .. ' / ' .. originalname .. ' (' .. released .. ') ' .. genre
		t[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
		t[1].InfoPanelTitle = about
		t[1].InfoPanelShowTime = 10000

		local imdb_id = get_al_t_y(name, released)

		if imdb_id then
			t[j] = {}
			t[j].Id = j
			t[j].Name = 'Online: IMDB'
			t[j].Address = 'https://www.imdb.com/title/' .. imdb_id
			j=j+1
		end

--[[		local hdvb, kp_id = get_hdvb(name, released)
		if hdvb~=false then
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: HDVB'
		t[j].Address = hdvb
		j=j+1
		end

		if not kp_id then
			kp_id = get_bazon(name, released)
		end

		if kp_id then
		local cdnmovies = get_cdnmovies(kp_id)
		if cdnmovies~=false then
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: CDN Movies'
		t[j].Address = cdnmovies
		j=j+1
		end
		end

		if kp_id then
		local zetflix = get_zetflix(kp_id)
		if zetflix~=false then
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: ZF'
		t[j].Address = zetflix
		j=j+1
		end
		end

		if kp_id then
		local videocdn = get_videocdn(kp_id)
		if videocdn~=false then
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: VideoCDN'
		t[j].Address = videocdn
		j=j+1
		end
		end

		if kp_id then
		local kodik = get_kodik(kp_id)
		if kodik~=false then
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: Kodik'
		t[j].Address = kodik:gsub('^//', 'http://')
		j=j+1
		end
		end

		if kp_id then
		local voidboost = get_voidboost(kp_id)
		if voidboost~=false then
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: VB'
		t[j].Address = voidboost
		j=j+1
		end
		end

		if kp_id then
		local collaps = get_collaps(kp_id)
		if collaps~=false then
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: Collaps'
		t[j].Address = collaps:gsub('^//', 'http://')
		j=j+1
		end
		end

		if not kp_id and tab.online and tab.online.VideoCDN then
		local check = check(tab.online.VideoCDN)
		if check and check~=false then
		if is_tv == false and m_simpleTV.User.torrent.content and m_simpleTV.User.torrent.content == content_id then
			m_simpleTV.User.torrent.is_set_position = true
		end
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: VideoCDN'
		t[j].Address = check
		j=j+1
		end
		end

		if not kp_id and tab.online and tab.online.Collaps then
		local check = check(tab.online.Collaps)
		if check and check~=false then
		if m_simpleTV.User.torrent.content and m_simpleTV.User.torrent.content == content_id then
			m_simpleTV.User.torrent.is_set_position = true
		end
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: Collaps'
		t[j].Address = check
		j=j+1
		end
		end

		if not kp_id and tab.online and tab.online.SeriaHD then
		local check = check(tab.online.SeriaHD)
		if check and check~=false then
		t[j] = {}
		t[j].Id = j
		t[j].Name = 'Online: SeriaHD'
		t[j].Address = check
		j=j+1
		end
		end--]]

		t[j] = {}
		t[j].Id = j
		t[j].Name = '🔎 TMDB'
		j=j+1

--		if tab.online and tab.online.KP then
		t[j] = {}
		t[j].Id = j
		t[j].Name = '🔎 Kinopub' .. tag
		j=j+1
--		end

--		if tab.online and tab.online.Filmix then
		t[j] = {}
		t[j].Id = j
		t[j].Name = '🔎 Filmix' .. tag
		j=j+1
--		end

--		if tab.online and tab.online.HDRezka then
		t[j] = {}
		t[j].Id = j
		t[j].Name = '🔎 HDRezka'
		j=j+1
--		end

		if tab.countrys and tab.countrys[1] then
		local i = 1
		while true do
		if not tab.countrys[i]
		then
		break
		end
		t[j] = {}
		t[j].Id = j
		t[j].Address = tab.countrys[i].playlist_url
		t[j].Name = tab.countrys[i].title
		i=i+1
		j=j+1
		end
		end

		if tab.genres and tab.genres[1] then
		local k = 1
		while true do
		if not tab.genres[k]
		then
		break
		end
		if not tab.genres[k].playlist_url:match('%+') then
		t[j] = {}
		t[j].Id = j
		t[j].Address = tab.genres[k].playlist_url
		t[j].Name = tab.genres[k].title
		end
		k=k+1
		j=j+1
		end
		end

		if tab.directors and tab.directors[1] then
		local m = 1
		while true do
		if not tab.directors[m]
		then
		break
		end
		t[j] = {}
		t[j].Id = j
		t[j].Address = tab.directors[m].playlist_url
		t[j].Name = 'Director: ' .. tab.directors[m].title
		m=m+1
		j=j+1
		end
		end

		if tab.casts and tab.casts[1] then
		local n = 1
		while true do
		if not tab.casts[n] or not tab.casts[n].title
		then
		break
		end
		t[j] = {}
		t[j].Id = j
		t[j].Address = tab.casts[n].playlist_url
		t[j].Name = 'Casts: ' .. tab.casts[n].title or ''
		t[j].InfoPanelLogo = tab.casts[n].poster or ''
		t[j].InfoPanelLogo = t[j].InfoPanelLogo:gsub('w600_and_h900_bestv2','w250_and_h141_face')
		t[j].InfoPanelName =  tab.casts[n].title .. ' (' ..  (tab.casts[n].birthday or 'not info') .. ') ' .. (tab.casts[n].place_of_birth or '')
		t[j].InfoPanelTitle = tab.casts[n].biography:gsub('\n',' ')
		t[j].InfoPanelShowTime = 10000
		n=n+1
		j=j+1
		end
		end

--[[		if tab.similars and tab.similars[1] and tab.similars[1].details and tab.similars[1].details.id then
		local o = 1
		while true do
		if not tab.similars[o]
		then
		break
		end
		t[j] = {}
		t[j].Id = j
		t[j].Address = tab.similars[o].details.id
		t[j].Name = 'Similar: ' .. find_in_see(tab.similars[o].details.id) .. tab.similars[o].details.name .. ' - ' .. tab.similars[o].details.type
		if not tab.similars[o].details.wide_poster or tab.similars[o].details.wide_poster == '' then
			t[j].InfoPanelLogo = tab.similars[o].details.poster
		else
			t[j].InfoPanelLogo = tab.similars[o].details.wide_poster
		end
		t[j].InfoPanelName =  tab.similars[o].details.name .. ' / ' .. tab.similars[o].details.originalname .. ' (' .. tab.similars[o].details.released .. ') ' .. (tab.similars[o].details.genre or '')
		t[j].InfoPanelTitle = tab.similars[o].details.about
		t[j].InfoPanelShowTime = 10000
		o=o+1
		j=j+1
		end
		end--]]

		t.ExtButton0 = {ButtonEnable = true, ButtonName = 'Главная 🎦'}
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '🧲 Трекеры'}
		local current_id = m_simpleTV.User.torrent.id_balanser or 1
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, tonumber(current_id) - 1, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		m_simpleTV.User.torrent.audio_id = nil
		if id == 1 then
			add_to_see(content_id,t[1].InfoPanelName,background)
			content(t[1].Address)
		end
		if t[id].Name:match('Similar: ') then
			content(t[id].Address)
		elseif t[id].Name:match('Collaps') and not kp_id then
			m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&balanser=collaps&' .. t[id].Address, title=title})
		elseif (t[id].Name:match('SeriaHD') or t[id].Name:match('VideoCDN')) and not kp_id then
			m_simpleTV.Control.PlayAddressT({address=t[id].Address, title=title})
		elseif t[id].Name:match('HDVB') then
		if is_tv == false and m_simpleTV.User.torrent.content and m_simpleTV.User.torrent.content == content_id then
			m_simpleTV.User.torrent.is_set_position = true
			local t1 = t[id].Address
--			debug_in_file(#t1 .. '\n','c://1/content.txt')
			if #t1 > 1 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔊 Озвучка', 0, t1, 10000, 1 + 4 + 8 + 2)
			id = id or 1
			if ret == 1 then
				if not m_simpleTV.User.hdvb then
					m_simpleTV.User.hdvb = {}
				end
				m_simpleTV.User.hdvb.transl_selected = true
				m_simpleTV.User.hdvb.transl_name = t1[id].Name
				m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t1[id].Address, title=title})
			end
			else
				m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t[id].Address[1].Address, title=title})
			end
		else
			m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t[id].Address[1].Address, title=title})
		end
		elseif t[id].Name:match('CDN Movies') then
			if is_tv == false and m_simpleTV.User.torrent.content and m_simpleTV.User.torrent.content == content_id then
				m_simpleTV.User.torrent.is_set_position = true
			end
			m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t[id].Address, title=title})
		elseif t[id].Name:match('ZF') then
			if is_tv == false and m_simpleTV.User.torrent.content and m_simpleTV.User.torrent.content == content_id then
				m_simpleTV.User.torrent.is_set_position = true
			end
			m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t[id].Address, title=title})
		elseif t[id].Name:match('IMDB') then
			if is_tv == false and m_simpleTV.User.torrent.content and m_simpleTV.User.torrent.content == content_id then
				m_simpleTV.User.torrent.is_set_position = true
			end
			m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t[id].Address, title=title})
		elseif t[id].Name:match('VideoCDN') and kp_id then
			if is_tv == false and m_simpleTV.User.torrent.content and m_simpleTV.User.torrent.content == content_id then
				m_simpleTV.User.torrent.is_set_position = true
			end
			m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t[id].Address, title=title})
		elseif t[id].Name:match('Kodik') then
			if is_tv == false and m_simpleTV.User.torrent.content and m_simpleTV.User.torrent.content == content_id then
				m_simpleTV.User.torrent.is_set_position = true
			end
			m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t[id].Address, title=title})
		elseif t[id].Name:match('VB') then
			if is_tv == false and m_simpleTV.User.torrent.content and m_simpleTV.User.torrent.content == content_id then
				m_simpleTV.User.torrent.is_set_position = true
			end
			m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t[id].Address, title=title})
		elseif t[id].Name:match('Collaps') then
			if is_tv == false and m_simpleTV.User.torrent.content and m_simpleTV.User.torrent.content == content_id then
				m_simpleTV.User.torrent.is_set_position = true
			end
			m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t[id].Address, title=title})
		elseif t[id].Name:match('TMDB') then
			m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(title),'LiteConf.ini')
			search_tmdb()
		elseif t[id].Name:match('Kinopub') then
			m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(title),'LiteConf.ini')
			local search_ini = m_simpleTV.Config.GetValue('search/media','LiteConf.ini') or ''
			show_select('https://kino.pub/item/search?query=' .. search_ini:gsub('%%28.-%%29',''))
		elseif t[id].Name:match('Filmix') then
			m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(title),'LiteConf.ini')
			search_filmix_media()
		elseif t[id].Name:match('HDRezka') then
			m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(title),'LiteConf.ini')
			search_rezka()
		else
		content_adr_page(t[id].Address)
		end
		end
		if ret == 2 then
		start_page()
		end
		if ret == 3 then
		if is_tv == false and m_simpleTV.User.torrent.content and m_simpleTV.User.torrent.content == content_id then
			m_simpleTV.User.torrent.is_set_position = true
		end
--		debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
		torrents(tab.torrents)
		end
end

function content_adr_page(adr)
	local token = decode64('d2luZG93c18zZWZlMGUyZDg5ZTQ3NzVhYWFjMTBiMGMxYjU0YTU3MF81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = adr .. '&token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id or not tab.channels[1].details.name
	then
	return end
	m_simpleTV.Http.Close(session)
	local title = tab.title or 'Media'
	local page = tab.page.current
	local t, i = {}, 1
	while true do
	if not tab.channels[i] or not tab.channels[i].details.id
				then
				break
				end
	t[i]={}
	local id = tab.channels[i].details.id or ''
	local name = tab.channels[i].details.name or 'noname'
	local poster = tab.channels[i].details.wide_poster or tab.channels[i].details.poster or ''
	local originalname = tab.channels[i].details.originalname or ''
	local released = tab.channels[i].details.released or ''
	local about = tab.channels[i].details.about or ''
	local genre = tab.channels[i].details.genre or ''
	local type = tab.channels[i].details.type or ''
	local address = tab.channels[i].playlist_url
	local tag = ''
	if tab.channels[i].details.tags and tab.channels[i].details.tags[1] then
		tag =  ', ' .. tab.channels[i].details.tags[1]
	end
	if tab.channels[i].details.tags and tab.channels[i].details.tags[2] then
		tag =  tag .. ', ' .. tab.channels[i].details.tags[2]
	end
	t[i].Id = i
	t[i].Name = find_in_see(id) .. name .. ' (' .. released .. ') - ' .. type .. tag
	t[i].InfoPanelLogo = poster
	t[i].Address = id
	t[i].InfoPanelName = name .. ' / ' .. originalname .. ' (' .. released .. ') ' .. genre
	t[i].InfoPanelTitle = about
    i=i+1
	end
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		title = title .. ' (стр. ' .. page .. ')'
		if next_pg <= 36 then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg > 0 then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
		else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
		end

		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		if t[id].Name == 'noname' then
			content_adr_page(adr)
		end
			content(t[id].Address)
		end
		if ret == 2 then
			if tonumber(prev_pg) > 0 then
				content_adr_page(adr:gsub('%&page=.-$','') .. '&page=' .. tonumber(page)-1) else
				start_page()
			end
		end
		if ret == 3 then
			content_adr_page(adr:gsub('%&page=.-$','') .. '&page=' .. tonumber(page)+1)
		end
end

function torrents(adr)
	local token = decode64('d2luZG93c18zZWZlMGUyZDg5ZTQ3NzVhYWFjMTBiMGMxYjU0YTU3MF81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url
	if adr:match('?') then url = adr:gsub('sorting=','sortings=') .. '&token=' .. token else url = adr .. '?token=' .. token end
--	local url = adr:gsub('sorting=','sortings=') .. '?token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	local content_id = adr:match('/torrents/(.-)$')
	if not tab or not tab.menu or not tab.menu[1] or not tab.menu[1].title or not tab.menu[1].submenu or not tab.menu[1].submenu[1] or not tab.menu[1].submenu[1].playlist_url
	then
	return end
	m_simpleTV.Http.Close(session)
	local title = tab.menu[1].title
	local current_id=1
	local t, i = {}, 1
	while true do
	if not tab.menu[1].submenu[i]
				then
				break
				end
	t[i]={}
	local name = tab.menu[1].submenu[i].title
	local address = tab.menu[1].submenu[i].playlist_url
	t[i].Id = i
	t[i].Name = tab.menu[1].submenu[i].title
	t[i].Address = address
	if tab.menu[1].submenu[i].selected == true then current_id = i end
    i=i+1
	end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = 'Контент '}
		local AutoNumberFormat, FilterType

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, tonumber(current_id-1), t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			torrents_tracker(t[id].Address)
		end
		if ret == 2 then
			content(content_id)
		end
end

function torrents_tracker(adr)
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.torrent then
		m_simpleTV.User.torrent = {}
	end
	local token = decode64('d2luZG93c18zZWZlMGUyZDg5ZTQ3NzVhYWFjMTBiMGMxYjU0YTU3MF81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url
	if adr:match('?') then url = adr .. '&token=' .. token else url = adr .. '?token=' .. token end
--	local url = adr:gsub('sorting=','sortings=') .. 'token=' .. token
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end
--	debug_in_file(rc .. ' - ' .. url .. '\n' .. answer .. '\n','c://1/deb.txt')
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	local content_id = url:match('/torrents/(.-)?')
	local title = url:match('tracker=(.-)%&') or 'Все трекеры'
	if title == '' then title = 'Все трекеры' end
	local poster = 'http://image.tmdb.org/t/p/w600_and_h900_bestv2' .. tab.details.poster
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].trackerName or not tab.channels[1].magnet
	then
	return end
	m_simpleTV.Http.Close(session)
	local current_id=1
	local t, i = {}, 1
	while true do
	if not tab.channels[i]
				then
				break
				end
	t[i]={}
	local name = tab.channels[i].title
	local sid = tab.channels[i].sid or ''
	local pir = tab.channels[i].pir or ''
	local bitrate = tab.channels[i].bitrate or ''
	local bitrat = tab.channels[i].bitrat or ''
	local trackerName = tab.channels[i].trackerName
	local sizeName = tab.channels[i].sizeName
	local address = tab.channels[i].magnet
	local createTime = tab.channels[i].createTime
	t[i].Id = i
	t[i].Name = name
	t[i].InfoPanelLogo = poster
	t[i].Address = address
	t[i].InfoPanelName = name
	t[i].InfoPanelTitle = trackerName .. ' • ' .. bitrate .. '/' .. bitrat .. ' ' .. sizeName .. ' sid/pir: ✅ ' .. sid .. '  🔻 ' .. pir .. ' • ' .. createTime
	t[i].InfoPanelShowTime = 30000
	if m_simpleTV.User.torrent.address and address == m_simpleTV.User.torrent.address then current_id = i end
    i=i+1
	end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = 'Трекеры '}
		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, tonumber(current_id-1), t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.torrent.audio_id = nil
			m_simpleTV.Control.PlayAddressT({address='content_id=' .. content_id .. '&' .. t[id].Address, title=t[id].Name})
		end
		if ret == 2 then
			torrents(adr)
		end
end

function add_to_history_tracker(adr,title,logo)

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

-- wafee code for history
	local cur_max
	local max_history = m_simpleTV.Config.GetValue('openFrom/maxRecentItem','simpleTVConfig') or 15
    local recentName = getConfigVal('trackers_history/title') or ''
    local recentAddress = getConfigVal('trackers_history/adr') or ''
	local recentLogo = getConfigVal('trackers_history/logo') or ''
     local t={}
     local tt={}
     local i=2
	 t[1] = {}
     t[1].Id = 1
     t[1].Name = title
	 t[1].Address = adr
	 t[1].Logo = logo
   if recentName~='' and recentLogo~='' and recentAddress~='' then

     for w in string.gmatch(recentName,"[^%|]+") do
       t[i] = {}
       t[i].Id = i
       t[i].Name = w
       i=i+1
     end
     i=2
     for w in string.gmatch(recentAddress,"[^%|]+") do
       t[i].Address = w
       i=i+1
     end
	 i=2
     for w in string.gmatch(recentLogo,"[^%|]+") do
       t[i].Logo = w
       i=i+1
     end

     local function isExistAdr()
       for i=2,#t do
         if adr:gsub('%&bal=.-$','')==t[i].Address:gsub('%&bal=.-$','') then
           return true, i
         end
       end
       return false
     end

     local isExist,i=isExistAdr()
     if isExist then
       table.remove(t,i)
     end

     recentName=''
     recentAddress = ''
     recentLogo = ''

	 if #t <= tonumber(max_history) then
		cur_max = #t
	 else
		cur_max = tonumber(max_history)
	 end

     for i=1,cur_max  do
      local name = t[i].Name
      t[i].Name = t[i].Name:gsub('@@@@@',',')
      recentName = recentName .. name .. '|'
      recentAddress = recentAddress .. t[i].Address .. '|'
	  recentLogo = recentLogo .. t[i].Logo .. '|'
      t[i].Id = i
--      debug_in_file('fromOSDmenu = ' .. t[i].Id .. ' ' .. t[i].Name .. ' ' .. t[i].Address .. '\n','c://1/kp.txt')
     end

	 setConfigVal('trackers_history/title',recentName)
	 setConfigVal('trackers_history/logo',recentLogo)
	 setConfigVal('trackers_history/adr',recentAddress)

	 else

	 setConfigVal('trackers_history/title',title .. '|')
	 setConfigVal('trackers_history/logo',logo .. '|')
	 setConfigVal('trackers_history/adr',adr .. '|')

   end
end

function media_info_Trackers_from_stena(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	if adr and adr ~= '' then
		m_simpleTV.Control.PlayAddressT({address=adr})
	end
	return
end
