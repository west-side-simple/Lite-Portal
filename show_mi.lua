-- show mediainfo westSide (01.04.25)
function show_mediainfo(channelId)
 if channelId==-1 then return end

--[[
	local state, info = m_simpleTV.EPG.GetCurrent(channelId)
	debug_in_file((state or "uncertain") .. '\n-----------------\n','c://1/test_show.txt')
	if state=="PRESENT" then
		debug_in_file(
		"EpgId=" .. info.EpgId .. '\n'  -- string, id of the EPG channel(main key)
	 .. "ChannelId=" .. info.ChannelId .. '\n' -- number
	 .. "Offset=" .. info.Offset .. '\n'  -- number, epg offset
	 .. "IsTimeshift=" .. (info.IsTimeshift and 'true' or 'false') .. '\n' -- boolean, true is current programme is timeshifting
	 .. "Progress=" .. info.Progress .. '\n' -- number, progress of the current programme
	 .. "Id1=" .. info.Id1 .. '\n' -- number, id of the current programme
	 .. "Title1=" .. info.Title1 .. '\n' -- utf8 string, title of the current programme
	 .. "Start1=" .. info.Start1 .. '\n' -- number, start dateTime of the current programme, dateTime in time_t format
	 .. "End1=" .. info.End1 .. '\n'   -- number, end dateTime of the current programme, dateTime in time_t format
	 .. "HasDesc1=" .. (info.HasDesc1 and 'true' or 'false') .. '\n' -- boolean, true if current programme has description
	 .. "Id2=" .. info.Id2 .. '\n' -- number, id of the next programme
	 .. "Title2=" .. info.Title2 .. '\n' -- utf8 string, title of the next programme
	 .. "Start2=" .. info.Start2 .. '\n' -- number, start dateTime of the next programme, dateTime in time_t format
	 .. "End2=" .. info.End2 .. '\n' -- number, end dateTime of the next programme, dateTime in time_t format
	 .. "HasDesc2=" .. (info.HasDesc2 and 'true' or 'false') .. '\n-----------------\n' -- boolean, true if next programme has description
	 ,'c://1/test_show.txt')
	end--]]

		local function test_logo(logo)
			local userAgent = "Mozilla/5.0 (Windows NT 10.0; rv:85.0) Gecko/20100101 Firefox/85.0"
			local session =  m_simpleTV.Http.New(userAgent)
			if not session then return 'simpleTVImage:./luaScr/user/show_mi/emptyLogo.png' end
			m_simpleTV.Http.SetTimeout(session, 2000)
			local rc = m_simpleTV.Http.Request(session,{method="HEAD",url=logo})
			if rc==200 then
			  m_simpleTV.Http.Close(session)
			  return logo
			end
			m_simpleTV.Http.Close(session)
			return 'simpleTVImage:./luaScr/user/show_mi/emptyLogo.png'
		end

		local function clean_title(s)
			s = s:gsub('%(.-%).-$', '')
			s = s:gsub('%[.-%]', ' ')
			s = s:gsub('Х/ф', '')
			s = s:gsub('х/ф', '')
			s = s:gsub('М/ф', '')
			s = s:gsub('м/ф', '')
			s = s:gsub('М/с', '')
			s = s:gsub('м/с', '')
			s = s:gsub('Т/с', '')
			s = s:gsub('т/с', '')
			s = s:gsub('%d+%-.-$', ' ')
			s = s:gsub('Сезон.-$', '')
			s = s:gsub('сезон.-$', '')
			s = s:gsub('Серия.-$', '')
			s = s:gsub('серия.-$', '')
			s = s:gsub('%d+ с%-н.-$', '')
			s = s:gsub('%d+ с[%.]*$', '')
