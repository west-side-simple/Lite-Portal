-- ini for TVPortal plugin
-- author west_side 08.09.23

	local t ={}
		t.name = 'TVPortal WS'
		t.htmlUri = m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/configDialog.html'
		t.luaUri  = 'user/portaltvWS/configDialog.lua'
		t.iconUri  = m_simpleTV.MainScriptDir_UTF8 .. 'user/portaltvWS/img/portaltv.png'

	m_simpleTV.Config.AddExtDialogT(t)