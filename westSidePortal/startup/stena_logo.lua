-- Видеоскрипт для формирования стены лого медиапортала TV выбранного фильтра - дополнение меню фильтра (02.04.25)

local function get_group_name(groupId)
--	debug_in_file((groupId or 'NOT') .. '\n','c://1/group.txt')
	if tonumber(groupId) == nil then return 'UnGroup' end
	local Channels_Filter = m_simpleTV.Database.GetTable('SELECT * FROM Channels WHERE (Channels.Id>268435455) AND Channels.Id = ' .. tonumber(groupId) .. '; ')
	if Channels_Filter == nil or Channels_Filter[1] == nil then
		return 'UnGroup'
	end
	return Channels_Filter[1].Name
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
			if t and t[1] and t[1].Id and t[1].Name then return t[1].Id,t[1].Name end
	end
 return nil
end

function get_token_stalker(url, mac, portal, session)
	if not url or not portal or not mac or not session then
		return
	end
	local rc, answer = m_simpleTV.Http.Request(session, {method='post', url = url, body = 'type=stb&action=handshake', headers = 'Cookie: mac=' .. mac})
	if rc~=200 then
		return
	end
--	debug_in_file(answer .. '\n','c://1/answer_token.txt')
	local token = answer:match('"token":"(.-)"')
	if not token then return end
	local random_str = answer:match('"random":"(.-)"')
	if not random_str then
		local data = '0123456789abcdef'
		random_str = ''
		for i = 1,40 do
			local random_data = math.random(16)
			random_str = data:sub(random_data, random_data) .. random_str
		end
	end
	return token, random_str
end

function select_mac(id, NameForId, adr, desc, ExtFilterID, portal, session, play)
	local t,i = {},1
	local activ_mac = desc:match('<strong>%[.-(%S%S:%S%S:%S%S:%S%S:%S%S:%S%S)')
	local activ_index = 1
	local pars = '%S%S:%S%S:%S%S:%S%S:%S%S:%S%S'
	if desc:match('logn=') then pars = '%[.-%]' end
	for w in desc:gmatch(pars) do
		local mac = w:match('(%S%S:%S%S:%S%S:%S%S:%S%S:%S%S)')
		if mac == nil then break end
		local serial = w:match('sern=(.-)\n') or m_simpleTV.Common.CryptographicHash(mac, 'Md5', true)
		local device1 = w:match('dev1=(.-)\n') or m_simpleTV.Common.CryptographicHash(mac, 'Sha256', true)
		local device2 = w:match('dev2=(.-)\n') or device1
		local login = w:match('logn=(.-)\n')
		local password = w:match('pass=(.-)\n')
		local is_logpass = login and password
		t[i] = {}
		t[i].Id = i
		t[i].Name = mac
		t[i].Ser = serial:sub(1,13):upper()
		t[i].Dev1 = device1:upper()
		t[i].Dev2 = device2:upper()
		if login and password then
			t[i].Login = login
			t[i].Password = password
		end
		t[i].Is_logpass = is_logpass
		t[i].Address = adr
		if mac == activ_mac then activ_index = i end
		i=i+1
	end
	local ret, id1
