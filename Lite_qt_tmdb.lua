--TMDb portal - lite version west_side 21.07.22

local function findrutor(name, id)
	local session2 = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36', proxy, true)
		if not session2 then return '' end
	m_simpleTV.Http.SetTimeout(session2, 12000)
	local url_ru = 'http://rutor.info/search/0/0/000/0/' .. m_simpleTV.Common.toPercentEncoding(name)
	local rc_ru, answer_ru = m_simpleTV.Http.Request(session2, {url = url_ru})
	if rc_ru~=200 then
	return ''
	end

	local t, i, str_ru = {}, 1, ''
	answer_ru = answer_ru:gsub('\n','')
	answer_ru = answer_ru:match('<table width=".-</table>')
	if answer_ru then
	for w in answer_ru:gmatch('<tr class=".-</tr>') do
--	if w:match('BDR') then
	local adr, item, sids, pirs = w:match('<a href="(/torrent/.-)">(.-)<.-alt="S" />(.-)<.-class="red">(.-)<')
	if adr then adr = 'http://rutor.info' .. adr end
	if item and item:match('^(.-) /') and item:match('^(.-) /'):gsub('ё','е') == name:gsub('ё','е') or item and item:match('^(.-) %(') and item:match('^(.-) %('):gsub('ё','е') == name:gsub('ё','е') then
	str_ru = str_ru .. '<table width="100%"><tr><td width="' .. masshtab*150 .. '"><img src="simpleTVImage:./luaScr/user/westSide/icons/rutor.png" height = "' .. masshtab*30 .. '"></td><td style="padding: 15px 15px 5px;"><h5><a href = "simpleTVLua:m_simpleTV.Control.PlayAddress(\'' .. adr .. '&tmdb=' .. id .. '\')" style="color: #EBEBEB; text-decoration: none;">' .. item .. '</a></td><td width="' .. masshtab*100 .. '"> ✅ ' .. sids .. '<br> 🔻 ' .. pirs .. '</h5></td></tr></table><hr>'
	end
--	end
	i=i+1
	end
	end
	return str_ru
end

local function findrutracker(name, id)

	local ret, login, pass = pm.GetTestPassword('rutracker', 'rutracker', true)
		if not login or not pass or login == '' or password == '' then
	--		showError('2\в дополнении "Password Manager"\nвведите логин и пароль для rutracker')
		 return ''
		end
	m_simpleTV.Http.Close(session)
	local session1 = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36', proxy, true)
		if not session1 then return '' end
	m_simpleTV.Http.SetTimeout(session1, 12000)
	m_simpleTV.Http.SetRedirectAllow(session1, false)
	local url = 'https://rutracker.org/forum/login.php'
	login = m_simpleTV.Common.toPercentEncoding(login)
	pass = m_simpleTV.Common.toPercentEncoding(pass)

	local rc, answer = m_simpleTV.Http.Request(session1, {method = 'post', url = url, headers = '\nReferer: ' .. inAdr .. '\nContent-Type: application/x-www-form-urlencoded', body = 'login_username=' .. login .. '&login_password=' .. pass .. '&login=%E2%F5%EE%E4'})
		if rc ~= 302 then
			m_simpleTV.Http.Close(session1)
	--		showError('3\nперелогинтесь в браузере\nили пароль/логин неверны')
		 return ''
		end
	m_simpleTV.Http.SetRedirectAllow(session1, true)
	local url_rt = 'https://rutracker.org/forum/tracker.php?nm=' .. m_simpleTV.Common.toPercentEncoding(name)
	local rc_rt, answer_rt = m_simpleTV.Http.Request(session1, {url = url_rt})
	if rc_rt~=200 then
	return ''
	end

	local t, i, str_rt = {}, 1, ''
	answer_rt = m_simpleTV.Common.multiByteToUTF8(answer_rt)
	for w in answer_rt:gmatch('<tr id=".-</tr>') do
	if w:match('HD Video') then
	local adr, item, sids, pirs = w:match('class="med tLink ts%-text hl%-tags bold" href="(.-)">(.-)<.-<b class="seedmed">(%d+).-title="Личи">(%d+)<')
	if adr then adr = 'https://rutracker.org/forum/' .. adr end
	if item and item:match('^(.-) /') and item:match('^(.-) /'):gsub('ё','е') == name:gsub('ё','е') or item and item:match('^(.-) %(') and item:match('^(.-) %('):gsub('ё','е') == name:gsub('ё','е') then
	str_rt = str_rt .. '<table width="100%"><tr><td width="' .. masshtab*150 .. '"><img src="simpleTVImage:./luaScr/user/westSide/icons/rutracker.png" height = "' .. masshtab*30 .. '"></td><td style="padding: 15px 15px 5px;"><h5><a href = "simpleTVLua:m_simpleTV.Control.PlayAddress(\'' .. adr .. '&tmdb=' .. id .. '\')" style="color: #EBEBEB; text-decoration: none;">' .. item .. '</a></td><td width="' .. masshtab*100 .. '"> ✅ ' .. sids .. '<br> 🔻 ' .. pirs .. '</h5></td></tr></table><hr>'
	end
	end
	i=i+1
	end
	return str_rt
end

local function find_movie(title)
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
m_simpleTV.Http.SetTimeout(session, 60000)
local urld = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title)
local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
if rc1~=200 then
  m_simpleTV.Http.Close(session)
  return '',0
