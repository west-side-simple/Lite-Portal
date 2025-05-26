-- расширение дополнения httptimeshift - 1ott.net (26/01/24)
-- west_side
	function httpTimeshift_1ott(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end

			if not (eventParams.params.address:match('1ott%.net'))
				and not (eventParams.params.rawM3UString:match('tvg%-rec="%d') or eventParams.params.rawM3UString:match('timeshift="%d'))
			then
			 return
			end
			if eventParams.queryType == 'GetLengthByAddress'
				or eventParams.queryType == 'TestAddress'
				or eventParams.queryType == 'IsRecordAble'
			then
				local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)') or eventParams.params.rawM3UString:match('timeshift="(%d+)')
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="' .. days .. '"'
			 return true
			end
			if eventParams.queryType == 'Start' then
				local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)') or eventParams.params.rawM3UString:match('timeshift="(%d+)')
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="' .. days .. '" catchup-source="?utc=${start}&lutc=${timestamp}"'
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)') or eventParams.params.rawM3UString:match('timeshift="(%d+)')
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="' .. days .. '" catchup-source="?utc=${start}&lutc=${timestamp}"'
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_1ott')
