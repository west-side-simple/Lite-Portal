-- расширение дополнения httptimeshift - filmax (21/11/21)
-- west_side
	function httpTimeshift_filmax(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('filmax%.pp%.ru')
				and eventParams.params.rawM3UString:match('catchup%-days="%d'))
			then
			 return
			end
			if eventParams.queryType == 'GetLengthByAddress'
				or eventParams.queryType == 'TestAddress'
				or eventParams.queryType == 'IsRecordAble'
			then
				local days = eventParams.params.rawM3UString:match('catchup%-days="(%d+)')
				eventParams.params.address = ''
				eventParams.params.rawM3UString = eventParams.params.rawM3UString:gsub('duration', 'offset')

			 return true
			end
			if eventParams.queryType == 'Start' then
				local days = eventParams.params.rawM3UString:match('catchup%-days="(%d+)')
				eventParams.params.address = ''
				eventParams.params.rawM3UString = eventParams.params.rawM3UString:gsub('duration', 'offset')
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				local days = eventParams.params.rawM3UString:match('catchup%-days="(%d+)')
				eventParams.params.address = ''
				eventParams.params.rawM3UString = eventParams.params.rawM3UString:gsub('duration', 'offset')
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_filmax')