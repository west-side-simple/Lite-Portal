-- Radio Caprice (488 каналов) - потоковый радиосервис: коллекция стилей, жанров, направлений.
-- Загрузится плейлист в медиа-вкладку Радио

-- автор westSide, скрапер TVS для загрузки плейлиста радио "Radio Caprice" (14.07.2024)


	module('RC_pls', package.seeall)
	local my_src_name = 'Radio Caprice'
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = 'http://radcap.ru/apple-touch-icon.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 0, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 1, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local tab = {
	{"BLUES","Radcap blues.png"},
	{"CLASSICAL","Radcap classical.png"},
	{"COUNTRY","Radcap country.png"},
	{"ELECTRONIC","Radcap electronic.png"},
	{"ETHNIC","Radcap ethnic.png"},
	{"HARDCORE","Radcap hardcore.png"},
	{"HIPHOP","Radcap hiphop.png"},
	{"JAZZ","Radcap jazz.png"},
	{"METAL","Radcap metal.png"},
	{"MISC","Radcap misc.png"},
	{"POP","Radcap pop.png"},
	{"REGGAE","Radcap reggae.png"},
	{"ROCK","Radcap rock.png"},
	{"SHANSON","Radcap shanson.png"},
	}

	local function getGrpImg(grp)
		grp = string.gsub(grp, '%-', '')
		local img = ''
		for i=1,#tab do
			if string.find(grp, tab[i][1],1,true) then
			img = tab[i][2]
			break
			end
		end
		return img
	end

	local function GetAdr(adr)
	local url = 'http://radcap.ru/' .. adr
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
			if not session then return '' end
		m_simpleTV.Http.SetTimeout(session, 14000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return '' end
		return answer:match('"title":"2"%,file:"(.-)"') or ''
	end

	local function LoadFromNet()
		local url = 'http://radcap.ru/index-db.html'
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
			if not session then return end
		m_simpleTV.Http.SetTimeout(session, 8000)
		local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		m_simpleTV.Http.Close(session)
			if rc ~= 200 then return end
	answer = answer:gsub('\n',' ')
    local i,j,t=1,1,{}
    local adr,logo,name,grp,img_grp
    for w in answer:gmatch('<a style="color.-</table>.-</table>') do
		grp = w:match('<.-href=".-">(.-)<')
        grp = grp:gsub('%&amp%;','&'):gsub('ШАНСОН','SHANSON')
        img_grp=getGrpImg(grp)
		for w1 in w:gmatch('<a href=.-</a>') do
		adr,logo,name = w1:match('<a href="(.-)".-<img src="(.-)".->(.-)<')
		if not adr or not name then break end
		t[i] = {}
		local adrs = 'http:' .. GetAdr(adr) .. '$OPT:NO-STIMESHIFT'
			t[i].name = name:gsub('%&amp%;','&')
			t[i].address = adrs
			t[i].group = grp
			t[i].logo = 'http://radcap.ru/' .. logo
			t[i].group_is_unique = 1
			t[i].group_logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/BannersRadCap/' .. img_grp
			m_simpleTV.OSD.ShowMessage('Radio Caprice. Group: ' .. j .. ', Channels: ' .. i,0xFF00,10)
        i=i+1
        end
		j=j+1
    end
			if i == 1 then return end
	 return t
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local t_pls = LoadFromNet()
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' ошибка загрузки плейлиста'
											, color = ARGB(255, 255, 100, 0)
											, showTime = 1000 * 5
											, id = 'channelName'})
			 return
			end
		m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' (' .. #t_pls .. ')'
									, color = ARGB(255, 155, 255, 155)
									, showTime = 1000 * 5
									, id = 'channelName'})
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')