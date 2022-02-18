-- видеоскрипт для подключения TMDb в качестве поиска медиаконтента, персон, сборников-франшиз (18/08/21)
-- autor westSide
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not m_simpleTV.Control.CurrentAddress:match('^=')
		and not m_simpleTV.Control.CurrentAddress:match('^tmdb_id=')
		then
		 return
		end



		local tv = 0
		if inAdr:match('%&tv$') then tv = 1 end

		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3809.87 Safari/537.36')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 12000)

	local function getadr(imdbid)

	local url_vn = decode64('aHR0cHM6Ly8zOC5zdmV0YWNkbi5pbi9mblhPVURCOW5OU08vbW92aWUvMjc4OD9pbWRiX2lkPQ==') .. imdbid
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})
		if rc5~=200 then
		return ''
		else
		return url_vn
		end
	end

	local function imdbid(id,tv)
	local url_im,rc6,answer_im,tab_im
	if tv == 1 then
	url_im = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy90di8=') .. id .. decode64('L2V4dGVybmFsX2lkcz9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJV')
	elseif tv == 0 then
	url_im = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ==')
	end
	local rc6,answer_im = m_simpleTV.Http.Request(session,{url=url_im})
		if rc6~=200 then
		return ''
		end
		require('json')
		answer_im = answer_im:gsub('(%[%])', '"nil"')
		local tab_im = json.decode(answer_im)
		if tab_im and tab_im.imdb_id and tab_im.imdb_id ~= 'null' then
		return tab_im.imdb_id
		else
		return ''
		end
	end

local function find_movie(title)

local urld = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title)
local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
if rc1~=200 then
  m_simpleTV.Http.Close(session)
  return
end
local total_pages,total_results = answerd:match('"total_pages":(%d+),"total_results":(%d+)')
local answer = ''
if tonumber(total_pages) == 0 then total_pages = 1 end
for j = 1,total_pages do
local urld = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&page=' .. j
local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
if rc1~=200 then
  m_simpleTV.Http.Close(session)
  return
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
	t[i].Name = rus .. ' (' .. year .. ')'
	t[i].Address = 'tmdb_id=' .. id_media
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
local urld2 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title)
local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
if rc2~=200 then
  m_simpleTV.Http.Close(session)
  return
