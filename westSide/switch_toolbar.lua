
local istoolbar = m_simpleTV.Config.GetValue('standaloneplaylist/toolbarShow','simpleTVConfig')

if istoolbar then m_simpleTV.Config.SetValue('standaloneplaylist/toolbarShow',false,'simpleTVConfig') else m_simpleTV.Config.SetValue('standaloneplaylist/toolbarShow',true,'simpleTVConfig') end

m_simpleTV.Config.Apply('NEED_STANDALONE_PLAYLIST_UPDATE')
