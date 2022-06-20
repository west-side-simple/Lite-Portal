-- скрапер TVS для загрузки медиатеки "FoxTV" http://pa.fox-tv.fun/ (23/06/21)
-- логин, пароль установить в 'Password Manager', для id - FOX
-- ## Переименовать каналы ##
	local filter = {
	{'Наука', 'Наука UA'},
	}
	module('foxmedia_pls', package.seeall)
	local my_src_name = 'Foxmedia ($)'
	local function ProcessFilterTableLocal(t)
		if not type(t) == 'table' then return end
		for i = 1, #t do
			t[i].name = tvs_core.tvs_clear_double_space(t[i].name)
			for _, ff in ipairs(filter) do
				if (type(ff) == 'table' and t[i].name == ff[1]) then
					t[i].name = ff[2]
				end
			end
		end
	 return t
	end

local function ProcessLogoGroupTableLocal(group)
		local gn = {

		{"Фильмы СССР","fox=Фильмы СССР","http://m24.do.am/images/sssr.png"},
		{"Детское кино СССР","fox=Детское кино СССР","http://m24.do.am/images/kidsssr.png"},
		{"Мультфильмы СССР","fox=Мультфильмы СССР","http://m24.do.am/images/kids.png"},
		{"Наше кино","fox=Наше кино","http://m24.do.am/images/nashek.png"},
		{"Индийские фильмы","fox=Индийские фильмы","http://m24.do.am/images/india.png"},
		{"Релакс","fox=Релакс","http://m24.do.am/images/relax.png"},
		{"Fox Кинозалы","fox=Fox Кинозалы","http://m24.do.am/images/mix.png"},
		{"Сериалы","fox=Сериалы","http://m24.do.am/images/serials.png"},
		{"Музыка","fox=Музыка","http://m24.do.am/images/musicico.ico"},
		{"Сказки","fox=Сказки","http://m24.do.am/images/skazki.png"},
		{"Мультфильмы","fox=Мультфильмы","http://m24.do.am/Logo/mult.png"},
		{"4K фильмы","fox=4K фильмы","http://m24.do.am/images/4k.png"},
		{"Фэнтези","fox=Фэнтези","http://m24.do.am/Logo/fehntezi.png"},
		{"Фантастика","fox=Фантастика","http://m24.do.am/Logo/fantastika.png"},
		{"Ужасы","fox=Ужасы","http://m24.do.am/images/fear.png"},
		{"Триллер","fox=Триллер","http://m24.do.am/Logo/thiller.png"},
		{"Спортивные","fox=Спортивные","http://m24.do.am/images/sport.png"},
		{"Семейный","fox=Семейный","http://m24.do.am/images/family.png"},
		{"Приключения","fox=Приключения","http://m24.do.am/images/adventure.png"},
		{"Музыкальный фильм","fox=Музыкальный фильм","http://m24.do.am/images/musicle.png"},
		{"Криминальный","fox=Криминальный","http://m24.do.am/images/crime.png"},
		{"Комиксы","fox=Комиксы","http://m24.do.am/images/comix.png"},
		{"Комедия","fox=Комедия","http://m24.do.am/images/comedy.png"},
		{"Исторический","fox=Исторический","http://m24.do.am/images/history.png"},
		{"Драмы","fox=Драмы","http://m24.do.am/images/drama.png"},
		{"Документальный","fox=Документальный","http://m24.do.am/images/biograf.png"},
		{"Детектив","fox=Детектив","http://m24.do.am/images/Detective.png"},
		{"Военные","fox=Военные","http://m24.do.am/images/war.png"},
		{"Вестерн","fox=Вестерн","http://m24.do.am/images/western.png"},
		{"Боевик","fox=Боевик","http://m24.do.am/images/boevik.png"},
		{"Биографический","fox=Биографический","http://m24.do.am/images/biograf.png"},
		{"Аниме","fox=Аниме","http://m24.do.am/images/anime.png"},
		}

		local gt, logogroup = {}, './luaScr/user/westSide/icons/foxmedia.png'
  for gi=1,#gn do
    gt[gi] = {}
    gt[gi].GName = gn[gi][1]
    gt[gi].GAction = gn[gi][2]
	gt[gi].GLogo = gn[gi][3]
	if gn[gi][1] == group then
	logogroup = gn[gi][3]
	end
  end
  return logogroup