--			s = s:gsub('%p', ' ')
			s = s:gsub('«', '')
			s = s:gsub('»', '')
			s = s:gsub('^%s*(.-)%s*$', '%1')
			s = s:gsub('%.$', '')
			s = s:gsub('%,$', '')
		 return s
		end

 local t = m_simpleTV.Database.GetTable('SELECT * FROM channels WHERE Id==' .. channelId)
 if   t == nil
   or t[1] == nil
  then
 return
 end

  local logo = t[1].Logo
  if logo == '' or not logo then
    logo = 'simpleTVImage:./luaScr/user/show_mi/emptyLogo.png'
  elseif string.match(logo,'^%.%.') then
    logo = 'simpleTVImage:' .. logo
  end
  if string.match(logo,'^http') then
   logo = test_logo(logo)
  end
 local state, info = m_simpleTV.EPG.GetCurrent(channelId)
 local delta = 0
 local dataEND = ''
 if state and state=="PRESENT" then
	delta = os.time() - (tonumber(info.Start1) + (tonumber(info.End1)-tonumber(info.Start1))*tonumber(info.Progress))
	dataEND = math.floor((tonumber(info.End1) - tonumber(info.Start1)) * (1 - tonumber(info.Progress)) / 60) .. ' мин.'
 end
 local epgTitle,epgDesc,epgTitle1,epgDesc1
-- local delta = m_simpleTV.Timeshift.EpgOffsetRequest or 0

 if t[1].EpgId~='' and  t[1].EpgId~='noepg' then
--	local delta = m_simpleTV.Timeshift.EpgOffsetRequest or 0
	local curTime = os.date('%Y-%m-%d %X', os.time() - tonumber(delta) + 1)
	local sql = 'SELECT * FROM ChProg WHERE IdChannel=="' .. t[1].EpgId .. '"'
              .. ' AND StartPr <= "' .. curTime .. '" AND EndPr > "' .. curTime .. '"'
  --debug_in_file(sql)
  local epgT = m_simpleTV.Database.GetTable(sql)

  if     epgT~=nil
     and epgT[1]~=nil
   then
   epgTitle = epgT[1].Title
   epgDesc  = epgT[1].Desc
   epgCategory = epgT[1].Category
   StartFor = epgT[1].StartPr:gsub('-$--$--$', '')
   EndFor   = epgT[1].EndPr
  end
--	else return
 end

  if t[1].EpgId1~='' and  t[1].EpgId1~='noepg' then

--	local delta = m_simpleTV.Timeshift.EpgOffsetRequest or 0
	local curTime = os.date('%Y-%m-%d %X', os.time() - delta + 1)

	local sql1 = 'SELECT * FROM ChProg WHERE IdChannel=="' .. t[1].EpgId .. '"'
              .. ' AND StartPr > "' .. curTime .. '"'
  --debug_in_file(sql1)
  local epgT1 = m_simpleTV.Database.GetTable(sql1)

  if     epgT1~=nil
     and epgT1[1]~=nil
   then
   epgTitle1 = epgT1[1].Title
   epgDesc1  = epgT1[1].Desc
   epgCategory1 = epgT1[1].Category
  end
