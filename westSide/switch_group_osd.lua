if m_simpleTV.User == nil then m_simpleTV.User = {} end
if m_simpleTV.User.WestSide == nil then m_simpleTV.User.WestSide = {} end
if m_simpleTV.User.WestSide.close_group == nil then m_simpleTV.User.WestSide.close_group = 0 end

if m_simpleTV.User.WestSide.close_group == 0 then
    m_simpleTV.PlayList.Expand(true,true) --open group
elseif m_simpleTV.User.WestSide.close_group == 1 then
	m_simpleTV.PlayList.Expand(false,true) --close group
	m_simpleTV.User.WestSide.close_group = -1
end

m_simpleTV.User.WestSide.close_group = m_simpleTV.User.WestSide.close_group + 1

