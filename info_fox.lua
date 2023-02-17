-- видеоскрипт для получения информации медиа по названию и году (17/02/23) - автор west_side
function info_fox(title,year,logo)
local userAgent = "Mozilla/5.0 (Windows NT 10.0; rv:85.0) Gecko/20100101 Firefox/85.0"
local session =  m_simpleTV.Http.New(userAgent)
if not session then return end
m_simpleTV.Http.SetTimeout(session, 8000)

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

local function promo_tm(tmid)
local urltm = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9tb3ZpZS8=') .. tmid .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmYXBwZW5kX3RvX3Jlc3BvbnNlPXZpZGVvcyZsYW5ndWFnZT1ydQ==')
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
else promo = ''
end

if tab and tab.genres then
 local j = 1
	while true do
		if not tab.genres[j]
		then
		break
		end
 genre = genre .. tab.genres[j].name .. ', '
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
 country = country .. tab.production_countries[j].name .. ', '
 j=j+1
 end
 country = country:gsub(', $', '')
 else
 country = ''
 end

if tab and tab.tagline then slogan = tab.tagline else slogan = '' end

return promo, genre, country, slogan
end

local function bg_poster_title(title, year)

local urld = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&year=' .. year
local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
if rc1~=200 then
  m_simpleTV.Http.Close(session)
  return
end
require('json')
answerd = answerd:gsub('(%[%])', '"nil"')
local tab = json.decode(answerd)
	if not tab or not tab.results[1]
	then
	local urld2 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1ydSZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&first_air_date_year=' .. year
local rc2,answerd2 = m_simpleTV.Http.Request(session,{url=urld2})
if rc2~=200 then
  m_simpleTV.Http.Close(session)
  return
end
require('json')
answerd2 = answerd2:gsub('(%[%])', '"nil"')

local tab = json.decode(answerd2)
	if not tab or not tab.results[1]
	then
	background, poster, overview, rating, count, ru_name, orig_name, promo, genre, country, slogan, tmid = '', '', '', '', '', '', '', '', '', '', '', ''
	else
	if tab.results[1].poster_path and tab.results[1].poster_path ~= 'null' then
	poster = tab.results[1].poster_path
	poster = 'http://image.tmdb.org/t/p/original' .. poster
	else poster = logo
	end
	if tab.results[1].backdrop_path and tab.results[1].backdrop_path ~= 'null'
	then
	background = tab.results[1].backdrop_path
	background = 'http://image.tmdb.org/t/p/original' .. background
	else background = logo
	end

	overview = tab.results[1].overview
	rating = tab.results[1].vote_average
	count = tab.results[1].vote_count
	ru_name = tab.results[1].name
	orig_name = tab.results[1].original_name
	tmid = tab.results[1].id
	promo, genre, country, slogan = '', 'сериал', '', ''

end
	else
	if tab.results[1].poster_path and tab.results[1].poster_path ~= 'null' then
	poster = tab.results[1].poster_path
	poster = 'http://image.tmdb.org/t/p/original' .. poster
	else poster = logo
	end
	if tab.results[1].backdrop_path and tab.results[1].backdrop_path ~= 'null'
	then
	background = tab.results[1].backdrop_path
	background = 'http://image.tmdb.org/t/p/original' .. background
	else background = logo
	end

	overview = tab.results[1].overview
	rating = tab.results[1].vote_average
	count = tab.results[1].vote_count
	ru_name = tab.results[1].title
	orig_name = tab.results[1].original_title
	tmid = tab.results[1].id
	promo, genre, country, slogan = promo_tm(tmid)
end
	return background, poster, overview, rating, count, ru_name, orig_name, promo, genre, country, slogan, tmid
end

local function tmdb_eng(title, year)

local urle = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvbW92aWU/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1lbiZleHRlcm5hbF9zb3VyY2U9aW1kYl9pZCZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&year=' .. year
local rc3,answere = m_simpleTV.Http.Request(session,{url=urle})
if rc3~=200 then
  m_simpleTV.Http.Close(session)
  return ''
