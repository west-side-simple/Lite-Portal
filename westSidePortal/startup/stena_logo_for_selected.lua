-- Видеоскрипт для формирования стены лого медиапортала TV выбранных каналов и групп - дополнение меню плейлиста (26.01.2024)
local function get_group_name(groupId)
	local Channels_Filter = m_simpleTV.Database.GetTable('SELECT * FROM Channels WHERE (Channels.Id>268435455) AND Channels.Id = ' .. tonumber(groupId) .. '; ')
	if Channels_Filter == nil or Channels_Filter[1] == nil then
		return false
	end
	return Channels_Filter[1].Name
end

local function get_filter_name(filterId)
	local Channels_Filter = m_simpleTV.Database.GetTable('SELECT * FROM ExtFilter WHERE ExtFilter.Id = ' .. tonumber(filterId) .. '; ')
	if Channels_Filter == nil or Channels_Filter[1] == nil then
		return false
	end
	return Channels_Filter[1].Name
end

function select_stena_logo_for_selected(filterId)

	local Channels_Selected = m_simpleTV.PlayList.GetSelectedItems()

	if Channels_Selected == nil or Channels_Selected[1] == nil then
		return
	end

	m_simpleTV.Config.SetValue('tvportal','tvportal',"PortalTV.ini")
	local t, j = {}, 1
	for i = 1,#Channels_Selected do
		local Channels_Filter
		if tonumber(Channels_Selected[i]) <= 268435455 then
			Channels_Filter = m_simpleTV.Database.GetTable('SELECT * FROM Channels WHERE (Channels.Id=' .. tonumber(Channels_Selected[i]) .. '); ')
			t[j] = {}
			t[j].NameCh = Channels_Filter[1].Name
			t[j].AddressCh = Channels_Filter[1].Address:gsub('http://domen_name','domen_name'):gsub('http://torrent://INFOHASH','torrent://INFOHASH')
			t[j].GroupCh = 'Selected'
			t[j].LogoCh = Channels_Filter[1].Logo
			t[j].M3UCh = Channels_Filter[1].RawM3UString:gsub('duration', 'offset')
			t[j].StateCh = Channels_Filter[1].State
			j = j + 1
		else
			local Channels_Filter1 = m_simpleTV.Database.GetTable('SELECT * FROM Channels; ')
			for m = 1,#Channels_Filter1 do
			if tonumber(Channels_Filter1[m].Group)==tonumber(Channels_Selected[i]) and tonumber(Channels_Filter1[m].Id) > 268435455 then
				for k = 1,#Channels_Filter1 do
				if tonumber(Channels_Filter1[k].Group)==tonumber(Channels_Filter1[m].Id) and tonumber(Channels_Filter1[k].Id) <= 268435455 and (filterId and tonumber(Channels_Filter1[k].ExtFilter)==tonumber(filterId) or not filterId) then
						local group_name = get_group_name(Channels_Filter1[k].Group)
						local extfilter_name = get_filter_name(Channels_Filter1[k].ExtFilter)
						t[j] = {}
						t[j].NameCh = Channels_Filter1[k].Name
						t[j].AddressCh = Channels_Filter1[k].Address:gsub('http://domen_name','domen_name'):gsub('http://torrent://INFOHASH','torrent://INFOHASH')
						t[j].GroupCh = group_name .. ' (' .. extfilter_name .. ')'
						t[j].LogoCh = Channels_Filter1[k].Logo
						t[j].M3UCh = Channels_Filter1[k].RawM3UString:gsub('duration', 'offset')
						t[j].StateCh = Channels_Filter1[k].State
						j = j + 1
				end
				end
			elseif tonumber(Channels_Filter1[m].Group)==tonumber(Channels_Selected[i]) and tonumber(Channels_Filter1[m].Id) <= 268435455 and (filterId and tonumber(Channels_Filter1[m].ExtFilter)==tonumber(filterId) or not filterId) then
				local group_name = get_group_name(Channels_Filter1[m].Group)
				local extfilter_name = get_filter_name(Channels_Filter1[m].ExtFilter)
					t[j] = {}
					t[j].NameCh = Channels_Filter1[m].Name
					t[j].AddressCh = Channels_Filter1[m].Address:gsub('http://domen_name','domen_name'):gsub('http://torrent://INFOHASH','torrent://INFOHASH')
					t[j].GroupCh = group_name .. ' (' .. extfilter_name .. ')'
					t[j].LogoCh = Channels_Filter1[m].Logo
					t[j].M3UCh = Channels_Filter1[m].RawM3UString:gsub('duration', 'offset')
					t[j].StateCh = Channels_Filter1[m].State
					j = j + 1
			end
			m = m + 1
			end
		end
		i = i + 1
	end
	if i == 1 then return false end
	if j == 1 then return false end
	table.sort(t, function(a, b) return tostring(a.GroupCh) < tostring(b.GroupCh) end)
	m_simpleTV.User.TVPortal.Channel = t
	m_simpleTV.User.TVPortal.Current_Playlist_PortalTV = 'Selected'
	m_simpleTV.User.TVPortal.Address_PortalTV_0 = 'Плейлисты'
	return start_tv()
end
