-- (03/06/23)
	function httpTimeshiftTestEvent(eventType, eventParams)
		if eventType == 'StartProcessing'
		then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if eventParams.queryType == 'Start'
			then
				if eventParams.params.offset > 0 then
					local timeshift_date = os.date('%x %X', (os.time() - (eventParams.params.offset / 1000)))
					local month, day, year, hour, min, _ = timeshift_date:match('(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)')
					if day and month and hour and min then
						day = string.format('%d', day)
						hour = string.format('%d', hour)
						month = tonumber(month)
						local t = {'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',}
						month = t[month]
						local str = ' (Архив ' .. day .. ' ' .. month .. ' в ' .. hour .. ':' .. min .. ')'
						local title = m_simpleTV.Control.GetTitle()
						title = title:gsub(' %(Архив.-$','') .. str
						m_simpleTV.OSD.ShowMessageT({text = title, showTime = 1000 * 5, id = 'channelName'})
						if m_simpleTV.Control.ChannelID ~= 268435455 then
							m_simpleTV.Control.SetTitle(title)
						end
					end
				end
			end
			if
				not (eventParams.params.address:match('limehd%.') -- limeHD
						and m_simpleTV.User
						and m_simpleTV.User.infolink
						and m_simpleTV.User.infolink.catchup)
				and not ((eventParams.params.address:match('rt%.ru/hls/CH_') -- wink
						or eventParams.params.address:match('ngenix%.net[:%d]*/hls/CH_'))
						and not eventParams.params.rawM3UString:match('catchup'))
				and not (eventParams.params.address:match('strm%.yandex%.ru/ka') -- yandexTV
						and eventParams.params.rawM3UString:match('catchup'))
				and not (eventParams.params.address:match('vcdn%.biz.-/type%.live') -- megogoTV
						and eventParams.params.rawM3UString:match('catchup'))
				and not (eventParams.params.address:match('bluepointtv') -- bluepoint
						and m_simpleTV.User
						and m_simpleTV.User.bluepoint
						and m_simpleTV.User.bluepoint.url_archive)
				and not (eventParams.params.address:match('microimpuls') -- impulsTV
						and m_simpleTV.User
						and m_simpleTV.User.impulstv
						and m_simpleTV.User.impulstv.url_archive)
				and not (eventParams.params.address:match('telecola%.tv') -- telecola
						and m_simpleTV.User
						and m_simpleTV.User.telecola
						and m_simpleTV.User.telecola.cid_sid
						and eventParams.params.rawM3UString:match('catchup'))
				and not (eventParams.params.address:match('%.%w+/iptv/%w+/%d+/index%.m3u8') -- edem
						and ((not eventParams.params.rawM3UString:match('catchup')
							and eventParams.params.rawM3UString:match('tvg%-rec="1"'))
							or eventParams.params.rawM3UString == ''))
				and not (eventParams.params.address:match('iptvx%.tv') -- cbilling
						and ((not eventParams.params.rawM3UString:match('catchup')
							and eventParams.params.rawM3UString:match('tvg%-rec='))
							or eventParams.params.rawM3UString == ''))
			then
			 return
			end
			if eventParams.queryType == 'GetLengthByAddress'
				or eventParams.queryType == 'TestAddress'
				or eventParams.queryType == 'IsRecordAble'
			then
				if eventParams.params.address:match('limehd%.') -- limeHD
				then
					eventParams.params.rawM3UString = m_simpleTV.User.infolink.catchup
				elseif (eventParams.params.address:match('rt%.ru/hls/CH_') -- wink
					or eventParams.params.address:match('ngenix%.net[:%d]*/hls/CH_'))
				then
					eventParams.params.rawM3UString = 'catchup="append" catchup-days="3"'
				elseif eventParams.params.address:match('%.%w+/iptv/%w+/%d+/index%.m3u8') -- edem
				then
					eventParams.params.rawM3UString = 'catchup="append" catchup-days="7"'
				elseif eventParams.params.address:match('iptvx%.tv') -- cbilling
				then
					local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)') or 7
					eventParams.params.rawM3UString = 'catchup="append" catchup-days="' .. days .. '"'
				end
			 return true
			end
			if eventParams.queryType == 'Start'
			then
				if eventParams.params.address:match('limehd%.') -- limeHD
				then
					eventParams.params.rawM3UString = m_simpleTV.User.infolink.catchup
					if eventParams.params.offset > 0 then
						eventParams.params.address = m_simpleTV.User.infolink.url_archive
					end
				elseif (eventParams.params.address:match('rt%.ru/hls/CH_') -- wink
					or eventParams.params.address:match('ngenix%.net[:%d]*/hls/CH_'))
				then
					eventParams.params.rawM3UString = 'catchup="append" catchup-days="3" catchup-source="?offset=-${offset}"'
				elseif eventParams.params.address:match('vcdn%.biz.-/type%.live') -- megogoTV
				then
					if eventParams.params.offset > 0 then
						local offset = math.floor(eventParams.params.offset / 1000)
						local adr = eventParams.params.address:gsub('/ts/%d+/type%.live', '/type%.live')
						adr = adr:gsub('/type%.live', '/ts/' .. offset .. '/type.live')
						eventParams.params.address = adr
					end
				elseif eventParams.params.address:match('strm%.yandex%.ru/ka') -- yandexTV
				then
					if eventParams.params.offset > 0 then
						local endY = os.time() - 120
						local startY = os.time() - (eventParams.params.offset / 1000)
						startY = math.floor(startY)
						if (endY - startY) > (6 * 3600) then
							endY = startY + (6 * 3600)
						end
						eventParams.params.rawM3UString = eventParams.params.rawM3UString:gsub('catchup%-source="%?start=${start}"'
						, 'catchup-source="?start=' .. startY .. '&end=' .. endY ..'"')
					end
				elseif eventParams.params.address:match('bluepointtv') -- bluepoint
				then
					if eventParams.params.offset > 0 then
						eventParams.params.address = m_simpleTV.User.bluepoint.url_archive
					end
				elseif eventParams.params.address:match('microimpuls') -- impulsTV
				then
					if eventParams.params.offset > 0 then
						eventParams.params.address = m_simpleTV.User.impulstv.url_archive
					end
				elseif eventParams.params.address:match('telecola%.tv') -- telecola
				then
					if eventParams.params.offset > 0 then
						eventParams.params.address = telecola(eventParams.params.offset) or eventParams.params.address
					end
				elseif eventParams.params.address:match('%.%w+/iptv/%w+/%d+/index%.m3u8') -- edem
				then
					eventParams.params.rawM3UString = 'catchup="append" catchup-days="7" catchup-source="?utc=${start}&lutc=${timestamp}"'
				elseif eventParams.params.address:match('iptvx%.tv') -- cbilling
				then
					local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)') or 7
					eventParams.params.rawM3UString = 'catchup="append" catchup-days="' .. days .. '" catchup-source="?utc=${start}&lutc=${timestamp}"'
				end
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress'
			then
				if eventParams.params.address:match('limehd%.') -- limeHD
				then
					eventParams.params.address = m_simpleTV.User.infolink.url_archive
					eventParams.params.rawM3UString = m_simpleTV.User.infolink.catchup
				elseif (eventParams.params.address:match('rt%.ru/hls/CH_') -- wink
					or eventParams.params.address:match('ngenix%.net[:%d]*/hls/CH_'))
				then
					eventParams.params.rawM3UString = 'catchup="append" catchup-days="3" catchup-record-source="?utcstart=${start}&utcend=${end}"'
				elseif eventParams.params.address:match('bluepointtv') -- bluepoint
				then
					eventParams.params.address = m_simpleTV.User.bluepoint.url_archive
				elseif eventParams.params.address:match('microimpuls') -- impulsTV
				then
					eventParams.params.address = m_simpleTV.User.impulstv.url_archive
				elseif eventParams.params.address:match('vcdn%.biz.-/type%.live') -- megogoTV
				then
					local offset = math.floor(eventParams.params.offset / 1000)
					local adr = eventParams.params.address:gsub('/ts/%d+/type%.live', '/type%.live')
					adr = adr:gsub('/type%.live', '/ts/' .. offset .. '/type.live')
					eventParams.params.address = adr
				elseif eventParams.params.address:match('%.%w+/iptv/%w+/%d+/index%.m3u8') -- edem
				then
					eventParams.params.rawM3UString = 'catchup="append" catchup-days="7" catchup-source="?utc=${start}&lutc=${timestamp}"'
				elseif eventParams.params.address:match('iptvx%.tv') -- cbilling
				then
					local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)') or 7
					eventParams.params.rawM3UString = 'catchup="append" catchup-days="' .. days .. '" catchup-source="?utc=${start}&lutc=${timestamp}"'
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshiftTestEvent')