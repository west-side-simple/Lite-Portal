if package.loaded['tvs_core'] and package.loaded['tvs_func'] then
    local tmp_sources = tvs_core.tvs_GetSourceParam() or {} -- загрузка списка источников из sources.lua
    for SID, v in pairs(tmp_sources) do
         if v.name:find('Filmix Best') -- некий признак группы источников, или из таблицы отбирать как-то
--		 or v.name:find('Wink Media') 
--		 or v.name:find('Wink UFC')
--		 or v.name:find('Wink сериалы')
--		 or v.name:find('CatCast all')
--		 or v.name:find('Kubic')
--		 or v.name:find('Tuni4ok')
		 or v.name:find('DENMS TV')
		 then 
            tvs_func.OSD_mess('Пакет скраперов WS 🔄 ' .. v.name )
            tvs_core.UpdateSource(SID, true) -- процедура обновления
            -- следующие 2 команды не обязательно, можно потестить необходимость
            collectgarbage()
            m_simpleTV.Common.Wait(2000)
         end
    end
end