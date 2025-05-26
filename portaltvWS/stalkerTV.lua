-- Видеоскрипт для воспроизведения Stalker portala (03.09.2024)
-- author west_side, GitHub: https://github.com/west-side-simple
-- Открывает ссылки:
-- stalker=...
-- ===============================================================================================================

if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
local inAdr = m_simpleTV.Control.CurrentAdress
if not inAdr then return end
if not inAdr:match('^stalker=')
then return end

m_simpleTV.Control.ChangeAdress = 'Yes'

local portal = inAdr:match('stalker=(.-)$'):gsub('&.-$','')
local mac = inAdr:match('mac=(.-)$'):gsub('&.-$','')
local adr = inAdr:match('adr=(.-)$'):gsub('$.-$','')
local url = inAdr:match('url=(.-)$'):gsub('&.-$','')
local rc, answer
if not adr:match('token=') then
rc, answer = m_simpleTV.Http.Request(m_simpleTV.User.TVPortal.stalker_session, {method='post', url = url, body = 'type=itv&action=create_link&cmd=' .. adr .. '&series=0&forced_storage=0&disable_ad=0&download=0&force_ch_link_check=0&JsHttpRequest=1-xml', headers = 'Referer: ' .. portal .. '\nContent-Type: application/x-www-form-urlencoded;charset=UTF-8\nAccept: */*\nAuthorization: Bearer ' .. m_simpleTV.User.TVPortal.stalker_token .. '\nX-User-Agent: Model: MAG250; Link: WiFi\nCookie: mac=' .. mac .. '; stb_lang=en; timezone=Europe%2FParis'})
if rc~=200 then
	return m_simpleTV.OSD.ShowMessageT({text = 'Ошибка получения стрима \nдля выбранного MAC канала-плейлиста Stalker.', color = ARGB(255, 155, 155, 255)})
end
--debug_in_file(answer .. '\n','c://1/str_js.txt')
if not answer then return end
end
local retAdr = answer and answer:match('"cmd":"(.-)"') or adr
retAdr = retAdr:gsub('\\',''):gsub('^.-%s','')
m_simpleTV.Control.SetNewAddress(retAdr)