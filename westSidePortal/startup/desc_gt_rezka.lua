--Rezka desc west_side 20.05.25

local function Get_rating(rating)
	if rating == nil or rating == '' then return 0 end
	local rat = math.ceil((tonumber(rating)*2 - tonumber(rating)*2%1)/2)
	return rat
end

local function ARGB(A,R,G,B)
   local a = A*256*256*256+R*256*256+G*256+B
   if A<128 then return a end
   return a - 4294967296
end

local function Get_length(str)
	return m_simpleTV.Common.lenUTF8(str)
end

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

local function Get_logo_franchise(adr_site)
	local session = m_simpleTV.Http.New('Mozilla/5.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local id_rezka = adr_site:match('/(%d+)')
	if tonumber(id_rezka) == 74605 then adr_site = adr_site:gsub('%-latest%.html','.html'):gsub('%.html','-latest.html') end
	local rc, answer = m_simpleTV.Http.Request(session, {url = adr_site .. '?app_rules=1', headers = 'X-Requested-With: XMLHttpRequest\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36\nCookie: ' .. m_simpleTV.User.rezka.cookies})
	m_simpleTV.Http.Close(session)
	m_simpleTV.Common.Sleep(200)
	if rc ~= 200 then return end
	local logo = answer:match('<meta property="og:image" content="(.-)"')
	if logo then return logo end
	return
end

local function Get_picon_for_name(name)

	local tt1 = {
	{'Мои фильмы','films.svg',42,32},
	{'Мои сериалы','series.svg',42,32},
	{'Мои мультфильмы','cartoons.svg',38,34},
	{'Мои аниме','anime.svg',34,34},
	}
	for i = 1,#tt1 do
		if name:match(tt1[i][1]) then
			return tt1[i][2],tt1[i][3],tt1[i][4]
		end
	end
end

function tooltip_clear_WS(ObjectName,EventName,data)
--[[	debug_in_file('name:' .. ObjectName .. '\n')
	debug_in_file('envent:' .. EventName .. '\n');

	if EventName == 'mousePressEvent' then
	debug_in_file('x:' .. data.x .. '\n');
	debug_in_file('y:' .. data.y .. '\n');
	debug_in_file('button:' .. data.button .. '\n');
	elseif EventName == 'mouseReleaseEvent' then
	debug_in_file('x:' .. data.x .. '\n');
	debug_in_file('y:' .. data.y .. '\n');
	debug_in_file('button:' .. data.button .. '\n');
	elseif EventName == 'mouseDoubleClickEvent' then
	debug_in_file('x:' .. data.x .. '\n');
	debug_in_file('y:' .. data.y .. '\n');
	debug_in_file('button:' .. data.button .. '\n');
	elseif EventName == 'mouseMoveEvent' then
	debug_in_file('x:' .. data.x .. '\n');
	debug_in_file('y:' .. data.y .. '\n');
	debug_in_file('buttons:' .. data.buttons .. '\n');
	end

	debug_in_file('\n\n\n');--]]
	m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_ID')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST1')
	m_simpleTV.OSD.RemoveElement('ID_LOGO_STENA_REQUEST')
	m_simpleTV.User.stena_rezka.back.old_request = false
end

function tooltip_WS(ObjectName,EventName,data)
	if not ObjectName then return end
	local x
	local y
	local mes
	local align
	local  t, AddElement = {}, m_simpleTV.OSD.AddElement
	if ObjectName:match('/films/') then
		mes = 'Фильмы'
		x = 90
		y = 140
	end
	if ObjectName:match('/series/') then
		mes = 'Сериалы'
		x = 170
		y = 140
	end
	if ObjectName:match('/cartoons/') then
		mes = 'Мульты'
		x = 250
		y = 140
	end
	if ObjectName:match('/animation/') then
		mes = 'Аниме'
		x = 330
		y = 140
	end
	if ObjectName:match('COLLECTIONS_IMG') then
		mes = 'Коллекции'
		x = 410
		y = 140
	end
	if ObjectName:match('FRANCHISES_IMG') then
		mes = 'Франшизы'
		x = 490
		y = 140
	end
	if ObjectName:match('FAVORITE_IMG') then
		mes = 'Избранное'
		x = 570
		y = 140
	end
	if ObjectName:match('LEFT_IMG') then
		mes = 'back'
		x = 650
		y = 140
	end
	if ObjectName:match('INFO_IMG') then
		mes = 'last'
		x = 730
		y = 140
	end

	if ObjectName:match('CLEAR_IMG') then
		mes = 'Очистить'
		x = 90
		y = 140
		align = 0x0103
	end
	if ObjectName:match('NEXT_IMG') then
		mes = 'Следующая'
		x = 170
		y = 140
		align = 0x0103
	end
	if ObjectName:match('PAGE_IMG') then
		mes = 'Страница'
		x = 250
		y = 140
		align = 0x0103
	end
	if ObjectName:match('PREV_IMG') then
		mes = 'Предыдущая'
		x = 330
		y = 140
		align = 0x0103
	end
	if ObjectName:match('HISTORY_IMG') then
		mes = 'Поиск ⟲'
		x = 410
		y = 140
		align = 0x0103
	end
	if ObjectName:match('SEARCH_IMG') then
		mes = 'Поиск'
		x = 490
		y = 140
		align = 0x0103
	end
	if ObjectName:match('PERSON') then
		mes = 'Добавить'
		x = 650
		y = 140
		align = 0x0103
	end
	if ObjectName:match('FRANCHISES_BACK') then
		mes = 'Play'
		x = 650
		y = 140
		align = 0x0103
	end
	if mes then
		m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_ID')

			     t = {}
				 t.id = 'STENA_TOOLTIP_ID'
				 t.cx=140
				 t.cy=40
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = align or 0x0101
				 t.left=x
				 t.top=y
				 t.once=1
				 t.zorder=1
				 t.background = -1
				 t.backcolor0 = 0xff0000000
				 AddElement(t)

				t={}
				t.id = 'IMG_STENA_TOOLTIP_ID'
				t.cx=140
				t.cy=40
				t.class="IMAGE"
				t.zorder=2
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 0
				t.top  = 0
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 2*2
				t.borderround = 2
				AddElement(t,'STENA_TOOLTIP_ID')

				 t={}
				 t.id = 'TEXT_STENA_TOOLTIP_ID'
				 t.cx=0
				 t.cy=0
				 t.class="TEXT"
				 t.zorder=2
				 t.align = 0x0202
				 t.text = mes
				 t.color = ARGB (255, 36, 36, 36)
				 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_name = "Segoe UI Black"
				 t.textparam = 0x00000001
				 t.boundWidth = 15 -- bound to screen
				 t.row_limit=1 -- row limit
				 t.scrollTime = 20 --for ticker (auto scrolling text)
				 t.scrollFactor = 4
				 t.text_elidemode = 2
				 t.scrollWaitStart = 40
				 t.scrollWaitEnd = 100
				 t.left = 0
				 t.top  = 0
--				 t.glow = 2 -- коэффициент glow эффекта
--				 t.glowcolor = 0xFF000077 -- цвет glow эффекта
				 AddElement(t,'STENA_TOOLTIP_ID')

	end
end

function genres_rezka_id(id)
	if not id then return end
	m_simpleTV.User.stena_rezka.back.current_page_karusel = nil
	if id:match('PREV') then
		return last_rezka(m_simpleTV.User.stena_rezka.back.filter,m_simpleTV.User.stena_rezka.back.title:gsub(' %(.-$',''),tonumber(m_simpleTV.User.stena_rezka.back.current_page) - 1)
	end
	if id:match('NEXT') then
		return last_rezka(m_simpleTV.User.stena_rezka.back.filter,m_simpleTV.User.stena_rezka.back.title:gsub(' %(.-$',''),tonumber(m_simpleTV.User.stena_rezka.back.current_page) + 1)
	end
	local adr = id:match('&(.-)$')
	if not adr then return end
	adr = adr:gsub('%?.-$',''):gsub('^https://.-/','/')
--  debug_in_file(adr .. '\n')
-----------------
local t1 = {
{"/films/","любого жанра"},
{"/films/western/","Вестерны"},
{"/films/family/","Семейные"},
{"/films/fantasy/","Фэнтези"},
{"/films/biographical/","Биографические"},
{"/films/arthouse/","Арт-хаус"},
{"/films/action/","Боевики"},
{"/films/military/","Военные"},
{"/films/detective/","Детективы"},
{"/films/crime/","Криминал"},
{"/films/adventures/","Приключения"},
{"/films/drama/","Драмы"},
{"/films/sport/","Спортивные"},
{"/films/fiction/","Фантастика"},
{"/films/comedy/","Комедии"},
{"/films/melodrama/","Мелодрамы"},
{"/films/thriller/","Триллеры"},
{"/films/horror/","Ужасы"},
{"/films/musical/","Мюзиклы"},
{"/films/historical/","Исторические"},
{"/films/documentary/","Документальные"},
{"/films/erotic/","Эротика"},
{"/films/kids/","Детские"},
{"/films/travel/","Путешествия"},
{"/films/cognitive/","Познавательные"},
{"/films/theatre/","Театр"},
{"/films/concert/","Концерт"},
{"/films/standup/","Стендап"},
{"/films/short/","Короткометражные"},
{"/films/russian/","Русские"},
{"/films/ukrainian/","Украинские"},
{"/films/foreign/","Зарубежные"},
}
local t2 = {
{"/series/","любого жанра"},
{"/series/military/","Военные"},
{"/series/action/","Боевики"},
{"/series/arthouse/","Арт-хаус"},
{"/series/thriller/","Триллеры"},
{"/series/horror/","Ужасы"},
{"/series/adventures/","Приключения"},
{"/series/family/","Семейные"},
{"/series/fiction/","Фантастика"},
{"/series/fantasy/","Фэнтези"},
{"/series/drama/","Драмы"},
{"/series/melodrama/","Мелодрамы"},
{"/series/sport/","Спортивные"},
{"/series/comedy/","Комедии"},
{"/series/detective/","Детективы"},
{"/series/crime/","Криминал"},
{"/series/historical/","Исторические"},
{"/series/biographical/","Биографические"},
{"/series/western/","Вестерны"},
{"/series/documentary/","Документальные"},
{"/series/musical/","Музыкальные"},
{"/series/realtv/","Реальное ТВ"},
{"/series/telecasts/","Телепередачи"},
{"/series/standup/","Стендап"},
{"/series/erotic/","Эротика"},
{"/series/russian/","Русские"},
{"/series/ukrainian/","Украинские"},
{"/series/foreign/","Зарубежные"},
}
local t3 = {
{"/cartoons/","любого жанра"},
{"/cartoons/fiction/","Фантастика"},
{"/cartoons/fantasy/","Фэнтези"},
{"/cartoons/action/","Боевики"},
{"/cartoons/biographical/","Биографические"},
{"/cartoons/comedy/","Комедии"},
{"/cartoons/western/","Вестерны"},
{"/cartoons/military/","Военные"},
{"/cartoons/drama/","Драмы"},
{"/cartoons/melodrama/","Мелодрамы"},
{"/cartoons/arthouse/","Арт-хаус"},
{"/cartoons/detective/","Детективы"},
{"/cartoons/crime/","Криминал"},
{"/cartoons/thriller/","Триллеры"},
{"/cartoons/historical/","Исторические"},
{"/cartoons/documentary/","Документальные"},
{"/cartoons/erotic/","Эротика"},
{"/cartoons/fairytale/","Сказки"},
{"/cartoons/family/","Семейные"},
{"/cartoons/horror/","Ужасы"},
{"/cartoons/adventures/","Приключения"},
{"/cartoons/sport/","Спортивные"},
{"/cartoons/cognitive/","Познавательные"},
{"/cartoons/musical/","Мюзиклы"},
{"/cartoons/kids/","Детские"},
{"/cartoons/adult/","Для взрослых"},
{"/cartoons/multseries/","Мультсериалы"},
{"/cartoons/short/","Короткометражные"},
{"/cartoons/full-length/","Полнометражные"},
{"/cartoons/soyzmyltfilm/","Советские"},
{"/cartoons/russian/","Русские"},
{"/cartoons/ukrainian/","Украинские"},
{"/cartoons/foreign/","Зарубежные"},
}
local t4 = {
{"/animation/","любого жанра"},
{"/animation/military/","Военные"},
{"/animation/drama/","Драмы"},
{"/animation/detective/","Детективы"},
{"/animation/thriller/","Триллеры"},
{"/animation/comedy/","Комедии"},
{"/animation/fiction/","Фантастика"},
{"/animation/fantasy/","Фэнтези"},
{"/animation/adventures/","Приключения"},
{"/animation/romance/","Романтические"},
{"/animation/historical/","Исторические"},
{"/animation/horror/","Ужасы"},
{"/animation/mystery/","Мистические"},
{"/animation/musical/","Музыкальные"},
{"/animation/erotic/","Эротика"},
{"/animation/action/","Боевики"},
{"/animation/fighting/","Боевые искусства"},
{"/animation/samurai/","Самур. боевик"},
{"/animation/sport/","Спортивные"},
{"/animation/educational/","Образовательные"},
{"/animation/everyday/","Повседневность"},
{"/animation/parody/","Пародия"},
{"/animation/school/","Школа"},
{"/animation/kids/","Детские"},
{"/animation/fairytale/","Сказки"},
{"/animation/kodomo/","Кодомо"},
{"/animation/shoujoai/","Сёдзё-ай"},
{"/animation/shoujo/","Сёдзё"},
{"/animation/shounen/","Сёнэн"},
{"/animation/shounenai/","Сёнэн-ай"},
{"/animation/ecchi/","Этти"},
{"/animation/mahoushoujo/","Махо-сёдзё"},
{"/animation/mecha/","Меха"},
}
	if adr:match('/films/')	then
		for j = 1,#t1 do
			if adr == t1[j][1] then
				m_simpleTV.User.stena_rezka.back.genres_id = j
				m_simpleTV.User.stena_rezka.back.type = 'films'
				return last_rezka(t1[j][1],'Фильмы: ' .. t1[j][2],1)
			end
		end
	end
	if adr:match('/series/')	then
		for j = 1,#t2 do
			if adr == t2[j][1] then
				m_simpleTV.User.stena_rezka.back.genres_id = j
				m_simpleTV.User.stena_rezka.back.type = 'series'
				return last_rezka(t2[j][1],'Сериалы: ' .. t2[j][2],1)
			end
		end
	end
	if adr:match('/cartoons/')	then
		for j = 1,#t3 do
			if adr == t3[j][1] then
				m_simpleTV.User.stena_rezka.back.genres_id = j
				m_simpleTV.User.stena_rezka.back.type = 'cartoons'
				return last_rezka(t3[j][1],'Мульты: ' .. t3[j][2],1)
			end
		end
	end
	if adr:match('/animation/')	then
		for j = 1,#t4 do
			if adr == t4[j][1] then
				m_simpleTV.User.stena_rezka.back.genres_id = j
				m_simpleTV.User.stena_rezka.back.type = 'animation'
				return last_rezka(t4[j][1],'Аниме: ' .. t4[j][2],1)
			end
		end
	end
