-- расширение дополнения httptimeshift - PortalTV WS (16/09/23)
-- west_side
	function httpTimeshift_portalTV(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not eventParams.params.address:match('^portalTV=%d+&channel=%d+')
			then
			 return
			end
			if not (eventParams.params.rawM3UString:match('tvg%-rec="%d') or eventParams.params.rawM3UString:match('catchup%-days="%d'))
			then
			 return
			end
			if eventParams.queryType == 'GetLengthByAddress'
				or eventParams.queryType == 'TestAddress'
				or eventParams.queryType == 'IsRecordAble'
			then
				local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)') or eventParams.params.rawM3UString:match('catchup%-days="(%d+)')
				eventParams.params.rawM3UString = 'catchup-days="' .. days .. '" catchup="shift"'
			 return true
			end
			if eventParams.queryType == 'Start' then
				local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)') or eventParams.params.rawM3UString:match('catchup%-days="(%d+)')
				eventParams.params.rawM3UString = 'catchup-days="' .. days .. '" catchup="shift"'
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)') or eventParams.params.rawM3UString:match('catchup%-days="(%d+)')
				eventParams.params.rawM3UString = 'catchup-days="' .. days .. '" catchup="shift"'
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_portalTV')
