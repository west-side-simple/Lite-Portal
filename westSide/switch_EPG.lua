if m_simpleTV.User == nil then m_simpleTV.User = {} end
if m_simpleTV.User.WestSide == nil then m_simpleTV.User.WestSide = {} end
if m_simpleTV.User.WestSide.info == nil then m_simpleTV.User.WestSide.info = 0 end

if m_simpleTV.User.WestSide.info == 0 then
    m_simpleTV.Control.ExecuteAction(6,1) --KEY_OSD_SHOW_PLAYLIST
    m_simpleTV.Control.ExecuteAction(38,1) --KEY_SHOW_EPG
elseif m_simpleTV.User.WestSide.info == 1 then
    m_simpleTV.Control.ExecuteAction(6,0) --KEY_OSD_SHOW_PLAYLIST
    m_simpleTV.Control.ExecuteAction(38,0) --KEY_SHOW_EPG
    m_simpleTV.User.WestSide.info = -1
end
m_simpleTV.User.WestSide.info = m_simpleTV.User.WestSide.info + 1
--m_simpleTV.OSD.ShowMessageT({text='info: ' .. m_simpleTV.User.WestSide.info,id='wsInfo'})