end

	function GetSettings()
	local scrap_settings = {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '../Channel/logo/icons/foxmedia.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 0, RefreshButton = 0, AutoBuild = 0, show_progress = 1, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0,GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 0, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3}}
	 return scrap_settings
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function LoadFromSite()
		local url
			local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('FOX') end, err)
		if not login or not password or login == '' or password == '' then return
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './work/Channel/logo/icons/foxmedia.png"', text = ' Внесите данные в менеджере паролей для ID FOX', color = ARGB(255, 255, 255, 255), showTime = 1000 * 60})
		else
		url = 'http://pl.etvs.live/' .. login
					.. '/' .. password
					.. '/vodall.m3u'
		end

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
				answer = answer .. '\n'
		local t, i = {}, 1

			for w in answer:gmatch('%#EXTINF:.-\n.-\n') do
				local title = w:match(',(.-)\n')
				local adr = w:match('\n(.-)\n')
				local logo = w:match('tvg%-logo="(.-)"')
					if not adr or not title then break end
				t[i] = {}
				t[i].name = title				
				adr = adr:gsub('password=.-&', 'password=' .. password .. '&')
				adr = adr:gsub('username=.-&', 'username=' .. login .. '&')
				adr = adr:gsub('/video%.', '/index.')
				t[i].address = adr
				t[i].RawM3UString = w:match('%d+(.-),')
				t[i].group = w:match('group%-title="([^"]+)')
				if t[i].name:match('Fox Сериалы') or t[i].name:match('Fox Кинозал')
				then
				t[i].name = t[i].name:gsub(' /.-$', '')
				t[i].group = 'Fox Кинозалы'
				end
				if t[i].name:match('Годзилла 2')
				then
				t[i].group = 'Приключения'
				end
				if t[i].name:match('Детская игра')
				then
				t[i].group = 'Триллер'
				end
				if t[i].name:match('Deja Vu 2006')
				then
				t[i].group = 'Триллер'
				end
				if t[i].name:match('В Севкабеле')
				then
				t[i].group = 'Музыка'
				end
				t[i].group_logo = ProcessLogoGroupTableLocal(t[i].group)

				name = t[i].name
-- Киноциклы
							if name:match('Гарри Поттер') or name:match('Фантастические твари')
							then t[i].group = '📽 Вселенная Гарри Поттера'
							t[i].group_logo = '../Channel/Logo/banners/MK/📽 Вселенная Гарри Поттера.png'
							end
							if name:match('Властелин колец') or name:match('Хоббит')
							then t[i].group = '📽 Властелин колец ⚜ Хоббит'
							t[i].group_logo = '../Channel/Logo/banners/MK/📽 Властелин колец ⚜ Хоббит.png'
							end
							if name:match('Звёздные войны')
							then t[i].group = '📽 Звёздные войны'
							t[i].group_logo = '../Channel/Logo/banners/MK/📽 Звёздные войны.png'
							end
							if name:match('Люди Икс') or name:match('Росомаха') or name:match('Дэдпул') or name:match('Логан') and not name:match('Удача Логана')
							then t[i].group = '📽 Люди Икс'
							t[i].group_logo = '../Channel/Logo/banners/MK/📽 Люди Икс.png'
							end
-- Вселенная Marvel
							if name:match('Железный человек')
                            or name:match('Невероятный Халк')
                            or name:match('Thor') and not name:match('Легенда викингов')
                            or name:match('Первый мститель')
							or name:match('Мстители')
                            or name:match('Тор 2%: Царство тьмы')
                            or name:match('Первый мститель%: Другая война')
                            or name:match('Стражи Галактики')
                            or name:match('Мстители: Эра Альтрона')
							or name:match('Человек%-муравей')
                            or name:match('Первый мститель%: Противостояние')
                            or name:match('Доктор Стрэндж')
                            or name:match('Стражи Галактики%. Часть 2')
                            or name:match('Тор%: Рагнарёк')
                            or name:match('Чёрная Пантера')
                            or name:match('Мстители%: Война бесконечности')
							or name:match('Капитан Марвел')
                            or name:match('Мстители%: Финал')
                            or name:match('Человек%-паук')
							or name:match('Чудо%-женщина')
							or name:match('Лига справедливости')
							then t[i].group = '📽 Вселенная Marvel'
							t[i].group_logo = '../Channel/Logo/banners/MK/📽 Вселенная Marvel.png'
							end

-- Бондиана
							if name:match('Доктор Ноу')
							or name:match('Из России с любовью')
							or name:match('Голдфингер')
							or name:match('Шаровая молния')
							or name:match('Живёшь только дважды')
							or name:match('На секретной службе ее Величества')
							or name:match('Бриллианты навсегда')
							or name:match('Живи и дай умереть')
							or name:match('Человек с золотым пистолетом')
							or name:match('Шпион%, который меня любил')
							or name:match('Лунный гонщик')
							or name:match('Только для твоих глаз')
							or name:match('Осьминожка')
							or name:match('Никогда не говори никогда')
							or name:match('Вид на убийство')
							or name:match('Искры из глаз')
							or name:match('Лицензия на убийство')
							or name:match('Золотой Глаз')
							or name:match('Завтра не умрёт никогда')
							or name:match('И целого мира мало')
							or name:match('Умри%, но не сейчас')
							or name:match('Казино Рояль')
							or name:match('Квант милосердия')
							or name:match('Скайфолл')
							or name:match('Спектр ')
							or name:match('Не время умирать')
							then t[i].group = '📽 Бондиана'
							t[i].group_logo = '../Channel/Logo/banners/MK/📽 Бондиана.png'
							end
							t[i].group_is_unique = 1
				i = i + 1
			end
			if i == 1 then return end
	 return t
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite()
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' ошибка загрузки плейлиста'
											, color = ARGB(255, 255, 100, 0)
											, showTime = 1000 * 5
											, id = 'channelName'})
			 return
			end
			if t_pls == 0 then
				m_simpleTV.OSD.ShowMessageT({text = 'логин/пароль установить\nв дополнении "Password Manager"\для id - FOX'
											, color = ARGB(255, 255, 100, 0)
											, showTime = 1000 * 5
											, id = 'channelName'})
			 return
			end
		m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' (' .. #t_pls .. ')'
									, color = ARGB(255, 155, 255, 155)
									, showTime = 1000 * 5
									, id = 'channelName'})
		t_pls = ProcessFilterTableLocal(t_pls)
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')