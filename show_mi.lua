-- show mediainfo westSide (07.05.22)
function show_mediainfo(channelId)
 if channelId==-1 then return end

		local function clean_title(s)
			s = s:gsub('%(.-%)', ' ')
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
			s = s:gsub('%p', ' ')
			s = s:gsub('«', '')
			s = s:gsub('»', '')
			s = s:gsub('^%s*(.-)%s*$', '%1')
		 return s
		end

 local t = m_simpleTV.Database.GetTable('SELECT * FROM channels WHERE Id==' .. channelId)
 if   t == nil
   or t[1] == nil
  then
 return
 end

  local logo = t[1].Logo
  if logo == '' then
    logo = 'simpleTVImage:./luaScr/user/show_mi/emptyLogo.png'
  elseif string.match(logo,'^%.%.') then
    logo = 'simpleTVImage:' .. logo
  end

 local epgTitle,epgDesc,epgTitle1,epgDesc1
 local delta = m_simpleTV.Timeshift.EpgOffsetRequest or 0
 if t[1].EpgId~='' and  t[1].EpgId~='noepg' then
--	local delta = m_simpleTV.Timeshift.EpgOffsetRequest or 0
	local curTime = os.date('%Y-%m-%d %X', os.time() - delta/1000 + 1)
	local sql = 'SELECT * FROM ChProg WHERE IdChannel=="' .. t[1].EpgId .. '"'
              .. ' AND StartPr <= "' .. curTime .. '" AND EndPr > "' .. curTime .. '"'
--	local sql1 = 'SELECT * FROM ChProg WHERE IdChannel=="' .. t[1].EpgId .. '"'
--              .. ' AND StartPr > "' .. curTime .. '"'
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
	local curTime = os.date('%Y-%m-%d %X', os.time() - delta/1000 + 1)

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

	dataEN = os.date ("%a %d %b %Y %H:%M")
	dataRU = dataEN:gsub('Sun', 'Вс'):gsub('Mon', 'Пн'):gsub('Tue', 'Вт'):gsub('Wed', 'Ср'):gsub('Thu', 'Чт'):gsub('Fri', 'Пт'):gsub('Sat', 'Сб')
	dataRU = dataRU:gsub('Jan', 'Янв'):gsub('Feb', 'Фев'):gsub('Mar', 'Мар'):gsub('Apr', 'Апр'):gsub('May', 'Май'):gsub('Jun', 'Июн'):gsub('Jul', 'Июл'):gsub('Aug', 'Авг'):gsub('Sep', 'Сен'):gsub('Oct', 'Окт'):gsub('Nov', 'Ноя'):gsub('Dec', 'Дек')
	if m_simpleTV.Interface.GetLanguage() == 'ru' then data = dataRU else data = dataEn end
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
  local titleepg, yearepg, str3, backgroundepg
  if epgTitle then
		str1 = str1 .. '<h4><i><font color="#BBBBBB">' .. epgTitle ..  '</font></i><p>' .. epgCategory .. '<font color="#CD7F32">(' .. StartForH .. ':' .. StartForM .. ' - '  .. EndForH .. ':' .. EndForM .. ')</font> <b>' .. prtime .. ' мин.</b></h4>' .. '</td></tr></table>'
	titleepg = clean_title(epgTitle)
  end

  if epgDesc then
   str1 = str1 .. '<table width="100%"><tr><td style="padding: 0px 10px 10px;" valign="middle" width="100%"><h5><font color="#EBEBEB">' .. epgDesc ..  '</font></h5>'
   yearepg = epgDesc:match('^.-(%d%d%d%d).-$') or 0
  end

  if titleepg and yearepg then
  if t[1].Name and t[1].Name:match('KBC') then titleepg = titleepg:gsub(' 4K.-$',''):gsub(' %d%d%d%d$','') end
   str3,backgroundepg = info_fox(titleepg,yearepg,logo)
  end

  if backgroundepg and backgroundepg ~= '' and backgroundepg ~= logo then
   logo = backgroundepg
   if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
   end
  end

  str1 = '<html><body bgcolor="#182633"><table width="100%"><tr><td style="padding: 10px 10px 0px; color: #EBEBEB;">' .. '<img src="' .. logo .. '" width="240">' .. '</td>' .. str1

  if epgTitle1 then
   str1 = str1 .. '<p><h4><font color="#CD7F32">далее: </font><i><font color="#BBBBBB">' .. epgTitle1 .. epgCategory1 .. '</font></i></h4>'
  end

  str1 = str1 .. '</td></tr></table></body></html>'

 -- парсер названия
 t[1].Name = t[1].Name:gsub('BTV X%-Files HD', 'The X-Files 1993'):gsub('BTV  Ивановы%-Ивановы HD', 'Ивановы-Ивановы 2017'):gsub('BTV Игра престолов HD', 'Игра престолов 2011'):gsub('BTV Мистер Бин HD', 'Мистер Бин 1990'):gsub(' %- Украинский', ''):gsub(' %(Color%)', '')
 local title_rus = t[1].Name:gsub(' /.-$', ''):gsub('%(4K%)', ''):gsub(' %(мини%-сериал%)', ''):gsub('%(%+18%)', ''):gsub('%(Special%)', ''):gsub(' %- ', ' – '):gsub(' %(.-%d+%)$', ''):gsub(' %d+$', ''):gsub('%(color%)', '')
 local year = t[1].Name:match('%(.-(%d+)%)$') or t[1].Name:match(' (%d+)$')
 local title_orig = t[1].Name:gsub('^.-/ ', ''):gsub('%(4K%)', ''):gsub('%(4%)', ''):gsub(' %(мини%-сериал%)', ''):gsub('%(%+18%)', ''):gsub('%(Special%)', ''):gsub(' %- ', ' – '):gsub('%(.-%d+%)$', ''):gsub(' %d+$', ''):gsub('%(color%)', '') or title_rus
 if title_orig and year then
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
 if title_orig == 'Старые песни о главном 2' then year = 1997 end
 if title_orig == 'Старые песни о главном 3' then year = 1998 end
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
 title_orig = title_orig:gsub('%: %d+ серия$', ''):gsub(' %d+ серия$', ''):gsub(' chapter %d+$', ''):gsub('Сокровища Агри', 'Сокровища Агры'):gsub('20%-й Век начинается', 'Двадцатый век начинается')
 str2,background = info_fox(title_orig,year,logo)

    if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = background or logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end

 end
 if not str2 or str2 == '' then
 str = str1
 else
 str2 = '<html><body bgcolor="#182633">' .. info_fox(title_orig:gsub(' $', ''),year,logo) .. '</body></html>'
 str = str2
 end
