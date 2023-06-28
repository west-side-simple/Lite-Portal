-- скрапер TVS для загрузки плейлиста киноаоиска "Фильмы" (26/06/23)
-- Copyright © 2017-2023 Nexterr | https://github.com/Nexterr/simpleTV
-- ## необходим ##
-- видоскрипт: kinopoisk.lua
-- ##
-- адаптация для версии с парсером по названию и году (west_side) 28.06.23 с огромной благодарностью автору))
-- ##
	module('films_kinopoisk_3_pls', package.seeall)
	local my_src_name = 'Фильмы 3 Кинопоиск'
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '..\\Channel\\logo\\Icons\\serials.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 0, RefreshButton = 0, AutoBuild = 0, show_progress = 1, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 0, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 3}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end
	local function showMess(str, color, showT)
		local t = {text = '🎞 ' .. str, color = color, showTime = showT or (1000 * 5), id = 'channelName'}
		m_simpleTV.OSD.ShowMessageT(t)
	end
	local function LoadFromSite()
		require 'json'
			local function round(str)
			 return string.format('%.' .. (1 or 0) .. 'f', str)
			end
			local function getReting(kpR, imdR)
				local kp, imd
				if kpR then
					kpR = tonumber(kpR)
				end
				if imdR then
					imdR = tonumber(imdR)
				end
				if kpR and kpR > 0 then
					kp = string.format('КП: %s', round(kpR))
				end
				if imdR and imdR > 0 then
					imd = string.format('IMDb: %s', round(imdR))
				end
					if not kp and not imd then
					 return ''
					end
				local slsh = ''
				if kp and imd then
					slsh = ' / '
				end
			 return string.format(' (%s%s%s)', kp or '', slsh, imd or '')
			end
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:85.0) Gecko/20100101 Firefox/85.0')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
		showMess('«Фильмы - 3» загрузка ...', ARGB(255, 153, 255, 153), 600000)
		local t, i = {}, 1
			local function getTbl(t, k, tab)
				local j = 1
					while tab.results[j] do
						local kinopoisk_id = tab.results[j].kinopoisk_id
						if kinopoisk_id then
							t[k] = {}

							t[k].logo = tab.results[j].info.poster
							local genres = tab.results[j].info.genre or ''
							local country = tab.results[j].info.country or ''
							local year = tab.results[j].info.year or 0
							local director = tab.results[j].info.director or ''
							local actors = tab.results[j].info.actors or ''
							local name = tab.results[j].info.rus:gsub('"', '%%22')
							t[k].group = '📽 🐶 Кино для всей семьи'
--genres
					if  genres and genres:match('семейный') and genres:match('мультфильм')
					then t[k].group = '📽 🧜‍ Мультфильмы для всей семьи'
					elseif genres and genres:match('семейный') and not genres:match('мультфильм')
					then t[k].group = '📽 🐶 Кино для всей семьи'
							end
					if genres and genres:match('комедия') then
							t[k].group = '🎥 🤡 Комедия'
							end
					if genres then genres = genres:gsub('мелодрама', 'genrestmp') end
					if genres and genres:match('драма') then
							t[k].group = '🎥 🎭 Драма'
							end
					if genres then genres = genres:gsub('genrestmp', 'мелодрама') end
					if genres and genres:match('триллер') then
							t[k].group = '🎥 👺 Триллер'
							end
					if genres and genres:match('приключения') then
							t[k].group = '🎥 🗺 Приключения'
							end
					if genres and genres:match('документальный') then
							t[k].group = '🎥 📹 Документальные'
							end
					if genres and genres:match('боевик') then
					        t[k].group = '🎥 💣 Боевик'
							end
					if genres and genres:match('мелодрама') then
							t[k].group = '🎥 💖 Мелодрама'
							end
					if genres and genres:match('ужасы') then
							t[k].group = '🎥 🧛 Ужасы'
							end
					if genres and genres:match('военный') then
							t[k].group = '🎥 🎖 Военный'
							end
					if genres and genres:match('детектив') then
							t[k].group = '🎥 🕵 Детектив'
							end
					if genres and genres:match('криминал') then
							t[k].group = '🎥 💰 Криминал'
							end
					if genres and genres:match('фантастика') then
							t[k].group = '🎥 👽 Фантастика'
							end
					if genres and genres:match('фэнтези') then
							t[k].group = '🎥 👻 Фэнтези'
							end
					if genres and genres:match('вестерн') then
							t[k].group = '🎥 🤠 Вестерн'
							end
					if genres and genres:match('история') then
							t[k].group = '🎥 📜 История'
							end
					if genres and genres:match('биография') then
							t[k].group = '🎥 📝 Биографические'
							end
					if genres and genres:match('спорт') then
					        t[k].group = '🎥 🏀 Спорт'
							end
					if genres and genres:match('мюзикл') then
							t[k].group = '🎥 🎶 Мюзикл'
							end
					if genres and genres:match('короткометражка') then
							t[k].group = '🎥 ⏳ Короткометражные'
							end
					if genres and (genres:match('кино для детей') or genres:match('детский')) then
							t[k].group = '📽 🤴 Кино для детей'
							end
					if genres and genres:match('мультфильм') and not genres:match('кино для детей') then
					        t[k].group = '📽 🧜 Мультфильмы'
							end
					if genres and genres:match('аниме') then
					        t[k].group = '🎥 🎎 Аниме'
							end
					if genres and genres:match('музыка') then
							t[k].group = '📺 🎼 Музыка'
							end
