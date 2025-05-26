-- Видеоскрипт для воспроизведения из медиапортала TV (20.12.2024)
-- author west_side, GitHub: https://github.com/west-side-simple
-- Открывает ссылки:
-- portalTV=N&channel=M, где N - номер группы плейлиста TV портала, M - номер канала в группе плейлиста TV портала
-- portalTV_search=N&channel=M, где N - номер плейлиста TV портала, M - номер канала плейлисте TV портала
-- ===============================================================================================================

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
local inAdr = m_simpleTV.Control.CurrentAdress
if not inAdr then return end
if not inAdr:match('^portalTV=')
and not inAdr:match('^portalTV_search=')
and not inAdr:match('^portalTV_playlist=')
and not inAdr:match('^portalTV_stalker_playlist=')
then return end

m_simpleTV.Control.ChangeAdress = 'Yes'

local grp = inAdr:match('^portalTV=(%d+)') or inAdr:match('^portalTV_search=(%d+)')
local search_grp = inAdr:match('^portalTV_search=(%d+)')
local chn = inAdr:match('channel=(%d+)')
local pll = inAdr:match('^portalTV_playlist=(.-)$')
local stalker_pll = inAdr:match('^portalTV_stalker_playlist=(.-)$')

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
end

local function get_name_from_slots(adr)
	if m_simpleTV.User.TVPortal.Address_PortalTV_1 and m_simpleTV.User.TVPortal.Address_PortalTV_1 == adr then
		return m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_1)
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_2 and m_simpleTV.User.TVPortal.Address_PortalTV_2 == adr then
		return m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_2)
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_3 and m_simpleTV.User.TVPortal.Address_PortalTV_3 == adr then
		return m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_3)
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_4 and m_simpleTV.User.TVPortal.Address_PortalTV_4 == adr then
		return m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_4)
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_5 and m_simpleTV.User.TVPortal.Address_PortalTV_5 == adr then
		return m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_5)
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_6 and m_simpleTV.User.TVPortal.Address_PortalTV_6 == adr then
		return m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_6)
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_7 and m_simpleTV.User.TVPortal.Address_PortalTV_7 == adr then
		return m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_7)
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_8 and m_simpleTV.User.TVPortal.Address_PortalTV_8 == adr then
		return m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_8)
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_9 and m_simpleTV.User.TVPortal.Address_PortalTV_9 == adr then
		return m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_9)
	end
	if m_simpleTV.User.TVPortal.Address_PortalTV_10 and m_simpleTV.User.TVPortal.Address_PortalTV_10 == adr then
		return m_simpleTV.Common.multiByteToUTF8(m_simpleTV.User.TVPortal.Name_PortalTV_10)
	end
end

local function Get_title_pll()
	local title, i = 'PLL ', 1
	while true do
		local ch = m_simpleTV.Database.GetTable('SELECT Channels.Id FROM Channels WHERE Channels.Name="PLL ' .. i .. '" AND Channels.Id<268435455;')
		if ch and ch[1] and ch[1].Id then
			i = i + 1
		else
			return 'PLL ' .. i
		end
	end
end

local function findChannelIdByAddress(adr)
	if adr then
		local t = m_simpleTV.Database.GetTable('SELECT Channels.Id,Channels.Name FROM Channels WHERE Channels.Address="' .. adr .. '" AND Channels.Id<268435455;')
--		debug_in_file('SELECT Channels.Id,Channels.Name FROM Channels WHERE Channels.Address="' .. adr .. '" AND Channels.Id<268435455;'.. '\n' .. t[1].Id .. '\n','c://1/group.txt')
			if t and t[1] and t[1].Id and t[1].Name then return t[1].Id, t[1].Name end
	end
 return nil
end

local function xren(s) -- Nexterr Code +
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
			{'У', 'у'}, {'Ы', 'ы'}, -- russian
			{'A', 'a'}, {'B', 'b'}, {'C', 'c'}, {'D', 'd'}, {'E', 'e'}, {'F', 'f'}, {'G', 'g'}, {'H', 'h'},
			{'I', 'i'},	{'J', 'j'}, {'K', 'k'}, {'L', 'l'}, {'M', 'm'}, {'N', 'n'}, {'O', 'o'}, {'P', 'p'},
			{'Q', 'q'}, {'R', 'r'},	{'S', 's'}, {'T', 't'}, {'U', 'u'}, {'V', 'v'}, {'W', 'w'}, {'X', 'x'},
			{'Y', 'y'}, {'Z', 'z'},	-- english
			}
	for _, v in pairs(a) do
		s = s:gsub(v[1], v[2])
	end
	return s
end

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

local function IMDB(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJmtpbm9wb2lza19pZD0=') .. kp_id
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
	if rc5~=200 then
		return false
	end
	require('json')
	answer_vn = answer_vn:gsub('(%[%])', '"nil"')
	local tab_vn = json.decode(answer_vn)
	if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].imdb_id then
		return tab_vn.data[1].imdb_id
	end
	return
end

local function cor_title_year(imdb_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
	local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
	if rc1~=200 then
	m_simpleTV.Http.Close(session)
	return
	end
	require('json')
	answerd = answerd:gsub('(%[%])', '"nil"')
	local tab = json.decode(answerd)
	local title,year
	if tab and tab.movie_results and tab.movie_results[1] then
	title = tab.movie_results[1].title
	year = tab.movie_results[1].release_date
	elseif tab and tab.tv_results and tab.tv_results[1] then
	title = tab.tv_results[1].name
	year = tab.tv_results[1].first_air_date
	end
	if year then year = year:match('(%d%d%d%d)') end
	if title and year then return title, year end
	return false
end

local function Get_info(title, year)
	local url = 'http://api.vokino.tv/v2/list?name=' .. escape (title)
	local token = decode64('d2luZG93c18yZmRkYTQyMWNkZGI2OTExNmUwNzY4ZjNiZmY0ZGUwNV81OTIwMjE=')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	url = url .. '&token=' .. token
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
	local t, i = {}, 1
--	debug_in_file('\n----------------------\n' .. title .. ' ' .. year .. '\n----------------------\n','d://info_test.txt')
	while true do
		if not tab.channels[i] or not tab.channels[i].details or not tab.channels[i].details.id then break	end
		local id = tab.channels[i].details.id or ''
		local name = tab.channels[i].details.name
		local originalname = tab.channels[i].details.originalname
		local released = tab.channels[i].details.released
--		debug_in_file(name .. ' / ' .. originalname .. ' ' .. released .. '\n','d://info_test.txt')
		if (name and name == title or originalname and originalname == title) and released and tonumber(released) == tonumber(year) then
			if tab.channels[i].details.bg_poster and tab.channels[i].details.bg_poster.backdrop and m_simpleTV.Control.MainMode == 0 then
				m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = tab.channels[i].details.bg_poster.backdrop, TypeBackColor = 0, UseLogo = 3, Once = 1})
			end
			local poster = tab.channels[i].details.poster or tab.channels[i].details.wide_poster or 'http://web.vokino.tv/img/icons/img-torrent-empty.svg'
			local country = tab.channels[i].details.country or ''
			local genre = tab.channels[i].details.genre or ''
			local about = tab.channels[i].details.about or ''
			local imdb_r = tab.channels[i].details.rating_imdb or ''
			local kp_r = tab.channels[i].details.rating_kp or ''
			local type = tab.channels[i].details.type
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="3.5" src="' .. poster .. '"', text = country .. '\n' .. genre .. '\nIMDb: ' .. imdb_r .. ', KP: ' .. kp_r .. '\n' .. type .. '\n' .. released , showTime = 5000,0xFF00,3})
			return media_desc, background, about
		end
		i=i+1
	end
	return
