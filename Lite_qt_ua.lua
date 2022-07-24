--UA portal - lite version west_side 30.06.22

function run_lite_qt_ua()
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local last_adr = getConfigVal('info/kino4ua') or ''
			local pll={
		{"/filmy/","Фільми - надходження"},
		{"/filmy/vitchyzniani/","Вітчизняні"},
		{"/filmy/boyovik/","Бойовик"},
		{"/filmy/viyskovi/","Військовий"},
		{"/filmy/detectivy/","Детектив"},
		{"/filmy/documentalni/","Документальні"},
		{"/filmy/dramy/","Драма"},
		{"/filmy/zhahi/","Жахи"},
		{"/filmy/istorichni/","Історичні"},
		{"/filmy/komedii/","Комедія"},
		{"/filmy/cryminalni/","Кримінальні"},
		{"/filmy/melodramy/","Мелодрами"},
		{"/filmy/muzychni/","Музичні"},
		{"/filmy/prigody/","Пригоди"},
		{"/filmy/romans/","Романтика"},
		{"/filmy/trillery/","Трилер"},
		{"/filmy/fantastika/","Фантастика"},
		{"/filmy/fantasy/","Фентезі"},
		{"/filmy/simeyni/","Сімейні"},
		{"/filmy/dytiachi/","Дитячі"},
		{"/serialy/","Серіали - надходження"},
		{"/multfilmy/","Мультфильми"},
		{"/multserialy_ukrainskou/","Мультсеріали"},
		{"/anime_ukrainskou/","Аніме"},
		{"/tb_show_ukraynske/","ТБ - шоу"},
		{"","ПОШУК"},
}

  local t={}
  for i=1,#pll do
    t[i] = {}
    t[i].Id = i
    t[i].Name = pll[i][2]
    t[i].Action = pll[i][1]  end

  if last_adr and last_adr ~= '' then
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info '}
  end
  t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Виберіть категорію UA',0,t,9000,1+4+8)

  if ret == -1 or not id then
   return
  end
  if ret == 1 then
   if t[id].Name == 'ПОШУК' then
	search()
   else
    page_ua('https://kino4ua.com' .. t[id].Action .. 'page/' .. 1 .. '/')
   end
  end
  if ret == 2 then
   ua_info(last_adr)
  end
  if ret == 3 then
   run_westSide_portal()
  end
end

function page_ua(url)

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local rc, answer = m_simpleTV.Http.Request(session, {url = url})

		if rc ~= 200 then return end
		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
		local title = answer:match('<title>(.-)</title>')
		title = title:gsub(' онлайн.-$',''):gsub('Дивитися ',''):gsub('&.-$','')
		local t,i={},1
			for w in answer:gmatch('<div class="movie%-img img%-box">.-<div class="movie%-rate">') do
				local year = w:match('/year/(.-)/') or 0
				local adr, name = w:match('<a class="movie%-title" href="(.-)" title="(.-)"')
				local logo = w:match('src="(.-)"')
				local overview = w:match('<div class="movie%-text">(.-)</div>') or ''
				if not logo or not adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].InfoPanelLogo = 'https://kino4ua.com' .. logo
				t[i].Name = name:gsub('%&quot%;','"'):gsub('%&#039%;','`') .. ' (' .. year .. ')'
				t[i].Address = adr
				t[i].InfoPanelName = 'UA info: ' .. name:gsub('%&quot%;','"'):gsub('%&#039%;','`') .. ' (' .. year .. ')'
				t[i].InfoPanelShowTime = 30000
				t[i].InfoPanelTitle = overview:gsub('<.->','')
			    i = i + 1
			end
		local prev_pg, next_pg
		next_pg = answer:match('<span class="pnext"><a href="(.-)">Вперед</a></span>')
		prev_pg = answer:match('<span class="pprev"><a href="(.-)">Назад</a></span>')

		if next_pg then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
		else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
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
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			ua_info(t[id].Address)
		end
		if ret == 2 then
		if prev_pg then
		  page_ua(prev_pg)
		else
		  run_lite_qt_ua()
		end
		end
		if ret == 3 then
		  page_ua(next_pg)
		end
		end

