
local currentskin = m_simpleTV.Config.GetValue('skin/path','simpleTVConfig')
local pass = m_simpleTV.Common.GetMainPath(2) .. currentskin:gsub('^%./','')
local file = io.open(pass .. '/img/back.svg', 'r')
if not file then
	return
end

local answer = file:read('*a')
file:close()

local color = {
{'Blue', 'B0C4DE', '1E213D', '4169E1', '6699CC', '252850'},
{'Green', 'A0D6B4', '123524', '00A693', '71BC78', '177245'},
{'Red', 'FFCBBB', '560319', 'FF2400', 'FFA089', '92000A'},
{'Orange', 'E7C697', '35170C', 'E8793E', 'DEAA88', '4D220E'},
{'Magenta', 'FCB4D5', '270A1F', 'ED3CCA', 'FF97BB', '4A192C'},
{'Cyan', 'AFEEEE', '193737', '48D1CC', '78DBE2', '256D7B'},
{'Orchid', 'C9A0DC', '320B35', '9932CC', 'BA55D3', '7442C8'},
{'User', 'C1CACA', '293133', '708090', '9DA1AA', '414A4C'},
}

local k,m = 1,1

if answer:match('Blue') then
	k = 2
	m = 3
elseif answer:match('Green') then
	k = 3
	m = 4
elseif answer:match('Red') then
	k = 4
	m = 5
elseif answer:match('Orange') then
	k = 5
	m = 6
elseif answer:match('Magenta') then
	k = 6
	m = 7
elseif answer:match('Cyan') then
	k = 7
	m = 8
elseif answer:match('Orchid') then
	k = 8
	m = 1
elseif answer:match('User') then
	k = 1
	m = 2
end

local current_type_WS = m_simpleTV.Config.GetValue("current_type_WS","LiteConf.ini") or 1

m_simpleTV.Config.SetValue('mainView/logo/file', 'https://raw.githubusercontent.com/west-side-simple/logopacks/main/Wallpapers/' .. color[k][1] .. current_type_WS .. '.png' ,'simpleTVConfig')

local title_color, color_light, color_black, color_base, color_base_next, color_light1, color_black1 = color[k][1], color[k][2], color[k][3], color[k][4], color[m][4], color[k][5], color[k][6]

local color_for_ui, color_mono, color_mono_filter, gradient, gradient_activ, color_mono_invers, color_mono_back, color_mono_hex

local i = 1
if answer:match('WS Light') then
	i = 2
	color_for_ui = color_light1
	color_mono = '32'
	color_mono_hex = '2F353B'
	color_mono_filter = 'C0C0C0'
	color_mono_invers = '000000'
	color_mono_back = 'CFCFCF'
	gradient = {color_light, color_base}
	gradient_activ = {color_base, color_base}
elseif answer:match('WS Black') then
	i = 1
	color_for_ui = color_black1
	color_mono = '222'
	color_mono_hex = 'C0C0C0'
	color_mono_filter = '2F353B'
	color_mono_invers = 'FFFFFF'
	color_mono_back = '707070'
	gradient = {color_base, color_black1}
	gradient_activ = {color_light, color_base}
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
   <circle cx="25" cy="25" r="20" fill="#]] .. color_base .. [[" stroke="#]] .. color_black .. [[" stroke-width="2"/>
   <circle cx="75" cy="25" r="20" fill="#]] .. color_base_next .. [[" stroke="#]] .. color_base .. [[" stroke-width="2"/>
   <circle cx="125" cy="25" r="20" fill="#]] .. color_base_next .. [[" stroke="#]] .. color_base .. [[" stroke-width="2"/>
</svg>
]],
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>
WS Black1 ]] .. title_color ..
[[</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_black1 .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg width="90" height="30" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="1" width="30" height="29" fill="#]] .. color_black .. [["/>
  <rect x="30" y="1" width="30" height="29" fill="#]] .. color_base .. [[" fill-opacity="0.3"/>
  <rect x="60" y="1" width="30" height="29" fill="#]] .. color_base .. [[" fill-opacity="0.3"/>
</svg>
]],
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
   <circle cx="25" cy="25" r="20" fill="#]] .. color_base .. [[" stroke="#]] .. color_light .. [[" stroke-width="2"/>
   <circle cx="75" cy="25" r="20" fill="#]] .. color_base_next .. [[" stroke="#]] .. color_base .. [[" stroke-width="2"/>
   <circle cx="125" cy="25" r="20" fill="#]] .. color_base_next .. [[" stroke="#]] .. color_base .. [[" stroke-width="2"/>
