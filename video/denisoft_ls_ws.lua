-- видеоскрипт для плейлиста "LIMEFULL" http://denms.ru/iptv/1000849--iptvinruproxy (02.08.21) для выбора качества потока
-- использован шаблон кода nexterr для выбора качества потока
-- ## открывает подобные ссылки ##
-- http://192.168.229.72:9090/LIMEFULL/75 (адрес и порт выбираются в настройках локального сервера)
-- ##
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('/LIMEFULL/') then return end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = '', TypeBackColor = 0, UseLogo = 0, Once = 1})
	end
	local inAdr = m_simpleTV.Control.CurrentAddress
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.CurrentAddress = 'error'
	local session = m_simpleTV.Http.New()
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local retAdr = inAdr
	rc, answer = m_simpleTV.Http.Request(session, {url = retAdr})
	m_simpleTV.Http.Close(session)
		if rc ~= 200 then return end
	local t = {}
		for w in answer:gmatch('EXT%-X%-STREAM%-INF(.-)\n') do
			local name = w:match('RESOLUTION=%d+x(%d+)')
			local adr = w:match('BANDWIDTH=(%d+)')
			if name and adr then
				t[#t + 1] = {}
				t[#t].Id = tonumber(name)
				t[#t].Name = name .. 'p'
				t[#t].Address = retAdr .. '$OPT:adaptive-maxheight=' .. name .. '$OPT:adaptive-max-bw=' .. tonumber(adr)/1000
			end
		end
		if #t == 0 then
			m_simpleTV.Control.CurrentAddress = retAdr
		 return
		end
	table.sort(t, function(a, b) return a.Id < b.Id end)
	local lastQuality = tonumber(m_simpleTV.Config.GetValue('denisoft_ls_ws_qlty') or 5000)
	t[#t + 1] = {}
	t[#t].Id = 5000
	t[#t].Name = '▫ всегда высокое'
	t[#t].Address = t[#t - 1].Address
	local index = #t
		for i = 1, #t do
			if t[i].Id >= lastQuality then
				index = i
			 break
			end
		end
	if index > 1 then
		if t[index].Id > lastQuality then
			index = index - 1
		end
	end
	if m_simpleTV.Control.MainMode == 0 then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = '✕', ButtonScript = 'm_simpleTV.Control.ExecuteAction(37)'}
		t.ExtParams = {LuaOnOkFunName = 'denisoftlswsSaveQuality'}
		m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 32 + 64 + 128)
	end
	m_simpleTV.Control.CurrentAddress = t[index].Address
	function denisoftlswsSaveQuality(obj, id)
		m_simpleTV.Config.SetValue('denisoft_ls_ws_qlty', id)
	end
-- debug_in_file(t[index].Address .. '\n')
