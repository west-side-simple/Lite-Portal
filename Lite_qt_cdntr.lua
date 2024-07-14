--videocdn portal - lite version west_side 23.03.2024
--author west_side
----[[

local function Get_tr_for_content(content_type,kinopoisk_id,imdb_id,title)
	if content_type == 'movie' then content_type = 'movies' end
	if content_type == 'anime' then content_type = 'animes' end
	local embed
	if kinopoisk_id and kinopoisk_id ~= '' and kinopoisk_id ~= 0 then
		embed = '&field=kinopoisk_id&query=' .. kinopoisk_id
	elseif imdb_id and imdb_id ~= '' then
		embed = '&field=imdb_id&query=' .. imdb_id
	elseif title then
		embed = '&field=title&query=' .. title:gsub(' %(.-$','')
	else
		return false
	end
	local url = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkv') .. content_type:gsub('_','-') .. decode64('P2FwaV90b2tlbj10TmprWmdjOTdibWk5ajVJeTZxWnlzbXA5UmRtdkhtaA==') .. embed

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
--	debug_in_file(url .. '\n' .. answer .. '\n','c://1/url_answ.txt')
	if rc ~= 200 then return false end
	answer = unescape3(answer)
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
--	debug_in_file(url .. '\n' .. answer .. '\n','c://1/url_answ.txt')
	local tab = json.decode(answer)
	if not tab or not tab.data or not tab.data[1] then
		return false
	end
	local t,i = {},1
	while true do
		if not tab.data[1].media or not tab.data[1].media[i] or not tab.data[1].media[i].translation then
			break
		end
		t[i] = {}
		t[i].Tr = tab.data[1].media[i].translation.id
		t[i].Name = (tab.data[1].media[i].translation.title or 'озвучка')
		t[i].Max_Res = tab.data[1].media[i].max_quality .. 'P'
		t[i].Source_Type = tab.data[1].media[i].source_quality
--		debug_in_file(t[i].Source_Type .. '\n','c://1/source.txt')
		i = i + 1
	end
	while true do
		if not tab.data[1].translations or not tab.data[1].translations[i] or not tab.data[1].translations[i].max_quality then
			break
		end
		t[i] = {}
		t[i].Tr = tab.data[1].translations[i].id
		t[i].Name = (tab.data[1].translations[i].title or 'озвучка')
		t[i].Max_Res = tab.data[1].translations[i].max_quality .. 'P'
		t[i].Source_Type = tab.data[1].translations[i].source_quality
--		debug_in_file(t[i].Source_Type .. '\n','c://1/source.txt')
		i = i + 1
	end
	local hash, t0 = {}, {}
	for i = 1, #t do
		if not hash[t[i].Tr]
		then
			t0[#t0 + 1] = t[i]
			hash[t[i].Tr] = true
		end
	end
	return t0
end

local function get_logo_yandex(kp_id)
	local url = 'https://st.kp.yandex.net/images/film_big/' .. kp_id .. '.jpg'
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		return false
	end
	m_simpleTV.Http.SetTimeout(session, 3000)
	m_simpleTV.Http.SetTLSProtocol(session, 'TLS1_2')
	m_simpleTV.Http.EnableLocalCache(session)
	local rc,answer = m_simpleTV.Http.Request(session,{url=url, writeinfile = true})
	m_simpleTV.Http.Close(session)
	return answer
end

local function test_KP()
	local t0 = os.clock()
	local t1
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then
		m_simpleTV.Http.Close(session)
		return false
	end
	m_simpleTV.Http.SetTimeout(session, 1000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = decode64(
'aHR0cHM6Ly96c29scjMuem9uYXNlYXJjaC5jb20vc29sci9tb3ZpZS9zZWxlY3QvP3d0PWpzb24mZmw9eWVhcixyYXRpbmdfa2lub3BvaXNrLHJhdGluZ19pbWRiLGRlc2NyaXB0aW9uLGdlbnJlX25hbWUsY291bnRyeSZxPWlkOg==') .. 600})
	if not answer or answer:match('"numFound":0') then
--	debug_in_file(rc .. ' ' .. os.clock() - t0 .. '\n' .. (answer or 'not') .. '\n','c://1/time.txt')
	m_simpleTV.Http.Close(session)
	return false end
	m_simpleTV.Http.Close(session)
--	debug_in_file(rc .. ' ' .. os.clock() - t0 .. '\n','c://1/time.txt')
	return true
end

local function Get_KP(kp_id,session)
	local url = decode64(
'aHR0cHM6Ly96c29scjMuem9uYXNlYXJjaC5jb20vc29sci9tb3ZpZS9zZWxlY3QvP3d0PWpzb24mZmw9eWVhcixyYXRpbmdfa2lub3BvaXNrLHJhdGluZ19pbWRiLGRlc2NyaXB0aW9uLGdlbnJlX25hbWUsY291bnRyeSZxPWlkOg==') .. kp_id
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return false end
	local year = answer:match('"year":(%d%d%d%d)')
	local genre = answer:match('"genre_name":"(.-)"')
	local country = answer:match('"country":"(.-)"')
	local rating_imdb = answer:match('"rating_imdb":(.-)%,')
	local rating_kp = answer:match('"rating_kinopoisk":(.-)%,')
	local desc = (answer:match('"description":"(.-)"') or ''):gsub('\\n\\n',' ')
	return year, genre, country, rating_imdb, rating_kp, desc
end

local function Get_Year_trubl(kp_id,session)
	local url = decode64('aHR0cHM6Ly9hcGl2Yi5pbmZvL2FwaS92aWRlb3MuanNvbj90b2tlbj01ZTJmZTRjNzBiYWZkOWE3NDE0YzRmMTcwZWUxYjE5MiZpZF9rcD0=') .. kp_id
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return '' end
	local year = answer:match('"year":(%d%d%d%d)')
	if year then
		return year
	end
	return ''
end

local function Get_Year_Poster_dubl(imdb_id,session)
	local url = decode64('aHR0cHM6Ly93d3cub21kYmFwaS5jb20vP2FwaWtleT02MzY0NjJiMCZpPQ==') .. imdb_id
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return '','','','' end
	local year, genre, country, poster = answer:match('"Year":"(%d%d%d%d).-"Genre":"(.-)".-"Country":"(.-)".-"Poster":"(.-)"')
	if year and poster then
		return year, genre, country, poster, ''
	end
	return '','','',''
end
--]]

	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end

	if not m_simpleTV.User.Videocdn then
		m_simpleTV.User.Videocdn = {}
	end

