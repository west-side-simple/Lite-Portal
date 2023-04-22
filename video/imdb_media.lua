-- видеоскрипт для сайта https://www.imdb.com/ (18/03/23) - автор west_side
-- открывает подобные ссылки:
-- https://www.imdb.com/title/tt5491994/reference
-- необходим скрипт kinopoisk.lua - автор nexterr (mod west_side)
		if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
		if not inAdr then return end
		if not inAdr:match('https?://www%.imdb%.com/title/tt%d+') then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
local function getConfigVal(key)
	return m_simpleTV.Config.GetValue(key,"LiteConf.ini")
end
local function setConfigVal(key,val)
	m_simpleTV.Config.SetValue(key,val,"LiteConf.ini")
end
	local function bg_imdb_id(imdb_id)
	--#!!nexterr code!!#--
	local urld = 'https://api.themoviedb.org/3/find/' .. imdb_id .. decode64('P2FwaV9rZXk9ZDU2ZTUxZmI3N2IwODFhOWNiNTE5MmVhYWE3ODIzYWQmbGFuZ3VhZ2U9cnUmZXh0ZXJuYWxfc291cmNlPWltZGJfaWQ')
	local rc1,answerd = m_simpleTV.Http.Request(session,{url=urld})
	if rc1~=200 then
	m_simpleTV.Http.Close(session)
	return
	end
	require('json')
	answerd = answerd:gsub('(%[%])', '"nil"')
	local tab = json.decode(answerd)
	local background,poster,title = '','','imdb_id'
	if not tab and (not tab.movie_results[1] or tab.movie_results[1]==nil) and not tab.movie_results[1].backdrop_path or not tab and not (tab.tv_results[1] or tab.tv_results[1]==nil) and not tab.tv_results[1].backdrop_path then background = '' else
	if tab.movie_results[1] then
	background = tab.movie_results[1].backdrop_path or ''
	poster = tab.movie_results[1].poster_path or ''
	title = tab.movie_results[1].original_title
	elseif tab.tv_results[1] then
	background = tab.tv_results[1].backdrop_path or ''
	poster = tab.tv_results[1].poster_path or ''
	title = tab.tv_results[1].original_name
	end
	if background and background ~= nil and background ~= '' then background = 'http://image.tmdb.org/t/p/original' .. background end
	if poster and poster ~= '' then poster = 'http://image.tmdb.org/t/p/original' .. poster end
	if poster and poster ~= '' and background == '' then background = poster end
    end
	if background == nil then background = '' end
	return background,title
	end
	local function vb_asw(imdb_id)
	local urlv = 'https://voidboost.net/embed/' .. imdb_id
	local rcv,answerv = m_simpleTV.Http.Request(session,{url=urlv})
	if rcv~=200 then
	return ''
	end
	return urlv
	end
	local function kpid(imdbid)
	if imdbid == 'tt0086333' then return '77264' end
	local url_vn = decode64('aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvcnQ/YXBpX3Rva2VuPXROamtaZ2M5N2JtaTlqNUl5NnFaeXNtcDlSZG12SG1oJmltZGJfaWQ9') .. imdbid
	local rc5,answer_vn = m_simpleTV.Http.Request(session,{url=url_vn})

		if rc5~=200 then
		return vb_asw(imdbid)
		end
		require('json')
		answer_vn = answer_vn:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
		local tab_vn = json.decode(answer_vn)

		if tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].kp_id then
		return tostring(tab_vn.data[1].kp_id)
		elseif tab_vn and tab_vn.data and tab_vn.data[1] and tab_vn.data[1].imdb_id then
		return 'https://32.svetacdn.in/fnXOUDB9nNSO?imdb_id=' .. imdbid
		elseif vb_asw(imdbid) and vb_asw(imdbid) ~= '' then
		return vb_asw(imdbid)
		else
		return ''
		end
	end
	local imdbid = inAdr:match('(tt%d+)')
	local title = 'IMDbID=' .. imdbid
	local logo = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuIMDb.png'
	local logo,title = bg_imdb_id(imdbid)
	if logo == '' then logo = m_simpleTV.MainScriptDir_UTF8 .. 'user/show_mi/menuIMDb.png' end
	m_simpleTV.Control.ChangeChannelLogo(logo, m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	m_simpleTV.Control.SetTitle(title)
	m_simpleTV.Control.CurrentTitle_UTF8 = title
	local retAdr
		if kpid(imdbid) and kpid(imdbid)~='' and not kpid(imdbid):match('http') then
		retAdr = '**' .. kpid(imdbid)
		setConfigVal('info/imdb',imdbid)
		setConfigVal('info/scheme','TMDB')
		elseif kpid(imdbid) and kpid(imdbid)~='' and kpid(imdbid):match('http') then
		retAdr = kpid(imdbid)
		setConfigVal('info/imdb',imdbid)
		setConfigVal('info/scheme','TMDB')
		else
		run_lite_qt_tmdb()
		end
	m_simpleTV.Control.ChangeAdress = 'No'
	m_simpleTV.Control.CurrentAdress = retAdr
	dofile(m_simpleTV.MainScriptDir .. "user\\video\\video.lua")
-- debug_in_file(retAdr .. '\n')