--	else return
 end

	local dataEN = os.date ("%a %d %b %Y %H:%M")
	local dataRU = dataEN:gsub('Sun', 'Вс'):gsub('Mon', 'Пн'):gsub('Tue', 'Вт'):gsub('Wed', 'Ср'):gsub('Thu', 'Чт'):gsub('Fri', 'Пт'):gsub('Sat', 'Сб')
	dataRU = dataRU:gsub('Jan', 'Янв'):gsub('Feb', 'Фев'):gsub('Mar', 'Мар'):gsub('Apr', 'Апр'):gsub('May', 'Май'):gsub('Jun', 'Июн'):gsub('Jul', 'Июл'):gsub('Aug', 'Авг'):gsub('Sep', 'Сен'):gsub('Oct', 'Окт'):gsub('Nov', 'Ноя'):gsub('Dec', 'Дек')
	local data = dataEN
	local desc_in_channel
	if dataEND =='' and t[1].LastPosition then
		dataEND = 'Прогресс просмотра ' .. math.ceil(tonumber(t[1].LastPosition)*100) .. '%'
		desc_in_channel = t[1].Desc or ''
	else
		dataEND = 'До окончания ' .. dataEND
	end
	if m_simpleTV.Interface.GetLanguage() == 'ru' or m_simpleTV.Interface.GetLanguage() == 'uk' then data = dataRU end

 if StartFor and EndFor then
 StartForN = StartFor:gsub('.- ', '')
 StartForH = StartForN:match('(.-):')
 StartForM = StartForN:match(':(.-):')
 EndForN = EndFor:gsub('.- ', '')
 EndForH = EndForN:match('(.-):')
 EndForM = EndForN:match(':(.-):')
 prtime = (EndForH * 60 + EndForM) - (StartForH * 60 + StartForM)
 if prtime < 0 then prtime = prtime + 24 * 60 end
 timeH = os.date ("%H")
 timeM = os.date ("%M")
 prendtime = (EndForH * 60 + EndForM) - (timeH * 60 + timeM)
 if prendtime < 0 then prendtime = prendtime + 24 * 60 end
 end
  if epgCategory and epgCategory ~= '' then epgCategory = '<font color="#BBBBBB">' .. epgCategory .. '</font><p>' else epgCategory = '' end
  if epgCategory1 and epgCategory1 ~= '' then epgCategory1 = ' (' .. epgCategory1 .. ')' else epgCategory1 = '' end
  local str1, str2 = '<td style="padding: 10px 10px 0px; color: #EBEBEB;" valign="middle"><h3><font color="#00FF7F">' .. t[1].Name .. '</font></h3>', ''
  local titleepg, yearepg, str3, backgroundepg, str4
  if epgTitle then
		str1 = str1 .. '<h4><i><font color="#BBBBBB">' .. epgTitle ..  '</font></i><p>' .. epgCategory .. '<font color="#CD7F32">(' .. StartForH .. ':' .. StartForM .. ' - '  .. EndForH .. ':' .. EndForM .. ')</font> <b>' .. prtime .. ' мин.</b></h4>' .. '</td></tr></table>'
	titleepg = clean_title(epgTitle)
  end
  if epgDesc then
   for w in epgDesc:gmatch('%d%d%d%d') do
    yearepg = w
   end
  end
  yearepg = epgTitle and epgTitle:match('%((%d%d%d%d)%)') or yearepg or epgTitle and epgTitle:match('(%d%d%d%d)')
  if titleepg and yearepg then
    if t[1].Name and t[1].Name:match('KBC') then titleepg = titleepg:gsub(' 4K.-$',''):gsub(' %d%d%d%d$','') end
    str3, backgroundepg, str4 = info_fox(titleepg,yearepg,logo)
--	debug_in_file(titleepg .. ' ' .. yearepg .. '\n')
  end
  if str4 and str4 ~= '' then
   str1 = str1 .. '<table width="100%"><tr><td style="padding: 0px 10px 10px;" valign="middle" width="100%"><h5><font color="#EBEBEB">' .. str4 ..  '</font></h5>'
  else
   str1 = str1 .. '<table width="100%"><tr><td style="padding: 0px 10px 10px;" valign="middle" width="100%"><h5><font color="#EBEBEB">' .. (epgDesc or desc_in_channel or '') ..  '</font></h5>'
  end

  if backgroundepg and backgroundepg ~= '' and backgroundepg ~= logo then
   logo = backgroundepg
   if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
   end
  end
  local bg = ' bgcolor="#182633"'
