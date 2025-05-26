	if m_simpleTV.User==nil then m_simpleTV.User={} end
	if m_simpleTV.User.TVPortal==nil then m_simpleTV.User.TVPortal={} end

	local function getConfigVal(key)
		return m_simpleTV.Config.GetValue(key,"PortalTV.ini")
	end

	local function setConfigVal(key,val)
		m_simpleTV.Config.SetValue(key,val,"PortalTV.ini")
	end

	function OnNavigateComplete(Object)
		local value
		value= getConfigVal("Portal_TV_WS_Enable") or 1
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'Portal_TV_WS_Enable',value)
		
		value= getConfigVal("Portal_TV_WS_desc_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'Portal_TV_WS_desc_Enable',value)
		
		value= getConfigVal("Portal_TV_WS_mes_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'Portal_TV_WS_mes_Enable',value)
		
		value= getConfigVal("Portal_TV_WS_epg_Enable") or 1
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'Portal_TV_WS_epg_Enable',value)
		
		value= getConfigVal("Portal_TV_WS_info_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'Portal_TV_WS_info_Enable',value)
		
		value= getConfigVal("PortalTV_1_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_1_Enable',value)

		value= getConfigVal("PortalTV_1_Name") or m_simpleTV.Common.UTF8ToMultiByte('Слот 1')
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_1_Name', value)

		value= getConfigVal("PortalTV_1_Address") or ''
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_1_Address',value)

		m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','PortalTV_1_default','OnClick_PortalTV_1_default')

		value= getConfigVal("PortalTV_2_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_2_Enable',value)

		value= getConfigVal("PortalTV_2_Name") or m_simpleTV.Common.UTF8ToMultiByte('Слот 2')
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_2_Name', value)

		value= getConfigVal("PortalTV_2_Address") or ''
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_2_Address',value)

		m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','PortalTV_2_default','OnClick_PortalTV_2_default')

		value= getConfigVal("PortalTV_3_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_3_Enable',value)

		value= getConfigVal("PortalTV_3_Name") or m_simpleTV.Common.UTF8ToMultiByte('Слот 3')
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_3_Name', value)

		value= getConfigVal("PortalTV_3_Address") or ''
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_3_Address',value)

		m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','PortalTV_3_default','OnClick_PortalTV_3_default')

		value= getConfigVal("PortalTV_4_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_4_Enable',value)

		value= getConfigVal("PortalTV_4_Name") or m_simpleTV.Common.UTF8ToMultiByte('Слот 4')
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_4_Name', value)

		value= getConfigVal("PortalTV_4_Address") or ''
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_4_Address',value)

		m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','PortalTV_4_default','OnClick_PortalTV_4_default')

		value= getConfigVal("PortalTV_5_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_5_Enable',value)

		value= getConfigVal("PortalTV_5_Name") or m_simpleTV.Common.UTF8ToMultiByte('Слот 5')
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_5_Name', value)

		value= getConfigVal("PortalTV_5_Address") or ''
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_5_Address',value)

		m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','PortalTV_5_default','OnClick_PortalTV_5_default')

		value= getConfigVal("PortalTV_6_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_6_Enable',value)

		value= getConfigVal("PortalTV_6_Name") or m_simpleTV.Common.UTF8ToMultiByte('Слот 6')
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_6_Name', value)

		value= getConfigVal("PortalTV_6_Address") or ''
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_6_Address',value)

		m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','PortalTV_6_default','OnClick_PortalTV_6_default')

		value= getConfigVal("PortalTV_7_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_7_Enable',value)

		value= getConfigVal("PortalTV_7_Name") or m_simpleTV.Common.UTF8ToMultiByte('Слот 7')
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_7_Name', value)

		value= getConfigVal("PortalTV_7_Address") or ''
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_7_Address',value)

		m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','PortalTV_7_default','OnClick_PortalTV_7_default')

		value= getConfigVal("PortalTV_8_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_8_Enable',value)

		value= getConfigVal("PortalTV_8_Name") or m_simpleTV.Common.UTF8ToMultiByte('Слот 8')
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_8_Name', value)

		value= getConfigVal("PortalTV_8_Address") or ''
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_8_Address',value)

		m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','PortalTV_8_default','OnClick_PortalTV_8_default')

		value= getConfigVal("PortalTV_9_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_9_Enable',value)

		value= getConfigVal("PortalTV_9_Name") or m_simpleTV.Common.UTF8ToMultiByte('Слот 9')
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_9_Name', value)

		value= getConfigVal("PortalTV_9_Address") or ''
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_9_Address',value)

		m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','PortalTV_9_default','OnClick_PortalTV_9_default')

		value= getConfigVal("PortalTV_10_Enable") or 0
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_10_Enable',value)

		value= getConfigVal("PortalTV_10_Name") or m_simpleTV.Common.UTF8ToMultiByte('Слот 10')
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_10_Name', value)

		value= getConfigVal("PortalTV_10_Address") or ''
		m_simpleTV.Dialog.SetElementValueString(Object,'PortalTV_10_Address',value)
		
		value= getConfigVal("Portal_TV_FavCh") or ''
		m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'Portal_TV_FavCh',value)
		
		value= getConfigVal("Portal_TV_FavGr") or ''
		m_simpleTV.Dialog.SetElementValueString_UTF8(Object,'Portal_TV_FavGr',value)

		m_simpleTV.Dialog.AddEventHandler(Object,'OnClick','PortalTV_10_default','OnClick_PortalTV_10_default')
		
		value= getConfigVal("image_proxy") or "http://image.tmdb.org"
		local value1
			if value == "http://image.tmdb.org" then
				value1 = 0
			end
			if value == "https://img.lkpma.xyz" then
				value1 = 1
			end
			if value == "http://proxy.vokino.tv/image" then
				value1 = 2
			end					
		m_simpleTV.Dialog.SelectComboIndex(Object,"image_proxy",value1)
		
	end

	function OnOk(Object)

		local value
		
		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'Portal_TV_WS_Enable')
		if value ~= nil then
			setConfigVal("Portal_TV_WS_Enable",value)
			m_simpleTV.User.TVPortal.Use = 1
			if tonumber(value) == 0 then
				m_simpleTV.User.TVPortal.Use = 0
			end
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'Portal_TV_WS_desc_Enable')
		if value ~= nil then
			setConfigVal("Portal_TV_WS_desc_Enable",value)
			m_simpleTV.User.TVPortal.UseDesc = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.UseDesc = 1
			end
		end
		
		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'Portal_TV_WS_mes_Enable')
		if value ~= nil then
			setConfigVal("Portal_TV_WS_mes_Enable",value)
			m_simpleTV.User.TVPortal.UseMes = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.UseMes = 1
			end
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'Portal_TV_WS_epg_Enable')
		if value ~= nil then
			setConfigVal("Portal_TV_WS_epg_Enable",value)
			m_simpleTV.User.TVPortal.is_epg = 0
			if m_simpleTV.User.TVPortal.epg.id then
				m_simpleTV.Interface.RemoveExtMenu(m_simpleTV.User.TVPortal.epg.id)
			end
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.is_epg = 1
--				m_simpleTV.Interface.AddExtMenuT(m_simpleTV.User.TVPortal.epg)
			end
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'Portal_TV_WS_info_Enable')
		
		if value ~= nil then
			setConfigVal("Portal_TV_WS_info_Enable",value)
			m_simpleTV.User.TVPortal.is_button = 0						
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.is_button = 1				
			end
			for i = 1, #m_simpleTV.User.TVPortal.button.id do
				m_simpleTV.PlayList.RemoveItemButton(m_simpleTV.User.TVPortal.button.id[i])
			end
		end
		
		dofile(m_simpleTV.MainScriptDir .. "user/startup/show_mi.lua")
		
		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'PortalTV_1_Enable')
		if value ~= nil then
			setConfigVal("PortalTV_1_Enable",value)
			m_simpleTV.User.TVPortal.Use_PortalTV_1 = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.Use_PortalTV_1 = 1
			end
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_1_Name')
		if value ~= nil then
			setConfigVal("PortalTV_1_Name",value)
			m_simpleTV.User.TVPortal.Name_PortalTV_1 = value
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_1_Address')
		if value ~= nil then
			setConfigVal("PortalTV_1_Address",value)
			m_simpleTV.User.TVPortal.Address_PortalTV_1 = value
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'PortalTV_2_Enable')
		if value ~= nil then
			setConfigVal("PortalTV_2_Enable",value)
			m_simpleTV.User.TVPortal.Use_PortalTV_2 = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.Use_PortalTV_2 = 1
			end
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_2_Name')
		if value ~= nil then
			setConfigVal("PortalTV_2_Name",value)
			m_simpleTV.User.TVPortal.Name_PortalTV_2 = value
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_2_Address')
		if value ~= nil then
			setConfigVal("PortalTV_2_Address",value)
			m_simpleTV.User.TVPortal.Address_PortalTV_2 = value
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'PortalTV_3_Enable')
		if value ~= nil then
			setConfigVal("PortalTV_3_Enable",value)
			m_simpleTV.User.TVPortal.Use_PortalTV_3 = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.Use_PortalTV_3 = 1
			end
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_3_Name')
		if value ~= nil then
			setConfigVal("PortalTV_3_Name",value)
			m_simpleTV.User.TVPortal.Name_PortalTV_3 = value
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_3_Address')
		if value ~= nil then
			setConfigVal("PortalTV_3_Address",value)
			m_simpleTV.User.TVPortal.Address_PortalTV_3 = value
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'PortalTV_4_Enable')
		if value ~= nil then
			setConfigVal("PortalTV_4_Enable",value)
			m_simpleTV.User.TVPortal.Use_PortalTV_4 = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.Use_PortalTV_4 = 1
			end
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_4_Name')
		if value ~= nil then
			setConfigVal("PortalTV_4_Name",value)
			m_simpleTV.User.TVPortal.Name_PortalTV_4 = value
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_4_Address')
		if value ~= nil then
			setConfigVal("PortalTV_4_Address",value)
			m_simpleTV.User.TVPortal.Address_PortalTV_4 = value
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'PortalTV_5_Enable')
		if value ~= nil then
			setConfigVal("PortalTV_5_Enable",value)
			m_simpleTV.User.TVPortal.Use_PortalTV_5 = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.Use_PortalTV_5 = 1
			end
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_5_Name')
		if value ~= nil then
			setConfigVal("PortalTV_5_Name",value)
			m_simpleTV.User.TVPortal.Name_PortalTV_5 = value
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_5_Address')
		if value ~= nil then
			setConfigVal("PortalTV_5_Address",value)
			m_simpleTV.User.TVPortal.Address_PortalTV_5 = value
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'PortalTV_6_Enable')
		if value ~= nil then
			setConfigVal("PortalTV_6_Enable",value)
			m_simpleTV.User.TVPortal.Use_PortalTV_6 = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.Use_PortalTV_6 = 1
			end
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_6_Name')
		if value ~= nil then
			setConfigVal("PortalTV_6_Name",value)
			m_simpleTV.User.TVPortal.Name_PortalTV_6 = value
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_6_Address')
		if value ~= nil then
			setConfigVal("PortalTV_6_Address",value)
			m_simpleTV.User.TVPortal.Address_PortalTV_6 = value
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'PortalTV_7_Enable')
		if value ~= nil then
			setConfigVal("PortalTV_7_Enable",value)
			m_simpleTV.User.TVPortal.Use_PortalTV_7 = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.Use_PortalTV_7 = 1
			end
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_7_Name')
		if value ~= nil then
			setConfigVal("PortalTV_7_Name",value)
			m_simpleTV.User.TVPortal.Name_PortalTV_7 = value
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_7_Address')
		if value ~= nil then
			setConfigVal("PortalTV_7_Address",value)
			m_simpleTV.User.TVPortal.Address_PortalTV_7 = value
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'PortalTV_8_Enable')
		if value ~= nil then
			setConfigVal("PortalTV_8_Enable",value)
			m_simpleTV.User.TVPortal.Use_PortalTV_8 = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.Use_PortalTV_8 = 1
			end
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_8_Name')
		if value ~= nil then
			setConfigVal("PortalTV_8_Name",value)
			m_simpleTV.User.TVPortal.Name_PortalTV_8 = value
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_8_Address')
		if value ~= nil then
			setConfigVal("PortalTV_8_Address",value)
			m_simpleTV.User.TVPortal.Address_PortalTV_8 = value
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'PortalTV_9_Enable')
		if value ~= nil then
			setConfigVal("PortalTV_9_Enable",value)
			m_simpleTV.User.TVPortal.Use_PortalTV_9 = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.Use_PortalTV_9 = 1
			end
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_9_Name')
		if value ~= nil then
			setConfigVal("PortalTV_9_Name",value)
			m_simpleTV.User.TVPortal.Name_PortalTV_9 = value
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_9_Address')
		if value ~= nil then
			setConfigVal("PortalTV_9_Address",value)
			m_simpleTV.User.TVPortal.Address_PortalTV_9 = value
		end

		value=m_simpleTV.Dialog.GetCheckBoxValue(Object,'PortalTV_10_Enable')
		if value ~= nil then
			setConfigVal("PortalTV_10_Enable",value)
			m_simpleTV.User.TVPortal.Use_PortalTV_10 = 0
			if tonumber(value) == 1 then
				m_simpleTV.User.TVPortal.Use_PortalTV_10 = 1
			end
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_10_Name')
		if value ~= nil then
			setConfigVal("PortalTV_10_Name",value)
			m_simpleTV.User.TVPortal.Name_PortalTV_10 = value
		end

		value = m_simpleTV.Dialog.GetElementValueString(Object,'PortalTV_10_Address')
		if value ~= nil then
			setConfigVal("PortalTV_10_Address",value)
			m_simpleTV.User.TVPortal.Address_PortalTV_10 = value
		end
		
		value=m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'Portal_TV_FavCh')
		if value~=nil then
			setConfigVal("Portal_TV_FavCh",value)
		end
		
		value=m_simpleTV.Dialog.GetElementValueString_UTF8(Object,'Portal_TV_FavGr')
		if value~=nil then
			setConfigVal("Portal_TV_FavGr",value)
		end
		
		value = m_simpleTV.Dialog.GetComboValue_UTF8(Object,"image_proxy")
		if value ~= nil then
		setConfigVal("image_proxy",value)
		m_simpleTV.User.TVPortal.proxy_image = value
		end

	end

	function OnClick_PortalTV_1_default(Object)
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_1_Enable',0)
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_1_Name',m_simpleTV.Common.UTF8ToMultiByte('Слот 1'))
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_1_Address','')
	end

	function OnClick_PortalTV_2_default(Object)
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_2_Enable',0)
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_2_Name',m_simpleTV.Common.UTF8ToMultiByte('Слот 2'))
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_2_Address','')
	end

	function OnClick_PortalTV_3_default(Object)
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_3_Enable',0)
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_3_Name',m_simpleTV.Common.UTF8ToMultiByte('Слот 3'))
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_3_Address','')
	end

	function OnClick_PortalTV_4_default(Object)
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_4_Enable',0)
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_4_Name',m_simpleTV.Common.UTF8ToMultiByte('Слот 4'))
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_4_Address','')
	end

	function OnClick_PortalTV_5_default(Object)
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_5_Enable',0)
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_5_Name',m_simpleTV.Common.UTF8ToMultiByte('Слот 5'))
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_5_Address','')
	end

	function OnClick_PortalTV_6_default(Object)
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_6_Enable',0)
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_6_Name',m_simpleTV.Common.UTF8ToMultiByte('Слот 6'))
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_6_Address','')
	end

	function OnClick_PortalTV_7_default(Object)
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_7_Enable',0)
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_7_Name',m_simpleTV.Common.UTF8ToMultiByte('Слот 7'))
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_7_Address','')
	end

	function OnClick_PortalTV_8_default(Object)
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_8_Enable',0)
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_8_Name',m_simpleTV.Common.UTF8ToMultiByte('Слот 8'))
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_8_Address','')
	end

	function OnClick_PortalTV_9_default(Object)
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_9_Enable',0)
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_9_Name',m_simpleTV.Common.UTF8ToMultiByte('Слот 9'))
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_9_Address','')
	end

	function OnClick_PortalTV_10_default(Object)
		m_simpleTV.Dialog.SetCheckBoxValue(Object,'PortalTV_10_Enable',0)
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_10_Name',m_simpleTV.Common.UTF8ToMultiByte('Слот 10'))
		m_simpleTV.Dialog.SetElementText(Object,'PortalTV_10_Address','')
	end