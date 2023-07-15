if m_simpleTV.User == nil then m_simpleTV.User = {} end
if m_simpleTV.User.WestSide == nil then m_simpleTV.User.WestSide = {} end
if m_simpleTV.User.WestSide.info == nil then m_simpleTV.User.WestSide.info = 0 end

if m_simpleTV.User.WestSide.info == 0 then
    m_simpleTV.Control.ExecuteAction(7,1) --KEY_ON_PIP
    m_simpleTV.Control.ExecuteAction(64,0) --KEY_MULTIPIP
elseif m_simpleTV.User.WestSide.info == 1 then
    m_simpleTV.Control.ExecuteAction(7,0) --KEY_ON_PIP
    m_simpleTV.Control.ExecuteAction(64,1) --KEY_MULTIPIP
elseif m_simpleTV.User.WestSide.info >= 2 then
    m_simpleTV.Control.ExecuteAction(7,0) --KEY_ON_PIP
    m_simpleTV.Control.ExecuteAction(64,0) --KEY_MULTIPIP
    m_simpleTV.User.WestSide.info = -1
end
m_simpleTV.User.WestSide.info = m_simpleTV.User.WestSide.info + 1
--m_simpleTV.OSD.ShowMessageT({text='info: ' .. m_simpleTV.User.WestSide.info,id='wsInfo'})