end
--[[
local function GetEPG_Id(name)
	name = xren(name:gsub('%-','%-'):gsub('%+','%+'):gsub('%.','%.'))
	if not m_simpleTV.User.TVPortal.EPG then
		local epg = m_simpleTV.Database.GetTable('SELECT * FROM ChannelsEpg ORDER BY Id')
		if epg == nil or epg[1] == nil then
			return false, false
		end

		local t,j = {},1
		for i = 1,#epg do
			local all_names = xren(epg[i].ChName:gsub('%-','%-'):gsub('%+','%+'):gsub('%.','%.')) .. ';'
			for w in all_names:gmatch('.-%;') do
				local title = w:gsub('%;','')
				t[j] = {}
				t[j].Name_EPG = title
				t[j].Id_EPG = epg[i].Id
				t[j].Logo_EPG = epg[i].Logo
				j = j + 1
			end
			i = i + 1
		end
		if j == 1 then return false, false end
		m_simpleTV.User.TVPortal.EPG = t -- база EPG с t[j].Name_EPG, t[j].Id_EPG, t[j].Logo_EPG
	end
	for i = 1,#m_simpleTV.User.TVPortal.EPG do
		if m_simpleTV.User.TVPortal.EPG[i].Name_EPG == name then
			return m_simpleTV.User.TVPortal.EPG[i].Id_EPG, m_simpleTV.User.TVPortal.EPG[i].Logo_EPG
		end
	end
	return false, false
end
--]]
local function GetEPG_Id(name)

	local epg = m_simpleTV.Database.GetTable('SELECT * FROM ChannelsEpg WHERE ((ChannelsEpg.ChName LIKE "' .. name .. ';%" OR ChannelsEpg.ChName LIKE "%;' .. name .. ';%" OR ChannelsEpg.ChName LIKE "%;' .. name .. '" OR ChannelsEpg.ChName LIKE "' .. name .. '" ))')

	if epg == nil or epg[1] == nil then
		return false, false
	else
		return epg[1].Id,epg[1].Logo:gsub('https://picon%.pp%.ua/','https://epgx.site/p/')
	end

end

local function GetEPG_Simple_For_Id(id,ch_name,ch_logo,active)
	local epgTitle,epgDesc,epgTitle1,epgDesc1,epgCategory,epgCategory1,StartFor,EndFor,StartForN,StartForH,StartForM,EndForN,EndForH,EndForM,prtime,timeH,timeM,prendtime
	local curTime = os.date('%Y-%m-%d %X', os.time() + 1)
	if m_simpleTV.User.TVPortal.EpgOffsetRequest and active == true then
		curTime = os.date('%Y-%m-%d %X', os.time() + 1 - tonumber(m_simpleTV.User.TVPortal.EpgOffsetRequest)/1000)
	end
--	debug_in_file(curTime .. ': ' .. (os.time() + 1) .. ' - ' .. (m_simpleTV.User.TVPortal.EpgOffsetRequest or 0) .. '\n','c://1/offset.txt')
	local sql = 'SELECT * FROM ChProg WHERE IdChannel=="' .. id .. '"' .. ' AND StartPr <= "' .. curTime .. '" AND EndPr > "' .. curTime .. '"'
	local epgT = m_simpleTV.Database.GetTable(sql)
	if epgT ~= nil and epgT[1] ~= nil then
		epgTitle = epgT[1].Title
		epgDesc  = epgT[1].Desc
		epgCategory = epgT[1].Category or ''
		StartFor = epgT[1].StartPr:gsub('-$--$--$', '')
		EndFor   = epgT[1].EndPr
	end
	local sql1 = 'SELECT * FROM ChProg WHERE IdChannel=="' .. id .. '"' .. ' AND StartPr > "' .. curTime .. '"'
	local epgT1 = m_simpleTV.Database.GetTable(sql1)
	if epgT1 ~= nil and epgT1[1] ~= nil then
		epgTitle1 = epgT1[1].Title
		epgDesc1  = epgT1[1].Desc
		epgCategory1 = epgT1[1].Category or ''
	end
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

	if epgCategory1 and epgCategory1 ~= '' then epgCategory1 = ' (' .. epgCategory1 .. ')' else epgCategory1 = '' end
	local str1, str2 = ch_name .. '\n', ''
	local titleepg
	if epgTitle and StartFor and EndFor then
		str1 = str1 .. epgTitle ..  '\n' .. epgCategory .. ' (' .. StartForH .. ':' .. StartForM .. ' - '  .. EndForH .. ':' .. EndForM .. ') ' .. prtime .. ' мин.'
		titleepg = clean_title(epgTitle)
	end
--	if epgDesc then
--		str1 = str1 .. epgDesc
--	end

	if epgTitle1 then
		str1 = str1 .. '\nдалее: ' .. epgTitle1 .. epgCategory1
	end
	return epgTitle,str1
