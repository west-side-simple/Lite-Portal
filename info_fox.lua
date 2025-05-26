-- видеоскрипт для получения информации медиа по названию и году (19/02/25) - автор west_side

function info_fox(title,year,logo)
	if year == nil then return end
	local userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36"
	local session =  m_simpleTV.Http.New(userAgent)
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

		if m_simpleTV.User==nil then m_simpleTV.User={} end
		if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end
		if m_simpleTV.User.westSide==nil then m_simpleTV.User.westSide={} end

	local function xren(s)
		if not s then
			return ''
		end
		s = s:lower()
		s = s:gsub('*', '')
		s = s:gsub('%s+', ' ')
		s = s:gsub('^%s*(.-)%s*$', '%1')
		local a = {
				{'А', 'а'}, {'Б', 'б'}, {'В', 'в'}, {'Г', 'г'}, {'Д', 'д'}, {'Е', 'е'}, {'Ж', 'ж'}, {'З', 'з'},
				{'И', 'и'},	{'Й', 'й'}, {'К', 'к'}, {'Л', 'л'}, {'М', 'м'}, {'Н', 'н'}, {'О', 'о'}, {'П', 'п'},
				{'Р', 'р'}, {'С', 'с'},	{'Т', 'т'}, {'Ч', 'ч'}, {'Ш', 'ш'}, {'Щ', 'щ'}, {'Х', 'х'}, {'Э', 'э'},
				{'Ю', 'ю'}, {'Я', 'я'}, {'Ь', 'ь'},	{'Ъ', 'ъ'}, {'Ё', 'е'},	{'ё', 'е'}, {'Ф', 'ф'}, {'Ц', 'ц'},
				{'У', 'у'}, {'Ы', 'ы'}, {':', ''}
				}
		for _, v in pairs(a) do
			s = s:gsub(v[1], v[2])
		end
		return s
	end

	local function Get_person(tmdbid, tv)
		m_simpleTV.User.TVPortal.tmid = tmdbid
		m_simpleTV.User.TVPortal.tv = tv
		local urltm
		if tv == 0 then
			urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPWNyZWRpdHMmbGFuZ3VhZ2U9cnU=')
		elseif tv == 1 then
			urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPWNyZWRpdHMmbGFuZ3VhZ2U9cnU=')
		end

		local rc4,answertm = m_simpleTV.Http.Request(session,{url=urltm})
		if rc4~=200 then
		  m_simpleTV.Http.Close(session)
		  return
		end
		require('json')
		answertm = answertm:gsub('(%[%])', '"nil"')
		local tab = json.decode(answertm)

		local t1,j={},0
		if tab and tab.credits and tab.credits.crew and tab.credits.crew[1] and tab.credits.crew[1].id then
		local j1 = 1
			while true do
				if not tab.credits.crew[j1]	then
					break
				end
				if tab.credits.crew[j1].job and tab.credits.crew[j1].job == 'Director' then
					local rus1 = tab.credits.crew[j1].name or ''
					local cha1 = tab.credits.crew[j1].job or ''
					local id_person1 = tab.credits.crew[j1].id
					local poster1
					if tab.credits.crew[j1].profile_path and tab.credits.crew[j1].profile_path ~= 'null' and j <= 1 then
						j=j+1
						poster1 = tab.credits.crew[j1].profile_path
						poster1 = 'http://image.tmdb.org/t/p/w100_and_h100_face' .. poster1
						t1[j] = {}
						t1[j].Name = rus1
						t1[j].Id = j
						t1[j].InfoPanelLogo = poster1
						t1[j].InfoPanelName = rus1 .. ' - ' .. cha1
						t1[j].InfoPanelShowTime = 10000
						t1[j].Address = id_person1
					end
				end
				j1=j1+1
			end
		end

		if tab and tab.credits and tab.credits.cast and tab.credits.cast[1] and tab.credits.cast[1].id then
			local j2 = 1
			while true do
				if not tab.credits.cast[j2]	then
					break
				end
				local rus = tab.credits.cast[j2].name or ''
				local cha = tab.credits.cast[j2].character or ''
				local id_person = tab.credits.cast[j2].id
				local poster
				if tab.credits.cast[j2].profile_path and tab.credits.cast[j2].profile_path ~= 'null' and j <= 9 then
					j=j+1
					poster = tab.credits.cast[j2].profile_path
					poster = 'http://image.tmdb.org/t/p/w100_and_h100_face' .. poster
					t1[j] = {}
					t1[j].Name = rus
					t1[j].Id = j
					t1[j].InfoPanelLogo = poster
					t1[j].InfoPanelName = rus .. ' - ' .. cha
					t1[j].InfoPanelShowTime = 10000
					t1[j].Address = id_person
				end
				j2=j2+1
			end
		end
		if m_simpleTV.User.TVPortal.persons == nil then
			m_simpleTV.User.TVPortal.persons = {}
		end