--  if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then bg = '' end
  str1 = '<html><body' .. bg .. '>' .. '<table width="100%"><tr><td style="padding: 10px 10px 0px; color: #EBEBEB;" align="left"><h4><i><font color="#BBFF8C00">' .. data .. '</font></i></h4></td><td style="padding: 10px 10px 0px; color: #EBEBEB;" align="right"><h4><i><font color="#BBFF8C00">' .. dataEND .. '</font></i></h4></td></tr></table>' .. '<table width="100%"><tr><td style="padding: 10px 10px 0px; color: #EBEBEB;">' .. '<img src="' .. logo .. '" width="240">' .. '</td>' .. str1

  if epgTitle1 then
   str1 = str1 .. '<p><h4><font color="#CD7F32">далее: </font><i><font color="#BBBBBB">' .. epgTitle1 .. epgCategory1 .. '</font></i></h4>'
  end

  str1 = str1 .. '</td></tr></table></body></html>'

 -- парсер названия
 t[1].Name = t[1].Name:gsub('BTV X%-Files HD', 'The X-Files 1993'):gsub('BTV  Ивановы%-Ивановы HD', 'Ивановы-Ивановы 2017'):gsub('BTV Игра престолов HD', 'Игра престолов 2011'):gsub('BTV Мистер Бин HD', 'Мистер Бин 1990'):gsub(' %- Украинский', ''):gsub(' %(Color%)', ''):gsub('пьесса','пьеса')
 local title_rus = t[1].Name:gsub(' /.-$', ''):gsub('%(4K%)', ''):gsub(' %(мини%-сериал%)', ''):gsub('%(%+18%)', ''):gsub('%(Special%)', ''):gsub(' %- ', ' – '):gsub(' %(.-%d+%)$', ''):gsub(' %d+$', ''):gsub('%(color%)', '')
 local year = t[1].Name:match('%(.-(%d+)%)$') or t[1].Name:match(' (%d+)$') or ''
 t[1].Name = t[1].Name:gsub(' %(.-$', '')
 local title_orig = t[1].Name:gsub('^.-/ ', ''):gsub('%(4K%)', ''):gsub('%(4%)', ''):gsub(' %(мини%-сериал%)', ''):gsub('%(%+18%)', ''):gsub('%(Special%)', ''):gsub(' %- ', ' – '):gsub('%(.-%d+%)$', ''):gsub(' %d+$', ''):gsub('%(color%)', '') or title_rus
 if title_orig and year and not epgTitle then
 if title_orig:match('The Witcher') then title_orig = 'Ведьмак' year = 2019 end
 if title_orig == 'Bob Dylan at the Newport Folk Festival' then title_orig = 'Bob Dylan: The Other Side of the Mirror - Live at the Newport Folk Festival' year = 2007 end
 if title_orig:match('Холодное лето') then year = 1988 end
 if title_orig:match('Невероятные приключения') then year = 1974 end
 if title_orig:match('Мировой парень') then year = 1972 end
 if title_orig:match('Отпуск за свой счет') then year = 1982 end
 if title_orig:match('Блондинка за углом') then year = 1983 end
 if title_orig:match('Приключения Тома Сойера') then year = 1982 end
 if title_orig:match('12 стульев') and tonumber(year) == 1976 then year = 1977 end
 if title_orig:match('Человек%-амфибия') then year = 1962 end
 if title_orig:match('Трест который лопнул') then year = 1983 end
 if title_orig:match('Вождь краснокожих') then title_orig = 'Деловые люди' end
 if title_orig:match('Калина красная') then year = 1974 end
 if title_orig:match('ДАртаньян и три мушкетера') then year = 1978 end
 if title_orig:match('Кавказская пленница') then year = 1967 end
 if title_orig:match('Москва слезам не верит') then year = 1980 end
 if title_orig:match('На море!') then year = 2009 end
 if title_orig:match('Легенда №17') then year = 2013 end
 if title_orig:match('На Дерибасовской хорошая погода') then title_orig = 'На Дерибасовской хорошая погода, или На Брайтон-Бич опять идут дожди' year = 1993 end
 if title_orig:match('Трезвый водитель') then year = 2019 end
 if title_orig:match('Inkheart') then year = 2008 end
 if title_orig:match('The Dark World') then title_orig = 'Thor: The Dark World' end
 if title_orig == 'The Witches' then year = 1990 end
 if title_orig == 'Pelé: Birth of a Legend' then year = 2016 end
 if title_orig == 'Phantasm' then year = 1979 end
 if title_orig == 'Hellbound' then year = 1994 end
 if title_orig == 'Season of the Witch' then year = 2011 end
 if title_orig:match('R%-Evolution') then year = 2013 end
 if title_orig:match('Heathens and Thieves') then year = 2013 end
 if title_orig:match('Lichtmond') and tonumber(year) == 2014 then title_orig = 'Lichtmond 3 - Days of Eternity' end
 if title_orig:match('Старые песни о главном') then year = 1996 end
 if title_orig == 'Старые песни о главном 2' then year = 1997 end
 if title_orig == 'Старые песни о главном 3' then year = 1998 end
 if title_rus == 'Чиполлино' then year = 1973 end
 if title_rus == 'Белое солнце пустыни' then year = 1970 end
 if title_rus == 'Сексмиссия' then year = 1984 end
 if title_rus == 'Юнона и Авось' then year = 1983 end
 if title_rus == 'Любовь никогда не умирает' then year = 2012 end
 if title_rus == 'Летучая мышь' then year = 1979 end
 if title_rus == 'Хорошая девочка' then year = 2002 end
 if title_rus == 'Притворись моим парнем' then year = 2013 end
 if title_rus == 'Остров сокровищ' then year = 1989 end
 if title_orig:match('Приключения Петрова и Васечкина') then year = 1983 end
 if title_orig:match('Бриллиантовая рука') then year = 1969 end
 if title_orig:match('Федорино горе') then year = 1973 end
 if title_rus:match('Майами') and title_orig == 'New in Town' then year = 2009 end
 if title_orig:match('Неоконченная пьеса') then	year = 1977 end
 title_orig = title_orig:gsub('%: %d+ серия$', ''):gsub(' %d+ серия$', ''):gsub(' chapter %d+$', ''):gsub('Сокровища Агри', 'Сокровища Агры'):gsub('20%-й Век начинается', 'Двадцатый век начинается')
 str2,background = info_fox(title_orig,year,logo)

    if m_simpleTV.Control.MainMode == 0 and not backgroundepg then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = background or logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end

 end
 if not str2 or str2 == '' then
 str = str1
 else
 str2 = '<html><body' .. bg .. '>' .. str2 .. '</body></html>'
 str = str2
 end
