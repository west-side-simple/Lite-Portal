-- скрапер TVS для схемы https://itv.rt.ru (16/10/20) - фильмы
-- пакеты -----------------------------------------------------------------

  local package_id = '1000,75708675,75708662,58448812,51668850,75608266,28786394,73985815,72726400,74978218,1000,68863456,51668850,74978253,48304735,51218122,51163704,74012058,69823916,1892579,51166947,51214152'

---------------------------------------------------------------------------
	module('Z_films_pls', package.seeall)
	local my_src_name = '🎦 Фильмы'
	function GetSettings()
		local scrap_settings = {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '..\\Channel\\logo\\Icons\\serials.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, show_progress = 1, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0,GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 0, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3}}
	 return scrap_settings
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
-------

	local function LoadFromSite()
			local function round(str)
				return string.format('%.' .. (1 or 0) .. 'f', str)
			end

			local function getReting(kpR, idmR)
				local kp, idm
				if kpR and kpR ~= '0' then
					kp = 'KП  ' .. round(kpR)
				end
				if idmR and idmR ~= '0' then
					idm = 'IMDb  ' .. round(idmR)
				end
					if not kp and not idm then return end
				local zpt = ''
				if kp and idm then
					zpt = ', '
				end
			 return (kp or '') .. zpt .. (idm or '') .. ' | '
			end
		require 'json'

-- Блок динамичного контента
		local reting = getReting(kpR, idmR)
		local session = m_simpleTV.Http.New('Mozilla/5.0 (SmartHub; SMART-TV; U; Linux/SmartTV) AppleWebKit/531.2+ (KHTML, like Gecko) WebBrowser/1.0 SmartTV Safari/531.2+')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 180000)

		local rc, answer = m_simpleTV.Http.Request(session, {url = decode64('aHR0cHM6Ly9mZS5zdmMuaXB0di5ydC5ydS9DYWNoZUNsaWVudEpzb24vanNvbi9Wb2RQYWNrYWdlL2xpc3RfbW92aWVzP2xvY2F0aW9uSWQ9NzAwMDAxJmZyb209MCZ0bz05OTk5OTk5OSZwYWNrYWdlSWQ9') .. package_id})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
		answer = answer:gsub('%[%]', '"nil"')
		local tab = json.decode(answer)

			if not tab or not tab.movie_list then return end
		local t, i = {}, 1
		local j = 1
			while true do
					if not tab.movie_list[j] then break end
				if tab.movie_list[j].assets and tab.movie_list[j].kinopId
				and (not tab.movie_list[j].name:match('. Серия') or tab.movie_list[j].name:match('. Серия') and tab.movie_list[j].country and tab.movie_list[j].country:match('СССР'))
				and (not tab.movie_list[j].name:match('. Серии') or tab.movie_list[j].name:match('. Серии') and tab.movie_list[j].country and tab.movie_list[j].country:match('СССР'))
				and (not tab.movie_list[j].name:match('. Сезон') or tab.movie_list[j].name:match('. Сезон') and tab.movie_list[j].country and tab.movie_list[j].country:match('СССР'))
				and not tab.movie_list[j].name:match('Кротик и Панда')
				and not tab.movie_list[j].name:match('Смешарики')
				and not tab.movie_list[j].name:match('Фиксики')
				and not tab.movie_list[j].name:match(' 4K')
				and not tab.movie_list[j].name:match(' Гоблина')
				and (tab.movie_list[j].kinopId or (not tab.movie_list[j].kinopId and (
				tab.movie_list[j].name:match('Как трусливый Роберт Форд убил Джесси Джеймса') or
				tab.movie_list[j].name:match('Малыши в дикой природе') or
				tab.movie_list[j].name:match('Джефф, живущий дома') or
				tab.movie_list[j].name:match('8 первых свиданий') or
				tab.movie_list[j].name:match('Новогодний ремонт') or
				tab.movie_list[j].name:match('Эрагон') or
				tab.movie_list[j].name:match('Головокружение') or
				tab.movie_list[j].name:match('Пророк') and tab.movie_list[j].year == '2009' or
				tab.movie_list[j].name:match('Библиотекарь: В поисках копья судьбы') or
				tab.movie_list[j].name:match('Затура: Космическое приключение') or
				tab.movie_list[j].country and tab.movie_list[j].country:match('СССР')
				)))
				then
					t[i] = {}

					t[i].group = '📽 Другие'
					t[i].address = decode64('aHR0cHM6Ly84MjA5LnN2ZXRhY2RuLmluL1BYazJRR2J2RVZtUz9rcF9pZD0') .. tab.movie_list[j].kinopId
					t[i].name = tab.movie_list[j].name
					t[i].name_z = tab.movie_list[j].name
					t[i].logo = tab.movie_list[j].logo2
					t[i].kinopId = tab.movie_list[j].kinopId
					kinopId = t[i].kinopId
					name = t[i].name:gsub(',', '%%2C'):gsub('"', '%%22')
					t[i].years = tab.movie_list[j].year or ''
					year = tab.movie_list[j].year
					director = tab.movie_list[j].director or ''
					actors = tab.movie_list[j].actors or ''
					actors = actors:gsub('Эштон Катчер', 'Эштон Кутчер'):gsub('Дженнифер Лопез', 'Дженнифер Лопес'):gsub('Этан Хоук', 'Итан Хоук')
					
