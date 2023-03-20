-- ini for Audio plugin
-- author west_side 07.03.23

	local t ={}
		t.name = 'Audio WS'
		t.htmlUri = m_simpleTV.MainScriptDir_UTF8 .. 'user/audioWS/configDialog.html'
		t.luaUri  = 'user/audioWS/configDialog.lua'
		t.iconUri  = m_simpleTV.MainScriptDir_UTF8 .. 'user/audioWS/img/AudioWS.png'

	m_simpleTV.Config.AddExtDialogT(t)