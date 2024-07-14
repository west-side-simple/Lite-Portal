-- Видеоскрипт для формирования стены лого медиапортала TV выбранного фильтра - дополнение меню фильтра (17.02.2024)

local function get_group_name(groupId)
--	debug_in_file((groupId or 'NOT') .. '\n','c://1/group.txt')
	if tonumber(groupId) == nil then return 'UnGroup' end
	local Channels_Filter = m_simpleTV.Database.GetTable('SELECT * FROM Channels WHERE (Channels.Id>268435455) AND Channels.Id = ' .. tonumber(groupId) .. '; ')
	if Channels_Filter == nil or Channels_Filter[1] == nil then
		return false
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

function select_playlist_PLL(ExtFilterID)
	local t = m_simpleTV.Database.GetTable('SELECT Channels.Id,Channels.Name FROM Channels WHERE Channels.ExtFilter="' .. ExtFilterID .. '" AND Channels.Id<268435455;')
	if t == nil then return end
	local t1 = {}
	for i = 1,#t do
		t1[i] = {}
		t1[i].Id = i
		t1[i].Name = t[i].Name
		t1[i].Action = t[i].Id
	end
	if get_all_playlists then
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' PortalPLL '}
	end
	if SelectTVPortal then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' PortalTV '}
	end

	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Select playlist' ,0,t1,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
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
	local playlists = m_simpleTV.Database.GetTable("SELECT * FROM ExtFilter WHERE Name <> 'PortalTV' AND Name <> 'FAV TV' AND Name <> 'FAV Media';")
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

	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('TVPortal: select playlist' ,tonumber(current_id) - 1,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t[id].Name == 'PortalPLL' then
				return select_playlist_PLL(t[id].Action)
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

function select_stena_logo(extFilterId, Filter_Name)
	if not extFilterId then
		return false
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

	m_simpleTV.Config.SetValue('tvportal','tvportal',"PortalTV.ini")
	local t = {}
	for i = 1,#Channels_Filter do
		t[i] = {}
		t[i].NameCh = Channels_Filter[i].Name
		t[i].AddressCh = Channels_Filter[i].Address:gsub('http://domen_name','domen_name'):gsub('http://torrent://INFOHASH','torrent://INFOHASH')
		t[i].GroupCh = get_group_name(Channels_Filter[i].Group)
		t[i].LogoCh = Channels_Filter[i].Logo
		t[i].M3UCh = Channels_Filter[i].RawM3UString:gsub('duration', 'offset')
		t[i].StateCh = Channels_Filter[i].State
	end
	if i == 1 then return false end
	table.sort(t, function(a, b) return tostring(a.GroupCh) < tostring(b.GroupCh) end)
	m_simpleTV.User.TVPortal.Channel = t
	m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = Filter_Name
	m_simpleTV.User.TVPortal.Address_PortalTV_pll = extFilterId
	m_simpleTV.User.TVPortal.Address_PortalTV_0 = 'Плейлисты'
	return start_tv()
end

local _ , _ , extFilterId = ...
	local Filter_Data = m_simpleTV.Database.GetTable('SELECT Name FROM ExtFilter WHERE id=' .. (extFilterId or '').. '; ')
	local Filter_Name = ''
	if Filter_Data and Filter_Data[1] then
	   Filter_Name = Filter_Data[1].Name
	end
select_stena_logo(extFilterId, Filter_Name)