</svg>
]],
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>
WS Light1 ]] .. title_color ..
[[</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_light1 .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg width="90" height="30" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="1" width="30" height="29" fill="#]] .. color_light .. [["/>
  <rect x="30" y="1" width="30" height="29" fill="#]] .. color_base .. [[" fill-opacity="0.3"/>
  <rect x="60" y="1" width="30" height="29" fill="#]] .. color_base .. [[" fill-opacity="0.3"/>
</svg>
]],
},
}

local header
local fileEnd = '.svg'
for j = 1,5 do
local filePath
if j == 1 then
header = 'back'
elseif j == 2 then
header = 'back_active'
elseif j == 3 then
header = 'circle'
elseif j == 4 then
header = 'back1'
elseif j == 5 then
header = 'back_item'
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

file = io.open(pass .. '/forms/standaloneplst/window.ui', 'r')

if not file then
	return
end

answer = file:read('*a')

local frame1 = answer:match('%<%!%-%-start frame1.-end frame1%-%-%>')

local frame1_up = [[<!--start frame1-->
     <property name="styleSheet">
      <string notr="true"> background-color: #]] .. color_mono_filter .. [[; color: #]] .. color_mono_invers .. [[; selection-background-color: #]] .. color_mono_back .. [[; </string>
	 </property>
     <property name="skinBackground" stdset="0">
      <string notr="true">usetransparent=&quot;1&quot;src=&quot;img\back1.svg&quot; can_glass=&quot;2&quot; color1=&quot;0xff]] .. color_for_ui .. [[&quot; type=&quot;0&quot; </string>
     </property>
	 <!--end frame1-->]]

local frame2 = answer:match('%<%!%-%-start frame2.-end frame2%-%-%>')

local frame2_up = [[<!--start frame2-->
     <property name="skinBackground" stdset="0">
      <string notr="true">
	  usetransparent=&quot;1&quot;
	  src=&quot;img\back1.svg&quot;
	  can_glass=&quot;1&quot;
	  color1=&quot;0xff]] .. color_for_ui .. [[&quot;
	  type=&quot;0&quot;</string>
     </property>
	 <!--end frame2-->]]

local frame3 = answer:match('%<%!%-%-start frame3.-end frame3%-%-%>')

local frame3_up = [[<!--start frame3-->
             <color alpha="255">
              <red>]] .. color_mono .. [[</red>
              <green>]] .. color_mono .. [[</green>
              <blue>]] .. color_mono .. [[</blue>
             </color>
	 <!--end frame3-->]]
	 
	 

--debug_in_file(answer:gsub('%<%!%-%-start frame1.-end frame1%-%-%>',frame1_up):gsub('%<%!%-%-start frame2.-end frame2%-%-%>',frame2_up)..'\n','c:/1/exitfile')

file = io.open(pass .. '/forms/standaloneplst/window.ui', 'w+')

file:write(answer:gsub('%<%!%-%-start frame1.-end frame1%-%-%>',frame1_up):gsub('%<%!%-%-start frame2.-end frame2%-%-%>',frame2_up):gsub('%<%!%-%-start frame3.-end frame3%-%-%>',frame3_up):gsub('</ui>.-$','</ui>'))

file:close()

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_no.ui', 'r')

if not file then
	return
end

answer = file:read('*a')

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_no.ui', 'w+')

file:write(answer:gsub('%<%!%-%-start frame3.-end frame3%-%-%>',frame3_up):gsub('</ui>.-$','</ui>'))

file:close()

file = io.open(pass .. '/forms/standaloneplst/tree_element_group.ui', 'r')

if not file then
	return
end

answer = file:read('*a')

file = io.open(pass .. '/forms/standaloneplst/tree_element_group.ui', 'w+')

file:write(answer:gsub('%<%!%-%-start frame3.-end frame3%-%-%>',frame3_up):gsub('</ui>.-$','</ui>'))

file:close()

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_bottom.ui', 'r')

if not file then
	return
end

answer = file:read('*a')

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_bottom.ui', 'w+')

file:write(answer:gsub('%<%!%-%-start frame3.-end frame3%-%-%>',frame3_up):gsub('</ui>.-$','</ui>'))

