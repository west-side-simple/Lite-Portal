--Плагин автообновления сборки для lite portal - автор west_side 02.07.23
--Необходимы скрипты /luaScr/user/video/hello_world.lua, /luaScr/user/startup/west_side.lua, /luaScr/user/westSide/events.lua - автор west_side
-------------------------------------------------------------------
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if m_simpleTV.User.westSide==nil then
		m_simpleTV.User.westSide={}
	end
-------------------------------------------------------------------
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
------------------------------------------------------------------- блок вывода текущих даты и времени (русский, английский соответственно интерфейсу)
	local dataEN = os.date ("%a %d %b %Y %H:%M")
	local dataRU = dataEN:gsub('Sun', 'Вс'):gsub('Mon', 'Пн'):gsub('Tue', 'Вт'):gsub('Wed', 'Ср'):gsub('Thu', 'Чт'):gsub('Fri', 'Пт'):gsub('Sat', 'Сб')
	dataRU = dataRU:gsub('Jan', 'Янв'):gsub('Feb', 'Фев'):gsub('Mar', 'Мар'):gsub('Apr', 'Апр'):gsub('May', 'Май'):gsub('Jun', 'Июн'):gsub('Jul', 'Июл'):gsub('Aug', 'Авг'):gsub('Sep', 'Сен'):gsub('Oct', 'Окт'):gsub('Nov', 'Ноя'):gsub('Dec', 'Дек')
	if m_simpleTV.Interface.GetLanguage() == 'ru' then data = dataRU else data = dataEN end
-------------------------------------------------------------------
	local userAgent = "Mozilla/5.0 (Windows NT 10.0; rv:85.0) Gecko/20100101 Firefox/85.0"
	local session =  m_simpleTV.Http.New(userAgent)
	if not session then
	return ''
	end
	m_simpleTV.Http.SetTimeout(session, 8000)

	local rc,answer = m_simpleTV.Http.Request(session,{url='http://m24.do.am/_fr/0/upd.txt'})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		m_simpleTV.User.westSide.UP=true -- глобальная переменная для обновлений nil, true, false
		if not m_simpleTV.Config.GetValue('mainPlayController/playLastChannelOnStartup','simpleTVConfig') == true then
			m_simpleTV.Control.PlayAddressT({title='SimpleTV',address='SimpleTV'})-- fix title
		end
		return m_simpleTV.OSD.ShowMessageT({text = 'Обновление не доступно\nТекущее время: ' .. data, color = ARGB(255, 255, 255, 255), showTime = 2000 * 5})
		-- нет доступа к хостингу обновлений
	else
		m_simpleTV.Http.Close(session)
		m_simpleTV.OSD.ShowMessageT({text = 'Проверка обновлений\nТекущее время: ' .. data, color = ARGB(255, 255, 255, 255), showTime = 2000 * 5}) -- есть доступ к хостингу обновлений
		m_simpleTV.User.westSide.UP=false -- глобальная переменная для обновлений nil, true, false
	end

	local str3 = answer:match('^.-\n.-\n(.-)\n') -- текст информера обновления
	local str4 = answer:match('^.-\n.-\n.-\n(.-)\n') -- резерв
	local str5 = answer:match('^.-\n.-\n.-\n.-\n(.-)\n') -- бекграунд информера рекламы, анонсов и объявлений
	local str6 = answer:match('^.-\n.-\n.-\n.-\n.-\n(.-)\n') -- текст информера рекламы, анонсов и объявлений
	local str7 = answer:match('^.-\n.-\n.-\n.-\n.-\n.-\n(.-)\n') -- резерв
	local str8 = answer:match('^.-\n.-\n.-\n.-\n.-\n.-\n.-\n(.-)\n') -- флаг видео при обновлении: 1,2,...N если 0 - информер обновления
	local h,m,d,mo,y = answer:match('(%d+):(%d+) (%d+)%.(%d+)%.(%d+)') --str1
--[[	local h1,m1,d1,mo1,y1 = answer:match('\n(%d+):(%d+) (%d+)%.(%d+)%.(%d+)')--]] --str2 заготовка обновления 2-го типа
	local dateuptime = { year = '20' .. y,
                   month = mo,
                   day = d,
                   hour = h,
                   min = m,
                   sec = 0
                  }
