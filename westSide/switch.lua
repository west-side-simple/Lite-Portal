if m_simpleTV.User == nil then m_simpleTV.User = {} end
if m_simpleTV.User.WestSide == nil then m_simpleTV.User.WestSide = {} end
if m_simpleTV.User.WestSide.info == nil then m_simpleTV.User.WestSide.info = 0 end

if m_simpleTV.User.WestSide.info == 0 then
    m_simpleTV.Control.ExecuteAction(161,0) --KEY_OSD_SHOW_CURRENT_EPG_DESC
    m_simpleTV.Control.ExecuteAction(65,0) --CHANNEL_INFO_OSD
    m_simpleTV.Control.ExecuteAction(36,1) --KEYOSDCURPROG
elseif m_simpleTV.User.WestSide.info == 1 then   
    m_simpleTV.Control.ExecuteAction(161,0) --KEY_OSD_SHOW_CURRENT_EPG_DESC
    m_simpleTV.Control.ExecuteAction(65,1) --CHANNEL_INFO_OSD
    m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
elseif m_simpleTV.User.WestSide.info == 2 then
    m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
    m_simpleTV.Control.ExecuteAction(161,1) --KEY_OSD_SHOW_CURRENT_EPG_DESC
    m_simpleTV.Control.ExecuteAction(65,0) --CHANNEL_INFO_OSD
elseif m_simpleTV.User.WestSide.info >= 3 then
--    m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
--    m_simpleTV.Control.ExecuteAction(65,0) --CHANNEL_INFO_OSD
--    m_simpleTV.Control.ExecuteAction(161,0) --KEY_OSD_SHOW_CURRENT_EPG_DESC
	show_portal_window() --KEY_OSD_SHOW_PORTAL_INFO
    m_simpleTV.User.WestSide.info = -1
end

m_simpleTV.User.WestSide.info = m_simpleTV.User.WestSide.info + 1
--m_simpleTV.OSD.ShowMessageT({text='info: ' .. m_simpleTV.User.WestSide.info,id='wsInfo'})