local function country_name(name, session)
	local url, title
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

local function Get_genre_movie_name(id)
	for i = 1,#m_simpleTV.User.TVPortal.stena.movie_genres do
		if m_simpleTV.User.TVPortal.stena.movie_genres[i].id == id then
			return m_simpleTV.User.TVPortal.stena.movie_genres[i].name
		end
	end
	return id
end

local function Get_genre_tv_name(id)
	for i = 1,#m_simpleTV.User.TVPortal.stena.tv_genres do
		if m_simpleTV.User.TVPortal.stena.tv_genres[i].id == id then
			return m_simpleTV.User.TVPortal.stena.tv_genres[i].name
		end
	end
	return id
end

local function Get_Year_Poster(imdb_id,session)
	if not m_simpleTV.User.TVPortal.stena then m_simpleTV.User.TVPortal.stena = {} end
	if not m_simpleTV.User.TVPortal.stena.movie_genres or not #m_simpleTV.User.TVPortal.stena.movie_genres or
	not m_simpleTV.User.TVPortal.stena.tv_genres or not #m_simpleTV.User.TVPortal.stena.tv_genres then
		genres_arr()
	end
	local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
	local rc5,answerd = m_simpleTV.Http.Request(session,{url=urld})
	if rc5~=200 then
	return '','','','','',''
	end
--	debug_in_file(urld .. '\n' .. answerd .. '\n---------\n','c://1/a.txt')
	require('json')
	answerd = answerd:gsub('(%[%])', '"nil"')
	local tab = json.decode(answerd)
	if not tab then return '','','','','','' end
	if not tab.movie_results and not tab.tv_results then return '','','','','','' end
	if not tab.movie_results[1] and not tab.tv_results[1] then return '','','','','','' end
	local year, poster, vod
	local genre, rating, desc = '', '', ''
	if tab.movie_results[1] then
		desc = tab.movie_results[1].overview or ''
		year = tab.movie_results[1].release_date or ''
		rating = tab.movie_results[1].vote_average or 0
		if year and year ~= '' then
			year = year:match('%d%d%d%d')
		end
		if tab.movie_results[1].backdrop_path and tab.movie_results[1].backdrop_path ~= 'null' then
			vod = tab.movie_results[1].backdrop_path
			vod = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. vod
		else
			vod = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB goriz v1.png'
		end
		if tab.movie_results[1].poster_path and tab.movie_results[1].poster_path ~= 'null' then
			poster = tab.movie_results[1].poster_path
			poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
		else
			poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB vert v2.png'
		end
		if tab.movie_results[1].genre_ids and tab.movie_results[1].genre_ids[1] then
			local j = 1
			while true do
				if not tab.movie_results[1].genre_ids[j] then
					break
				end
				genre = genre .. Get_genre_movie_name(tab.movie_results[1].genre_ids[j]) .. ', '
				j = j + 1
			end
			genre = genre:gsub('%, $','')
		end
	elseif tab.tv_results[1] then
		desc = (tab.tv_results[1].overview or ''):gsub('\\n\\n',' ')
		year = tab.tv_results[1].first_air_date or ''
		rating = tab.tv_results[1].vote_average or 0
		if year and year ~= '' then
			year = year:match('%d%d%d%d')
		end
		if tab.tv_results[1].backdrop_path and tab.tv_results[1].backdrop_path ~= 'null' then
			vod = tab.tv_results[1].backdrop_path
			vod = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. vod
		else
			vod = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB goriz v1.png'
		end
		if tab.tv_results[1].poster_path and tab.tv_results[1].poster_path ~= 'null' then
			poster = tab.tv_results[1].poster_path
			poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
		else
			poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_TMDB vert v2.png'
		end
		if tab.tv_results[1].genre_ids and tab.tv_results[1].genre_ids[1] then
			local j = 1
			while true do
				if not tab.tv_results[1].genre_ids[j] then
					break
				end
				genre = genre .. Get_genre_tv_name(tab.tv_results[1].genre_ids[j]) .. ', '
				j = j + 1
			end
			genre = genre:gsub('%, $','')
		end
	end
	return year, genre, rating, poster, desc, vod
end

