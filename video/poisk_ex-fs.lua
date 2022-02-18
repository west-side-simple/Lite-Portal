-- видеоскрипт  поиска медиаконтента кинопоиска через сайт https://ex-fs.net/ (01/09/21)
-- autor westSide
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not m_simpleTV.Control.CurrentAddress:match('^!')
		then
		 return
		end
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000, id = 'channelName'})
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = ''

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3809.87 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelLogo('https://fdlx.com/wp-content/uploads/v-ukraine-vozobnovil-rabotu-servis-ex-ua-poyavilsya-novyj-kinosajt-ex-fs-net-1.png', m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName('Search EX-FS: ' .. m_simpleTV.Common.multiByteToUTF8(inAdr:gsub('^!',''),1251), m_simpleTV.Control.ChannelID, false)
	end
	m_simpleTV.Control.SetTitle('Search EX-FS: ' .. m_simpleTV.Common.multiByteToUTF8(inAdr:gsub('^!',''),1251))

	local function xren(s)
			if not s then
			 return ''
			end
		s = s:lower()
		s = s:gsub('%s+', ' ')
		s = s:gsub('^%s*(.-)%s*$', '%1')
		local a = {
				{'А', 'а'}, {'Б', 'б'}, {'В', 'в'}, {'Г', 'г'}, {'Д', 'д'}, {'Е', 'е'}, {'Ж', 'ж'}, {'З', 'з'},
				{'И', 'и'},	{'Й', 'й'}, {'К', 'к'}, {'Л', 'л'}, {'М', 'м'}, {'Н', 'н'}, {'О', 'о'}, {'П', 'п'},
				{'Р', 'р'}, {'С', 'с'},	{'Т', 'т'}, {'Ч', 'ч'}, {'Ш', 'ш'}, {'Щ', 'щ'}, {'Х', 'х'}, {'Э', 'э'},
				{'Ю', 'ю'}, {'Я', 'я'}, {'Ь', 'ь'},	{'Ъ', 'ъ'}, {'Ё', 'е'},	{'ё', 'е'}, {'Ф', 'ф'}, {'Ц', 'ц'},
				{'У', 'у'}, {'Ы', 'ы'},
				}
			for _, v in pairs(a) do
				s = s:gsub(v[1], v[2])
			end
	 return s
	end

	local function find_exfs(exfs_search,con)
	local t, i, j, pages, answerd3 = {}, 1, 1, 1, ''
	while j <= tonumber(pages) do
	local urld2 = 'https://ex-fs.net/index.php?do=search&subaction=search&search_start=' .. j .. '&full_search=0&result_from=1&story=' .. m_simpleTV.Common.toPercentEncoding(exfs_search:gsub('%-',' '))
	local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
	if rc2~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	answerd2 = answerd2:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', ''):gsub('\n', '')
	if j==1 then pages = answerd2:match('найдено (%d+)') or 18 pages = math.ceil(tonumber(pages)/18) end
	answerd3 = answerd3 .. answerd2
	j=j+1
	end
	for w in answerd3:gmatch('<div class="SeaRchresultPost">.-<div class="clear"></div>') do

	local logo, adr, name, title, infodesc_exfs = w:match('<img src="(.-)".-href="(.-)" >(.-)</a>.-<div class="SeaRchresultPostInfo">(.-)</div>.-<div class="SeaRchresultPostOpisanie">(.-)</div>')
	logo = logo:gsub('/thumbs%.php%?src=',''):gsub('%&.-$','')
	infodesc_exfs = infodesc_exfs:gsub('<div.->',''):gsub('&nbsp;',' ')
	title = title:gsub('</a>',''):gsub('<a.->','')
	title = ' (' .. title .. ')'
	if not logo or not adr or not name then break end

	if tonumber(con) == 1 and adr:match('/films/')
	or tonumber(con) == 2 and adr:match('/series/')
	or tonumber(con) == 3 and adr:match('/cartoon/')
	or tonumber(con) == 4 and adr:match('/show/')
	or tonumber(con) == 5 and adr:match('/actors/')
	then
	if tonumber(con) == 5 and adr:match('/actors/') then title = '' end
	t[i] = {}
	t[i].Id = i
	t[i].Name = name .. title
	t[i].Address = adr
	t[i].InfoPanelLogo = logo
	t[i].InfoPanelName = 'EX-FS info: ' .. name .. title
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = infodesc_exfs

	i = i + 1
	end
	end
	return t, i-1
	end

	local function find_work(url)

	local function infodesc(url1)

	local rc4,answerd4 = m_simpleTV.Http.Request(session,{url=url1})
	if rc4~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	answerd4 = answerd4:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', ''):gsub('\n', '')
	local content = answerd4:match('<meta name="description" content="(.-)"')
	local plus = ''
	answerd4 = answerd4:gsub('<h4 class="FullstoryInfoTitle">Перевод.-</p>',''):gsub('<h4 class="FullstoryInfoTitle">Качество.-</p>',''):gsub('<h4 class="FullstoryInfoTitle">Время.-</p>','')
	for w1 in answerd4:gmatch('<p.-</p>') do
	plus = plus .. ', ' .. w1:gsub('<.->','')
	end
	plus = plus:gsub('^, ','')
	return content , plus
	end

	local urld3 = url
	local rc3,answerd3 = m_simpleTV.Http.Request(session,{url=urld3})
	if rc3~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	answerd3 = answerd3:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', ''):gsub('\n', '')

	local t, i = {}, 1
	for w in answerd3:gmatch('<div class="MiniPostAllForm MiniPostAllFormDopAct">.-</div> </div>') do
	local group = ''
	local logo, adr, name = w:match('<img src="(.-)".-<a href="(.-)".->(.-)</a>')

	if not logo or not adr or not name then break end
	logo = logo:gsub('/thumbs%.php%?src=',''):gsub('%&.-$','')
	if adr:match('/films/') then group = ' - Фильм' end
	if adr:match('/series/') then group = ' - Сериал' end
	if adr:match('/cartoon/') then group = ' - Мультфильм' end
	if adr:match('/show/') then group = ' - Передачи и шоу' end
	local infodesc_exfs, title = infodesc(adr)

	t[i] = {}
	t[i].Id = i
	t[i].Name = name .. group
	t[i].Address = adr
	t[i].InfoPanelLogo = logo
	t[i].InfoPanelName = name .. ' (' .. (title or '...') .. ')'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = infodesc_exfs .. '...'

	i = i + 1

	end
	return t, i-1
	end

	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = 'https://s02.h.cdn4.life/media/html5/9/7/df097cf5-1d6a-4ca2-b216-7bcbdf84840c/images/bg-mid.jpg', TypeBackColor = 0, UseLogo = 3, Once = 1})
	end

	exfs_search = inAdr:match('^!(.-)$')
	exfs_search = m_simpleTV.Common.multiByteToUTF8(exfs_search,1251)
	m_simpleTV.Control.CurrentTitle_UTF8 = exfs_search
	local t1, nm1 = find_exfs(exfs_search,1)
	local t2, nm2 = find_exfs(exfs_search,2)
	local t3, nm3 = find_exfs(exfs_search,3)
	local t4, nm4 = find_exfs(exfs_search,4)
	local t5, nm5 = find_exfs(exfs_search,5)
	local retAdr = ''

	local tt = {
	{"Фильмы","","./luaScr/user/show_mi/IconVideo.png",""},
	{"Сериалы","","./luaScr/user/show_mi/IconTVShows.png",""},
	{"Мультфильмы","","./luaScr/user/show_mi/IconVideo.png",""},
	{"Передачи и шоу","","./luaScr/user/show_mi/IconTVShows.png",""},
	{"Персоны","","./luaScr/user/show_mi/IconActor.png",""},
	}

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
    t[i].Name = tt[i][1] .. ' (' .. nm4 .. ')'
	elseif i == 5 then
    t[i].Name = tt[i][1] .. ' (' .. nm5 .. ')'
	end
    t[i].Action = tt[i][2]
	t[i].InfoPanelLogo = tt[i][3]
	t[i].InfoPanelTitle = tt[i][4]
	t[i].InfoPanelShowTime = 12000
  end
	t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 Rezka '}
	t.ExtButton0 = {ButtonEnable = true, ButtonName = '🔎 TMDb '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 Выберите категорию поиска: ' .. exfs_search,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr:gsub('^!','=')
		end
		if ret == 3 then
		retAdr = inAdr:gsub('^!','#')
		end
  if ret == 1 then

	if id == 1 then

	t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 фильмы: ' .. exfs_search, 0, t1, 30000, 1 + 4 + 8 + 2)
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
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 сериалы: ' .. exfs_search, 0, t2, 30000, 1 + 4 + 8 + 2)
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
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 мультфильмы: ' .. exfs_search, 0, t3, 30000, 1 + 4 + 8 + 2)
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
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 передачи и шоу: ' .. exfs_search, 0, t4, 30000, 1 + 4 + 8 + 2)
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
		elseif id == 5 then

	t5.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t5.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 персоны: ' .. exfs_search, 0, t5, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		m_simpleTV.Control.CurrentTitle_UTF8 = t5[id].Name
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = t5[id].InfoPanelLogo, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
		local t6, nm6 = find_work(t5[id].Address)
		if t6 ~= '' then
		t6.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
		t6.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 ' .. t5[id].Name .. ' (' .. nm6 .. ')', 0, t6, 30000, 1 + 4 + 8 + 2)
	if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		m_simpleTV.Control.CurrentTitle_UTF8 = t6[id].Name
		m_simpleTV.Control.ChangeChannelLogo(t6[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		retAdr = t6[id].Address
	end
	end
	end
	end
	end
	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = retAdr
	dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\video\\video.lua')
	-- debug_in_file(retAdr .. '\n')