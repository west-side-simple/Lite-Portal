-- Плагин для трекера RipsClub (HEVC) lite portal 22.02.23
-- author west_side

function start_hevc()
	local tt = {
		{"","TOP"},
		{"https://rips.club/search/?part=1&year=&cat=0&standard=0&bit=0&order=0&search=","Фильмы"},
		{"https://rips.club/search/?part=2&year=&cat=0&standard=0&bit=0&order=1&search=","Сериалы"},
		{"https://rips.club/search/?part=3&year=&cat=0&standard=0&bit=0&order=1&search=","Концерты"},
		{"https://rips.club/search/?part=0&year=&cat=15&standard=0&bit=0&order=1&search=","Мультфильмы"},
		{"","ПОИСК"},
		}
		local t0={}
		for i=1,#tt do
			t0[i] = {}
			t0[i].Id = i
			t0[i].Name = tt[i][2]
			t0[i].Action = tt[i][1]
		end
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t0[id].Name == 'ПОИСК' then
				search()
			elseif t0[id].Name == 'TOP' then
				top_hevc()
			else
				search_hevc(t0[id].Action)
			end
		end
end

function top_hevc()
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'https://rips.club'
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		return
	end

		local answer1 = answer:match('<div class="top">(.-)</div>')
		local t,i={},1
			for w in answer1:gmatch('<a href.-</a>') do
				local name = w:match('title="(.-)"')
				local adr = w:match('href="(.-)"')
				local logo = w:match('src="(.-)"')
				if not adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].InfoPanelLogo = 'https://rips.club' .. logo
				t[i].Name = name:gsub('%&quot%;','"'):gsub('%&apos%;',"'"):gsub('%).-$',')')
				t[i].Address = 'https://rips.club' .. adr
				t[i].InfoPanelName = name:gsub('%&quot%;','"'):gsub('%&apos%;',"'")
				t[i].InfoPanelShowTime = 30000
			    i = i + 1
			end

		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}

		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('RipsClub (HEVC) TOP', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			content_hevc(t[id].Address)
		end
		if ret == 2 then
		  start_hevc()
		end
end

function search_hevc(url)

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', ''):gsub('%&amp%;', '&')
		local answer_part = answer:match('<select name="part".-</select>')
		local answer_cat = answer:match('<select name="cat".-</select>')
		local answer_search = answer:match('<div class="search">.-</div>')
		local title = 'HEVC • '
		if answer_part and answer_part:match('selected>(.-)</option>') then title = title .. answer_part:match('selected>(.-)</option>') .. ' ' end
		if answer_cat and answer_cat:match('selected>(.-)</option>') then title = title .. answer_cat:match('selected>(.-)</option>') .. ' ' end
		if answer_search and answer_search:match('value="(.-)" required>') and answer_search:match('value="(.-)" required>') ~= '' then title = title .. 'Поиск: ' .. answer_search:match('value="(.-)" required>') .. ' ' end
		local t,i={},1
			for w in answer:gmatch('<section><div class="title">.-</section>') do
				local name = w:match('title="Подробнее">(.-)<')
				local year = name:match('%((%d+)') or 0
				local adr = w:match('href="(.-)"')
				local logo = w:match('src="(.-)"')
				local overview = w:match('<div class="about">(.-)</div>') or ''
				local sid,pir =  w:match('<span title="Раздают %(сиды%)">(.-)</span><span title="Качают %(пиры%)">(.-)</span>') or 0,0
				if not logo or not adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].InfoPanelLogo = 'https://rips.club' .. logo
				t[i].Name = name:gsub('%&quot%;','"'):gsub('%&apos%;',"'"):gsub('%).-$',')')
				t[i].Address = 'https://rips.club' .. adr:gsub('^https%://rips%.club','')
				t[i].InfoPanelName = name:gsub('%&quot%;','"'):gsub('%&apos%;',"'")
				t[i].InfoPanelShowTime = 30000
				t[i].InfoPanelTitle = '✅ ' .. sid .. '  🔻 ' .. pir .. ' • ' .. overview:gsub('\n',' '):gsub('\r',' '):gsub('<.->',' '):gsub('  ',' '):gsub('^ ',''):gsub('%&quot%;','"'):gsub('%&apos%;',"'")
			    i = i + 1
			end
		local current =	url:match('%?page=(%d+)') or 1
		local next = answer:match('<li class="c_page">(%d+)</li>')
		local all = answer:match('">(%d+)</a></li></ul>') or answer:match('">(%d+)</li></ul>') or 1
		local prev
		if tonumber(current) > 1 then
		prev = url:gsub('%?page=' .. current,'%?page=' .. tonumber(current)-1)
		end
		if next and tonumber(next) < tonumber(all) then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
		else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
		end

		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title .. '(страница '.. current .. ' из ' .. all .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			content_hevc(t[id].Address)
		end
		if ret == 2 then
		if prev then
		  search_hevc(prev)
		else
		  start_hevc()
		end
		end
		if ret == 3 then
		  search_hevc(url:gsub('%?page=' .. current .. '%&','?'):gsub('%?','?page=' .. tonumber(current)+1 .. '&'))
		end
