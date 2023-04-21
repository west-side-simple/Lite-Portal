--videocdn translations portal - lite version west_side 21.04.2023
--author west_side

local function title_translate(translate)
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
		m_simpleTV.Http.SetTimeout(session, 60000)
		for page = 1,19 do
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
				t[i].Name = unescape3(tab.data[j].smart_title)
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

function run_lite_qt_cdntr()
	if not m_simpleTV.User then
		m_simpleTV.User = {}
	end
	if not m_simpleTV.User.Videocdn then
		m_simpleTV.User.Videocdn = {}
	end
	require 'lfs'
	local rc, answer
	local url = 'aHR0cHM6Ly92aWRlb2Nkbi50di9hcGkvdHJhbnNsYXRpb25zP2FwaV90b2tlbj1vUzdXenZOZnhlNEs4T2NzUGpwQUlVNlh1MDFTaTBmbQ=='
	local t,i,page,current_id = {},1,1,1
	local str = ''
	local filePath = m_simpleTV.MainScriptDir .. 'user/westSidePortal/core/db_tr.txt' -- DB translations
	local fhandle = io.open(filePath, 'r')
	if not fhandle then
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 60000)
		for page = 1,19 do
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
				t[i].Name = unescape3(tab.data[j].smart_title)
				t[i].Action = tab.data[j].id
				t[i].InfoPanelName = 'Перевод'
				t[i].InfoPanelTitle = unescape3(tab.data[j].title)
				t[i].InfoPanelLogo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png'
				if m_simpleTV.User.Videocdn.translate and tonumber(t[i].Action) == tonumber(m_simpleTV.User.Videocdn.translate) then current_id = i end
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
			t[i].InfoPanelName = 'Перевод'
			t[i].InfoPanelTitle = w:match('/.-/.-/(.-)/')
			t[i].InfoPanelLogo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png'
			if m_simpleTV.User.Videocdn.translate and tonumber(t[i].Action) == tonumber(m_simpleTV.User.Videocdn.translate) then current_id = i end
			i = i + 1
		end
	end

	t.ExtButton0 = {ButtonEnable = true, ButtonName = ' Portal '}

	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Videocdn озвучка: ' .. #t,tonumber(current_id)-1,t,10000,1+4+8+2)
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
  t1.ExtButton0 = {ButtonEnable = true, ButtonName = '🢀'}
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8(title_translate(url:gsub('%&translation=','')):gsub('%) %(',', '):gsub('Профессиональный','Проф.'):gsub('Любительский','Люб.'):gsub('Авторский','Авт.'),0,t1,9000,1+4+8)
  if ret == -1 or not id then
	return
  end
  if ret==1 then
    page_cdntr(t1[id].Action)
  end
  if ret==2 then
    run_lite_qt_cdntr()
  end
end

function page_cdntr(url)

	local current_id = url:match('%&translation=(%d+)')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
--	debug_in_file(rc .. ': ' .. current_id .. '\n' .. answer .. '\n',m_simpleTV.MainScriptDir .. 'user/westSidePortal/cdn.txt')
		if rc ~= 200 then return type_cdntr('&translation=' .. current_id) end
-----------------
	require('json')
	answer = answer:gsub('\\', '\\\\'):gsub('\\"', '\\\\"'):gsub('\\/', '/'):gsub('(%[%])', '"nil"')
	local current_tr = title_translate(current_id)
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
	if tab.data[i].year and tab.data[i].year:match('%d%d%d%d') and tonumber(tab.data[i].year:match('%d%d%d%d'))~=1969 then year = ' (' .. tab.data[i].year:match('%d%d%d%d') .. ')' end -- bug
		t[i]={}
		t[i].Id = i
		t[i].Name = unescape3(tab.data[i].ru_title) .. year
		t[i].Action = 'http:' .. tab.data[i].iframe_src .. '?translation=' .. current_id
		t[i].InfoPanelName = unescape3(tab.data[i].ru_title) .. ' / ' .. unescape3(tab.data[i].orig_title) .. year
		t[i].InfoPanelTitle = current_tr
		t[i].InfoPanelLogo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/MoreLogo/westSidePortal.png'
		t[i].imdb_id = tab.data[i].imdb_id or ''
		t[i].kinopoisk_id = tab.data[i].kinopoisk_id or ''
		if t[i].kinopoisk_id == 0 then t[i].kinopoisk_id = '' end
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
		local ret, id = m_simpleTV.OSD.ShowSelect_UTF8('страница '.. current .. ' из ' .. last, 0, t, 30000, 1+4+8+2)
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
		  type_cdntr('&translation=' .. current_id)
		end
		end
		if ret == 3 then
		  page_cdntr(url .. next_pg)
		end
end