end
-----------------------------------
local function GetEPG_For_Id(id,ch_name,ch_logo)
	local epgTitle,epgDesc,epgTitle1,epgDesc1,epgCategory,epgCategory1,StartFor,EndFor,StartForN,StartForH,StartForM,EndForN,EndForH,EndForM,prtime,timeH,timeM,prendtime
	local curTime = os.date('%Y-%m-%d %X', os.time() + 1)
	if m_simpleTV.User.TVPortal.EpgOffsetRequest then
		curTime = os.date('%Y-%m-%d %X', os.time() + 1 - tonumber(m_simpleTV.User.TVPortal.EpgOffsetRequest)/1000)
	end
--	debug_in_file(curTime .. ': ' .. (os.time() + 1) .. ' - ' .. (m_simpleTV.User.TVPortal.EpgOffsetRequest or 0) .. '\n','c://1/offset.txt')
	local sql = 'SELECT * FROM ChProg WHERE IdChannel=="' .. id .. '"' .. ' AND StartPr <= "' .. curTime .. '" AND EndPr > "' .. curTime .. '"'
	local epgT = m_simpleTV.Database.GetTable(sql)
	if epgT ~= nil and epgT[1] ~= nil then
		epgTitle = epgT[1].Title
		epgDesc  = epgT[1].Desc
		epgCategory = epgT[1].Category
		StartFor = epgT[1].StartPr:gsub('-$--$--$', '')
		EndFor   = epgT[1].EndPr
	end
	local sql1 = 'SELECT * FROM ChProg WHERE IdChannel=="' .. id .. '"' .. ' AND StartPr > "' .. curTime .. '"'
	local epgT1 = m_simpleTV.Database.GetTable(sql1)
	if epgT1 ~= nil and epgT1[1] ~= nil then
		epgTitle1 = epgT1[1].Title
		epgDesc1  = epgT1[1].Desc
		epgCategory1 = epgT1[1].Category
	end
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
	local str1, str2 = '<td style="padding: 10px 10px 0px; color: #EBEBEB;" valign="middle"><h3><font color="#00FF7F">' .. ch_name .. '</font></h3>', ''
	local titleepg, yearepg, str3, backgroundepg
	if epgTitle and StartFor and EndFor then
		str1 = str1 .. '<h4><i><font color="#BBBBBB">' .. epgTitle ..  '</font></i><p>' .. epgCategory .. '<font color="#CD7F32">(' .. StartForH .. ':' .. StartForM .. ' - '  .. EndForH .. ':' .. EndForM .. ')</font> <b>' .. prtime .. ' мин.</b></h4>' .. '</td></tr></table>'
		titleepg = clean_title(epgTitle)
	end
	if epgDesc then
		str1 = str1 .. '<table width="100%"><tr><td style="padding: 0px 10px 10px;" valign="middle" width="100%"><h5><font color="#EBEBEB">' .. epgDesc ..  '</font></h5>'
		yearepg = titleepg:match('^.-(%d%d%d%d).-$') or epgDesc:match('^.-(%d%d%d%d).-$') or 0
	end
	if titleepg and yearepg then
		if ch_name:match('KBC') then titleepg = titleepg:gsub(' 4K.-$',''):gsub(' %d%d%d%d$','') end
--		debug_in_file(titleepg .. ' / ' .. yearepg .. '\n','c://1/foxinfo.txt')
		str3,backgroundepg = info_fox(titleepg:gsub(' %(.-$',''):gsub(' %d%d%d%d.-$',''),yearepg,ch_logo)
	end

	if backgroundepg and backgroundepg ~= '' and backgrounde ~= ch_logo then
		epg_logo = backgroundepg
		if m_simpleTV.Control.MainMode == 0 then
			m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = epg_logo, TypeBackColor = 0, UseLogo = 3, Once = 1})
		end
	end
	str1 = '<html><body bgcolor="#182633"><table width="100%"><tr><td style="padding: 10px 10px 0px; color: #EBEBEB;">' .. '<img src="' .. (epg_logo or ch_logo) .. '" width="240">' .. '</td>' .. str1
	if epgTitle1 then
		str1 = str1 .. '<p><h4><font color="#CD7F32">далее: </font><i><font color="#BBBBBB">' .. epgTitle1 .. epgCategory1 .. '</font></i></h4>'
	end
	str1 = str1 .. '</td></tr></table></body></html>'
	return epgTitle,str1
end
-----------------------------------

local function GetAdr(adr)
	for i = 1,#m_simpleTV.User.TVPortal.Channel_Of_Group do
		if adr == m_simpleTV.User.TVPortal.Channel_Of_Group[i].Address then
			if not m_simpleTV.User.TVPortal.Channel_Of_Group[i].Address1:match('XXXXXXXXXX') then
				if not m_simpleTV.User.EdemWS then
					m_simpleTV.User.EdemWS = {}
				end
				m_simpleTV.User.EdemWS.channel = nil
				m_simpleTV.User.EdemWS.channel_ott = nil
			end
			return m_simpleTV.User.TVPortal.Channel_Of_Group[i].Address1, m_simpleTV.User.TVPortal.Channel_Of_Group[i].Logo
		end
	end
end

local function findChannelIdinPortal(adr, extFilter, typeMedia)
	local t = m_simpleTV.Database.GetTable('SELECT Channels.Id FROM Channels WHERE Channels.Address="' .. adr .. '" AND Channels.Id<268435455 AND Channels.TypeMedia=' .. typeMedia .. ' AND Channels.ExtFilter=' .. extFilter .. ';')
--	debug_in_file('SELECT Channels.Id FROM Channels WHERE Channels.Address="' .. adr .. '" AND Channels.Id<268435455 AND Channels.TypeMedia=' .. typeMedia .. ' AND Channels.ExtFilter=' .. extFilter .. ';', 'c://1/debug.txt')
	if t and t[1] and t[1].Id then
		return true
	end
	return false
end