end
local total_pages,total_results = answerd:match('"total_pages":(%d+),"total_results":(%d+)')
local answer = ''
if tonumber(total_pages) == 0 then total_pages = 1 end
for j = 1,total_pages do
local urld = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&page=' .. j
local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
if rc1~=200 then
  m_simpleTV.Http.Close(session)
  return '',0
end
answer = answer .. answerd
j=j+1
end
require('json')
answer = answer:gsub('(%[%])', '"nil"'):gsub('%],"total_pages":%d+,"total_results":%d+%}%{"page":%d+,"results":%[', ',')
local tab = json.decode(answer)
local t, i, desc = {}, 1, ''
while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	local id_media = tab.results[i].id or ''
    local rus = tab.results[i].title or ''
	local year = tab.results[i].release_date or ''
	local overview = tab.results[i].overview or ''
	local poster
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end

	if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
	poster = tab.results[i].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. poster
	elseif tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
	poster = tab.results[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = './luaScr/user/show_mi/no-img.png'
	end

	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ') - movie'
	t[i].Address = id_media
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus .. ' (' .. year .. ')'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview

	i = i + 1
	end
	return t, i - 1
end

local function find_series(title)
local function infodesc_tmdb(id,tv)
local urltm, titul_tmdb_media, tmdb_media
if tv == 0 then
urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ=='):gsub('=ru','=ru')
titul_tmdb_media = titul_tmdb_movie
tmdb_media = 'tmdb_movie_page=1'
elseif tv == 1 then
urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ=='):gsub('=ru','=ru')
titul_tmdb_media = titul_tmdb_tv
tmdb_media = 'tmdb_tv_page=1'
end
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
m_simpleTV.Http.SetTimeout(session, 60000)
local rc3,answertm = m_simpleTV.Http.Request(session,{url=urltm})
if rc3~=200 then
  m_simpleTV.Http.Close(session)
  return
end
require('json')
answertm = answertm:gsub('(%[%])', '"nil"')
local tab, overview = json.decode(answertm), ''

	overview = tab.overview or ''

return overview
end
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
m_simpleTV.Http.SetTimeout(session, 60000)
local urld2 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title)
local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
if rc2~=200 then
  m_simpleTV.Http.Close(session)
  return '',0
end
local total_pages,total_results = answerd2:match('"total_pages":(%d+),"total_results":(%d+)')
local answer3 = ''
if tonumber(total_pages) == 0 then total_pages = 1 end
for j = 1,total_pages do
local urld3 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&page=' .. j
local rc3,answerd3 = m_simpleTV.Http.Request(session,{url=urld3})
if rc3~=200 then
  m_simpleTV.Http.Close(session)
  return '',0
end
answer3 = answer3 .. answerd3
j=j+1
end
require('json')
answer3 = answer3:gsub('(%[%])', '"nil"'):gsub('%],"total_pages":%d+,"total_results":%d+%}%{"page":%d+,"results":%[', ',')

local tab = json.decode(answer3)

local t, i, desc = {}, 1, ''
while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	local id_media = tab.results[i].id or ''
    local ru_name = tab.results[i].name or ''
	local year = tab.results[i].first_air_date or ''
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
	local overview = infodesc_tmdb(id_media,1)
	local poster
	if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
	poster = tab.results[i].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. poster
	elseif tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
	poster = tab.results[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = './luaScr/user/show_mi/no-img.png'
	end

	t[i].Id = i
	t[i].Name = ru_name .. ' (' .. year .. ') - tv'
	t[i].Address = id_media
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. ru_name .. ' (' .. year .. ')'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview

	i = i + 1
	end
	return t, i - 1
end

local function findpersonIdByName(person)
	local urlt = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvcGVyc29uP2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmcGFnZT0xJmluY2x1ZGVfYWR1bHQ9ZmFsc2UmcXVlcnk9') .. m_simpleTV.Common.toPercentEncoding(person)
	local id, name, logo
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local rc, answert = m_simpleTV.Http.Request(session, {url = urlt})
	if rc~=200 then
	return '',0
	end
	require('json')
	answert = answert:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert)

	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name
	then
	return '',0 end

	local t, i, desc = {}, 1, ''
	while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	rus = tab.results[i].name or ''

	id_person = tab.results[i].id
	department = tab.results[i].known_for_department or ''
	department = department:gsub('Acting','Актёрское искусство: '):gsub('Directing','Режиссура: '):gsub('Writing','Сценарист: '):gsub('Creating','Продюсер: ')
	if tab.results[i].profile_path and tab.results[i].profile_path ~= 'null' then
	poster = tab.results[i].profile_path
	poster = 'http://image.tmdb.org/t/p/w180_and_h180_face' .. poster
	else poster = './luaScr/user/show_mi/no-img.png'
	end

	if tab.results[i].known_for and tab.results[i].known_for ~= 'nil' and (tab.results[i].known_for[1].title or tab.results[i].known_for[1].name)then
	known_for = tab.results[i].known_for[1].title or tab.results[i].known_for[1].name
	if tab.results[i].known_for[2] and (tab.results[i].known_for[2].title or tab.results[i].known_for[2].name) then
	known_for = known_for .. ', ' .. (tab.results[i].known_for[2].title or tab.results[i].known_for[2].name)
	end
	if tab.results[i].known_for[3] and (tab.results[i].known_for[3].title or tab.results[i].known_for[3].name) then
	known_for = known_for .. ', ' .. (tab.results[i].known_for[3].title or tab.results[i].known_for[3].name)
	end
	else
	known_for = ''
	end

	t[i].Id = i
	t[i].Name = rus
	t[i].Address = id_person
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = department .. known_for
    i=i+1
	end
	return t, i - 1
