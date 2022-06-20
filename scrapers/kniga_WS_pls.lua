-- скрапер TVS для сайта https://knigavuhe.org от west_side (08/08/21)
-- необходим скрипт knigavuhe.lua
	module('kniga_WS_pls', package.seeall)
	local my_src_name = 'Аудиокниги 2'
	
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://knigavuhe.org/images/apple-touch-icon-180.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 0, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0,GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 2}}
	end

	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function LoadFromPage(playlist, pls_name, count)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.2785.143 Safari/537.36', prx, false)
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)
		local str, page = '', 1
	while page <= tonumber(count) do
	local url = playlist .. page .. '/'
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
			if rc ~= 200 then break end
			str = str .. answer:gsub('\n', '')
			page = page + 1
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/progress1/p' .. math.floor(((page-1)/tonumber(count)*100)+0.5) .. '.png"', text = ' Книга в ухе (' .. pls_name .. ') - общий прогресс загрузки: ' .. page-1, color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
	end
	 return str
	end

	local function LoadFromSite(playlist, pls_name, count)
		local t, i = {}, 1
		local name, adr, logo
		local answer = LoadFromPage(playlist, pls_name, count)
			for w in answer:gmatch('<a class="bookkitem_cover"(.-)</div>          </div>  </div>') do
				local name1 = w:match('<a href="/author.-">(.-)</a>') or ''
				local name2 = w:match('<a href="/book.-">(.-)</a>')
				name = name1 .. ' - ' .. name2				
				local adr = w:match('href="(.-)">')
				local logo = w:match('src="(.-)"') or ''
				local group = w:match('<a href="/genre.-">(.-)</a>') or ''
				if not name or not adr then break end
				t[i] = {}
				t[i].group = 'Книга в ухе - ' .. group
				t[i].logo = logo
				t[i].name = name				
				t[i].address = 'https://knigavuhe.org' .. adr
			    i = i + 1
			end
	 return t
	end

	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]		

		local pll={

{"https://knigavuhe.org/genre/audiospektakli/",120,"Аудиоспектакли"},


{"https://knigavuhe.org/genre/biznes/",30,"Бизнес"},


{"https://knigavuhe.org/genre/biografii-memuary/",70,"Биографии, мемуары"},


{"https://knigavuhe.org/genre/detektivy-trillery/",480,"Детективы, триллеры"},


{"https://knigavuhe.org/genre/dlja-detejj/",180,"Для детей, Аудиосказки"},


{"https://knigavuhe.org/genre/istorija/",90,"История"},


{"https://knigavuhe.org/genre/klassika/",120,"Классика"},


{"https://knigavuhe.org/genre/medicina-zdorove/",10,"Медицина, здоровье"},


{"https://knigavuhe.org/genre/na-inostrannykh-jazykakh/",10,"На иностранных языках"},


{"https://knigavuhe.org/genre/nauchno-populjarnoe/",40,"Научно-популярное"},


{"https://knigavuhe.org/genre/obuchenie/",10,"Обучение"},


{"https://knigavuhe.org/genre/poehzija/",30,"Поэзия"},


{"https://knigavuhe.org/genre/prikljuchenija/",90,"Приключения"},


{"https://knigavuhe.org/genre/psikhologija-filosofija/",70,"Психология, философия"},


{"https://knigavuhe.org/genre/raznoe/",60,"Разное"},


{"https://knigavuhe.org/genre/ranobeh/",100,"Ранобэ"},


{"https://knigavuhe.org/genre/religija/",20,"Религия"},


{"https://knigavuhe.org/genre/roman-proza/",610,"Роман, проза"},


{"https://knigavuhe.org/genre/uzhasy-mistika/",290,"Ужасы, мистика"},


{"https://knigavuhe.org/genre/fantastika/",930,"Фантастика, фэнтези"},


{"https://knigavuhe.orghttps://litravuhe.ru",50,"Школьная литература"},


{"https://knigavuhe.org/genre/ehzoterika/",60,"Эзотерика"},


{"https://knigavuhe.org/genre/jumor-satira/",70,"Юмор, сатира"},

}

  local t={}
  for i=1,#pll do
    t[i] = {}
    t[i].Id = i
    t[i].Name = pll[i][3]
	t[i].Count = pll[i][2]
    t[i].Action = pll[i][1]
  end

  local playlist, pls_name, count
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Книга в ухе - select playlist',0,t,9000,1+4+8)
  if id==nil then return end
  if ret == 1 then
   playlist = t[id].Action
   pls_name = t[id].Name
   count = t[id].Count
  end

		local t_pls = LoadFromSite(playlist, pls_name, count)		

			if not t_pls then m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'}) return end
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')