file:close()

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_side.ui', 'r')

if not file then
	return
end

answer = file:read('*a')

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_side.ui', 'w+')

file:write(answer:gsub('%<%!%-%-start frame3.-end frame3%-%-%>',frame3_up):gsub('</ui>.-$','</ui>'))

file:close()

local answer1 =
[[
QWidget{
 border: 0px solid #999999;
 background: url(_BASESKINPATH_/img/back.svg) center center center;
 color: #]] .. color_mono_hex .. [[;
 font-weight: 600;
 margin: 0px;
 padding: 0px;
}

QTreeView
{
 background: url(_BASESKINPATH_/img/back.svg) center center center;
 alternate-background-color: rgba(0, 0, 0, 16);
 font: 20px;
}

QTreeView::item:selected
{
 color: #ffffc618;
 font-weight: 600;
 background: #7f7f7f7f;
}

QTreeView::item:hover
{
 background: #66000000;
 color: #ffffffff;
}

QTreeView::item
{
 background: #00000000;
}

#m_Splitter{
 height: 1px;
 width: 1px;
}

#line{
 border-bottom: 1px solid #fff;
}

QScrollBar:vertical {
 border: 0px solid #999999;
 background: rgba(128, 128, 128, 180);
 width:8px;
 border-radius: 4px;
 margin: 0px 0px 0px 0px;
}
QScrollBar::handle:vertical {
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #474A51, stop: 1 #2F353B);
 min-height: 20px;
 border-radius: 4px;
 }
QScrollBar::handle:vertical:pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 min-height: 20px;
 border-radius: 4px;
 }
QScrollBar::handle:vertical:hover:!pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 min-height: 20px;
 border-radius: 4px;
 }
QScrollBar::add-line:vertical {
 background:  rgba(100, 100, 100, 120);
 height: 0px;
 border: 0px solid #999999;
 border-radius: 4px;
 subcontrol-position: bottom;
 subcontrol-origin: margin;
}
QScrollBar::add-line:vertical:pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 4px;
 border: 0px solid rgba(255, 127, 63, 255);
 }
QScrollBar::add-line:vertical:hover:!pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 4px;
 border: 0px solid rgba(255, 127, 63, 127);
 }
QScrollBar::sub-line:vertical {
 background: rgba(100, 100, 100, 120);
 height: 0px;
 border: 0px solid #999999;
 border-radius: 4px;
 subcontrol-position: top;
 subcontrol-origin: margin;
}
QScrollBar::sub-line:vertical:pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 4px;
 border: 0px solid rgba(255, 127, 63, 255);
 }
QScrollBar::sub-line:vertical:hover:!pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 4px;
 border: 0px solid rgba(255, 127, 63, 127);
 }
QScrollBar:top-arrow:vertical, QScrollBar::bottom-arrow:vertical {
 border: 0px solid grey;
 width: 0px;
 height: 0px;
 background: rgba(100, 100, 100, 120);
 border-radius: 0px;
}
QScrollBar::add-page:vertical, QScrollBar::sub-page:vertical {
 background: none;
}
]]

