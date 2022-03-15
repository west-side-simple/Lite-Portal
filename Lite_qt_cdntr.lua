--videocdn translations portal - lite version west_side 15.03.22

function run_lite_qt_cdntr()

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local url = 'aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHJhbnNsYXRpb25zP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbQ=='
	local rc, answer = m_simpleTV.Http.Request(session, {url = decode64(url)})
	require('json')
	answer = answer:gsub('(%[%])', '"nil"')
	local tab = json.decode(answer)
	if not tab or not tab.data or not tab.data[1]
	then
	return end
	local t,i = {},2
	while true do
	if not tab.data[i] then break end
		t[i]={}
		t[i].Id = i
		t[i].Name = tab.data[i].short_title
		t[i].Action = tab.data[i].id
		t[i].InfoPanelName = 'Перевод'
		t[i].InfoPanelTitle = tab.data[i].title
		t[i].InfoPanelLogo = 'https://videocdn.tv/favicon.png'
		i = i + 1
		end

	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите перевод videocdn',0,t,10000,1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			type_cdntr('&translation=' .. t[id].Action)
		end
		if ret == 2 then
			run_westSide_portal()
		end
end

function type_cdntr(url)
local tt1={
{'Фильмы','aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvbW92aWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbQ=='},
{'Сериалы','aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHYtc2VyaWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbQ=='},
{'Аниме','aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvYW5pbWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbQ=='},
{'Аниме сериалы','aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvYW5pbWUtdHYtc2VyaWVzP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbQ=='},
{'ТВ Шоу','aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvc2hvdy10di1zZXJpZXM/YXBpX3Rva2VuPW9TN1d6dk5meGU0SzhPY3NQanBBSVU2WHUwMVNpMGZt'},
}

  local t1={}
  for i=1,#tt1 do
    t1[i] = {}
    t1[i].Id = i
    t1[i].Name = tt1[i][1]
	t1[i].Action = decode64(tt1[i][2]) .. url
  end

  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Выберите медиаконтент',0,t1,9000,1+4+8)
  if id==nil then return end

  if ret==1 then
    page_cdntr(t1[id].Action)
  end
end

function page_cdntr(url)

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)

	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
		if rc ~= 200 then return end
-----------------
require('json')
	answer = answer:gsub('(%[%])', '"nil"')
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
	local year = ''
	if tab.data[i].year then year = ' (' .. tab.data[i].year:match('%d%d%d%d') .. ')' end
		t[i]={}
		t[i].Id = i
		t[i].Name = tab.data[i].ru_title
		t[i].Action = 'http:' .. tab.data[i].translations[1].iframe_src
		t[i].InfoPanelName = tab.data[i].ru_title .. ' / ' .. tab.data[i].orig_title .. year
		t[i].InfoPanelTitle = tab.data[i].translations[1].title
		t[i].InfoPanelLogo = 'https://videocdn.tv/favicon.png'
		t[i].imdb_id = tab.data[i].imdb_id or ''
		t[i].kinopoisk_id = tab.data[i].kinopoisk_id or ''
		i = i + 1
	end
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
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('(страница '.. current .. ' из ' .. last .. ')', 0, t, 30000, 1+4+8+2)
		if ret == -1 or not id then
			return
		end
		if ret == 1 then
			m_simpleTV.Control.CurrentTitle_UTF8 = t[id].InfoPanelName
			m_simpleTV.Control.SetTitle(t[id].InfoPanelName)
			retAdr = t[id].Action .. '&embed=' .. t[id].kinopoisk_id .. ',' .. t[id].imdb_id
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