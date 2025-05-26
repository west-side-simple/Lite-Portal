-- открывает подобные ссылки:
-- http://api.vokino.tv/v2/compilations/content/65ab8ace43bdb6190ae77ca4
-- необходим скрипт imdb_media.lua - автор west_side (21.01.25)

	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end

	if not inAdr:match('/compilations/content/')
	then return end
	m_simpleTV.Control.ChangeAdress = 'Yes'
	m_simpleTV.Control.CurrentAdress = ''
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.2785.143 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	local url = inAdr

	local rc, answer = m_simpleTV.Http.Request(session, {url = url})

			if not answer then return end

			require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.channels or not tab.channels[1] or not tab.channels[1].details or not tab.channels[1].details.id or not tab.channels[1].details.name
	then
	return end
	m_simpleTV.Http.Close(session)
	local title = tab.title
	local t, i = {}, 1
	while true do
	if not tab.channels[i]
				then
				break
				end
	t[i]={}
	local id = tab.channels[i].details.id
	local name = tab.channels[i].details.name
	local poster = tab.channels[i].details.poster
	local originalname = tab.channels[i].details.originalname
	local released = tab.channels[i].details.released
	local about = tab.channels[i].details.about
	local genre = tab.channels[i].details.genre
	local type = tab.channels[i].details.type
	t[i].Id = i
	t[i].Name = name .. ' (' .. released .. ') - ' .. type
	t[i].InfoPanelLogo = poster
	t[i].Address = 'title=' .. name .. '&year=' .. released
	t[i].InfoPanelName = name .. ' / ' .. originalname .. ' (' .. released .. ') ' .. genre
	t[i].InfoPanelTitle = about
    i=i+1
	end

			local hash, t0 = {}, {}
				for i = 1, #t do
					if not hash[t[i].Address]
					then
						t0[#t0 + 1] = t[i]
						hash[t[i].Address] = true
					end
				end

				for i = 1, #t0 do
					t0[i].Id = i
				end

		local AutoNumberFormat, FilterType
			if #t0 > 4 then
				AutoNumberFormat = '%1. %2'
				FilterType = 1
			else
				AutoNumberFormat = ''
				FilterType = 2
			end
		t0.ExtParams = {FilterType = FilterType, AutoNumberFormat = AutoNumberFormat}
		if #t0 > 0 then
			local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('IMDB: ' .. title, 0, t0, 30000, 1 + 4 + 8 + 2)
			if ret == 1 then
				m_simpleTV.Control.PlayAddressT({address=t0[id].Address, title=t0[id].Name})
			end
		else
			m_simpleTV.OSD.ShowMessageT({imageParam = 'vSizeFactor="1.0" src="http://m24.do.am/images/logoport.png"', text = 'IMDB: Медиаконтент не найден', color = ARGB(255, 255, 255, 255), showTime = 1000 * 10})
			search_all()
		end