--	play = true
	if not play then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' StalkerPLL '}
		m_simpleTV.Common.Sleep(200)
		ret, id1 = m_simpleTV.OSD.ShowSelect_UTF8(NameForId .. ': Выберите MAC', tonumber(activ_index)-1, t, 10000, 1+4+8+2)
	else
		ret = 1
		id1 = tonumber(activ_index) or 1
	end
	if ret == -1 or not id1 then
		return
	end
	if ret == 1 then

		local token, random_str = get_token_stalker(t[id1].Address, t[id1].Name, portal, session)
		if not token then
			m_simpleTV.OSD.ShowMessageT({text = 'Ошибка выбранного MAC для канала-плейлиста Stalker', color = ARGB(255, 155, 155, 255)})
			return select_mac(id, NameForId, adr, desc, ExtFilterID, portal, session, play)
		end
		local str = ''
		for i = 1,#t do
			local str1 = ''
			if t[i].Ser and t[i].Is_logpass then
				str1 = str1 .. '\nsern=' .. t[i].Ser
			end
			if t[i].Dev1 and t[i].Is_logpass then
				str1 = str1 .. '\ndev1=' .. t[i].Dev1
			end
			if t[i].Dev2 and t[i].Is_logpass then
				str1 = str1 .. '\ndev2=' .. t[i].Dev2
			end
			if t[i].Login and t[i].Password then
				str1 = str1 .. '\nlogn=' .. t[i].Login .. '\npass=' .. t[i].Password .. '\n'
			end
			if tonumber(id1) == i then
				str = str .. '<strong>[' .. t[i].Name .. str1 .. ']</strong>\n'
			else
				str = str .. '[' .. t[i].Name .. str1 .. ']\n'
			end
			i = i + 1
		end
		m_simpleTV.Database.ExecuteSql('UPDATE Channels SET Desc="' .. str .. '" WHERE (Channels.Id = ' .. id .. '); ')
		m_simpleTV.PlayList.Refresh()

--		debug_in_file(t[id1].Name .. '\n' .. t[id1].Ser .. '\n' .. t[id1].Dev1 .. '\n' .. t[id1].Dev2 .. '\n------------\n','c://1/mac_.txt')

		local rc, answer = m_simpleTV.Http.Request(session, {method='post', url = t[id1].Address, body = 'type=stb&action=get_profile&hd=1&ver=ImageDescription: 0.2.18-r23-250; ImageDate: Wed Aug 29 10:49:53 EEST 2018; PORTAL version: 5.1.0; API Version: JS API version: 343; STB API version: 146; Player Engine version: 0x58c&num_banks=2&sn=' .. t[id1].Ser .. '&stb_type=MAG250&image_version=218&video_out=hdmi&device_id=' .. t[id1].Dev1 .. '&device_id2=' .. t[id1].Dev2 .. '&signature=&auth_second_step=1&hw_version=1.7-BD-00&not_valid_token=0&client_type=STB&hw_version_2=41b1b83de56bfcf125bc137cf91f03d5&timestamp='.. os.time() ..'&api_signature=263&metrics={"mac":"' .. t[id1].Name .. '","sn":"' .. t[id1].Ser .. '","model":"MAG250","type":"STB","uid":"","random":"' .. random_str .. '"}&JsHttpRequest=1-xml', headers = 'Referer: ' .. portal .. '\nContent-Type: application/x-www-form-urlencoded;charset=UTF-8\nAccept: */*\nAuthorization: Bearer ' .. token .. '\nX-User-Agent: Model: MAG250; Link: WiFi\nCookie: mac=' .. t[id1].Name .. '; stb_lang=en; timezone=Europe%2FParis'})
		if rc~=200 then
			m_simpleTV.OSD.ShowMessageT({text = 'Ошибка получения профиля \nдля выбранного MAC канала-плейлиста Stalker', color = ARGB(255, 155, 155, 255)})
			return select_mac(id, NameForId, adr, str, ExtFilterID, portal, session)
		end
--		debug_in_file(unescape3(answer) .. '\n','c://1/prof_js.txt')