function AddPortalTVAddressToPlaylist()
	-- ADD option: if not ExtFilter FAV TV and FAV Media then ADD
	local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="FAV TV";')
	if is_portal == nil or is_portal[1] == nil then
		is_portal = m_simpleTV.Database.GetTable('SELECT (MAX(ExtFilter.Id))+1 AS NewId FROM ExtFilter;')
		local Filter_ID = is_portal[1].NewId
		if is_portal == nil or is_portal[1] == nil or Filter_ID == '' then
			Filter_ID =  1
		end
		if m_simpleTV.Database.ExecuteSql('INSERT INTO ExtFilter ([Id],[Name],[TypeMedia],[Pressed],[Logo],[Comment]) VALUES (' .. Filter_ID .. ',"FAV TV",' .. 0 .. ',' .. 0 ..',"https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png","Вспомогательный фильтр для PortalTV");') then
			m_simpleTV.PlayList.Refresh()
			m_simpleTV.User.TVPortal.ID_TV_Filter = Filter_ID
		end
	else
		if not m_simpleTV.User.TVPortal.ID_TV_Filter then
			m_simpleTV.User.TVPortal.ID_TV_Filter = is_portal[1].Id
		end
	end
	local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="FAV Media";')
	if is_portal == nil or is_portal[1] == nil then
		is_portal = m_simpleTV.Database.GetTable('SELECT (MAX(ExtFilter.Id))+1 AS NewId FROM ExtFilter;')
		local Filter_ID = is_portal[1].NewId
		if m_simpleTV.Database.ExecuteSql('INSERT INTO ExtFilter ([Id],[Name],[TypeMedia],[Pressed],[Logo],[Comment]) VALUES (' .. Filter_ID .. ',"FAV Media",' .. 3 .. ',' .. 0 ..',"https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png","Вспомогательный фильтр для PortalTV");') then
			m_simpleTV.PlayList.Refresh()
			m_simpleTV.User.TVPortal.ID_Media_Filter = Filter_ID
		end
	else
		if not m_simpleTV.User.TVPortal.ID_Media_Filter then
			m_simpleTV.User.TVPortal.ID_Media_Filter = is_portal[1].Id
		end
	end
--	m_simpleTV.OSD.ShowMessageT({text = m_simpleTV.User.TVPortal.ID_Media_Filter .. '/' .. m_simpleTV.User.TVPortal.ID_TV_Filter .. '/' .. m_simpleTV.User.TVPortal.Id, color = 0xff9999ff})
	----------------------
	local t = m_simpleTV.Database.GetTable('SELECT * FROM channels WHERE Id==' .. m_simpleTV.User.TVPortal.Id)
	if t == nil or t[1] == nil then
		return m_simpleTV.OSD.ShowMessageT({text = 'NOT ID', color = 0xff9999ff})
	end
	local title = t[1].Name
	local logo = t[1].Logo
	local EpgId = t[1].EpgId
	local RawM3UString = t[1].RawM3UString
	local State = t[1].State
	local adr = m_simpleTV.Control.CurrentAddress
	local extFilter, typeMedia
	if m_simpleTV.User.TVPortal.IsMedia == true then
		extFilter = m_simpleTV.User.TVPortal.ID_Media_Filter
		typeMedia = 3
	else
		extFilter = m_simpleTV.User.TVPortal.ID_TV_Filter
		typeMedia = 0
	end
	local GetIs = findChannelIdinPortal(adr, extFilter, typeMedia)
	if  GetIs ~= false then
		m_simpleTV.OSD.ShowMessageT({text = 'Канал добавлен ранее', color = 0xff9999ff})
	else
		t = m_simpleTV.Database.GetTable('SELECT (MAX(Channels.Id))+1 AS NewId FROM Channels WHERE Channels.Id<268435456 AND Channels.Id<>268435455;')
		if not t or not t[1] or not t[1].NewId then
		return m_simpleTV.OSD.ShowMessageT({text = 'NOT ADD ID', color = 0xff9999ff})
		end
		channelId = t[1].NewId