--country
					if country and country:match('Россия') then t[k].group = '🇷🇺 ' .. t[k].group
					elseif country and country:match('Китай') then t[k].group = '🇨🇳 ' .. t[k].group
					elseif country and country:match('Великобритания') then t[k].group = '🇬🇧 ' .. t[k].group
					elseif country and country:match('Франция') then t[k].group = '🇫🇷 ' .. t[k].group
					elseif country and country:match('Канада') then t[k].group = '🇨🇦 ' .. t[k].group
					elseif country and country:match('Индия') then t[k].group = '🇮🇳 ' .. t[k].group end
--persons
							if actors and actors:match('Том Хэнкс') then
							t[k].group = '👨‍ Том Хэнкс'
							elseif actors and actors:match('Николас Кейдж') then
							t[k].group = '👨‍ Николас Кейдж'
							elseif actors and actors:match('Клинт Иствуд') then
							t[k].group = '👨‍ Клинт Иствуд'
							elseif actors and actors:match('Джек Николсон') then
							t[k].group = '👨‍ Джек Николсон'
							elseif actors and actors:match('Джон Малкович') then
							t[k].group = '👨‍ Джон Малкович'
							elseif actors and actors:match('Джим Керри') then
							t[k].group = '👨‍ Джим Керри'
							elseif actors and actors:match('Аль Пачино') then
							t[k].group = '👨‍ Аль Пачино'
							elseif actors and actors:match('Киану Ривз') then
							t[k].group = '👨‍ Киану Ривз'
							elseif actors and actors:match('Дастин Хоффман') then
							t[k].group = '👨‍ Дастин Хоффман'
							elseif actors and actors:match('Джерард Батлер') then
							t[k].group = '👨‍ Джерард Батлер'
							elseif actors and actors:match('Бен Стиллер') then
							t[k].group = '👨‍ Бен Стиллер'
							elseif actors and actors:match('Брэдли Купер') then
							t[k].group = '👨‍ Брэдли Купер'
							elseif actors and actors:match('Морган Фриман') then
							t[k].group = '👨‍ Морган Фриман'
							elseif actors and actors:match('Леонардо ДиКаприо') then
							t[k].group = '👨‍ Леонардо ДиКаприо'
							elseif actors and actors:match('Роберт Де Ниро') then
							t[k].group = '👨‍ Роберт Де Ниро'
							elseif actors and actors:match('Мэл Гибсон') then
							t[k].group = '👨‍ Мэл Гибсон'
							elseif actors and actors:match('Брэд Питт') then
							t[k].group = '👨‍ Брэд Питт'
							elseif actors and actors:match('Том Круз') then
							t[k].group = '👨‍ Том Круз'
							elseif actors and actors:match('Джордж Клуни') then
							t[k].group = '👨‍ Джордж Клуни'
							elseif actors and actors:match('Джонни Депп') then
							t[k].group = '👨‍ Джонни Депп'
							elseif actors and actors:match('Стив Карелл') then
							t[k].group = '👨‍ Стив Карелл'
							elseif actors and actors:match('Энтони Хопкинс') then
							t[k].group = '👨‍ Энтони Хопкинс'
							elseif actors and actors:match('Арнольд Шварценеггер') then
							t[k].group = '👨‍ Арнольд Шварценеггер'
							elseif actors and actors:match('Сильвестр Сталлоне') then
							t[k].group = '👨‍ Сильвестр Сталлоне'
							elseif actors and actors:match('Вин Дизель') then
							t[k].group = '👨‍ Вин Дизель'
							elseif actors and actors:match('Бен Аффлек') then
							t[k].group = '👨‍ Бен Аффлек'
							elseif actors and actors:match('Брюс Уиллис') then
							t[k].group = '👨‍ Брюс Уиллис'
							elseif actors and actors:match('Кевин Костнер') then
							t[k].group = '👨‍ Кевин Костнер'
							elseif actors and actors:match('Мэтт Дэймон') then
							t[k].group = '👨‍ Мэтт Дэймон'
							elseif actors and actors:match('Дэниэл Крэйг') then
							t[k].group = '👨‍ Дэниэл Крэйг'
							elseif actors and actors:match('Майкл Дуглас') then
							t[k].group = '👨‍ Майкл Дуглас'
							elseif actors and actors:match('Ричард Гир') then
							t[k].group = '👨‍ Ричард Гир'
							elseif actors and actors:match('Хью Грант') then
							t[k].group = '👨‍ Хью Грант'
							elseif actors and actors:match('Алек Болдуин') then
							t[k].group = '👨‍ Алек Болдуин'
							elseif actors and actors:match('Харрисон Форд') then
							t[k].group = '👨‍ Харрисон Форд'
							elseif actors and actors:match('Эдди Мёрфи') then
							t[k].group = '👨‍ Эдди Мёрфи'
							elseif actors and actors:match('Робин Уильямс') then
							t[k].group = '👨‍ Робин Уильямс'
							elseif actors and actors:match('Джон Траволта') then
							t[k].group = '👨‍ Джон Траволта'
							elseif actors and actors:match('Антонио Бандерас') then
							t[k].group = '👨‍ Антонио Бандерас'
							elseif actors and actors:match('Курт Рассел') then
							t[k].group = '👨‍ Курт Рассел'
							elseif actors and actors:match('Рассел Кроу') then
							t[k].group = '👨‍ Рассел Кроу'
							elseif actors and actors:match('Роберт Дауни мл.') then
							t[k].group = '👨‍ Роберт Дауни мл.'
							elseif actors and actors:match('Кевин Спейси') then
							t[k].group = '👨‍ Кевин Спейси'
							elseif actors and actors:match('Джейсон Стэйтем') then
							t[k].group = '👨‍ Джейсон Стэйтем'
							elseif actors and actors:match('Джеймс Белуши') then
							t[k].group = '👨‍ Джеймс Белуши'
							elseif actors and actors:match('Эштон Кутчер') then
							t[k].group = '👨‍ Эштон Кутчер'
							elseif actors and actors:match('Майкл Шин') then
							t[k].group = '👨‍ Майкл Шин'
							elseif actors and actors:match('Кристиан Бэйл') then
							t[k].group = '👨‍ Кристиан Бэйл'
							elseif actors and actors:match('Бенедикт Камбербэтч') then
							t[k].group = '👨‍ Бенедикт Камбербэтч'
							elseif actors and actors:match('Итан Хоук') then
							t[k].group = '👨‍ Итан Хоук'
							elseif actors and actors:match('Билл Мюррей') then
							t[k].group = '👨‍ Билл Мюррей'
							elseif actors and actors:match('Том Харди') then
							t[k].group = '👨‍ Том Харди'
							elseif actors and actors:match('Ли Пейс') then
							t[k].group = '👨‍ Ли Пейс'
							elseif actors and actors:match('Джуд Лоу') then
							t[k].group = '👨‍ Джуд Лоу'
							elseif actors and actors:match('Микки Рурк') then
							t[k].group = '👨‍ Микки Рурк'
							elseif actors and actors:match('Орландо Блум') then
							t[k].group = '👨‍ Орландо Блум'
							elseif actors and actors:match('Мартин Фриман') then
							t[k].group = '👨‍ Мартин Фриман'
							elseif actors and actors:match('Крис Хемсворт') then
							t[k].group = '👨‍ Крис Хемсворт'
							elseif actors and actors:match('Эдвард Нортон') then
							t[k].group = '👨‍ Эдвард Нортон'
							elseif actors and actors:match('Хоакин Феникс') then
							t[k].group = '👨‍ Хоакин Феникс'
							elseif actors and actors:match('Шон Коннери') then
							t[k].group = '👨‍ Шон Коннери'
							elseif actors and actors:match('Пирс Броснан') then
							t[k].group = '👨‍ Пирс Броснан'
							elseif actors and actors:match('Колин Фёрт') then
							t[k].group = '👨‍ Колин Фёрт'
							elseif actors and actors:match('Адам Сэндлер') then
							t[k].group = '👨‍ Адам Сэндлер'
							elseif actors and actors:match('Жан Рено') then
							t[k].group = '👨‍ Жан Рено'
							elseif actors and actors:match('Джош Хартнетт') then
							t[k].group = '👨‍ Джош Хартнетт'
							elseif actors and actors:match('Жан-Клод Ван Дамм') then
							t[k].group = '👨‍ Жан-Клод Ван Дамм'
							elseif actors and actors:match('Уилл Смит') then
							t[k].group = '👨‍ Уилл Смит'
							elseif actors and actors:match('Алексей Серебряков') then
							t[k].group = '👨‍ Алексей Серебряков'
							elseif actors and actors:match('Константин Хабенский') then
							t[k].group = '👨‍ Константин Хабенский'
							elseif actors and actors:match('Владимир Машков') then
							t[k].group = '👨‍ Владимир Машков'
							elseif actors and actors:match('Сергей Гармаш') then
							t[k].group = '👨‍ Сергей Гармаш'
							elseif actors and actors:match('Алексей Чадов') then
							t[k].group = '👨‍ Алексей Чадов'
							elseif actors and actors:match('Евгений Сидихин') then
							t[k].group = '👨‍ Евгений Сидихин'
                            elseif actors and actors:match('Евгений Ткачук') then
							t[k].group = '👨‍ Евгений Ткачук'
							elseif actors and actors:match('Дайан Китон') then
							t[k].group = '👩‍‍ Дайан Китон'
							elseif actors and actors:match('Кэмерон Диаз') then
							t[k].group = '👩‍‍ Кэмерон Диаз'
							elseif actors and actors:match('Деми Мур') then
							t[k].group = '👩‍‍ Деми Мур'
							elseif actors and actors:match('Николь Кидман') then
							t[k].group = '👩‍‍ Николь Кидман'
							elseif actors and actors:match('Анджелина Джоли') then
							t[k].group = '👩‍‍ Анджелина Джоли'
							elseif actors and actors:match('Гвинет Пэлтроу') then
							t[k].group = '👩‍‍ Гвинет Пэлтроу'
							elseif actors and actors:match('Скарлетт Йоханссон') then
							t[k].group = '👩‍‍ Скарлетт Йоханссон'
							elseif actors and actors:match('Дрю Бэрримор') then
							t[k].group = '👩‍‍ Дрю Бэрримор'
							elseif actors and actors:match('Дженнифер Энистон') then
							t[k].group = '👩‍‍ Дженнифер Энистон'
							elseif actors and actors:match('Джулия Робертс') then
							t[k].group = '👩‍‍ Джулия Робертс'
							elseif actors and actors:match('Мэрил Стрип') then
							t[k].group = '👩‍‍ Мэрил Стрип'
							elseif actors and actors:match('Кейт Бланшетт') then
							t[k].group = '👩‍‍ Кейт Бланшетт'
                            elseif actors and actors:match('Мила Кунис') then
							t[k].group = '👩‍‍ Мила Кунис'
                            elseif actors and actors:match('Кира Найтли') then
							t[k].group = '👩‍‍ Кира Найтли'
                            elseif actors and actors:match('Ума Турман') then
							t[k].group = '👩‍‍ Ума Турман'
                            elseif actors and actors:match('Кэтрин Хайгл') then
							t[k].group = '👩‍‍ Кэтрин Хайгл'
							elseif actors and actors:match('Шэрон Стоун') then
							t[k].group = '👩‍‍ Шэрон Стоун'
							elseif actors and actors:match('Сандра Буллок') then
							t[k].group = '👩‍‍ Сандра Буллок'
							elseif actors and actors:match('Элизабет Бэнкс') then
							t[k].group = '👩‍‍ Элизабет Бэнкс'
							elseif actors and actors:match('Сигурни Уивер') then
							t[k].group = '👩‍‍ Сигурни Уивер'
							elseif actors and actors:match('Сара Джессика Паркер') then
							t[k].group = '👩‍‍ Сара Джессика Паркер'
							elseif actors and actors:match('Мег Райан') then
							t[k].group = '👩‍‍ Мег Райан'
							elseif actors and actors:match('Кейт Уинслет') then
							t[k].group = '👩‍‍ Кейт Уинслет'
							elseif actors and actors:match('Рене Зеллвегер') then
							t[k].group = '👩‍‍ Рене Зеллвегер'
							elseif actors and actors:match('Ким Бейсингер') then
							t[k].group = '👩‍‍ Ким Бейсингер'
							elseif actors and actors:match('Мишель Пфайффер') then
							t[k].group = '👩‍‍ Мишель Пфайффер'
							elseif actors and actors:match('Моника Беллуччи') then
							t[k].group = '👩‍‍ Моника Беллуччи'
							elseif actors and actors:match('Софи Марсо') then
							t[k].group = '👩‍‍ Софи Марсо'
							elseif actors and actors:match('Вупи Голдберг') then
							t[k].group = '👩‍‍ Вупи Голдберг'
							elseif actors and actors:match('Риз Уизерспун') then
							t[k].group = '👩‍‍ Риз Уизерспун'
							elseif actors and actors:match('Барбра Стрейзанд') then
							t[k].group = '👩‍‍ Барбра Стрейзанд'
							elseif actors and actors:match('Милла Йовович') then
							t[k].group = '👩‍‍ Милла Йовович'
							elseif actors and actors:match('Дженнифер Лопес') then
							t[k].group = '👩‍‍ Дженнифер Лопес'
							elseif actors and actors:match('Кейт Бекинсейл') then
							t[k].group = '👩‍‍ Кейт Бекинсейл'
							elseif actors and actors:match('Джессика Альба') then
							t[k].group = '👩‍‍ Джессика Альба'
							end