local answer2 =
[[
#m_ChannelName
{
 background: rgba(0, 0, 0, 0);
 color : #ffffff;
 font: 20px;
 font-weight: 600;
}

#m_CurrentTime
{
 font: 18px;
}

#m_EpgFilterTypeButton
{
 color : #ffffff;
 border: 1px solid #C7D0CC;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #C7D0CC, stop: 1 #2F353B);
}

#m_EpgFilterTypeButton:pressed
{
 border: 1px solid #ffffff;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
}

#m_EpgFilterTypeButton:hover
{
 border: 1px solid #ffffff;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
}

#m_FilterCombo
{
 color: #]] .. color_mono_invers .. [[;
 border: 0px solid #C7D0CC;
 background-color: #]] .. color_mono_filter .. [[; selection-background-color: #]] .. color_mono_back .. [[;
 font: 14px;
}

#m_EpgNow
{
 color: #]] .. color_base .. [[;
 font: 20px;
}

#m_EpgProgress
{
 text-align: center;
 font: 20px;
 font: bold;
 font-weight: 600;
 background: rgba(222, 222, 222, 44);
 height: 2px;
 border: 1px solid #444444;
 border-radius: 3px;
 color: rgba(255, 255, 255, 255);
}

QProgressBar::chunk
{
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
 width: 8px;
 margin: 2px;
 border: 2px #00FFFF;
 border-radius: 2px;
}

QHeaderView::section
{
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 color: white;
 padding-left: 4px;
 border: 1px solid #C7D0CC;
 font: 20px;
}

#m_EpgList
{
 background: rgba(]] .. color_mono .. [[, ]] .. color_mono .. [[, ]] .. color_mono .. [[, 24);
 background-attachment: fixed;
 border: 0px solid #8f8f91;
 color: #]] .. color_mono_hex .. [[;
 font: 18px;
 font-weight: 200;
 padding-bottom: 8px;
}

#m_EpgList:active
{
  color : #]] .. color_base .. [[;
}

#m_LabelDesk
{
 margin-top: 4px;
 color: #]] .. color_base .. [[;
 background: rgba(0, 0, 0, 0);
 border: 0px solid #999999;
 font: 20px;
 font-weight: 600;
}

#m_Desc
{
 font: 18px;
 background: rgba(]] .. color_mono .. [[, ]] .. color_mono .. [[, ]] .. color_mono .. [[, 24);
 border: 1px solid #]] .. color_for_ui .. [[;
}

#m_ButtonTime1:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime2:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime3:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime4:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime5:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime6:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime7:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}

#m_ButtonTime1:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime2:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime3:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime4:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime5:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime6:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime7:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}

#m_ButtonTime1
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime2
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime3
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime4
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime5
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime6
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime7
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}

#m_TimeSt
{
 background: rgba(0, 0, 0, 0);
 color : #ffffff;
 font: 20px;
}

#m_TimeEnd
{
 background: rgba(0, 0, 0, 0);
 color : #ffffff;
 font: 20px;
}

#m_ButtonTimeNow
{
 padding:4px;

 font-size: 18px;
 border-radius: 2px;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
}

#m_ButtonTimeNow:hover
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
}

#m_ButtonTimeNow:pressed
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
}

#m_ButtonTimeUp
{
 background: url(_BASESKINPATH_/img/butr.png) center center ;
 background-repeat: no-repeat;
 border: 0px solid #C7D0CC;
 color : #bbb;
 font: 18px;
 border-radius: 6px;
}