--		debug_in_file('\n----- ' .. tmdbid ..', ' .. tv .. ' -----\n','c://1/person.txt')
		for j = 1,#t1 do
			m_simpleTV.User.TVPortal.persons[j] = {}
			m_simpleTV.User.TVPortal.persons[j].logo = t1[j].InfoPanelLogo
			m_simpleTV.User.TVPortal.persons[j].name = t1[j].Name
			m_simpleTV.User.TVPortal.persons[j].action = t1[j].Address
--			debug_in_file(t1[j].Id .. '. ' .. t1[j].Name .. ' ' .. m_simpleTV.User.TVPortal.persons[j] .. '\n','c://1/person.txt')
		end
		return t1
	end

	local function country_name(name)
		local url, title
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 60000)
		url = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy93YXRjaC9wcm92aWRlcnMvcmVnaW9ucz9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJV')
		local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc~=200 then
		return name
		end
		require('json')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
		local i = 1
		while true do
			if not tab.results[i] then
				break
			end
			local title = tab.results[i].iso_3166_1
			if title == name then
				return tab.results[i].native_name or tab.results[i].english_name or name
			end
			i=i+1
		end
		return name:gsub('SU','СССР')
	end

	local function promo_tm(tmid, tv)
		if not tmid then return end
		local urltm
		if tv == 0 then
			urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. tmid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ==')
		elseif tv == 1 then
			urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. tmid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ==')
		end
		local rc3,answertm = m_simpleTV.Http.Request(session,{url=urltm})
		if rc3~=200 then
			m_simpleTV.Http.Close(session)
			return
		end
		require('json')
		answertm = answertm:gsub('(%[%])', '"nil"')
		local tab, promo, genre, country, slogan = json.decode(answertm), '', '', '', ''
		if tab and tab.videos and tab.videos.results and tab.videos.results[1] and tab.videos.results[1].key then
			promo = tab.videos.results[1].key
			promo = 'https://www.youtube.com/watch?v=' .. promo
		else
			promo = ''
		end
		m_simpleTV.User.TVPortal.genres = nil
		m_simpleTV.User.TVPortal.genres = {}
		if tab and tab.genres then
		    local j = 1
			while true do
				if not tab.genres[j]
				then
					break
				end
				m_simpleTV.User.TVPortal.genres[j] = {}
				genre = genre .. tab.genres[j].name .. ', '
				m_simpleTV.User.TVPortal.genres[j].Name = tab.genres[j].name
				m_simpleTV.User.TVPortal.genres[j].Id = tab.genres[j].id
				m_simpleTV.User.TVPortal.genres[j].Type = tv
				j=j+1
			end
			genre = genre:gsub(', $', '')
		else
			genre = ''
		end

		if tab and tab.production_countries then
			local j = 1
			while true do
				if not tab.production_countries[j]
				then
					break
				end
				country = country .. country_name(tab.production_countries[j].iso_3166_1) .. ', '
				j=j+1
			end
			country = country:gsub(', $', '')
		else
			country = ''
		end

		if tab and tab.tagline then
			slogan = tab.tagline
		else
			slogan = ''
		end

		return promo, genre, country, slogan
	end

	local function bg_poster_title(title, year)

		local background, poster, overview, rating, count, ru_name, orig_name, promo, genre, country, slogan, tmid
		local urld = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&primary_release_year=' .. year
		local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
		if rc1~=200 then
			m_simpleTV.Http.Close(session)
			return
		end
		require('json')
		answerd = answerd:gsub('(%[%])', '"nil"')
		local tab = json.decode(answerd)
		local tv
		if title == 'Шерлок' then tab = nil end -- fix tv
		if title == 'Друзья' then tab = nil end -- fix tv
		if title:match('Бандитский Петербург') then tab = nil end -- fix tv
		if not tab or not tab.results[1] then
			local urld2 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&first_air_date_year=' .. year
			local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
			if rc2~=200 then
				m_simpleTV.Http.Close(session)
				return
			end
			tv = 1
			require('json')
			answerd2 = answerd2:gsub('(%[%])', '"nil"')

			local tab = json.decode(answerd2)
			if not tab or not tab.results[1] then
				background, poster, overview, rating, count, ru_name, orig_name, promo, genre, country, slogan, tmid, year_tmdb = '', '', '', '', '', '', '', '', '', '', '', '', ''
			else
				local i = 1
				while true do
					if not tab.results[i] then break end
					if tab.results[i].name and tab.results[i].name == title or tab.results[i].original_name and tab.results[i].original_name == title then
						if tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
							poster = tab.results[i].poster_path
							poster = 'http://image.tmdb.org/t/p/original' .. poster
						else
							poster = logo
						end

						if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
							background = tab.results[i].backdrop_path
							background = 'http://image.tmdb.org/t/p/original' .. background
						else
							background = poster
						end

						overview = tab.results[i].overview:gsub('\\"','"'):gsub('\n',' '):gsub('  ',' ')
						rating = tab.results[i].vote_average or 0
						count = tab.results[i].vote_count
						ru_name = tab.results[i].name
						orig_name = tab.results[i].original_name:gsub('u0026','&')
						tmid = tab.results[i].id
						year_tmdb = tab.results[i].first_air_date or ''
						if year_tmdb and year_tmdb ~= '' then
							year_tmdb = year_tmdb:match('%d%d%d%d')
						else
							year_tmdb = 0
						end
						break
					end
					i = i + 1
				end
			end
		else
			tv = 0
			local i = 1
			while true do
				if not tab.results[i] then break end
				if tab.results[i].title and tab.results[i].title == title or tab.results[i].original_title and tab.results[i].original_title == title then
					if tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
						poster = tab.results[i].poster_path
						poster = 'http://image.tmdb.org/t/p/original' .. poster
					else
						poster = logo
					end

					if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
						background = tab.results[i].backdrop_path
						background = 'http://image.tmdb.org/t/p/original' .. background
					else
						background = poster
					end

					overview = tab.results[i].overview:gsub('\\"','"'):gsub('\n',' '):gsub('  ',' ')
					rating = tab.results[i].vote_average or 0
					count = tab.results[i].vote_count
					ru_name = tab.results[i].title
					orig_name = tab.results[i].original_title:gsub('u0026','&')
					tmid = tab.results[i].id
					year_tmdb = tab.results[i].release_date or ''
					if year_tmdb and year_tmdb ~= '' then
						year_tmdb = year_tmdb:match('%d%d%d%d')
					else
						year_tmdb = 0
					end
					break
				end
				i = i + 1
			end
		end
		if not tmid then return end
		if not poster then poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB vert v2.png' end
		promo, genre, country, slogan = promo_tm(tmid, tv)
		m_simpleTV.User.TVPortal.logo = poster:gsub('original','w300_and_h450_bestv2')
		m_simpleTV.User.TVPortal.title = ru_name:gsub("'",'´')
		m_simpleTV.User.TVPortal.title_en = orig_name:gsub("'",'´')
		m_simpleTV.User.TVPortal.genre = genre or ''
		m_simpleTV.User.TVPortal.country = country or ''
		m_simpleTV.User.TVPortal.year = year_tmdb
		m_simpleTV.User.TVPortal.slogan = (slogan or ''):gsub("'",'´')
		m_simpleTV.User.TVPortal.ret_tmdb = rating
		