-----------------
end

function stena_rezka()
--	debug_in_file(m_simpleTV.User.stena_rezka.back.filter .. '\n--------\n')
			m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
			m_simpleTV.OSD.RemoveElement('ID_DIV_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_3')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST1')
			m_simpleTV.OSD.RemoveElement('ID_LOGO_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_ID')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR1_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR2_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR3_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR4_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR5_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR6_TOOLTIP_WS')
			m_simpleTV.User.TVPortal.stena_rezka_info = false
			m_simpleTV.User.TVPortal.stena_rezka_use = true
			m_simpleTV.User.TVPortal.stena_rezka_busy = true
			m_simpleTV.User.TVPortal.stena_filmix_use = false
			m_simpleTV.User.TVPortal.stena_filmix_info = false
			m_simpleTV.User.TVPortal.stena_info = false
			m_simpleTV.User.TVPortal.stena_search_use = false
			m_simpleTV.User.TVPortal.stena_genres = false
			m_simpleTV.User.TVPortal.stena_use = false
			m_simpleTV.User.TVPortal.stena_home = false
			m_simpleTV.User.stena_rezka.back.old_request = false
			m_simpleTV.Interface.RestoreBackground()
			local  t, AddElement = {}, m_simpleTV.OSD.AddElement
			local add = 0

				 t = {}
				 t.id = 'STENA_CLEAR1_TOOLTIP_WS'
				 t.cx=-100
				 t.cy=10
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=150
				 t.once=1
				 t.zorder=0
--				 t.background = 2 --for test
--				 t.backcolor0 = 0x000000ff --for test
--				 t.backcolor1 = 0x66000000 --for test
				 t.isInteractive = true
				 t.mouseMoveEventFunction = 'tooltip_clear_WS'
				 AddElement(t)

				 t = {}
				 t.id = 'STENA_CLEAR2_TOOLTIP_WS'
				 t.cx=-100
				 t.cy=10
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=160
				 t.once=1
				 t.zorder=0
--				 t.background = 2 --for test
--				 t.backcolor0 = 0x66000000 --for test
--				 t.backcolor1 = 0x000000ff --for test
				 t.isInteractive = true
				 t.mouseMoveEventFunction = 'tooltip_clear_WS'
				 AddElement(t)

				 t = {}
				 t.id = 'STENA_CLEAR3_TOOLTIP_WS'
				 t.cx=-100
				 t.cy=10
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=300
				 t.once=1
				 t.zorder=0
--				 t.background = 2 --for test
--				 t.backcolor0 = 0x000000ff --for test
--				 t.backcolor1 = 0x99000000 --for test
				 t.isInteractive = true
--				 t.mouseMoveEventFunction = 'tooltip_clear_WS'
--				 AddElement(t)

				 t = {}
				 t.id = 'STENA_CLEAR4_TOOLTIP_WS'
				 t.cx=-100
				 t.cy=10
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=310
				 t.once=1
				 t.zorder=0
--				 t.background = 2 --for test
--				 t.backcolor0 = 0x99000000 --for test
--				 t.backcolor1 = 0x000000ff --for test
				 t.isInteractive = true
				 t.mouseMoveEventFunction = 'tooltip_clear_WS'
--				 AddElement(t)

				 t = {}
				 t.id = 'STENA_CLEAR5_TOOLTIP_WS'
				 t.cx=-100
				 t.cy=50
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=910
				 t.once=1
				 t.zorder=0
--				 t.background = 2 --for test
--				 t.backcolor0 = 0x000000ff --for test
--				 t.backcolor1 = 0x99000000 --for test
				 t.isInteractive = true
				 t.mouseMoveEventFunction = 'tooltip_clear_WS'
				 AddElement(t)

				 t = {}
				 t.id = 'STENA_CLEAR6_TOOLTIP_WS'
				 t.cx=-100
				 t.cy=50
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=960
				 t.once=1
				 t.zorder=0
--				 t.background = 2 --for test
--				 t.backcolor0 = 0x99000000 --for test
--				 t.backcolor1 = 0x000000ff --for test
				 t.isInteractive = true
				 t.mouseMoveEventFunction = 'tooltip_clear_WS'
				 AddElement(t)

				 t = {}
				 t.id = 'ID_DIV_STENA_1'
				 t.cx=-100
				 t.cy=-100
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=-70 / m_simpleTV.Interface.GetScale()*1.5
				 t.once=1
				 t.zorder=1
				 t.background = -1
				 t.backcolor0 = 0xff0000000
				 AddElement(t)

				 t = {}
				 t.id = 'ID_DIV_STENA_2'
				 t.cx=-100
				 t.cy=-100
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=0
				 t.once=1
				 t.zorder=0
				 t.background = 1
				 t.backcolor0 = 0x440000FF
--				 t.backcolor1 = 0x77FFFFFF
				 AddElement(t)

				 t = {}
				 t.id = 'ID_DIV_STENA_3'
				 t.cx=-100
				 t.cy=-100
				 t.class="DIV"
				 t.minresx=0
				 t.minresy=0
				 t.align = 0x0101
				 t.left=0
				 t.top=-100
				 t.once=1
				 t.zorder=1
				 t.background = -1
				 t.backcolor0 = 0xff0000000
				 AddElement(t)

				 t = {}
				 t.id = 'FON_STENA_ID'
				 t.cx= -100
				 t.cy= -100
				 t.class="IMAGE"
				 t.animation = true
				 t.imagepath = 'type="dir" count="150" delay="60" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/cerberus/cerberus%1.png"'
				 t.minresx=-1
				 t.minresy=-1
				 t.align = 0x0101
				 t.left=0
				 t.top=0
				 t.transparency = 255
				 t.zorder=1
				 AddElement(t,'ID_DIV_STENA_2')

				 t = {}
				 t.id = 'GLOBUS_STENA_ID'
				 t.cx= 60
				 t.cy= 60
				 t.class="IMAGE"
				 t.animation = true
				 t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/3d/d%0.png"'
				 t.minresx=-1
				 t.minresy=-1
				 t.align = 0x0103
				 t.left=15
				 t.top=110
				 t.transparency = 255
				 t.zorder=2
				 t.isInteractive = true
				 t.cursorShape = 13
--				 if not m_simpleTV.User.TVPortal.stena_rezka or not m_simpleTV.User.TVPortal.stena_rezka.current_address then
				 t.mousePressEventFunction = 'start_page_mediaportal'
--				 else
--				 t.mousePressEventFunction = 'rezka_info'
--				 end
				 AddElement(t,'ID_DIV_STENA_1')

				 t={}
				 t.id = 'TEXT_STENA_TITLE_ID'
				 t.cx=-66
				 t.cy=0
				 t.class="TEXT"
				 t.align = 0x0102
				 if m_simpleTV.User.stena_rezka.back.type == 'films'
					or m_simpleTV.User.stena_rezka.back.type == 'series'
					or m_simpleTV.User.stena_rezka.back.type == 'cartoons'
					or m_simpleTV.User.stena_rezka.back.type == 'animation' then
					t.text = m_simpleTV.User.stena_rezka.back.title .. ' ' .. (m_simpleTV.User.stena_rezka.back.filter_type_name or '')
				 else
					t.text = m_simpleTV.User.stena_rezka.back.title
				 end
				 t.color = -2113993
				 t.font_height = -25 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
				 t.font_name = m_simpleTV.User.TVPortal.stena_exfs_title_font or 'Segoe UI Black'
				 t.textparam = 0x00000001
				 t.boundWidth = 15 -- bound to screen
				 t.row_limit=1 -- row limit
				 t.scrollTime = 20 --for ticker (auto scrolling text)
				 t.scrollFactor = 4
				 t.text_elidemode = 2
				 t.scrollWaitStart = 40
				 t.scrollWaitEnd = 100
				 t.left = 0
				 t.top  = 100
				 t.glow = 2 -- коэффициент glow эффекта
				 t.glowcolor = 0xFF000077 -- цвет glow эффекта
				 AddElement(t,'ID_DIV_STENA_1')