--  debug_in_file(str)
 return '',str
end

function delta()
return
end

--добавление кнопки в плейлист, кроме указанных в таблице исключений

--таблица исключений
local tab = {"Media Portal 24","Radio","Radcap","YandexTV","TVSources","FMPlay Streams","Zaycev FM","101RU","DFM,RMC,RU Radio","PCradio","Digitally Imported","RadioTunes","Classicalradio","Rockradio","Jazzradio","TuneIn","Radio Record1","Multimediaholding","FMPlay","Love Radio","RadioOboz","FLAC Radio","EMG"}

--создаем таблицу tt и заносим в нее ExtFilterID исключая ExtFilter из таблицы t
local tt={}
local ext = m_simpleTV.Database.GetTable('SELECT Id, Name FROM ExtFilter;', true)
if ext~=nil then
 local function isTestExtFilter(name)
   for i,v in ipairs(tab) do
    if name==v then return true end
   end
    return false
 end

  for i=1, #ext do
   if not isTestExtFilter(ext[i].Name) then
      tt[#tt+1] = ext[i].Id
   end
  end
end

if #tt==0 then tt[1]=0 end
local t ={}
t.Image = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/fw_box_t.png'
t.EventFunction = "show_mediainfo"
t.IsTooltip = true
t.Mode = 7   --opt default=7 ( bitmask  1 - main playlist  2 - OSD playlist 4 - OSD playlist fullscreen)
t.DrawOnChannel = true   --opt default =true
t.DrawOnGroup   = false   --opt default =false
t.MediaMode = -1 --opt default -1 (-1 all, 0 - channels, 1 - files, etc)
t.StaticTooltip = m_simpleTV.Common.string_toUTF8('Show Mi',1251)
--t.ExtFilterID = 0
--t.MaxSize =16   --opt default 0
for i=1, #tt do
 t.ExtFilterID = tt[i]
 m_simpleTV.PlayList.AddItemButton(t)
end