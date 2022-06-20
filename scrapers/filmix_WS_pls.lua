-- скрапер TVS для top плейлистов сайта https://filmix.co от west_side (16/07/21)

	module('filmix_WS_pls', package.seeall)
	local my_src_name = 'Filmix Best'
	local filmixsite = 'https://filmix.ac'
		local masshtab = m_simpleTV.User.paramScriptForSkin_masshtab or 1.5
		if m_simpleTV.User.paramScriptForSkin_background1 then
			background1 = m_simpleTV.User.paramScriptForSkin_background1
		else
			background1 = ''
		end
		if m_simpleTV.User.paramScriptForSkin_background2 then
			background2 = m_simpleTV.User.paramScriptForSkin_background2
		else
			background2 = ''
		end
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'https://filmix.ac/templates/Filmix/media/img/favicon.ico', TypeSource = 1, TypeCoding = 1, DeleteM3U = 0, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0,GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 2}}
	end

	function GetVersion()
	 return 2, 'UTF-8'
	end
	local sessionFilmix = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
	local function LoadFromPage()
	local str, page_all = '', 1
	while page_all <= 147 do

	local sessionFilmix = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36', prx, false)
			if not sessionFilmix then return end
			m_simpleTV.Http.SetTimeout(sessionFilmix, 60000)
			local playlist, txt = '', ''
			if page_all==1 then t1=os.time() end

			if page_all < 8 then playlist = 'viewing' txt = '👁 Filmix viewing' page = page_all page_in = 7
			elseif page_all >= 8 and page_all < 25 then playlist = 'top250' txt = '🎥 Filmix: Top 250' page = page_all - 7 page_in = 17
			elseif page_all >= 25 and page_all < 42 then playlist = 'top250/kp' txt = '🎥 Кинопоиск: Top 250' page = page_all - 24
	        elseif page_all >= 42 and page_all < 59 then playlist = 'top250/imdb' txt = '🎥 IMDB: Top 250' page = page_all - 41
			elseif page_all >= 59 and page_all < 76 then playlist = 'top250s' txt = '📺 Filmix: Top 250' page = page_all - 58
			elseif page_all >= 76 and page_all < 93 then playlist = 'top250s/kp' txt = '📺 Кинопоиск: Top 250' page = page_all - 75
	        elseif page_all >= 93 and page_all < 110 then playlist = 'top250s/imdb' txt = '📺 IMDB: Top 250' page = page_all - 92
			elseif page_all >= 110 and page_all < 114 then playlist = 'top250m' txt = '🐶 Filmix: Top 250' page = page_all - 109 page_in = 4
			elseif page_all >= 114 and page_all < 131 then playlist = 'top250m/kp' txt = '🐶 Кинопоиск: Top 250' page = page_all - 113 page_in = 17
	        elseif page_all >= 131 and page_all <= 147 then playlist = 'top250m/imdb' txt = '🐶 IMDB: Top 250' page = page_all - 130
			end
			local filmixurl = 'https://filmix.ac/' .. playlist .. '/page/' .. page .. '/'

			local rc, filmixanswer = m_simpleTV.Http.Request(sessionFilmix, {url = filmixurl:gsub('/page/1/','')})
			if rc ~= 200 then m_simpleTV.Common.Sleep(60000) page_all = page_all - 1 end

			filmixanswer = m_simpleTV.Common.multiByteToUTF8(filmixanswer)
			str = str .. filmixanswer:gsub('\n', ' ')
			page_all = page_all + 1

			m_simpleTV.OSD.ShowMessageT({text = txt .. ' (' .. math.floor(page/page_in*100) .. '%)' , showTime = 10000,0xFF00,3})

			if page_all==147 then t2=os.time()
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="' .. m_simpleTV.Common.GetMainPath(2) .. './luaScr/user/westSide/icons/poisk.png"', text = 'Время загрузки ' .. t2-t1 .. ' сек. Приятного просмотра', color = ARGB(255, 127, 63, 255), showTime = 1000 * 60})
			end

	end

	 return str, txt
	end

	local function LoadFromSite()
		local t, i, gr_n = {}, 1, 0
		local name, adr, logo
		local answer = LoadFromPage()
			for w in answer:gmatch('<article class="shortstory line" itemscope itemtype="http://schema.org/Movie"(.-)</article>') do
				name_rus = w:match('itemprop="name" content="(.-)"><a itemprop'):gsub('&amp;', '&')
				name_eng = w:match('itemprop="alternativeHeadline" content="(.-)">') or ''
				quality = w:match('<div class="quality">(.-) </div>') or ''
				year = w:match('<a itemprop="copyrightYear".->(.-)</a>') or ''
				genres = w:match('<a itemprop="genre".->(.-)</a></span></div>') or ''
				genres = genres:gsub('</a>', ''):gsub('<a itemprop="genre".->', '')
				perevod = w:match('<div class="item translate">(.-)<div class="item actors">') or ''
				perevod = perevod:gsub(':', ': ')
				actors = w:match('<div class="item actors">(.-)<p itemprop="description">') or ''
				actors = actors:gsub('&nbsp;', ' '):gsub(':', ': ')
				description = w:match('<p itemprop="description">(.-)</p>') or ''
				if description ~= ''
					then desc = '<h5>' .. description .. '</h5>'
					else desc = ''
				end
				number_top = w:match('<div class="counter%-top250">(.-)</div>') or '500'
				adr = w:match('<a itemprop="url" href="(.-)"')
				logo = w:match('<img src="(.-)"') or ''
				ratePos = w:match('<span class="rateinf ratePos">(.-)</span>')
				rateNeg = w:match('<span class="rateinf rateNeg">(.-)</span>')
				vote = ratePos + rateNeg
				rating = ratePos/vote * 10
				rating = string.format('%.' .. (1 or 0) .. 'f', rating)
				rating_str = '<img src="https://filmix.co/templates/Filmix/media/img/favicon.ico" height="' .. 24*masshtab .. '" align="top"><img src="simpleTVImage:./luaScr/user/westSide/stars/' .. rating .. '.png" height="' .. 24*masshtab .. '" align="top">'
				desc1 = '<h4><font color=#CD7F32>' .. year .. '</font></h4><h5>' .. genres .. '</h5><h5>' .. rating_str .. ' ' .. vote .. '</h5><h5><font color=#BBBBBB>' .. perevod .. '</font></h5>'
				logo = w:match('<img src="(.-)"') or ''
