-- видеоскрипт для плейлиста "StarNet" https://www.starnet.md (29/10/24)
-- Copyright © 2017-2024 Nexterr | https://github.com/Nexterr-origin/simpleTV-Scripts
-- mod WS
-- ## необходим ##
-- скрапер TVS: starnet-md_pls.lua
-- ## открывает подобные ссылки ##
-- http://hls.stb.md/DRAIV_H264/video.m3u8?token=
-- ##
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('^https?://hls%.stb%.md') then return end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = '', TypeBackColor = 0, UseLogo = 0, Once = 1})
	end
	local inAdr = m_simpleTV.Control.CurrentAddress
	m_simpleTV.Control.ChangeAddress = 'Yes'
--	m_simpleTV.Control.CurrentAddress = 'error'
	local session = m_simpleTV.Http.New()
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

	local function findtok()
		local url= decode64('aHR0cHM6Ly90b2tlbi5zdGIubWQvYXBpL0ZsdXNzb25pYy9zdHJlYW0vTklDS0VMT0RFT05fSDI2NC9tZXRhZGF0YS5qc29u')
		local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc~=200 then
		return ''
		end
		require('json')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
		if tab and tab.variants and tab.variants[1] and tab.variants[1].url then
		return tab.variants[1].url:gsub('^.-token=','')
		else
		return ''
		end
	end

	local token = findtok()
	local retAdr = inAdr .. token
	if not retAdr then return end
	retAdr = retAdr:gsub('/index', '/video')
	rc, answer = m_simpleTV.Http.Request(session, {url = retAdr})
	m_simpleTV.Http.Close(session)
	if rc ~= 200 then return end
	local t = {}
	local base = retAdr:match('.+/')
		for w in string.gmatch(answer,'EXT%-X%-STREAM%-INF(.-%.m3u8.-)\n') do
			local adr = w:match('\n(.+)')
			local name = w:match('RESOLUTION=%d+x(%d+)')
			local br = w:match('%,BANDWIDTH=(%d+)')
			if adr and name and br then
				br = tonumber(br)
				t[#t + 1] = {}
				t[#t].Id = br/1000
				t[#t].Name =  br/1000 .. ' kb/s (' .. name .. 'p)'
				t[#t].Address = base .. adr:gsub('/[^.]+', '/index') .. '$OPT:adaptive-maxheight=' .. tonumber(name) .. '$OPT:adaptive-max-bw=' .. tonumber(br)/1000
			end
		end
		if #t == 0 then
			m_simpleTV.Control.CurrentAddress = retAdr
		 return
		end
	table.sort(t, function(a, b) return a.Id < b.Id end)
	local lastQuality = tonumber(m_simpleTV.Config.GetValue('starnet_md_qlty') or 10000)
	t[#t + 1] = {}
	t[#t].Id = 10000
	t[#t].Name = '🟢 всегда высокое'
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
		t.ExtParams = {LuaOnOkFunName = 'starnetmdSaveQuality', Random = 0, PlayMode = 2, StopOnError = 0}
		m_simpleTV.OSD.ShowSelect_UTF8('⚙ Качество', index - 1, t, 5000, 32 + 64 + 128)
	end
	m_simpleTV.Control.CurrentAddress = t[index].Address
	function starnetmdSaveQuality(obj, id)
		m_simpleTV.Config.SetValue('starnet_md_qlty', id)
	end
-- debug_in_file(t[index].Address .. '\n')
