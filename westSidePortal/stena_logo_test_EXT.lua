-- Видеоскрипт для формирования стены лого медиапортала TV выбранного фильтра и групп - дополнение меню фильтра (26.01.2024)

function select_stena_logo_for_EXT(extFilterId, Filter_Name)
	if not extFilterId then
		return false
	end
	local Channels_Filter = m_simpleTV.Database.GetTable('SELECT * FROM Channels WHERE ((Channels.ExtFilter=' .. tonumber(extFilterId) .. ') AND (Channels.Id<268435455)); ')
	if Channels_Filter == nil or Channels_Filter[1] == nil then
		return false
	end
	return select_stena_logo_for_selected(extFilterId)
end

local _ , _ , extFilterId = ...
	local Filter_Data = m_simpleTV.Database.GetTable('SELECT Name FROM ExtFilter WHERE id=' .. (extFilterId or '').. '; ')
	local Filter_Name = ''
	if Filter_Data and Filter_Data[1] then
	   Filter_Name = Filter_Data[1].Name
	end

select_stena_logo_for_EXT(extFilterId, Filter_Name)