end
require('json')
answere = answere:gsub('(%[%])', '"nil"')
local tab = json.decode(answere)
	if not tab or not tab.results[1] or not tab.results[1].overview
	then
	local urle2 = decode64('aHR0cHM6Ly9hcGkudGhlbW92aWVkYi5vcmcvMy9zZWFyY2gvdHY/YXBpX2tleT1kNTZlNTFmYjc3YjA4MWE5Y2I1MTkyZWFhYTc4MjNhZCZsYW5ndWFnZT1lbiZxdWVyeT0=') .. m_simpleTV.Common.toPercentEncoding(title) .. '&first_air_date_year=' .. year
local rc4,answere2 = m_simpleTV.Http.Request(session,{url=urle2})
if rc4~=200 then
  m_simpleTV.Http.Close(session)
  return
end
require('json')
answere2 = answere2:gsub('(%[%])', '"nil"')
local tab = json.decode(answere2)
	if not tab or not tab.results[1]
	then
     overviewe = ''
	else
	 overviewe = tab.results[1].overview
    end
    else
	 overviewe = tab.results[1].overview
    end
	return overviewe
end


urlb = decode64('aHR0cHM6Ly9iYXpvbi5jYy9hcGkvc2VhcmNoP3Rva2VuPWMxMThlYjVmOGQzNjU2NWIyYjA4YjUzNDJkYTk3Zjc5JnRpdGxlPQ==') .. m_simpleTV.Common.toPercentEncoding(title)
local rc,answer = m_simpleTV.Http.Request(session,{url=urlb})
if rc~=200 then
  m_simpleTV.Http.Close(session)
  return
end

require('json')
  answer = answer:gsub('%[%]', '"nil"'):gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/')
  local tab = json.decode(answer)

if not tab or not tab.results then
local background, poster, overview, rating, count, ru_name, orig_name, promo, genre, country, slogan, tmid = bg_poster_title(title, year)
if overview == '' and tmid~=''
then
overview = tmdb_eng(title, year) or ''
end
if background and poster and genre and tmid ~= '' and country and slogan then
		if promo and promo ~= '' then
		str_poisk = '<a href = "simpleTVLua:m_simpleTV.Control.PlayAddress(\'' .. promo .. '\')"><img src="simpleTVImage:./luaScr/user/show_mi/trailer.png" height="43"></a>'
		else
		str_poisk = ''
		end
		videodesc= '<table width="100%"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="300"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h3><font color=#00FA9A>' .. ru_name .. '</font></h3><h5><i><font color=#CCCCCC>' .. slogan .. '</font></i></h5><h4>' .. str_poisk .. '</h4><h5><font color=#BBBBBB>' .. orig_name .. '</font></h5><h5><font color=#E0FFFF>' .. country .. ' ' .. year .. '</font></h5><h5><font color=#EBEBEB>' .. genre .. '</font></h5><h5><img src="simpleTVImage:./luaScr/user/show_mi/menuTM.png" height="24" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. (tonumber(rating)*10 - tonumber(rating)*10%1)/10 .. '.png" height="24" align="top"> ' .. rating .. ' (' .. count .. ')</h5><h5>' .. overview .. '</h5></td></tr></table>'
		videodesc = videodesc:gsub('"', '\"')
	m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.5" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/show_mi/menuTM1.png"', text = ru_name .. '\n' .. orig_name .. '\n' .. year .. '\n' .. country .. '\n' .. genre , showTime = 5000,0xFF00,3})

return videodesc, background
 else
 return '', ''