-- Киноциклы
							if name:match('Гарри Поттер') or name:match('Фантастические твари')
							then t[k].group = '📽 Вселенная Гарри Поттера'
							end
							if name:match('Властелин колец') or name:match('Хоббит')
							then t[k].group = '📽 Властелин колец ⚜ Хоббит'
							end
							if name:match('Звёздные войны')
							then t[k].group = '📽 Звёздные войны'
							end
							if name:match('Люди Икс') or name:match('Росомаха') or name:match('Дэдпул') or name:match('Логан') and not name:match('Удача Логана')
							then t[k].group = '📽 Люди Икс'
							end
-- Вселенная Marvel
							if name:match('Железный человек')
                            or name:match('Невероятный Халк')
                            or name:match('Железный человек 2')
                            or kinopoisk_id  == '258941'
                            or name:match('Первый мститель')
							or kinopoisk_id  == '263531'
                            or name:match('Железный человек 3')
                            or name:match('Тор 2%: Царство тьмы')
                            or name:match('Первый мститель%: Другая война')
                            or name:match('Стражи Галактики')
                            or name:match('Мстители: Эра Альтрона')
							or kinopoisk_id  == '195496'
                            or name:match('Первый мститель%: Противостояние')
                            or name:match('Доктор Стрэндж')
                            or name:match('Стражи Галактики%. Часть 2')
							or kinopoisk_id  == '690593'
                            or name:match('Тор%: Рагнарёк')
                            or name:match('Чёрная Пантера')
                            or name:match('Мстители%: Война бесконечности')
							or kinopoisk_id  == '935940'
                            or name:match('Капитан Марвел')
                            or name:match('Мстители%: Финал')
                            or name:match('Человек%-паук%: Вдали от дома')
							or kinopoisk_id  == '1008445'
							then t[k].group = '📽 Вселенная Marvel'
							end