end

local function find_collectons(title)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urlt = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvY29sbGVjdGlvbj9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJVJnBhZ2U9MSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title)
	local id, name, logo
	local rc, answert = m_simpleTV.Http.Request(session, {url = urlt})
	if rc~=200 then
	return  '',0
	end
	require('json')
	answert = answert:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert)

	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name
	then
	return '',0 end

	local t, i, desc = {}, 1, ''
	while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	rus = tab.results[i].name or ''

	id_collections = tab.results[i].id
	overview = tab.results[i].overview or ''
	if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
	poster = tab.results[i].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. poster
	elseif tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
	poster = tab.results[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = './luaScr/user/show_mi/no-img.png'
	end

	t[i].Id = i
	t[i].Name = rus
	t[i].Address = id_collections
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview
    i=i+1
	end
	return t, i - 1
end

local function vb_asw(imdb_id)
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urlv = 'https://voidboost.net/embed/' .. imdb_id
	local rcv,answerv = m_simpleTV.Http.Request(session,{url=urlv})
	if rcv~=200 then
	return ''
	end
	return urlv
end

local function kpid(imdbid)
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJmltZGJfaWQ9') .. imdbid
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})

		if rc5~=200 then
		return ''
		end
		require('json')
		answer_vn = answer_vn:gsub('(%[%])', '"nil"')
		local tab_vn = json.decode(answer_vn)

		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].kp_id then
		return tab_vn.data[1].kp_id
		elseif tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].imdb_id then
		return 'https://32.svetacdn.in/fnXOUDB9nNSO?imdb_id=' .. imdbid
		elseif vb_asw(imdbid) and vb_asw(imdbid) ~= '' then
		return vb_asw(imdbid)
		else
		return ''
		end
end

local function imdbid(tmdbtvid)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local url_im = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. tmdbtvid .. decode64('L2V4dGVybmFsX2lkcz9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJV')
	local rc6,answer_im = m_simpleTV.Http.Request(session,{url=url_im})

		if rc6~=200 then
		return ''
		end
		require('json')
		answer_im = answer_im:gsub('(%[%])', '"nil"')
		local tab_im = json.decode(answer_im)

		if tab_im and tab_im.imdb_id then
		return tab_im.imdb_id
		else
		return ''
		end
end

local function genres_name(tv,tmdb_genres_id)
	local url_g1, tmdb_media
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	if tv == 0 then
	url_g1 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9nZW5yZS9tb3ZpZS9saXN0P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlU=')
	tmdb_media = 'tmdb_movie_page=1'
	elseif tv == 1 then
	url_g1 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9nZW5yZS90di9saXN0P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlU=')
	tmdb_media = 'tmdb_tv_page=1'
	end
	local rc7,answer_g1 = m_simpleTV.Http.Request(session,{url=url_g1})
		if rc7~=200 then
		return ''
		end
		require('json')
		answer_g1 = answer_g1:gsub('(%[%])', '"nil"')
		local tab_g1 = json.decode(answer_g1)
		local t, i, name = {}, 1, ''
		while true do
		if not tab_g1.genres[i]
				then
				break
				end
		t[i]={}
		t[i].id = tab_g1.genres[i].id
		t[i].name = tab_g1.genres[i].name
		if tonumber(tmdb_genres_id) == tonumber(tab_g1.genres[i].id) then
		name = t[i].name
		end
		i=i+1
		end
	return name
end

