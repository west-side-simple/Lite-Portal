-- Видеоскрипт для страницы приветствия плеера (2023.07.01)
-- Открывает ссылку:
-- SimpleTV
-- Запускается при старте плеера кроме режима плеера - воспроизводить при старте последний адрес прошлой сессии
-- Используется для фикса title, если not m_simpleTV.Control.CurrentAdress
---------------------------------------------------------------------------------------------------------------
if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
local inAdr = m_simpleTV.Control.CurrentAdress
if not inAdr then return end
if not inAdr:match('^SimpleTV') then return end
m_simpleTV.Control.ChangeAdress = 'Yes'
local logo = m_simpleTV.Common.GetMainPath(2) ..'lite.ico'
if m_simpleTV.Control.MainMode == 0 then
	m_simpleTV.Control.ChangeChannelLogo(logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
end
m_simpleTV.Control.ExecuteAction(11)