-- ошибки базы
					if kinopId and kinopId == '41982' then country = 'СССР' end
					if kinopId and kinopId == '471073' then country = 'СССР' end
					if kinopId and kinopId == '447653' then year = '2010' end
					if kinopId and kinopId == 'Skjelvet' then kinopId = '1094106' end
					if kinopId and kinopId == '934413' then kinopId = '938871' end
					if kinopId and kinopId == '572049' then country = 'США' end
					if kinopId and kinopId == '79848' and name:match('Секс в большом городе') then kinopId = '77042' end
					if country and year and country:match('СССР') and tonumber(year) >= 1992 then country = country:gsub('СССР', 'Россия') end

-- дополнения
					if t[i].name:match('История о нас. Серия') then kinopId = '1316645'
					t[i].logox = 'https://avatars.mds.yandex.net/get-kinopoisk-image/1900788/7ab0df69-e0d9-4194-b38b-0ffbdf4047e3/360'
					end
					if t[i].name:match('Исследователь. Серия') then kinopId = '1346338'
					t[i].logox = 'https://avatars.mds.yandex.net/get-kinopoisk-image/1600647/4f626eaf-6dd0-4707-9b3c-ce083d40b8f9/360'
					end
					if tab.movie_list[j].name:match('Иван Царевич и Серый Волк 3') then kinopId = '705346' end
					if tab.movie_list[j].name:match('Иван Царевич и Серый Волк 2') then country = 'Россия' end
				    if tab.movie_list[j].name:match('Как трусливый Роберт Форд убил Джесси Джеймса') then kinopId = '102127' end
				    if tab.movie_list[j].name:match('Малыши в дикой природе') then kinopId = '1142491' end
				    if tab.movie_list[j].name:match('Джефф, живущий дома') then kinopId = '507673' end
				    if tab.movie_list[j].name:match('8 первых свиданий') then kinopId = '615823' end
				    if tab.movie_list[j].name:match('Новогодний ремонт') then kinopId = '1273240' end
				    if tab.movie_list[j].name:match('Эрагон') then kinopId = '103644' end
				    if tab.movie_list[j].name:match('Головокружение') then kinopId = '352' end
				    if tab.movie_list[j].name == 'Пророк' then kinopId = '436502' end
				    if tab.movie_list[j].name:match('Библиотекарь: В поисках копья судьбы') then kinopId = '161030' end
				    if tab.movie_list[j].name:match('Затура: Космическое приключение') then kinopId = '81097' country = 'США' end
					if tab.movie_list[j].name:match('Кругляши') then kinopId = '1351742' country = 'Россия' end
					if tab.movie_list[j].name:match('Подкидыш') then kinopId = '43044' end

					if tab.movie_list[j].name:match('Машины сказки') then t[i].group = 'Машины сказки' country = 'Россия' end
					if tab.movie_list[j].name:match('Маша и Медведь') then t[i].group = 'Маша и медведь' country = 'Россия' end

					if kinopId and kinopId == '8139' then country = 'США,Мексика' end
					if kinopId and kinopId == '1162957' then country = 'Китай' end
					if kinopId and kinopId == '257974' then country = 'СССР' end
					if kinopId and kinopId == '414930' then country = 'Россия' end
					if kinopId and kinopId == '8043' then country = 'Великобритания,Франция,Италия,США' end
					if kinopId and kinopId == '6173' then country = 'Германия,США' end
					if kinopId and kinopId == '652088' then country = 'Россия' end
					if kinopId and kinopId == '84048' then country = 'Великобритания,Италия,Марокко' end
					if kinopId and kinopId == '195222' then country = 'Великобритания,США' end
					if kinopId and kinopId == '596318' then country = 'Франция,Канада' end
					if kinopId and kinopId == '573772' then country = 'Россия' end
					if kinopId and kinopId == '18973' then country = 'Франция,Великобритания' end
					if kinopId and kinopId == '361' then country = 'США,Германия' end
					if kinopId and kinopId == '404333' then country = 'США,Франция' end
					if kinopId and kinopId == '79072' then country = 'США,Австралия' end
					if kinopId and kinopId == '104942' then country = 'Великобритания' end
					if kinopId and kinopId == '582170' then country = 'США,Великобритания' end
					if kinopId and kinopId == '797' then country = 'США,Канада' end
					if kinopId and kinopId == '7096' then country = 'США,Германия,Мексика' end
					if kinopId and kinopId == '13682' then country = 'Великобритания,Франция,Аргентина' end
					if kinopId and kinopId == '550910' then country = 'США,Франция,Япония' end
					if kinopId and kinopId == '87178' then country = 'США,Канада' end
					if kinopId and kinopId == '406354' then country = 'США,Канада' end
					if kinopId and kinopId == '989978' then country = 'Колумбия,США' end
					if kinopId and kinopId == '15067' then country = 'Австралия' end
					if kinopId and kinopId == '8033' then country = 'США,Германия,Великобритания,Венгрия' end
					if kinopId and kinopId == '588' then country = 'США,Канада' end
					if kinopId and kinopId == '1107' then country = 'Франция,США' end
					if kinopId and kinopId == '683191' then country = 'США,Болгария' end
					if kinopId and kinopId == '594736' then country = 'США,Япония,Испания,Великобритания' end
					if kinopId and kinopId == '785' then country = 'США,Австралия' end
					if kinopId and kinopId == '77407' then country = 'США,Мексика' end
					if kinopId and kinopId == '258804' then country = 'Германия,США' end
					if kinopId and kinopId == '811398' then country = 'Италия' end
					if kinopId and kinopId == '1150048' then country = 'США,Сербия,Канада' end
					if kinopId and kinopId == '427272' then country = 'Ирландия,Великобритания' end
					if kinopId and kinopId == '689587' then country = 'США,Канада' end
					if kinopId and kinopId == '738974' then country = 'Россия' end
					if kinopId and kinopId == '718562' then country = 'Россия' end
					if kinopId and kinopId == '692472' then country = 'Испания' end
					if kinopId and kinopId == '468182' then country = 'Россия' end
					if kinopId and kinopId == '839506' then country = 'Армения' end
					if kinopId and kinopId == '1174226' then country = 'Китай,США' end
					if kinopId and kinopId == '771113' then country = 'Франция,Россия' end
					if kinopId and kinopId == '416199' then country = 'Великобритания,Франция' end
					if kinopId and kinopId == '646313' then country = 'Великобритания,Пуэрто Рико,США' end
					if kinopId and kinopId == '647676' then country = 'Франция,Люксембург,Бельгия' end
					if kinopId and kinopId == '1065010' then country = 'Норвегия' end
					if kinopId and kinopId == '958470' then country = 'Россия' end
					if kinopId and kinopId == '103156' then country = 'Великобритания,США' end
					if kinopId and kinopId == '682934' then country = 'Великобритания' end
					if kinopId and kinopId == '425373' then country = 'Россия' end
					if kinopId and kinopId == '485295' then country = 'Франция,Австралия,Германия,Италия' end
					if kinopId and kinopId == '416107' then country = 'Венгрия,США' end
					if kinopId and kinopId == '1052714' then country = 'Швеция' end
					if kinopId and kinopId == '487471' then country = 'Великобритания' end
					if kinopId and kinopId == '418840' then country = 'США,Канада,Великобритания' end
					if kinopId and kinopId == '12330' then country = 'США,Германия' end
					if kinopId and kinopId == '7030' then country = 'Канада,США,Швейцария' end
					if kinopId and kinopId == '1047956' then country = 'Италия,Германия,Франция' end
					if kinopId and kinopId == '681849' then country = 'Италия' end
					if kinopId and kinopId == '325797' then country = 'США,Япония' end
					if kinopId and kinopId == '2890' then country = 'США,Великобритания' end
					if kinopId and kinopId == '615583' then country = 'США,Великобритания,Франция' end
					if kinopId and kinopId == '653696' then country = 'Россия' end
					if kinopId and kinopId == '839355' then country = 'Франция,Бельгия' end

					if country == '🌐' then country = 'США' end
					if kinopId then t[i].kinopId = kinopId end

					k = 1
				    genres = ''
				    group = ''
					while true do
							if not (tab.movie_list[j].genres and tab.movie_list[j].genres[k]) then break end
							genrestmp = tostring (tab.movie_list[j].genres[k])

							if genrestmp == '1712860' then genrestmp = 'комедия'
                            elseif genrestmp == '1712861' then genrestmp = 'боевик'
							elseif genrestmp == '1712862' then genrestmp = 'приключения'
							elseif genrestmp == '1712863' or genrestmp == '87191651'
							then genrestmp = 'ужасы'
							elseif genrestmp == '81732440' then genrestmp = 'анимационный'
							elseif genrestmp == '1712864'
							or genrestmp == '25927802'
							then genrestmp = 'драма'
							elseif genrestmp == '1712865' then genrestmp = 'триллер'
							elseif genrestmp == '1712866' then genrestmp = 'мультфильм'
							elseif genrestmp == '1712873' then genrestmp = 'мелодрама'
							elseif genrestmp == '1712877' then genrestmp = 'фэнтези'
							elseif genrestmp == '1712878' then genrestmp = 'история'
							elseif genrestmp == '1744092' then genrestmp = 'мюзикл'
							elseif genrestmp == '1744093' then genrestmp = 'кино для детей'
							elseif genrestmp == '78740546' then genrestmp = 'романтические'
							elseif genrestmp == '1744094' then group = 'Сериалы '
							elseif genrestmp == '1744096' then genrestmp = 'UFC'
							elseif genrestmp == '39041214' then genrestmp = 'криминал'
							elseif genrestmp == '22220859' and name:match('. Серия ') or genrestmp == '22220859' and name:match('. Сезон ')
							then group = 'Сериалы '
							elseif genrestmp == '71765859' and name:match('. Серия ') or genrestmp == '71765859' and name:match('. Сезон ')
							then group = 'Сериалы '
							elseif genrestmp == '22385166' and name:match('. Серия ') or genrestmp == '22385166' and name:match('. Сезон ')
							then group = 'Сериалы '
							elseif genrestmp == '91606006' and name:match('. Сезон ')
							or genrestmp == '91606006' and name:match('. Серия ')
							or genrestmp == '91606006' and name:match('. Серии ')
							then group = 'Сериалы '
							elseif genrestmp == '1744091' or
							genrestmp == '7724576' and name:match('. Серия ') or genrestmp == '7724576' and name:match('. Сезон ') or
							genrestmp == '75770084' and name:match('. Серия ') or genrestmp == '75770084' and name:match('. Сезон ')
							then t[i].group = 'Мультсериалы ' .. t[i].group
							elseif genrestmp == '23746312' or genrestmp == '23746263' then genrestmp = 'эротика'
							elseif genrestmp == '23738041' then group = 'Сериалы '
							elseif genrestmp == '28808574' then t[i].group = '📺 📚 Обучающие программы' country = 'Россия'
							elseif genrestmp == '73409267' then t[i].group = '📺 📚 Изучение English'
							else genrestmp = genrestmp end

							if genrestmp == '1712874' or genrestmp == '75770084'
							then genrestmp = 'документальный'
							end
							if genrestmp == '91506725' then genrestmp = 'короткометражка'
							end
							if genrestmp == '16519276' then genrestmp = 'музыка'
							end
							if genrestmp == '73409267' then genrestmp = 'английский'
							end
							if genrestmp == '1744091' then genrestmp = 'мультсериал'
							end
							if genrestmp == '7724576' then genrestmp = 'мультфильм'
							end
							if genrestmp == '71765859' or genrestmp == '87491679'
							then genrestmp = 'семейный'
							end
							if genrestmp == '22385166' then genrestmp = 'популярный'
							end
							if genrestmp == '22220859' then genrestmp = 'рекомендуемый'
							end
							if genrestmp == '23738041' or genrestmp == '1744094' then genrestmp = 'сериал'
							end
							if genrestmp == '28808574' then genrestmp = 'уроки и лекции'
							end
							if genrestmp == '65020420' then genrestmp = 'топ'
							end
							if genrestmp == '91606006' then genrestmp = 'новинки'
							end
							if genrestmp == '35480501' then	genrestmp = 'перевод Гоблина'
							end
							if genrestmp == '81756014' then	genrestmp = '4K'
							end
							if genrestmp == '1744095' or genrestmp == '40609800' then genrestmp = 'золотой фонд'
							end

						if k == 1 then genres = genrestmp .. genres else
						genres = genrestmp .. ', ' .. genres end
						k = k + 1
					end