--[[	local dateuptime1 = { year = '20' .. y1,
                   month = mo1,
                   day = d1,
                   hour = h1,
                   min = m1,
                   sec = 0
                  }--]]--заготовка обновления 2-го типа
	local t1 = os.time(dateuptime)
	local t2 = getConfigVal("Upd") or 0
--[[	local t3 = os.time(dateuptime1)
	local t4 = getConfigVal("Upd1") or 0--]]--заготовка обновления 2-го типа
	local need
	if t1 and t2 then
		need = tonumber(t1) - tonumber(t2)
	end
--[[	if t3 and t4 then
		need1 = tonumber(t3) - tonumber(t4)--заготовка обновления 2-го типа
	end--]]

	if need then
		if need > 0 then -- проверка новых обновлений для пользователя (даже в случае отказа от предыдущего обновления)
			setConfigVal("Upd",t1) -- запись в LiteConf.ini времени, когда пользователь информирован о наличии текущего обновления (мог обновиться, мог игнорировать - можно позже обновить принудительно)
			if getConfigVal("need") and getConfigVal("need")==1 then
				return -- информирование пользователя отказавшегося от обновления о выходе нового
				m_simpleTV.OSD.ShowMessageT({text = 'Доступно обновление\nВремя текущего обновления: ' .. d .. '.' .. mo .. '.20' .. y .. ' ' .. h .. ':' .. m, color = ARGB(255, 255, 255, 255), showTime = 2000 * 5})
			end
			setConfigVal("need",1) -- флаг информирования о наличии текущего обновления
------------------------------------------------------------------- блок двух вариантов обновления: информер или видеоролик
			if str8 and tonumber(str8)==0 or not str8 or str8=='' or not tonumber(str8) then
				m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = 'http://m24.do.am/_fr/0/7911633.jpg', TypeBackColor = 0, UseLogo = 4, Once = 1})
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.5" src="http://m24.do.am/images/liteportal.png"', text = str3 .. '\nТекущее время: ' .. data, color = ARGB(255, 255, 255, 255), showTime = 2000 * 10})
				local params = {}
				params.message = 'Для обновления сборки нажмите кнопку ДА.'
				params.caption = 'Update'
				params.buttons = 'Yes|No'
				params.icon = 'Question'
				params.defButton = 'Yes'
				if m_simpleTV.Interface.MessageBoxT(params) == 'Yes' then
					setConfigVal("need",0) -- флаг текущего обновления и готовности к новому
					os.execute('tv-update.exe')
				end
			else
				m_simpleTV.Control.PlayAddress('hello_world=' .. tonumber(str8) .. '')
			end
------------------------------------------------------------------- блок анонсов и объявлений
		elseif need <= 0 then
			m_simpleTV.User.westSide.UP=true
			if str5~='' then -- флаг анонсов и объявлений
				if getConfigVal("need") and getConfigVal("need")==1 then -- информирование пользователя отказавшегося от обновлений о наличии анонсов и объявлений
					m_simpleTV.OSD.ShowMessageT({text = 'Есть новые анонсы и объявления', color = ARGB(255, 255, 255, 255), showTime = 2000 * 5})
					local params = {}
					params.message = 'Просмотреть анонсы и объявления'
					params.caption = 'Просмотр'
					params.buttons = 'Yes|No'
					params.icon = 'Question'
					params.defButton = 'Yes'
					if m_simpleTV.Interface.MessageBoxT(params) ~= 'Yes' then
						return
					end
				end
				m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = str5 , TypeBackColor = 0, UseLogo = 4, Once = 1})
			end
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.5" src="http://m24.do.am/images/liteportal.png"' , text = str6 ,  color = ARGB(255, 255, 255, 255), showTime = 1700 * 10})
			if not m_simpleTV.Config.GetValue('mainPlayController/playLastChannelOnStartup','simpleTVConfig') == true then
				m_simpleTV.Control.PlayAddressT({title='SimpleTV',address='SimpleTV'})-- fix title
			end
		end
	end