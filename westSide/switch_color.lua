
local currentskin = m_simpleTV.Config.GetValue('skin/path','simpleTVConfig')
local pass = m_simpleTV.Common.GetMainPath(2) .. currentskin:gsub('^%./','')
local file = io.open(pass .. '/img/back.svg', 'r')
if not file then
	return
end

local answer = file:read('*a')
file:close()

local color = {
{'Blue', 'B0C4DE', '1E213D', '5D76CB'},
{'Green', 'A0D6B4', '123524', '009B77'},
{'Red', 'FFCBBB', '490005', 'FF2400'},
}

local k,m = 1,1

if answer:match('Blue') then
	k = 2
	m = 3
elseif answer:match('Green') then
	k = 3
	m = 1
elseif answer:match('Red') then
	k = 1
	m = 2
end

local title_color, color_light, color_black, color_base, color_base_next = color[k][1], color[k][2], color[k][3], color[k][4], color[m][4]



local i = 1
if answer:match('WS Light') then
	i = 2
elseif answer:match('WS Black') then
	i = 1
end

local t = {
{ [[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>
WS Black ]] .. title_color .. 
[[</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_black .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>WS Back</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_base .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg" height="50px" width="150px" viewBox="0 0 150 50">>
   <circle cx="25" cy="25" r="20" fill="#]] .. color_base .. [[" />
   <circle cx="75" cy="25" r="20" fill="#]] .. color_base_next .. [[" />
   <circle cx="125" cy="25" r="20" fill="#]] .. color_base_next .. [[" />
</svg>
]]
},
{ [[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>
WS Light ]] .. title_color .. 
[[</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_light .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>WS Back</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_base .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg" height="50px" width="150px" viewBox="0 0 150 50">>
   <circle cx="25" cy="25" r="20" fill="#]] .. color_base .. [[" />
   <circle cx="75" cy="25" r="20" fill="#]] .. color_base_next .. [[" />
   <circle cx="125" cy="25" r="20" fill="#]] .. color_base_next .. [[" />
</svg>
]]
},
}

local header
local fileEnd = '.svg'
for j = 1,3 do
local filePath
if j == 1 then
header = 'back'
elseif j == 2 then
header = 'back_active'
elseif j == 3 then
header = 'circle'
end
filePath = pass .. '/img/' .. header .. fileEnd
local fhandle = io.open(filePath, 'w+')
if fhandle then
	fhandle:write(t[i][j]:gsub('\\',''))
	fhandle:close()
--	m_simpleTV.OSD.ShowMessageT({text = 'создан ' .. filePath .. '\n', showTime = 1000 * 10})
else
	m_simpleTV.OSD.ShowMessageT({text = 'ошибка создания ' .. filePath .. '\n', showTime = 1000 * 10})
end
j = j + 1
end

m_simpleTV.Config.Apply('NEED_STANDALONE_PLAYLIST_UPDATE')
