-- поиск медиа в схемах из телепрограмы (07/08/22)
-- необходим скрипт: Lite_qt_search.lua
	function findEPGInKP(epgId)
		m_simpleTV.Control.ExecuteAction(38, 0) -- SHOW_OSD_EPG
		m_simpleTV.Control.ExecuteAction(6, 0)
	
		if not epgId then return end
		local t = m_simpleTV.Database.GetTable('SELECT * FROM ChProg WHERE (ChProg.Id=' .. epgId .. ');')
			if not t
				or not t[1]
				or not t[1].Title
			then
			 return
			end
		

		local function clean_title(s)
			s = s:gsub('%(.-%)', ' ')
			s = s:gsub('%[.-%]', ' ')
			s = s:gsub('Х/ф', '')
			s = s:gsub('х/ф', '')
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
		local w = clean_title(t[1].Title)

		m_simpleTV.Config.SetValue('search/media',escape (w),"LiteConf.ini")
		
		search_all()

	end
	local t = {}
	t.utf8 = true
	t.name = 'КиноПоиск'
	t.lua_as_scr = true
	t.luastring = 'local action,param,extParam = ...;findEPGInKP(extParam)'
	t.location = 'LOCATION_EPG_MENU' -- LOCATION_EPG_MENU
	t.image = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSide/icons/portal.png'
	m_simpleTV.Interface.AddExtMenuT(t)