--		debug_in_file(m_simpleTV.User.TVPortal.title .. '\n' .. m_simpleTV.User.TVPortal.title_en .. '\n' .. m_simpleTV.User.TVPortal.genre .. '\n' .. m_simpleTV.User.TVPortal.country .. '\n' .. m_simpleTV.User.TVPortal.year .. '\n' .. m_simpleTV.User.TVPortal.slogan .. '\n' .. m_simpleTV.User.TVPortal.ret_tmdb .. '\n--------------\n','c://1/tst.txt')
		return background, poster, overview, rating, count, ru_name, orig_name, promo, genre, country, slogan, tmid, tv
	end

	local function tmdb_eng(title, year)
		local overview
		local urle = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1lbiZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&primary_release_year=' .. year
		local rc3,answere = m_simpleTV.Http.Request(session,{url=urle})
		if rc3~=200 then
			m_simpleTV.Http.Close(session)
			return ''
		end
		require('json')
		answere = answere:gsub('(%[%])', '"nil"')
		local tab = json.decode(answere)
		if not tab or not tab.results[1] or not tab.results[1].overview	then
			local urle2 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1lbiZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&first_air_date_year=' .. year
			local rc4,answere2 = m_simpleTV.Http.Request(session,{url=urle2})
			if rc4~=200 then
				m_simpleTV.Http.Close(session)
				return ''
			end
			require('json')
			answere2 = answere2:gsub('(%[%])', '"nil"')
			local tab = json.decode(answere2)
			if not tab or not tab.results[1] then
				overviewe = ''
			else
				overviewe = tab.results[1].overview
			end
		else
			overviewe = tab.results[1].overview
		end
		return overviewe
	end

	local function tmdb_id(imdb_id)
		local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
		local rc5,answerd = m_simpleTV.Http.Request(session,{url=urld})
		if rc5~=200 then
			m_simpleTV.Http.Close(session)
		return false
		end
		require('json')
		answerd = answerd:gsub('(%[%])', '"nil"')
		local tab = json.decode(answerd)
		local tmdb_id, tv, background, poster
		if not tab or
			(not tab.movie_results or tab.movie_results==nil) and
			(not tab.tv_results or tab.tv_results==nil) and
			(not tab.movie_results[1] or tab.movie_results[1]==nil) and
			(not tab.tv_results[1] or tab.tv_results[1]==nil) then
			return false
		end
		if tab.movie_results and tab.movie_results[1] then
			tmdb_id, tv = tab.movie_results[1].id, 0
			if tab.movie_results[1].poster_path and tab.movie_results[1].poster_path ~= 'null' then
				poster = tab.movie_results[1].poster_path
				poster = 'http://image.tmdb.org/t/p/original' .. poster
			else
				poster = logo
			end
			if tab.movie_results[1].backdrop_path and tab.movie_results[1].backdrop_path ~= 'null' then
				background = tab.movie_results[1].backdrop_path
				background = 'http://image.tmdb.org/t/p/original' .. background
			else
				background = poster
			end
			rating = tab.movie_results[1].vote_average or 0
			return tmdb_id, tv, background, poster, rating
		end
		if tab.tv_results and tab.tv_results[1] then
			tmdb_id, tv = tab.tv_results[1].id, 1
			if tab.tv_results[1].poster_path and tab.tv_results[1].poster_path ~= 'null' then
				poster = tab.tv_results[1].poster_path
				poster = 'http://image.tmdb.org/t/p/original' .. poster
			else
				poster = logo
			end
			if tab.tv_results[1].backdrop_path and tab.tv_results[1].backdrop_path ~= 'null' then
				background = tab.tv_results[1].backdrop_path
				background = 'http://image.tmdb.org/t/p/original' .. background
			else
				background = poster
			end
			rating = tab.tv_results[1].vote_average or 0
			return tmdb_id, tv, background, poster, rating
		end
		return false
	end

	local function get_country_flags(country_ID)
		local country_flag = '<img src="simpleTVImage:./luaScr/user/show_mi/country/' .. country_ID .. '.png" height="36" align="top">'
		return country_flag
	end

	local function get_country(country)
		local tmp_country_ID = ''
		local country_ID = ''
		if country and country:match('СССР') then tmp_country_ID = 'ussr' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Аргентина') then tmp_country_ID = 'ar' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Австрия') then tmp_country_ID = 'at' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Австралия') then tmp_country_ID = 'au' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Бельгия') then tmp_country_ID = 'be' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Бразилия') then tmp_country_ID = 'br' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Канада') then tmp_country_ID = 'ca' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Швейцария') then tmp_country_ID = 'ch' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Китай') then tmp_country_ID = 'cn' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Гонконг') then tmp_country_ID = 'hk' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Германия') then tmp_country_ID = 'de' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Дания') then tmp_country_ID = 'dk' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Испания') then tmp_country_ID = 'es' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Финляндия') then tmp_country_ID = 'fi' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Франция') then tmp_country_ID = 'fr' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Великобритания') then tmp_country_ID = 'gb' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Греция') then tmp_country_ID = 'gr' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Ирландия') then tmp_country_ID = 'ie' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Израиль') then tmp_country_ID = 'il' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Индия') then tmp_country_ID = 'in' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Исландия') then tmp_country_ID = 'is' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Италия') then tmp_country_ID = 'it' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Япония') then tmp_country_ID = 'jp' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Южная Корея') or country and country:match('Корея Южная') then tmp_country_ID = 'kr' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Мексика') then tmp_country_ID = 'mx' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Нидерланды') then tmp_country_ID = 'nl' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Норвегия') then tmp_country_ID = 'no' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Польша') then tmp_country_ID = 'pl' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Венгрия') then tmp_country_ID = 'hu' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Новая Зеландия') then tmp_country_ID = 'nz' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Португалия') then tmp_country_ID = 'pt' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Румыния') then tmp_country_ID = 'ro' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('ЮАР') then tmp_country_ID = 'rs' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Россия') then tmp_country_ID = 'ru' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Швеция') then tmp_country_ID = 'se' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Турция') then tmp_country_ID = 'tr' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('Украина') then tmp_country_ID = 'ua' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		if country and country:match('США') then tmp_country_ID = 'us' country_ID = get_country_flags(tmp_country_ID) .. country_ID end
		return country_ID or ''
	end

	local function imdbid(kp_id)
		local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJmtpbm9wb2lza19pZD0=') .. kp_id
		local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
			if rc5~=200 then
				return false
			end
			require('json')
			answer_vn = answer_vn:gsub('(%[%])', '"nil"')
			local tab_vn = json.decode(answer_vn)
			if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].imdb_id then
				return tab_vn.data[1].imdb_id
			end
		return false
	end

	local function get_alloha(title, year)

		local urlb = decode64('aHR0cHM6Ly9hcGkuYXBidWdhbGwub3JnLz90b2tlbj1kMzE3NDQxMzU5ZTUwNWMzNDNjMjA2M2VkYzk3ZTc=') .. '&name=' .. m_simpleTV.Common.toPercentEncoding(title) .. '&year=' .. year
		local rc,answer = m_simpleTV.Http.Request(session,{url=urlb})
