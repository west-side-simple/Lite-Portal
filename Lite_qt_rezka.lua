--Rezka portal - lite version west_side 29.07.22

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

function run_lite_qt_rezka()

	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local last_adr = getConfigVal('info/rezka') or ''
	local tt = {}
	if io.open(m_simpleTV.MainScriptDir .. 'user/TVSources/m3u/out_Franchises.m3u', 'r') and ExaminFranchisesRezka() == true
	then
	    tt = {
		{"","Rezka New"},
		{"","Коллекции"},
		{"","Франшизы: Фильмы"},
		{"","Франшизы: Мультфильмы"},
		{"","Франшизы: Сериалы"},
		{"","Франшизы: Аниме"},
		{"","Обновление Франшиз"},
		{"","ПОИСК"},
		{"","Rezka зеркало"},
		}
	elseif ExaminFranchisesRezka() == true
	then
		tt = {
		{"","Rezka New"},
		{"","Коллекции"},
		{"","Франшизы"},
		{"","Обновление Франшиз"},
		{"","ПОИСК"},
		{"","Rezka зеркало"},
		}
    else
		tt = {
		{"","Rezka New"},
		{"","Коллекции"},
		{"","Франшизы"},
		{"","ПОИСК"},
		{"","Rezka зеркало"},
		}
	end
	local t0={}
		for i=1,#tt do
			t0[i] = {}
			t0[i].Id = i
			t0[i].Name = tt[i][2]
			t0[i].Action = tt[i][1]
		end
	if last_adr and last_adr ~= '' then
	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info '}
	end
	t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию Rezka',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t0[id].Name == 'ПОИСК' then
				search()
			elseif t0[id].Name == 'Rezka зеркало' then
				zerkalo_rezka()
			elseif t0[id].Name == 'Rezka New' then
				last_rezka()
			elseif t0[id].Name == 'Коллекции' then
				collection_rezka()
			elseif t0[id].Name:match('Франшизы') then
				if t0[id].Name:match('Фильмы') then
				franchises_rezka_ganre('Фильмы')
				elseif t0[id].Name:match('Мультфильмы') then
				franchises_rezka_ganre('Мультфильмы')
				elseif t0[id].Name:match('Сериалы') then
				franchises_rezka_ganre('Сериалы')
				elseif t0[id].Name:match('Аниме') then
				franchises_rezka_ganre('Аниме')
				else
				franchises_rezka('https://hdrezka.ag/franchises/page/50/')
				end
			elseif t0[id].Name == 'Обновление Франшиз' then
				UpdateFranchisesRezka()
			end
		end
		if ret == 2 then
		media_info_rezka(last_adr)
		end
		if ret == 3 then
		run_westSide_portal()
		end
end

function zerkalo_rezka()
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	local current_zerkalo_id = 0
	local tt = {
		{"","Без зеркала"},
--		{"https://rezkery.com/","https://rezkery.com/"},
--		{"http://upivi.com/","http://upivi.com/"},
--		{"http://kinopub.me/","http://kinopub.me/"},
--		{"http://metaivi.com/","http://metaivi.com/"},
--		{"http://rd8j1em1zxge.org/","http://rd8j1em1zxge.org/"},
--		{"http://m85rnv8njgwv.org/","http://m85rnv8njgwv.org/"},
		{"https://hdrezka19139.org/","https://hdrezka19139.org/"},
		{"https://hdrezkabnbrts.net/","https://hdrezkabnbrts.net/"},
		}

	local t0={}
		for i=1,#tt do
			t0[i] = {}
			t0[i].Id = i
			t0[i].Name = tt[i][2]
			t0[i].Action = tt[i][1]
			if t0[i].Action == current_zerkalo then current_zerkalo_id = i-1 end
			i=i+1
		end

	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Rezka '}
	t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите зеркало Rezka',current_zerkalo_id,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			setConfigVal('zerkalo/rezka',t0[id].Action)
			zerkalo_rezka()
		end
		if ret == 2 then
			run_lite_qt_rezka()
		end
		if ret == 3 then
			run_westSide_portal()
		end
end

function last_rezka()
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	local url
	if current_zerkalo ~= '' then
	url = current_zerkalo:gsub('/$','')
	else
	url = 'https://hdrezka.ag'
	end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local rc,answer = m_simpleTV.Http.Request(session,{url= url})
		if rc ~= 200 then return end
	local title = 'Rezka New'
	local t,i = {},1
		for w in answer:gmatch('<div class="b%-content__inline_item".-</div> </div></div>') do
			local logo, group, adr, name, title = w:match('<img src="(.-)".-<i class="entity">(.-)</i>.-<a href="(.-)">(.-)</a> <div class="misc">(.-)<')
