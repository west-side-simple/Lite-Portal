-- config for dialog window Audio plugin
-- author west_side 06.03.23

	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.AudioWS==nil then m_simpleTV.User.AudioWS={} end
	if m_simpleTV.User.AudioWS.images==nil then m_simpleTV.User.AudioWS.images={} end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"AudioWS.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"AudioWS.ini")
	end

	function OnNavigateComplete(Object)
		local value
		value= getConfigVal("AudioWS_Enable") or 1
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'AudioWS_Enable',value)

		value= getConfigVal("AudioWS_Slide") or 1
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'AudioWS_Slide',value)

		value= getConfigVal("AudioWS_Cookies") or ''
		m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'AudioWS_Cookies',value)
	end

	function OnOk(Object)
		local value
		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'AudioWS_Enable')
		if value ~= nil then
			setConfigVal("AudioWS_Enable",value)
			m_simpleTV.User.AudioWS.Use = 1
			if tonumber(value) == 0 then
				m_simpleTV.User.AudioWS.Use = 0
			end
		end
		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'AudioWS_Slide')
		if value ~= nil then
			setConfigVal("AudioWS_Slide",value)
			m_simpleTV.User.AudioWS.Slide = 1
			if tonumber(value) == 0 then
				m_simpleTV.User.AudioWS.Slide = 0
			end
		end
		value=m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'AudioWS_Cookies')
		if value~=nil then
			setConfigVal("AudioWS_Cookies",value)
		end
	end