local function tmdb_id(imdb_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
	local rc5,answerd = m_simpleTV.Http.Request(session,{url=urld})
	if rc5~=200 then
		m_simpleTV.Http.Close(session)
	return
	end
	require('json')
	answerd = answerd:gsub('(%[%])', '"nil"')
	local tab = json.decode(answerd)
	local tmdb_id, tv
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then tmdb_id, tv = '', '' else
	if tab.movie_results[1] then
	tmdb_id, tv = tab.movie_results[1].id, 0
	elseif tab.tv_results[1] then
	tmdb_id, tv = tab.tv_results[1].id, 1
	end
	end
	return tmdb_id, tv
end

function run_lite_qt_tmdb()

	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local last_adr = getConfigVal('info/imdb') or ''
	local tt = {
		{"","Фильмы"},
		{"","Сериалы"},
		{"","Персоны"},
		{"","Коллекции"},
		{"","ПОИСК"},
		}

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
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию TMDb',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t0[id].Name == 'ПОИСК' then
				search()
			elseif t0[id].Name == 'Персоны' then
				tmdb_person_page(1)
			elseif t0[id].Name == 'Коллекции' then
				collection()
			elseif t0[id].Name == 'Фильмы' then
				tmdb_movie_page(1, t0[id].Action)
			elseif t0[id].Name == 'Сериалы' then
				tmdb_tv_page(1, t0[id].Action)
			end
		end
		if ret == 2 then
		local tmdbid,tv = tmdb_id(last_adr)
		media_info_tmdb(tmdbid,tv)
		end
		if ret == 3 then
		run_westSide_portal()
		end
end

function tmdb_movie_page(page, tmdb_genres_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urltp = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS9wb3B1bGFyP2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlUmcGFnZT0=') .. page .. '&with_genres=' .. tmdb_genres_id
	local rc, answertp = m_simpleTV.Http.Request(session, {url = urltp})
	if rc~=200 then
	return ''
	end
	require('json')
	answertp = answertp:gsub('(%[%])', '"nil"')

	local tab = json.decode(answertp)
	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].title
	then
	return '' end

	local t, i = {}, 1
	while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	local rus = tab.results[i].title or ''
	local orig = tab.results[i].original_title or ''
	local year = tab.results[i].release_date or ''
	local poster
	if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
	poster = tab.results[i].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w500_and_h282_face' .. poster
	elseif tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
	poster = tab.results[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = 'simpleTVImage:./luaScr/user/westSide/icons/no-img.png'
	end
	local id_movie = tab.results[i].id
	local overview = tab.results[i].overview or ''
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ')'
	t[i].InfoPanelLogo = poster
	t[i].Address = id_movie
	t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
	t[i].InfoPanelTitle = overview
	t[i].InfoPanelShowTime = 10000
    i=i+1
	end
		local gnr_name = genres_name(0,tmdb_genres_id)
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Фильмы (страница ' .. page .. ' из 500) ' .. gnr_name
		if next_pg <= 500 then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg > 0 then
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
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		media_info_tmdb(t[id].Address,0)
		end
		if ret == 2 then
		if tonumber(prev_pg) > 0 then
		tmdb_movie_page(tonumber(page)-1, tmdb_genres_id)
		else
		run_lite_qt_tmdb()
		end
		end
		if ret == 3 then
		tmdb_movie_page(tonumber(page)+1, tmdb_genres_id)
		end
		end

function tmdb_tv_page(page, tmdb_genres_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urltp = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di9wb3B1bGFyP2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUtUlUmcGFnZT0=') .. page .. '&with_genres=' .. tmdb_genres_id
	local rc, answertp = m_simpleTV.Http.Request(session, {url = urltp})
	if rc~=200 then
	return ''
	end
	require('json')
	answertp = answertp:gsub('(%[%])', '"nil"')

	local tab = json.decode(answertp)
		if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name
	then
	return '' end

	local t, i, desc = {}, 1, ''
	while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	local rus = tab.results[i].name or ''
	local orig = tab.results[i].original_name or ''
	local year = tab.results[i].first_air_date or ''
	local id_tv = tab.results[i].id
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
	local poster
	if tab.results[i].backdrop_path and tab.results[i].backdrop_path ~= 'null' then
	poster = tab.results[i].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w500_and_h282_face' .. poster
	elseif tab.results[i].poster_path and tab.results[i].poster_path ~= 'null' then
	poster = tab.results[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = 'simpleTVImage:./luaScr/user/westSide/icons/no-img.png'
	end
	local overview = tab.results[i].overview or ''
	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ')'
	t[i].InfoPanelLogo = poster
	t[i].Address = id_tv
	t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
	t[i].InfoPanelTitle = overview
	t[i].InfoPanelShowTime = 10000
    i=i+1
	end
		local gnr_name = genres_name(1,tmdb_genres_id)
		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Сериалы (страница ' .. page .. ' из 500) ' .. gnr_name
		if next_pg <= 500 then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg > 0 then
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
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		media_info_tmdb(t[id].Address,1)
		end
		if ret == 2 then
		if tonumber(prev_pg) > 0 then
		tmdb_tv_page(tonumber(page)-1, tmdb_genres_id)
		else
		run_lite_qt_tmdb()
		end
		end
		if ret == 3 then
		tmdb_tv_page(tonumber(page)+1, tmdb_genres_id)
		end
		end

function tmdb_person_page(page)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urltp = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9wZXJzb24vcG9wdWxhcj9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJVJnBhZ2U9') .. page
	local rc, answertp = m_simpleTV.Http.Request(session, {url = urltp})
	if rc~=200 then
	return ''
	end
	require('json')
	answertp = answertp:gsub('(%[%])', '"nil"')

	local tab = json.decode(answertp)
	if not tab or not tab.results or not tab.results[1] or not tab.results[1].id or not tab.results[1].name
	then
	return '' end

	local t, i, j = {}, 1, 1
	while true do
	if not tab.results[i]
				then
				break
				end
	t[i]={}
	local rus = tab.results[j].name or ''
	local known_for
----------
	if tab.results[j].known_for and tab.results[j].known_for ~= 'nil' and (tab.results[j].known_for[1].title or tab.results[j].known_for[1].name)then
	known_for = tab.results[j].known_for[1].title or tab.results[j].known_for[1].name
	if tab.results[j].known_for[2] and (tab.results[j].known_for[2].title or tab.results[j].known_for[2].name) then
	known_for = known_for .. ', ' .. (tab.results[j].known_for[2].title or tab.results[j].known_for[2].name)
	end
	if tab.results[j].known_for[3] and (tab.results[j].known_for[3].title or tab.results[j].known_for[3].name) then
	known_for = known_for .. ', ' .. (tab.results[j].known_for[3].title or tab.results[j].known_for[3].name)
	end
	else
	known_for = ''
	end
----------

	local id_person = tab.results[j].id
	local poster
	if tab.results[j].profile_path and tab.results[j].profile_path ~= 'null' then
	poster = tab.results[j].profile_path
	poster = 'http://image.tmdb.org/t/p/w500_and_h282_face' .. poster
	end
	t[i].Id = i
	t[i].Address = id_person
	t[i].Name = rus
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = rus
	t[i].InfoPanelTitle = known_for
	t[i].InfoPanelShowTime = 10000
	j=j+1
    i=i+1
	end

		local prev_pg = tonumber(page) - 1
		local next_pg = tonumber(page) + 1
		local title = 'Персоны (страница ' .. page .. ' из 500)'
		if next_pg <= 500 then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ''}
		end
		if prev_pg > 0 then
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
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title, 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		personWorkById(t[id].Address)
		end
		if ret == 2 then
		if tonumber(prev_pg) > 0 then
		tmdb_person_page(tonumber(page)-1)
		else
		run_lite_qt_tmdb()
		end
		end
		if ret == 3 then
		tmdb_person_page(tonumber(page)+1)
		end
	end

function collection()
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 60000)
		local url_home = decode64('aHR0cDovL20yNC5kby5hbS9DSC9raW5vL3RtZGJfY29sbGVjdGlvbnMudHh0')
		local rc,answer_pls = m_simpleTV.Http.Request(session,{url=url_home})
		if rc ~= 200 then return '' end
		answer_pls = answer_pls .. '\n'
		local t, i = {}, 1

			for w in answer_pls:gmatch('%#EXTINF:.-\n.-\n') do
				local title = w:match(',(.-)\n')
				local adr = w:match('\n(.-)\n')
				local logo = w:match('tvg%-logo="(.-)"') or 'simpleTVImage:./luaScr/user/westSide/icons/tmdb.png'
					if not adr or not title then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = title
				t[i].Address = adr:gsub('^tmdb_collection=','')
--анатомия
				if adr == 'tmdb_collection=8412' then logo ='https://www.themoviedb.org/t/p/w500_and_h282_face/vt4Ry2oQuHwQ7KOA7ZbC1vFal3W.jpg' end
--снайпер
				if adr == 'tmdb_collection=14246' then logo ='https://www.themoviedb.org/t/p/w500_and_h282_face/vt4Ry2oQuHwQ7KOA7ZbC1vFal3W.jpg' end
--чаки
				if adr == 'tmdb_collection=10455' then logo ='https://www.themoviedb.org/t/p/original/fCsi39CuitAmLSUvUy1EWmKETNx.jpg' end
--дорога домой
				if adr == 'tmdb_collection=43058' then logo ='https://www.themoviedb.org/t/p/original/emjiSiZbDUo40veJEysqulaI027.jpg' end
--Правосудие Стоуна
				if adr == 'tmdb_collection=59235' then logo ='https://www.themoviedb.org/t/p/original/8CnmhIk7FAGCDrqZcC90LnrmrUE.jpg' end
--Виннету
				if adr == 'tmdb_collection=9309' then logo ='https://www.themoviedb.org/t/p/original/koiG0RZgrvv1GdPr5DSUing0vZw.jpg' end
				t[i].InfoPanelLogo = logo:gsub('original','w500_and_h282_face')
				t[i].InfoPanelName = 'TMDb: ' .. title
				t[i].InfoPanelShowTime = 10000
				i = i + 1
			end
			t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
			t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
			local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите коллекцию TMDb (' .. #t .. ')',0,t,10000,1+4+8+2)
			if ret == -1 or not id then
				return
			end
			if ret == 1 then
				collection_TMDb(t[id].Address)
			end
			if ret == 2 then
				run_lite_qt_tmdb()
			end
			end

function collection_TMDb(tmdbcolid)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local urlt1 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9jb2xsZWN0aW9uLw==') .. tmdbcolid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnU=')
	local rc, answert1 = m_simpleTV.Http.Request(session, {url = urlt1})
	if rc~=200 then
	return ''
	end
	require('json')
	answert1 = answert1:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert1)
	if not tab or not tab.parts or not tab.parts[1] or not tab.parts[1].id or not tab.parts[1].title
	then
	return '' end

	local name_c = tab.name
	local t, i = {}, 1
	while true do
	if not tab.parts[i] or not tab.parts[i].id
				then
				break
				end
	t[i]={}
	local id_media = tab.parts[i].id
    local rus = tab.parts[i].title or ''
	local orig = tab.parts[i].original_title or ''
	local year = tab.parts[i].release_date or ''
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
	local poster
	if tab.parts[i].backdrop_path and tab.parts[i].backdrop_path ~= 'null' then
	poster = tab.parts[i].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w500_and_h282_face' .. poster
	elseif tab.parts[i].poster_path and tab.parts[i].poster_path ~= 'null' then
	poster = tab.parts[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = 'simpleTVImage:./luaScr/user/westSide/icons/no-img.png'
	end
	local overview = tab.parts[i].overview or ''
	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ')'
	t[i].InfoPanelLogo = poster
	t[i].Address = id_media
	t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
	t[i].InfoPanelTitle = overview
	t[i].InfoPanelShowTime = 10000
	i=i+1
	end
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Back '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play '}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(name_c, 0, t, 30000, 1+4+8+2)
	if ret == -1 or not id then
		return
	end
	if ret == 1 then
		media_info_tmdb(t[id].Address,0)
	end
	if ret == 2 then
		run_lite_qt_tmdb()
	end
	if ret == 3 then
		retAdr = 'collection_tmdb=' .. tmdbcolid
		m_simpleTV.Control.ChangeAddress = 'No'
		m_simpleTV.Control.ExecuteAction(37)
		m_simpleTV.Control.CurrentAddress = retAdr
		m_simpleTV.Control.PlayAddress(retAdr)
	end
