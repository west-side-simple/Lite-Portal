--HDRezka portal - lite version west_side 06.04.25

if not m_simpleTV.User then
	m_simpleTV.User = {}
end

if not m_simpleTV.User.rezka then
	m_simpleTV.User.rezka = {}
end

if not m_simpleTV.User.TVPortal then
	m_simpleTV.User.TVPortal = {}
end

if not m_simpleTV.User.stena_rezka then
	m_simpleTV.User.stena_rezka = {}
end

if not m_simpleTV.User.stena_rezka.back then
	m_simpleTV.User.stena_rezka.back = {}
end

local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end

local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end

	m_simpleTV.User.stena_rezka.back.filter_type = getConfigVal('rezka_filter_type') or 'watching'
	local t1 = {
	{'last','Поступления'},
	{'popular','Популярные'},
	{'watching','Смотрят'},
	}
	for j=1,3 do
		if m_simpleTV.User.stena_rezka.back.filter_type == t1[j][1] then
			m_simpleTV.User.stena_rezka.back.filter_type_name = t1[j][2]
			break
		end
	end

	m_simpleTV.User.stena_rezka.back.pls_type = getConfigVal('rezka_pls_type') or 'table'
	local t2 = {
	{'table','Таблица'},
	{'karusel','Карусель'},
	}
	for j=1,2 do
		if m_simpleTV.User.stena_rezka.back.pls_type == t2[j][1] then
			m_simpleTV.User.stena_rezka.back.pls_type_name = t2[j][2]
			break
		end
	end