--		local is_Authentication = ''
		if answer:match('"msg":"Device conflict') then
			m_simpleTV.OSD.ShowMessageT({text = 'Конфликт устройства для выбранного MAC канала-плейлиста Stalker.', color = ARGB(255, 155, 155, 255)})
			return select_mac(id, NameForId, adr, str, ExtFilterID, portal, session)
		end
		if answer:match('"msg":"Authentication request"') then
			if not t[id1].Login or not t[id1].Password then
				m_simpleTV.OSD.ShowMessageT({text = 'Нужны данные авторизации для выбранного MAC канала-плейлиста Stalker.', color = ARGB(255, 155, 155, 255)})
				return select_mac(id, NameForId, adr, str, ExtFilterID, portal, session)
			end
			rc, answer = m_simpleTV.Http.Request(session, {method='post', url = t[id1].Address, body = 'type=stb&action=do_auth&login=' .. t[id1].Login .. '&password=' .. t[id1].Password, headers = 'Referer: ' .. portal .. '\nContent-Type: application/x-www-form-urlencoded;charset=UTF-8\nAccept: */*\nAuthorization: Bearer ' .. token .. '\nX-User-Agent: Model: MAG250; Link: WiFi\nCookie: mac=' .. t[id1].Name .. '; stb_lang=en; timezone=Europe%2FParis'})
			if rc~=200 then
				m_simpleTV.OSD.ShowMessageT({text = 'Ошибка авторизации для выбранного MAC канала-плейлиста Stalker.', color = ARGB(255, 155, 155, 255)})
				return select_mac(id, NameForId, adr, str, ExtFilterID, portal, session)
			end
--			is_Authentication = '&login=' .. t[id1].Login .. '&password=' .. t[id1].Password
		end
		rc, answer = m_simpleTV.Http.Request(session, {method='post', url = t[id1].Address, body = 'type=itv&action=get_genres&JsHttpRequest=1-xml', headers = 'Referer: ' .. portal .. '\nContent-Type: application/x-www-form-urlencoded;charset=UTF-8\nAccept: */*\nAuthorization: Bearer ' .. token .. '\nX-User-Agent: Model: MAG250; Link: WiFi\nCookie: mac=' .. t[id1].Name .. '; stb_lang=en; timezone=Europe%2FParis'})
		if rc~=200 then
			m_simpleTV.OSD.ShowMessageT({text = 'Ошибка получения групп плейлиста \nдля выбранного MAC канала-плейлиста Stalker.', color = ARGB(255, 155, 155, 255)})
			return select_mac(id, NameForId, adr, str, ExtFilterID, portal, session)
		end
--		debug_in_file(answer .. '\n','c://1/gr_js.txt')
		local t3, j = {}, 1
		for w in answer:gmatch('"id".-"alias"') do
			local id_group, title_group = w:match('"id":"(.-)".-"title":"(.-)"')
			if not id_group or not title_group then break end
			t3[j] = {}
			t3[j].id_group = id_group
			t3[j].title_group = unescape3(title_group):gsub('\\/',' / ')
--			debug_in_file(t3[j].id_group .. '\n' .. t3[j].title_group .. '\n','c://1/ch_js.txt')
			j = j + 1
		end
		rc, answer = m_simpleTV.Http.Request(session, {method='post', url = t[id1].Address, body = 'type=itv&action=get_all_channels&JsHttpRequest=1-xml', headers = 'Referer: ' .. portal .. '\nContent-Type: application/x-www-form-urlencoded;charset=UTF-8\nAccept: */*\nAuthorization: Bearer ' .. token .. '\nX-User-Agent: Model: MAG250; Link: WiFi\nCookie: mac=' .. t[id1].Name .. '; stb_lang=en; timezone=Europe%2FParis'})
		if rc~=200 or rc==200 and not answer then
			m_simpleTV.OSD.ShowMessageT({text = 'Ошибка получения каналов плейлиста \nдля выбранного MAC канала-плейлиста Stalker.', color = ARGB(255, 155, 155, 255)})
			return select_mac(id, NameForId, adr, str, ExtFilterID, portal, session)
		end
