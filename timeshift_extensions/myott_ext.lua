-- расширение дополнения httptimeshift - http://myott.top/ (20/04/22)
-- west_side
	function httpTimeshift_myott(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not eventParams.params.address:match('myott%.top')
			then
			 return
			end
			if eventParams.queryType == 'GetLengthByAddress'
				or eventParams.queryType == 'TestAddress'
				or eventParams.queryType == 'IsRecordAble'
			then
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="7"'
			 return true
			end
			if eventParams.queryType == 'Start' then
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="7" catchup-source="?utc=${start}&lutc=${timestamp}"'
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="7" catchup-source="?utc=${start}&lutc=${timestamp}"'
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_myott')