local function title_translate(translate)
	if translate == '' then return 'Все озвучки' end
	require 'lfs'
	local rc, answer, name_translate
	local url = 'aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHJhbnNsYXRpb25zP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbQ=='
	local t,i,page = {},1,1
	local str = ''
	local filePath = m_simpleTV.MainScriptDir .. 'user/westSidePortal/core/db_tr.txt' -- DB translations
	local fhandle = io.open(filePath, 'r')
	if not fhandle then
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 16000)
		for page = 1,23 do
			rc, answer = m_simpleTV.Http.Request(session, {url = decode64(url) .. '&page=' .. page .. '&limit=100'})
			require('json')
			if not answer then return end
			answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
			local tab = json.decode(answer)
			local j = 1
			if not tab or not tab.data or not tab.data[1] then return end
			while true do
			if not tab.data[j] then break end
				t[i]={}
				t[i].Id = i
				t[i].Name = unescape3(tab.data[j].short_title)
				t[i].Action = tab.data[j].id
				t[i].InfoPanelTitle = unescape3(tab.data[j].title)
				if tonumber(t[i].Action) == tonumber(translate) then name_translate = unescape3(t[i].InfoPanelTitle) end
				str = str .. '\n/' .. t[i].Action .. '/' .. t[i].Name .. '/' .. t[i].InfoPanelTitle .. '/'
				i = i + 1
				j = j + 1
			end
			page = page + 1
		end
		m_simpleTV.Http.Close(session)
		fhandle = io.open(filePath, 'w+')
		if fhandle then
			fhandle:write(str)
			fhandle:close()
		end
	else
		fhandle = io.open(filePath, 'r')
		answer = fhandle:read('*a')
		fhandle:close()
		for w in answer:gmatch('/.-/\n') do
			t[i]={}
			t[i].Id = i
			t[i].Name = w:match('/.-/(.-)/')
			t[i].Action = w:match('/(.-)/')
			t[i].InfoPanelTitle = w:match('/.-/.-/(.-)/')
			if tonumber(t[i].Action) == tonumber(translate) then name_translate = unescape3(t[i].InfoPanelTitle) end
			i = i + 1
		end
		return name_translate or 'Озвучка'
	end
end

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

local function get_item_quantity(url,session)
	local search_ini = getConfigVal('search/media') or ''
	local url = url .. search_ini
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	if rc ~= 200 then return 0 end
	return answer:match('"total_count":(%d+)') or 0
end

local function get_quantity_for_search()
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101 Firefox/96.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)

	local tt = {
	decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvbW92aWVzP2FwaV90b2tlbj10TmprWmdjOTdibWk5ajVJeTZxWnlzbXA5UmRtdkhtaCZwYWdlPTEmbGltaXQ9MTAmZmllbGQ9dGl0bGUmcXVlcnk9'),
	decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHYtc2VyaWVzP2FwaV90b2tlbj10TmprWmdjOTdibWk5ajVJeTZxWnlzbXA5UmRtdkhtaCZwYWdlPTEmbGltaXQ9MTAmZmllbGQ9dGl0bGUmcXVlcnk9'),
	decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvYW5pbWVzP2FwaV90b2tlbj10TmprWmdjOTdibWk5ajVJeTZxWnlzbXA5UmRtdkhtaCZwYWdlPTEmbGltaXQ9MTAmZmllbGQ9dGl0bGUmcXVlcnk9'),
	decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvYW5pbWUtdHYtc2VyaWVzP2FwaV90b2tlbj10TmprWmdjOTdibWk5ajVJeTZxWnlzbXA5UmRtdkhtaCZwYWdlPTEmbGltaXQ9MTAmZmllbGQ9dGl0bGUmcXVlcnk9'),
	decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvdy10di1zZXJpZXM/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJnBhZ2U9MSZsaW1pdD0xMCZmaWVsZD10aXRsZSZxdWVyeT0='),
	}
	if m_simpleTV.User.Videocdn.search == nil then m_simpleTV.User.Videocdn.search = {} end
	for i = 1,5 do
		m_simpleTV.User.Videocdn.search[i] = get_item_quantity(tt[i],session)
	end
end

function run_lite_qt_cdntr()

	local t = {}
	t[1] = {}
	t[1].Id = 1
	t[1].Name = 'Контент'

	t[2] = {}
	t[2].Id = 2
	t[2].Name = 'Озвучка'

	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
	local act
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Videocdn',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if id == 1 then
			type_cdntr('')
			elseif id == 2 then
			run_lite_qt_cdntr_ozv()
			end
		end
		if ret == 2 then
		  run_westSide_portal()
		end
end

function run_lite_qt_cdntr_ozv()
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.Videocdn then
		m_simpleTV.User.Videocdn = {}
	end
	require 'lfs'
	local tt0 = os.time()
	local rc, answer
	local url = 'aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHJhbnNsYXRpb25zP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbQ=='
	local t,i,page,current_id = {},1,1,1
	local str = ''
	local filePath = m_simpleTV.MainScriptDir .. 'user/westSidePortal/core/db_tr.txt' -- DB translations
	local fhandle = io.open(filePath, 'r')
	if not fhandle then
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 16000)
		for page = 1,23 do
			rc, answer = m_simpleTV.Http.Request(session, {url = decode64(url) .. '&page=' .. page .. '&limit=100'})
			require('json')
			if not answer then return end
			answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
			local tab = json.decode(answer)
			local j = 1
			if not tab or not tab.data or not tab.data[1] then return end
			while true do
			if not tab.data[j] then break end
				t[i]={}
--				t[i].Id = i
				t[i].Name = unescape3(tab.data[j].short_title)
				t[i].Action = tab.data[j].id
--				t[i].InfoPanelName = 'Перевод'
				t[i].InfoPanelTitle = unescape3(tab.data[j].title)
				t[i].InfoPanelLogo = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/VideoCDN.png'