--			year = title:match('%d%d%d%d') or 0
					if not adr and not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name .. ' (' .. (title:match('%d%d%d%d') or 0) .. ') - ' .. group
				t[i].InfoPanelLogo = logo
				t[i].Address =  url .. adr
				t[i].InfoPanelName = name .. ' (' .. (title:match('%d%d%d%d') or 0) .. ')'
				t[i].InfoPanelShowTime = 10000
				i = i + 1
			end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Back '}
		t.ExtParams = {FilterType = 0, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title:gsub(' в HD онлайн','') .. ' (' .. #t .. ')',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		media_info_rezka(t[id].Address)
		end
		if ret == 2 then
			run_lite_qt_rezka()
		end
end

function collection_rezka()
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local url = 'https://hdrezka.ag/collections/'
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end
	local t,i = {},1
	for j=1,3 do
		local rc,answer = m_simpleTV.Http.Request(session,{url=url .. 'page/' .. j .. '/'})
		if rc ~= 200 then return '' end
		for w in answer:gmatch('<div class="b%-content__collections_item".-</div></div>') do
			local adr,logo,num,name = w:match('url="(.-)".-src="(.-)".-tooltip">(%d+).-"title">(.-)<')
			if not adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name .. ' (' .. num .. ')'
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Rezka collection: ' .. name
				t[i].InfoPanelShowTime = 10000
			i=i+1
		end
		j=j+1
	end
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите коллекцию Rezka (' .. #t .. ')',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			collection_rezka_url(t[id].Address)
		end
		if ret == 2 then
			run_westSide_portal()
		end
end

function collection_rezka_url(url)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc ~= 200 then return '' end
	local title = answer:match('<h1>(.-)</h1>') or 'Rezka collection'
	local navigation = answer:match('<div class="b%-navigation">(.-)</div>') or ''
	local left,right = '',''
	for w in navigation:gmatch('<a.-</a>') do
	local adr_nav = w:match('href="(.-)"')
	if not adr_nav then break end
	if w:match('b%-navigation__prev') then
	left = w:match('href="(.-)"')
	end
	if w:match('b%-navigation__next') then
	right = w:match('href="(.-)"')
	end
	end
	local t,i = {},1
	for w in answer:gmatch('<div class="b%-content__inline_item".-</div></div>') do
			local adr,logo,type_media,name,desc = w:match('url="(.-)".-src="(.-)".-"entity">(.-)<.-href=".-">(.-)<.-<div>(.-)</div>')
			if not adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name .. ' (' .. desc .. ') - ' .. type_media
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = name .. ' (' .. desc .. ')'
				t[i].InfoPanelShowTime = 10000
			i=i+1
		end
	if left and left ~= ''
	then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Prev '}
	else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	end
	if right and right ~= '' then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Next '}
	end
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title .. ' (' .. #t .. ')',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			media_info_rezka(t[id].Address)
		end
		if ret == 2 then
		if left and left ~= ''
		then
			collection_rezka_url(left)
		else
			collection_rezka()
		end
		end
		if ret == 3 and right and right ~= ''
		then
			collection_rezka_url(right)
		end
end

function franchises_rezka(url)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc ~= 200 then return '' end
	local current_page = url:match('/page/(%d+)') or 1
	local navigation = answer:match('<div class="b%-navigation">(.-)</div>') or ''
	local left,right = '',''
	for w in navigation:gmatch('<a.-</a>') do
	local adr_nav = w:match('href="(.-)"')
	if not adr_nav then break end
	if w:match('b%-navigation__prev') then
	right = w:match('href="(.-)"')
	end
	if w:match('b%-navigation__next') then
	left = w:match('href="(.-)"')
	end
	end
	local t,i = {},1

		for w in answer:gmatch('<div class="b%-content__collections_item".-</div></div>') do
			local adr,logo,num,name = w:match('url="(.-)".-src="(.-)".-tooltip">(%d+).-"title">(.-)<')
			if not adr or not name then break end
				t[i] = {}
				t[i].Name = name .. ' (' .. num .. ')'
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Rezka franchise: ' .. name
				t[i].InfoPanelShowTime = 10000
			i=i+1
		end

	local t1 = {}
		t1 = table_reverse(t)
		for i = 1, #t1 do
			t1[i].Id = i
		end
	if left and left ~= ''
	then
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' Prev '}
	else
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	end
	if right and right ~= '' then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Next '}
	end
		t1.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Франшизы Rezka - стр. ' .. 51-tonumber(current_page) .. ' из 50',0,t1,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			franchises_rezka_url(t1[id].Address)
		end
		if ret == 2 then
		if left and left ~= ''
		then
			franchises_rezka(left)
		else
			run_lite_qt_rezka()
		end
		end
		if ret == 3 and right and right ~= ''
		then
			franchises_rezka(right)
		end