end

function personWorkById(tmdbperid)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local urlt = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9wZXJzb24v') .. tmdbperid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnU=')
	local name, logo, tmdbstr, logo1

	local rc, answert = m_simpleTV.Http.Request(session, {url = urlt})
	if rc~=200 then
	return ''
	end
	require('json')
	answert = answert:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert)
	if tab and tab.id and tab.name
	then
	title = tab.name
	end

	local urlt1 = decode64(
	'aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9wZXJzb24v') .. tmdbperid .. decode64('L2NvbWJpbmVkX2NyZWRpdHM/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydQ==') .. '&sort_by=vote_average.desc'

	local rc, answert1 = m_simpleTV.Http.Request(session, {url = urlt1})
	if rc~=200 then
	return ''
	end
	require('json')
	answert1 = answert1:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert1)
	if not tab
	then
	return ''
	end

	local t, i = {}, 1
	local i1, i2 = 1, 1
	while true do
	if not tab.cast[i1]
				then
				break
				end
	t[i]={}
	local id_media = tab.cast[i1].id or ''
    local rus = tab.cast[i1].title  or tab.cast[i1].name or ''
	local orig = tab.cast[i1].original_title or tab.cast[i1].original_name or ''
	local year = tab.cast[i1].release_date or tab.cast[i1].first_air_date or ''
	local type_media = tab.cast[i1].media_type
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
---------------
local poster
	if tab.cast[i1].backdrop_path and tab.cast[i1].backdrop_path ~= 'null' then
	poster = tab.cast[i1].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w500_and_h282_face' .. poster
	elseif tab.cast[i1].poster_path and tab.cast[i1].poster_path ~= 'null' then
	poster = tab.cast[i1].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = 'simpleTVImage:./luaScr/user/westSide/icons/no-img.png'
	end

	local overview = tab.cast[i1].overview or ''

	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ') - ' .. type_media
	t[i].InfoPanelLogo = poster
	t[i].Address = id_media
	t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
	t[i].InfoPanelTitle = overview
	t[i].InfoPanelShowTime = 10000