#m_ButtonTimeUp:hover
{
 background: url(_BASESKINPATH_/img/butr.png) center center qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_base .. [[, stop: 1 #]] .. color_base .. [[);
 background-repeat: no-repeat;
 border: 1px solid #F5F5F5;
 color: #eee;
 font: 18px;
 border-radius: 6px;
}

#m_ButtonTimeUp:pressed
{
 background: url(_BASESKINPATH_/img/butr.png) center center qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_base .. [[, stop: 1 #]] .. color_base .. [[);
 background-repeat: no-repeat;
 border: 1px solid #F5F5F5;
 color: #eee;
 font: 18px;
 border-radius: 6px;
}

#m_ButtonTimeDown
{
 background: url(_BASESKINPATH_/img/butl.png) center center ;
 background-repeat: no-repeat;
 border: 0px solid #C7D0CC;
 color : #bbb;
 font: 18px;
 border-radius: 6px;
}

#m_ButtonTimeDown:hover
{
 background: url(_BASESKINPATH_/img/butl.png) center center qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_base .. [[, stop: 1 #]] .. color_base .. [[);
 background-repeat: no-repeat;
 border: 1px solid #F5F5F5;
 color: #eee;
 font: 18px;
 border-radius: 6px;
}

#m_ButtonTimeDown:pressed
{
 background: url(_BASESKINPATH_/img/butl.png) center center qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_base .. [[, stop: 1 #]] .. color_base .. [[);
 background-repeat: no-repeat;
 border: 1px solid #F5F5F5;
 color: #eee;
 font: 18px;
 border-radius: 6px;
}
]]

local answer3 =
[[
QComboBox
{
 background: rgba(0, 0, 0, 32);
 border: 1px solid #C7D0CC;
 border-radius: 2px;
 padding: 2px;
 font-size: 18px;
 font-weight: 200;
}

QGroupBox
{
 background: rgba(0, 0, 0, 0);
 border: 0px solid #C7D0CC;
 border-radius: 0px;
 color: #]] .. color_mono_hex .. [[;
 font: bold 20px;
 max-width: 1200px;
 min-width: 120px;
 margin: 4px;
 padding-top: 20px;
}

QGroupBox:title
{
 background: rgba(0, 0, 0, 0);
 border: 0px solid #C7D0CC;
 border-radius: 0px;
 color: #]] .. color_mono_hex .. [[;
 margin: 8px;
 padding-top: -4px;
}

QLabel
{
 background: rgba(222, 222, 0, 0);
 border: 0px solid #C7D0CC;
 border-radius: 2px;
 color: #]] .. color_mono_hex .. [[;
 font-size: 16px;
 font-weight: 600;
}

QDoubleSpinBox
{
 border: 1px solid #C7D0CC;
 background: rgba(0, 0, 0, 32);
 border-radius: 2px;
 color: #]] .. color_mono_hex .. [[;
 padding: 2px;
 font-size: 16px;
 font-weight: 600;
}

QLineEdit
{
 box-sizing: border-box;
 background: rgba(111, 111, 111, 55);
 border: 1px solid #C7D0CC;
 border-radius: 2px;
 color: #]] .. color_mono_hex .. [[;
 font-size: 16px;
 padding: 3px;
 font-weight: 400;
}

QPushButton
{
 background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #C7D0CC, stop: 0.75 #2F353B);
 border: 1px solid #C7D0CC;
 border-radius: 2px;
 color : #fff;
 padding: 3px;
 text-align: center;
 font-size: 16px;
 font-weight: 200;
 cursor: pointer;
}

QPushButton:hover
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_black1 .. [[);
}

QPushButton:pressed
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
}

QToolButton
{
 background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #C7D0CC, stop: 0.75 #2F353B);
 border: 1px solid #C7D0CC;
 border-radius: 2px;
 color : #fff;
 padding: 3px;
 text-align: center;
 font-size: 16px;
 font-weight: 200;
 cursor: pointer;
}

QToolButton:hover
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
}
QToolButton:pressed
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
}

#m_PermDesc
{
 border: 1px solid #C7D0CC;
 background: rgba(111, 111, 111, 55);
 border-radius: 2px;
}

#m_Address
{
 background: rgba(0, 0, 0, 16);
 color: #]] .. color_mono_hex .. [[;
 font: bold 16px;
 padding-top: 4px;
}

#m_RealAddres
{
 background: rgba(0, 0, 0, 16);
 color: #]] .. color_mono_hex .. [[;
 font: bold 16px;
 padding-top: 4px;
}

#m_SlaveAddress
{
 background: rgba(0, 0, 0, 16);
 color: #]] .. color_mono_hex .. [[;
 font: bold 16px;
 padding-top: 4px;
}
]]

file = io.open(pass .. '/includeui/appStylesheet.qss', 'w+')

file:write(answer1 .. answer2 .. answer3)
file:close()

answer =
[[
QScrollBar:vertical {
 border: 0px solid #999999;
 background: rgba(128, 128, 128, 180);
 width:18px;
 border-radius: 0px;
 margin: 0px 0px 0px 0px;
}
QScrollBar::handle:vertical {
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #474A51, stop: 1 #2F353B);
 min-height: 45px;
 border-radius: 9px;
 }
QScrollBar::handle:vertical:pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 min-height: 45px;
 border-radius: 9px;
 }
QScrollBar::handle:vertical:hover:!pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 min-height: 45px;
 border-radius: 9px;
 }
QScrollBar::add-line:vertical {
 background:  rgba(100, 100, 100, 120);
 height: 0px;
 border: 0px solid #999999;
 border-radius: 9px;
 subcontrol-position: bottom;
 subcontrol-origin: margin;
}
QScrollBar::add-line:vertical:pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 9px;
 border: 0px solid rgba(255, 127, 63, 255);
 }
QScrollBar::add-line:vertical:hover:!pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 9px;
 border: 0px solid rgba(255, 127, 63, 127);
 }
QScrollBar::sub-line:vertical {
 background: rgba(100, 100, 100, 120);
 height: 0px;
 border: 0px solid #999999;
 border-radius: 9px;
 subcontrol-position: top;
 subcontrol-origin: margin;
}
QScrollBar::sub-line:vertical:pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 9px;
 border: 0px solid rgba(255, 127, 63, 255);
 }
QScrollBar::sub-line:vertical:hover:!pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 9px;
 border: 0px solid rgba(255, 127, 63, 127);
 }