--		debug_in_file(rc .. ':\n' .. unescape3(answer) .. '\n','c://1/testfox.txt')
		if rc~=200 then
			m_simpleTV.Http.Close(session)
			return
		end
		local background, poster, overview, rating, count, ru_name, orig_name, promo, genres, country, slogan, tmdbid, imdb_id
		require('json')
		answer = answer:gsub('%[%]', '"nil"'):gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/')
		local tab = json.decode(unescape3(answer))
		if tab and tab.data then
			local yearb = tab.data.year or year or ''
			local kpid = tab.data.id_kp

			imdb_id = tab.data.id_imdb
			if imdb_id then
				tmdbid, tv, background, poster, rating = tmdb_id(imdb_id)
			end
			if tmdbid and tv then
				promo, genres, country, slogan = promo_tm(tmdbid, tv)
				Get_person(tmdbid, tv)
			end
			local rus = (tab.data.name or ''):gsub('&nbsp;', ' '):gsub('&#151;', '-')
			local orig = (tab.data.original_name or ''):gsub('&nbsp;', ' '):gsub('&#151;', '-'):gsub('A Town Called Bastard', 'A Town Called Hell')
			local kpR, imdbR
			local reting = ''
			local kpR = math.floor(tonumber((tab.data.rating_kp or 0))*10)/10
			local imdbR = math.floor(tonumber((tab.data.rating_imdb or 0))*10)/10
			m_simpleTV.User.TVPortal.ret_KP = kpR
			m_simpleTV.User.TVPortal.ret_imdb = imdbR
			reting = '<h5><img src="simpleTVImage:./luaScr/user/show_mi/menuKP.png" height="36" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. kpR .. '.png" height="36" align="top"> ' .. kpR .. '</h5><h5><img src="simpleTVImage:./luaScr/user/show_mi/menuIMDb.png" height="36" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. imdbR .. '.png" height="36" align="top"> ' .. imdbR .. '</h5>'
			country = (tab.data.country or country or ''):gsub(', ', ','):gsub(',', ', ')
			local director = (tab.data.directors or ''):gsub(', ', ','):gsub(',', ', ')
			local actors = (tab.data.actors or ''):gsub(', ', ','):gsub(',', ', ')
			genres = (tab.data.genre or genres or ''):gsub(', ', ','):gsub(',', ', ')
			local description = (tab.data.description or overview or ''):gsub('&amp;#151;', ' – '):gsub('&#151;', ' - '):gsub('\\n', ' '):gsub('\\r', ' '):gsub('\n', ' '):gsub('&nbsp;', ' '):gsub('&laquo;', '«'):gsub('&raquo;', '»'):gsub('\r', ' ')
			slogan = tab.data.tagline or slogan or ''
			if slogan ~= '' then slogan = ' «' .. slogan .. '» ' end
			local age = tab.data.age_restrictions or 0
			m_simpleTV.User.TVPortal.age = ' ● ' .. age .. '+'
			local time_all = tab.data.time
			if time_all then
				m_simpleTV.User.TVPortal.time_all = ' ● ' .. time_all
			else
				m_simpleTV.User.TVPortal.time_all = ''
				time_all = 0
			end
			if promo and promo ~= '' then
				str_poisk = '<a href = "simpleTVLua:m_simpleTV.Control.PlayAddress(\'' .. promo .. '\')"><img src="simpleTVImage:./luaScr/user/show_mi/trailer.png" height="43"></a>'
			else
				str_poisk = ''
			end
			m_simpleTV.User.TVPortal.logo = poster
			m_simpleTV.User.TVPortal.title = rus:gsub("'",'´')
			m_simpleTV.User.TVPortal.title_en = orig:gsub("'",'´')
			m_simpleTV.User.TVPortal.genre = genres
			m_simpleTV.User.TVPortal.country = country
			m_simpleTV.User.TVPortal.year = yearb
			m_simpleTV.User.TVPortal.slogan = slogan:gsub("'",'´')
			m_simpleTV.User.TVPortal.ret_tmdb = rating
			country_ID = get_country(country)
			if orig == '' then orig = rus end
			videodesc = '<table width="100%" border="0"><tr><td style="padding: 15px 15px 5px;"><img src="' .. (poster or logo) .. '" height="450"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h4><font color=#00FA9A>' .. rus .. '</font></h4><h5><i><font color=#CCCCCC>' .. slogan .. '</font></i></h5><h4>' .. str_poisk .. '</h4><h5><font color=#BBBBBB>' .. orig .. '<h5><font color=#EBEBEB>' .. country_ID .. ' ' .. country .. ' </font><font color=#E0FFFF>' .. yearb .. '</font></h5><h5><font color=#EBEBEB>' .. genres .. '</font> • ' .. age .. '+</h5>' .. reting .. '<h5><font color=#E0FFFF>' .. time_all .. '</font></h5><h5>Режиссер: <font color=#EBEBEB>' .. director .. '</font><br>В ролях: <font color=#EBEBEB>' .. actors .. '</font></h5></td></tr></table><table width="100%"><tr><td style="padding: 5px 5px 5px;"><h5><font color=#EBEBEB>' .. description .. '</font></h5></td></tr></table>'
			local videodesc = videodesc:gsub('"', '\"')

			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.5" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/show_mi/menuKP1.png"', text = rus .. '\n' .. orig .. '\n' .. yearb .. '\n' .. country .. '\n' .. genres .. '\n\n\n\n\n\n', showTime = 5000,0xFF00,3})

			return videodesc, background, description
		end
		return false
	end

	local function Get_info(title, year)
		local delta = os.clock()
		if not title then return end
		local url = 'http://api.vokino.tv/v2/list?name=' .. title
		local token = decode64('d2luZG93c18zZWZlMGUyZDg5ZTQ3NzVhYWFjMTBiMGMxYjU0YTU3MF81OTIwMjE=')
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 10000)
		url = url .. '&token=' .. token
		local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc~=200 then
			m_simpleTV.Http.Close(session)
			return
		end
		require('json')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
			if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id or not tab.channels[1].details.name
		then
		return end
		m_simpleTV.Http.Close(session)
		local t, i = {}, 1
	--	debug_in_file('\n----------------------\n' .. title .. ' ' .. year .. '\n----------------------\n','d://info_test.txt')
		while true do
			if not tab.channels[i] or not tab.channels[i].details or not tab.channels[i].details.id then break end
			local id = tab.channels[i].details.id or ''
			local name = tab.channels[i].details.name
			local originalname = tab.channels[i].details.originalname
			local released = tab.channels[i].details.released
	--		debug_in_file(name .. ' / ' .. originalname .. ' ' .. released .. '\n','d://info_test.txt')
			if (name and name == title or originalname and originalname == title) and released and tonumber(released) == tonumber(year) then