--дополнения
					if kinopId and kinopId == '12126' then genres = 'комедия, семейный' end
--
				    genres_title = genres:gsub(',', '%%2C'):gsub('%c', '')
					if group and group == 'Сериалы ' then t[i].group = 'Сериалы ' .. t[i].group end
					if t[i].group:match('Сериалы') and not name:match('. Серия ') and not name:match('. Серии ') and not name:match('. Сезон ')
					then
					t[i].group = t[i].group:gsub('Сериалы ', '')
					genres_title = 'фильм'
					end

					t[i].group = t[i].group:gsub('Сериалы Детям', 'Мультсериалы')
					t[i].group = t[i].group:gsub('Сериалы Мультсериалы', 'Мультсериалы')
					t[i].group = t[i].group:gsub('Сериалы Мультсериалы Мультсериалы', 'Мультсериалы')
					t[i].group = t[i].group:gsub('Мультсериалы Мультсериалы', 'Мультсериалы')
					t[i].group = t[i].group:gsub('Мультсериалы Мультсериалы Мультсериалы', 'Мультсериалы')
					t[i].group = t[i].group:gsub('Мультсериалы Мультсериалы Мультсериалы Мультсериалы', 'Мультсериалы')
					t[i].group = t[i].group:gsub('Мультсериалы 📽 🚂 Мультфильмы', 'Мультсериалы')