-- Советский блок
                    if country and country:match('СССР') and genres:match('мультфильм') then
					t[k].group = '🟥 Советские мультфильмы'
					end
					if country and country:match('СССР') and not genres:match('мультфильм') then
					t[k].group = '🟥 Советский кинематограф'
					end

-- Бондиана
							if kinopoisk_id  == '17483' or
							   kinopoisk_id  == '17482' or
							   kinopoisk_id  == '8192' or
							   kinopoisk_id  == '10365' or
							   kinopoisk_id  == '14557' or
							   kinopoisk_id  == '5309' or
							   kinopoisk_id  == '22243' or
							   kinopoisk_id  == '17479' or
							   kinopoisk_id  == '8872' or
							   kinopoisk_id  == '5674' or
							   kinopoisk_id  == '8167' or
							   kinopoisk_id  == '8166' or
							   kinopoisk_id  == '8171' or
							   kinopoisk_id  == '8173' or
							   kinopoisk_id  == '7282' or
							   kinopoisk_id  == '6915' or
							   kinopoisk_id  == '5609' or
							   kinopoisk_id  == '5970' or
							   kinopoisk_id  == '3556' or
							   kinopoisk_id  == '8141' or
							   kinopoisk_id  == '6585' or
							   kinopoisk_id  == '651' or
							   kinopoisk_id  == '49844' or
							   kinopoisk_id  == '258475' or
							   kinopoisk_id  == '408871' or
							   kinopoisk_id  == '678552'
							then t[k].group = '📽 Бондиана'
							end
