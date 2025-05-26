-- WS Logopack plugin startup script
-- author: west_side 15.05.25

--[[
m_simpleTV.Database.ExecuteSql("ATTACH DATABASE '" .. m_simpleTV.Common.GetMainPath(1) .. "/logopack.db' AS logopack;", false)
m_simpleTV.Database.ExecuteSql("CREATE TABLE IF NOT EXISTS logopack.logopackchannels (NameChannels TEXT NOT NULL, LogoChannels TEXT NOT NULL, AuthorLogopack TEXT NOT NULL);", false)
m_simpleTV.Database.ExecuteSql('START TRANSACTION;/*logopackchannels*/')

		local epg = m_simpleTV.Database.GetTable('SELECT * FROM ChannelsEpg ORDER BY Id')
		local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:85.0) Gecko/20100101 Firefox/85.0')
		if not session then return end
		m_simpleTV.Http.SetTimeout(session, 60000)
		for i = 1,#epg do
			local name = epg[i].ChName
			local logo = epg[i].Logo
			local author = epg[i].Source:gsub('^.-%-','')
			local id = epg[i].Id:gsub('^.-_','')
			if author == 'EDEM' then
				author = 'EDEM dark'
			end
			if author == 'gabba' then
				author = 'Gabbarit'
			end
			if author == 'Italo' then
				author = 'Italo'
			end
			if author == 'one' then
				author = 'IPTV ONE'
			end
			if author == '1OTT' then
				logo = 'http://list.1ott.net/img/channel_icons/' .. id .. '.png'
				local rc, answer = m_simpleTV.Http.Request(session, {url = logo})
				if rc ~= 200 then logo = nil end
			end
			if logo and logo ~= '' then
				m_simpleTV.Database.ExecuteSql("INSERT  INTO logopackchannels (NameChannels, LogoChannels, AuthorLogopack) VALUES ('" .. name .. "','" .. logo .. "','" .. author .. "');", true)
				if logo:match('http://epg%.it999%.ru/img/') then
					logo = logo:gsub('/img/','/img2/')
					author = 'EDEM transparent'
					m_simpleTV.Database.ExecuteSql("INSERT  INTO logopackchannels (NameChannels, LogoChannels, AuthorLogopack) VALUES ('" .. name .. "','" .. logo .. "','" .. author .. "');", true)
				end
			end

			i = i + 1
		end
		m_simpleTV.Database.ExecuteSql('COMMIT;/*logopackchannels*/')
--]]
--[[
	m_simpleTV.Database.ExecuteSql("ATTACH DATABASE '" .. m_simpleTV.Common.GetMainPath(1) .. "/logopack.db' AS logopack;", false)
	m_simpleTV.Database.ExecuteSql("CREATE TABLE IF NOT EXISTS logopack.logopackchannels (NameChannels TEXT NOT NULL, LogoChannels TEXT NOT NULL, AuthorLogopack TEXT NOT NULL);", false)
	m_simpleTV.Database.ExecuteSql('START TRANSACTION;/*logopackchannels*/')
	local search = '/troya.m3u8'
	local path = m_simpleTV.Common.GetMainPath(1) .. search
	local file = io.open(path, 'r')
	local answer = file:read('*a')
	file:close()
	for w in answer:gmatch('%#EXTINF:.-\n') do
		local name = w:match('tvg%-id="(.-)"')
		local logo = w:match('tvg%-logo="(.-)"')
		if logo then
			author = 'TROYA'
			m_simpleTV.Database.ExecuteSql("INSERT  INTO logopackchannels (NameChannels, LogoChannels, AuthorLogopack) VALUES ('" .. name .. "','" .. logo .. "','" .. author .. "');", true)
		end
	end
	m_simpleTV.Database.ExecuteSql('COMMIT;/*logopackchannels*/')
--]]
--[[
	m_simpleTV.Database.ExecuteSql("ATTACH DATABASE '" .. m_simpleTV.Common.GetMainPath(1) .. "/logopack.db' AS logopack;", false)
	m_simpleTV.Database.ExecuteSql("CREATE TABLE IF NOT EXISTS logopack.logopackchannels (NameChannels TEXT NOT NULL, LogoChannels TEXT NOT NULL, AuthorLogopack TEXT NOT NULL);", false)
	m_simpleTV.Database.ExecuteSql('START TRANSACTION;/*logopackchannels*/')
local pathname = m_simpleTV.Common.GetMainPath(1) .. '/Mirror Glass dopolnenie/'
if os.dir(pathname) then
	local author = 'Mirror Glass'
	for entry in os.dir(pathname) do
		if entry.name:match('%.png$') then
		local logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/Mirror Glass dopolnenie/' .. m_simpleTV.Common.multiByteToUTF8(entry.name)

			m_simpleTV.Database.ExecuteSql("INSERT  INTO logopackchannels (NameChannels, LogoChannels, AuthorLogopack) VALUES ('" .. m_simpleTV.Common.multiByteToUTF8(entry.name):gsub('%.png','') .. "','" .. logo .. "','" .. author .. "');", true)
		end
	end
end
	m_simpleTV.Database.ExecuteSql('COMMIT;/*logopackchannels*/')
--]]
--[[
	m_simpleTV.Database.ExecuteSql("ATTACH DATABASE '" .. m_simpleTV.Common.GetMainPath(1) .. "/logopack.db' AS logopack;", false)
	m_simpleTV.Database.ExecuteSql("CREATE TABLE IF NOT EXISTS logopack.logopackchannels (NameChannels TEXT NOT NULL, LogoChannels TEXT NOT NULL, AuthorLogopack TEXT NOT NULL);", false)
	m_simpleTV.Database.ExecuteSql('START TRANSACTION;/*logopackchannels*/')
local pathname = m_simpleTV.Common.GetMainPath(1) .. '/ColorPic/'
if os.dir(pathname) then
	local author = 'ColorPic'
	for entry in os.dir(pathname) do
		if entry.name:match('%.png$') then
		local logo = 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/ColorPic/' .. m_simpleTV.Common.multiByteToUTF8(entry.name)

			m_simpleTV.Database.ExecuteSql("INSERT  INTO logopackchannels (NameChannels, LogoChannels, AuthorLogopack) VALUES ('" .. m_simpleTV.Common.multiByteToUTF8(entry.name):gsub('%.png','') .. "','" .. logo .. "','" .. author .. "');", true)
		end
	end
end
	m_simpleTV.Database.ExecuteSql('COMMIT;/*logopackchannels*/')
--]]
--[[
	m_simpleTV.Database.ExecuteSql("ATTACH DATABASE '" .. m_simpleTV.Common.GetMainPath(1) .. "/logopack.db' AS logopack;", false)
	m_simpleTV.Database.ExecuteSql("CREATE TABLE IF NOT EXISTS logopack.logopackchannels (NameChannels TEXT NOT NULL, LogoChannels TEXT NOT NULL, AuthorLogopack TEXT NOT NULL);", false)
	m_simpleTV.Database.ExecuteSql('START TRANSACTION;/*logopackchannels*/')
	local search = '/Logopack_Anzo.m3u'
	local path = m_simpleTV.Common.GetMainPath(1) .. search
	local file = io.open(path, 'r')
	local answer = file:read('*a')
	file:close()
	for w in answer:gmatch('.-\n') do
		local name, logo = w:match('(.-)(http.-%.png)')
		if name and logo then
			name = name:gsub('%=',';')
			author = 'mini by AnZo'
			m_simpleTV.Database.ExecuteSql("INSERT  INTO logopackchannels (NameChannels, LogoChannels, AuthorLogopack) VALUES ('" .. name .. "','" .. logo .. "','" .. author .. "');", true)
		end
	end
	m_simpleTV.Database.ExecuteSql('COMMIT;/*logopackchannels*/')
--]]
--[[
	m_simpleTV.Database.ExecuteSql("ATTACH DATABASE '" .. m_simpleTV.Common.GetMainPath(1) .. "/logopack.db' AS logopack;", false)
	m_simpleTV.Database.ExecuteSql("CREATE TABLE IF NOT EXISTS logopack.logopackchannels (NameChannels TEXT NOT NULL, LogoChannels TEXT NOT NULL, AuthorLogopack TEXT NOT NULL);", false)
	m_simpleTV.Database.ExecuteSql('START TRANSACTION;/*logopackchannels*/')
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:85.0) Gecko/20100101 Firefox/85.0')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 60000)
	local author = 'OttgTV'
	local rc, answer = m_simpleTV.Http.Request(session, {url = 'https://karnei4.github.io/convert/index_2.html'})
	for w in answer:gmatch('title=".-"><img src=".-"') do
		local name, logo = w:match('title="(.-)"><img src="(.-)"')
		if name and logo then
			m_simpleTV.Database.ExecuteSql("INSERT  INTO logopackchannels (NameChannels, LogoChannels, AuthorLogopack) VALUES ('" .. name .. "','" .. logo .. "','" .. author .. "');", true)
		end
	end
	m_simpleTV.Database.ExecuteSql('COMMIT;/*logopackchannels*/')
--]]
	local t = {}
    t.utf8 = true -- string coding
    t.name = "Update Logopack"
    t.lua_as_scr = false
    t.luastring = 'user/westSide_Logo/up_logo.lua'
    --t.key = 0x01000002
    --t.ctrlkey = 0 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
    t.location = 'LOCATION_EXTFILTER_MENU'
    t.image = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSide_Logo/img/palette-custom.png'
    m_simpleTV.Interface.AddExtMenuT(t)

	local t1 = {}
    t1.utf8 = true -- string coding
    t1.name = "Update Logopack"
    t1.lua_as_scr = false
    t1.luastring = 'user/westSide_Logo/up_pll_logo.lua'
    --t.key = 0x01000002
    --t.ctrlkey = 0 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
    t1.location = 'LOCATION_PLAYLIST_MENU'
    t1.image = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSide_Logo/img/palette-custom.png'
    m_simpleTV.Interface.AddExtMenuT(t1)