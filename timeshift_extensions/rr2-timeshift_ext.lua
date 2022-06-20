-- расширение дополнения httptimeshift - rr2 (03/06/21)
-- west_side
	function httpTimeshift_rr2(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('rr2%.73mtv%.org')
				and eventParams.params.rawM3UString:match('tvg%-rec="%d'))
			then
			 return
			end
			if eventParams.queryType == 'GetLengthByAddress'
				or eventParams.queryType == 'TestAddress'
				or eventParams.queryType == 'IsRecordAble'
			then
				local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)')
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="' .. days .. '"'
			 return true
			end
			if eventParams.queryType == 'Start' then
				local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)')
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="' .. days .. '" catchup-source="?utc=${start}&lutc=${timestamp}"'
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				local days = eventParams.params.rawM3UString:match('tvg%-rec="(%d+)')
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="' .. days .. '" catchup-source="?utc=${start}&lutc=${timestamp}"'
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_rr2')
