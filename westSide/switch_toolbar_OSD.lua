
local istoolbar = m_simpleTV.Config.GetValue('osdPlaylist/toolbarShow','simpleTVConfig')

if istoolbar then m_simpleTV.Config.SetValue('osdPlaylist/toolbarShow',false,'simpleTVConfig') else m_simpleTV.Config.SetValue('osdPlaylist/toolbarShow',true,'simpleTVConfig') end

m_simpleTV.Config.Apply('NEED_MAIN_OSD_UPDATE')

m_simpleTV.Control.ExecuteAction('CHANNELLISTOSD')