--[[				if tab.channels[i].details.bg_poster and tab.channels[i].details.bg_poster.backdrop and m_simpleTV.Control.MainMode == 0 then
					m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = tab.channels[i].details.bg_poster.backdrop, TypeBackColor = 0, UseLogo = 3, Once = 1})
				end--]]
				local poster = tab.channels[i].details.poster or tab.channels[i].details.wide_poster or 'http://web.vokino.tv/img/icons/img-torrent-empty.svg'
				local country = tab.channels[i].details.country or ''
				local genre = tab.channels[i].details.genre or ''
				local about = tab.channels[i].details.about or ''
				local imdb_r = tab.channels[i].details.rating_imdb or 0
				local kp_r = tab.channels[i].details.rating_kp or 0
				local age = tab.channels[i].details.age or 0
				delta = os.clock() - delta
--				debug_in_file('\n~~~~~~~~~~~~~~~~~~~~~\nparser name+year: ' .. delta .. '\n~~~~~~~~~~~~~~~~~~~~~\n','c://1/timing.txt')
				m_simpleTV.User.TVPortal.ret_KP = kp_r
				m_simpleTV.User.TVPortal.ret_imdb = imdb_r
				local type = tab.channels[i].details.type
	--			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="3.5" src="' .. poster .. '"', text = country .. '\n' .. genre .. '\nIMDb: ' .. imdb_r .. ', KP: ' .. kp_r .. '\n' .. type .. '\n' .. released , showTime = 5000,0xFF00,3})
				return
			end
			i=i+1
		end
		return
	end