--		debug_in_file('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Address],[Group],[EpgId],[ExtFilter],[TypeMedia],[Logo],[Fav],[RawM3UString],[State]) VALUES (' .. t[1].NewId .. ',' .. t[1].NewId .. ',"' .. title .. '","' .. adr .. '",' .. 0 .. ',"' .. EpgId .. '",' .. extFilter ..',' .. typeMedia .. ',"' .. logo .. '",' .. 1 .. ',' .. "'" .. (RawM3UString or ''):gsub('\r',''):gsub('\r',''):gsub('\n',''):gsub("'",'´') .. "'," ..  State .. ');\n', 'c://1/debug.txt')

		if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Address],[Group],[EpgId],[ExtFilter],[TypeMedia],[Logo],[Fav],[RawM3UString],[State]) VALUES (' .. t[1].NewId .. ',' .. t[1].NewId .. ',"' .. title .. '","' .. adr .. '",' .. 0 .. ',"' .. EpgId .. '",' .. extFilter ..',' .. typeMedia .. ',"' .. logo .. '",' .. 1 .. ',' .. "'" .. (RawM3UString or ''):gsub('\r',''):gsub('\r',''):gsub('\n',''):gsub("'",'´') .. "'," ..  State .. ');') then
		m_simpleTV.PlayList.Refresh()
		m_simpleTV.OSD.ShowMessageT({text = 'Канал добавлен', color = 0xff9999ff})
		end
	end
end

function GetPortalTableForTVPortal()
	local t = m_simpleTV.User.TVPortal.Channel_Of_Group
	if stena_desc_tvportal_content and m_simpleTV.User.TVPortal.UseDesc == 1 then
		return get_stena_desc_tvportal_content(tonumber(m_simpleTV.User.TVPortal.Channel_id))
	end
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Group ', ButtonScript = 'start_tv()'}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Filters ', ButtonScript = 'get_group_with_filter()'}
--[[	if m_simpleTV.User.TVPortal.start_adr == 'portalTV_search=' then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Search ', ButtonScript = 'SelectTVPortal_search()'}
	else
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' TVPortal ', ButtonScript = 'SelectTVPortal()'}
	end]]
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2', StopOnError = 0, StopAfterPlay = 0, PlayMode = 2}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.TVPortal.Group_name .. ' - ' .. #t .. ' ch.', tonumber(m_simpleTV.User.TVPortal.Channel_id)-1, t, 10000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalTV";')
			local Filter_ID = is_portal[1].Id
			local epg_id,epg_logo = GetEPG_Id(m_simpleTV.User.TVPortal.Channel_Of_Group[id].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub(' ⟲.-$',''):gsub('^ ',''))
			if epg_id == false then epg_id = "simpleTVFakeEpgId" end
			local logo = m_simpleTV.User.TVPortal.Channel_Of_Group[id].Logo
			if epg_logo and m_simpleTV.User.TVPortal.Channel_Of_Group[id].Logo == '' then
				logo = epg_logo
			end
			if logo == '' or logo == nil then
				logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png'
			end
			m_simpleTV.Database.ExecuteSql('DELETE FROM Channels WHERE (Channels.Id=' .. m_simpleTV.User.TVPortal.Id .. ');', true)
			if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Address],[Group],[ExtFilter],[TypeMedia],[EpgId],[Logo],[LastPosition],[UpdateID],[RawM3UString],[State]) VALUES (' .. m_simpleTV.User.TVPortal.Id .. ',' .. m_simpleTV.User.TVPortal.Id .. ',"' .. m_simpleTV.User.TVPortal.Channel_Of_Group[id].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub("'",'´'):gsub(' ⟲.-$',''):gsub(' $',''):gsub(' orig$',''):gsub(' 50$','') .. '","portalTV=' .. m_simpleTV.User.TVPortal.Group_id .. '&channel=' .. id .. '",' .. 0 .. ',' .. Filter_ID ..',' .. 0 .. ',"' .. '' .. '","' .. logo .. '",' .. 0 .. ',"PortalTV",' .. "'" .. (m_simpleTV.User.TVPortal.Channel_Of_Group[id].RawM3UString or '') .. "'," .. m_simpleTV.User.TVPortal.Channel_Of_Group[id].State .. ');') then
				m_simpleTV.PlayList.Refresh()
			end
			m_simpleTV.PlayList.VerifyItem(m_simpleTV.User.TVPortal.Id, false)
			m_simpleTV.PlayList.SetFocusItem(m_simpleTV.User.TVPortal.Id, m_simpleTV.Interface.GetFullScreenMode())
			m_simpleTV.Control.SetPosition(0.0)
			m_simpleTV.Control.PlayAddressT({ address = '$InternationalID=' .. m_simpleTV.User.TVPortal.Id, timeshiftOffset = 0})
		end
		if ret == 2 then
			return start_tv()
		end
		if ret == 3 then
			return get_group_with_filter()
--[[			if m_simpleTV.User.TVPortal.start_adr == 'portalTV_search=' then
				SelectTVPortal_search()
			else
				SelectTVPortal()
			end]]
		end
end

function playaddress_from_stena(id1)
	id1 = id1:match('(%d+)') or 1
	local id = (tonumber(m_simpleTV.User.TVPortal.stena_tvportal_page) - 1) * 60 + tonumber(id1)
	local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalTV";')
	local Filter_ID = is_portal[1].Id
	local epg_id,epg_logo = GetEPG_Id(m_simpleTV.User.TVPortal.Channel_Of_Group[id].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub(' ⟲.-$',''):gsub('^ ',''))
	if epg_id == false then epg_id = "simpleTVFakeEpgId" end
	local logo = m_simpleTV.User.TVPortal.Channel_Of_Group[id].Logo
	if epg_logo and m_simpleTV.User.TVPortal.Channel_Of_Group[id].Logo == '' then
		logo = epg_logo
	end
	if logo == '' or logo == nil then
		logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png'
	end
	m_simpleTV.Database.ExecuteSql('DELETE FROM Channels WHERE (Channels.Id=' .. m_simpleTV.User.TVPortal.Id .. ');', true)
	if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Address],[Group],[ExtFilter],[TypeMedia],[EpgId],[Logo],[LastPosition],[UpdateID],[RawM3UString],[State]) VALUES (' .. m_simpleTV.User.TVPortal.Id .. ',' .. m_simpleTV.User.TVPortal.Id .. ',"' .. m_simpleTV.User.TVPortal.Channel_Of_Group[id].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub("'",'´'):gsub(' ⟲.-$',''):gsub(' ⟲.-$',''):gsub(' $',''):gsub(' orig$',''):gsub(' 50$','') .. '","portalTV=' .. m_simpleTV.User.TVPortal.Group_id .. '&channel=' .. id .. '",' .. 0 .. ',' .. Filter_ID ..',' .. 0 .. ',"' .. '' .. '","' .. logo .. '",' .. 0 .. ',"PortalTV",' .. "'" .. (m_simpleTV.User.TVPortal.Channel_Of_Group[id].RawM3UString or '') .. "'," .. m_simpleTV.User.TVPortal.Channel_Of_Group[id].State .. ');') then
		m_simpleTV.PlayList.Refresh()
	end
	stena_clear()
	m_simpleTV.User.TVPortal.is_stena = false
	m_simpleTV.PlayList.VerifyItem(m_simpleTV.User.TVPortal.Id, false)
	m_simpleTV.PlayList.SetFocusItem(m_simpleTV.User.TVPortal.Id, m_simpleTV.Interface.GetFullScreenMode())
	m_simpleTV.Control.SetPosition(0.0)
	m_simpleTV.Control.PlayAddressT({ address = '$InternationalID=' .. m_simpleTV.User.TVPortal.Id, timeshiftOffset = 0})
end

local function check_logo(logo,session)

	local rc, answer = m_simpleTV.Http.Request(session, {url = logo})
	if rc ~= 200 then return nil end
	return logo

end

function get_stena_desc_tvportal_content(id)
	if m_simpleTV.User.TVPortal.is_forced then
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0')
		if not session then return false end
		m_simpleTV.Http.SetTimeout(session, 1000)
	end
	if not id then id = 1
--	m_simpleTV.Control.ChangeAddress = 'No'
--	m_simpleTV.Control.CurrentAddress = 'wait'
	end
	local page = math.ceil(tonumber(id)/60)
	local id1 = id - (math.ceil(tonumber(id)/60) - 1)*60
	local t, j = {}, 1
	for i = 1,#m_simpleTV.User.TVPortal.Channel_Of_Group do
		if i > (page - 1) * 60 and i <= page * 60 then
			t[j] = m_simpleTV.User.TVPortal.Channel_Of_Group[i]
			if m_simpleTV.User.TVPortal.is_forced then
			t[j].Logo = check_logo(t[j].Logo,session)
			end
			j = j + 1
		end
		i = i + 1
	end
	m_simpleTV.User.TVPortal.Channel_Of_Group_stena_current_id = id
	m_simpleTV.User.TVPortal.Channel_Of_Group_stena = t
	m_simpleTV.User.TVPortal.Channel_Of_Group_stena_current = id1
	m_simpleTV.User.TVPortal.stena_tvportal_page = page
	m_simpleTV.User.TVPortal.stena_tvportal_allpage = math.ceil(#m_simpleTV.User.TVPortal.Channel_Of_Group/60)

		if tonumber(page) < tonumber(m_simpleTV.User.TVPortal.stena_tvportal_allpage) then
		m_simpleTV.User.TVPortal.stena_tvportal_next = tonumber(page)+1
		else
		m_simpleTV.User.TVPortal.stena_tvportal_next = nil
		end
		if tonumber(page) > 1 then
		m_simpleTV.User.TVPortal.stena_tvportal_prev = tonumber(page)-1
		else
		m_simpleTV.User.TVPortal.stena_tvportal_prev = nil
		end

	return stena_desc_tvportal_content()
end

function stena_tvportal_prev()
	get_stena_desc_tvportal_content((tonumber(m_simpleTV.User.TVPortal.stena_tvportal_prev) - 1)*60 + 1)
end

function stena_tvportal_next()
	get_stena_desc_tvportal_content((tonumber(m_simpleTV.User.TVPortal.stena_tvportal_next) - 1)*60 + 1)
end

function select_tvportal_page()
	local t = {}
	for i = 1,tonumber(m_simpleTV.User.TVPortal.stena_tvportal_allpage) do
		t[i] = {}
		t[i].Id = i
		t[i].Name = i
	end
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Select page', tonumber(m_simpleTV.User.TVPortal.stena_tvportal_page)-1, t, 5000, 'ALWAYS_OK | MODAL_MODE')
	if ret == -1 or not id then
		return
	end
	if ret == 1 then
		get_stena_desc_tvportal_content((tonumber(id)-1) * 60 + 1)
	end
end

function get_EPG_for_id_channel(id1)
	local active = false
	if id1:match('active') then active = true end
	id1 = id1:match('(%d+)') or 1
	local chn = (tonumber(m_simpleTV.User.TVPortal.stena_tvportal_page) - 1) * 60 + tonumber(id1)
	local epg_id,epg_logo = GetEPG_Id(m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub(' orig$',''):gsub(' %[.-$',''):gsub(' ⟲.-$',''):gsub('%&apos%;',"'"):gsub('^ ',''),active)
	if epg_id == false then epg_id = "simpleTVFakeEpgId" end
	local logo = m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].Logo
	if epg_logo and logo == '' then
		logo = epg_logo
	end
	if logo == '' or logo == nil then
		logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png'
	end
	if epg_id then
		epg_title,desc = GetEPG_Simple_For_Id(epg_id,m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''),logo,active)
	end

	local t, AddElement = {}, m_simpleTV.OSD.AddElement
	local t1 = m_simpleTV.User.TVPortal.Channel_Of_Group_stena
		if m_simpleTV.User.TVPortal.stena_tvportal_cur_content_adr == nil or t1[tonumber(id1)].Address ~= m_simpleTV.User.TVPortal.stena_tvportal_cur_content_adr then
			m_simpleTV.User.TVPortal.stena_tvportal_cur_content_adr = t1[tonumber(id1)].Address

				t = {}
				t.id = 'STENA_TVPORTAL_CONTENT_IMG_ID'
				t.cx=110
				t.cy=110
				t.class="IMAGE"
				t.imagepath = logo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 20
			    t.top  = 80
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'ID_DIV_STENA_2')

				t = {}
				t.id = 'STENA_TVPORTAL_CONTENT_TXT_ID'
				t.cx=900
				t.cy=0
				t.class="TEXT"
				t.text = desc:gsub('<.->','') .. '\n\n\n\n\n\n'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = -13 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