--  debug_in_file(str:gsub('http://image%.tmdb%.org',m_simpleTV.User.TVPortal.proxy_image):gsub('/original/','/w200/') .. '\n')
 return '',str:gsub('http://image%.tmdb%.org',m_simpleTV.User.TVPortal.proxy_image):gsub('/original/','/w200/')
end

function show_me()
--	debug_in_file(m_simpleTV.Control.ChannelID .. '\n')
	if not m_simpleTV.Control.ChannelID then return end
	local function findChannelNameByID(id)
		if id then
			local t = m_simpleTV.Database.GetTable('SELECT Channels.Name FROM Channels WHERE Channels.Id="' .. id .. '";')
			if t and t[1] and t[1].Name then return t[1].Name end
		end
	 return nil
	end
		local rc,str = show_mediainfo(m_simpleTV.Control.ChannelID)
		local t ={}
		t.message=str:gsub(' bgcolor="#182633"','')   -- string  (empty string mean close current messageBox)
		--All other field are optional
		t.header=findChannelNameByID(m_simpleTV.Control.ChannelID)    -- string
--		t.extMessage -- string
--		t.textColor  -- ARGB
--		t.linkColor  -- ARGB
		t.richTextMode=true -- boolean
		t.addFontHeight=3  -- number
		t.addHeaderFontHeight=5  -- number
		t.showTime=5000  -- number
--		t.once      -- boolean (auto close if current play stopped or changed)
--		t.textAlignment  -- Qt::Alignment
--		t.windowAlignment  -- number
--		t.windowMaxSizeH   -- number
--		t.windowMaxSizeV   -- number
		m_simpleTV.OSD.ShowMessageBox(t)