--		debug_in_file(answer .. '\n','c://1/ch_js.txt')
---------------------------

		local t2, i = {}, 1
		for w in answer:gmatch('"name":.-"lock"') do
			local name = w:match('"name":"(.-)"')
			local adr = w:match('"cmd":"(.-)"')
			local days = w:match('"tv_archive_duration":"(%d+)') or 0
			local logo = w:match('"logo":"(.-)"') or ''
			if portal:match('stb%.homeiptv%.org') or portal:match('stb%.freeott%.top') or portal:match('portal%.wisp%.cat') then
				logo = 'http://play.wisp.cat/logos/' .. logo
			end
			if portal:match('vodofun%.tv') then
				logo = 'http://vodofun.tv/stalker_portal/misc/logos/320/' .. logo
			end
			local group = w:match('"tv_genre_id":"(.-)"') or 'Not Group'
			if not adr or not name then break end
			days = tonumber(days)/24
			if not name:match('##') then
			t2[i] = {}
			t2[i].NameCh = unescape3(name):gsub('^%S%S%S%s%-%s',''):gsub('^%S%S%s%-%s',''):gsub('^%S%S%S:%s',''):gsub('^%S%S:%s',''):gsub('^|%S%S%S|%s',''):gsub('^|%S%S|%s',''):gsub('^%S%S%S|',''):gsub('^%S%S|',''):gsub('^%s+',''):gsub('%s+$',''):gsub('^%S%S%s|%s',''):gsub('^%S%S%S%s|%s',''):gsub('^%(%S%S%)%s',''):gsub('^%[%S%S%S%]%s',''):gsub('^%[%S%S%]%s',''):gsub('\\','')
--			t2[i].AddressCh = 'stalker=' .. portal .. '&mac=' .. t[id1].Name .. is_Authentication .. '&url=' .. t[id1].Address .. '&adr=' .. adr:gsub('\\/', '/')
			t2[i].AddressCh = 'stalker=' .. portal .. '&mac=' .. t[id1].Name .. '&url=' .. t[id1].Address .. '&adr=' .. adr:gsub('\\/', '/')
--			debug_in_file(t2[i].AddressCh .. '\n')
			for k = 1,#t3 do
				if tostring(t3[k].id_group) == tostring(group) then
					group = t3[k].title_group
				end
			end
			t2[i].GroupCh = group
			t2[i].LogoCh = logo:gsub('\\','')
			t2[i].M3UCh = 'catchup-days="' .. days .. '" catchup-type="flussonic"'
			if days and tonumber(days) > 0 then
				t2[i].StateCh = 2
			else
				t2[i].StateCh = 0
			end
			i=i+1
			end
		end
		if #t2==0 then
			m_simpleTV.OSD.ShowMessageT({text = 'Нет каналов плейлиста \nдля выбранного MAC канала-плейлиста Stalker.', color = ARGB(255, 155, 155, 255)})
			return select_mac(id, NameForId, adr, str, ExtFilterID, portal, session)
		end
		m_simpleTV.OSD.ShowMessageT({text = 'Сформирован плейлист \nдля выбранного MAC канала-плейлиста Stalker.\nПриятного просмотра.', color = ARGB(255, 155, 155, 255)})
		table.sort(t2, function(a, b) return tostring(a.GroupCh) < tostring(b.GroupCh) end)
		m_simpleTV.User.TVPortal.Channel = t2
		if m_simpleTV.User.TVPortal.Channel then
		--------------------для теста закомментировать
			m_simpleTV.User.TVPortal.stalker_session = session
			m_simpleTV.User.TVPortal.stalker_token = token
			return start_tv(nil, play)
		--------------------
		end