-- Группировка отдельных жанров
					t[i].flags = ''

					if genres then
					if (name:match('. Серия ') or name:match('. Серии ') or name:match('. Сезон ')) then t[i].group = t[i].group
					elseif genres:match('семейный') and genres:match('мультфильм')
					then t[i].group = '📽 🧜‍ Мультфильмы для всей семьи'
					elseif genres:match('семейный') and not genres:match('мультфильм')
					then t[i].group = '📽 🐶 Кино для всей семьи'
							end
							end

					if genres and genres:match('комедия') then
							t[i].group = '🎥 🤡 Комедия'
							end
					if genres then genres = genres:gsub('мелодрама', 'genrestmp') end
					if genres and genres:match('драма') then
							t[i].group = '🎥 🎭 Драма'
							end
					if genres then genres = genres:gsub('genrestmp', 'мелодрама') end
					if genres and genres:match('триллер') then
							t[i].group = '🎥 👺 Триллер'
							end
					if genres and genres:match('приключения') then
							t[i].group = '🎥 🗺 Приключения'
							end
					if genres and genres:match('документальный') then
							t[i].group = '🎥 📹 Документальные'
							end
					if genres and genres:match('боевик') then
					        t[i].group = '🎥 💣 Боевик'
							end
					if genres and genres:match('мелодрама') then
							t[i].group = '🎥 💖 Мелодрама'
							end
					if genres and genres:match('ужасы') then
							t[i].group = '🎥 🧛 Ужасы'
							end
					if genres and genres:match('детектив') then
							t[i].group = '🎥 🕵 Детектив'
							end
					if genres and genres:match('криминал') then
							t[i].group = '🎥 💰 Криминал'
							end
					if genres and genres:match('фэнтези') then
							t[i].group = '🎥 👻 Фэнтези'
							end
					if genres and genres:match('вестерн') then
							t[i].group = '🎥 🤠 Вестерн'
							end
					if genres and genres:match('история') then
							t[i].group = '🎥 📜 История'
							end
					if genres and genres:match('спорт') then
					        t[i].group = '🎥 🏀 Спорт'
							end
					if genres and genres:match('мюзикл') then
							t[i].group = '🎥 🎶 Мюзикл'
							end
					if genres and genres:match('короткометражка') then
							t[i].group = '🎥 ⏳ Короткометражные'
							end

					if genres and genres:match('кино для детей') or t[i].group:match('Детям') and not genres:match('мультфильм') then
							t[i].group = '📽 🤴 Кино для детей'
							t[i].flags = t[i].flags .. ' 🤴 '
							end
					if genres and genres:match('семейный') then
							t[i].flags = t[i].flags .. ' 👨‍👩‍👧‍👦 '
							end
					if genres and genres:match('мультфильм') then
							t[i].flags = t[i].flags .. ' 🧜 '
							end
					if genres and genres:match('мультфильм')
					and not genres:match('кино для детей')
					and not t[i].group:match('Мультсериалы')
					then
					        t[i].group = '📽 🧜 Мультфильмы'
							end
					if genres and genres:match('анимационный') then
					        t[i].group = '🎥 👀 Анимационные'
							t[i].flags = t[i].flags .. ' 👀 '
							end
					if name:match('Фиксики') then country = 'Россия' t[i].group = t[i].group:gsub('📽 🤴 Кино для детей ', '') t[i].group = 'Мультсериалы ' .. t[i].group end
					if name:match('Кротик и Панда') then t[i].group = t[i].group:gsub('📽 🤴 Кино для детей ', '') t[i].group = 'Мультсериалы ' .. t[i].group end
					if name:match('Смешарики') then country = 'Россия' t[i].group = 'Мультсериалы Смешарики' end

					if country and country:match('Россия') and not t[i].group:match('📺 📚 Обучающие программы') then t[i].group = '🇷🇺 ' .. t[i].group
					elseif country and country:match('Китай') then t[i].group = '🇨🇳 ' .. t[i].group
					elseif country and country:match('Великобритания') and not t[i].group:match('📺 📚 Изучение English') then t[i].group = '🇬🇧 ' .. t[i].group
					elseif country and country:match('Франция') then t[i].group = '🇫🇷 ' .. t[i].group
					elseif country and country:match('Канада') then t[i].group = '🇨🇦 ' .. t[i].group
					elseif country and country:match('Индия') then t[i].group = '🇮🇳 ' .. t[i].group end

							if actors and actors:match('Том Хэнкс') then
							t[i].group = '👨‍ Том Хэнкс'
							elseif actors and actors:match('Николас Кейдж') then
							t[i].group = '👨‍ Николас Кейдж'
							elseif actors and actors:match('Клинт Иствуд') then
							t[i].group = '👨‍ Клинт Иствуд'
							elseif actors and actors:match('Джек Николсон') then
							t[i].group = '👨‍ Джек Николсон'
							elseif actors and actors:match('Джон Малкович') then
							t[i].group = '👨‍ Джон Малкович'
							elseif actors and actors:match('Джим Керри') then
							t[i].group = '👨‍ Джим Керри'
							elseif actors and actors:match('Аль Пачино') then
							t[i].group = '👨‍ Аль Пачино'
							elseif actors and actors:match('Киану Ривз') then
							t[i].group = '👨‍ Киану Ривз'
							elseif actors and actors:match('Дастин Хоффман') then
							t[i].group = '👨‍ Дастин Хоффман'
							elseif actors and actors:match('Джерард Батлер') then
							t[i].group = '👨‍ Джерард Батлер'
							elseif actors and actors:match('Бен Стиллер') then
							t[i].group = '👨‍ Бен Стиллер'
							elseif actors and actors:match('Брэдли Купер') then
							t[i].group = '👨‍ Брэдли Купер'
							elseif actors and actors:match('Морган Фриман') then
							t[i].group = '👨‍ Морган Фриман'
							elseif actors and actors:match('Леонардо ДиКаприо') then
							t[i].group = '👨‍ Леонардо ДиКаприо'
							elseif actors and actors:match('Роберт Де Ниро') then
							t[i].group = '👨‍ Роберт Де Ниро'
							elseif actors and actors:match('Мэл Гибсон') then
							t[i].group = '👨‍ Мэл Гибсон'
							elseif actors and actors:match('Брэд Питт') then
							t[i].group = '👨‍ Брэд Питт'
							elseif actors and actors:match('Том Круз') then
							t[i].group = '👨‍ Том Круз'
							elseif actors and actors:match('Джордж Клуни') then
							t[i].group = '👨‍ Джордж Клуни'
							elseif actors and actors:match('Джонни Депп') then
							t[i].group = '👨‍ Джонни Депп'
							elseif actors and actors:match('Стив Карелл') then
							t[i].group = '👨‍ Стив Карелл'
							elseif actors and actors:match('Энтони Хопкинс') then
							t[i].group = '👨‍ Энтони Хопкинс'
							elseif actors and actors:match('Арнольд Шварценеггер') then
							t[i].group = '👨‍ Арнольд Шварценеггер'
							elseif actors and actors:match('Сильвестр Сталлоне') then
							t[i].group = '👨‍ Сильвестр Сталлоне'
							elseif actors and actors:match('Вин Дизель') then
							t[i].group = '👨‍ Вин Дизель'
							elseif actors and actors:match('Бен Аффлек') then
							t[i].group = '👨‍ Бен Аффлек'
							elseif actors and actors:match('Брюс Уиллис') then
							t[i].group = '👨‍ Брюс Уиллис'
							elseif actors and actors:match('Кевин Костнер') then
							t[i].group = '👨‍ Кевин Костнер'
							elseif actors and actors:match('Мэтт Дэймон') then
							t[i].group = '👨‍ Мэтт Дэймон'
							elseif actors and actors:match('Дэниэл Крэйг') then
							t[i].group = '👨‍ Дэниэл Крэйг'
							elseif actors and actors:match('Майкл Дуглас') then
							t[i].group = '👨‍ Майкл Дуглас'
							elseif actors and actors:match('Ричард Гир') then
							t[i].group = '👨‍ Ричард Гир'
							elseif actors and actors:match('Хью Грант') then
							t[i].group = '👨‍ Хью Грант'
							elseif actors and actors:match('Алек Болдуин') then
							t[i].group = '👨‍ Алек Болдуин'
							elseif actors and actors:match('Харрисон Форд') then
							t[i].group = '👨‍ Харрисон Форд'
							elseif actors and actors:match('Эдди Мёрфи') then
							t[i].group = '👨‍ Эдди Мёрфи'
							elseif actors and actors:match('Робин Уильямс') then
							t[i].group = '👨‍ Робин Уильямс'
							elseif actors and actors:match('Джон Траволта') then
							t[i].group = '👨‍ Джон Траволта'
							elseif actors and actors:match('Антонио Бандерас') then
							t[i].group = '👨‍ Антонио Бандерас'
							elseif actors and actors:match('Курт Рассел') then
							t[i].group = '👨‍ Курт Рассел'
							elseif actors and actors:match('Рассел Кроу') then
							t[i].group = '👨‍ Рассел Кроу'
							elseif actors and actors:match('Роберт Дауни мл.') then
							t[i].group = '👨‍ Роберт Дауни мл.'
							elseif actors and actors:match('Кевин Спейси') then
							t[i].group = '👨‍ Кевин Спейси'
							elseif actors and actors:match('Джейсон Стэйтем') then
							t[i].group = '👨‍ Джейсон Стэйтем'
							elseif actors and actors:match('Джеймс Белуши') then
							t[i].group = '👨‍ Джеймс Белуши'
							elseif actors and actors:match('Эштон Кутчер') then
							t[i].group = '👨‍ Эштон Кутчер'
							elseif actors and actors:match('Майкл Шин') then
							t[i].group = '👨‍ Майкл Шин'
							elseif actors and actors:match('Кристиан Бэйл') then
							t[i].group = '👨‍ Кристиан Бэйл'
							elseif actors and actors:match('Бенедикт Камбербэтч') then
							t[i].group = '👨‍ Бенедикт Камбербэтч'
							elseif actors and actors:match('Итан Хоук') then
							t[i].group = '👨‍ Итан Хоук'
							elseif actors and actors:match('Билл Мюррей') then
							t[i].group = '👨‍ Билл Мюррей'
							elseif actors and actors:match('Том Харди') then
							t[i].group = '👨‍ Том Харди'
							elseif actors and actors:match('Ли Пейс') then
							t[i].group = '👨‍ Ли Пейс'
							elseif actors and actors:match('Джуд Лоу') then
							t[i].group = '👨‍ Джуд Лоу'
							elseif actors and actors:match('Микки Рурк') then
							t[i].group = '👨‍ Микки Рурк'
							elseif actors and actors:match('Орландо Блум') then
							t[i].group = '👨‍ Орландо Блум'
							elseif actors and actors:match('Мартин Фриман') then
							t[i].group = '👨‍ Мартин Фриман'
							elseif actors and actors:match('Крис Хемсворт') then
							t[i].group = '👨‍ Крис Хемсворт'
							elseif actors and actors:match('Эдвард Нортон') then
							t[i].group = '👨‍ Эдвард Нортон'
							elseif actors and actors:match('Хоакин Феникс') then
							t[i].group = '👨‍ Хоакин Феникс'
							elseif actors and actors:match('Шон Коннери') then
							t[i].group = '👨‍ Шон Коннери'
							elseif actors and actors:match('Пирс Броснан') then
							t[i].group = '👨‍ Пирс Броснан'
							elseif actors and actors:match('Колин Фёрт') then
							t[i].group = '👨‍ Колин Фёрт'
							elseif actors and actors:match('Адам Сэндлер') then
							t[i].group = '👨‍ Адам Сэндлер'
							elseif actors and actors:match('Жан Рено') then
							t[i].group = '👨‍ Жан Рено'
							elseif actors and actors:match('Джош Хартнетт') then
							t[i].group = '👨‍ Джош Хартнетт'
							elseif actors and actors:match('Жан-Клод Ван Дамм') then
							t[i].group = '👨‍ Жан-Клод Ван Дамм'
							elseif actors and actors:match('Уилл Смит') then
							t[i].group = '👨‍ Уилл Смит'
							elseif actors and actors:match('Алексей Серебряков') then
							t[i].group = '👨‍ Алексей Серебряков'
							elseif actors and actors:match('Константин Хабенский') then
							t[i].group = '👨‍ Константин Хабенский'
							elseif actors and actors:match('Владимир Машков') then
							t[i].group = '👨‍ Владимир Машков'
							elseif actors and actors:match('Сергей Гармаш') then
							t[i].group = '👨‍ Сергей Гармаш'
							elseif actors and actors:match('Алексей Чадов') then
							t[i].group = '👨‍ Алексей Чадов'
							elseif actors and actors:match('Евгений Сидихин') then
							t[i].group = '👨‍ Евгений Сидихин'
                            elseif actors and actors:match('Евгений Ткачук') then
							t[i].group = '👨‍ Евгений Ткачук'
							elseif actors and actors:match('Дайан Китон') then
							t[i].group = '👩‍‍ Дайан Китон'
							elseif actors and actors:match('Кэмерон Диаз') then
							t[i].group = '👩‍‍ Кэмерон Диаз'
							elseif actors and actors:match('Деми Мур') then
							t[i].group = '👩‍‍ Деми Мур'
							elseif actors and actors:match('Николь Кидман') then
							t[i].group = '👩‍‍ Николь Кидман'
							elseif actors and actors:match('Анджелина Джоли') then
							t[i].group = '👩‍‍ Анджелина Джоли'
							elseif actors and actors:match('Гвинет Пэлтроу') then
							t[i].group = '👩‍‍ Гвинет Пэлтроу'
							elseif actors and actors:match('Скарлетт Йоханссон') then
							t[i].group = '👩‍‍ Скарлетт Йоханссон'
							elseif actors and actors:match('Дрю Бэрримор') then
							t[i].group = '👩‍‍ Дрю Бэрримор'
							elseif actors and actors:match('Дженнифер Энистон') then
							t[i].group = '👩‍‍ Дженнифер Энистон'
							elseif actors and actors:match('Джулия Робертс') then
							t[i].group = '👩‍‍ Джулия Робертс'
							elseif actors and actors:match('Мэрил Стрип') then
							t[i].group = '👩‍‍ Мэрил Стрип'
							elseif actors and actors:match('Кейт Бланшетт') then
							t[i].group = '👩‍‍ Кейт Бланшетт'
                            elseif actors and actors:match('Мила Кунис') then
							t[i].group = '👩‍‍ Мила Кунис'
                            elseif actors and actors:match('Кира Найтли') then
							t[i].group = '👩‍‍ Кира Найтли'
                            elseif actors and actors:match('Ума Турман') then
							t[i].group = '👩‍‍ Ума Турман'
                            elseif actors and actors:match('Кэтрин Хайгл') then
							t[i].group = '👩‍‍ Кэтрин Хайгл'
							elseif actors and actors:match('Шэрон Стоун') then
							t[i].group = '👩‍‍ Шэрон Стоун'
							elseif actors and actors:match('Сандра Буллок') then
							t[i].group = '👩‍‍ Сандра Буллок'
							elseif actors and actors:match('Элизабет Бэнкс') then
							t[i].group = '👩‍‍ Элизабет Бэнкс'
							elseif actors and actors:match('Сигурни Уивер') then
							t[i].group = '👩‍‍ Сигурни Уивер'
							elseif actors and actors:match('Сара Джессика Паркер') then
							t[i].group = '👩‍‍ Сара Джессика Паркер'
							elseif actors and actors:match('Мег Райан') then
							t[i].group = '👩‍‍ Мег Райан'
							elseif actors and actors:match('Кейт Уинслет') then
							t[i].group = '👩‍‍ Кейт Уинслет'
							elseif actors and actors:match('Рене Зеллвегер') then
							t[i].group = '👩‍‍ Рене Зеллвегер'
							elseif actors and actors:match('Ким Бейсингер') then
							t[i].group = '👩‍‍ Ким Бейсингер'
							elseif actors and actors:match('Мишель Пфайффер') then
							t[i].group = '👩‍‍ Мишель Пфайффер'
							elseif actors and actors:match('Моника Беллуччи') then
							t[i].group = '👩‍‍ Моника Беллуччи'
							elseif actors and actors:match('Софи Марсо') then
							t[i].group = '👩‍‍ Софи Марсо'
							elseif actors and actors:match('Вупи Голдберг') then
							t[i].group = '👩‍‍ Вупи Голдберг'
							elseif actors and actors:match('Риз Уизерспун') then
							t[i].group = '👩‍‍ Риз Уизерспун'
							elseif actors and actors:match('Барбра Стрейзанд') then
							t[i].group = '👩‍‍ Барбра Стрейзанд'
							elseif actors and actors:match('Милла Йовович') then
							t[i].group = '👩‍‍ Милла Йовович'
							elseif actors and actors:match('Дженнифер Лопес') then
							t[i].group = '👩‍‍ Дженнифер Лопес'
							elseif actors and actors:match('Кейт Бекинсейл') then
							t[i].group = '👩‍‍ Кейт Бекинсейл'
							elseif actors and actors:match('Джессика Альба') then
							t[i].group = '👩‍‍ Джессика Альба'
							end