--director
						if director and director:match('Павел Лунгин') then	t[k].group = '📹 Павел Лунгин' end
						if director and director:match('Роман Каримов') then t[k].group = '📹 Роман Каримов' end
						if director and director:match('Гай Ричи') then	t[k].group = '📹 Гай Ричи' end
						if director and director:match('Альфред Хичкок') then t[k].group = '📹 Альфред Хичкок' end
						if director and director:match('Стивен Спилберг') then t[k].group = '📹 Стивен Спилберг' end
						if director and director:match('Мартин Скорсезе') then t[k].group = '📹 Мартин Скорсезе' end
						if director and director:match('Квентин Тарантино') then t[k].group = '📹 Квентин Тарантино' end
						if director and director:match('Кристофер Нолан') then t[k].group = '📹 Кристофер Нолан' end
						if director and director:match('Вуди Аллен') then t[k].group = '📹 Вуди Аллен' end
						if director and director:match('Дэвид Финчер') then	t[k].group = '📹 Дэвид Финчер' end

							t[k].group_logo = '../Channel/Logo/banners/MK/' .. t[k].group:gsub('🆕 ', ''):gsub('🇮🇳 ', ''):gsub('🇫🇷 ', ''):gsub('🇬🇧 ', ''):gsub('🇷🇺 ', ''):gsub('🇨🇳 ', ''):gsub('🇨🇦 ', '') .. '.png'
							t[k].group_is_unique = 1
							t[k].name = tab.results[j].info.rus:gsub('"', '%%22')
							t[k].name = t[k].name .. ' (' .. year .. ')'
							t[k].address = '**' ..  kinopoisk_id
							k = k + 1
						end
						j = j + 1
					end
			 return t, k
			end
			for c = 1, 1400 do
			if c==1 then t1=os.time() end
				local url = string.format(decode64('aHR0cHM6Ly9iYXpvbi5jYy9hcGkvanNvbi8/dG9rZW49NGY2YWRkZDUzMjdhY2RkNzY5NjljOTc3OTk1MzViMTQmdHlwZT1maWxtJnBhZ2U9JXM'), c)
				local rc, answer = m_simpleTV.Http.Request(session, {url = url})
				if rc == 200 and answer:match('"results"') then
					answer = answer:gsub('%[%]', '""')
					local tab = json.decode(answer)
					if tab and tab.results then
						t, i = getTbl(t, i, tab)
					end
				else
				t2=os.time()
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/poisk.png"', text = 'Время загрузки ' .. t2-t1 .. ' сек. Приятного просмотра', color = ARGB(255, 127, 63, 255), showTime = 1000 * 60})
				 break
				end
				m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/progress1/p' .. math.floor(c/500*100+0.5) .. '.png"', text = ' - общий прогресс загрузки: ' .. c, color = ARGB(255, 63, 63, 255), showTime = 1000 * 60})
			end
		m_simpleTV.Http.Close(session)
			if #t == 0 then return end
	 return t
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite()
			if not t_pls then
				showMess(Source.name .. ': ошибка загрузки плейлиста', ARGB(255, 255, 102, 0))
			 return
			end
		showMess(Source.name .. ' (' .. #t_pls .. ')', ARGB(255, 153, 255, 153))
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')