local function GetFavCat()
	local session = m_simpleTV.Http.New('Mozilla/5.0')
	if not session then
		return
	end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	local host
	if current_zerkalo ~= '' then
	host = current_zerkalo:gsub('/$','')
	else
	host = 'https://hdrezka.ag'
	end
	rc, answer = m_simpleTV.Http.Request(session, {url = host .. '/favorites/', method = 'get', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
--	debug_in_file((answer or 'NOT') .. '\n','c://1/avt_rezka.txt')
	if not answer then return end

	local tf,i = {},1
	for w in answer:gmatch('<a class="b%-favorites_content__cats_list_link.-</a>') do
		local adr,name,num = w:match('href="(.-)".-<span class="name">(.-)</span>.-<span class="num%-holder">(.-)</span>')
		if not adr or not name or not num then break end
		tf[i] = {}
		tf[i].Id = i
		tf[i].Address = adr
		tf[i].Name = name .. ' ' .. num:gsub('<.->','')
		i = i + 1
	end
	m_simpleTV.Http.Close(session)
	m_simpleTV.Common.Sleep(200)
	return tf
end

local function flag_favorites(id_rezka)
	if not m_simpleTV.User.rezka.favorites or not id_rezka then return '' end
	local session_res = {}
	for i = 1,#m_simpleTV.User.rezka.favorites do
		local url = m_simpleTV.User.rezka.favorites[i].Address
		session_res[i] = m_simpleTV.Http.New('Mozilla/5.0')
		if not session_res[i] then return '' end
		m_simpleTV.Http.SetTimeout(session_res[i], 4000)
		local rc, answer = m_simpleTV.Http.Request(session_res[i], {url = url, method = 'get', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
		if rc~=200 or not answer then return '' end
--		debug_in_file(answer .. '\n','c://1/flag_rezka.txt')
		for w in answer:gmatch('<div class="b%-content__inline_item".-</div></div>') do
			local adr = w:match('url="(.-)"')
			if not adr then break end
--		debug_in_file(id_rezka .. '\n----\n' .. url .. ' * ' .. w .. ' * ' .. adr:match('/(%d+)') .. '\n','c://1/check_flag_rezka.txt')
			if tonumber(adr:match('/(%d+)')) == tonumber(id_rezka) then return '📌 ' end

		end
		m_simpleTV.Http.Close(session_res[i])
		m_simpleTV.Common.Sleep(200)
	end
	return ''
end

function set_page(filter,filter_name,current_page,max_num)

	local t = {}
	for i = 1,tonumber(max_num) do
		t[i] = {}
		t[i].Id = i
		t[i].Name = i
	end
	m_simpleTV.Common.Sleep(200)
	local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Select page: ' .. filter_name, tonumber(current_page)-1, t, 10000, 1+4+8+2)
	if id == nil then
		return
	end
	if ret == 1 then
		return last_rezka(filter,filter_name,id)
	end
end

function rezka_autorization()
	m_simpleTV.User.rezka.account = nil
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	local host
	if current_zerkalo ~= '' then
	host = current_zerkalo:gsub('/$','')
	else
	host = 'https://hdrezka.ag'
	end
--	local host = 'https://hdrezka.ag'
	local sessionHDRezka = m_simpleTV.Http.New('Mozilla/5.0')
	if not sessionHDRezka then return end
	m_simpleTV.Http.SetTimeout(sessionHDRezka, 2000)
	local res, login, password, header = xpcall(function() require('pm') return pm.GetPassword('rezka') end, err)
	if not login or not password or login == '' or password == '' then
		m_simpleTV.User.rezka.cookies = ''
	else
		local rc, answer = m_simpleTV.Http.Request(sessionHDRezka, {body = 'login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login_not_save=0', url = host .. '/ajax/login/', method = 'post', headers = 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8\nX-Requested-With: XMLHttpRequest\nReferer: ' .. host})
--		debug_in_file('login_name=' .. m_simpleTV.Common.toPercentEncoding(login) .. '&login_password=' .. m_simpleTV.Common.toPercentEncoding(password) .. '&login_not_save=0\n' .. answer .. '\n','c://1/avt_rezka.txt')
		if answer and answer:match('"success":true') then
			m_simpleTV.User.rezka.cookies = m_simpleTV.Http.GetCookies(sessionHDRezka,host)
			rc, answer = m_simpleTV.Http.Request(sessionHDRezka, {url = host .. '/favorites/', method = 'get', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
			if answer then
				answer = answer:match('<li class="b%-tophead%-premuser">Осталось <b>(.-)</b>')
				if answer then
					m_simpleTV.User.rezka.account = answer
--					m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="https://hdrezka.ag/templates/hdrezka/images/hd_prem_logo.png"', text = '  ' .. answer, color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
				end
			end
--			debug_in_file(answer .. '\n','c://1/avt_rezka.txt')
			if not m_simpleTV.User.rezka.favorites then
				m_simpleTV.User.rezka.favorites = GetFavCat()
			end
			local url = host .. '/ajax/favorites/'
			local headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies
			local name_cat = {'Мои фильмы','Мои сериалы','Мои мультфильмы','Мои аниме'}

			for i = 1,#name_cat do
				local my_cat = nil
				if m_simpleTV.User.rezka.favorites and #m_simpleTV.User.rezka.favorites then
					for j = 1,#m_simpleTV.User.rezka.favorites do
						if m_simpleTV.User.rezka.favorites[j].Name:match(name_cat[i]) then
							my_cat = true
						end
					end
				end
				if not my_cat or my_cat == nil then
					local body = 'name=' .. name_cat[i] .. '&action=add_cat'
					rc, answer = m_simpleTV.Http.Request(sessionHDRezka, {url = url, method = 'post', body = body, headers = headers})
					m_simpleTV.Common.Sleep(200)
				end
				i = i + 1
			end

--			debug_in_file(m_simpleTV.User.rezka.cookies .. '\n','c://1/avt_rezka.txt')
		else
			m_simpleTV.User.rezka.cookies = ''
		end
	end
	m_simpleTV.Http.Close(sessionHDRezka)
end

local function update_phpsesid()
	local cookie = m_simpleTV.Interface.CopyFromClipboard()
	if cookie:match('PHPSESSID') then
		m_simpleTV.User.ZF.cookies = cookie
	end
end

local function GetBalanser(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = decode64('aHR0cHM6Ly9nby56ZWZsaXgub25saW5lL2lwbGF5ZXIvdmlkZW9kYi5waHA/a3A9') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url, method = 'get', headers = 'User-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36\nReferer: ' .. 'https://go.zeflix.online/iplayer/player.php\nCookie: ' .. m_simpleTV.User.ZF.cookies})
	if rc==200 and answer:match('^<script>') then return '' end
	if rc ~= 200 or answer:match('video_not_found') or (not answer:match('%.mp4') and not answer:match('%.m3u8')) then return false end
--	debug_in_file(answer .. '\n','c://1/zf.txt')
	return url
end

local function GetBalanser_new(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local url = decode64('aHR0cHM6Ly9oaWR4bGdsay5kZXBsb3kuY3gvbGl0ZS96ZXRmbGl4P2tpbm9wb2lza19pZD0=') .. kp_id
	local rc,answer = m_simpleTV.Http.Request(session,{url = url})
	m_simpleTV.Http.Close(session)
--	debug_in_file(url .. '\n' .. answer,'c://1/deb_zf.txt')
	if rc==200 and answer:match('data%-json') then
		return url
	end
	return false
end

function create_collection()
	local session = m_simpleTV.Http.New('Mozilla/5.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local url = 'https://hdrezka.ag/collections/'
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end

		local t,i = {},1
		for j=1,5 do
			local rc,answer = m_simpleTV.Http.Request(session,{url=url .. 'page/' .. j .. '/', method = 'get', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
			if rc ~= 200 then return '' end
			for w in answer:gmatch('<div class="b%-content__collections_item".-</div></div>') do
				local adr,logo,num,name = w:match('url="(.-)".-src="(.-)".-tooltip">(%d+).-"title">(.-)<')
				if not adr or not name then break end
					t[i] = {}
					t[i].Id = i
					t[i].Name = name .. ' (' .. num .. ')'
					t[i].Address = adr
					t[i].Logo = logo
					if not stena_rezka then
						t[i].InfoPanelLogo = logo
						t[i].InfoPanelName = 'Rezka collection: ' .. name
						t[i].InfoPanelShowTime = 10000
					end
				i=i+1
			end
			j=j+1
			m_simpleTV.Common.Sleep(200)
		end
		m_simpleTV.User.stena_rezka.back.collection = t
		m_simpleTV.Http.Close(session)
end

function ADD_to_favorites_rezka(adr)
	if not m_simpleTV.User.rezka.favorites then return end
	local function check_in_favorites_catalog(name)
		for i = 1,#m_simpleTV.User.rezka.favorites do
			if m_simpleTV.User.rezka.favorites[i].Name:match(name) then
				return m_simpleTV.User.rezka.favorites[i].Address:match('/(%d+)')
			end
		end
	end
	local host
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	host = current_zerkalo:gsub('/$','')
	else
	host = 'https://hdrezka.ag'
	end
	local id_rezka = adr:match('/(%d+)')
	local id_cat = adr:match('//.-/(.-)/')
	if id_cat == 'films' then
		id_cat = check_in_favorites_catalog('Мои фильмы')
	elseif id_cat == 'series' then
		id_cat = check_in_favorites_catalog('Мои сериалы')
	elseif id_cat == 'cartoons' then
		id_cat = check_in_favorites_catalog('Мои мультфильмы')
	elseif id_cat == 'animation' then
		id_cat = check_in_favorites_catalog('Мои аниме')
	end
	if not id_cat or not id_cat:match('%d+') then id_cat = m_simpleTV.User.rezka.favorites[1].Address:match('/(%d+)') end
	local session = m_simpleTV.Http.New('Mozilla/5.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local body = 'post_id=' .. id_rezka .. '&cat_id=' .. id_cat .. '&action=add_post'
	local headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies
	local rc, answer = m_simpleTV.Http.Request(session, {url = host .. '/ajax/favorites/', method = 'post', body = body, headers = headers})
	m_simpleTV.Http.Close(session)
	m_simpleTV.Common.Sleep(200)
--	debug_in_file(id_rezka..'/' .. id_cat .. '/' .. rc .. '/' .. unescape3 (answer) .. '\n')
end

function favorites_cat_rezka(cat_adr,cat_name)
	local session = m_simpleTV.Http.New('Mozilla/5.0')
		if not session then
			return
		end
		m_simpleTV.Http.SetTimeout(session, 6000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = cat_adr, method = 'get', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
--		debug_in_file(answer .. '\n','c://1/avt_rezka.txt')
		local t,i = {},1
		for w in answer:gmatch('<div class="b%-content__inline_item".-</div></div>') do
			local adr,logo,type_media,name,desc = w:match('url="(.-)".-src="(.-)".-"entity">(.-)<.-href=".-">(.-)<.-<div>(.-)</div>')
			if not adr or not name then break end
			t[i] = {}
			t[i].Id = i
			t[i].Name = name .. ' (' .. desc .. ') - ' .. type_media
			t[i].Address = adr
			t[i].Logo = logo
			t[i].title_name = name
			t[i].title_desc = desc .. '\n' .. type_media
			if not rezka_info then
			t[i].InfoPanelLogo = logo
			t[i].InfoPanelName = name .. ' (' .. desc .. ')'
			t[i].InfoPanelShowTime = 10000
			end
			i=i+1
		end
		m_simpleTV.Http.Close(session)
		m_simpleTV.Common.Sleep(200)

		if not m_simpleTV.User.stena_rezka.back then
			m_simpleTV.User.stena_rezka.back = {}
		end

		m_simpleTV.User.stena_rezka.back.item = t
		m_simpleTV.User.stena_rezka.back.title = 'FavHDRezka: ' .. cat_name:gsub(' %(.-$','') .. ' (' .. #t .. ')'
		m_simpleTV.User.stena_rezka.back.type = 'favorite_' .. cat_adr
		m_simpleTV.User.stena_rezka.back.max_num = nil
		m_simpleTV.User.stena_rezka.back.prev_num = nil
		m_simpleTV.User.stena_rezka.back.next_num = nil
		m_simpleTV.User.stena_rezka.back.current_page = nil
		m_simpleTV.User.stena_rezka.back.current_page_karusel = nil
		if stena_rezka then
			dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\startup\\desc_gt_rezka.lua')
			return stena_rezka()
		end


	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Rezka '}
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Favorites '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('FavHDRezka: ' .. cat_name,0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.stena_rezka.back.item_id = id
			media_info_rezka(t[id].Address)
		end
		if ret == 2 then
			favorites_rezka()
		end
		if ret == 3 then
			run_lite_qt_rezka()
		end
end

function favorites_rezka()
	local t = m_simpleTV.User.rezka.favorites
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Rezka '}
	t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Favorites HDRezka',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if not t[id].Name:match('%(0%)') then
				favorites_cat_rezka(t[id].Address,t[id].Name)
			else
				favorites_rezka()
			end
		end
		if ret == 2 then
			run_lite_qt_rezka()
		end
		if ret == 3 then
			run_westSide_portal()
		end
end

function run_lite_qt_rezka()

	if m_simpleTV.User.rezka.cookies == '' then
--		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="https://static.hdrezka.ac/templates/hdrezka/images/favicon.ico"', text = 'HDRezka: Для использования полного функционала медиапортала\nавторизуйтесь на сайте https://hdrezka.ag или на зеркале сайта при необходимости\nи внесите регистрационные данные в\nменеджере паролей для id rezka.\nРекомендуется вместо логина вводить email.', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
	end
	if m_simpleTV.User.rezka.cookies ~= '' then
		m_simpleTV.User.rezka.favorites = GetFavCat()
	end

	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or 'https://hdrezka.ag/'
	local last_adr = getConfigVal('info/rezka') or ''
	local tt = {}
	if io.open(m_simpleTV.MainScriptDir .. 'user/TVSources/m3u/out_Franchises.m3u', 'r') and ExaminFranchisesRezka() == true
	then
	    tt = {
		{"/","HDRezka: Горячие новинки"},
		{"/films/?filter=last","HDRezka: Фильмы, последние поступления"},
		{"/films/?filter=popular","HDRezka: Фильмы, популярные"},
		{"/films/?filter=watching","HDRezka: Фильмы, сейчас смотрят"},
		{"/series/?filter=last","HDRezka: Сериалы, последние поступления"},
		{"/series/?filter=popular","HDRezka: Сериалы, популярные"},
		{"/series/?filter=watching","HDRezka: Сериалы, сейчас смотрят"},
		{"/cartoons/?filter=last","HDRezka: Мультфильмы, последние поступления"},
		{"/cartoons/?filter=popular","HDRezka: Мультфильмы, популярные"},
		{"/cartoons/?filter=watching","HDRezka: Мультфильмы, сейчас смотрят"},
		{"/animation/?filter=last","HDRezka: Аниме, последние поступления"},
		{"/animation/?filter=popular","HDRezka: Аниме, популярные"},
		{"/animation/?filter=watching","HDRezka: Аниме, сейчас смотрят"},
		{"","Коллекции"},
		{"","Франшизы: Фильмы"},
		{"","Франшизы: Мультфильмы"},
		{"","Франшизы: Сериалы"},
		{"","Франшизы: Аниме"},
		{"","Обновление Франшиз"},
		{"","ПОИСК"},
		{"","Rezka зеркало"},
		}
	elseif ExaminFranchisesRezka() == true
	then
		tt = {
		{"/","HDRezka: Горячие новинки"},
		{"/films/?filter=last","HDRezka: Фильмы, последние поступления"},
		{"/films/?filter=popular","HDRezka: Фильмы, популярные"},
		{"/films/?filter=watching","HDRezka: Фильмы, сейчас смотрят"},
		{"/series/?filter=last","HDRezka: Сериалы, последние поступления"},
		{"/series/?filter=popular","HDRezka: Сериалы, популярные"},
		{"/series/?filter=watching","HDRezka: Сериалы, сейчас смотрят"},
		{"/cartoons/?filter=last","HDRezka: Мультфильмы, последние поступления"},
		{"/cartoons/?filter=popular","HDRezka: Мультфильмы, популярные"},
		{"/cartoons/?filter=watching","HDRezka: Мультфильмы, сейчас смотрят"},
		{"/animation/?filter=last","HDRezka: Аниме, последние поступления"},
		{"/animation/?filter=popular","HDRezka: Аниме, популярные"},
		{"/animation/?filter=watching","HDRezka: Аниме, сейчас смотрят"},
		{"","Коллекции"},
		{"","Франшизы"},
		{"","Обновление Франшиз"},
		{"","ПОИСК"},
		{"","Rezka зеркало"},
		}
    else
		tt = {
		{"/","HDRezka: Горячие новинки"},
		{"/films/?filter=last","HDRezka: Фильмы, последние поступления"},
		{"/films/?filter=popular","HDRezka: Фильмы, популярные"},
		{"/films/?filter=watching","HDRezka: Фильмы, сейчас смотрят"},
		{"/series/?filter=last","HDRezka: Сериалы, последние поступления"},
		{"/series/?filter=popular","HDRezka: Сериалы, популярные"},
		{"/series/?filter=watching","HDRezka: Сериалы, сейчас смотрят"},
		{"/cartoons/?filter=last","HDRezka: Мультфильмы, последние поступления"},
		{"/cartoons/?filter=popular","HDRezka: Мультфильмы, популярные"},
		{"/cartoons/?filter=watching","HDRezka: Мультфильмы, сейчас смотрят"},
		{"/animation/?filter=last","HDRezka: Аниме, последние поступления"},
		{"/animation/?filter=popular","HDRezka: Аниме, популярные"},
		{"/animation/?filter=watching","HDRezka: Аниме, сейчас смотрят"},
		{"","Коллекции"},
		{"","Франшизы"},
		{"","ПОИСК"},
		{"","Rezka зеркало"},
		}
	end
	local t0={}
		for i=1,#tt do
			t0[i] = {}
			t0[i].Id = i
			t0[i].Name = tt[i][2]
			t0[i].Action = tt[i][1]
		end
	if m_simpleTV.User.rezka.favorites and #m_simpleTV.User.rezka.favorites and #m_simpleTV.User.rezka.favorites > 0 then
		t0[#tt+1] = {}
		t0[#tt+1].Id = #tt+1
		t0[#tt+1].Name = 'Избранное'
		t0[#tt+1].Action = ''
	end
	if last_adr and last_adr ~= '' then
	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Info '}
	end
	t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	m_simpleTV.Common.Sleep(200)
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию Rezka',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t0[id].Name == 'ПОИСК' then
				search()
			elseif t0[id].Name == 'Избранное' then
				favorites_rezka()
			elseif t0[id].Name == 'Rezka зеркало' then
				zerkalo_rezka()
			elseif t0[id].Name:match('новинки') then
				get_start()
			elseif t0[id].Name:match('HDRezka') then
				last_rezka(t0[id].Action, t0[id].Name)
			elseif t0[id].Name == 'Коллекции' then
				collection_rezka()
			elseif t0[id].Name:match('Франшизы') then
				if t0[id].Name:match('Фильмы') then
				franchises_rezka_ganre('Фильмы')
				elseif t0[id].Name:match('Мультфильмы') then
				franchises_rezka_ganre('Мультфильмы')
				elseif t0[id].Name:match('Сериалы') then
				franchises_rezka_ganre('Сериалы')
				elseif t0[id].Name:match('Аниме') then
				franchises_rezka_ganre('Аниме')
				else
				franchises_rezka(current_zerkalo .. 'franchises/page/93/')
				end
			elseif t0[id].Name == 'Обновление Франшиз' then
				UpdateFranchisesRezka()
			end
		end
		if ret == 2 then
		media_info_rezka(last_adr)
		end
		if ret == 3 then
		run_westSide_portal()
		end
end

function zerkalo_rezka()
	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end
	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or 'https://hdrezka.ag/'
	local current_zerkalo_id = 0
	local tt = {
		{"https://hdrezka.ag/","Без зеркала"},
		{"https://rezkery.com/","https://rezkery.com/"},
		{"http://hdrezka.me/","http://hdrezka.me/"},
		{"https://rezka.fi/","https://rezka.fi/"},
		{"https://rezka-ua.in/","https://rezka-ua.in/"},
		{"https://rezka-ua.org/","https://rezka-ua.org/"},
		}

	local t0={}
		for i=1,#tt do
			t0[i] = {}
			t0[i].Id = i
			t0[i].Name = tt[i][2]
			t0[i].Action = tt[i][1]
			if t0[i].Action == current_zerkalo then current_zerkalo_id = i-1 end
			i=i+1
		end

	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' Rezka '}
	t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите зеркало Rezka',current_zerkalo_id,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			setConfigVal('zerkalo/rezka',t0[id].Action)
			rezka_autorization()
			zerkalo_rezka()
		end
		if ret == 2 then
			run_lite_qt_rezka()
		end
		if ret == 3 then
			run_westSide_portal()
		end
end

function get_start(id)
	m_simpleTV.User.stena_rezka.back.current_page_karusel = nil
--	debug_in_file(id .. '\n~~~~~~~~~~\n', 'c://1/req_rezka.txt')
	if not id or not id:match('_%d+') then id = '_0' end
	id = id:match('_(%d+)')
--	debug_in_file(id .. '\n~~~~~~~~~~\n', 'c://1/req_rezka.txt')
	local t, i = {}, 1
	local zerkalo = m_simpleTV.Config.GetValue('zerkalo/rezka','LiteConf.ini') or ''
	if zerkalo == '' then zerkalo = 'https://hdrezka.ag/' end
	local session = m_simpleTV.Http.New('Mozilla/5.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 4000)
	local url = zerkalo .. 'engine/ajax/get_newest_slider_content.php'
	local body = 'id=' .. id
	local headers = 'X-Requested-With: XMLHttpRequest\nCookie: '
	local rc, answer = m_simpleTV.Http.Request(session, {url = url, method = 'post', body = body, headers = headers})
--	debug_in_file(answer .. '\n~~~~~~~~~~\n', 'c://1/req_rezka.txt')
	m_simpleTV.Http.Close(session)
	if not answer then return end
	for w in answer:gmatch('data%-id=.-<div class="misc">.-</div>') do
		local logo, group, adr, name, title = w:match('<img src="(.-)".-<i class="entity">(.-)</i>.-<a href="(.-)">(.-)</a>.-<div class="misc">(.-)<')
		if not adr or not name then break end
		t[i] = {}
		t[i].Id = i
		t[i].Name = name .. ' (' .. (title:match('%d%d%d%d') or 0) .. ')'
		t[i].Logo = logo
		t[i].Address =  zerkalo .. adr:gsub('^http.-//.-/','')
		t[i].title_name = name
		t[i].title_desc = title or ''
		t[i].group = group
		i = i + 1
	end
	m_simpleTV.User.stena_rezka.back.item = t
	m_simpleTV.User.stena_rezka.back.type = 'start_' .. id
	m_simpleTV.User.stena_rezka.back.max_num = nil
	m_simpleTV.User.stena_rezka.back.prev_num = nil
	m_simpleTV.User.stena_rezka.back.next_num = nil
	m_simpleTV.User.stena_rezka.back.current_page = nil
	m_simpleTV.User.stena_rezka.back.title = 'HDRezka: Горячие новинки'
	if tostring(id) == '1' or tostring(id) == '2' or tostring(id) == '3' or tostring(id) == '82' then
		m_simpleTV.User.stena_rezka.back.title = m_simpleTV.User.stena_rezka.back.title .. ' - ' .. m_simpleTV.User.stena_rezka.back.item[1].group
	end
	m_simpleTV.Http.Close(session)
	m_simpleTV.Common.Sleep(200)
	return stena_rezka()
end

function last_rezka(filter,filter_name,page)

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

	if not m_simpleTV.User.stena_rezka.back then
		m_simpleTV.User.stena_rezka.back = {}
	end

	m_simpleTV.User.stena_rezka.back.filter_type = filter:match('filter=(.-)&') or filter:match('filter=(.-)$') or m_simpleTV.User.stena_rezka.back.filter_type or 'watching'
	m_simpleTV.User.stena_rezka.back.current_page_karusel = nil
	local t1 = {
	{'last','Поступления'},
	{'popular','Популярные'},
	{'watching','Смотрят'},
	}
	for j=1,3 do
		if m_simpleTV.User.stena_rezka.back.filter_type == t1[j][1] then
			m_simpleTV.User.stena_rezka.back.filter_type_name = t1[j][2]
			break
		end
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0')
	if not session then return end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	local url
	if current_zerkalo ~= '' then
		url = current_zerkalo:gsub('/$','')
	else
		url = 'https://hdrezka.ag'
	end

	m_simpleTV.Http.SetTimeout(session, 8000)
	local current_page = page or 1

	url = url .. filter:gsub('^https://.-/',''):gsub('/%?.-$','/') .. 'page/' .. current_page .. '/?filter=' .. m_simpleTV.User.stena_rezka.back.filter_type
	if filter == '/' then url = url .. filter end

	local rc,answer = m_simpleTV.Http.Request(session,{url= url, method = 'get', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})

--	debug_in_file(url .. '\nrc:' .. rc .. ' / ' .. filter .. '\n'
--	.. answer .. '\n'
--	,'c://1/test_rezka.txt')

		if rc ~= 200 and rc ~= 404 then return end

	local max = 45
	if filter == '/' then max = 36 end
	local t,i = {},1
		for w in answer:gmatch('<div class="b%-content__inline_item".-</div> %-%-> </div></div>') do
			local logo, adr, name, title = w:match('<img src="(.-)".-<a href="(.-)">(.-)</a> <div.->(.-)<')
			local info = w:match('<span class="info">(.-)</span>')
			if not adr or not name or i>max then break end
			t[i] = {}
			t[i].Id = i
			t[i].Name = name .. ' (' .. (title:match('%d%d%d%d') or 0) .. ')'
			t[i].Address =  adr:gsub('^/', url .. '/')
			t[i].Logo = logo
			t[i].title_name = name
			t[i].title_desc = title or ''
			if not rezka_info then
				t[i].InfoPanelLogo = logo
				t[i].InfoPanelName = name .. ' / ' .. (title or '')
				if info then
					t[i].InfoPanelTitle = info:gsub('<.->',' ')
				end
				t[i].InfoPanelShowTime = 10000
			end
			i = i + 1
		end

	m_simpleTV.User.stena_rezka.back.item = t

	if filter:match('/films/') then
		m_simpleTV.User.stena_rezka.back.type = 'films'
	end
	if filter:match('/series/') then
		m_simpleTV.User.stena_rezka.back.type = 'series'
	end
	if filter:match('/cartoons/') then
		m_simpleTV.User.stena_rezka.back.type = 'cartoons'
	end
	if filter:match('/animation/') then
		m_simpleTV.User.stena_rezka.back.type = 'animation'
	end

	local navigation = answer:match('<div class="b%-navigation">(.-)</div>')
	local max_num = 1
	if navigation then
		for w in navigation:gmatch('<a.-</a>') do
			local adr_page, num_page = w:match('<a.-href="(.-)">(.-)</a>')
			if not adr_page or not num_page then break end
			num_page = num_page:match('%d+')
			if num_page and tonumber(num_page) > tonumber(max_num) then max_num = num_page end
		end
	end
	if max_num and tonumber(max_num) < tonumber(current_page) then
		max_num = current_page
	end
--	debug_in_file(max_num .. ' | ' .. current_page .. ' / ' .. filter .. '\n')
	m_simpleTV.User.stena_rezka.back.max_num = max_num
	m_simpleTV.User.stena_rezka.back.prev_num = nil
	m_simpleTV.User.stena_rezka.back.next_num = nil
	m_simpleTV.User.stena_rezka.back.current_page = current_page
	if tonumber(current_page) > 1 then
		m_simpleTV.User.stena_rezka.back.prev_num = tonumber(current_page) - 1
	end
	if max_num and tonumber(current_page) < tonumber(max_num) then
		m_simpleTV.User.stena_rezka.back.next_num = tonumber(current_page) + 1
	end
	local add_to_name = ''
	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Back '}
	if max_num and tonumber(max_num) > 1 and filter ~= '/' then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Page '}
		add_to_name = ' (' .. current_page .. ' из ' .. max_num .. ')'
	end
	t.ExtParams = {FilterType = 0, AutoNumberFormat = '%1. %2'}
	m_simpleTV.Http.Close(session)
	m_simpleTV.Common.Sleep(200)
	if filter_name == '' then filter_name = 'Rezka New' end
	if stena_rezka then
		dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\startup\\desc_gt_rezka.lua')
		m_simpleTV.User.stena_rezka.back.title = filter_name .. add_to_name
		m_simpleTV.User.stena_rezka.back.filter = filter:gsub('%?.-$',''):gsub('^https://.-/','/')
		return stena_rezka()
	end
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(filter_name .. add_to_name,0,t,10000,1+4+8+2)
	if ret == -1 or not id then
		return
	end
	if ret == 1 then
		m_simpleTV.User.stena_rezka.back.item_id = id
		m_simpleTV.User.stena_rezka.back.title = filter_name .. add_to_name
		m_simpleTV.User.stena_rezka.back.filter = filter
		media_info_rezka(t[id].Address)
	end
	if ret == 2 then
		run_lite_qt_rezka()
	end
	if ret == 3 then
		set_page(filter,filter_name,current_page,max_num)
	end
end

function collection_rezka()
	if not m_simpleTV.User.stena_rezka.back.collection then
		create_collection()
	end
	m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_ID')
	m_simpleTV.User.stena_rezka.back.collection.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	m_simpleTV.User.stena_rezka.back.collection.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		m_simpleTV.Common.Sleep(200)
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите коллекцию Rezka (' .. #m_simpleTV.User.stena_rezka.back.collection .. ')',0,m_simpleTV.User.stena_rezka.back.collection,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.stena_rezka.back.collection.current_url = m_simpleTV.User.stena_rezka.back.collection[id].Address
			collection_rezka_url(m_simpleTV.User.stena_rezka.back.collection[id].Address,m_simpleTV.User.stena_rezka.back.collection[id].Logo,1)
		end
		if ret == 2 then
			run_westSide_portal()
		end
end

function collection_rezka_url(url,inlogo,page)
	local session = m_simpleTV.Http.New('Mozilla/5.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end
	if not m_simpleTV.User.stena_rezka.back.collection then m_simpleTV.User.stena_rezka.back.collection = {} end
	m_simpleTV.User.stena_rezka.back.collection.current_url = url
	local current_page = page or 1
	local rc,answer = m_simpleTV.Http.Request(session,{url= url .. 'page/' .. current_page .. '/', method = 'get', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
		if rc ~= 200 then return '' end
--	debug_in_file(answer..'\n')
	local title = answer:match('<h1>(.-)</h1>') or 'Rezka collection'
	local navigation = answer:match('<div class="b%-navigation">(.-)</div>') or ''
	local left,right = '',''
	for w in navigation:gmatch('<a.-</a>') do
	local adr_nav = w:match('href="(.-)"')
	if not adr_nav then break end
	if w:match('b%-navigation__prev') then
	left = w:match('href="(.-)"')
	end
	if w:match('b%-navigation__next') then
	right = w:match('href="(.-)"')
	end
	end

	local max_num = 1
	if navigation then
		for w in navigation:gmatch('<a.-</a>') do
			local adr_page, num_page = w:match('<a.-href="(.-)">(.-)</a>')
			if not adr_page or not num_page then break end
			num_page = num_page:match('%d+')
			if num_page and tonumber(num_page) > tonumber(max_num) then max_num = num_page end
		end
	end
	if max_num and tonumber(max_num) < tonumber(current_page) then
		max_num = current_page
	end
	m_simpleTV.User.stena_rezka.back.max_num = max_num
	m_simpleTV.User.stena_rezka.back.prev_num = nil
	m_simpleTV.User.stena_rezka.back.next_num = nil
	m_simpleTV.User.stena_rezka.back.current_page_karusel = nil
	m_simpleTV.User.stena_rezka.back.current_page = current_page
	if tonumber(current_page) > 1 then
		m_simpleTV.User.stena_rezka.back.prev_num = tonumber(current_page) - 1
	end
	if max_num and tonumber(current_page) < tonumber(max_num) then
		m_simpleTV.User.stena_rezka.back.next_num = tonumber(current_page) + 1
	end
	local add_to_name = ''
	if max_num and tonumber(max_num) > 1 then
		add_to_name = ' (' .. current_page .. ' из ' .. max_num .. ')'
	end
	local t,i = {},1
	for w in answer:gmatch('<div class="b%-content__inline_item".-</div></div>') do
			local adr,logo,type_media,name,desc = w:match('url="(.-)".-src="(.-)".-"entity">(.-)<.-href=".-">(.-)<.-<div>(.-)</div>')
			if not adr or not name then break end
				t[i] = {}
				t[i].Id = i
				t[i].Name = name .. ' (' .. desc .. ') - ' .. type_media
				t[i].Address = adr
				t[i].Logo = logo
				t[i].title_name = name
				t[i].title_desc = title or ''
				if not rezka_info then
					t[i].InfoPanelLogo = logo
					t[i].InfoPanelName = name .. ' (' .. desc .. ')'
					t[i].InfoPanelShowTime = 10000
				end
			i=i+1
		end
		if not m_simpleTV.User.stena_rezka.back.collection then
			create_collection()
		end
		m_simpleTV.User.stena_rezka.back.item = t
		m_simpleTV.User.stena_rezka.back.title = title:gsub('Смотреть ',''):gsub(' в HD онлайн',''):gsub('%&quot%;','') .. add_to_name
		m_simpleTV.User.stena_rezka.back.type = 'collection'
		m_simpleTV.User.stena_rezka.back.logo = nil
		if inlogo and inlogo ~= '' then
			m_simpleTV.User.stena_rezka.back.logo = inlogo
		elseif (not inlogo or inlogo == '') and m_simpleTV.User.stena_rezka.back.collection then
			local current_id_collection = url:match('/(%d+)')
			if current_id_collection then
				for j = 1, #m_simpleTV.User.stena_rezka.back.collection do
					local id_collection = m_simpleTV.User.stena_rezka.back.collection[j].Address:match('/(%d+)')
					if id_collection and tonumber(id_collection) == tonumber(current_id_collection) then
						m_simpleTV.User.stena_rezka.back.logo = m_simpleTV.User.stena_rezka.back.collection[j].Logo
						break
					end
				end
			end
		end
		m_simpleTV.Http.Close(session)
		m_simpleTV.Common.Sleep(200)
	if stena_rezka then
		dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\startup\\desc_gt_rezka.lua')
		return stena_rezka()
	end
	if left and left ~= ''
	then
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Prev '}
	else
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	end
	if right and right ~= '' then
		t.ExtButton1 = {ButtonEnable = true, ButtonName = ' Next '}
	end
	t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title .. ' (' .. #t .. ')',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.stena_rezka.back.item_id = id
			return media_info_rezka(t[id].Address)
		end
		if ret == 2 then
			if left and left ~= '' then
				collection_rezka_url(left,inlogo)
			else
				collection_rezka()
			end
		end
		if ret == 3 and right and right ~= '' then
			collection_rezka_url(right,inlogo)
		end
end

function menu_franchises(req)
	m_simpleTV.OSD.RemoveElement('STENA_TOOLTIP_ID')
	local current_zerkalo = m_simpleTV.Config.GetValue('zerkalo/rezka','LiteConf.ini') or 'https://hdrezka.ag/'
	local tt = {}
	if io.open(m_simpleTV.MainScriptDir .. 'user/TVSources/m3u/out_Franchises.m3u', 'r') and ExaminFranchisesRezka() == true
	then
	    tt = {
		{"","Франшизы: Фильмы"},
		{"","Франшизы: Мультфильмы"},
		{"","Франшизы: Сериалы"},
		{"","Франшизы: Аниме"},
		{"","Обновление Франшиз"},
		}
	elseif ExaminFranchisesRezka() == true
	then
		tt = {
		{"","Франшизы"},
		{"","Обновление Франшиз"},
		}
    else
		tt = {
		{"","Франшизы"},
		}
	end

	local t0={}
	for i=1,#tt do
		t0[i] = {}
		t0[i].Id = i
		t0[i].Name = tt[i][2]
		t0[i].Action = tt[i][1]
	end
	t0.ExtButton0 = {ButtonEnable = true, ButtonName = ' HDRezka '}
	t0.ExtButton1 = {ButtonEnable = true, ButtonName = ' Portal '}
	m_simpleTV.Common.Sleep(200)
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите категорию',0,t0,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			if t0[id].Name:match('Франшизы') then
				if t0[id].Name:match('Фильмы') then
				franchises_rezka_ganre('Фильмы')
				elseif t0[id].Name:match('Мультфильмы') then
				franchises_rezka_ganre('Мультфильмы')
				elseif t0[id].Name:match('Сериалы') then
				franchises_rezka_ganre('Сериалы')
				elseif t0[id].Name:match('Аниме') then
				franchises_rezka_ganre('Аниме')
				else
				franchises_rezka(current_zerkalo .. 'franchises/page/93/')
				end
			elseif t0[id].Name == 'Обновление Франшиз' then
				UpdateFranchisesRezka()
			end
		end
		if ret == 2 then
			return run_lite_qt_rezka()
		end
		if ret == 3 then
			return run_westSide_portal()
		end
end

function franchises_rezka(url)
	local session = m_simpleTV.Http.New('Mozilla/5.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''

	if url:match('STENA') then
		return menu_franchises()
	end

	url = 'https://hdrezka.ag/franchises/'
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end
	local rc,answer = m_simpleTV.Http.Request(session,{url= url, method = 'get', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
		if rc ~= 200 then return '' end
	local current_page = url:match('/page/(%d+)') or 1
	local navigation = answer:match('<div class="b%-navigation">(.-)</div>') or ''
	local left,right = '',''
	for w in navigation:gmatch('<a.-</a>') do
	local adr_nav = w:match('href="(.-)"')
	if not adr_nav then break end
	if w:match('b%-navigation__prev') then
	right = w:match('href="(.-)"')
	end
	if w:match('b%-navigation__next') then
	left = w:match('href="(.-)"')
	end
	end
	local t,i = {},1

		for w in answer:gmatch('<div class="b%-content__collections_item".-</div></div>') do
			local adr,logo,num,name = w:match('url="(.-)".-src="(.-)".-tooltip">(%d+).-"title">(.-)<')
			if not adr or not name then break end
				t[i] = {}
				t[i].Name = name .. ' (' .. num .. ')'
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].Logo = logo
				t[i].InfoPanelName = 'Rezka franchise: ' .. name
				t[i].InfoPanelShowTime = 10000
			i=i+1
		end
		m_simpleTV.Http.Close(session)
		m_simpleTV.Common.Sleep(200)
	local t1 = {}
		t1 = table_reverse(t)
		for i = 1, #t1 do
			t1[i].Id = i
		end
	if left and left ~= ''
	then
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' Prev '}
	else
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
	end
	if right and right ~= '' then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Next '}
	end
		t1.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Франшизы Rezka - стр. ' .. 94-tonumber(current_page) .. ' из 93',0,t1,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			franchises_rezka_url(t1[id].Address)
		end
		if ret == 2 then
		if left and left ~= ''
		then
			franchises_rezka(left)
		else
			run_lite_qt_rezka()
		end
		end
		if ret == 3 and right and right ~= ''
		then
			franchises_rezka(right)
		end
end

function franchises_rezka_ganre(ganre)
	local file = io.open(m_simpleTV.MainScriptDir .. 'user/TVSources/m3u/out_Franchises.m3u', 'r')
	local answer = file:read('*a')
	file:close()
	local t,i = {},1
		for w in answer:gmatch('EXTINF:.-\n.-\n') do
		local grp,logo,name,adr = w:match('group%-title="(.-)".-tvg%-logo="(.-)".-%,(.-)\n(.-)\n')
		if not grp or not logo or not name or not adr then break end
		if grp == ganre then
				t[i] = {}
				t[i].Id = i
				t[i].Name = name:gsub('Все части мультфильма ',''):gsub('Все части мультсериала ',''):gsub('Все мультфильмы про ','Про '):gsub('Все мультфильмы франшизы ',''):gsub('Все мультфильмы ',''):gsub('Все части фильма ',''):gsub('Все части сериала ',''):gsub('все части сериала ',''):gsub('Все части документального сериала ',''):gsub('Все фильмы про ','Про '):gsub('Все части франшизы ',''):gsub('Все части аниме ',''):gsub('Все мультфильмы серии ',''):gsub('Все фильмы серии ',''):gsub('%%2C','!')
				t[i].Address = adr
				t[i].InfoPanelLogo = logo
				t[i].Logo = logo
				t[i].InfoPanelName = 'Rezka franchise: ' .. name
				t[i].InfoPanelShowTime = 10000
			i=i+1
		end
		end
		t.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
		t.ExtParams = {FilterType = 1, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Франшизы: ' .. ganre .. ' (' .. #t .. ')',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			franchises_rezka_url(t[id].Address)
		end
		if ret == 2 then
			run_lite_qt_rezka()
		end
end

function franchises_rezka_url(url)
	local session = m_simpleTV.Http.New('Mozilla/5.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end
	local rc,answer = m_simpleTV.Http.Request(session,{url= url, method = 'get', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
		if rc ~= 200 then return '' end
	local title = answer:match('<h1>Смотреть (.-)</h1></div>') or 'Rezka franchises'
	local logo = answer:match('"og:image" content="(.-)"')
	local t,i = {},1
		for w in answer:gmatch('<div class="b%-post__partcontent_item".-</div></div>') do
			local adr,name,year = w:match('url="(.-)".-href=".-">(.-)<.-year">(.-)<')
			if not adr or not name then break end
				t[i] = {}
				t[i].Name = name .. ' (' .. year .. ')'
				t[i].Address = adr
				t[i].title_name = name
				t[i].title_desc = year
			i=i+1
		end
		local t1 = {}
		t1 = table_reverse(t)
		for i = 1, #t1 do
			t1[i].Id = i
		end

		if not m_simpleTV.User.stena_rezka.back then
			m_simpleTV.User.stena_rezka.back = {}
		end
		m_simpleTV.User.stena_rezka.back.item = t
		m_simpleTV.User.stena_rezka.back.title = title:gsub(' в HD онлайн','') .. ' (' .. #t .. ')'
		m_simpleTV.User.stena_rezka.back.logo = logo
		m_simpleTV.User.stena_rezka.back.type = 'franchise'
		m_simpleTV.User.stena_rezka.back.max_num = nil
		m_simpleTV.User.stena_rezka.back.prev_num = nil
		m_simpleTV.User.stena_rezka.back.next_num = nil
		m_simpleTV.User.stena_rezka.back.current_page = nil
		m_simpleTV.User.stena_rezka.back.adr_franchise = url
		m_simpleTV.Http.Close(session)
		m_simpleTV.Common.Sleep(200)
		if stena_rezka then
			dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\startup\\desc_gt_rezka.lua')
			return stena_rezka()
		end
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' Back '}
		if not title:match('сериал') then
		t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' Play '}
		end
		t1.ExtParams = {FilterType = 0, AutoNumberFormat = '%1. %2'}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title:gsub(' в HD онлайн','') .. ' (' .. #t1 .. ')',0,t1,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.stena_rezka.back.item_id = id
			media_info_rezka(t1[id].Address)
		end
		if ret == 2 then
			run_lite_qt_rezka()
		end
		if ret == 3 then
			m_simpleTV.Control.ChangeAddress = 'No'
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.CurrentAddress = url
			m_simpleTV.Control.PlayAddress(url)
		end
end

function UpdatePersonRezka()
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

function UpdateFranchisesRezka()
if package.loaded['tvs_core'] and package.loaded['tvs_func'] then
    local tmp_sources = tvs_core.tvs_GetSourceParam() or {}
    for SID, v in pairs(tmp_sources) do
         if v.name:find('Franchises')
		 then
		    tvs_core.UpdateSource(SID, false)
            tvs_func.OSD_mess('', -2)
         end
    end
end
end

function ExaminFranchisesRezka()
if package.loaded['tvs_core'] and package.loaded['tvs_func'] then
    local tmp_sources = tvs_core.tvs_GetSourceParam() or {}
    for SID, v in pairs(tmp_sources) do
         if v.name:find('Franchises')
		 then
			return true
         end
    end
	return false
end
end

function person_rezka_work(url)
	local session = m_simpleTV.Http.New('Mozilla/5.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end
	local rc,answer = m_simpleTV.Http.Request(session,{url= url, method = 'get', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
		if rc ~= 200 then return '' end
	local title1 = answer:match('<h1><span class="t1" itemprop="name">(.-)</span>') or 'Rezka person'

	local logo_person = answer:match('<img itemprop="image" src="(.-)"') or 'https://static.hdrezka.ac/templates/hdrezka/images/avatar.png'
	local desc = answer:match('<h1><span class="t1".-<div class="b%-person__career">') or ''
	desc = desc:gsub('<span class="t2" itemprop="alternativeHeadline">','\n'):gsub('<h2>','\n'):gsub('<.->',''):gsub('Смотреть все.-$','')
	if not rezka_info then
	m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="4.0" src="' .. logo_person .. '"', text = desc, color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
	end
	local t,i = {},1
	for w in answer:gmatch('<div class="b%-content__inline_item.-</div> %-%-> </div></div>') do
	local logo, group, adr, name, title = w:match('<img src="(.-)".-<span class="(.-)".-<a href="(.-)">(.-)</a> <div class="misc">(.-)<')
	if not adr or not name then break end
	t[i] = {}
	t[i].Name = name .. ' (' .. title .. ') - ' .. group:gsub('cat ','')
	t[i].Address = adr
	t[i].Logo = logo
	t[i].title_name = name
	t[i].title_desc = title .. '\n' .. group:gsub('cat ','')
	if not rezka_info then
	t[i].InfoPanelLogo = logo
	t[i].InfoPanelName = 'Rezka info: ' .. name .. ' (' .. title .. ')'
	t[i].InfoPanelShowTime = 10000
	end
	i=i+1
	end
		local hash, res = {}, {}
		for i = 1, #t do
		t[i].Address = tostring(t[i].Address)
			if not hash[t[i].Address] then
				res[#res + 1] = t[i]
				hash[t[i].Address] = true
			end
		end
		for i = 1, #res do
			res[i].Id = i
		end
		local AutoNumberFormat, FilterType
			if #res > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end

		if not m_simpleTV.User.stena_rezka.back then
			m_simpleTV.User.stena_rezka.back = {}
		end
		m_simpleTV.User.stena_rezka.back.item = res
		m_simpleTV.User.stena_rezka.back.title = title1 .. ' (' .. #res .. ')'
		m_simpleTV.User.stena_rezka.back.logo = logo_person
		m_simpleTV.User.stena_rezka.back.adr_person = url
		m_simpleTV.User.stena_rezka.back.desc_person = desc
		m_simpleTV.User.stena_rezka.back.type = 'person'
		m_simpleTV.User.stena_rezka.back.max_num = nil
		m_simpleTV.User.stena_rezka.back.prev_num = nil
		m_simpleTV.User.stena_rezka.back.next_num = nil
		m_simpleTV.User.stena_rezka.back.current_page = nil
		m_simpleTV.User.stena_rezka.back.current_page_karusel = nil
		m_simpleTV.Http.Close(session)
		m_simpleTV.Common.Sleep(200)
		if stena_rezka then
			dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\startup\\desc_gt_rezka.lua')
			return stena_rezka()
		end

		res.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
		res.ExtButton1 = {ButtonEnable = true, ButtonName = ' 💾 '}
		res.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title1 .. ' (' .. #res .. ')',0,res,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.User.stena_rezka.back.item_id = id
			return media_info_rezka(res[id].Address)
		end
		if ret == 2 then
			return run_lite_qt_rezka()
		end
		if ret == 3	then
			setConfigVal('person/rezka',url)
			UpdatePersonRezka()
		end
end

function media_info_rezka(url)
	if m_simpleTV.User.TVPortal.stena_rezka then m_simpleTV.User.TVPortal.stena_rezka = nil end
	if m_simpleTV.User.TVPortal.stena_rezka == nil then m_simpleTV.User.TVPortal.stena_rezka = {} end
	local proxy = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.3809.87 Safari/537.36', proxy, false)
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end
	local current_zerkalo = getConfigVal('zerkalo/rezka') or ''
	if current_zerkalo ~= '' then
	url = url:gsub('http.-//.-/', current_zerkalo)
	end
	local id_rezka = url:match('/(%d+)')
	if tonumber(id_rezka) == 74605 then url = url:gsub('%-latest%.html','.html'):gsub('%.html','-latest.html') end
	m_simpleTV.User.TVPortal.stena_rezka.current_address = url
	local rc,answer = m_simpleTV.Http.Request(session,{url= url .. '?app_rules=1', headers = 'X-Requested-With: XMLHttpRequest\nCookie: ' .. m_simpleTV.User.rezka.cookies})
--	debug_in_file(url .. '\n' .. rc .. '\n' .. answer .. '\n','c://1/inforezka.txt')
		if rc ~= 200 then return '' end
	local tooltip_body
	if m_simpleTV.Config.GetValue('mainOsd/showEpgInfoAsWindow', 'simpleTVConfig') then tooltip_body = ''
	else tooltip_body = 'bgcolor="#182633"'
	end
	answer = answer:gsub('<!%-%-.-%-%->', ''):gsub('/%*.-%*/', '')
	local poster = answer:match('<link rel="image_src" href="([^"]+)') or answer:match('<img itemprop="image" src="([^"]+)') or answer:match('<div class="b%-sidecover"> <a href="([^"]+)') or answer:match('property="og:image" content="([^"]+)') or ''
	m_simpleTV.User.TVPortal.stena_rezka.logo = poster
	local name_rus = answer:match('<h1 itemprop="name">(.-)</h1>') or answer:match('<h1><span class="t1" itemprop="name">([^<]+)') or answer:match('<div class="b%-content__htitle"> <h1>(.-)</h1>') or ''
	name_rus = name_rus:gsub(' в HD онлайн', ''):gsub('Смотреть ', '')
	m_simpleTV.User.TVPortal.stena_rezka.title = name_rus
	local desc = answer:match('"og:description" content="(.-)"%s*/>') or ''
	desc = desc:gsub('"', "'"):gsub('&laquo;', '«'):gsub('&raquo;', '»')
	m_simpleTV.User.TVPortal.stena_rezka.overview = desc
	local time_all = answer:match('<h2>Время</h2>:</td> <td itemprop="duration">(.-)</td>') or ''
	if time_all ~= '' then
		m_simpleTV.User.TVPortal.stena_rezka.time_all = ' ● ' .. time_all
		time_all = '<h5><font color=#E0FFFF>' .. time_all .. '</font></h5>'
	end
	local name_eng = answer:match('alternativeHeadline">(.-)</div>') or ''
	m_simpleTV.User.TVPortal.stena_rezka.title_en = name_eng
	local mpaa = answer:match('style="color: #666;">(.-+)') or ''
	if mpaa ~= '' then
		m_simpleTV.User.TVPortal.stena_rezka.age = ' ● ' .. mpaa
	end
	local slogan = answer:match('<h2>Слоган</h2>:</td> <td>(.-)</td>') or ''
	slogan = slogan:gsub('&laquo;', '«'):gsub('&raquo;', '»')
	m_simpleTV.User.TVPortal.stena_rezka.slogan = slogan
	local country = answer:match('<h2>Страна.-">(.-)</tr>') or ''
	country = country:gsub('<a.->', ''):gsub('</td>', ''):gsub('</a>', '')
	m_simpleTV.User.TVPortal.stena_rezka.country = country
	local year = answer:match('Дата выхода.-year/(.-)/') or answer:match('Год:.-year/(.-)/') or answer:match('<td class="l">(<h2>Дата рождения</h2>:.-)<div class="b%-person__career">') or ''
	year = year:gsub('<a href="https://rezkery.com/year/.->', ''):gsub('<tr>', ''):gsub('</tr>', ''):gsub('<td.->', ''):gsub('</td>', ''):gsub('</a>', ''):gsub('<h2.->', '<h5>'):gsub('</h2>', ''):gsub('</table>', ''):gsub('<div class="b%-person__gallery_holder">.-</div>', '')
	m_simpleTV.User.TVPortal.stena_rezka.year = year
	local kpr = answer:match('Кинопоиск</a>: <span class="bold">(.-)</span> <i>') or ''
	if kpr ~= '' then kpr = string.format('%.' .. (1 or 0) .. 'f', kpr) end
	m_simpleTV.User.TVPortal.stena_rezka.ret_KP = kpr
	local imdbr = answer:match('IMDb.-: <span class="bold">(.-)</span> <i>') or ''
	m_simpleTV.User.TVPortal.stena_rezka.ret_imdb = imdbr
	local rezkar = answer:match('"rating%-layer%-num.->(.-)<') or ''
	m_simpleTV.User.TVPortal.stena_rezka.ret_rezka = rezkar
	if not rezka_info then
		m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="5.0" src="' .. poster .. '"', text = slogan .. '\n' .. mpaa .. '\n' .. year .. '\n' .. country .. '\nКинопоиск: ' .. kpr .. '\nIMDb: ' .. imdbr .. '\nHDRezka: ' .. rezkar .. '\n' .. time_all:gsub('<.->', ''), color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
	end
	local desc_text = answer:match('<div class="b%-post__description_text">(.-)</div>') or ''
	desc_text = desc_text:gsub('<a.->', ''):gsub('</a>', '')
	desc_text = '<table width="100%" border="0"><tr><td style="padding: 15px 15px 5px;"><img src="' .. poster .. '" height="470"></td><td style="padding: 0px 5px 5px; color: #EBEBEB; vertical-align: middle;"><h2><font color=#00FA9A>' .. name_rus .. '</font></h2><h5><i><font color=#EBEBEB>' .. slogan .. '</font></i>  <b><font color=#E0FFFF>' .. mpaa .. '</font></b></h5><h3><font color=#BBBBBB>' .. name_eng .. '</font></h3><h5><font color=#E0FFFF>' .. year .. ' • ' .. country .. '<p> • Кинопоиск: ' .. kpr .. '<p> • IMDb: ' .. imdbr .. '<p> • HDRezka: ' .. rezkar .. '</font></h5><h5><font color=#E0FFFF>' .. time_all .. '</font></h5><h4><font color=#EBEBEB>' .. desc_text .. '</font></h4></td></tr></table>'

	local answer1 = answer:match('<h2>Из серии</h2>:(.-)</tr>') or ''
	local answer2 = answer:match('<div class="b%-sidetitle">(.-</a>)') or ''
	local answer3 = answer:match('<div class="b%-sidelist__holder">(.-)<div id="addcomment%-title"') or ''
	local answer4 = answer:match('<h2>Жанр</h2>:(.-)</tr>') or ''

	local title = name_rus .. ' (' .. year .. ')'
	local kp_id, imdb_id, balanser, is_video
	if answer:match('<span class="b%-post__info_rates kp"><a href="/help/.-" target="_blank" rel="nofollow">Кинопоиск</a>') then
	kp_id = answer:match('<span class="b%-post__info_rates kp"><a href="/help/(.-)"')
	kp_id = decode64(kp_id)
	kp_id = kp_id:gsub('%%3A', ':'):gsub('%%2F', '/')
	kp_id = kp_id:match('kinopoisk%.ru/.-/(%d+)/.-$')
	end
	if answer:match('<span class="b%-post__info_rates imdb"><a href="/help/.-" target="_blank" rel="nofollow">IMDb</a>') then
	imdb_id = answer:match('<span class="b%-post__info_rates imdb"><a href="/help/(.-)/"')
	imdb_id = decode64(imdb_id)
	imdb_id = imdb_id:gsub('%%3A', ':'):gsub('%%2F', '/')
	imdb_id = imdb_id:match('imdb%.com/title/(tt.-)/.-$')
	end
--	local add_id = kp_id or imdb_id
	local add_id = kp_id
	if add_id then
		balanser = GetBalanser_new(add_id)
	end
	local id_rezka = url:match('/(%d+)')
	if answer:match('initCDNSeriesEvents%(' .. id_rezka .. ',%s*(%d+)') or answer:match('initCDNMoviesEvents%(' .. id_rezka .. ',%s*(%d+)') then
		is_video = true
	end
	m_simpleTV.User.TVPortal.stena_rezka.current_id = id_rezka
	local flag = flag_favorites(id_rezka)
	if flag ~= '' then
	m_simpleTV.User.TVPortal.stena_rezka.flag = true
	else
	m_simpleTV.User.TVPortal.stena_rezka.flag = false
	end
	local t1,j={},2
		t1[1] = {}
		t1[1].Id = 1
		t1[1].Address = ''
		t1[1].Name = flag .. '.: info :.'
		t1[1].InfoPanelLogo = poster
		t1[1].InfoPanelName = title or 'Rezka info'
		t1[1].InfoPanelDesc = '<html><body ' .. tooltip_body .. '>' .. desc_text:gsub('"', "\"") .. '</body></html>'
		t1[1].InfoPanelTitle = desc
		t1[1].InfoPanelShowTime = 10000
		if balanser then
		t1[2] = {}
		t1[2].Id = 2
		t1[2].Address = balanser
		if balanser ~= '' then
		t1[2].Name = 'Online: ZF'
		elseif balanser == '' then
		t1[2].Name = '🔄 Online: ZF'
		end
		j = 3
		end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = ''
		t1[j].Name = 'InfoDesc'
		j = j + 1
		m_simpleTV.User.TVPortal.stena_rezka.genres = {}
		local gn = 1
		for w in answer4:gmatch('<a.-</a>') do
		local genres = w:match('"genre">(.-)</span></a>')
		local genres_adr = w:match('<a href="(.-)"')
		if not genres_adr or not genres then break end
		m_simpleTV.User.TVPortal.stena_rezka.genres[gn] = {}
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = genres_adr .. '?filter=watching'
		t1[j].Name = 'Жанр: ' .. genres
		m_simpleTV.User.TVPortal.stena_rezka.genres[gn].Id = gn
		m_simpleTV.User.TVPortal.stena_rezka.genres[gn].genre_adr = genres_adr .. '?filter=watching'
		m_simpleTV.User.TVPortal.stena_rezka.genres[gn].genre_name = genres
		j=j+1
		gn = gn + 1
		end
		m_simpleTV.User.TVPortal.stena_rezka.collections = nil
		m_simpleTV.User.TVPortal.stena_rezka.collections = {}
		local cl = 1
		if answer2 and answer2 ~= '' and answer2:match('href="(.-)"') then
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = answer2:match('href="(.-)"')
		t1[j].Name = answer2:match('class="b%-post__franchise_link_title">(.-)</a>') or 'Франшиза'
		m_simpleTV.User.TVPortal.stena_rezka.collections[cl] = {}
		m_simpleTV.User.TVPortal.stena_rezka.collections[cl].name = t1[j].Name
		m_simpleTV.User.TVPortal.stena_rezka.collections[cl].adr = t1[j].Address
		cl = cl + 1
		j=j+1
		end
		for w1 in answer1:gmatch('<a href=".-</a>') do
		local adr,name = w1:match('<a href="(.-)">(.-)</a>')
		if not adr or not name then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Address = adr
		t1[j].Name = name:gsub('&#039;',"'"):gsub('&amp;',"&")
		m_simpleTV.User.TVPortal.stena_rezka.collections[cl] = {}
		m_simpleTV.User.TVPortal.stena_rezka.collections[cl].name = t1[j].Name
		m_simpleTV.User.TVPortal.stena_rezka.collections[cl].adr = t1[j].Address
		cl = cl + 1
		j=j+1
		end
		m_simpleTV.User.TVPortal.stena_rezka.actors = nil
		m_simpleTV.User.TVPortal.stena_rezka.actors = {}
		local tp = {}
		local ps = 1
		for w2 in answer:gmatch('<span class="person%-name%-item".-</span>') do
		local person_logo, person_work, person_adr, person_name = w2:match('data%-photo="(.-)".-data%-job="(.-)".-href="(.-)".-itemprop="name">(.-)</span>')
		if not person_name or not person_adr or not person_work then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Name = person_name:gsub('&laquo;',''):gsub('&raquo;','') .. ' (' .. person_work .. ')'
		t1[j].Address = person_adr
		t1[j].InfoPanelLogo = person_logo
		t1[j].InfoPanelName = person_name:gsub('&laquo;',''):gsub('&raquo;','') .. ' (' .. person_work .. ')'
		t1[j].InfoPanelShowTime = 10000
		if person_logo and person_logo ~= 'null' then
		tp[ps] = {}
		tp[ps].Id = ps
		tp[ps].actors_name = person_name:gsub('&laquo;',''):gsub('&raquo;','')
		tp[ps].actors_logo = person_logo
		tp[ps].actors_adr = person_adr
		tp[ps].actors_work = person_work
		ps = ps + 1
		end
		j=j+1
		end

		local hash, res = {}, {}
		for ps = 1, #tp do
		tp[ps].actors_adr = tostring(tp[ps].actors_adr)
			if not hash[tp[ps].actors_adr] then
				res[#res + 1] = tp[ps]
				hash[tp[ps].actors_adr] = true
			end
		end
		for ps = 1, #res do
			res[ps].Id = ps
		end

		m_simpleTV.User.TVPortal.stena_rezka.actors = res

		m_simpleTV.User.TVPortal.stena_rezka.add_content = nil
		m_simpleTV.User.TVPortal.stena_rezka.add_content = {}
		local ac = 1
		for w3 in answer3:gmatch('"b%-content__inline_item".-</div></div>') do
		local logo, item, adr, name, desc = w3:match('<img src="(.-)".-<i class="entity">(.-)</i>.-<a href="(.-)">(.-)</a> <div class="misc">(.-)</div>')
		if not logo or not item or not adr or not name or not desc then break end
		t1[j] = {}
		t1[j].Id = j
		t1[j].Name = name .. ' (' .. desc .. ') - ' .. item
		t1[j].Address = adr
		t1[j].InfoPanelLogo = logo
		t1[j].InfoPanelName = name .. ' (' .. desc .. ') - ' .. item
		t1[j].InfoPanelShowTime = 10000
		m_simpleTV.User.TVPortal.stena_rezka.add_content[ac] = {}
		m_simpleTV.User.TVPortal.stena_rezka.add_content[ac].adr = adr
		m_simpleTV.User.TVPortal.stena_rezka.add_content[ac].name = name
		m_simpleTV.User.TVPortal.stena_rezka.add_content[ac].logo = logo
		ac = ac + 1
		j=j+1
		end
		m_simpleTV.Http.Close(session)
		m_simpleTV.Common.Sleep(200)
		if rezka_info then
			dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\startup\\desc_gt_rezka.lua')
			return rezka_info()
		end
		t1.ExtButton0 = {ButtonEnable = true, ButtonName = ' 🢀 '}
		if is_video then
			t1.ExtButton1 = {ButtonEnable = true, ButtonName = ' ▶ '}
		end
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('Rezka: ' .. title, 0, t1, 30000, 1 + 4 + 8 + 2)
		if ret == 1 then
			if id == 1 then
				ADD_to_favorites_rezka(url)
				media_info_rezka(url)
			elseif t1[id].Name:match('InfoDesc') then
				dofile(m_simpleTV.MainScriptDir .. 'user\\westSidePortal\\startup\\desc_gt_rezka.lua')
				rezka_info()
			elseif t1[id].Address:match('/collections/') then
				collection_rezka_url(t1[id].Address)
			elseif t1[id].Address:match('/franchises/') then
				franchises_rezka_url(t1[id].Address)
			elseif t1[id].Name:match('Жанр') then
				last_rezka(t1[id].Address,t1[id].Name)
			elseif t1[id].Address:match('/person/') then
				person_rezka_work(t1[id].Address)
			elseif t1[id].Name:match('🔄') then
				update_phpsesid()
				media_info_rezka(url)
			elseif t1[id].Name:match('ZF') then
				m_simpleTV.User.filmix.CurAddress = nil
				m_simpleTV.User.rezka.CurAddress = url
				m_simpleTV.User.westSide.PortalTable = true
				m_simpleTV.Control.PlayAddressT({address=t1[id].Address, title=title})
			else
				media_info_rezka(t1[id].Address)
			end
		end
		if ret == 2 then
			run_lite_qt_rezka()
		end
		if ret == 3 then
			setConfigVal('info/rezka',url)
			setConfigVal('info/scheme','Rezka')
			retAdr = url
			m_simpleTV.Control.ChangeAddress = 'No'
			m_simpleTV.Control.ExecuteAction(37)
			m_simpleTV.Control.CurrentAddress = retAdr
			m_simpleTV.Control.PlayAddressT({address = retAdr, title = title})
		end
end

function add_to_history_rezka(adr, title, logo)

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
	end

-- wafee code for history
	local cur_max
	local max_history = m_simpleTV.Config.GetValue('openFrom/maxRecentItem','simpleTVConfig') or 15
    local recentName = getConfigVal('rezka_history/title') or ''
    local recentAddress = getConfigVal('rezka_history/adr') or ''
	local recentLogo = getConfigVal('rezka_history/logo') or ''
	local current_id = adr:match('/(%d+)')
     local t={}
     local tt={}
     local i=2
	 t[1] = {}
     t[1].Id = 1
     t[1].Name = title
	 t[1].Address = adr
	 t[1].Logo = logo
   if recentName~='' and recentLogo~='' and recentAddress~='' then

     for w in string.gmatch(recentName,"[^%|]+") do
       t[i] = {}
       t[i].Id = i
       t[i].Name = w
       i=i+1
     end
     i=2
     for w in string.gmatch(recentAddress,"[^%|]+") do
       t[i].Address = w
       i=i+1
     end
	 i=2
     for w in string.gmatch(recentLogo,"[^%|]+") do
       t[i].Logo = w
       i=i+1
     end

     local function isExistAdr()
       for i=2,#t do
	     local from_all_id = t[i].Address:match('/(%d+)')
         if tonumber(from_all_id) == tonumber(current_id) then
           return true, i
         end
       end
       return false
     end

     local isExist,i=isExistAdr()
     if isExist then
       table.remove(t,i)
     end

     recentName=''
     recentAddress = ''
     recentLogo = ''

	 if #t <= tonumber(max_history) then
		cur_max = #t
	 else
		cur_max = tonumber(max_history)
	 end

     for i=1,cur_max  do
      local name = t[i].Name
      t[i].Name = t[i].Name:gsub('@@@@@',',')
      recentName = recentName .. name .. '|'
      recentAddress = recentAddress .. t[i].Address .. '|'
	  recentLogo = recentLogo .. t[i].Logo .. '|'
      t[i].Id = i
--      debug_in_file('fromOSDmenu = ' .. t[i].Id .. ' ' .. t[i].Name .. ' ' .. t[i].Address .. '\n','c://1/kp.txt')
     end

	 setConfigVal('rezka_history/title',recentName)
	 setConfigVal('rezka_history/logo',recentLogo)
	 setConfigVal('rezka_history/adr',recentAddress)

	 else

	 setConfigVal('rezka_history/title',title .. '|')
	 setConfigVal('rezka_history/logo',logo .. '|')
	 setConfigVal('rezka_history/adr',adr .. '|')

   end
end

function media_info_HDRezka_from_stena(id)
	if not id then return end
	local adr = id:match('&(.-)$')
	if adr and adr ~= '' then
		return media_info_rezka(adr)
	end
	return
end

rezka_autorization()