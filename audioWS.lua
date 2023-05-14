-- startup Audio plugin
-- author west_side 06.03.23

	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.AudioWS==nil then m_simpleTV.User.AudioWS={} end
	if m_simpleTV.User.AudioWS.images==nil then m_simpleTV.User.AudioWS.images={} end

	function AudioWSevent()
		local t = m_simpleTV.Control.GetCurrentChannelInfo()
		if t~=nil and t.Address~=nil then
			m_simpleTV.Control.CurrentAdress = t.Address
			m_simpleTV.Control.Reason = 'Playing'
			dofile (m_simpleTV.MainScriptDir .. 'user/audioWS/events.lua')
		end
	end
	m_simpleTV.User.AudioWS.Use = 1
	AddFileToExecute('events', m_simpleTV.MainScriptDir .. 'user/audioWS/events.lua')
	AddFileToExecute('getaddress', m_simpleTV.MainScriptDir .. 'user/audioWS/getaddress.lua')
	AddFileToExecute('onconfig',m_simpleTV.MainScriptDir .. "user/audioWS/initconfig.lua")
	m_simpleTV.OSD.AddEventListener({type=1,callback='AudioWSevent'})

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

	value= getConfigVal("AudioWS_Cookies") or ''
	m_simpleTV.User.AudioWS.Cookies = value