end
local total_pages,total_results = answerd2:match('"total_pages":(%d+),"total_results":(%d+)')
local answer3 = ''
if tonumber(total_pages) == 0 then total_pages = 1 end
for j = 1,total_pages do
local urld3 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&page=' .. j
local rc3,answerd3 = m_simpleTV.Http.Request(session,{url=urld3})
if rc3~=200 then
  m_simpleTV.Http.Close(session)
  return
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
	t[i].Name = ru_name .. ' (' .. year .. ')'
	t[i].Address = 'tmdb_id=' .. id_media .. '&tv'
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
	t[i].Address = 'tmdb_id_person=' .. id_person
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = department .. known_for
    i=i+1
	end
	return t, i - 1
	end

	local function findpersonInfoById(id)
	local urlt = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9wZXJzb24v') .. id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnU=')
	local name, logo, tmdbstr
	local rc, answert = m_simpleTV.Http.Request(session, {url = urlt})
	if rc~=200 then
	return ''
	end
	require('json')
	answert = answert:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert)
	if not tab or not tab.id
	then
	return '', '', ''
	else
	name = tab.name or ''
	logo = tab.profile_path or ''
	place = tab.place_of_birth or ''
	data1 = tab.birthday or ''
	data2 = tab.deathday or ''
	if data2 == 'null' or data2 == '' then data2 = '' else data2 = ', Дата смерти: ' .. data2 end
	data3 = tab.biography or ''
	if data3 == 'null' or data3 == '' then data3 = '' else data3 = ', Биография: ' .. data3 end
	if tab.profile_path and tab.profile_path ~= 'null' then
	logo = tab.profile_path
	logo = 'http://image.tmdb.org/t/p/original' .. logo
	else logo = 'simpleTVImage:./luaScr/user/westSide/icons/no-img.png'
	end
	tmdbstr = 'Место рождения: ' .. place .. ', Дата рождения: ' .. data1 .. data2 .. data3
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = logo:gsub('/original/','/w1066_and_h600_bestv2/'), TypeBackColor = 0, UseLogo = 3, Once = 1})
	end
	return tmdbstr
	end
	end

	local function findpersonWorkById(id)
	local urlt1 = decode64(
	'aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9wZXJzb24v') .. id .. decode64('L2NvbWJpbmVkX2NyZWRpdHM/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydQ==') .. '&sort_by=vote_average.desc'

	local rc, answert1 = m_simpleTV.Http.Request(session, {url = urlt1})
	if rc~=200 then
	return ''
	end
	require('json')
	answert1 = answert1:gsub('(%[%])', '"nil"')

	local tab = json.decode(answert1)

	local t, i, i2 = {}, 1, 1
	if tab and tab.cast and tab.cast[1] and tab.cast[1].id then
	while true do
	if tab and tab.cast and tab.cast[1] and tab.cast[1].id then
	if not tab.cast[i2]
				then
				break end
	t[i]={}
	id_media = tab.cast[i2].id or ''
    rus = tab.cast[i2].title  or tab.cast[i2].name or ''
	orig = tab.cast[i2].original_title or tab.cast[i2].original_name or ''
	year = tab.cast[i2].release_date or tab.cast[i2].first_air_date or ''
	type_media = tab.cast[i2].media_type
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
	overview = tab.cast[i2].overview or ''
	if tab.cast[i2].backdrop_path and tab.cast[i2].backdrop_path ~= 'null' then
	poster = tab.cast[i2].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. poster
	elseif tab.cast[i2].poster_path and tab.cast[i2].poster_path ~= 'null' then
	poster = tab.cast[i2].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = './luaScr/user/show_mi/no-img.png'
	end

	if type_media == 'movie' then
	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ')'
	t[i].Address = 'tmdb_id=' .. id_media
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus .. ' (' .. year .. ')'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview
	elseif type_media == 'tv' then
	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ') - сериал'
	t[i].Address = 'tmdb_id=' .. id_media .. '&tv'
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus .. ' (' .. year .. ') - сериал'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview
	end

	i = i + 1
	end
	i2=i2+1
	end
	elseif tab and tab.cast and tab.cast[1] and tab.cast[1].id and tab.crew and tab.crew[1] and tab.crew[1].id
	or tab and tab.crew and tab.crew[1] and tab.crew[1].id
	then
	local i1 = 1
	while true do
	if tab and tab.crew and tab.crew[1] and tab.crew[1].id then
	if not tab.crew[i1]
				then
				break
				end
	t[i]={}
	local id_media = tab.crew[i1].id or ''
    local rus = tab.crew[i1].title or tab.crew[i1].name or ''
	local orig = tab.crew[i1].original_title or tab.crew[i1].original_name or ''
	local year = tab.crew[i1].release_date or tab.crew[i1].first_air_date or ''
	local type_media = tab.crew[i1].media_type
	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
	local overview = tab.crew[i1].overview or ''
	if tab.crew[i1].backdrop_path and tab.crew[i1].backdrop_path ~= 'null' then
	poster = tab.crew[i1].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. poster
	elseif tab.crew[i1].poster_path and tab.crew[i1].poster_path ~= 'null' then
	poster = tab.crew[i1].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = './luaScr/user/show_mi/no-img.png'
	end

	if type_media == 'movie' then
	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ')'
	t[i].Address = 'tmdb_id=' .. id_media
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus .. ' (' .. year .. ')'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview
	elseif type_media == 'tv' then
	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ') - сериал'
	t[i].Address = 'tmdb_id=' .. id_media .. '&tv'
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus .. ' (' .. year .. ') - сериал'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview
	end

	i = i + 1
	end
	i1=i1+1
	end
	end
	return t
	end

local function find_collectons(title)

local urlt = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvY29sbGVjdGlvbj9hcGlfa2V5PWQ1NmU1MWZiNzdiMDgxYTljYjUxOTJlYWFhNzgyM2FkJmxhbmd1YWdlPXJ1LVJVJnBhZ2U9MSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title)
	local id, name, logo
	local rc, answert = m_simpleTV.Http.Request(session, {url = urlt})
	if rc~=200 then
	return ''
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
	t[i].Address = 'tmdb_id_collections=' .. id_collections
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview
    i=i+1
	end
	return t, i - 1
	end

	local function findCollectionForId(id)
	local urlt1 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9jb2xsZWN0aW9uLw==') .. id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnU=')

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
	if tab.backdrop_path and tab.backdrop_path ~= 'null' then
		logo_c = 'http://image.tmdb.org/t/p/original' .. tab.backdrop_path
	else logo_c = 'https://www.themoviedb.org/t/p/w1920_and_h600_multi_faces_filter(duotone,032541,01b4e4)/ayUMWKe6Wow5ixLlKxxlp7IqTiI.jpg'
	end