--				t.boundWidth = 1000
				t.row_limit=6
				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 150
			    t.top  = 80
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')

		end
end

if pll then
--	debug_in_file(m_simpleTV.Common.multiByteToUTF8(pll) .. '\n')
	if pll:match('ID=(%d+)') then
		local Channels_Filter = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE (ExtFilter.Id=' .. tonumber(pll:match('ID=(%d+)')) .. '); ')
		if Channels_Filter == nil or Channels_Filter[1] == nil then
			return false
		end
		local channelId,channelName = findChannelIdByAddress(inAdr)
		if channelId then
			m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = channelName
			m_simpleTV.OSD.ShowMessageT({text = 'Плейлист есть в базе', color = ARGB(255, 155, 155, 255)})
		else
			local t = m_simpleTV.Database.GetTable('SELECT (MAX(Channels.Id))+1 AS NewId FROM Channels WHERE Channels.Id<268435456 AND Channels.Id<>268435455;')
			if not t or not t[1] or not t[1].NewId then return start_tv() end
			channelId = t[1].NewId
			local title = Channels_Filter[1].Name or Get_title_pll()
			local logo = Channels_Filter[1].Logo or m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Unknown.png'
			local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalPLL";')
			if is_portal == nil or is_portal[1] == nil then
				is_portal = m_simpleTV.Database.GetTable('SELECT (MAX(ExtFilter.Id))+1 AS NewId FROM ExtFilter;')

				local Filter_ID = is_portal[1].NewId
				if is_portal == nil or is_portal[1] == nil or Filter_ID == '' then
					Filter_ID =  1
				end

				if m_simpleTV.Database.ExecuteSql('INSERT INTO ExtFilter ([Id],[Name],[TypeMedia],[Pressed],[Logo],[Comment]) VALUES (' .. Filter_ID .. ',"PortalPLL",' .. 2 .. ',' .. 0 ..',"https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png","Вспомогательный фильтр для PortalPLL");') then
					m_simpleTV.PlayList.Refresh()
				end
			end
			if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Logo],[Address],[ExtFilter],[TypeMedia]) VALUES (' .. channelId .. ',' .. channelId .. ',"' .. title .. '","' .. logo .. '","' .. inAdr .. '",' .. is_portal[1].Id ..',' .. 2 .. ');') then
				m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = title
				m_simpleTV.PlayList.Refresh()
				m_simpleTV.OSD.ShowMessageT({text = 'Плейлист добавлен', color = ARGB(255, 155, 155, 255)})
			end
		end
		return select_stena_logo(Channels_Filter[1].Id, Channels_Filter[1].Name)
	end
	m_simpleTV.Interface.CopyToClipboard(m_simpleTV.Common.multiByteToUTF8(pll))
	return add_to_portal_playlist()
end

if stalker_pll then
	local StalkerId, StalkerName = findChannelIdByAddress('portalTV_stalker_playlist=' .. stalker_pll)
	if StalkerId and StalkerName then
		local is_stalker = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="StalkerPLL";')
		if not is_stalker or not is_stalker[1] or not is_stalker[1].Id then
			return
		end
		setConfigVal('StalkerPLL',StalkerId)
		m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = StalkerName
		return get_stalker(StalkerId, StalkerName, is_stalker[1].Id)
	end
	return
