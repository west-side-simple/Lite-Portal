-- startup Audio plugin
-- author west_side 06.12.23

	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.AudioWS==nil then m_simpleTV.User.AudioWS={} end
	if m_simpleTV.User.AudioWS.images==nil then m_simpleTV.User.AudioWS.images={} end

	function GetPortalTableForAudio(title)
		local t = {}

		t[1] = {}
		t[1].Id = 1
		t[1].Name = 'Поиск в Youtube'
		t[1].Action = title
		t[2] = {}
		t[2].Id = 2
		t[2].Name = 'Поиск на сайте Google'
		t[2].Action = 'https://www.google.com/search?q=' .. m_simpleTV.Common.toPersentEncoding(title)
		t[3] = {}
		t[3].Id = 3
		t[3].Name = 'Поиск на сайте Youtube'
		t[3].Action = 'https://www.youtube.com/results?search_query=' .. m_simpleTV.Common.toPersentEncoding(title)
		t[4] = {}
		t[4].Id = 4
		t[4].Name = 'Поиск в VK'
		t[4].Action = 'https://vk.com/audios6559?q=' .. m_simpleTV.Common.toPersentEncoding(title)
		t[5] = {}
		t[5].Id = 5
		t[5].Name = 'Поиск в Яндекс Музыке'
		t[5].Action = 'https://music.yandex.ru/search?text=' .. m_simpleTV.Common.toPersentEncoding(title)

		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Поиск в браузере',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if id == 1 then
				m_simpleTV.Control.PlayAddressT({address = '-' .. t[id].Action})
			else
				m_simpleTV.Interface.OpenLink(t[id].Action)
			end
		end
	end

	function AudioWSevent(typeEvent)
		if typeEvent and tonumber(typeEvent) == 1 and m_simpleTV.User.AudioWS and m_simpleTV.User.AudioWS.stena then
			m_simpleTV.User.AudioWS.stena = false
		end
	end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"AudioWS.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"AudioWS.ini")
	end

	local value= getConfigVal("AudioWS_Enable") or 1
	m_simpleTV.User.AudioWS.Use = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.AudioWS.Use = 1
	end

	value= getConfigVal("AudioWS_Slide") or 1
	m_simpleTV.User.AudioWS.Slide = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.AudioWS.Slide = 1
	end

	value= getConfigVal("AudioWS_Hot") or 1
	m_simpleTV.User.AudioWS.Hot = 0
	if tonumber(value) == 1 then
		m_simpleTV.User.AudioWS.Hot = 1
	end

	value= getConfigVal("AudioWS_Cookies") or ''
	m_simpleTV.User.AudioWS.Cookies = value

	AddFileToExecute('events', m_simpleTV.MainScriptDir .. 'user/audioWS/events.lua')
	AddFileToExecute('getaddress', m_simpleTV.MainScriptDir .. 'user/audioWS/getaddress.lua')
	AddFileToExecute('onconfig',m_simpleTV.MainScriptDir .. "user/audioWS/initconfig.lua")
	m_simpleTV.OSD.AddEventListener({type=1,callback='AudioWSevent'})