-- Киноциклы
							if name:match('Гарри Поттер') or name:match('Фантастические твари')
							then t[i].group = '📽 Гарри Поттер'
							end
							if name:match('Властелин колец') or name:match('Хоббит')
							then t[i].group = '📽 Властелин колец ⚜ Хоббит'
							end
							if name:match('Звёздные войны') and genrestmp ~= 'цикл передач' and t[i].child == '0' or
							name:match('Звёздные Войны') and genrestmp ~= 'цикл передач' and t[i].child == '0'
							then t[i].group = '📽 Звёздные войны'
							end
							if name:match('Люди Икс') or name:match('Росомаха') or name:match('Дэдпул') or name:match('Логан') and not name:match('Удача Логана')
							then t[i].group = '📽 Люди Икс'
							end
-- Вселенная Marvel
							if name:match('Железный человек')
                            or name:match('Невероятный Халк')
                            or name:match('Железный человек 2')
--                            or name:match('Тор')
                            or kinopId  == '258941'
                            or name:match('Первый мститель')
--                            or name:match('Мстители')
							or kinopId  == '263531'
                            or name:match('Железный человек 3')
                            or name:match('Тор 2: Царство тьмы')
                            or name:match('Первый мститель: Другая война')
                            or name:match('Стражи Галактики')
                            or name:match('Мстители: Эра Альтрона')