---------------
	i=i+1
	i1=i1+1
	end

	while true do
	if not tab.crew[i2]
				then
				break
				end
	t[i]={}
	local id_media = tab.crew[i2].id or ''
    local rus = tab.crew[i2].title or tab.crew[i2].name or ''
	local orig = tab.crew[i2].original_title or tab.crew[i2].original_name or ''
	local year = tab.crew[i2].release_date or tab.crew[i2].first_air_date or ''
	local type_media = tab.crew[i2].media_type
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end

	if tab.crew[i2].job and (tab.crew[i2].job == 'Director' or tab.crew[i2].job == 'Creator') then
---------------
	local poster
	if tab.crew[i2].backdrop_path and tab.crew[i2].backdrop_path ~= 'null' then
	poster = tab.crew[i2].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w500_and_h282_face' .. poster
	elseif tab.crew[i2].poster_path and tab.crew[i2].poster_path ~= 'null' then
	poster = tab.crew[i2].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = 'simpleTVImage:./luaScr/user/westSide/icons/no-img.png'
	end

	local overview = tab.crew[i2].overview or ''

	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ') - ' .. type_media
	t[i].InfoPanelLogo = poster
	t[i].Address = id_media
	t[i].InfoPanelName = rus .. ' / ' .. orig .. ' ' .. year
	t[i].InfoPanelTitle = overview
	t[i].InfoPanelShowTime = 10000
	i=i+1