---------------------------
		local cmd = t2[1].AddressCh:match('adr=(.-)$')
		if not cmd then
			m_simpleTV.OSD.ShowMessageT({text = 'Ошибка получения стрима \nдля выбранного MAC канала-плейлиста Stalker.', color = ARGB(255, 155, 155, 255)})
			return select_mac(id, NameForId, adr, str, ExtFilterID, portal, session)
		end
		cmd = cmd:gsub('\\',''):gsub(' ','%%20')
		rc, answer = m_simpleTV.Http.Request(session, {method='post', url = t[id1].Address, body = 'type=itv&action=create_link&cmd=' .. cmd .. '&series=0&forced_storage=0&disable_ad=0&download=0&force_ch_link_check=0&JsHttpRequest=1-xml', headers = 'Referer: ' .. portal .. '\nContent-Type: application/x-www-form-urlencoded;charset=UTF-8\nAccept: */*\nAuthorization: Bearer ' .. token .. '\nX-User-Agent: Model: MAG250; Link: WiFi\nCookie: mac=' .. t[id1].Name .. '; stb_lang=en; timezone=Europe%2FParis'})
		if rc~=200 then
			m_simpleTV.OSD.ShowMessageT({text = 'Ошибка получения стрима \nдля выбранного MAC канала-плейлиста Stalker.', color = ARGB(255, 155, 155, 255)})
			return select_mac(id, NameForId, adr, str, ExtFilterID, portal, session)
		end
--		debug_in_file(answer .. '\n','c://1/str_js.txt')

		cmd = answer:match('"cmd":"(.-)"')
		cmd = cmd:gsub('\\',''):gsub('^.-%s','')
		return m_simpleTV.Control.PlayAddressT({ address = cmd, title = 'TEST'})
	end
	if ret == 2 then
		select_playlist_PLL(ExtFilterID, 'StalkerPLL', id)
	end
end

function get_stalker(id, NameForId, ExtFilterID)
	local t = m_simpleTV.Database.GetTable('SELECT Channels.Id,Channels.Name,Channels.Address,Channels.Desc FROM Channels WHERE Channels.Id="' .. id .. '" AND Channels.Id<268435455;')
	if t == nil or t[1] == nil or t[1].Address == nil or t[1].Desc == nil then
		m_simpleTV.OSD.ShowMessageT({text = 'Внесите данные в Desc канала-плейлиста Stalker', color = ARGB(255, 155, 155, 255)})
		return
	end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local url = t[1].Address:gsub('^.-http','http') .. 'xpcom.common.js'
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 or not answer or not answer:match('this%.get_server_params') then
		m_simpleTV.OSD.ShowMessageT({text = NameForId .. ': Ошибка загрузчика канала-плейлиста Stalker,\n возможно нужен ВПН', color = ARGB(255, 155, 155, 255)})
		m_simpleTV.Http.Close(session)
		return select_playlist_PLL(ExtFilterID, 'StalkerPLL', id)
	end
	local data = answer:match('this%.get_server_params.-this%.ajax_loader(.-)%;')
	if not data then
		m_simpleTV.OSD.ShowMessageT({text = NameForId .. ': Ошибка загрузчика канала-плейлиста Stalker', color = ARGB(255, 155, 155, 255)})
		m_simpleTV.Http.Close(session)
		return select_playlist_PLL(ExtFilterID, 'StalkerPLL', id)
	end
	local plus
	for w in data:gmatch('\'.-\'') do
		plus = w:match('\'(.-)\'')
	end
	if not plus then
		m_simpleTV.OSD.ShowMessageT({text = NameForId .. ': Ошибка загрузчика канала-плейлиста Stalker', color = ARGB(255, 155, 155, 255)})
		m_simpleTV.Http.Close(session)
		return select_playlist_PLL(ExtFilterID, 'StalkerPLL', id)
	end
	local adr = t[1].Address:gsub('^.-http','http'):gsub('/c/','/') .. plus:gsub('^/','')
	m_simpleTV.OSD.ShowMessageT({text = NameForId .. ': Загрузчик канала-плейлиста Stalker,\nAddress=' .. adr, color = ARGB(255, 155, 155, 255)})
	return select_mac(id, NameForId, adr, t[1].Desc, ExtFilterID, t[1].Address:gsub('^.-http','http'), session)
end