end
else
		local background, poster, overview, rating, count, ru_name, orig_name, promo = '', '', '', '', '', '', '', ''
		local t, i, reting = {}, 1, ''
		local j = 1
			while true do
				if not tab.results[j]
				then
				break
				end
				if tab.results[j].info and tab.results[j].info.year and math.abs( tonumber(tab.results[j].info.year) - tonumber(year) ) <= 1 and tab.results[j].info.rus and ( xren(tab.results[j].info.rus):gsub('&nbsp;', ' '):gsub('&#151;', '-'):gsub(':', ' '):gsub('%.', ' '):gsub('%-', ' '):gsub('  ', ' ') == xren(title):gsub(':', ' '):gsub('%.', ' '):gsub('%-', ' '):gsub('  ', ' ') or xren(tab.results[j].info.orig):gsub('&nbsp;', ' '):gsub('&#151;', '-'):gsub(':', ' '):gsub('%.', ' '):gsub('%-', ' '):gsub('  ', ' ') == xren(title):gsub(':', ' '):gsub('%.', ' '):gsub('%-', ' '):gsub('  ', ' ')) then
					t[i] = {}
					yearb = tab.results[j].info.year or ''
					t[i].rus = tab.results[j].info.rus:gsub('&nbsp;', ' '):gsub('&#151;', '-') or ''
					t[i].orig = tab.results[j].info.orig:gsub('&nbsp;', ' '):gsub('&#151;', '-'):gsub('A Town Called Bastard', 'A Town Called Hell') or ''
					background, poster, overview, rating, count, ru_name, orig_name, promo, tmid = bg_poster_title(t[i].orig, year)
					if not background and not poster or poster == '' then
					background, poster = tab.results[j].info.poster or logo, tab.results[j].info.poster or logo end
					if tab.results[j].info.rating then
					kpR = math.floor(tonumber(tab.results[j].info.rating.rating_kp)*10)/10 or ''
					imdbR = math.floor(tonumber(tab.results[j].info.rating.rating_imdb)*10)/10 or ''
					vote_kpR = tab.results[j].info.rating.vote_num_kp or ''
					vote_imdbR = tab.results[j].info.rating.vote_num_imdb or ''
					if kpR ~= '' then
					reting = reting .. '<h5><img src="simpleTVImage:./luaScr/user/show_mi/menuKP.png" height="36" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. kpR .. '.png" height="36" align="top"> ' .. kpR .. ' (' .. vote_kpR .. ')</h5>'
					end
					if reting_imdb ~= '' then
					reting = reting .. '<h5><img src="simpleTVImage:./luaScr/user/show_mi/menuIMDb.png" height="36" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. imdbR .. '.png" height="36" align="top"> ' .. imdbR .. ' (' .. vote_imdbR .. ')</h5>'
					end
					end
					kpid = tab.results[j].kinopoisk_id or ''
					country = tab.results[j].info.country or ''
					country = country:gsub(', ', ','):gsub(',', ', ')
					year = tab.results[j].info.year or ''
					director = tab.results[j].info.director or ''
					director = director:gsub(', ', ','):gsub(',', ', ')
					actors = tab.results[j].info.actors or ''
					actors = actors:gsub(', ', ','):gsub(',', ', ')
					t[i].genres = tab.results[j].info.genre or ''
					description = tab.results[j].info.description:gsub('&amp;#151;', ' – '):gsub('&#151;', ' - '):gsub('\\n', ' '):gsub('\\r', ' '):gsub('\n', ' '):gsub('&nbsp;', ' '):gsub('&laquo;', '«'):gsub('&raquo;', '»'):gsub('\r', ' ')
				    t[i].genres = t[i].genres:gsub(', ', ','):gsub(',', ', ')
					slogan = tab.results[j].info.slogan or ''
					if slogan ~= '' then slogan = ' «' .. slogan .. '» ' end
					age = tab.results[j].info.age or ''
					time_all = tab.results[j].info.time or ''

					if promo and promo ~= '' then
					str_poisk = '<a href = "simpleTVLua:m_simpleTV.Control.PlayAddress(\'' .. promo .. '\')"><img src="simpleTVImage:./luaScr/user/show_mi/trailer.png" height="43"></a>'
					else
					str_poisk = ''
					end

	local function get_country_flags(country_ID)
    country_flag = '<img src="simpleTVImage:./luaScr/user/show_mi/country/' .. country_ID .. '.png" height="36" align="top">'
    return country_flag:gsub('"', "'")
	end

	local tmp_country_ID = ''
	country_ID = ''
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
		t[i].country = country

					t[i].videodesc = '<table width="100%" border="0"><tr><td style="padding: 15px 15px 5px;"><img src="' .. (poster or logo) .. '" height="300"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h4><font color=#00FA9A>' .. t[i].rus .. '</font></h4><h5><i><font color=#CCCCCC>' .. slogan .. '</font></i></h5><h4>' .. str_poisk .. '</h4><h5><font color=#BBBBBB>' .. t[i].orig .. '<h5><font color=#EBEBEB>' .. country_ID .. ' ' .. t[i].country .. ' </font><font color=#E0FFFF>' .. yearb .. '</font></h5><h5><font color=#EBEBEB>' .. t[i].genres .. '</font> • ' .. age .. '+</h5>' .. reting .. '<h5><font color=#E0FFFF>' .. tonumber(time_all)/60 .. ' мин.</font></h5><h5>Режиссер: <font color=#EBEBEB>' .. director .. '</font><br>В ролях: <font color=#EBEBEB>' .. actors .. '</font></h5></td></tr></table><table width="100%"><tr><td style="padding: 5px 5px 5px;"><h5><font color=#EBEBEB>' .. description .. '</font></h5></td></tr></table>'
					t[i].videodesc = t[i].videodesc:gsub('"', '\"')
					t[i].background = background
					i = i + 1
				end
				j = j + 1
			end