--				if m_simpleTV.User.Videocdn.translate and tonumber(t[i].Action) == tonumber(m_simpleTV.User.Videocdn.translate) then current_id = i end
--				str = str .. '\n/' .. t[i].Action .. '/' .. t[i].Name .. '/' .. t[i].InfoPanelTitle .. '/'
				i = i + 1
				j = j + 1
			end
			page = page + 1
		end
		m_simpleTV.Http.Close(session)
		local hash, t0 = {}, {}
		for i = 1, #t do
			if not hash[t[i].Action]
			then
				t0[#t0 + 1] = t[i]
				hash[t[i].Action] = true
			end
		end
		table.sort(t0, function(a, b) return tonumber(a.Action) < tonumber(b.Action) end)
		local tt1 = os.time()
		m_simpleTV.Database.ExecuteSql("ATTACH DATABASE '" .. m_simpleTV.Common.GetMainPath(1) .. "/mediaportal.db' AS mediaportal;", false)
		m_simpleTV.Database.ExecuteSql("CREATE TABLE IF NOT EXISTS mediaportal.dubbing (ID INTEGER NOT NULL, ShortName TEXT NOT NULL, FullName TEXT NOT NULL);", false)
		m_simpleTV.Database.ExecuteSql('START TRANSACTION;/*dubbing*/')
		for i = 1, #t0 do
			t0[i].Id = i
			str = str .. '/' .. t0[i].Action .. '/' .. t0[i].Name .. '/' .. t0[i].InfoPanelTitle .. '/\n'
			m_simpleTV.Database.ExecuteSql("INSERT  INTO dubbing (ID, ShortName, FullName) VALUES ('" .. t0[i].Action .. "','" .. t0[i].Name:gsub("'",'´') .. "','" .. t0[i].InfoPanelTitle:gsub("'",'´') .. "');", true)
--			t0[i].Name = t0[i].Name
--			t0[i].Action = t0[i].Action
--			t0[i].InfoPanelName = 'Перевод'
--			t0[i].InfoPanelTitle = unescape3(tab.data[j].title)
--			t0[i].InfoPanelLogo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png'
		end
		m_simpleTV.Database.ExecuteSql('COMMIT;/*dubbing*/')
		local tt2 = os.time()
--		debug_in_file(tt1-tt0 .. ' / ' .. tt2-tt1 .. '\n',m_simpleTV.MainScriptDir .. 'user/westSidePortal/cdn.txt')
		fhandle = io.open(filePath, 'w+')
		if fhandle then
			fhandle:write(str)
			fhandle:close()
		end
		return run_lite_qt_cdntr_ozv()
	else
		fhandle = io.open(filePath, 'r')
		answer = fhandle:read('*a')
		fhandle:close()
			t[1]={}
			t[1].Id = 1
			t[1].Name = 'Все озвучки'
			t[1].Action = ''
			t[1].InfoPanelName = 'Все озвучки'
			t[1].InfoPanelTitle = 'Все озвучки'
			t[1].InfoPanelLogo = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/VideoCDN.png'
			i = 2
		for w in answer:gmatch('/.-/\n') do
			t[i]={}
			t[i].Id = i
			t[i].Name = w:match('/.-/(.-)/')
			t[i].Action = '&translation=' .. w:match('/(.-)/')
			t[i].InfoPanelName = 'Озвучка: ' .. t[i].Action
			t[i].InfoPanelTitle = w:match('/.-/.-/(.-)/')
			t[i].InfoPanelLogo = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/pause/VideoCDN.png'
--			if m_simpleTV.User.Videocdn.translate and t[i].Action:match('%d+') and tonumber(t[i].Action:match('(%d+)')) == tonumber(m_simpleTV.User.Videocdn.translate) then current_id = i end
			i = i + 1
		end
	end

	t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}

	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Videocdn озвучка: ' .. #t,tonumber(current_id)-1,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.Videocdn.translate = t[id].Action
			type_cdntr(t[id].Action)
		end
		if ret == 2 then
		  run_lite_qt_cdntr()
		end
end

function type_cdntr(url)

	local tt1={
	{'Фильмы','aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvbW92aWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbSZwYWdlPTEmbGltaXQ9MTAmZGlyZWN0aW9uPWRlc2M=','movie'},
	{'Сериалы','aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHYtc2VyaWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbSZwYWdlPTEmbGltaXQ9MTAmZGlyZWN0aW9uPWRlc2M=','tv'},
	{'Аниме','aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvYW5pbWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbSZwYWdlPTEmbGltaXQ9MTAmZGlyZWN0aW9uPWRlc2M=','anime'},
	{'Аниме сериалы','aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvYW5pbWUtdHYtc2VyaWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbSZwYWdlPTEmbGltaXQ9MTAmZGlyZWN0aW9uPWRlc2M=','anime_tv'},
	{'ТВ Шоу','aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvdy10di1zZXJpZXM/YXBpX3Rva2VuPW9TN1d6dk5meGU0SzhPY3NQanBBSVU2WHUwMVNpMGZtJnBhZ2U9MSZsaW1pdD0xMCZkaXJlY3Rpb249ZGVzYw==','tv_show'},
	}

	if stena_videocdn then
		m_simpleTV.User.Videocdn.type_name = tt1[1][1]
		m_simpleTV.User.Videocdn.type = tt1[1][3]
--		debug_in_file(decode64(tt1[1][2]) .. url .. '\n',m_simpleTV.MainScriptDir .. 'user/westSide/answer.txt')
		return page_cdntr(decode64(tt1[1][2]) .. url)
	end

  local t1={}
  for i=1,#tt1 do
    t1[i] = {}
    t1[i].Id = i
    t1[i].Name = tt1[i][1]
	t1[i].Name1 = tt1[i][3]
	t1[i].Action = decode64(tt1[i][2]) .. url
  end
  t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
  local title
  if url ~= '' then
	title = title_translate(url:gsub('%&translation=','')):gsub('%) %(',', '):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'):gsub('голосый','-'):gsub(' закадровый','закадр.'):gsub(' дублирование',' дуб.')
  else
	title = 'VideoCDN контент'
  end
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title,0,t1,9000,1+4+8)
  if ret == -1 or not id then
	return
  end
  if ret==1 then
	m_simpleTV.User.Videocdn.type_name = t1[id].Name
	m_simpleTV.User.Videocdn.type = t1[id].Name1
    page_cdntr(t1[id].Action)
  end
  if ret==2 then
    run_lite_qt_cdntr()
  end