-------------------
				t = {}
				t.id = 'STENA_REZKA_START_IMG_ID&/films/'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/movie.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 90
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
--				m_simpleTV.User.stena_rezka.back.type
				if m_simpleTV.User.stena_rezka.back.type == 'films' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'genres_rezka_id'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_REZKA_START_IMG_ID&/series/'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/tv.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 170
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.stena_rezka.back.type == 'series' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'genres_rezka_id'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_REZKA_START_IMG_ID&/cartoons/'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/mult.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 250
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.stena_rezka.back.type == 'cartoons' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'genres_rezka_id'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_REZKA_START_IMG_ID&/animation/'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/multserial.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 330
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.stena_rezka.back.type == 'animation' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'genres_rezka_id'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_REZKA_COLLECTIONS_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/collections.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 410
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.stena_rezka.back.type == 'collections' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'collection_rezka'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_REZKA_FRANCHISES_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/cartoons.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 490
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.stena_rezka.back.type == 'franchises' then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'franchises_rezka'
				AddElement(t,'ID_DIV_STENA_1')

			if m_simpleTV.User.rezka.favorites then
				t = {}
				t.id = 'STENA_REZKA_FAVORITE_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/favorite.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 570
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				if m_simpleTV.User.stena_rezka.back.type:match('favorite') then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'get_favorites_for_address'
				AddElement(t,'ID_DIV_STENA_1')
			end
			
			if m_simpleTV.User.TVPortal.stena_rezka and m_simpleTV.User.TVPortal.stena_rezka.current_address then
				t = {}
				t.id = 'STENA_REZKA_LEFT_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/left.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 650
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'rezka_info'
				AddElement(t,'ID_DIV_STENA_1')
			end

			local last_adr = getConfigVal('info/rezka') or ''
			if last_adr and last_adr ~= '' then
				t = {}
				t.id = 'STENA_REZKA_INFO_IMG_ID&' .. last_adr
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/right.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 730
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'last_media_info_rezka'
				AddElement(t,'ID_DIV_STENA_1')
			end	

				t = {}
				t.id = 'STENA_REZKA_AVATAR_IMG_ID'
				t.class="IMAGE"
				if m_simpleTV.User.rezka.account then
				t.cx=177
				t.cy=40
				t.top  = 180
				t.imagepath = 'https://rezka-ua.org/templates/hdrezka/images/hd_prem_logo.png'
				else
				t.cx=224
				t.cy=60
				t.top  = 170
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/FM_HDrezka.gif'
--				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/FM_HDrezka.png' -- variant
				end
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0102
				t.left = 0
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
--				t.bordercolor = -6250336
				if m_simpleTV.User.stena_rezka.back.type:match('start') then
				t.bordercolor = -1250336
				t.borderwidth = 4
				end
				t.backroundcorner = 4*4
				t.borderround = 4
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'get_start'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_REZKA_AVATAR_TXT_ID'
				t.cx=0
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.rezka.account or ''
				t.color = ARGB(255 ,152, 152, 152)
				t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
				t.boundWidth = 15
				t.text_elidemode = 2
				t.glow = 1 -- коэффициент glow эффекта
				t.glowcolor = 0xFF770077 -- цвет glow эффекта
				t.align = 0x0102
				t.left = 0
			    t.top  = 220
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

			if m_simpleTV.User.stena_rezka.back.type ~= 'franchise' then
				t = {}
				t.id = 'STENA_REZKA_PLS_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				if m_simpleTV.User.stena_rezka.back.pls_type_name == 'Таблица' then
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/plst.png'
				else
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/plst_p.png'
				end
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 730
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'change_stena_rezka_pls_type'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_REZKA_PLS_TXT_ID'
				t.cx=0
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.stena_rezka.back.pls_type_name
				t.color = ARGB(255 ,152, 152, 152)
				t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
				t.boundWidth = 15
				t.text_elidemode = 2
				t.glow = 1 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.left = 0
			    t.top  = 56
				t.transparency = 200
				t.zorder=2
				AddElement(t,'STENA_REZKA_PLS_IMG_ID')
			end

			if m_simpleTV.User.stena_rezka.back.type == 'films'
				or m_simpleTV.User.stena_rezka.back.type == 'series'
				or m_simpleTV.User.stena_rezka.back.type == 'cartoons'
				or m_simpleTV.User.stena_rezka.back.type == 'animation' then

				t = {}
				t.id = 'STENA_REZKA_SETTINGS_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/options.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 650
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'change_stena_rezka_filter_type'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_REZKA_TYPE_TXT_ID'
				t.cx=0
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.stena_rezka.back.filter_type_name
				t.color = ARGB(255 ,152, 152, 152)
				t.font_height = -9 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
				t.boundWidth = 15
				t.text_elidemode = 2
				t.glow = 1 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 0
			    t.top  = 56
				t.transparency = 200
				t.zorder=2
				AddElement(t,'STENA_REZKA_SETTINGS_IMG_ID')

			end

				t = {}
				t.id = 'STENA_REZKA_SEARCH_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 490
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'stena_search'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_SEARCH_CONTENT_REZKA_HISTORY_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Search_History.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 410
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
--				t.background = 0
--			    t.backcolor0 = 0x66999999
--			    t.backcolor1 = 0
--				t.backcenterpoint_x = 30
--                t.backcenterpoint_y = 30
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'get_history_of_search'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_REZKA_CLEAR_IMG_ID'
				t.cx=60
				t.cy=60
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Clear.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left = 90
			    t.top  = 170
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.isInteractive = true
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFFFFFFFF
				t.bordercolor = -6250336
				t.backroundcorner = 20*20
				t.borderround = 20
				t.mouseMoveEventFunction = 'tooltip_WS'
				t.mousePressEventFunction = 'stena_clear'
				AddElement(t,'ID_DIV_STENA_1')
-------------------
local t1 = {
{"/films/","любого жанра"},
{"/films/western/","Вестерны"},
{"/films/family/","Семейные"},
{"/films/fantasy/","Фэнтези"},
{"/films/biographical/","Биографические"},
{"/films/arthouse/","Арт-хаус"},
{"/films/action/","Боевики"},
{"/films/military/","Военные"},
{"/films/detective/","Детективы"},
{"/films/crime/","Криминал"},
{"/films/adventures/","Приключения"},
{"/films/drama/","Драмы"},
{"/films/sport/","Спортивные"},
{"/films/fiction/","Фантастика"},
{"/films/comedy/","Комедии"},
{"/films/melodrama/","Мелодрамы"},
{"/films/thriller/","Триллеры"},
{"/films/horror/","Ужасы"},
{"/films/musical/","Мюзиклы"},
{"/films/historical/","Исторические"},
{"/films/documentary/","Документальные"},
{"/films/erotic/","Эротика"},
{"/films/kids/","Детские"},
{"/films/travel/","Путешествия"},
{"/films/cognitive/","Познавательные"},
{"/films/theatre/","Театр"},
{"/films/concert/","Концерт"},
{"/films/standup/","Стендап"},
{"/films/short/","Короткометражные"},
{"/films/russian/","Русские"},
{"/films/ukrainian/","Украинские"},
{"/films/foreign/","Зарубежные"},
}
local t2 = {
{"/series/","любого жанра"},
{"/series/military/","Военные"},
{"/series/action/","Боевики"},
{"/series/arthouse/","Арт-хаус"},
{"/series/thriller/","Триллеры"},
{"/series/horror/","Ужасы"},
{"/series/adventures/","Приключения"},
{"/series/family/","Семейные"},
{"/series/fiction/","Фантастика"},
{"/series/fantasy/","Фэнтези"},
{"/series/drama/","Драмы"},
{"/series/melodrama/","Мелодрамы"},
{"/series/sport/","Спортивные"},
{"/series/comedy/","Комедии"},
{"/series/detective/","Детективы"},
{"/series/crime/","Криминал"},
{"/series/historical/","Исторические"},
{"/series/biographical/","Биографические"},
{"/series/western/","Вестерны"},
{"/series/documentary/","Документальные"},
{"/series/musical/","Музыкальные"},
{"/series/realtv/","Реальное ТВ"},
{"/series/telecasts/","Телепередачи"},
{"/series/standup/","Стендап"},
{"/series/erotic/","Эротика"},
{"/series/russian/","Русские"},
{"/series/ukrainian/","Украинские"},
{"/series/foreign/","Зарубежные"},
}
local t3 = {
{"/cartoons/","любого жанра"},
{"/cartoons/fiction/","Фантастика"},
{"/cartoons/fantasy/","Фэнтези"},
{"/cartoons/action/","Боевики"},
{"/cartoons/biographical/","Биографические"},
{"/cartoons/comedy/","Комедии"},
{"/cartoons/western/","Вестерны"},
{"/cartoons/military/","Военные"},
{"/cartoons/drama/","Драмы"},
{"/cartoons/melodrama/","Мелодрамы"},
{"/cartoons/arthouse/","Арт-хаус"},
{"/cartoons/detective/","Детективы"},
{"/cartoons/crime/","Криминал"},
{"/cartoons/thriller/","Триллеры"},
{"/cartoons/historical/","Исторические"},
{"/cartoons/documentary/","Документальные"},
{"/cartoons/erotic/","Эротика"},
{"/cartoons/fairytale/","Сказки"},
{"/cartoons/family/","Семейные"},
{"/cartoons/horror/","Ужасы"},
{"/cartoons/adventures/","Приключения"},
{"/cartoons/sport/","Спортивные"},
{"/cartoons/cognitive/","Познавательные"},
{"/cartoons/musical/","Мюзиклы"},
{"/cartoons/kids/","Детские"},
{"/cartoons/adult/","Для взрослых"},
{"/cartoons/multseries/","Мультсериалы"},
{"/cartoons/short/","Короткометражные"},
{"/cartoons/full-length/","Полнометражные"},
{"/cartoons/soyzmyltfilm/","Советские"},
{"/cartoons/russian/","Русские"},
{"/cartoons/ukrainian/","Украинские"},
{"/cartoons/foreign/","Зарубежные"},
}
local t4 = {
{"/animation/","любого жанра"},
{"/animation/military/","Военные"},
{"/animation/drama/","Драмы"},
{"/animation/detective/","Детективы"},
{"/animation/thriller/","Триллеры"},
{"/animation/comedy/","Комедии"},
{"/animation/fiction/","Фантастика"},
{"/animation/fantasy/","Фэнтези"},
{"/animation/adventures/","Приключения"},
{"/animation/romance/","Романтические"},
{"/animation/historical/","Исторические"},
{"/animation/horror/","Ужасы"},
{"/animation/mystery/","Мистические"},
{"/animation/musical/","Музыкальные"},
{"/animation/erotic/","Эротика"},
{"/animation/action/","Боевики"},
{"/animation/fighting/","Боевые искусства"},
{"/animation/samurai/","Самур. боевик"},
{"/animation/sport/","Спортивные"},
{"/animation/educational/","Образовательные"},
{"/animation/everyday/","Повседневность"},
{"/animation/parody/","Пародия"},
{"/animation/school/","Школа"},
{"/animation/kids/","Детские"},
{"/animation/fairytale/","Сказки"},
{"/animation/kodomo/","Кодомо"},
{"/animation/shoujoai/","Сёдзё-ай"},
{"/animation/shoujo/","Сёдзё"},
{"/animation/shounen/","Сёнэн"},
{"/animation/shounenai/","Сёнэн-ай"},
{"/animation/ecchi/","Этти"},
{"/animation/mahoushoujo/","Махо-сёдзё"},
{"/animation/mecha/","Меха"},
}
				local dx = 1920/9
				local dy = 160/4
				local tt1
			if m_simpleTV.User.stena_rezka.back.type == 'films' then
				tt1 = t1
			end
			if m_simpleTV.User.stena_rezka.back.type == 'series' then
				tt1 = t2
			end
			if m_simpleTV.User.stena_rezka.back.type == 'cartoons' then
				tt1 = t3
			end
			if m_simpleTV.User.stena_rezka.back.type == 'animation' then
				tt1 = t4
			end
			if tt1 then
				for j=1,#tt1 do

					local nx = j - (math.ceil(j/9) - 1)*9
					local ny = math.ceil(j/9)
					 t={}
					 t.id = j .. '_TEXT_GENRES_REZKA_ID&' .. tt1[j][1]
					 t.cx=200
					 t.cy=0
					 t.once = 0
					 t.class="TEXT"
					 t.align = 0x0101
					 t.text = ' ' .. tt1[j][2]:gsub('метражные','-ый') .. ' '
					 if tt1[j][1] == m_simpleTV.User.stena_rezka.back.filter then
					 t.color = ARGB(255, 255, 215, 0)
					 else
					 t.color = ARGB(255, 192, 192, 192)
					 end
					 t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					 t.font_name = "Segoe UI Black"
					 t.textparam = 0
					 t.left = nx*dx - 210
					 t.top  = ny*dy + 210
					 t.glow = 1.2
					 t.glowcolor = 0xFF000077
					 t.borderwidth = 1
					 t.backroundcorner = 2*2
					 t.isInteractive = true
					 t.color_UnderMouse = ARGB(255, 255, 215, 0)
					 t.glowcolor_UnderMouse = 0xFF0000FF
					 t.glow_samples_UnderMouse = 2
					 t.background_UnderMouse = 2
					 t.backcolor0_UnderMouse = 0xBB4169E1
					 t.backcolor1_UnderMouse = 0xBB00008B
					 t.bordercolor_UnderMouse = 0xEE4169E1
					 t.cursorShape = 13
					 t.mousePressEventFunction = 'genres_rezka_id'
					 AddElement(t,'ID_DIV_STENA_1')
				end
				end

			if m_simpleTV.User.stena_rezka.back.type == 'person' then

				if m_simpleTV.User.stena_rezka.back.adr_person then

					t = {}
					t.id = 'STENA_REZKA_PERSON_BACK_IMG_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