if t[1] and t[1].videodesc and t[1].background
then
m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.5" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/show_mi/menuKP1.png"', text = t[1].rus .. '\n' .. t[1].orig .. '\n' .. year .. '\n' .. t[1].country .. '\n' .. t[1].genres , showTime = 5000,0xFF00,3})

return t[1].videodesc, t[1].background
else
local background, poster, overview, rating, count, ru_name, orig_name, promo, genre, country, slogan, tmid = bg_poster_title(title, year)
if background and poster and poster ~= '' and genre and tmid ~= '' and country then
		if promo and promo ~= '' then
		str_poisk = '<a href = "simpleTVLua:m_simpleTV.Control.PlayAddress(\'' ..promo .. '\')"><img src="simpleTVImage:./luaScr/user/show_mi/trailer.png" height="43"></a>'
		else
		str_poisk = ''
		end
		videodesc= '<table width="100%"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="300"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h3><font color=#00FA9A>' .. ru_name .. '</font></h3><h5><i><font color=#CCCCCC>' .. slogan .. '</font></i></h5><h4>' .. str_poisk .. '</h4><h5><font color=#BBBBBB>' .. orig_name .. '</font></h5><h5><font color=#E0FFFF>' .. country .. ' ' .. year .. '</font></h5><h5><font color=#EBEBEB>' .. genre .. '</font></h5><h5><img src="simpleTVImage:./luaScr/user/show_mi/menuTM.png" height="24" align="top"> <img src="simpleTVImage:./luaScr/user/show_mi/stars/' .. (tonumber(rating)*10 - tonumber(rating)*10%1)/10 .. '.png" height="24" align="top"> ' .. rating .. ' (' .. count .. ')</h5><h5>' .. overview .. '</h5></td></tr></table>'
		videodesc = videodesc:gsub('"', '\"')
m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="2.5" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/show_mi/menuTM1.png"', text = ru_name .. '\n' .. orig_name .. '\n' .. year .. '\n' .. country .. '\n' .. genre , showTime = 5000,0xFF00,3})

return videodesc, background
 else
 return '', '' end
end
end
end