end

if m_simpleTV.User.TVPortal.Channel_Of_Group == nil then
	local channelId, channelName = findChannelIdByAddress('portalTV_playlist=' .. (getConfigVal('tvportal') or ''))
	if channelId then
		m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = channelName
	else
		m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = get_name_from_slots((getConfigVal('tvportal') or ''))
	end
	local is_extfilter = getConfigVal('tvportal')
	if search_grp then
		m_simpleTV.User.TVPortal.Group_id = tonumber(grp)
		m_simpleTV.User.TVPortal.Channel_id = chn
		return start_tv_search()
	else
		m_simpleTV.User.TVPortal.Group_id = tonumber(grp)
		m_simpleTV.User.TVPortal.Channel_id = chn
		m_simpleTV.User.TVPortal.Filter_type = getConfigVal('tvportal_filters') or 0
		if is_extfilter and is_extfilter:match('^ID=(%d+)') then
			select_stena_logo(is_extfilter:match('^ID=(%d+)'), m_simpleTV.User.TVPortal.Current_Playlist_PortalTV, true)
		else
			start_tv(false,true,m_simpleTV.User.TVPortal.Filter_type)
		end
	end
end

if m_simpleTV.User.filmix==nil then m_simpleTV.User.filmix={} end
if m_simpleTV.User.rezka==nil then m_simpleTV.User.rezka={} end
if m_simpleTV.User.TMDB==nil then m_simpleTV.User.TMDB={} end
if m_simpleTV.User.collaps==nil then m_simpleTV.User.collaps={} end
if m_simpleTV.User.torrent==nil then m_simpleTV.User.torrent={} end
if m_simpleTV.User.hevc==nil then m_simpleTV.User.hevc={} end
if m_simpleTV.User.AudioWS==nil then m_simpleTV.User.AudioWS={} end
m_simpleTV.User.filmix.CurAddress = nil
m_simpleTV.User.rezka.CurAddress = nil
m_simpleTV.User.TMDB.Id = nil
m_simpleTV.User.TMDB.tv = nil
m_simpleTV.User.collaps.ua = nil
m_simpleTV.User.collaps.kinogo = nil
m_simpleTV.User.torrent.content = nil
m_simpleTV.User.hevc.content = nil
m_simpleTV.User.AudioWS.TrackCash = nil
m_simpleTV.User.rezka.ThumbsInfo = nil
if m_simpleTV.User.westSide then
	m_simpleTV.User.westSide.PortalTable = true
end
m_simpleTV.User.TVPortal.PortalTable = true
m_simpleTV.User.TVPortal.is_stena = false

local t = m_simpleTV.User.TVPortal.Channel_Of_Group
if t == nil then return end
t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Group ', ButtonScript = 'start_tv()'}
if search_grp then
	m_simpleTV.User.TVPortal.start_adr = 'portalTV_search='
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Search ', ButtonScript = 'SelectTVPortal_search()'}
else
	m_simpleTV.User.TVPortal.start_adr = 'portalTV='
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' TVPortal ', ButtonScript = 'SelectTVPortal()'}
end
t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2', StopOnError = -1, StopAfterPlay = -1, PlayMode = -1}

--GetPortalTableForTVPortal()


	local __,id = m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.TVPortal.Group_name .. ' - ' .. #t .. ' ch.', tonumber(chn) - 1, t, 10000, 2 + 32)
	id = id or 1
	m_simpleTV.User.TVPortal.Channel_id = tonumber(chn)

	local retAdr, logo = GetAdr(t[tonumber(chn)].Address)
--	retAdr = CheckAddress(retAdr)

	m_simpleTV.Control.CurrentTitle_UTF8 = t[tonumber(chn)].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub(' ⟲.-$',''):gsub('%&apos%;',"'"):gsub('^ ','')
	m_simpleTV.Control.SetTitle(t[tonumber(chn)].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub(' ⟲.-$',''):gsub('%&apos%;',"'"):gsub('^ ',''))
			local is_portal = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE Name=="PortalTV";')
			local Filter_ID = is_portal[1].Id
			local epg_id,epg_logo = GetEPG_Id(m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub(' orig$',''):gsub(' %[.-$',''):gsub(' ⟲.-$',''):gsub('%&apos%;',"'"):gsub('^ ',''))
			if epg_id == false then epg_id = "simpleTVFakeEpgId" end
			if epg_logo and logo == '' then
				logo = epg_logo
			end
			if logo == '' or logo == nil then
				logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png'
			end
			local media_title, media_desc, background
			local name_for_media = m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].Name:gsub('\r',''):gsub(' ⟲.-$',''):gsub(' orig$',''):gsub('г%.$',''):gsub('%.$',''):gsub('4k | ',''):gsub('4K | ',''):gsub('%&apos%;',"'"):gsub('^ ','')
			local year = name_for_media:match(' %((%d%d%d%d)%)$') or name_for_media:match(' (%d%d%d%d)$')
	if name_for_media:match(' E%d+$') or name_for_media:match(' e%d+$') or name_for_media:match('%d+ серия') or name_for_media:match('%(Фильм') then
		epg_id,epg_logo = nil,nil
		year = 0
		name_for_media = name_for_media:gsub(' S%d+.-$', ''):gsub(' s%d+.-$', ''):gsub(' E%d+.-$', ''):gsub(' e%d+.-$', ''):gsub(' %(%d+ сезон.-$', ''):gsub(' %d+ сезон.-$', ''):gsub(' %(Фильм.-$', '')
	end
	if retAdr:match('%.mp4') or retAdr:match('%.mkv') or retAdr:match('%.avi') then
		epg_id,epg_logo = nil,nil
		year = year or 0
		name_for_media = name_for_media:gsub(' %(.-$', ''):gsub(' ч%..-$', ''):gsub('%d+%.', '')
	end
	if name_for_media:match('Fox Кинозалы') or name_for_media:match('Fox Сериалы') then
		epg_id,epg_logo = nil,nil
		m_simpleTV.User.TVPortal.IsFoxRoom = true
	else
		m_simpleTV.User.TVPortal.IsFoxRoom = false
	end
	if year then
		name_for_media = name_for_media:gsub(' %- Украинский', ''):gsub(' %(Color%)', ''):gsub('пьесса','пьеса')
		epg_id,epg_logo = nil,nil
		local title_rus = name_for_media:gsub(' /.-$', ''):gsub('%(4K%)', ''):gsub(' %(мини%-сериал%)', ''):gsub('%(%+18%)', ''):gsub('%(Special%)', ''):gsub(' %- ', ' – '):gsub(' %(.-%d+%)$', ''):gsub(' %d+$', ''):gsub('%(color%)', ''):gsub(' %(.-$', '')
		local title_orig = name_for_media:gsub('^.-/ ', ''):gsub('%(4K%)', ''):gsub('%(4%)', ''):gsub(' %(мини%-сериал%)', ''):gsub('%(%+18%)', ''):gsub('%(Special%)', ''):gsub(' %- ', ' – '):gsub('%(.-%d+%)$', ''):gsub(' %d+$', ''):gsub('%(color%)', '') or title_rus