--					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0103
					t.left = 650
					t.top  = 170
					t.transparency = 100
					t.zorder=2
					t.borderwidth = 2
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 20*20
					t.borderround = 20
					t.mouseMoveEventFunction = 'tooltip_WS'
					t.mousePressEventFunction = 'UpdatePersonRezka_id'
					AddElement(t,'ID_DIV_STENA_1')

					t = {}
					t.id = 'STENA_REZKA_PERSON_ADR_IMG_ID'
					t.class="IMAGE"
					t.cx=60
					t.cy=60
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/saveplst.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0202
					t.left = 0
					t.top  = 0
					t.transparency = 200
					t.zorder=2
					AddElement(t,'STENA_REZKA_PERSON_BACK_IMG_ID')
				end

				t = {}
				t.id = 'STENA_REZKA_PERSON_IMG_ID'
				t.class="IMAGE"
				t.cx=133
				t.cy=200
				t.top  = 230
				t.imagepath = m_simpleTV.User.stena_rezka.back.logo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 700
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'STENA_REZKA_PERSON_TXT_ID'
				t.cx=0
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.stena_rezka.back.desc_person
				t.color = ARGB(255 ,152, 152, 152)
				t.font_height = -9.5 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000008
				t.boundWidth = 15
				t.text_elidemode = 2
				t.glow = 1 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 850
			    t.top  = 230
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_1')
			end

			if m_simpleTV.User.stena_rezka.back.type == 'collection' or m_simpleTV.User.stena_rezka.back.type == 'franchise' then

				if m_simpleTV.User.stena_rezka.back.type == 'franchise' then
					t = {}
					t.id = 'STENA_REZKA_FRANCHISES_BACK_IMG_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
--					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0103
					t.left = 650
					t.top  = 170
					t.transparency = 100
					t.zorder=2
					t.borderwidth = 2
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 20*20
					t.borderround = 20
					t.mouseMoveEventFunction = 'tooltip_WS'
					t.mousePressEventFunction = 'Play_franchise_id'
					AddElement(t,'ID_DIV_STENA_1')

					t = {}
					t.id = 'STENA_REZKA_FRANCHISES_PLAY_IMG_ID'
					t.class="IMAGE"
					t.cx=36
					t.cy=36
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Play.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0103
					t.left = 662
					t.top  = 182
					t.transparency = 200
					t.zorder=2
					AddElement(t,'ID_DIV_STENA_1')
				end

				t = {}
				t.id = 'STENA_REZKA_COLLECTION_IMG_ID'
				t.class="IMAGE"
				t.cx=320
				t.cy=180
				t.top  = 250
				t.imagepath = m_simpleTV.User.stena_rezka.back.logo or (m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/HDrezka_Collection.png')
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0102
				t.left = 0
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 2
				t.bordercolor = -6250336
				t.backroundcorner = 5*5
				t.borderround = 20
				AddElement(t,'ID_DIV_STENA_1')

--[[				if not m_simpleTV.User.stena_rezka.back.logo or m_simpleTV.User.stena_rezka.back.logo=='' then
					t = {}
					t.id = 'STENA_REZKA_COLLECTION_TXT_ID'
					t.cx=0
					t.cy=0
					t.class="TEXT"
					t.text = m_simpleTV.User.stena_rezka.back.type
					t.color = ARGB(255 ,152, 152, 152)
					t.font_height = -16 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000008
					t.boundWidth = 15
					t.text_elidemode = 2
					t.glow = 1 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.align = 0x0102
					t.left = 0
					t.top  = 360
					t.transparency = 200
					t.zorder=2
					AddElement(t,'ID_DIV_STENA_1')
				end--]]
			end

		if m_simpleTV.User.stena_rezka.back.type:match('start') then

			local tt1 = {
			{'','0','FM_HDrezka.png'},
			{'Фильмы','1','films.svg'},
			{'Сериалы','2','series.svg'},
			{'Мульты','3','cartoons.svg'},
			{'Аниме','82','anime.svg'},
			}

			for j = 1,5 do

				t = {}
				t.id = 'REZKA_START_STENA_BACK_ID_' .. tt1[j][2]
				t.cx= 160 / 1*1.25
				t.cy= 90 / 1*1.25
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left= 358 + 200*(j-1) / 1*1.25
				t.top= 215 / 1*1.25
				t.transparency = 200
				t.zorder=0
				if m_simpleTV.User.stena_rezka.back.type == ('start_' .. tt1[j][2]) then
				t.borderwidth = 4
				else
				t.borderwidth = 0
				end
				t.bordercolor = -6250336
				t.isInteractive = true
				t.background_UnderMouse = 0
				t.backcolor0_UnderMouse = 0xEE4169E1
				t.backcolor1_UnderMouse = 0
				t.cursorShape = 13
				t.bordercolor_UnderMouse = 0xFF4169E1
				t.backroundcorner = 4*4
				t.borderround = 4
				t.mousePressEventFunction = 'get_start'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'REZKA_START_STENA_IMG_ID_' .. j
				if j == 1 then
				t.cx= 128 / 1*1.25
				t.cy= 36 / 1*1.25
				t.align = 0x0202
				t.left= 0
				elseif j == 2 or j == 3 then
				t.cx= 21 / 1*2
				t.cy= 16 / 1*2
				t.align = 0x0201
				t.left= 20
				elseif j == 4 then
				t.cx= 19 / 1*2
				t.cy= 17 / 1*2
				t.align = 0x0201
				t.left= 20
				elseif j == 5 then
				t.cx= 17 / 1*2
				t.cy= 17 / 1*2
				t.align = 0x0201
				t.left= 20
				end
				t.class="IMAGE"
				t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/' .. tt1[j][3]
				t.minresx=-1
				t.minresy=-1
				t.top= 0
				t.transparency = 200
				t.zorder=2
				AddElement(t,'REZKA_START_STENA_BACK_ID_' .. tt1[j][2])

				t = {}
				t.id = 'REZKA_START_STENA_TEXT_ID_' .. tt1[j][2]
				t.cx= 0
				t.cy= 0
				t.class="TEXT"
				t.text = tt1[j][1]
				t.align = 0x0203
				t.left= 20
				t.top= 0
				t.color = ARGB(255, 192, 192, 192)
				t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 65, 105, 225)
				t.glowcolor_UnderMouse = 0xFFFFFFFF
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 3 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.mousePressEventFunction = 'get_start'
				AddElement(t,'REZKA_START_STENA_BACK_ID_' .. tt1[j][2])

		   end

		end

		if m_simpleTV.User.stena_rezka.back.type:match('favorites') then

			for j = 1,#m_simpleTV.User.rezka.favorites do

				if m_simpleTV.User.rezka.favorites[j].Name:match('Мои фильмы') or m_simpleTV.User.rezka.favorites[j].Name:match('Мои сериалы') or m_simpleTV.User.rezka.favorites[j].Name:match('Мои мультфильмы') or m_simpleTV.User.rezka.favorites[j].Name:match('Мои аниме') then

					t = {}
					t.id = 'REZKA_FAVORITES_STENA_BACK_ID&' .. m_simpleTV.User.rezka.favorites[j].Address
					t.cx= 440
					t.cy= 90 / 1*1.25
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left= 65 + 450*(j-1)
					t.top= 215 / 1*1.25
					t.transparency = 100
					t.zorder=0
					if m_simpleTV.User.stena_rezka.back.type == ('favorite_' .. m_simpleTV.User.rezka.favorites[j].Address) then
					t.borderwidth = 4
					t.bordercolor = ARGB(255,255,255,255)
					else
					t.borderwidth = 1
					t.bordercolor = -6250336
					end
					t.isInteractive = true
					t.background_UnderMouse = 0
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 4*4
					t.borderround = 4
					t.mousePressEventFunction = 'get_favorites_for_address'
					AddElement(t,'ID_DIV_STENA_1')

					t = {}
					t.id = 'REZKA_FAVORITES_STENA_IMG_ID_' .. j
					t.align = 0x0201
					t.left= 20
					t.class="IMAGE"
					t.imagepath, t.cx, t.cy = Get_picon_for_name(m_simpleTV.User.rezka.favorites[j].Name)
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/' .. t.imagepath
					t.minresx=-1
					t.minresy=-1
					t.top= 0
					t.transparency = 200
					t.zorder=2
					AddElement(t,'REZKA_FAVORITES_STENA_BACK_ID&' .. m_simpleTV.User.rezka.favorites[j].Address)

					t = {}
					t.id = 'REZKA_FAVORITES_STENA_TEXT_ID&' .. m_simpleTV.User.rezka.favorites[j].Address
					t.cx= 0
					t.cy= 0
					t.class="TEXT"
					t.text = m_simpleTV.User.rezka.favorites[j].Name
					t.align = 0x0203
					t.left= 20
					t.top= 0
					if m_simpleTV.User.stena_rezka.back.type == ('favorite_' .. m_simpleTV.User.rezka.favorites[j].Address) then
					t.color = ARGB(255,255,255,255)
					else
					t.color = ARGB(255, 192, 192, 192)
					end
					t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
--					t.color_UnderMouse = ARGB(255, 65, 105, 225)
--					t.glowcolor_UnderMouse = 0xFFFFFFFF
--					t.glow_samples_UnderMouse = 4
					t.isInteractive = true
					t.cursorShape = 13
					t.textparam = 0x00000001
					t.text_elidemode = 1
					t.zorder=2
					t.glow = 3 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.mousePressEventFunction = 'get_favorites_for_address'
					AddElement(t,'REZKA_FAVORITES_STENA_BACK_ID&' .. m_simpleTV.User.rezka.favorites[j].Address)

				end
			end
		end
