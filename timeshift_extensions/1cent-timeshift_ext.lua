-- расширение дополнения httptimeshift - 1cent.net (20/06/22)
-- west_side
	function httpTimeshift_1cent(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not eventParams.params.address:match('only4%.tv')
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
	httpTimeshift.addEventExecutor('httpTimeshift_1cent')