--анатомия
if id == '8412' then logo_c ='https://www.themoviedb.org/t/p/original/vt4Ry2oQuHwQ7KOA7ZbC1vFal3W.jpg' end
--снайпер
if id == '14246' then logo_c ='https://www.themoviedb.org/t/p/original/vt4Ry2oQuHwQ7KOA7ZbC1vFal3W.jpg' end
--чаки
if id == '10455' then logo_c ='https://www.themoviedb.org/t/p/original/fCsi39CuitAmLSUvUy1EWmKETNx.jpg' end
--дорога домой
if id == '43058' then logo_c ='https://www.themoviedb.org/t/p/original/emjiSiZbDUo40veJEysqulaI027.jpg' end
--Правосудие Стоуна
if id == '59235' then logo_c ='https://www.themoviedb.org/t/p/original/8CnmhIk7FAGCDrqZcC90LnrmrUE.jpg' end
--Виннету
if id == '9309' then logo_c ='https://www.themoviedb.org/t/p/original/koiG0RZgrvv1GdPr5DSUing0vZw.jpg' end

	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, PictFileName = logo_c, TypeBackColor = 0, UseLogo = 3, Once = 1})
	end

	local t, i = {}, 1

	while true do
	if not tab.parts[i]
				then
				break
				end
	t[i]={}
	id_media = tab.parts[i].id or ''
    rus = tab.parts[i].title or ''
	year = tab.parts[i].release_date or ''

	if year and year ~= '' then
	year = year:match('%d%d%d%d')
	else year = 0 end
	overview = tab.parts[i].overview or ''
	if tab.parts[i].backdrop_path and tab.parts[i].backdrop_path ~= 'null' then
	poster = tab.parts[i].backdrop_path
	poster = 'http://image.tmdb.org/t/p/w533_and_h300_bestv2' .. poster
	elseif tab.parts[i].poster_path and tab.parts[i].poster_path ~= 'null' then
	poster = tab.parts[i].poster_path
	poster = 'http://image.tmdb.org/t/p/w220_and_h330_face' .. poster
	else poster = './luaScr/user/show_mi/no-img.png'
	end

	t[i].Id = i
	t[i].Name = rus .. ' (' .. year .. ')'
	t[i].Address = 'tmdb_id=' .. id_media
	t[i].InfoPanelLogo = poster
	t[i].InfoPanelName = 'TMDb info: ' .. rus .. ' (' .. year .. ')'
	t[i].InfoPanelShowTime = 30000
	t[i].InfoPanelTitle = overview
	i=i+1
	end

	return t
	end

	tmdb_search = inAdr:match('^=(.-)$')
	tmdb_search = m_simpleTV.Common.multiByteToUTF8(tmdb_search,1251)

	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, BackColorEnd = 255, PictFileName = 'https://www.themoviedb.org/t/p/w1920_and_h600_multi_faces_filter(duotone,032541,01b4e4)/ayUMWKe6Wow5ixLlKxxlp7IqTiI.jpg', TypeBackColor = 0, UseLogo = 3, Once = 1})
		m_simpleTV.Control.ChangeChannelLogo('https://www.themoviedb.org/assets/2/apple-touch-icon-57ed4b3b0450fd5e9a0c20f34e814b82adaa1085c79bdde2f00ca8787b63d2c4.png', m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		m_simpleTV.Control.ChangeChannelName('Search TMDb: ' .. tmdb_search, m_simpleTV.Control.ChannelID, false)
	end

	m_simpleTV.Control.SetTitle('Search TMDb: ' .. tmdb_search)

	local t1, nm1 = find_movie(tmdb_search)
	local t2, nm2 = find_series(tmdb_search)
	local t3, nm3 = findpersonIdByName(tmdb_search)
	local t5, nm5 = find_collectons(tmdb_search)
	local retAdr = ''

	local tt = {
	{"Фильмы","","./luaScr/user/show_mi/IconVideo.png",""},
	{"Сериалы","","./luaScr/user/show_mi/IconTVShows.png",""},
	{"Персоны","","./luaScr/user/show_mi/IconActor.png",""},
	{"Коллекции","","./luaScr/user/show_mi/IconCollection.png",""},
	}

	local t={}
  for i=1,#tt do
    t[i] = {}
    t[i].Id = i
	if i == 1 then
    t[i].Name = tt[i][1] .. ' (' .. nm1 .. ')'
	elseif i == 2 then
    t[i].Name = tt[i][1] .. ' (' .. nm2 .. ')'
	elseif i == 3 then
    t[i].Name = tt[i][1] .. ' (' .. nm3 .. ')'
	elseif i == 4 then
    t[i].Name = tt[i][1] .. ' (' .. nm5 .. ')'
	end
    t[i].Action = tt[i][2]
	t[i].InfoPanelLogo = tt[i][3]
	t[i].InfoPanelTitle = tt[i][4]
	t[i].InfoPanelShowTime = 12000
  end
	t.ExtButton1 = {ButtonEnable = true, ButtonName = '🔎 EX-FS '}
	t.ExtButton0 = {ButtonEnable = true, ButtonName = '🔎 Rezka '}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 Выберите категорию поиска: ' .. tmdb_search,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
--		 return
		end
		if ret == 2 then
		retAdr = inAdr:gsub('^=','#')
		end
		if ret == 3 then
		retAdr = inAdr:gsub('^=','!')
		end
  if ret == 1 then

	if id == 1 then

	t1.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 фильмы: ' .. tmdb_search, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		search = t1[id].Address:gsub('^tmdb_id=','')
		m_simpleTV.Control.CurrentTitle_UTF8 = t1[id].Name
		m_simpleTV.Control.ChangeChannelLogo(t1[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		search = imdbid(search,0)
		if search ~= '' then retAdr = getadr(search) end
		if retAdr and retAdr ~= '' then retAdr = retAdr .. '&imdb_id=' .. search else retAdr = '#' .. m_simpleTV.Common.UTF8ToMultiByte(t1[id].Name):gsub('%(.-$','') end
	end

	elseif id == 2 then

	t2.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t2.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 сериалы: ' .. tmdb_search, 0, t2, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		search = t2[id].Address:gsub('^tmdb_id=',''):gsub('%&tv$','')
		m_simpleTV.Control.CurrentTitle_UTF8 = t2[id].Name
		m_simpleTV.Control.ChangeChannelLogo(t2[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		search = imdbid(search,1)
		if search ~= '' then retAdr = getadr(search) end
		if retAdr and retAdr ~= '' then retAdr = retAdr .. '&imdb_id=' .. search else retAdr = '#' .. m_simpleTV.Common.UTF8ToMultiByte(t2[id].Name):gsub('%(.-$','') end
	end

	elseif id == 3 then

	t3.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t3.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 персоны: ' .. tmdb_search, 0, t3, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		search = t3[id].Address:gsub('^tmdb_id_person=','')
		m_simpleTV.Control.CurrentTitle_UTF8 = t3[id].Name
		findpersonInfoById(search)
		local t4 = findpersonWorkById(search)
		if t4 ~= '' then
		local hash, res = {}, {}
		for i = 1, #t4 do
			t4[i].Address = tostring(t4[i].Address)
			if not hash[t4[i].Address] then
				res[#res + 1] = t4[i]
				hash[t4[i].Address] = true
			end
		end
			local AutoNumberFormat, FilterType
			if #res > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		res.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		res.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
		res.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 ' .. t3[id].Name, 0, res, 30000, 1 + 4 + 8 + 2)
	if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		search = t4[id].Address:gsub('^tmdb_id=','')
		m_simpleTV.Control.CurrentTitle_UTF8 = t4[id].Name
		m_simpleTV.Control.ChangeChannelLogo(t4[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		if search:match('%&tv$') then
		search = imdbid(search:gsub('%&tv$',''),1)
		else
		search = imdbid(search,0)
		end
		if search ~= '' then retAdr = getadr(search) end
		if retAdr and retAdr ~= '' then retAdr = retAdr .. '&imdb_id=' .. search else retAdr = '#' .. m_simpleTV.Common.UTF8ToMultiByte(t4[id].Name):gsub('%(.-$','') end
	end
	end
	end

	elseif id == 4 then

	t5.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
	t5.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 коллекции: ' .. tmdb_search, 0, t5, 30000, 1 + 4 + 8 + 2)
		if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		search = t5[id].Address:gsub('^tmdb_id_collections=','')
		m_simpleTV.Control.CurrentTitle_UTF8 = t5[id].Name
		local t6 = findCollectionForId(search)
		if t6 ~= '' then
		t6.ExtButton1 = {ButtonEnable = true, ButtonName = '✕'}
		t6.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('🔎 ' .. t5[id].Name, 0, t6, 30000, 1 + 4 + 8 + 2)
	if ret == 3 or not id then
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.ExecuteAction(11)
		 return
		end
		if ret == 2 then
		retAdr = inAdr
		end
	if ret == 1 then
		search = t6[id].Address:gsub('^tmdb_id=','')
		m_simpleTV.Control.CurrentTitle_UTF8 = t6[id].Name
		m_simpleTV.Control.ChangeChannelLogo(t6[id].InfoPanelLogo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
		search = imdbid(search,0)
		if search ~= '' then retAdr = getadr(search) end
		if retAdr and retAdr ~= '' then retAdr = retAdr .. '&imdb_id=' .. search else retAdr = '#' .. m_simpleTV.Common.UTF8ToMultiByte(t6[id].Name):gsub('%(.-$','') end
	end
	end
	end
	end
	end
	m_simpleTV.Http.Close(session)
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.ExecuteAction(37)
	m_simpleTV.Control.CurrentAddress = retAdr
	dofile(m_simpleTV.MainScriptDir_UTF8 .. 'user\\video\\video.lua')
	-- debug_in_file(retAdr .. '\n')