-------------------
		if m_simpleTV.User.stena_rezka.back.item and #m_simpleTV.User.stena_rezka.back.item and #m_simpleTV.User.stena_rezka.back.item > 0 then
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			if tonumber(math.ceil(#m_simpleTV.User.stena_rezka.back.item/45)) > 1 then

				m_simpleTV.User.stena_rezka.back.max_num = math.ceil(#m_simpleTV.User.stena_rezka.back.item/45)

				m_simpleTV.User.stena_rezka.back.prev_num = nil
				m_simpleTV.User.stena_rezka.back.next_num = nil

				if not m_simpleTV.User.stena_rezka.back.current_page then m_simpleTV.User.stena_rezka.back.current_page = 1 end

				if tonumber(m_simpleTV.User.stena_rezka.back.current_page) < tonumber(m_simpleTV.User.stena_rezka.back.max_num) then
					m_simpleTV.User.stena_rezka.back.next_num = tonumber(m_simpleTV.User.stena_rezka.back.current_page) + 1
				end
				if tonumber(m_simpleTV.User.stena_rezka.back.current_page) > 1 then
					m_simpleTV.User.stena_rezka.back.prev_num = tonumber(m_simpleTV.User.stena_rezka.back.current_page) - 1
				end

				m_simpleTV.User.stena_rezka.back.item1 = {}

				local k = 1

				for j = 1,#m_simpleTV.User.stena_rezka.back.item do
					local n = math.ceil(j/45)
					if n == tonumber(m_simpleTV.User.stena_rezka.back.current_page) then
						m_simpleTV.User.stena_rezka.back.item1[k] = {}
						m_simpleTV.User.stena_rezka.back.item1[k] = m_simpleTV.User.stena_rezka.back.item[j]
						k = k + 1
					end
					j = j + 1
				end
			else
				m_simpleTV.User.stena_rezka.back.item1 = m_simpleTV.User.stena_rezka.back.item
			end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			if m_simpleTV.User.stena_rezka.back.pls_type == 'table' or m_simpleTV.User.stena_rezka.back.type == 'franchise' then
				local dx = 1900/9
				local dy = 450/5
				if m_simpleTV.User.stena_rezka.back.type:match('start') or m_simpleTV.User.stena_rezka.back.type:match('favorite') then
					dx = 1900/8
					dy = 450/4.2
				end
				for j = 1,#m_simpleTV.User.stena_rezka.back.item1 do
					local nx = j - (math.ceil(j/9) - 1)*9
					local ny = math.ceil(j/9)
					if m_simpleTV.User.stena_rezka.back.type:match('start') or m_simpleTV.User.stena_rezka.back.type:match('favorite') then
						nx = j - (math.ceil(j/8) - 1)*8
						ny = math.ceil(j/8)
					end
					t = {}
					t.id = j .. '_STENA_REZKA_BACK_IMG_ID&' .. m_simpleTV.User.stena_rezka.back.item1[j].Address
					t.cx=dx-10
					t.cy=dy-10
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = nx*dx - dx + 15
					t.top  = ny*dy + 360
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 2
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mouseMoveEventFunction = 'get_request_for_content'
					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,'ID_DIV_STENA_3')

					t = {}
					t.id = j .. '_STENA_REZKA_TEXT_ID&' .. m_simpleTV.User.stena_rezka.back.item1[j].Address
					t.cx=dx-20
					t.cy=dy-20
					t.class="TEXT"
					t.text = m_simpleTV.User.stena_rezka.back.item1[j].Name .. '\n\n\n'
					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000001
					t.boundWidth = 15
					t.left = 0
					t.top  = 0
					t.row_limit=2
					t.text_elidemode = 2
					t.zorder=2
	--				t.glow = 2 -- коэффициент glow эффекта
	--				t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					t.mouseMoveEventFunction = 'get_request_for_content'
					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,j .. '_STENA_REZKA_BACK_IMG_ID&' .. m_simpleTV.User.stena_rezka.back.item1[j].Address)
				end
			end

			if m_simpleTV.User.stena_rezka.back.pls_type == 'karusel' and m_simpleTV.User.stena_rezka.back.type ~= 'franchise'  then
				local dn = 9
				local top = 435
				if m_simpleTV.User.stena_rezka.back.type:match('start') or m_simpleTV.User.stena_rezka.back.type:match('favorites') then
					dn = 8
					top = 405
				end
				if m_simpleTV.User.stena_rezka.back.type:match('person') or m_simpleTV.User.stena_rezka.back.type:match('collection') then
					dn = 9
					top = 445
				end
----------------------
				m_simpleTV.User.stena_rezka.back.max_num_karusel = math.ceil(#m_simpleTV.User.stena_rezka.back.item1/dn)

				m_simpleTV.User.stena_rezka.back.prev_karusel_num = nil
				m_simpleTV.User.stena_rezka.back.next_karusel_num = nil

				m_simpleTV.User.stena_rezka.back.current_page_karusel = m_simpleTV.User.stena_rezka.back.current_page_karusel or 1

				if tonumber(m_simpleTV.User.stena_rezka.back.current_page_karusel) < tonumber(m_simpleTV.User.stena_rezka.back.max_num_karusel) then
					m_simpleTV.User.stena_rezka.back.next_karusel_num = tonumber(m_simpleTV.User.stena_rezka.back.current_page_karusel) + 1
				end
				if tonumber(m_simpleTV.User.stena_rezka.back.current_page_karusel) > 1 then
					m_simpleTV.User.stena_rezka.back.prev_karusel_num = tonumber(m_simpleTV.User.stena_rezka.back.current_page_karusel) - 1
				end
----------------------


				local dx = 1900/dn
				local dy = 1900/dn*1.5
				for j = 1,#m_simpleTV.User.stena_rezka.back.item1 do
					if math.ceil(j/dn) == tonumber(m_simpleTV.User.stena_rezka.back.current_page_karusel) then
					local nx = j - (math.ceil(j/dn) - 1)*dn
					local ny = math.ceil(j/dn)
					if m_simpleTV.User.stena_rezka.back.type:match('start') or m_simpleTV.User.stena_rezka.back.type:match('favorites') then
						nx = j - (math.ceil(j/dn) - 1)*dn
						ny = math.ceil(j/dn)
					end
					if not m_simpleTV.User.stena_rezka.back.item1[j] then break end
					t = {}
					t.id = j .. '_STENA_REZKA_BACK_IMG_ID&' .. m_simpleTV.User.stena_rezka.back.item1[j].Address
					t.cx=dx-10
					t.cy=dy-10 + 80
					t.class="IMAGE"
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = nx*dx - dx + 15
					t.top  = top
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 1
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
					t.mouseMoveEventFunction = 'get_request_for_content'
					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,'ID_DIV_STENA_3')

					t = {}
					t.id = j .. '_STENA_REZKA_LOGO_IMG_ID&' .. m_simpleTV.User.stena_rezka.back.item1[j].Address
					t.cx=dx-10
					t.cy=dy-10
					t.class="IMAGE"
					t.imagepath = m_simpleTV.User.stena_rezka.back.item1[j].Logo
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0102
					t.left = 1
					t.top  = 0
					t.transparency = 200
					t.zorder=1
					t.borderwidth = 2
--					t.isInteractive = true
--					t.cursorShape = 13
--					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 3*3
					t.borderround = 3
--					t.mouseMoveEventFunction = 'get_request_for_content'
--					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,j .. '_STENA_REZKA_BACK_IMG_ID&' .. m_simpleTV.User.stena_rezka.back.item1[j].Address)

					t = {}
					t.id = j .. '_STENA_REZKA_TEXT_ID&' .. m_simpleTV.User.stena_rezka.back.item1[j].Address
					t.cx=dx-30
					t.cy=dy-10 + 60
					t.class="TEXT"
					t.text = m_simpleTV.User.stena_rezka.back.item1[j].Name
--					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000008
					t.boundWidth = 15
					t.left = 10
					t.top  = 0
					t.row_limit=2
					t.text_elidemode = 2
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					t.mouseMoveEventFunction = 'get_request_for_content'
					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,j .. '_STENA_REZKA_BACK_IMG_ID&' .. m_simpleTV.User.stena_rezka.back.item1[j].Address)
					end
				end

				if m_simpleTV.User.stena_rezka.back.prev_karusel_num then
					t = {}
					t.id = 'STENA_REZKA_PREV_KARUSEL_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 890
					t.top  = 835
					t.transparency = 50
					t.zorder=3
					t.borderwidth = 2
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 20*20
					t.borderround = 20
					t.mouseMoveEventFunction = 'tooltip_WS'
					t.mousePressEventFunction = 'get_karusel_posters'
					AddElement(t,'ID_DIV_STENA_3')

					t = {}
					t.id = 'STENA_REZKA_PREV_KARUSEL_TEXT_ID'
					t.cx=60
					t.cy=60
					t.class="TEXT"
					t.text = ''
					t.align = 0x0101
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -20 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000001
					t.boundWidth = 60
					t.left = 0
					t.top  = -5
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					t.mousePressEventFunction = 'get_karusel_posters'
					AddElement(t,'STENA_REZKA_PREV_KARUSEL_ID')
				end

				if m_simpleTV.User.stena_rezka.back.next_karusel_num then
					t = {}
					t.id = 'STENA_REZKA_NEXT_KARUSEL_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 970
					t.top  = 835
					t.transparency = 50
					t.zorder=2
					t.borderwidth = 2
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 20*20
					t.borderround = 20
					t.mouseMoveEventFunction = 'tooltip_WS'
					t.mousePressEventFunction = 'get_karusel_posters'
					AddElement(t,'ID_DIV_STENA_3')

					t = {}
					t.id = 'STENA_REZKA_NEXT_KARUSEL_TEXT_ID'
					t.cx=60
					t.cy=60
					t.class="TEXT"
					t.text = ''
					t.align = 0x0101
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -20 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000001
					t.boundWidth = 60
					t.left = 0
					t.top  = -5
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					t.mousePressEventFunction = 'get_karusel_posters'
					AddElement(t,'STENA_REZKA_NEXT_KARUSEL_ID')
				end

				if m_simpleTV.User.stena_rezka.back.prev_num and not m_simpleTV.User.stena_rezka.back.prev_karusel_num then
					t = {}
					t.id = 'STENA_REZKA_PREV_NUMER_IMG_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 890
					t.top  = 835
					t.transparency = 50
					t.zorder=2
					t.borderwidth = 2
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 20*20
					t.borderround = 20
					if m_simpleTV.User.stena_rezka.back.type == 'collection' or m_simpleTV.User.stena_rezka.back.type == 'person' then
						t.mousePressEventFunction = 'other_rezka_page'
					else
						t.mousePressEventFunction = 'genres_rezka_id'
					end
					AddElement(t,'ID_DIV_STENA_3')

					t = {}
					t.id = 'STENA_REZKA_PREV_NUMER_TEXT_ID'
					t.cx=60
					t.cy=60
					t.class="TEXT"
					t.text = ''
					t.align = 0x0101
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -16 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000001
					t.boundWidth = 60
					t.left = 0
					t.top  = 5
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					if m_simpleTV.User.stena_rezka.back.type == 'collection' or m_simpleTV.User.stena_rezka.back.type == 'person' then
						t.mousePressEventFunction = 'other_rezka_page'
					else
						t.mousePressEventFunction = 'genres_rezka_id'
					end
					AddElement(t,'STENA_REZKA_PREV_NUMER_IMG_ID')
				end

				if m_simpleTV.User.stena_rezka.back.next_num and not m_simpleTV.User.stena_rezka.back.next_karusel_num then
					t = {}
					t.id = 'STENA_REZKA_NEXT_NUMER_IMG_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 970
					t.top  = 835
					t.transparency = 50
					t.zorder=2
					t.borderwidth = 2
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 20*20
					t.borderround = 20
					if m_simpleTV.User.stena_rezka.back.type == 'collection' or m_simpleTV.User.stena_rezka.back.type == 'person' then
						t.mousePressEventFunction = 'other_rezka_page'
					else
						t.mousePressEventFunction = 'genres_rezka_id'
					end
					AddElement(t,'ID_DIV_STENA_3')

					t = {}
					t.id = 'STENA_REZKA_NEXT_NUMER_TEXT_ID'
					t.cx=60
					t.cy=60
					t.class="TEXT"
					t.text = ''
					t.align = 0x0101
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -16 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000001
					t.boundWidth = 60
					t.left = 0
					t.top  = 5
					t.zorder=1
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
					if m_simpleTV.User.stena_rezka.back.type == 'collection' or m_simpleTV.User.stena_rezka.back.type == 'person' then
						t.mousePressEventFunction = 'other_rezka_page'
					else
						t.mousePressEventFunction = 'genres_rezka_id'
					end
					AddElement(t,'STENA_REZKA_NEXT_NUMER_IMG_ID')
				end

			end
		end

				if m_simpleTV.User.stena_rezka.back.max_num and tonumber(m_simpleTV.User.stena_rezka.back.max_num) and tonumber(m_simpleTV.User.stena_rezka.back.max_num) > 1 then
					t = {}
					t.id = 'STENA_REZKA_SELECT_PAGE_IMG_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Page.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0103
					t.left = 250
					t.top  = 170
					t.transparency = 200
					t.zorder=2
					t.borderwidth = 2
					t.isInteractive = true
	--				t.background = 0
	--			    t.backcolor0 = 0x66999999
	--			    t.backcolor1 = 0
	--				t.backcenterpoint_x = 30
	--                t.backcenterpoint_y = 30
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 20*20
					t.borderround = 20
--					t.mouseMoveEventFunction = 'tooltip_WS'
					if m_simpleTV.User.stena_rezka.back.type == 'collection' or m_simpleTV.User.stena_rezka.back.type == 'person' then
						t.mousePressEventFunction = 'select_other_rezka_page'
					else
						t.mousePressEventFunction = 'select_rezka_page'
					end
					AddElement(t,'ID_DIV_STENA_1')

					t = {}
					t.id = 'STENA_REZKA_SELECT_PAGE_TXT_ID'
					t.cx=60
					t.cy=60
					t.class="TEXT"
					t.text = m_simpleTV.User.stena_rezka.back.current_page
					t.align = 0x0202
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000001
					t.boundWidth = 60
					t.left = 0
					t.top  = -15
					t.zorder=2
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.isInteractive = true
					t.cursorShape = 13
					t.color_UnderMouse = ARGB(255 ,255, 192, 63)
--					t.mouseMoveEventFunction = 'tooltip_WS'
					if m_simpleTV.User.stena_rezka.back.type == 'collection' or m_simpleTV.User.stena_rezka.back.type == 'person' then
						t.mousePressEventFunction = 'select_other_rezka_page'
					else
						t.mousePressEventFunction = 'select_rezka_page'
					end
					AddElement(t,'STENA_REZKA_SELECT_PAGE_IMG_ID')
				end

				if m_simpleTV.User.stena_rezka.back.prev_num then
					t = {}
					t.id = 'STENA_REZKA_PREV_IMG_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Prev.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0103
					t.left = 330
					t.top  = 170
					t.transparency = 200
					t.zorder=2
					t.borderwidth = 2
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 20*20
					t.borderround = 20
					t.mouseMoveEventFunction = 'tooltip_WS'
					if m_simpleTV.User.stena_rezka.back.type == 'collection' or m_simpleTV.User.stena_rezka.back.type == 'person' then
						t.mousePressEventFunction = 'other_rezka_page'
					else
						t.mousePressEventFunction = 'genres_rezka_id'
					end
					AddElement(t,'ID_DIV_STENA_1')
				end

				if m_simpleTV.User.stena_rezka.back.next_num then
					t = {}
					t.id = 'STENA_REZKA_NEXT_IMG_ID'
					t.cx=60
					t.cy=60
					t.class="IMAGE"
					t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Next.png'
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0103
					t.left = 170
					t.top  = 170
					t.transparency = 200
					t.zorder=2
					t.borderwidth = 2
					t.isInteractive = true
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFFFFFFFF
					t.bordercolor = -6250336
					t.backroundcorner = 20*20
					t.borderround = 20
					t.mouseMoveEventFunction = 'tooltip_WS'
					if m_simpleTV.User.stena_rezka.back.type == 'collection' or m_simpleTV.User.stena_rezka.back.type == 'person' then
						t.mousePressEventFunction = 'other_rezka_page'
					else
						t.mousePressEventFunction = 'genres_rezka_id'
					end
					AddElement(t,'ID_DIV_STENA_1')
				end

			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST1')
			m_simpleTV.OSD.RemoveElement('ID_LOGO_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_ID')