end

function page_cdntr(url)

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
--		t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/m/green/m%0.png"'
		t.imagepath = 'type="dir" count="10" delay="120" src="' .. m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/m/blue/m%0.png"'
		t.minresx=-1
		t.minresy=-1
		t.align = 0x0101
		t.left=120
		t.top=100
		t.transparency = 192
		t.zorder=2
	AddElement(t,'ID_DIV_STENA_2')

	local current_id = url:match('%&translation=(%d+)') or m_simpleTV.User.Videocdn.translate or ''
	m_simpleTV.User.Videocdn.cur_translate = current_id
	local current_tr = title_translate(current_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
--	debug_in_file(rc .. ': ' .. current_id .. '\n' .. unescape3(answer) .. '\n',m_simpleTV.MainScriptDir .. 'user/westSide/cdn.txt')
		if rc ~= 200 then
			if stena_videocdn then
				m_simpleTV.User.Videocdn.stena = {}
				m_simpleTV.User.Videocdn.stena_next = nil
				m_simpleTV.User.Videocdn.stena_title = m_simpleTV.User.Videocdn.type_name .. ' (стр. 1 из 1) ' .. current_tr:gsub('%) %(',', '):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'):gsub('голосый','-'):gsub(' закадровый','закадр.'):gsub(' дублирование',' дуб.')
				stena_videocdn()
			else
				type_cdntr('&translation=' .. current_id)
			end
			return
		end
	local is_KP = test_KP()
	m_simpleTV.User.Videocdn.stena = {}
	m_simpleTV.User.Videocdn.stena.Trans_Title = nil
-----------------
	require('json')
--	debug_in_file(url .. '\n' .. unescape3(answer) .. '\n','c://1/cdn_timing.txt')
	answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	local current = tab.current_page
	local last = tab.last_page
	if not tab or not tab.data or not tab.data[1]
	then
	run_lite_qt_cdntr()
	return end
	local t,i = {},1
	while true do
	if not tab.data[i] then break end
	local year, genre, rating, desc, country, trans_title, index = '','','','','',{},1
	local year_baze
	local poster, vod
	if tab.data[i].year and tab.data[i].year:match('%d%d%d%d') and tonumber(tab.data[i].year:match('%d%d%d%d'))~=1969 then year_baze = tab.data[i].year:match('%d%d%d%d') end -- bug
		t[i]={}
		t[i].Id = i
		t[i].imdb_id = tab.data[i].imdb_id or ''
		t[i].kp_id = tab.data[i].kinopoisk_id or ''
		t[i].content = tab.data[i].content_type
		local str = ''
		if current_id ~= '' then
			t[i].Action = 'https:' .. tab.data[i].iframe_src .. '?translation=' .. current_id
			if tab.data[i].media and tab.data[i].media[1] and tab.data[i].media[1].max_quality then
				str = current_tr .. ' - ' .. tab.data[i].media[1].max_quality .. 'p'
			elseif tab.data[i].translations and tab.data[i].translations[1] and tab.data[i].translations[1].max_quality then
				str = current_tr .. ' - ' .. tab.data[i].translations[1].max_quality .. 'p'
			end
		else
			t[i].Action = 'https:' .. tab.data[i].iframe_src
			local j = 1

			while true do
				if not tab.data[i].media or not tab.data[i].media[j] or not tab.data[i].media[j].translation then break end
				str = str .. ' / ' .. unescape3((tab.data[i].media[j].translation.title or 'озвучка')) .. ' - ' .. tab.data[i].media[j].max_quality .. 'p'
				j = j + 1
			end
			while true do
				if not tab.data[i].translations or not tab.data[i].translations[j] or not tab.data[i].translations[j].max_quality then break end
				str = str .. ' / ' .. unescape3((tab.data[i].translations[j].title or 'озвучка')) .. ' - ' .. tab.data[i].translations[j].max_quality .. 'p'
				j = j + 1
			end
		end
		t[i].Trans_Title = str:gsub('^ / ',''):gsub('%) %(',', '):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'):gsub('голосый','-'):gsub(' закадровый','закадр.'):gsub(' дублирование',' дуб.')

----[[
		if t[i].imdb_id ~= '' then
			year, genre, rating, poster, desc, vod = Get_Year_Poster(t[i].imdb_id,session)
			if genre and genre ~= '' and genre ~= 'N/A' then
				genre = ' ● ' .. genre
			else
				genre = ''
			end
			if rating and rating ~= '' then
				t[i].ret_tmdb = rating
				rating = ' TMDB: ' .. rating
			else
				rating = ''
			end
--[[			if current_id ~= '' then
				t[i].InfoPanelTitle = desc
			end--]]
		end
		if not year or year == '' and year_baze and year_baze ~= '' then
			year = year_baze
		end
		if t[i].kp_id ~= '' and t[i].kp_id ~= 0 and is_KP == true then
		local year_kp, genre_kp, country_kp, rating_imdb, rating_kp, desc_kp = Get_KP(t[i].kp_id,session)
		t[i].ret_imdb = rating_imdb or 0
		t[i].ret_kp = rating_kp or 0
			if year_kp then year = year_kp end
			if genre_kp then genre = ' ● ' .. genre_kp end
			if rating_kp and rating_imdb then rating = ' KP: ' .. rating_kp .. ' IMDb: ' .. rating_imdb .. rating end
			if country_kp then country = ' ● ' .. country_kp end
			if desc_kp then desc = desc_kp end
		end--]]
		if rating ~= '' then
			rating = ' ●' .. rating
		end
		if not year or year == '' then
			year = Get_Year_trubl(t[i].kp_id,session)
		end
		if year and year == 0 then
			year = ''
		end
		if year and year ~= '' then
			year = ' (' .. year .. ')'
		end
--]]