function select_playlist_PLL(ExtFilterID, ExtFilterName, Pllid)
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
	end
	local t = m_simpleTV.Database.GetTable('SELECT Channels.Id,Channels.Name FROM Channels WHERE Channels.ExtFilter="' .. ExtFilterID .. '" AND Channels.Id<268435455;')
	if not Pllid then
		if ExtFilterName == 'StalkerPLL' then
			Pllid = getConfigVal('StalkerPLL')
		end
		if ExtFilterName == 'PortalPLL' then
			Pllid = getConfigVal('PortalPLL')
		end
	end
	if t == nil then return end
	local t1 = {}
	local cur_id = 1
	for i = 1,#t do
		t1[i] = {}
		t1[i].Id = i
		t1[i].Name = t[i].Name
		t1[i].Action = t[i].Id
		if Pllid and tonumber(t1[i].Action) == tonumber(Pllid) then
			cur_id = i
		end
	end
	if get_all_playlists then
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' Playlists '}
	end
	if SelectTVPortal then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' PortalTV '}
	end
	m_simpleTV.Common.Sleep(200)
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(ExtFilterName .. ': Select playlist', tonumber(cur_id)-1, t1, 10000, 1+4+8+2)
	if ret == -1 or not id then
		return
	end
	if ret == 1 then
		if ExtFilterName == 'StalkerPLL' then
			m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = t1[id].Name
			setConfigVal('StalkerPLL',t1[id].Action)
			return get_stalker(t1[id].Action, t1[id].Name, ExtFilterID)
		end
		m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = t1[id].Name
		setConfigVal('PortalPLL',t1[id].Action)
		m_simpleTV.Control.PlayAddressT({ address = '$InternationalID=' .. t1[id].Action})
	end
	if ret == 2 then
		return get_all_playlists()
	end
	if ret == 3 then
		return SelectTVPortal()
	end
end