end

function rezka_info()
			m_simpleTV.Control.ExecuteAction(36,0) --KEYOSDCURPROG
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST1')
			m_simpleTV.OSD.RemoveElement('ID_LOGO_STENA_REQUEST')
			m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_ID')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR1_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR2_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR3_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR4_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR5_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('STENA_CLEAR6_TOOLTIP_WS')
			m_simpleTV.OSD.RemoveElement('ID_DIV_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_1')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_2')
			m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_3')
			m_simpleTV.User.TVPortal.stena_rezka_info = true
			m_simpleTV.User.TVPortal.stena_rezka_use = false
			m_simpleTV.User.TVPortal.stena_filmix_use = false
			m_simpleTV.User.TVPortal.stena_filmix_info = false
			m_simpleTV.User.TVPortal.stena_info = false
			m_simpleTV.User.TVPortal.stena_search_use = false
			m_simpleTV.User.TVPortal.stena_genres = false
			m_simpleTV.User.TVPortal.stena_use = false
			m_simpleTV.User.TVPortal.stena_home = false
			m_simpleTV.Interface.RestoreBackground()
			local  t, AddElement = {}, m_simpleTV.OSD.AddElement
			local add = 0

			 t.BackColor = 0
			 t.BackColorEnd = 255
			 t.PictFileName = m_simpleTV.User.TVPortal.stena_rezka.logo
			 t.TypeBackColor = 0
			 t.UseLogo = 3
			 t.Once = 1
			 t.Blur = 0
--			 m_simpleTV.Interface.SetBackground(t)

			 t = {}
			 t.id = 'ID_DIV_STENA_1'
			 t.cx=-100
			 t.cy=-100
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0101
			 t.left=0
			 t.top=-80 / m_simpleTV.Interface.GetScale()*1.5
			 t.once=1
			 t.zorder=1
			 t.background = -1
			 t.backcolor0 = 0xff0000000
			 AddElement(t)

			 t = {}
			 t.id = 'ID_DIV_STENA_2'
			 t.cx=-100
			 t.cy=-100
			 t.class="DIV"
			 t.minresx=0
			 t.minresy=0
			 t.align = 0x0101
			 t.left=0
			 t.top=0
			 t.once=1
			 t.zorder=0
			 t.background = 1
			 t.backcolor0 = 0x440000FF
--			 t.backcolor1 = 0x77FFFFFF
			 AddElement(t)

			 t = {}
			 t.id = 'FON_STENA_ID'
			 t.cx= -100
			 t.cy= -100
			 t.class="IMAGE"
			 t.animation = true
			 t.imagepath = 'type="dir" count="150" delay="60" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/cerberus/cerberus%1.png"'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=0
			 t.top=0
			 t.transparency = 255
			 t.zorder=1
			 AddElement(t,'ID_DIV_STENA_2')

			 t = {}
			 t.id = 'USER_LOGO_IMG_STENA_1_ID'
			 t.cx= 300 / 1*1.25
			 t.cy= 450 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.User.TVPortal.stena_rezka.logo
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=20 / 1*1.25
			 t.top=250 / 1*1.25
			 t.transparency = 200
			 t.zorder=1
			 t.borderwidth = 2
			 t.bordercolor = -6250336
			 t.backroundcorner = 4*4
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

		if m_simpleTV.User.rezka.cookies ~= '' then
			 t = {}
			 t.id = 'IMG_STENA_FAV_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.current_address
			 t.cx= 40 / 1*1.25
			 t.cy= 40 / 1*1.25
			 t.class="IMAGE"
			 if m_simpleTV.User.TVPortal.stena_rezka.flag == true then
			  t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/star-on.png'
			 else
			  t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/star-off.png'
			 end
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 270 / 1*1.25
			 t.top= 260 / 1*1.25
			 t.transparency = 255
			 t.zorder=1
			 t.borderwidth = 2
			 t.bordercolor = ARGB(0, 0, 0, 0)
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xBBBBBBBB
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFFFFFFFF
			 t.backroundcorner = 20*20
			 t.borderround = 20
			 t.mousePressEventFunction = 'add_to_favorites_rezka_stena'
			 AddElement(t,'ID_DIV_STENA_1')
		end

			 t = {}
			 t.id = 'HOME_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=20 / 1*1.25
			 t.top=720 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.borderwidth = 0
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'get_start'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'HOME_IMG_STENA_ID'
			 t.cx= 50 / 1*1.25
			 t.cy= 50 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/menu/home.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 40 / 1*1.25
			 t.top= 725 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')


			 t = {}
			 t.id = 'BACK_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=125 / 1*1.25
			 t.top=720 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.borderwidth = 0
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 if m_simpleTV.User.stena_rezka.back.type then
			 t.mousePressEventFunction = 'stena_rezka'
			 else
			 t.mousePressEventFunction = 'get_start'
			 end
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'BACK_IMG_STENA_ID'
			 t.cx= 50 / 1*1.25
			 t.cy= 50 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/menu/Prev.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 143 / 1*1.25
			 t.top= 725 / 1*1.25
			 t.transparency = 200
			 t.zorder=2

			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'STENA_CLEAR_IMG_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=230 / 1*1.25
			 t.top=720 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.borderwidth = 0
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'stena_clear'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'STENA_CLEAR_IMG_ID'
			 t.cx= 50 / 1*1.25
			 t.cy= 50 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/menu/Clear.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= 250 / 1*1.25
			 t.top= 725 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'RIMDB_IMG_STENA_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/imdb.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=20 / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'R_IMDB_STENA_IMG_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.stena_rezka.ret_imdb) .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=25 / 1*1.25
			 t.top=210 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'RKP_IMG_STENA_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/kinopoisk.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=125 / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'R_KP_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.stena_rezka.ret_KP) .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=130 / 1*1.25
			 t.top=210 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'RREZKA_IMG_STENA_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/HDRezkaRaiting.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=230 / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'R_REZKA_IMG_STENA_ID'
			 t.cx= 80 / 1*1.25
			 t.cy= 16 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/stars/' .. Get_rating(m_simpleTV.User.TVPortal.stena_rezka.ret_rezka) .. '.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=235 / 1*1.25
			 t.top=210 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'REZKA_IMG_STENA_FM_ID'
			 t.cx= 256
			 t.cy= 71
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/FM_HDrezka.gif'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0103
			 t.left=10
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = 0
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 5*5
			 t.borderround = 5
			 t.mousePressEventFunction = 'run_lite_qt_rezka'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'FILMIX_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(358+100) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'search_filmix_from_rezka'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'FILMIX_IMG_STENA_ID'
			 t.cx= 60 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/Filmix.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= (172+300) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=2

			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'TMDB_IMG_STENA_BACK_ID'
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/TMDB_.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(360+200) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'search_tmdb_from_rezka'
			 AddElement(t,'ID_DIV_STENA_1')

			 t = {}
			 t.id = 'PLAY_IMG_STENA_BACK_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.current_address
			 t.cx= 90 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/empty.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left=(255+100) / 1*1.25
			 t.top=170 / 1*1.25
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 0
			 t.bordercolor = -6250336
			 t.backroundcorner = 0*0
			 t.borderround = 20
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'play_rezka'
			 AddElement(t,'ID_DIV_STENA_1')


			 t = {}
			 t.id = 'PLAY_IMG_STENA_ID'
			 t.cx= 60 / 1*1.25
			 t.cy= 60 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Play.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left= (170+200) / 1*1.25
			 t.top= 170 / 1*1.25
			 t.transparency = 200
			 t.zorder=2
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_STENA_0_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.stena_rezka.slogan
			 t.color = -9113993
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_italic = 1
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 355 / 1*1.25
			 t.top  = 195 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_STENA_1_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.stena_rezka.title
			 t.color = -2123993
			 t.font_height = -35 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 400 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_underline = 1
			 t.font_name = "Segoe UI Black"
			 t.textparam = 1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 355 / 1*1.25
			 t.top  = 210 / 1*1.5
			 t.glow = 3 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_STENA_2_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.stena_rezka.title_en:gsub('%&nbsp%;',' ')
			 t.color = -2113993
			 t.font_height = -25 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.boundWidth = 15 -- bound to screen
			 t.row_limit=1 -- row limit
			 t.scrollTime = 40 --for ticker (auto scrolling text)
			 t.scrollFactor = 2
			 t.scrollWaitStart = 70
			 t.scrollWaitEnd = 100
			 t.left = 355 / 1*1.25
			 t.top  = 265 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_STENA_3_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = m_simpleTV.User.TVPortal.stena_rezka.year .. ' ● ' .. m_simpleTV.User.TVPortal.stena_rezka.country .. (m_simpleTV.User.TVPortal.stena_rezka.age or '') ..  (m_simpleTV.User.TVPortal.stena_rezka.time_all or '')
			 t.color = -2113993
			 t.font_height = -15 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.boundWidth = 15
			 t.left = 355 / 1*1.25
			 t.top  = 315 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_STENA_5_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.color = ARGB(255, 192, 192, 192)
			 t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
			 t.text = m_simpleTV.User.TVPortal.stena_rezka.overview .. '\n\n\n'
			 t.boundWidth = 50
			 t.row_limit=2
			 t.text_elidemode = 1
			 t.glow = 2 -- коэффициент glow эффекта
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.left = 380 / 1*1.25
			 t.top  = 375 / 1*1.5
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 AddElement(t,'ID_DIV_STENA_1')

			 t={}
			 t.id = 'TEXT_STENA_6_ID'
			 t.cx=0
			 t.cy=0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.color = -2113993
			 t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 400 / m_simpleTV.Interface.GetScale()*1.5
			 t.text = '    HDRezka рекомендует    '
			 t.boundWidth = 50
			 t.row_limit=2
			 t.text_elidemode = 1
			 t.zorder=2
			 t.glow = 2 -- коэффициент glow эффекта
			 t.font_name = "Segoe UI"
			 t.textparam = 0--1+4
			 t.left = 767 / 1*1.25
			 t.top  = 585 / 1*1.5
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 t.backroundcorner = 3*3
			 t.background = 2
			 t.backcolor0 = 0xEE4169E1
			 t.backcolor1 = 0xEE00008B
			 AddElement(t,'ID_DIV_STENA_1')

			local delta = 0
			if m_simpleTV.User.TVPortal.stena_rezka.genres and #m_simpleTV.User.TVPortal.stena_rezka.genres then
			 local max = 8
			 if #m_simpleTV.User.TVPortal.stena_rezka.genres < max then
			  max = #m_simpleTV.User.TVPortal.stena_rezka.genres
			 end
			 for j=1,max do

			 t={}
			 t.id = j .. 'TEXT_GENRES_STENA_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.genres[j].genre_adr
			 t.cx=0
			 t.cy=0
			 t.once = 0
			 t.class="TEXT"
			 t.align = 0x0101
			 t.text = ' ● ' .. m_simpleTV.User.TVPortal.stena_rezka.genres[j].genre_name:gsub('метражные','-ый') .. ' '
			 t.color = -2113993
			 t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_weight = 300 / m_simpleTV.Interface.GetScale()*1.5
			 t.font_name = "Segoe UI Black"
			 t.textparam = 0--1+4
			 t.left = 425 + delta
			 delta = delta + Get_length(t.text)*14
			 t.top  = 346 / 1*1.5
			 t.glow = 2 -- коэффициент glow эффекта
			 t.glowcolor = 0xFF000077 -- цвет glow эффекта
			 t.borderwidth = 1
			 t.backroundcorner = 3*3
			 t.isInteractive = true
			 t.background_UnderMouse = 2
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0xEE00008B
			 t.bordercolor_UnderMouse = 0xEE4169E1
			 t.cursorShape = 13

			 t.mousePressEventFunction = 'genres_rezka_id'

			 AddElement(t,'ID_DIV_STENA_1')
			end
			end

			local max = 10
			if 	m_simpleTV.User.TVPortal.stena_rezka.actors and
				m_simpleTV.User.TVPortal.stena_rezka.actors[1] then
				if #m_simpleTV.User.TVPortal.stena_rezka.actors < max then
					max = #m_simpleTV.User.TVPortal.stena_rezka.actors
				end
				for j = 1,max do
			 t = {}
			 t.id = 'PERSON_STENA_REZKA_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.actors[j].actors_adr
			 t.cx= 110 / 1*1.25
			 t.cy= 165 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.User.TVPortal.stena_rezka.actors[j].actors_logo
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left = 425 + (j-1)*148
			 t.top  = 668
			 t.transparency = 200
			 t.zorder=0
			 t.borderwidth = 2
			 t.bordercolor = -6250336
			 t.isInteractive = true
			 t.background_UnderMouse = 0
			 t.backcolor0_UnderMouse = 0xEE4169E1
			 t.backcolor1_UnderMouse = 0
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 3*3
			 t.borderround = 3
			 t.mousePressEventFunction = 'personWork_stena_rezka'
			 AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'PERSON_STENA_REZKA_TEXT_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.actors[j].actors_adr
				t.cx=105 / 1*1.25
				t.cy=200 / 1*1.25
				t.class="TEXT"
				t.text = '\n\n\n\n\n' .. m_simpleTV.User.TVPortal.stena_rezka.actors[j].actors_name .. '\n\n'
				t.align = 0x0101
				t.padding = 5
				t.color = ARGB(255, 192, 192, 192)
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 255, 215, 0)
			 	t.glowcolor_UnderMouse = 0xFF000077
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000001
--				t.boundWidth = 15
				t.left = 0
			    t.top  = 0
				t.row_limit=2
				t.text_elidemode = 1
				t.zorder=1
				t.glow = 6 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.mousePressEventFunction = 'personWork_stena_rezka'
				AddElement(t,'PERSON_STENA_REZKA_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.actors[j].actors_adr)

				t = {}
				t.id = 'PERSON_STENA_REZKA_WORK_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.actors[j].actors_adr
				t.cx=110 / 1*1.25
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena_rezka.actors[j].actors_work
				t.align = 0x0101
				t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 400 / m_simpleTV.Interface.GetScale()*1.5
				t.textparam = 0x00000001
				t.boundWidth = 15
				t.left = 425 + (j-1)*148
			    t.top  = 650
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 2 -- коэффициент glow эффекта
				t.color = -2113993
				t.font_name = "Segoe UI"
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.backroundcorner = 3*3
				t.background = 2
				t.backcolor0 = 0xEE4169E1
				t.backcolor1 = 0xEE00008B
				AddElement(t,'ID_DIV_STENA_1')
				end
			end

			local max = 4
			if 	m_simpleTV.User.TVPortal.stena_rezka.collections and
				m_simpleTV.User.TVPortal.stena_rezka.collections[1]	then
				if #m_simpleTV.User.TVPortal.stena_rezka.collections < max then
					max = #m_simpleTV.User.TVPortal.stena_rezka.collections
				end
				for j = 1,max do

			 t = {}
			 t.id = 'COLLECTION_REZKA_STENA_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.collections[j].adr
			 t.cx= 300 / 1*1.25
			 t.cy= 30 / 1*1.25
			 t.class="IMAGE"
			 t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/white.png'
			 t.minresx=-1
			 t.minresy=-1
			 t.align = 0x0101
			 t.left = 25
			 t.top  = 1000 + (j-1)*40
			 t.transparency = 40
			 t.zorder=0
			 t.borderwidth = 2
			 t.bordercolor = -6250336
			 t.background = 2
			 t.backcolor1 = 0xFF000000
			 t.backcolor0 = 0x00000000
			 t.isInteractive = true
			 t.background_UnderMouse = 2
			 t.backcolor1_UnderMouse = 0xEE4169E1
			 t.backcolor0_UnderMouse = 0x004169E1
			 t.cursorShape = 13
			 t.bordercolor_UnderMouse = 0xFF4169E1
			 t.backroundcorner = 2*2
			 t.borderround = 2
			 t.mousePressEventFunction = 'collection_stena_rezka'
			 AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'COLLECTION_REZKA_STENA_TEXT_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.collections[j].adr
				t.cx=280 / 1*1.25
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.TVPortal.stena_rezka.collections[j].name
				t.align = 0x0101
				t.color = ARGB(255, 192, 192, 192)
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.color_UnderMouse = ARGB(255, 255, 215, 0)
			 	t.glowcolor_UnderMouse = 0xFF000077
				t.glow_samples_UnderMouse = 4
				t.isInteractive = true
				t.cursorShape = 13
				t.textparam = 0x00000020
				t.boundWidth = 15
				t.left = 35
			    t.top  = 1000 + (j-1)*40
				t.text_elidemode = 1
				t.zorder=2
				t.glow = 1 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.mousePressEventFunction = 'collection_stena_rezka'
				AddElement(t,'ID_DIV_STENA_1')
				end
			end
			local max = 9
			if 	m_simpleTV.User.TVPortal.stena_rezka.add_content and
				m_simpleTV.User.TVPortal.stena_rezka.add_content[1]	then
				if #m_simpleTV.User.TVPortal.stena_rezka.add_content < max then
					max = #m_simpleTV.User.TVPortal.stena_rezka.add_content
				end
				for j = 1,max do
					t = {}
					t.id = 'ADD_CONTENT_STENA_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.add_content[j].adr
					t.cx= 150
					t.cy= 225
					t.class="IMAGE"
					t.imagepath = m_simpleTV.User.TVPortal.stena_rezka.add_content[j].logo
					t.minresx=-1
					t.minresy=-1
					t.align = 0x0101
					t.left = 425 + (j-1)*165
					t.top  = 915
					t.transparency = 200
					t.zorder=0
					t.borderwidth = 3
					t.bordercolor = -6250336
					t.isInteractive = true
					t.background_UnderMouse = 0
					t.backcolor0_UnderMouse = 0xEE4169E1
					t.backcolor1_UnderMouse = 0
					t.cursorShape = 13
					t.bordercolor_UnderMouse = 0xFF4169E1
					t.backroundcorner = 4*4
					t.borderround = 4
					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,'ID_DIV_STENA_1')

					t = {}
					t.id = 'ADD_CONTENT_STENA_TEXT_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.add_content[j].adr
					t.cx=145
					t.cy=250
					t.class="TEXT"
					t.text = '\n\n\n\n\n\n\n' .. m_simpleTV.User.TVPortal.stena_rezka.add_content[j].name .. '\n\n'
					t.align = 0x0101
					t.color = ARGB(255, 192, 192, 192)
					t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
					t.font_weight = 200 / m_simpleTV.Interface.GetScale()*1.5
					t.font_name = "Segoe UI Black"
					t.color_UnderMouse = ARGB(255, 255, 215, 0)
					t.glowcolor_UnderMouse = 0xFF000077
					t.glow_samples_UnderMouse = 4
					t.isInteractive = true
					t.cursorShape = 13
					t.textparam = 0x00000001
					t.boundWidth = 15
					t.left = 0
					t.top  = 8
					t.row_limit=2
					t.text_elidemode = 1
					t.zorder=1
					t.glow = 6 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.mousePressEventFunction = 'media_info_rezka_from_stena'
					AddElement(t,'ADD_CONTENT_STENA_IMG_ID&' .. m_simpleTV.User.TVPortal.stena_rezka.add_content[j].adr)
				end
			end