--					if not name_rus or not adr then break end
				t[i] = {}
				t[i].group_logo = 'https://lh6.googleusercontent.com/proxy/pnmnD8p6ZONfNCMq9qSlSwtaSty9KWVpnMgES8YXqKsDYltLcDjClVYt-rJHCUGLuUtn1r2i1TFsPI4RAlgG1pMoXGB1aDUGDe0O0lKR632_5mTr'
				t[i].logo = logo
				t[i].name = name_rus .. ' (' .. year .. ')'
--				t[i].video_title = year .. ' | ' .. genres .. ' | FXR: ' .. rating
--				t[i].video_desc = '<html><body bgcolor="#434750" ' .. background2 .. '><table width="100%"><tr><td style="padding: 10px 10px 5px; vertical-align: middle;"><img src="' .. t[i].logo .. '" width = "' .. 240*masshtab .. '"></td><td style="padding: 10px 10px 0px; color: #EBEBEB; vertical-align: middle;"><h4><font color=#7FD4FF>' .. quality .. '</font></h4><h4><font color=#00FA9A>' .. t[i].name .. '</font><a href = "simpleTVLua:m_simpleTV.Control.PlayAddress(\'#' .. t[i].name .. '\')"><img src="simpleTVImage:./work/Channel/Logo/Icons/menuRezka.png" height="' .. 36*masshtab .. '"></a></h4><h5><font color=#BBBBBB>' .. name_eng .. '</font></h5>' .. desc1 ..	'<h5><font color=#BBBBBB>' .. actors .. '</font></h5></td></tr></table></body></html>'
--				t[i].video_desc = t[i].video_desc:gsub('%%', '%%25')
--				t[i].video_desc = t[i].video_desc:gsub('"', '%%22')
--				t[i].video_title = t[i].video_title:gsub('"', '%%22')
				t[i].address = adr
				if number_top == '1' then gr_n = gr_n + 1 end
				if gr_n == 0 then t[i].group = '👁 Filmix viewing'
				elseif gr_n == 1 then t[i].group = '🎥 Filmix: Top 250'
				elseif gr_n == 2 then t[i].group = '🎥 Кинопоиск: Top 250'
				elseif gr_n == 3 then t[i].group = '🎥 IMDB: Top 250'
				elseif gr_n == 4 then t[i].group = '📺 Filmix: Top 250'
				elseif gr_n == 5 then t[i].group = '📺 Кинопоиск: Top 250'
				elseif gr_n == 6 then t[i].group = '📺 IMDB: Top 250'
				elseif gr_n == 7 then t[i].group = '🐶 Filmix: Top 250'
				elseif gr_n == 8 then t[i].group = '🐶 Кинопоиск: Top 250'
				elseif gr_n == 9 then t[i].group = '🐶 IMDB: Top 250'
				end
			    i = i + 1
			end
	 return t
	end

	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromSite()
			if not t_pls then m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' - ошибка загрузки плейлиста', color = ARGB(255, 255, 0, 0), showTime = 1000 * 5, id = 'channelName'}) return end
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')