function get_all_playlists()
	local playlists = m_simpleTV.Database.GetTable("SELECT * FROM ExtFilter WHERE Name <> 'PortalTV' AND Name <> 'FAV TV' AND Name <> 'FAV Media' AND Name <> 'PortalPLL' AND Name <> 'StalkerPLL';")
	if not playlists then
		return false
	end
	local t = {}
	local current_id = 1
	for i = 1,#playlists do
		t[i] = {}
		t[i].Id = i
		t[i].Name = playlists[i].Name
		t[i].Action = playlists[i].Id
		if m_simpleTV.User.TVPortal.Address_PortalTV_pll and tonumber(m_simpleTV.User.TVPortal.Address_PortalTV_pll) == tonumber(playlists[i].Id) then current_id = i end
	end
	if run_westSide_portal then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' PortalTV '}
	end
	if run_westSide_portal then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	end
	m_simpleTV.Common.Sleep(200)
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('TVPortal: select playlist' ,tonumber(current_id) - 1,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t[id].Name == 'PortalPLL' or t[id].Name == 'StalkerPLL' then
				return select_playlist_PLL(t[id].Action, t[id].Name)
			end
			return select_stena_logo(t[id].Action, t[id].Name)
		end
		if ret == 2 then
			return SelectTVPortal()
		end
		if ret == 3 then
			return run_westSide_portal()
		end
end

function select_stena_logo(extFilterId, Filter_Name, play)
	if not extFilterId then
		return false
	end
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
	end
	local Channels_Filter = m_simpleTV.Database.GetTable('SELECT * FROM Channels WHERE ((Channels.ExtFilter=' .. tonumber(extFilterId) .. ') AND (Channels.Id<268435455)); ')
	if Channels_Filter == nil or Channels_Filter[1] == nil then
		return false
	end

	local channelId,channelName = findChannelIdByAddress('portalTV_playlist=ID=' .. extFilterId)
	if channelId then
		m_simpleTV.OSD.ShowMessageT({text = 'Плейлист есть в базе', color = ARGB(255, 155, 155, 255)})
	else
		local t = m_simpleTV.Database.GetTable('SELECT (MAX(Channels.Id))+1 AS NewId FROM Channels WHERE Channels.Id<268435456 AND Channels.Id<>268435455;')
		if not t or not t[1] or not t[1].NewId then return start_tv() end
		channelId = t[1].NewId
		local title = Filter_Name or Get_title_pll()
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
		local logo
		local Channels_Filter1 = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE (ExtFilter.Id=' .. tonumber(extFilterId) .. '); ')
		if Channels_Filter1 ~= nil and Channels_Filter1[1] ~= nil then
			logo = Channels_Filter1[1].Logo
		else
			logo = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Unknown.png'
		end
		if m_simpleTV.Database.ExecuteSql('INSERT INTO Channels ([Id],[ChannelOrder],[Name],[Logo],[Address],[ExtFilter],[TypeMedia]) VALUES (' .. channelId .. ',' .. channelId .. ',"' .. title .. '","' .. logo .. '","' .. 'portalTV_playlist=ID=' .. extFilterId .. '",' .. is_portal[1].Id ..',' .. 2 .. ');') then
			m_simpleTV.PlayList.Refresh()
			m_simpleTV.OSD.ShowMessageT({text = 'Плейлист добавлен', color = ARGB(255, 155, 155, 255)})
		end
	end

	m_simpleTV.Config.SetValue('tvportal','ID=' .. extFilterId,"PortalTV.ini")
	local fav_ch_str = getConfigVal("Portal_TV_FavCh") or ''
	local fav_gr_str = getConfigVal("Portal_TV_FavGr") or ''
	local is_in_fav_ch_str, is_in_fav_gr_str = 0, 0
	local t = {}
	for i = 1,#Channels_Filter do
		local is_fav_ch = 0
		local is_fav_gr = 0

		t[i] = {}
		t[i].NameCh = Channels_Filter[i].Name
		t[i].AddressCh = Channels_Filter[i].Address:gsub('http://domen_name','domen_name'):gsub('http://torrent://INFOHASH','torrent://INFOHASH')
		t[i].GroupCh = get_group_name(Channels_Filter[i].Group)
		t[i].LogoCh = Channels_Filter[i].Logo
		t[i].M3UCh = Channels_Filter[i].RawM3UString:gsub('duration', 'offset')
		t[i].StateCh = Channels_Filter[i].State
		for w in fav_ch_str:gmatch('%,(.-)%,') do
			if t[i].NameCh:match(w) then is_fav_ch = 1 is_in_fav_ch_str = 1 end
		end
		for w in fav_gr_str:gmatch('%,(.-)%,') do
			if t[i].GroupCh:match(w) then is_fav_gr = 1 is_in_fav_gr_str = 1 end
		end
		t[i].fav_ch = is_fav_ch
		t[i].fav_gr = is_fav_gr
	end
	if i == 1 then return false end
	table.sort(t, function(a, b) return tostring(a.GroupCh) < tostring(b.GroupCh) end)
	m_simpleTV.User.TVPortal.Channel = t
	m_simpleTV.User.TVPortal.in_fav_ch_str = is_in_fav_ch_str
	m_simpleTV.User.TVPortal.in_fav_gr_str = is_in_fav_gr_str
	m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = Filter_Name
	m_simpleTV.User.TVPortal.Address_PortalTV_pll = extFilterId
	m_simpleTV.User.TVPortal.Address_PortalTV_0 = 'Плейлисты'
	return start_tv(false,play)
end

local _ , _ , extFilterId = ...
	local Filter_Data = m_simpleTV.Database.GetTable('SELECT Name FROM ExtFilter WHERE id=' .. (extFilterId or '').. '; ')
	local Filter_Name = ''
	if Filter_Data and Filter_Data[1] then
	   Filter_Name = Filter_Data[1].Name
	end
select_stena_logo(extFilterId, Filter_Name)