end

	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end

	m_simpleTV.User.TVPortal.is_button = m_simpleTV.Config.GetValue("Portal_TV_WS_info_Enable","PortalTV.ini") or 0 -- 1 or 0
	m_simpleTV.User.TVPortal.is_epg = m_simpleTV.Config.GetValue("Portal_TV_WS_epg_Enable","PortalTV.ini") or 1 -- 1 or 0

	m_simpleTV.User.TVPortal.proxy_image = m_simpleTV.Config.GetValue("image_proxy","PortalTV.ini") or 'http://image.tmdb.org'


	--добавление кнопки в плейлист, кроме указанных в таблице исключений

	--таблица исключений
	local tab = {"Media Portal 24","PERSONS","Franchises","IMDb WS",""}

	--создаем таблицу tt и заносим в нее ExtFilterID исключая ExtFilter из таблицы t
	local tt={}
	local ext = m_simpleTV.Database.GetTable('SELECT Id, Name, TypeMedia FROM ExtFilter;', true)
	if ext~=nil then
	 local function isTestExtFilter(name)
	   for i,v in ipairs(tab) do
		if name==v then return true end
	   end
		return false
	 end

	  for i=1, #ext do
	   if not isTestExtFilter(ext[i].Name) and tonumber(ext[i].TypeMedia)~=1 and tonumber(ext[i].TypeMedia)~=2  then
		  tt[#tt+1] = ext[i].Id
	   end
	  end
	end

if #tt==0 then tt[1]=0 end
m_simpleTV.User.TVPortal.button ={}
m_simpleTV.User.TVPortal.button.id ={}
m_simpleTV.User.TVPortal.button.Image = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/fw_box_t.png'
m_simpleTV.User.TVPortal.button.EventFunction = "show_mediainfo"
m_simpleTV.User.TVPortal.button.IsTooltip = true
m_simpleTV.User.TVPortal.button.Mode = 7   --opt default=7 ( bitmask  1 - main playlist  2 - OSD playlist 4 - OSD playlist fullscreen)
m_simpleTV.User.TVPortal.button.DrawOnChannel = true   --opt default =true
m_simpleTV.User.TVPortal.button.DrawOnGroup   = false   --opt default =false
m_simpleTV.User.TVPortal.button.MediaMode = -1 --opt default -1 (-1 all, 0 - channels, 1 - files, etc)
m_simpleTV.User.TVPortal.button.StaticTooltip = m_simpleTV.Common.string_toUTF8('Show Mi',1251)
--m_simpleTV.User.TVPortal.button.ExtFilterID = 0
--m_simpleTV.User.TVPortal.button.MaxSize =16   --opt default 0
if tonumber(m_simpleTV.User.TVPortal.is_button) == 1 then
 for i=1, #tt do
  m_simpleTV.User.TVPortal.button.ExtFilterID = tt[i]
  m_simpleTV.User.TVPortal.button.id[i] = m_simpleTV.PlayList.AddItemButton(m_simpleTV.User.TVPortal.button)
 end
end
-------------------------------------------------------------------
	m_simpleTV.User.TVPortal.epg={}
	m_simpleTV.User.TVPortal.epg.utf8 = true
	m_simpleTV.User.TVPortal.epg.name = 'Show Me'
	m_simpleTV.User.TVPortal.epg.luastring = 'show_me()'
	m_simpleTV.User.TVPortal.epg.lua_as_scr = true
	m_simpleTV.User.TVPortal.epg.submenu = 'westSide Portal'
    m_simpleTV.User.TVPortal.epg.imageSubmenu = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSide/icons/portal.png'
	m_simpleTV.User.TVPortal.epg.key = string.byte('G')
	m_simpleTV.User.TVPortal.epg.ctrlkey = 0
	m_simpleTV.User.TVPortal.epg.location = 0
	m_simpleTV.User.TVPortal.epg.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/MediaPortal_Logo.png'
if tonumber(m_simpleTV.User.TVPortal.is_epg) == 1 then
	m_simpleTV.Interface.AddExtMenuT({utf8 = false, name = '-'})
	m_simpleTV.User.TVPortal.epg.id = m_simpleTV.Interface.AddExtMenuT(m_simpleTV.User.TVPortal.epg)
	m_simpleTV.Interface.AddExtMenuT({utf8 = false, name = '-'})
end