--[[
		if (not poster or poster == 'N/A' or poster == '') and t[i].kp_id and t[i].kp_id ~= 0 then
			poster = get_logo_yandex(t[i].kp_id)
		end	--]]

		if (not vod or vod == '') then
			vod = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_vCDN goriz v4.png'
		end
		if (not poster or poster == '') then
			poster = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/Zaglushka_vCDN vert v2.png'
		end

		t[i].Name = unescape3(tab.data[i].ru_title) .. year
		t[i].InfoPanelLogo = vod:gsub('%._V1_SX300%.','._V1_QL75_UX144_CR0,1,144,213_.')
		t[i].Logo = poster:gsub('%._V1_SX300%.','._V1_QL75_UX144_CR0,1,144,213_.')
		t[i].InfoPanelName = unescape3(tab.data[i].ru_title) .. ' / ' .. unescape3(tab.data[i].orig_title) .. year .. rating .. genre .. country
		t[i].kinopoisk_id = tab.data[i].kinopoisk_id or ''
		if t[i].kinopoisk_id == 0 then t[i].kinopoisk_id = '' end
		t[i].InfoPanelTitle = desc or ''
		t[i].Reting = rating
--		debug_in_file(os.clock() .. ': ' .. t[i].Name .. ' imdb:' .. t[i].imdb_id .. ' kp:' .. t[i].kinopoisk_id .. '\n' .. t[i].InfoPanelLogo .. '\n','c://1/cdn_timing.txt')
		i = i + 1
	end
		m_simpleTV.User.Videocdn.stena = t

		local prev_pg, next_pg
		local title = ' (стр. ' .. current .. ' из ' .. last .. ') '
		local title1
		local search_ini = m_simpleTV.Common.fromPercentEncoding(getConfigVal('search/media') or '')
		if m_simpleTV.User.Videocdn.type:match('search') then
			title1 = 'поиск: ' .. search_ini
		else
			title1 = current_tr:gsub('%) %(',', '):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'):gsub('голосый','-'):gsub(' закадровый','закадр.')
		end
		if tonumber(current) < tonumber(last) then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		m_simpleTV.User.Videocdn.stena_next = url .. '&page=' .. tonumber(current)+1
		else
		m_simpleTV.User.Videocdn.stena_next = nil
		end
		if tonumber(current) > 1 then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ''}
		m_simpleTV.User.Videocdn.stena_prev = url .. '&page=' .. tonumber(current)-1
		else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
		m_simpleTV.User.Videocdn.stena_prev = nil
		end
		m_simpleTV.User.Videocdn.stena_title = m_simpleTV.User.Videocdn.type_name .. title .. title1
		m_simpleTV.User.Videocdn.stena_page = {last, url}
		if stena_videocdn then return stena_videocdn() end

		local prev_pg, next_pg
		if tonumber(current) > 1 then
		prev_pg = '&page=' .. tonumber(current) - 1
		end
		if tonumber(current) < tonumber(last) then
		next_pg = '&page=' .. tonumber(current) + 1
		end
		if next_pg then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg then
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
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(m_simpleTV.User.Videocdn.type .. ' (стр. '.. current .. ' из ' .. last .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.CurrentTitle_UTF8 = t[id].InfoPanelName
			m_simpleTV.Control.SetTitle(t[id].InfoPanelName)
			retAdr = t[id].Action .. '&embed=' .. t[id].kinopoisk_id .. ',' .. t[id].imdb_id
--			debug_in_file(t[id].InfoPanelName .. ', ' .. retAdr .. '\n',m_simpleTV.MainScriptDir .. 'user/westSidePortal/retAdr.txt')
			m_simpleTV.Control.ChangeAddress = 'No'
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.PlayAddressT({address = retAdr, title = t[id].InfoPanelName})
		end
		if ret == 2 then
		if prev_pg then
		  page_cdntr(url .. prev_pg)
		else
		  run_lite_qt_cdntr()
		end
		end
		if ret == 3 then
		  page_cdntr(url .. next_pg)
		end
end

function search_videocdn()
	get_quantity_for_search()
	page_movie_search_cdntr()
end

function get_info_for_item(id_cur)
	local id = id_cur:match('(%d+)')
	local t, AddElement = {}, m_simpleTV.OSD.AddElement
	local t1 = m_simpleTV.User.Videocdn.stena
		if m_simpleTV.User.Videocdn.cur_content_adr == nil or
			t1[tonumber(id)].Address ~= m_simpleTV.User.Videocdn.cur_content_adr then
			m_simpleTV.User.Videocdn.cur_content_adr = t1[tonumber(id)].Address
				local logo
				if t1[tonumber(id)].kinopoisk_id and t1[tonumber(id)].kinopoisk_id ~= '' and t1[tonumber(id)].Logo:match('/show_mi/') then
					logo = get_logo_yandex(t1[tonumber(id)].kinopoisk_id)
				end
--				debug_in_file((logo or 'NOT') .. ' | ' .. (t1[tonumber(id)].Logo or 'NOT') .. '\n','c://1/tst.txt')
				t = {}
				t.id = 'STENA_VIDEOCDN_CONTENT_IMG_ID'
				t.cx=320
				t.cy=480
				t.class="IMAGE"

				t.imagepath = logo or t1[tonumber(id)].Logo
				t.minresx=-1
				t.minresy=-1
				t.align = 0x0101
				t.left = 120
			    t.top  = 340
				t.transparency = 200
				t.zorder=2
				t.borderwidth = 3
				t.bordercolor = -6250336
				t.backroundcorner = 3*3
				t.borderround = 3
				AddElement(t,'ID_DIV_STENA_2')

				t = {}
				t.id = 'STENA_VIDEOCDN_CONTENT_TITUL_TXT_ID'
				t.cx=1200
				t.cy=0
				t.class="TEXT"
				t.text = t1[tonumber(id)].Name:gsub('\\"','"')
				t.color = ARGB(255 ,192, 255, 192)
				t.font_height = -16 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
--				t.boundWidth = 1000
--				t.row_limit=4
				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 490
			    t.top  = 330
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')

				t = {}
				t.id = 'STENA_VIDEOCDN_CONTENT_TXT_ID'
				t.cx=600
				t.cy=0
				t.class="TEXT"
				t.text = t1[tonumber(id)].InfoPanelName:gsub(' ●','\n ●'):gsub('.-/ ',''):gsub(' %(.-%)',''):gsub('\\"','"') .. '\n\n\n\n'
				t.color = ARGB(255 ,192, 192, 255)
				t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
--				t.boundWidth = 1000
				t.row_limit=4
--				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 490
			    t.top  = 390
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')

				t = {}
				t.id = 'STENA_VIDEOCDN_CONTENT_TXT1_ID'
				t.cx=600
				t.cy=0
				t.class="TEXT"
				t.text = t1[tonumber(id)].InfoPanelTitle:gsub('\\"','"') .. '\n\n\n\n\n\n\n\n\n'
				t.color = ARGB(255 ,192, 192, 192)
				t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5
				t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5
				t.font_name = "Segoe UI Black"
				t.textparam = 0x00000020
--				t.boundWidth = 1000
				t.row_limit=8
				t.text_elidemode = 2
				t.glow = 2 -- коэффициент glow эффекта
				t.glowcolor = 0xFF000077 -- цвет glow эффекта
				t.align = 0x0101
				t.left = 490
			    t.top  = 545
				t.transparency = 200
				t.zorder=2
				AddElement(t,'ID_DIV_STENA_2')

				m_simpleTV.OSD.RemoveElement('STENA_VIDEOCDN_CONTENT_TXT2_ID')
				for j = 1,25 do
					m_simpleTV.OSD.RemoveElement('STENA_VIDEOCDN_CONTENT_TXT2_' .. j .. '_ID')
					m_simpleTV.OSD.RemoveElement('STENA_VIDEOCDN_CONTENT_TXT3_' .. j .. '_ID')
					m_simpleTV.OSD.RemoveElement('STENA_VIDEOCDN_CONTENT_AUDIO_CODAC_' .. j .. '_ID')
					m_simpleTV.OSD.RemoveElement('STENA_VIDEOCDN_CONTENT_AUDIO_RES_' .. j .. '_ID')
					m_simpleTV.OSD.RemoveElement('STENA_VIDEOCDN_CONTENT_VIDEO_CODAC_' .. j .. '_ID')
					m_simpleTV.OSD.RemoveElement('STENA_VIDEOCDN_CONTENT_VIDEO_RES_' .. j .. '_ID')
					m_simpleTV.OSD.RemoveElement('STENA_VIDEOCDN_CONTENT_TYPE_VIDEO_' .. j .. '_ID')
				end

				local trans_title = Get_tr_for_content(t1[tonumber(id)].content,t1[tonumber(id)].kp_id,t1[tonumber(id)].imdb_id,t1[tonumber(id)].Name)

				local masshtab = 1
				if trans_title then

					if #trans_title > 14 then masshtab = 14 / #trans_title end
					for i = 1, #trans_title do
-----------------
						t = {}
						t.id = 'STENA_VIDEOCDN_CONTENT_TYPE_VIDEO_' .. i .. '_ID'
						t.cx= 48 * masshtab
						t.cy= 28 * masshtab
						t.class="IMAGE"
						if tonumber(trans_title[i].Tr) == tonumber(m_simpleTV.User.Videocdn.cur_translate) then
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/flagging/default/video/' .. trans_title[i].Source_Type:gsub('webdl','web-dl'):gsub('dvdrip','dvd'):gsub('bd','bluray'):gsub('tc','film'):gsub('ts','film'):gsub('tv','sdtv'):gsub('hdsd','hd'):gsub('sat','hdtv'):gsub('iptv','hdtv'):gsub('hdrip','hdtv') .. '.png'
						else
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/flagging/white/video/' .. trans_title[i].Source_Type:gsub('webdl','web-dl'):gsub('dvdrip','dvd'):gsub('bd','bluray'):gsub('tc','film'):gsub('ts','film'):gsub('tv','sdtv'):gsub('hdsd','hd'):gsub('sat','hdtv'):gsub('iptv','hdtv'):gsub('hdrip','hdtv') .. '.png'
						end
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0103
						t.left=737 * masshtab
						t.top=391 + ((i-1)*30) * masshtab
						t.transparency = 200
						t.zorder=0
						t.borderwidth = 0
						t.backroundcorner = 0*0
						t.borderround = 0
						AddElement(t,'ID_DIV_STENA_2')

						t = {}
						t.id = 'STENA_VIDEOCDN_CONTENT_AUDIO_CODAC_' .. i .. '_ID'
						t.cx= 35 * masshtab
						t.cy= 28 * masshtab
						t.class="IMAGE"
						if tonumber(trans_title[i].Tr) == tonumber(m_simpleTV.User.Videocdn.cur_translate) then
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/flagging/default/audio/aac.png'
						else
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/flagging/white/audio/aac.png'
						end
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0103
						t.left=700 * masshtab
						t.top=391 + ((i-1)*30) * masshtab
						t.transparency = 200
						t.zorder=0
						t.borderwidth = 0
						t.backroundcorner = 0*0
						t.borderround = 0
						AddElement(t,'ID_DIV_STENA_2')
						t = {}
						t.id = 'STENA_VIDEOCDN_CONTENT_AUDIO_RES_' .. i .. '_ID'
						t.cx= 35 * masshtab
						t.cy= 28 * masshtab
						t.class="IMAGE"
						if tonumber(trans_title[i].Tr) == tonumber(m_simpleTV.User.Videocdn.cur_translate) then
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/flagging/default/audio/2.png'
						else
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/flagging/white/audio/2.png'
						end
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0103
						t.left=665 * masshtab
						t.top=391 + ((i-1)*30) * masshtab
						t.transparency = 200
						t.zorder=0
						t.borderwidth = 0
						t.backroundcorner = 0*0
						t.borderround = 0
						AddElement(t,'ID_DIV_STENA_2')
-----------------
						t = {}
						t.id = 'STENA_VIDEOCDN_CONTENT_TXT2_' .. i .. '_ID'
						t.cx=520 * masshtab
						t.cy=0
						t.class="TEXT"
						t.text = trans_title[i].Name:gsub('%) %(',', '):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'):gsub('голосый','-'):gsub(' закадровый','закадр.'):gsub(' дублирование',' дуб.')
						if tonumber(trans_title[i].Tr) == tonumber(m_simpleTV.User.Videocdn.cur_translate) then
						t.color = ARGB(255 ,255, 192, 63)
						else
						t.color = ARGB(255 ,192, 192, 255)
						end
						t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5 * masshtab
						t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5 * masshtab
						t.font_name = "Segoe UI Black"
						t.textparam = 0x00000020
						t.text_elidemode = 2
						t.glow = 2 -- коэффициент glow эффекта
						t.glowcolor = 0xFF000077 -- цвет glow эффекта
						t.align = 0x0103
						t.left = 130 * masshtab
						t.top  = 390 + ((i-1)*30) * masshtab
						t.transparency = 200
						t.zorder=2
						AddElement(t,'ID_DIV_STENA_2')

						t = {}
						t.id = 'STENA_VIDEOCDN_CONTENT_TXT3_' .. i .. '_ID'
						t.cx=100 * masshtab
						t.cy=0
						t.class="TEXT"
						t.text = trans_title[i].Max_Res
						if tonumber(trans_title[i].Tr) == tonumber(m_simpleTV.User.Videocdn.cur_translate) then
						t.color = ARGB(255 ,255, 192, 63)
						else
						t.color = ARGB(255 ,192, 192, 255)
						end
						t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5 * masshtab
						t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5 * masshtab
						t.font_name = "Segoe UI Black"
						t.textparam = 0x00000020
						t.text_elidemode = 2
						t.glow = 2 -- коэффициент glow эффекта
						t.glowcolor = 0xFF000077 -- цвет glow эффекта
						t.align = 0x0103
						t.left = 20
						t.top  = 390 + ((i-1)*30) * masshtab
						t.transparency = 200
						t.zorder=2
--						AddElement(t,'ID_DIV_STENA_2')
-----------------
						t = {}
						t.id = 'STENA_VIDEOCDN_CONTENT_VIDEO_CODAC_' .. i .. '_ID'
						t.cx= 48 * masshtab
						t.cy= 28 * masshtab
						t.class="IMAGE"
						if tonumber(trans_title[i].Tr) == tonumber(m_simpleTV.User.Videocdn.cur_translate) then
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/flagging/default/video/h264.png'
						else
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/flagging/white/video/h264.png'
						end
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0103
						t.left=20 + 48 * masshtab
						t.top=391 + ((i-1)*30) * masshtab
						t.transparency = 200
						t.zorder=0
						t.borderwidth = 0
						t.backroundcorner = 0*0
						t.borderround = 0
						AddElement(t,'ID_DIV_STENA_2')
						t = {}
						t.id = 'STENA_VIDEOCDN_CONTENT_VIDEO_RES_' .. i .. '_ID'
						t.cx= 48 * masshtab
						t.cy= 28 * masshtab
						t.class="IMAGE"
						if tonumber(trans_title[i].Tr) == tonumber(m_simpleTV.User.Videocdn.cur_translate) then
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/flagging/default/video/' .. trans_title[i].Max_Res:gsub('P',''):gsub('360','240'):gsub('480','360') .. '.png'
						else
						t.imagepath = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/flagging/white/video/' .. trans_title[i].Max_Res:gsub('P',''):gsub('360','240'):gsub('480','360') .. '.png'
						end
						t.minresx=-1
						t.minresy=-1
						t.align = 0x0103
						t.left=20
						t.top=391 + ((i-1)*30) * masshtab
						t.transparency = 200
						t.zorder=0
						t.borderwidth = 0
						t.backroundcorner = 0*0
						t.borderround = 0
						AddElement(t,'ID_DIV_STENA_2')
-----------------
						i = i + 1
					end

				else
					t = {}
					t.id = 'STENA_VIDEOCDN_CONTENT_TXT2_ID'
					t.cx=750 * masshtab
					t.cy=0
					t.class="TEXT"
					t.text = t1[tonumber(id)].Trans_Title:gsub(' / ','\n'):gsub('360','240'):gsub('480','360') .. '\n\n\n\n\n\n\n\n\n'
					t.color = ARGB(255 ,255, 192, 63)
					t.font_height = -12 / m_simpleTV.Interface.GetScale()*1.5 * masshtab
					t.font_weight = 100 / m_simpleTV.Interface.GetScale()*1.5 * masshtab
					t.font_name = "Segoe UI Black"
					t.textparam = 0x00000020
	--				t.boundWidth = 1000
					t.row_limit=20
					t.text_elidemode = 2
					t.glow = 2 -- коэффициент glow эффекта
					t.glowcolor = 0xFF000077 -- цвет glow эффекта
					t.align = 0x0103
					t.left = 20
					t.top  = 390 * masshtab
					t.transparency = 200
					t.zorder=2
					AddElement(t,'ID_DIV_STENA_2')
				end
		end
end