end

function get_info_in_stena(id_rezka,title_desc)
	if m_simpleTV.User.stena_rezka.back.old_request and not m_simpleTV.User.stena_rezka.back.old_request:match('_' .. id_rezka .. '$') or m_simpleTV.User.TVPortal.stena_rezka_info or m_simpleTV.User.TVPortal.stena_rezka_busy then return end
	local session = m_simpleTV.Http.New('Mozilla/5.0')
	if not session then
		return
	end
	m_simpleTV.Http.SetTimeout(session, 8000)

		local zerkalo = getConfigVal('zerkalo/rezka') or ''
		local host
		if zerkalo ~= '' then
		host = zerkalo:gsub('/$','')
		else
		host = 'https://hdrezka.ag'
		end
		---------------
		local url = host .. '/engine/ajax/quick_content.php'
		local body = 'id=' .. id_rezka .. '&is_touch=1'
		local headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies
		local rc, answer = m_simpleTV.Http.Request(session, {url = url, method = 'post', body = body, headers = headers})
		m_simpleTV.Common.Sleep(200)
		if rc~= 200 or not answer then
			return
		end
		m_simpleTV.Http.Close(session)
--		debug_in_file(answer:gsub('<.->',''):gsub('\n%s+','\n') .. '\n\n')
		if m_simpleTV.User.stena_rezka.back.old_request and not m_simpleTV.User.stena_rezka.back.old_request:match('_' .. id_rezka .. '$') or m_simpleTV.User.TVPortal.stena_rezka_info or m_simpleTV.User.TVPortal.stena_rezka_busy then return end
		m_simpleTV.OSD.RemoveElement('USER_TEXT_REQUEST_ID')
		local  t, AddElement = {}, m_simpleTV.OSD.AddElement
				t = {}
				t.id = 'USER_TEXT_REQUEST_ID'
				t.cx=1000
				t.cy=0
				t.class="TEXT"
				t.text = title_desc .. answer:gsub('<div class="b%-content__catlabel.-">.-</div>',''):gsub('<div class="b%-content__bubble_text">.-</div>',''):gsub('<.->',''):gsub('\n%s+','\n'):gsub('^\n',''):gsub('^\n','') .. '\n\n'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
				t.row_limit=9
				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 20
			    t.top  = 10
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_REQUEST')

				t = {}
				t.id = 'USER_TEXT1_REQUEST_ID'
				t.cx=1000
				t.cy=0
				t.class="TEXT"
				t.text = answer:match('<i class="entity">(.-)</i>')
				t.color = ARGB(255 ,255, 192, 63)
				t.font_height = -10 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000002
--				t.row_limit=12
				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0103
				t.left = 20
			    t.top  = 10
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_REQUEST')

		t = {}
		t.id = 'ID_DIV_STENA_REQUEST1'
		t.cx=650
		t.cy=270
		t.class="DIV"
		t.minresx=0
		t.minresy=0
		t.align = 0x0101
		t.left=1245
		t.top=800
		t.once=1
		t.zorder=0
		t.background = 2
		t.backcolor0 = 0x440000FF
		t.backcolor1 = 0x77000000
		t.borderwidth = 2
		t.bordercolor = -6250336
		t.backroundcorner = 3*3
		t.borderround = 3
		AddElement(t)

				t = {}
				t.id = 'USER_TEXT_REQUEST1_ID'
				t.cx=610
				t.cy=0
				t.class="TEXT"
				t.text = answer:match('<div class="b%-content__bubble_text">(.-)</div>'):gsub('\n%s+','\n'):gsub('^%s+','') .. '\n\n\n\n\n\n\n\n\n\n\n\n'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = -11 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
				t.row_limit=10
				t.text_elidemode = 2
--				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 20
			    t.top  = 40
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_REQUEST1')
end