end

function franchises_rezka_ganre(ganre)
	local file = io.open(m_simpleTV.MainScriptDir .. 'user/TVSources/m3u/out_Franchises.m3u', 'r')
	local answer = file:read('*a')
	file:close()
	local t,i = {},1
		for w in answer:gmatch('EXTINF:.-\n.-\n') do
		local grp,logo,name,adr = w:match('group%-title="(.-)".-tvg%-logo="(.-)".-%,(.-)\n(.-)\n')
		if not grp or not logo or not name or not adr then break end
		if grp == ganre then
				t[i] = {}
				t[i].Id = i
				t[i].Name = name:gsub('Все части мультфильма ',''):gsub('Все части мультсериала ',''):gsub('Все мультфильмы про ','Про '):gsub('Все мультфильмы франшизы ',''):gsub('Все мультфильмы ',''):gsub('Все части фильма ',''):gsub('Все части сериала ',''):gsub('все части сериала ',''):gsub('Все части документального сериала ',''):gsub('Все фильмы про ','Про '):gsub('Все части франшизы ',''):gsub('Все части аниме ',''):gsub('Все мультфильмы серии ',''):gsub('Все фильмы серии ',''):gsub('%%2C','!')
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = 'Rezka franchise: ' .. name
				t[i].InfoPanelShowTime = 10000
			i=i+1
		end
		end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
		t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Франшизы: ' .. ganre .. ' (' .. #t .. ')',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			franchises_rezka_url(t[id].Address)
		end
		if ret == 2 then
			run_lite_qt_rezka()
		end
end