function ua_info(url)

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
	else tooltip_body = 'bgcolor="#182633"'
	end
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})

		if rc ~= 200 then return end
		answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local title = answer:match('<h1 itemprop="name">(.-)</h1>') or answer:match('<title>(.-)</title>')
	title = title:gsub(' дивитися онлайн.-$', '')
	local title1 = answer:match('назва:.-<div class="mi%-desc">(.-)</div>')
	if title1 then title1 = '<h4>' .. title1:gsub('^ ', '') .. '</h4>' else title1 = '' end
	local poster = answer:match('<meta property="og:image" content="(.-)"')
	poster = 'https://kino4ua.com/uploads/posts/' .. poster
	local rating = answer:match('Рейтинг IMDB та Кінопошук" src="(.-)"')
	if rating then rating = 'https://kino4ua.com' .. rating else rating = '' end
	local year = answer:match('/year/(.-)/') or ''
	local country = answer:match('countryOfOrigin">(.-)<') or ''
	local desc = answer:match('<meta name="description" content="(.-)"') or ''
	local director = answer:match('itemprop="director">(.-)<')
	if director then director = '<h4>Режисер: ' .. director .. '</h4>' else director = '' end
	local actors = answer:match('<span itemprop="actor">(.-)</span>')
	if actors then actors = '<h4>Актори: ' .. actors:gsub('<.->','') .. '</h4>' else actors = '' end
	local videodesc = answer:match('itemprop="description">(.-)</div>') or desc
	videodesc= '<table width="100%"><tr><td style="padding: 5px 5px 0px;"><img src="' .. poster .. '" width="320"><p><img src="' .. rating .. '" width="320"></td><td style="padding: 5px 5px 0px; color: #AAAAAA; vertical-align: middle;"><h3><font color=#00FA9A>' .. title .. '</font></h3>' .. title1 .. '<h4>' .. year .. ' • '.. country .. '</h4>' .. director .. actors .. '</td></tr></table><table width="100%"><tr><td style="padding: 0px 5px 0px; color: #FFFFFF;"><h4>' .. videodesc:gsub('<.->','') .. '</h4></td></tr></table>'
	videodesc = videodesc:gsub('"', '\"')

	local all_tag = answer:match('<div class="m%-desc full%-text clearfix">(.-)<div class="fullstory"') or ''
	local all_plus = answer:match('<div class="rel%-box" id="owl%-rel">(.-)</article>') or ''

	local t1,j={},2
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Address = ''
		t1[1].Name = '.: info :.'
		t1[1].InfoPanelLogo = poster
		t1[1].InfoPanelName = title:gsub('%&#039%;','`') .. ': UA info'
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc:gsub('%&#039%;','`') .. '</body></html>'
		t1[1].InfoPanelTitle = desc:gsub('%&#039%;','`')
		t1[1].InfoPanelShowTime = 10000

        for w in all_tag:gmatch('<a.-</a>') do
		local adr,name = w:match('href="(.-)">(.-)<')
		if not adr or not name then break end
		t1[j]={}
		t1[j].Id = j
		t1[j].Address = adr
		if adr:match('/actors/') then name = 'Актор: ' .. name:gsub('%&#039%;','`') end
		if adr:match('/director/') then name = 'Режисер: ' .. name:gsub('%&#039%;','`') end
		t1[j].Name = name
		j=j+1
		end
		for w in all_plus:gmatch('<a.-</a>') do
		local adr,logo,name = w:match('href="(.-)".-src="(.-)".-<div class="rel%-movie%-title">(.-)</div>')
		if not adr or not name or not logo then break end
		t1[j]={}
		t1[j].Id = j
		t1[j].Address = adr
		t1[j].Name = 'Схожий контент: ' .. name:gsub('%&#039%;','`')
		t1[j].InfoPanelLogo = 'https://kino4ua.com' .. logo
		t1[j].InfoPanelName = name:gsub('%&#039%;','`')
		t1[j].InfoPanelShowTime = 10000
		j=j+1
		end

		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play '}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('UA: ' .. title:gsub('%&#039%;','`'), 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			if id == 1 then
			 ua_info(url)
			elseif t1[id].Name:match('Схожий контент: ') then
			 ua_info(t1[id].Address)
			else
			 page_ua(t1[id].Address)
			end
		end
		if ret == 2 then
			run_lite_qt_ua()
		end
		if ret == 3 then
			retAdr = url
			m_simpleTV.Control.ChangeAddress = 'No'
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.PlayAddress(retAdr)
		end
end