---------------заплатки (FOX)
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
		if title_rus == '12 разгневанных мужчин' then year = 1957 end
		if title_orig:match('Приключения Петрова и Васечкина') then year = 1983 end
		if title_orig:match('Бриллиантовая рука') then year = 1969 end
		if title_orig:match('Федорино горе') then year = 1973 end
		if title_rus:match('Майами') and title_orig == 'New in Town' then year = 2009 end
		if title_orig:match('Неоконченная пьеса') then	year = 1977 end
		title_orig = title_orig:gsub('%: %d+ серия$', ''):gsub(' %d+ серия$', ''):gsub(' chapter %d+$', ''):gsub('Сокровища Агри', 'Сокровища Агры'):gsub('20%-й Век начинается', 'Двадцатый век начинается')
-----------------------
		local imdb_id = retAdr:match('%((tt%d+)%)')
		local kp_id = retAdr:match('%(kp%-(%d+)%)')
		if kp_id and not imdb_id then imdb_id = IMDB(kp_id) end
		if imdb_id and cor_title_year(imdb_id) then
		local title1,year1 = cor_title_year(imdb_id)
		media_desc, background, media_title = info_fox(title1,year1,logo)
		else
		media_desc, background, media_title = info_fox(title_orig:gsub(' $', ''),year,logo)
		end
--		Get_info(title_rus, year) -- for test
		if m_simpleTV.Control.MainMode == 0 and background and background ~= '' then
			m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = background, TypeBackColor = 0, UseLogo = 3, Once = 1})
			logo = background
		end
		if media_desc and media_desc ~= '' then
			media_desc = '<html><body bgcolor="#182633">' .. media_desc:gsub('<a href.-</a>','') .. '</body></html>'
--			debug_in_file(media_desc .. '\n','c://1/info.txt')
		end
		if media_desc == '' then media_title = 'нет описания' end
	end

			m_simpleTV.Database.ExecuteSql('DELETE FROM Channels WHERE (Channels.Id=' .. m_simpleTV.User.TVPortal.Id .. ');', true)
--			debug_in_file('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Address],[Group],[ExtFilter],[TypeMedia],[EpgId],[Logo],[LastPosition],[UpdateID],[RawM3UString],[State],[Title],[Desc]) VALUES (' .. m_simpleTV.User.TVPortal.Id .. ',' .. m_simpleTV.User.TVPortal.Id .. ',"' .. m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].InfoPanelName:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub('\n',''):gsub('\r',''):gsub('\n',''):gsub("'",'´') .. '","portalTV=' .. m_simpleTV.User.TVPortal.Group_id .. '&channel=' .. tonumber(chn) .. '",' .. 0 .. ',' .. Filter_ID ..',' .. 0 .. ',"' .. (epg_id or '') .. '","' .. logo .. '",' .. 0 .. ',"PortalTV",' .. "'" .. (m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].RawM3UString or ''):gsub('\r',''):gsub('\r',''):gsub('\n',''):gsub("'",'´') .. "'," .. m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].State .. ",'" .. (media_title or ""):gsub("'",'´') .. "','" .. (media_desc or ''):gsub("'",'´') .. "');" .. '\n','d://zapros_sql.txt')
			if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Address],[Group],[ExtFilter],[TypeMedia],[EpgId],[Logo],[LastPosition],[UpdateID],[RawM3UString],[State],[Title],[Desc]) VALUES (' .. m_simpleTV.User.TVPortal.Id .. ',' .. m_simpleTV.User.TVPortal.Id .. ',"' .. m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''):gsub('\n',''):gsub('\r',''):gsub('\n',''):gsub("'",'´'):gsub(' %[.-$',''):gsub(' ⟲.-$',''):gsub(' $',''):gsub(' orig$',''):gsub(' 50$','') .. '","' .. m_simpleTV.User.TVPortal.start_adr .. m_simpleTV.User.TVPortal.Group_id .. '&channel=' .. tonumber(chn) .. '",' .. 0 .. ',' .. Filter_ID ..',' .. 0 .. ',"' .. (epg_id or '') .. '","' .. logo .. '",' .. 0 .. ',"PortalTV",' .. "'" .. (m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].RawM3UString or ''):gsub('\r',''):gsub('\r',''):gsub('\n',''):gsub("'",'´') .. "'," .. m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].State .. ",'" .. (media_title or ""):gsub("'",'´') .. "','" .. (media_desc or ''):gsub("'",'´') .. "');") then
				m_simpleTV.PlayList.Refresh()
			end

			if m_simpleTV.Timeshift.EpgOffsetRequest and m_simpleTV.Timeshift.EpgOffsetRequest > 0 then
				m_simpleTV.User.TVPortal.EpgOffsetRequest = m_simpleTV.Timeshift.EpgOffsetRequest
			else
				m_simpleTV.User.TVPortal.EpgOffsetRequest = 0
			end
			if epg_id then
--				m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].Logo = logo
				epg_title,desc = GetEPG_Simple_For_Id(epg_id,m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].Name:gsub('^.-: ',''):gsub('^.-: ',''):gsub('\r',''),logo,true)
				m_simpleTV.User.TVPortal.IsMedia = false
--				m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].InfoPanelTitle = epg_title
--				m_simpleTV.User.TVPortal.Channel_Of_Group[tonumber(chn)].InfoPanelDesc = desc
			else
				m_simpleTV.User.TVPortal.IsMedia = true
			end
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.CurrentAddress = retAdr
	m_simpleTV.Control.SetNewAddressT({address = retAdr, timeshiftOffset = m_simpleTV.User.TVPortal.EpgOffsetRequest})