QScrollBar:top-arrow:vertical, QScrollBar::bottom-arrow:vertical {
 border: 0px solid grey;
 width: 0px;
 height: 0px;
 background: rgba(100, 100, 100, 120);
 border-radius: 0px;
}
QScrollBar::add-page:vertical, QScrollBar::sub-page:vertical {
 background: none;
}
]]

file = io.open(pass .. '/includeui/scrollbar.qss', 'w+')

file:write(answer)
file:close()

answer =
[[
QAbstractButton {
 background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop:0 rgba(176, 196, 222, 222), stop:0.6 rgba(30, 33, 61, 222));
 border: 1px solid #C7D0CC;
 border-radius: 2px;
 color: #bbb;
 padding: 3px;
 text-align: center;
 font-size: 30px;
 font-weight: 600;
 cursor: pointer;
}
QAbstractButton:pressed {
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light1 .. [[, stop: 0.7 #]] .. color_black .. [[);
}
QAbstractButton:hover:!pressed
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light1 .. [[, stop: 0.7 #]] .. color_black .. [[);
}
]]

file = io.open(pass .. '/includeui/defaultbutton.qss', 'w+')

file:write(answer)
file:close()

answer =
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="579.000000pt" height="105.000000pt" viewBox="0 0 579.000000 105.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>WS Back</metadata>
  <defs>
    <linearGradient id="grad" x1="0%" x2="0%" y1="0%" y2="100%">
      <stop offset="0%" stop-color="#]] .. color_base .. [[" />
	  <stop offset="30%" stop-color="#]] .. color_base .. [[" />
      <stop offset="30%" stop-color="#]] .. color_black1 .. [[" />
	  <stop offset="57%" stop-color="#]] .. color_black1 .. [[" />
      <stop offset="57%" stop-color="#]] .. color_black .. [[" />
	  <stop offset="84%" stop-color="#]] .. color_black .. [[" />
	  <stop offset="84%" stop-color="#]] .. color_light1 .. [[" />
	  <stop offset="100%" stop-color="#]] .. color_light1 .. [[" />
    </linearGradient>
  </defs>
<rect x="0" y="0" width="579" height="105" fill="url(#grad)" fill-opacity="0.95"/>
</svg>
]]

file = io.open(pass .. '/img/main.svg', 'w+')

file:write(answer)
file:close()

answer =
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="40.000000pt" height="40.000000pt" viewBox="0 0 40.000000 40.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>WS Back</metadata>
  <defs>
    <linearGradient id="grad" x1="0%" x2="0%" y1="0%" y2="100%">
      <stop offset="0%" stop-color="#]] .. gradient[1] .. [[" />
	  <stop offset="100%" stop-color="#]] .. gradient[2] .. [[" />
    </linearGradient>
  </defs>
<rect x="0" y="0" width="40" height="40" fill="url(#grad)"/>
</svg>
]]

file = io.open(pass .. '/img/gradient.svg', 'w+')

file:write(answer)
file:close()

answer =
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="40.000000pt" height="40.000000pt" viewBox="0 0 40.000000 40.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>WS Back</metadata>
  <defs>
    <linearGradient id="grad" x1="0%" x2="0%" y1="0%" y2="100%">
      <stop offset="0%" stop-color="#]] .. gradient_activ[1] .. [[" />
	  <stop offset="80%" stop-color="#]] .. gradient_activ[2] .. [[" />
    </linearGradient>
  </defs>
<rect x="0" y="0" width="40" height="40" fill="url(#grad)"/>
</svg>
]]

file = io.open(pass .. '/img/gradient_activ.svg', 'w+')

file:write(answer)
file:close()

answer =
[[
<svg width="90" height="30" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="1" width="30" height="29" fill="#]] .. color_base .. [["/>
  <rect x="30" y="1" width="30" height="29" fill="#]] .. color_base .. [[" fill-opacity="0.3"/>
  <rect x="60" y="1" width="30" height="29" fill="#]] .. color_base .. [[" fill-opacity="0.3"/>
</svg>
]]

file = io.open(pass .. '/img/back_item_active.svg', 'w+')

file:write(answer)
file:close()

m_simpleTV.Config.Apply('NEED_MAIN_VIEW_UPDATE')
m_simpleTV.Config.Apply('NEED_CONTROLPANELBASE_UPDATE')
m_simpleTV.Config.Apply('NEED_STANDALONE_PLAYLIST_UPDATE')
