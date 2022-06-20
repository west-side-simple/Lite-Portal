-- скрапер TVS для сайта https://izib.uk от west_side (05/08/21)
-- необходим скрипт izibuk.lua
	module('izibuk_WS_pls', package.seeall)
	local my_src_name = 'Аудиокниги'
	
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://izibuk.ru/images/izilogo.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 0, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0,GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 2}}
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
	local url = playlist .. '?p=' .. page
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
			if rc ~= 200 then break end
			str = str .. answer:gsub('\n', ' ')
			page = page + 1
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/progress1/p' .. math.floor(((page-1)/tonumber(count)*100)+0.5) .. '.png"', text = ' IziBuk (' .. pls_name .. ') - общий прогресс загрузки: ' .. page-1, color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
	end
	 return str
	end

	local function LoadFromSite(playlist, pls_name, count)
		local t, i = {}, 1
		local name, adr, logo
		local answer = LoadFromPage(playlist, pls_name, count)
			for w in answer:gmatch('<div class="_ccb9b7(.-)</div>  </div> </div>') do
				local name1 = w:match('<a href="/author.-">(.-)</a>') or ''
				local name2 = w:match('<a href="/book.-">(.-)</a>')
				name = name1 .. ' - ' .. name2				
				local adr = w:match('<a class="_bce453" href="(.-)">')
				local logo = w:match('src="(.-)"') or ''
				local group = pls_name
				if not name or not adr then break end
				t[i] = {}
				t[i].group = 'IziBuk - ' .. group
				t[i].logo = logo
				t[i].name = name				
				t[i].address = 'https://izibuk.ru' .. adr
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

{"https://izibuk.ru/genre1","Фантастика, фэнтези",650},
{"https://izibuk.ru/genre4","Детективы, триллеры, боевики",290},
{"https://izibuk.ru/genre7","Аудиоспектакли, радиопостановки и литературные чтения",50},
{"https://izibuk.ru/genre14","Бизнес, личностный рост",25},
{"https://izibuk.ru/genre22","Биографии, мемуары, ЖЗЛ",40},
{"https://izibuk.ru/genre6","Для детей, аудиосказки, стишки",90},
{"https://izibuk.ru/genre12","История, культурология",50},
{"https://izibuk.ru/genre13","Классика",60},
{"https://izibuk.ru/genre21","Медицина, здоровье",10},
{"https://izibuk.ru/genre15","На иностранных языках",5},
{"https://izibuk.ru/genre11","Научно-популярное",25},
{"https://izibuk.ru/genre17","Обучение",5},
{"https://izibuk.ru/genre18","Поэзия",10},
{"https://izibuk.ru/genre8","Приключения, военные приключения",40},
{"https://izibuk.ru/genre2","Психология, философия",50},
{"https://izibuk.ru/genre16","Разное",45},
{"https://izibuk.ru/genre20","Ранобэ",40},
{"https://izibuk.ru/genre19","Религия",10},
{"https://izibuk.ru/genre3","Роман, проза",350},
{"https://izibuk.ru/genre10","Ужасы, мистика, хоррор",60},
{"https://izibuk.ru/genre5","Эзотерика, Нетрадиционные религиозно-философские учения",25},
{"https://izibuk.ru/genre9","Юмор, сатира",25},
}

  local t={}
  for i=1,#pll do
    t[i] = {}
    t[i].Id = i
    t[i].Name = pll[i][2]
	t[i].Count = pll[i][3]
    t[i].Action = pll[i][1]
  end

  local playlist, pls_name, count
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('IziBuk - select playlist',0,t,9000,1+4+8)
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