---------------
	end
	i2=i2+1
	end

		t.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}

		local AutoNumberFormat, FilterType
			if #t > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end

		t.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8(title .. ' (' .. #t .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
		if t[id].Name:match('%- movie')
		then
		media_info_tmdb(t[id].Address,0)
		else
		media_info_tmdb(t[id].Address,1)
		end
		end
		if ret == 2 then
		run_lite_qt_tmdb()
		end
end

function media_info_tmdb(tmdbid,tv)
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
	else tooltip_body = 'bgcolor="#182633"'
	end
local urltm, titul_tmdb_media, tmdb_media
if tv == 0 then
urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ=='):gsub('=ru','=ru')
titul_tmdb_media = titul_tmdb_movie
tmdb_media = 'movie'
elseif tv == 1 then
urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. tmdbid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ=='):gsub('=ru','=ru')
titul_tmdb_media = titul_tmdb_tv
tmdb_media = 'tv'
end
local rc3,answertm = m_simpleTV.Http.Request(session,{url=urltm})
if rc3~=200 then
  m_simpleTV.Http.Close(session)
  return
end
require('json')
answertm = answertm:gsub('(%[%])', '"nil"')
local tab, promo, genre, country, rating = json.decode(answertm), '', '', '', ''

	if tab.poster_path and tab.poster_path ~= 'null' then
	poster = tab.poster_path
	poster = 'http://image.tmdb.org/t/p/original' .. poster
	else poster = 'simpleTVImage:./luaScr/user/westSide/icons/no-img.png'
	end

	if tab.backdrop_path and tab.backdrop_path ~= 'null'
	then
	background = tab.backdrop_path
	background = 'http://image.tmdb.org/t/p/original' .. background
	else background = 'simpleTVImage:./luaScr/user/westSide/icons/no-img.png'
	end

	overview = tab.overview
	rating = tab.vote_average
	count = tab.vote_count
	ru_name = tab.title or tab.name
	orig_name = tab.original_title or tab.original_name
	year = tab.release_date or tab.first_air_date
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end

if tab and tab.production_countries then
 local j = 1
	while true do
		if not tab.production_countries[j]
		then
		break
		end
 country = country .. tab.production_countries[j].name .. ', '
 j=j+1
 end
 country = country:gsub(', $', '')
 else
 country = ''
 end

if tab and tab.tagline then
slogan = tab.tagline
else slogan = ''
end

if tab and tab.genres then
 local j = 1
	while true do
		if not tab.genres[j]
		then
		break
		end
 genre = genre .. ', ' .. tab.genres[j].name

 j=j+1
 end
 genre = genre:gsub('^%, ', '')
 else
 genre = ''
 end
 rating = tostring(rating):match('(%d%.%d)') or tostring(rating):match('(%d)') or '0'
        local imdb_id = tab.imdb_id

		if tv == 1 then imdb_id = imdbid(tmdbid) end

		videodesc= '<table width="100%"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="470"></td><td style="padding: 0px 5px 5px; color: #FFFFFF; vertical-align: middle;"><h3><font color=#00FA9A>' .. ru_name .. '</font></h3><h4><i><font color=#CCCCCC>' .. slogan .. '</font></i></h4><h4><font color=#BBBBBB>' .. orig_name .. '</font></h4><h4><font color=#E0FFFF>' .. country .. ' • ' .. year .. '</font></h4><h4><font color=#EBEBEB>' .. genre .. '</font></h4><h5><img src="simpleTVImage:./luaScr/user/show_mi/menuTM.png" height="36" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. rating .. '.png" height="36" align="top"> ' .. rating .. ' (' .. count .. ')</h5></td></tr></table><table width="100%"><tr><td style="padding: 0px 15px 5px;" color: #FFFFFF;><h4><font color=#EBEBEB>' .. overview .. '</font></h4></td></tr></table>'
		videodesc = videodesc:gsub('"', '\"')

	local t1,j={},2
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Address = ''
		t1[1].Name = '.: info :.'
		t1[1].InfoPanelLogo = background
		t1[1].InfoPanelName = tmdb_media .. ': TMDb info'
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. videodesc .. '</body></html>'
		t1[1].InfoPanelTitle = overview
		t1[1].InfoPanelShowTime = 10000

		if tab and tab.belongs_to_collection and tab.belongs_to_collection.id and tab.belongs_to_collection.name then
		t1[2] = {}
		t1[2].Id = 2
		t1[2].Address = tab.belongs_to_collection.id
		t1[2].Name = 'TMDb: ' .. tab.belongs_to_collection.name
		j=3
		end

		local k = 1
		while true do
		if not tab.genres[k]
		then
		break
		end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = tab.genres[k].id
		t1[j].Name = tmdb_media .. ' - ' .. tab.genres[k].name
		k=k+1
		j=j+1
		end
--------------person
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
local desc = ''

if tab and tab.credits and tab.credits.crew and tab.credits.crew[1] and tab.credits.crew[1].id then
local j1 = 1
	while true do

		if not tab.credits.crew[j1]
		then
		break
		end
	if tab.credits.crew[j1].job and tab.credits.crew[j1].job == 'Director' then
	t1[j] = {}
	local rus1 = tab.credits.crew[j1].name or ''
	local cha1 = tab.credits.crew[j1].job or ''
	local id_person1 = tab.credits.crew[j1].id
	t1[j].Name = rus1 .. ' - ' .. cha1
	t1[j].Id = j
	local poster1
	if tab.credits.crew[j1].profile_path and tab.credits.crew[j1].profile_path ~= 'null' then
	poster1 = tab.credits.crew[j1].profile_path
	poster1 = 'http://image.tmdb.org/t/p/w500_and_h282_face' .. poster1
	t1[j].InfoPanelLogo = poster1
	t1[j].InfoPanelName = rus1 .. ' - ' .. cha1
	t1[j].InfoPanelShowTime = 10000
	end
	t1[j].Address = id_person1
	j=j+1
	end
	j1=j1+1
	end
end

if tab and tab.credits and tab.credits.cast and tab.credits.cast[1] and tab.credits.cast[1].id then
local j2 = 1
	while true do

		if not tab.credits.cast[j2]
		then
		break
		end

	t1[j] = {}
	local rus = tab.credits.cast[j2].name or ''
	local cha = tab.credits.cast[j2].character or ''
	local id_person = tab.credits.cast[j2].id
	t1[j].Name = rus .. ' - ' .. cha
	t1[j].Id = j
	local poster
	if tab.credits.cast[j2].profile_path and tab.credits.cast[j2].profile_path ~= 'null' then
	poster = tab.credits.cast[j2].profile_path
	poster = 'http://image.tmdb.org/t/p/w500_and_h282_face' .. poster
	t1[j].InfoPanelLogo = poster
	t1[j].InfoPanelName = rus .. ' - ' .. cha
	t1[j].InfoPanelShowTime = 10000
	end
	t1[j].Address = id_person
    j2=j2+1
	j=j+1
	end
end
--------------
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀 '}
		if imdb_id and imdb_id ~= '' and kpid(imdb_id) and kpid(imdb_id) ~= ''
		then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play'}
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('TMDb: ' .. ru_name .. ' (' .. year .. ')', 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			if id == 1 then
			media_info_tmdb(tmdbid,tv)
			elseif t1[id].Name:match('TMDb: ') then
			collection_TMDb(t1[id].Address)
			elseif t1[id].Name:match('movie %-') then
			tmdb_movie_page(1, t1[id].Address)
			elseif t1[id].Name:match('tv %-') then
			tmdb_tv_page(1, t1[id].Address)
			else
			personWorkById(t1[id].Address)
			end
		end
		if ret == 2 then
			run_lite_qt_tmdb()
		end
		if ret == 3 then
			retAdr = 'https://www.imdb.com/title/' .. imdb_id .. '/reference'
			m_simpleTV.Control.ChangeAddress = 'No'
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.PlayAddress(retAdr)
		end
end

function UpdatePersonTMDB()
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

function search_tmdb()
local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	local tmdb_search = getConfigVal('search/media') or ''
	tmdb_search = m_simpleTV.Common.fromPercentEncoding(tmdb_search)
	local title1 = 'Поиск TMDb: ' .. tmdb_search

	local t1, nm1 = find_movie(tmdb_search)
	local t2, nm2 = find_series(tmdb_search)
	local t3, nm3 = findpersonIdByName(tmdb_search)
	local t4, nm4 = find_collectons(tmdb_search)

	local tt = {
	{"Фильмы","","./luaScr/user/show_mi/IconVideo.png",""},
	{"Сериалы","","./luaScr/user/show_mi/IconTVShows.png",""},
	{"Персоны","","./luaScr/user/show_mi/IconActor.png",""},
	{"Коллекции","","./luaScr/user/show_mi/IconCollection.png",""},
	}

	local t, k = {}, 1
  for i=1,#tt do
    t[k] = {}
	if i == 1 and tonumber(nm1) > 0 then
    t[k].Id = k
    t[k].Name = tt[i][1] .. ' (' .. nm1 .. ')'
	t[k].Action = tt[i][1]
	t[k].InfoPanelLogo = tt[i][3]
	t[k].InfoPanelTitle = tt[i][4]
	t[k].InfoPanelShowTime = 12000
	k = k + 1
	elseif i == 2 and tonumber(nm2) > 0 then
    t[k].Id = k
    t[k].Name = tt[i][1] .. ' (' .. nm2 .. ')'
	t[k].Action = tt[i][1]
	t[k].InfoPanelLogo = tt[i][3]
	t[k].InfoPanelTitle = tt[i][4]
	t[k].InfoPanelShowTime = 12000
	k = k + 1
	elseif i == 3 and tonumber(nm3) > 0 then
    t[k].Id = k
    t[k].Name = tt[i][1] .. ' (' .. nm3 .. ')'
	t[k].Action = tt[i][1]
	t[k].InfoPanelLogo = tt[i][3]
	t[k].InfoPanelTitle = tt[i][4]
	t[k].InfoPanelShowTime = 12000
	k = k + 1
	elseif i == 4 and tonumber(nm4) > 0 then
    t[k].Id = k
    t[k].Name = tt[i][1] .. ' (' .. nm4 .. ')'
	t[k].Action = tt[i][1]
	t[k].InfoPanelLogo = tt[i][3]
	t[k].InfoPanelTitle = tt[i][4]
	t[k].InfoPanelShowTime = 12000
	k = k + 1
	end
	i = i + 1
  end
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🔎 Меню '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' 🔎 Поиск '}
	if k > 1 then
    local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 Выберите категорию поиска: ' .. tmdb_search,0,t,10000,1+4+8+2)
	if ret == -1 or not id then
		 return
	end
	if ret == 2 then
		search_all()
	end
	if ret == 3 then
		search()
	end
	if ret == 1 then
	if t[id].Action == "Фильмы" then
	if tonumber(nm1) == 0 then search_tmdb() end
	t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 фильмы: ' .. tmdb_search, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			return
		end
		if ret == 2 then
			search_tmdb()
		end
		if ret == 1 then
			media_info_tmdb(t1[id].Address,0)
		end
	elseif t[id].Action == "Сериалы" then
	if tonumber(nm2) == 0 then search_tmdb() end
	t2.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t2.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 сериалы: ' .. tmdb_search, 0, t2, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			return
		end
		if ret == 2 then
			search_tmdb()
		end
		if ret == 1 then
			media_info_tmdb(t2[id].Address,1)
		end
	elseif t[id].Action == "Персоны" then
	if tonumber(nm3) == 0 then search_tmdb() end
	t3.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t3.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 персоны: ' .. tmdb_search, 0, t3, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
		 return
		end
		if ret == 2 then
			search_tmdb()
		end
		if ret == 1 then
			personWorkById(t3[id].Address)
		end
	elseif t[id].Action == "Коллекции" then
	if tonumber(nm4) == 0 then search_tmdb() end
	t4.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t4.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 коллекции: ' .. tmdb_search, 0, t4, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
		 return
		end
		if ret == 2 then
			search_tmdb()
		end
		if ret == 1 then
			collection_TMDb(t4[id].Address)
		end
	end
	end
	else
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'TMDB: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
		search_all()
	end
	end
-------------------------------------------------------------------
--[[
 local t1={}
 t1.utf8 = true
 t1.name = 'TMDb меню'
 t1.luastring = 'run_lite_qt_tmdb()'
 t1.lua_as_scr = true
 t1.key = string.byte('H')
 t1.ctrlkey = 3
 t1.location = 0
 t1.image= m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuTM.png'
 m_simpleTV.Interface.AddExtMenuT(t1)
 m_simpleTV.Interface.AddExtMenuT({utf8 = false, name = '-'})
 --]]
-------------------------------------------------------------------