function franchises_rezka_url(url)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc ~= 200 then return '' end
	local title = answer:match('<h1>Смотреть все(.-)</h1></div>') or 'Rezka franchises'
	local t,i = {},1
		for w in answer:gmatch('<div class="b%-post__partcontent_item".-</div></div>') do
			local adr,name,year = w:match('url="(.-)".-href=".-">(.-)<.-year">(.-)<')
			if not adr or not name then break end
				t[i] = {}
				t[i].Name = name .. ' (' .. year .. ')'
				t[i].Address = adr
			i=i+1
		end
		local t1 = {}
		t1 = table_reverse(t)
		for i = 1, #t1 do
			t1[i].Id = i
		end
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' Back '}
		if not title:match('сериал') then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play '}
		end
		t1.ExtParams = {FilterType = 0, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title:gsub(' в HD онлайн','') .. ' (' .. #t1 .. ')',0,t1,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		media_info_rezka(t1[id].Address)
		end
		if ret == 2 then
			run_lite_qt_rezka()
		end
		if ret == 3 then
			m_simpleTV.Control.ChangeAddress = 'No'
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.CurrentAddress = url
			m_simpleTV.Control.PlayAddress(url)
		end
end

function UpdatePersonRezka()
if package.loaded['tvs_core'] and package.loaded['tvs_func'] then
    local tmp_sources = tvs_core.tvs_GetSourceParam() or {}
    for SID, v in pairs(tmp_sources) do
         if v.name:find('PERSONS')
		 then
		    tvs_core.UpdateSource(SID, false)
            tvs_func.OSD_mess('', -2)
         end
    end
end
end

function UpdateFranchisesRezka()
if package.loaded['tvs_core'] and package.loaded['tvs_func'] then
    local tmp_sources = tvs_core.tvs_GetSourceParam() or {}
    for SID, v in pairs(tmp_sources) do
         if v.name:find('Franchises')
		 then
		    tvs_core.UpdateSource(SID, false)
            tvs_func.OSD_mess('', -2)
         end
    end
end
end

function ExaminFranchisesRezka()
if package.loaded['tvs_core'] and package.loaded['tvs_func'] then
    local tmp_sources = tvs_core.tvs_GetSourceParam() or {}
    for SID, v in pairs(tmp_sources) do
         if v.name:find('Franchises')
		 then
			return true
         end
    end
	return false
end
end

function person_rezka_work(url)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc ~= 200 then return '' end
	local title1 = answer:match('<h1><span class="t1" itemprop="name">(.-)</span>') or 'Rezka person'
	local t,i = {},1
	for w in answer:gmatch('<div class="b%-content__inline_item.-</div> </div></div>') do
	local logo, group, adr, name, title = w:match('<img src="(.-)".-<span class="(.-)".-<a href="(.-)">(.-)</a> <div class="misc">(.-)<')
	if not adr or not name then break end
	t[i] = {}
	t[i].Name = name .. ' (' .. title .. ') - ' .. group:gsub('cat ','')
	t[i].Address = adr
	t[i].InfoPanelLogo = logo
	t[i].InfoPanelName = 'Rezka info: ' .. name .. ' (' .. title .. ')'
	t[i].InfoPanelShowTime = 10000
	i=i+1
	end
		local hash, res = {}, {}
		for i = 1, #t do
		t[i].Address = tostring(t[i].Address)
			if not hash[t[i].Address] then
				res[#res + 1] = t[i]
				hash[t[i].Address] = true
			end
		end
		for i = 1, #res do
			res[i].Id = i
		end
		local AutoNumberFormat, FilterType
			if #res > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		res.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
		res.ExtButton1 = {ButtonEnable = true, ButtonName = ' 💾 '}
		res.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title1 .. ' (' .. #res .. ')',0,res,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			media_info_rezka(res[id].Address)
		end
		if ret == 2 then
			media_info_rezka(url)
		end
		if ret == 3	then
			setConfigVal('person/rezka',url:gsub('rezka%.ag','rezkery.com'))
			UpdatePersonRezka()
		end
end

function media_info_rezka(url)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc ~= 200 then return '' end
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
	else tooltip_body = 'bgcolor="#182633"'
	end
	answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local poster = answer:match('<div class="b%-sidecover"> <a href="([^"]+)') or answer:match('property="og:image" content="([^"]+)') or ''
	local name_rus = answer:match('<h1 itemprop="name">(.-)</h1>') or answer:match('<h1><span class="t1" itemprop="name">([^<]+)') or answer:match('<div class="b%-content__htitle"> <h1>(.-)</h1>') or ''
	name_rus = name_rus:gsub(' в HD онлайн', ''):gsub('Смотреть ', '')
	local desc = answer:match('"og:description" content="(.-)"%s*/>') or ''
	desc = desc:gsub('"', "'"):gsub('&laquo;', '«'):gsub('&raquo;', '»')
	local time_all = answer:match('<h2>Время</h2>:</td> <td itemprop="duration">(.-)</td>') or ''
	if time_all ~= '' then time_all = '<h5><font color=#E0FFFF>' .. time_all .. '</font></h5>' end
	local name_eng = answer:match('alternativeHeadline">(.-)</div>') or ''
	local mpaa = answer:match('style="color: #666;">(.-+)') or ''
	local slogan = answer:match('<h2>Слоган</h2>:</td> <td>(.-)</td>') or ''
	slogan = slogan:gsub('&laquo;', '«'):gsub('&raquo;', '»')
	local country = answer:match('<h2>Страна.-">(.-)</tr>') or ''
	country = country:gsub('<a.->', ''):gsub('</td>', ''):gsub('</a>', '')
	local year = answer:match('Дата выхода.-year/(.-)/') or answer:match('Год:.-year/(.-)/') or answer:match('<td class="l">(<h2>Дата рождения</h2>:.-)<div class="b%-person__career">') or ''
	year = year:gsub('<a href="https://rezkery.com/year/.->', ''):gsub('<tr>', ''):gsub('</tr>', ''):gsub('<td.->', ''):gsub('</td>', ''):gsub('</a>', ''):gsub('<h2.->', '<h5>'):gsub('</h2>', ''):gsub('</table>', ''):gsub('<div class="b%-person__gallery_holder">.-</div>', '')
	local kpr = answer:match('Кинопоиск</a>: <span class="bold">(.-)</span> <i>') or ''
	if kpr ~= '' then kpr = string.format('%.' .. (1 or 0) .. 'f', kpr) end
	local imdbr = answer:match('IMDb.-: <span class="bold">(.-)</span> <i>') or ''
	local desc_text = answer:match('<div class="b%-post__description_text">(.-)</div>') or ''
	desc_text = desc_text:gsub('<a.->', ''):gsub('</a>', '')
	desc_text = '<table width="100%" border="0"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="470"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h4><font color=#00FA9A>' .. name_rus .. '</font></h4><h5><i><font color=#EBEBEB>' .. slogan .. '</font></i>  <b><font color=#E0FFFF>' .. mpaa .. '</font></b></h5><h5><font color=#BBBBBB>' .. name_eng .. '</font></h5><h5><font color=#E0FFFF>' .. year .. ' • ' .. country .. ' • Кинопоиск: ' .. kpr .. ' • IMDb: ' .. imdbr .. '</font></h5>' .. time_all .. '<h4><font color=#EBEBEB>' .. desc_text .. '</font></h4></td></tr></table>'
	local answer1 = answer:match('<h2>Из серии</h2>:(.-)</tr>') or ''
	local answer2 = answer:match('<div class="b%-sidetitle">(.-</a>)') or ''
	local answer3 = answer:match('<div class="b%-sidelist__holder">(.-)<div id="addcomment%-title"') or ''
	local title = name_rus .. ' (' .. year .. ')'
	local t1,j={},2
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Address = ''
		t1[1].Name = '.: info :.'
		t1[1].InfoPanelLogo = poster
		t1[1].InfoPanelName = title or 'Rezka info'
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. desc_text .. '</body></html>'
		t1[1].InfoPanelTitle = desc
		t1[1].InfoPanelShowTime = 10000
		if answer2 and answer2 ~= '' and answer2:match('href="(.-)"') then
		t1[2] = {}
		t1[2].Id = 2
		t1[2].Address = answer2:match('href="(.-)"')
		t1[2].Name = answer2:match('class="b%-post__franchise_link_title">(.-)</a>') or 'Франшиза'
		j = 3
		end
		for w1 in answer1:gmatch('<a href=".-</a>') do
		local adr,name = w1:match('<a href="(.-)">(.-)</a>')
		if not adr or not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = adr
		t1[j].Name = name:gsub('&#039;',"'"):gsub('&amp;',"&")
		j=j+1
		end
		for w2 in answer:gmatch('<span class="person%-name%-item".-</span>') do
		local person_logo, person_work, person_adr, person_name = w2:match('data%-photo="(.-)".-data%-job="(.-)".-href="(.-)".-itemprop="name">(.-)</span>')
		if not person_name or not person_adr or not person_work then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Name = person_name:gsub('&laquo;',''):gsub('&raquo;','') .. ' (' .. person_work .. ')'
		t1[j].Address = person_adr
		t1[j].InfoPanelLogo = person_logo
		t1[j].InfoPanelName = person_name:gsub('&laquo;',''):gsub('&raquo;','') .. ' (' .. person_work .. ')'
		t1[j].InfoPanelShowTime = 10000
		j=j+1
		end
		for w3 in answer3:gmatch('<a href=".-</div> </div>') do
		local logo, item, adr, name, desc = w3:match('<img src="(.-)".-<i class="entity">(.-)</i>.-<a href="(.-)">(.-)</a> <div class="misc">(.-)</div> </div>')
		if not logo or not item or not adr or not name or not desc then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Name = name .. ' (' .. desc .. ') - ' .. item
		t1[j].Address = adr
		t1[j].InfoPanelLogo = logo
		t1[j].InfoPanelName = name .. ' (' .. desc .. ') - ' .. item
		t1[j].InfoPanelShowTime = 10000
		j=j+1
		end
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀 '}
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play '}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Rezka: ' .. title, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			if id == 1 then
			media_info_rezka(url)
			elseif t1[id].Address:match('/collections/') then
			collection_rezka_url(t1[id].Address)
			elseif t1[id].Address:match('/franchises/') then
			franchises_rezka_url(t1[id].Address)
			elseif t1[id].Address:match('/person/') then
			person_rezka_work(t1[id].Address)
			else
			media_info_rezka(t1[id].Address)
			end
		end
		if ret == 2 then
			run_lite_qt_rezka()
		end
		if ret == 3 then
			setConfigVal('info/rezka',url)
			setConfigVal('info/scheme','Rezka')
			retAdr = url
			m_simpleTV.Control.ChangeAddress = 'No'
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.PlayAddress(retAdr)
		end
end