end

function content_hevc(url)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
	else tooltip_body = 'bgcolor="#182633"'
	end
	local hevc_id = url:match('/video%-(%d+)/')
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')

	local answer_cat = answer:match('<select name="cat".-</select>')
	local sid,pir =  answer:match('<span title="Раздают %(сиды%)">(.-)</span><span title="Качают %(пиры%)">(.-)</span>') or 0,0
	local retAdr = answer:match('<a rel="nofollow" href="(magnet.-)"')
	local title = answer:match('<title>(.-)</title>') or 'HEVC'
	title = title:gsub('%&quot%;','"'):gsub('%&apos%;',"'"):gsub('%).-$',')')
	local poster = answer:match('<meta property="og%:image" content="(.-)">')
	local overview = answer:match('<meta property="og%:description" content="(.-)">') or ''
	overview = overview:gsub('\n',' '):gsub('\r',' '):gsub('<.->',' '):gsub('  ',' '):gsub('^ ',''):gsub('%&quot%;','"'):gsub('%&apos%;',"'")
	local all_tag = answer:match('<b>Жанр%:</b>(.-)<br>') or ''
	local all_tag_txt = answer:match('(<b>Год%:.-<b>Жанр%:.-)<br>') or ''
	local plus_info = ''
	for w in answer:gmatch('<summary>.-</summary>') do
		local info = w:match('<summary>(.-)</summary>')
		if not info then break end
		if not info:match('Лог ') and not info:match('Медиаинфо') and not info:match('Мультитрекер') and not info:match('Файлы: ') and not info:match('Поблагодарили: ') then
		plus_info = plus_info .. info .. '<br>'
		end
	end
	local videodesc= '<table width="100%"><tr><td style="padding: 5px 5px 0px;"><img src="' .. poster .. '" height="300"></td><td style="padding: 5px 5px 0px; color: #AAAAAA; vertical-align: middle;"><h3><font color=#00FA9A>' .. title .. '</font></h3><h5>' .. all_tag_txt .. '</h5></td></tr></table><table width="100%"><tr><td style="padding: 0px 5px 0px; color: #FFFFFF; vertical-align: middle;"><h4>' .. overview .. plus_info .. '</h4></td></tr></table>'
	videodesc = videodesc:gsub('"', '\"')

	local t1,j={},2
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Address = ''
		t1[1].Name = '.: info :.'
		t1[1].InfoPanelLogo = poster
		t1[1].InfoPanelName = title .. ': HEVC info'
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
		t1[1].InfoPanelTitle = '✅ ' .. sid .. '  🔻 ' .. pir .. ' • ' .. overview .. plus_info:gsub('<br>',' ')
		t1[1].InfoPanelShowTime = 10000
		for w in answer_cat:gmatch('<option.-</option>') do
		local adr,name = w:match('<option value="(%d+)">(.-)</option>')
		if not adr or not name then break end
		if all_tag:match(name) then
		t1[j]={}
		t1[j].Id = j
		t1[j].Address = 'https://rips.club/search/?part=0&year=&cat=' .. adr .. '&standard=0&bit=0&order=0&search='
		t1[j].Name = name
		j=j+1
		end
		end

		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
		if retAdr then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play '}
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('HEVC: ' .. title, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			if id == 1 then
			 content_hevc(url)
			else
			 search_hevc(t1[id].Address)
			end
		end
		if ret == 2 then
			start_hevc()
		end
		if ret == 3 then
			m_simpleTV.Control.PlayAddressT({address='hevc_id=' .. hevc_id .. '&' .. retAdr, title=title})
		end
end