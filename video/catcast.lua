-- Видеоскрипт для http://catcast.tv/ (2020.10.25)
-- UP (west_side) 20.06.2023 - add current program title
-- Открывает ссылки:
-- https://catcast.tv/evgeniy-vhsзаказ
-- https://catcast.tv/vhs-90s
-- https://catcast.tv/mosfilm
-- https://catcast.tv/made_in_ussr
-- https://catcast.tv/mcm
------------------------------------------------------------------------------
if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
local inAdr = m_simpleTV.Control.CurrentAdress
if not inAdr then return end
if not inAdr:match('^https?://catcast%.tv/.+' ) then return end
m_simpleTV.Control.ChangeAdress = 'Yes'
m_simpleTV.Control.CurrentAdress = 'error'
local logo = 'https://catcast.tv/assets/no-logo.svg'


local userAgent = 'Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101 Firefox/78.0'
local session = m_simpleTV.Http.New(userAgent)
if not session then return end
local chName = inAdr:match('^https?://catcast%.tv/(.+)')
if not chName then return end
local url = 'https://api.catcast.tv/api/channels/getbyshortname/' .. m_simpleTV.Common.multiByteToUTF8(chName)

local t = {}
t.url = url
t.method = 'get'
t.headers = 'X-Timezone-Offset: -180\nReferer: ' .. inAdr
local rc, answer = m_simpleTV.Http.Request(session, t)
if rc ~= 200 then return end
answer = answer:gsub(':%[%]', ':""')
require('json')
local tab = json.decode(answer)
if tab == nil and tab.data == nil or tab.text ~= nil then
	m_simpleTV.OSD.ShowMessageT({text = 'Стрим удалён', color = ARGB(255, 255, 100, 0), showTime = 1000 * 5, id = 'channelName'})
return end
if tab.is_banned == true then
	m_simpleTV.OSD.ShowMessageT({text = 'Стрим заблокирован', color = ARGB(255, 255, 100, 0), showTime = 1000 * 5, id = 'channelName'})
return end
local title = tab.data.name
title = title:gsub('u0', '\\u0')
title = unescape1(title):gsub('\\u00ab', '«'):gsub('\\u00bb', '»'):gsub('u2116', '№'):gsub('u2605', '')
local poster = tab.data.logo or 'https://catcast.tv/assets/no-logo.svg'
local id = tab.data.id
local retAdr=''

url = 'https://api.catcast.tv/api/channels/' .. id .. '/getcurrentprogram'
local body = '{"hide_error_on_wrong_password":true}'
t.url = url
t.method = 'post'
t.headers = 'Accept: application/json, text/plain, */*\nContent-Type: application/json;charset=UTF-8\nSec-Fetch-Mode: cors\nX-Timezone-Offset: -180\nReferer: ' .. inAdr
t.body = body
rc, answer = m_simpleTV.Http.Request(session, t)
if rc ~= 200 then return end
answer = unescape3(answer):gsub(':%[%]', ':""')
--debug_in_file( answer .. '\n', 'c://1/catcast.txt', setnew )
tab = json.decode(answer)
if tab == nil and tab.data == nil then return end
if tab.data.need_password == true then
	m_simpleTV.OSD.ShowMessageT({text = 'Владелец стримкаста установил пароль на его просмотр.', color = ARGB(255, 255, 100, 0), showTime = 1000 * 5, id = 'channelName'})
return end
if tab.data.is_online == false then
	m_simpleTV.OSD.ShowMessageT({text = 'Стрим выключен. Попробуйте в другое время или узнайте расписание работы канала', color = ARGB(255, 255, 100, 0), showTime = 1000 * 5, id = 'channelName'})
return end
local program = ''
if tab.data.program_name ~= nil and tab.data.program_name ~= '' then program = ' (' .. tab.data.program_name .. ')' end
local svr, token
if tab.data.is_autopilot and tab.data.autopilot_server ~= nil and tab.data.token ~= nil then
	svr = tab.data.autopilot_server
	token = tab.data.token
	retAdr = 'https://' .. svr .. '/content/' .. id .. '/index.m3u8' .. '$OPT:http-ext-header=X-Access-Token:' .. token .. '$OPT:http-referrer=' .. inAdr
else
	retAdr = tab.data.full_url
end

if m_simpleTV.Control.CurrentTitle_UTF8 ~= nil then
	m_simpleTV.Control.CurrentTitle_UTF8 = title .. program
	m_simpleTV.Control.SetTitle(title .. program)
	if title == nil then m_simpleTV.Control.CurrentTitle_UTF8 = inAdr end
end

if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Control.ChangeChannelLogo(poster, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName(title, m_simpleTV.Control.ChannelID, false)
end
m_simpleTV.Control.CurrentAdress = retAdr