function get_request_for_content(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	local num = id:match('^(%d+)')
	local adr1 = adr:match('/(%d+)')
	if m_simpleTV.User.stena_rezka.back.old_request and m_simpleTV.User.stena_rezka.back.old_request:match('_' .. adr1 .. '$') then return end
	m_simpleTV.User.TVPortal.stena_rezka_busy = false
	m_simpleTV.User.stena_rezka.back.old_request = num .. '_' .. adr1
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST')
	m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST1')
	m_simpleTV.OSD.RemoveElement('ID_LOGO_STENA_REQUEST')
	local logo
	if m_simpleTV.User.stena_rezka.back.type == 'franchise' and adr then logo = Get_logo_franchise(adr) end
	local  t, AddElement = {}, m_simpleTV.OSD.AddElement

		t = {}
		t.id = 'ID_DIV_STENA_REQUEST'
		t.cx=1025
		t.cy=270
		t.class="DIV"
		t.minresx=0
		t.minresy=0
		t.align = 0x0101
		t.left=210
		t.top=800
		t.once=1
		t.zorder=0
		t.background = 2
		t.backcolor0 = 0x440000FF
		t.backcolor1 = 0x77000000
		t.borderwidth = 2
		t.bordercolor = -6250336
		t.backroundcorner = 3*3
		t.borderround = 3
		AddElement(t)

		if m_simpleTV.User.stena_rezka.back.item1[tonumber(num)].Logo or logo then

		t = {}
		t.id = 'ID_LOGO_STENA_REQUEST'
		t.cx= 180
		t.cy= 270
		t.class="DIV"
		t.minresx=0
		t.minresy=0
		t.align = 0x0101
		t.left=20
		t.top=800
		t.once=1
		t.zorder=0
--		t.background = 2
--		t.backcolor0 = 0x440000FF
--		t.backcolor1 = 0x77000000
--		t.borderwidth = 2
--		t.bordercolor = -6250336
--		t.backroundcorner = 3*3
--		t.borderround = 3
		AddElement(t)

		t = {}
		t.id = num .. '_USER_LOGO_REQUEST_ID_' .. adr1
		t.cx= 180
		t.cy= 270
		t.class="IMAGE"
		t.imagepath = m_simpleTV.User.stena_rezka.back.item1[tonumber(num)].Logo or logo
		t.minresx=-1
		t.minresy=-1
		t.align = 0x0101
		t.left=0
		t.top=0
		t.transparency = 200
		t.zorder=1
		t.borderwidth = 2
		t.bordercolor = -6250336
		t.backroundcorner = 3*3
		t.borderround = 3
		AddElement(t,'ID_LOGO_STENA_REQUEST')

		end

				t = {}
				t.id = 'USER_TEXT_REQUEST_ID'
				t.cx=1000
				t.cy=0
				t.class="TEXT"
				t.text = m_simpleTV.User.stena_rezka.back.item1[tonumber(num)].title_name .. '\n\n' .. m_simpleTV.User.stena_rezka.back.item[tonumber(num)].title_desc .. '\n\n\n\n\n\n'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = -14 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
				t.row_limit=6
				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 20
			    t.top  = 10
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_REQUEST')

				get_info_in_stena(adr1,m_simpleTV.User.stena_rezka.back.item1[tonumber(num)].title_desc)
end

function play_rezka(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	setConfigVal('info/rezka',adr)
	setConfigVal('info/scheme','Rezka')
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = adr
	return m_simpleTV.Control.PlayAddressT({address = adr})
end

function media_info_rezka_from_stena(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	m_simpleTV.OSD.RemoveElement('GLOBUS_STENA_ID')
			local  t, AddElement = {}, m_simpleTV.OSD.AddElement

				t = {}
				t.id = 'GLOBUS_STENA_ID'
				t.cx= 60
				t.cy= 60
				t.class="IMAGE"
				t.animation = true
				t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/3d1/d%0.png"'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0103
				t.left=15
				t.top=110
				t.transparency = 255
				t.zorder=2
				t.isInteractive = true
				t.cursorShape = 13
				t.mousePressEventFunction = 'start_page_mediaportal'
				AddElement(t,'ID_DIV_STENA_1')

				t = {}
				t.id = 'Matrix_STENA_ID'
				t.cx= 1800
				t.cy= 980
				t.class="IMAGE"
				t.animation = true
--				t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/m/green/m%0.png"'
--				t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/m/blue/m%0.png"'
				t.imagepath = 'type="file" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/m/matrix2.gif"'
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0403
				t.left=0
				t.top=0
				t.transparency = 192
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')
	return media_info_rezka(adr)
end

function add_to_favorites_rezka_stena(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	if not adr then return end
	ADD_to_favorites_rezka(adr)
	return media_info_rezka(adr)
end

function personWork_stena_rezka(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	if not adr then return end
	return person_rezka_work(adr)
end

function collection_stena_rezka(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	if not adr then return end
	if adr:match('/collections/') then
		if not m_simpleTV.User.stena_rezka.back.collection then
			create_collection()
		end
		return collection_rezka_url(adr)
	elseif adr:match('/franchises/') then
		return franchises_rezka_url(adr)
	end
end

function get_favorites_for_address(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	if not adr then
		return favorites_cat_rezka(m_simpleTV.User.rezka.favorites[1].Address,m_simpleTV.User.rezka.favorites[1].Name)
	end
	for i = 1,#m_simpleTV.User.rezka.favorites do
		if m_simpleTV.User.rezka.favorites[i].Address == adr then
			return favorites_cat_rezka(m_simpleTV.User.rezka.favorites[i].Address,m_simpleTV.User.rezka.favorites[i].Name)
		end
	end
end

function select_rezka_page()
	m_simpleTV.User.stena_rezka.back.current_page_karusel = nil
	return set_page(m_simpleTV.User.stena_rezka.back.filter,m_simpleTV.User.stena_rezka.back.title:gsub(' %(.-$',''),m_simpleTV.User.stena_rezka.back.current_page,m_simpleTV.User.stena_rezka.back.max_num)
end

function select_other_rezka_page()
	local t = {}
	for i = 1,tonumber(m_simpleTV.User.stena_rezka.back.max_num) do
		t[i] = {}
		t[i].Id = i
		t[i].Name = i
	end
	m_simpleTV.Common.Sleep(200)
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Select page: ' .. m_simpleTV.User.stena_rezka.back.title, tonumber(m_simpleTV.User.stena_rezka.back.current_page)-1, t, 10000, 1+4+8+2)
	if ret == -1 or not id then
		return
	end
	if ret == 1 then
		m_simpleTV.User.stena_rezka.back.current_page_karusel = nil
		m_simpleTV.User.stena_rezka.back.current_page = id
		if m_simpleTV.User.stena_rezka.back.type == 'person' then
			return stena_rezka()
		elseif m_simpleTV.User.stena_rezka.back.type == 'collection' then
			return collection_rezka_url(m_simpleTV.User.stena_rezka.back.collection.current_url,'',m_simpleTV.User.stena_rezka.back.current_page)
		end
	end
end

function other_rezka_page(id)
	if not id then return end
	m_simpleTV.User.stena_rezka.back.current_page_karusel = nil
	if id:match('PREV') then
		if m_simpleTV.User.stena_rezka.back.type == 'person' then
			m_simpleTV.User.stena_rezka.back.current_page = tonumber(m_simpleTV.User.stena_rezka.back.current_page) - 1
			return stena_rezka()
		elseif m_simpleTV.User.stena_rezka.back.type == 'collection' then
			m_simpleTV.User.stena_rezka.back.current_page = tonumber(m_simpleTV.User.stena_rezka.back.current_page) - 1
			return collection_rezka_url(m_simpleTV.User.stena_rezka.back.collection.current_url,'',m_simpleTV.User.stena_rezka.back.current_page)
		end
	end
	if id:match('NEXT') then
		if m_simpleTV.User.stena_rezka.back.type == 'person' then
			m_simpleTV.User.stena_rezka.back.current_page = tonumber(m_simpleTV.User.stena_rezka.back.current_page) + 1
			return stena_rezka()
		elseif m_simpleTV.User.stena_rezka.back.type == 'collection' then
			m_simpleTV.User.stena_rezka.back.current_page = tonumber(m_simpleTV.User.stena_rezka.back.current_page) + 1
			return collection_rezka_url(m_simpleTV.User.stena_rezka.back.collection.current_url,'',m_simpleTV.User.stena_rezka.back.current_page)
		end
	end
end

function Play_franchise_id()
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = m_simpleTV.User.stena_rezka.back.adr_franchise
	m_simpleTV.Control.PlayAddress(m_simpleTV.User.stena_rezka.back.adr_franchise)
end

function UpdatePersonRezka_id()
	setConfigVal('person/rezka',m_simpleTV.User.stena_rezka.back.adr_person)
	UpdatePersonRezka()
end

function search_tmdb_from_rezka()
	m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_rezka.title),'LiteConf.ini')
	search_tmdb()
end

function search_filmix_from_rezka()
	m_simpleTV.Config.SetValue('search/media',m_simpleTV.Common.toPercentEncoding(m_simpleTV.User.TVPortal.stena_rezka.title),'LiteConf.ini')
	search_filmix_media()
end

function back_from_media_info_rezka()
	if stena_rezka then return stena_rezka() end
	if not m_simpleTV.User.stena_rezka.back or not m_simpleTV.User.stena_rezka.back.item then
		return run_lite_qt_rezka()
	end
	local AutoNumberFormat, FilterType
	if #m_simpleTV.User.stena_rezka.back.item > 4 then
		AutoNumberFormat = '%1. %2'
		FilterType = 1
	else
		AutoNumberFormat = ''
		FilterType = 2
	end
	m_simpleTV.User.stena_rezka.back.item.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
	m_simpleTV.User.stena_rezka.back.item.ExtButton0 = {ButtonEnable = true, ButtonName = ' Back '}
	m_simpleTV.User.stena_rezka.back.item.ExtButton1 = nil
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.stena_rezka.back.title, tonumber(m_simpleTV.User.stena_rezka.back.item_id) - 1, m_simpleTV.User.stena_rezka.back.item, 30000, 1+4+8+2)
	if ret == -1 or not id then
		return
	end
	if ret == 1 then
		m_simpleTV.User.stena_rezka.back.item_id = id
		return media_info_rezka(m_simpleTV.User.stena_rezka.back.item[id].Address)
	end
	if ret == 2 then
		run_lite_qt_rezka()
	end
end

function change_stena_rezka_filter_type()

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local t1 = {
	{'last','Поступления'},
	{'popular','Популярные'},
	{'watching','Смотрят'},
	}

	if m_simpleTV.User.stena_rezka.back.filter_type == t1[1][1] then
		m_simpleTV.User.stena_rezka.back.filter_type = t1[2][1]
		m_simpleTV.User.stena_rezka.back.filter_type_name = t1[2][2]
		setConfigVal('rezka_filter_type',t1[2][1])
		return last_rezka(m_simpleTV.User.stena_rezka.back.filter,m_simpleTV.User.stena_rezka.back.title:gsub(' %(.-$',''),1)
	end
	if m_simpleTV.User.stena_rezka.back.filter_type == t1[2][1] then
		m_simpleTV.User.stena_rezka.back.filter_type = t1[3][1]
		m_simpleTV.User.stena_rezka.back.filter_type_name = t1[3][2]
		setConfigVal('rezka_filter_type',t1[3][1])
		return last_rezka(m_simpleTV.User.stena_rezka.back.filter,m_simpleTV.User.stena_rezka.back.title:gsub(' %(.-$',''),1)
	end
	if m_simpleTV.User.stena_rezka.back.filter_type == t1[3][1] then
		m_simpleTV.User.stena_rezka.back.filter_type = t1[1][1]
		m_simpleTV.User.stena_rezka.back.filter_type_name = t1[1][2]
		setConfigVal('rezka_filter_type',t1[1][1])
		return last_rezka(m_simpleTV.User.stena_rezka.back.filter,m_simpleTV.User.stena_rezka.back.title:gsub(' %(.-$',''),1)
	end
end

function change_stena_rezka_pls_type()
	m_simpleTV.User.stena_rezka.back.current_page_karusel = nil
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local t1 = {
	{'table','Таблица'},
	{'karusel','Карусель'},
	}

	if m_simpleTV.User.stena_rezka.back.pls_type == t1[1][1] then
		m_simpleTV.User.stena_rezka.back.pls_type = t1[2][1]
		m_simpleTV.User.stena_rezka.back.pls_type_name = t1[2][2]
		setConfigVal('rezka_pls_type',t1[2][1])
		return stena_rezka()
	end
	if m_simpleTV.User.stena_rezka.back.pls_type == t1[2][1] then
		m_simpleTV.User.stena_rezka.back.pls_type = t1[1][1]
		m_simpleTV.User.stena_rezka.back.pls_type_name = t1[1][2]
		setConfigVal('rezka_pls_type',t1[1][1])
		return stena_rezka()
	end
end

function get_karusel_posters(id)
	if not id then return end
	if id:match('PREV') then
		m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_3')
		m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST')
		m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST1')
		m_simpleTV.OSD.RemoveElement('ID_LOGO_STENA_REQUEST')
		m_simpleTV.User.stena_rezka.back.current_page_karusel = tonumber(m_simpleTV.User.stena_rezka.back.current_page_karusel) - 1
		return stena_rezka()
	end
	if id:match('NEXT') then
		m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_3')
		m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST')
		m_simpleTV.OSD.RemoveElement('ID_DIV_STENA_REQUEST1')
		m_simpleTV.OSD.RemoveElement('ID_LOGO_STENA_REQUEST')
		m_simpleTV.User.stena_rezka.back.current_page_karusel = tonumber(m_simpleTV.User.stena_rezka.back.current_page_karusel) + 1
		return stena_rezka()
	end
end

function last_media_info_rezka(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	if adr and adr ~= '' then
		return media_info_rezka(adr)
	end
	return
end
