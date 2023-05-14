-- скрипт выборочного обновления указанных скраперов TVS одним пакетом или по отдельности.
-- автор westSide 12.05.23
-- положить в папку user/audioWS/
-- вызов на кнопке контрола:
-- для секции на toolbar:
--[[
	 <item alignment="Qt::AlignLeft">
      <widget class="CSkinButton" name="m_UserButton1">
       <property name="sizePolicy">
        <sizepolicy hsizetype="Minimum" vsizetype="Minimum">
         <horstretch>0</horstretch>
         <verstretch>0</verstretch>
        </sizepolicy>
       </property>
	   <property name="minimumSize">
        <size>
         <width>30</width>
         <height>30</height>
        </size>
       </property>
       <property name="cursor">
        <cursorShape>PointingHandCursor</cursorShape>
       </property>
       <property name="focusPolicy">
        <enum>Qt::NoFocus</enum>
       </property>
       <property name="contextMenuPolicy">
        <enum>Qt::NoContextMenu</enum>
       </property>
       <property name="toolButtonStyle">
        <enum>Qt::ToolButtonIconOnly</enum>
       </property>
       <property name="skinImage" stdset="0">
        <stringlist notr="true">
         <string>isalpha=&quot;1&quot; src=&quot;img\osd\toolbar\UpdateScrapers.png&quot; tooltip=&quot;translateMe(Update WS Radio scrapers)&quot;</string>
        </stringlist>
       </property>
       <property name="scriptList" stdset="0">
        <stringlist notr="true">
         <string>action=&quot;OnClick&quot; scr=&quot;dofile(m_simpleTV.MainScriptDir .. 'user/audioWS/WS_radio_scrapers.lua')&quot;</string>
        </stringlist>
       </property>
       <property name="osdTooltip" stdset="0">
        <bool>true</bool>
       </property>
      </widget>
     </item>
--]]
-- для controlpanel:
--[[
 <node class="BUTTON" id="USER_BATTON_1" typeAlign="1" cx="18" cy="18" x="112" y="51">
   <image isalpha="0" autoScale="0" src="img\controlpanel\UpdateScrapers.png" tooltip="translateMe(Update WS Radio scrapers)" />
   <luascr OnClick="dofile( m_simpleTV.MainScriptDir .. 'user/audioWS/WS_radio_scrapers.lua)" />
 </node>
--]]

if package.loaded['tvs_core'] and package.loaded['tvs_func'] then
    local tmp_sources = tvs_core.tvs_GetSourceParam() or {} -- загрузка списка источников из sources.lua
	local tt = {'All Radio','MMX Group','MrFed','NRJ Group','Radio Caprice','Radio Record','Selivanoff','Web Radio'}
	local t = {}
		for i = 1,#tt do
		t[i] = {}
		t[i].Id = i
		t[i].Name = tt[i]
		t[i].Action = tt[i]
		end
	local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('Пакет скраперов WS Radio',0,t,9000,1+4+8)
	if id == nil then return end
	if ret == 1 then
		if id == 1 then
			for SID, v in pairs(tmp_sources) do
				if v.name:find('MMX Group') -- некий признак группы источников, или из таблицы отбирать как-то
				or v.name:find('MrFed')
				or v.name:find('NRJ Group')
				or v.name:find('Radio Caprice')
				or v.name:find('Radio Record')
				or v.name:find('Selivanoff')
				or v.name:find('Web Radio') then
					tvs_func.OSD_mess('Пакет скраперов WS Radio 🔄 ' .. v.name )
					tvs_core.UpdateSource(SID, true) -- процедура обновления
					-- следующие 2 команды не обязательно, можно потестить необходимость
					collectgarbage()
					m_simpleTV.Common.Wait(2000)
				end
			end
		else
			for SID, v in pairs(tmp_sources) do
				if v.name:find(t[id].Name) then
					tvs_func.OSD_mess('WS Radio 🔄 ' .. v.name )
					tvs_core.UpdateSource(SID, true) -- процедура обновления источника
				end
			end
		end
		tvs_func.OSD_mess('')
	end
end