-----------------------------------
	local videodesc, background, description = get_alloha(title, year)
	if videodesc then
		m_simpleTV.User.TVPortal.overview = description
		return videodesc, background, description
	end--]]

	local background, poster, overview, rating, count, ru_name, orig_name, promo, genre, country, slogan, tmid, tv = bg_poster_title(title:gsub('Марвелы','Капитан Марвел 2'):gsub('о змеях и певчих птицах','о певчих птицах и змеях'), year)
	if tmid and tmid ~= '' then
		Get_person(tmid, tv)
	end
	Get_info(ru_name, year)
	if overview == '' and tmid ~= '' then
		overview = tmdb_eng(title, year)
	end
	m_simpleTV.User.TVPortal.overview = (overview or ''):gsub('\\"','"')
	if background and poster and poster ~= '' and genre and tmid ~= '' and country then
		if promo and promo ~= '' then
			str_poisk = '<a href = "simpleTVLua:m_simpleTV.Control.PlayAddress(\'' ..promo .. '\')"><img src="simpleTVImage:./luaScr/user/show_mi/trailer.png" height="43"></a>'
		else
			str_poisk = ''
		end
		videodesc= '<table width="100%"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="450"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h3><font color=#00FA9A>' .. ru_name .. '</font></h3><h5><i><font color=#CCCCCC>' .. slogan .. '</font></i></h5><h4>' .. str_poisk .. '</h4><h5><font color=#BBBBBB>' .. orig_name .. '</font></h5><h5><font color=#E0FFFF>' .. country .. ' ' .. year .. '</font></h5><h5><font color=#EBEBEB>' .. genre .. '</font></h5><h5><img src="simpleTVImage:./luaScr/user/show_mi/menuTM.png" height="36" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. (tonumber(rating)*10 - tonumber(rating)*10%1)/10 .. '.png" height="36" align="top"> ' .. rating .. ' (' .. count .. ')</h5><h5>' .. overview .. '</h5></td></tr></table>'
		videodesc = videodesc:gsub('"', '\"')
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.5" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/show_mi/menuTM1.png"', text = ru_name .. '\n' .. orig_name .. '\n' .. year_tmdb .. '\n' .. country .. '\n' .. genre .. '\n\n\n\n\n\n', showTime = 5000,0xFF00,3})
		return videodesc:gsub('\\"','"'), background, overview:gsub('\\"','"')
	else
		return '', '', ''
	end
end