--                            or name:match('Человек-муравей')
							or kinopId  == '195496'
                            or name:match('Первый мститель: Противостояние')
                            or name:match('Доктор Стрэндж')
                            or name:match('Стражи Галактики. Часть 2')
 --                           or name:match('Человек-паук: Возвращение домой')
							or kinopId  == '690593'
                            or name:match('Тор: Рагнарёк')
                            or name:match('Чёрная Пантера')
                            or name:match('Мстители: Война бесконечности')
--                            or name:match('Человек-муравей и Оса')
							or kinopId  == '935940'
                            or name:match('Капитан Марвел')
                            or name:match('Мстители: Финал')
                            or name:match('Человек-паук: Вдали от дома')
							or kinopId  == '1008445'
							then t[i].group = '📽 Вселенная Marvel'

							end
-- Советский блок
                    if country and country:match('СССР') and (t[i].child == '1' or genres:match('мультфильм')) then
					t[i].group = '🟥 Советские мультфильмы'
					end
					if country and country:match('СССР') and t[i].child == '0' and not genres:match('мультфильм') then
					t[i].group = '🟥 Советский кинематограф'
					end
-- Бондиана
							if kinopId  == '17483' or
							   kinopId  == '17482' or
							   kinopId  == '8192' or
							   kinopId  == '10365' or
							   kinopId  == '14557' or
							   kinopId  == '5309' or
							   kinopId  == '22243' or
							   kinopId  == '17479' or
							   kinopId  == '8872' or
							   kinopId  == '5674' or
							   kinopId  == '8167' or
							   kinopId  == '8166' or
							   kinopId  == '8171' or
							   kinopId  == '8173' or
							   kinopId  == '7282' or
							   kinopId  == '6915' or
							   kinopId  == '5609' or
							   kinopId  == '5970' or
							   kinopId  == '3556' or
							   kinopId  == '8141' or
							   kinopId  == '6585' or
							   kinopId  == '651' or
							   kinopId  == '49844' or
							   kinopId  == '258475' or
							   kinopId  == '408871' or
							   kinopId  == '678552'
							then t[i].group = '📽 Бондиана'
							end

					    if director and director:match('Павел Лунгин') then	t[i].group = '📹 Павел Лунгин' end
						if director and director:match('Роман Каримов') then	t[i].group = '📹 Роман Каримов' end
						if director and director:match('Гай Ричи') then	t[i].group = '📹 Гай Ричи' end
						if director and director:match('Альфред Хичкок') then	t[i].group = '📹 Альфред Хичкок' end
						if director and director:match('Стивен Спилберг') then	t[i].group = '📹 Стивен Спилберг' end
						if director and director:match('Мартин Скорсезе') then	t[i].group = '📹 Мартин Скорсезе' end
						if director and director:match('Квентин Тарантино') then	t[i].group = '📹 Квентин Тарантино' end
						if director and director:match('Кристофер Нолан') then	t[i].group = '📹 Кристофер Нолан' end
						if director and director:match('Вуди Аллен') then	t[i].group = '📹 Вуди Аллен' end
						if director and director:match('Дэвид Финчер') then	t[i].group = '📹 Дэвид Финчер' end

						if genres_title:match('топ') then
						t[i].group = '🏆 Топ просмотра'
						end
						if genres_title:match('4K') or name:match(' 4K') then
						t[i].group = '📹 4K'
						end
						if genres_title:match('новинки') then
						t[i].group = '🆕 ' .. t[i].group
						end
						if genres and genres:match('романтические') then
						t[i].group = '🏆 Топ романтических'
						end

                    t[i].group_logo = '../Channel/Logo/banners/MK/' .. t[i].group:gsub('🆕 ', ''):gsub('🇮🇳 ', ''):gsub('🇫🇷 ', ''):gsub('🇬🇧 ', ''):gsub('🇷🇺 ', ''):gsub('🇨🇳 ', ''):gsub('🇨🇦 ', '') .. '.png'
                    t[i].group_is_unique = 1
					t[i].name = name:gsub(' SD$',''):gsub(' HD$','') .. ' (' .. year .. ')'
					i = i + 1
				end
			m_simpleTV.OSD.ShowMessageT({text = 'UPload: in (' .. j .. ') out (' .. i .. ')' ,0xFF00,3})
				j = j + 1
			end
m_simpleTV.OSD.ShowMessageT({text = 'One moment please ...' ,0xFF00,3})
			if i == 1 then return end
		local hash, tab = {}, {}
			for i = 1, #t do
				if not hash[t[i].address]
				then
					tab[#tab + 1] = t[i]
					hash[t[i].address] = true
				end
			end

			if #tab == 0 then return end

-- Формирование названий а также ссылок на контент и лого
			for i = 1, #tab do
				if tab[i].logo then
					tab[i].logo = 'http://sdp.svc.iptv.rt.ru:8080/images/' .. tab[i].logo
				end
			end
	 return tab
	end
	function GetList(UpdateID, m3u_file)
			if m_simpleTV.Common.GetVlcVersion() < 3000 then return end
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite()
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'})
			 return
			end
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then
			 return nil
			end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')