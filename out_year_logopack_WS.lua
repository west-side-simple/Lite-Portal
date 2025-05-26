-- script for create output logopack for evgen (example for year)
-- author westSide 31.01.25

function Create_out_logopack()

	local function ShowInfo(s)
		local q = {}
			q.once = 1
			q.zorder = 0
			q.cx = 0
			q.cy = 0
			q.id = 'WS_INFO'
			q.class = 'TEXT'
			q.align = 0x0202
			q.top = 0
			q.color = 0xFFFFFFF0
			q.font_italic = 0
			q.font_addheight = 6
			q.padding = 20
			q.textparam = 1 + 4
			q.text = s
			q.background = 0
			q.backcolor0 = 0x90000000
		m_simpleTV.OSD.AddElement(q)
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('WS_INFO')
		end
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('WS_INFO')
		end
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('WS_INFO')
		end
		m_simpleTV.OSD.RemoveElement('WS_INFO')
	end

	local param = {}
	param.name = 'Select Base Directory' -- title, string  (optional)
	param.startFolder = 'c://'-- string   (optional)
--	param.filters = 'Elements (*.svg)' -- string   (optional)
--	param.selectFile = -- string   (optional)
--	param.options = 0x00000001 -- int or string (optional) https://doc.qt.io/qt-5/qfiledialog.html#Option-enum
	param.fileMode = 2 -- int or string (optional) https://doc.qt.io/qt-5/qfiledialog.html#FileMode-enum
	param.acceptMode = 0 -- int or string (optional) https://doc.qt.io/qt-5/qfiledialog.html#AcceptMode-enum
	local picker = m_simpleTV.Interface.FilePicker(param)
	local time1=os.time()
	if picker == nil then return end
	picker = m_simpleTV.Common.UTF8ToMultiByte(picker)

--	debug_in_file(picker .. '\n' .. '\n---------------\n')

	local file_base_svg = io.open(picker .. '/base.svg', 'r')
	if not file_base_svg then return end
	local answer_file_base_svg = file_base_svg:read('*a')
	file_base_svg:close()
	answer_file_base_svg = answer_file_base_svg:gsub('<svg.->',''):gsub('</svg>','')

	local svg_in = {}
	for i = 1,10 do
		local file_svg = io.open(picker .. '/' .. (i-1) .. '.svg', 'r')
		local answer = file_svg:read('*a')
		file_svg:close()
		local y,w,h,im = answer:match(' y="(.-)".-width="(.-)".-height="(.-)".-xlink:href="(.-)"')
		svg_in[i] = {}
		svg_in[i].name = i
		svg_in[i].y = y
		svg_in[i].w = w
		svg_in[i].h = h
		svg_in[i].im = im
		i = i + 1
	end

	for k = 1910,2030 do
		local name = tostring(k)

		local a1,a2,a3,a4 = name:match('(%d)(%d)(%d)(%d)')
		if not a1 or not a2 or not a3 or not a4 then return end

		local y1, w1, h1, im1 = svg_in[a1+1].y,svg_in[a1+1].w,svg_in[a1+1].h,svg_in[a1+1].im
		local y2, w2, h2, im2 = svg_in[a2+1].y,svg_in[a2+1].w,svg_in[a2+1].h,svg_in[a2+1].im
		local y3, w3, h3, im3 = svg_in[a3+1].y,svg_in[a3+1].w,svg_in[a3+1].h,svg_in[a3+1].im
		local y4, w4, h4, im4 = svg_in[a4+1].y,svg_in[a4+1].w,svg_in[a4+1].h,svg_in[a4+1].im

		local pos = math.floor(-(tonumber(w1)+tonumber(w2)+tonumber(w3)+tonumber(w4)+150-1440)/2)
		local x1 = pos
		local x2 = pos + w1 + 50
		local x3 = x2 + w2 + 50
		local x4 = x3 + w3 + 50

		local str_data = '<image id="' .. 1 .. '" data-name="' .. 1 .. '" x="' .. x1 .. '" y="' .. y1 .. '" width="' .. w1 .. '" height="' .. h1 .. '" xlink:href="' .. im1 .. '"/>\n' .. '<image id="' .. 2 .. '" data-name="' .. 2 .. '" x="' .. x2 .. '" y="' .. y2 .. '" width="' .. w2 .. '" height="' .. h2 .. '" xlink:href="' .. im2 .. '"/>\n' .. '<image id="' .. 3 .. '" data-name="' .. 3 .. '" x="' .. x3 .. '" y="' .. y3 .. '" width="' .. w3 .. '" height="' .. h3 .. '" xlink:href="' .. im3 .. '"/>\n' .. '<image id="' .. 4 .. '" data-name="' .. 4 .. '" x="' .. x4 .. '" y="' .. y4 .. '" width="' .. w4 .. '" height="' .. h4 .. '" xlink:href="' .. im4 .. '"/>\n'

		local str = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="1440" height="720" viewBox="0 0 1440 720">' .. answer_file_base_svg .. str_data .. '</svg>'
		local fhandle = io.open(picker .. '/' .. name .. '.svg', 'w+')
		if fhandle then
			fhandle:write(str)
			fhandle:close()
		end

		k=k+1
	end
	ShowInfo('DB save in directory\n' .. m_simpleTV.Common.multiByteToUTF8(picker))
end

	local t = {}
    t.utf8 = true -- string coding
    t.name = "Create output logopack"
    t.lua_as_scr = true
    t.luastring = 'Create_out_logopack()'
    --t.key = 0x01000002
    --t.ctrlkey = 0 -- modifier keys (type: number) (available value: 0 - not modifier keys, 1 - CTRL, 2 - SHIFT, 3 - CTRL + SHIFT )
    t.location = 'LOCATION_MAIN_MENU'
    t.image = m_simpleTV.MainScriptDir_UTF8 .. 'user/westSide_Logo/img/palette-custom v4.png'
    m_simpleTV.Interface.AddExtMenuT(t)
