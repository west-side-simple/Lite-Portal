-- видеоскрипт для видеобалансера "Collaps" (29/03/25)
-- author WS
-- воспроизводит в браузере без рекламы
	if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
		if not m_simpleTV.Control.CurrentAddress:match('^https?://api[%d]*[^/]+/embed/movie/%d+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://api[%d]*[^/]+/embed/kp/%d+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://api[%d]*[^/]+/embed/imdb/tt%d+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://api%..-/embed/kp/%d+')
			and not m_simpleTV.Control.CurrentAddress:match('^https?://api%..-/embed/movie/%d+')
		then
		 return
		end

----------- отображение инфы

	local function ShowInfo(s)
		local q = {}
			q.once = 1
			q.zorder = 0
			q.cx = 0
			q.cy = 0
			q.id = 'WS_INFO'
			q.class = 'TEXT'
			q.align = 0x0202
			q.top = 0
			q.color = 0xFFFFFFF0
			q.font_italic = 0
			q.font_addheight = 6
			q.padding = 20
			q.textparam = 1 + 4
			q.text = s
			q.background = 0
			q.backcolor0 = 0x90000000
		m_simpleTV.OSD.AddElement(q)
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('WS_INFO')
		end
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('WS_INFO')
		end
		if m_simpleTV.Common.WaitUserInput(5000) == 1 then
			m_simpleTV.OSD.RemoveElement('WS_INFO')
		end
		m_simpleTV.OSD.RemoveElement('WS_INFO')
	end

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 10000)
	local rc,answer = m_simpleTV.Http.Request(session,{url = m_simpleTV.Control.CurrentAddress})
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAdress = 'wait'

	local ad = [[
    var middleCount = 0,
	    adTimeouts = { loading: 1000, starting: 1000, toNextImp: 1000, global: 1000 },
        adsConfig = {
	    nonLinear: {
		    fallbackOnly: false,
		    url: "https://usesentry.com/load-xml/?id=7875&type=nonlinear&dcc=1",
		    total:  0 ,
		    offset:  300 ,
		    label: { name: 'label', val: 'overlay', counter: true }
	    },

        pre: {
	        vast: { timeouts: adTimeouts, sequential: true },
            maxImpressions:  2 ,
	        urls: ["https://usesentry.com/load-xml/?id=5241&roll=pre&dcc=1&maximp=2"]

        },

        middle: {
	        offset: 10 * 60,
	        vast: {
                sequential: true,
				timeouts: {loading: 1000, starting: 1000, global: 1000}
            },
	        nonLinearFallback: true,
            pop: true,
            total:  0 ,
            maxImpressions: 1,
            urls: ["https://usesentry.com/load-xml/?id=21515&maximp=1&dcc=1&mid=6","https://usesentry.com/load-xml/?id=5242&maximp=1&dcc=1&mid=6"]
,
	        getUrls: function () {
		        var u = middleCount && adsConfig.middle.urls
			        ? adsConfig.middle.urls.slice(1)
			        : adsConfig.middle.urls;
		        middleCount++;
		        return u;
	        },
            label: { name: 'roll', val: 'mid', counter: true }
        },

        post: {
	        vast: {
		        sequential: true,
		        timeouts: { loading: 1000, starting: 1000, global: 1000 }
	        },
	        exitFullscreenVideo: true,
			skipCD: true,
            maxImpressions: 1,
            urls: ["https://usesentry.com/load-xml/?id=54851&roll=post&maximp=1&dcc=1"]

        },

        confirmTimeout: 60 * 1000,
        confirmOn: ['localhost'],
        vast: { timeouts: adTimeouts },
	    toLongSkip: 50,
        volume: 0.3,
        tv: true,
        midThenNonLinear:  true
    };
	]]
	answer = answer:gsub('<script data%-name="ad">.-</script>','<script data-name="ad">\n' .. ad .. '</script>')
	local fileName = 'Collaps'
--	debug_in_file(answer .. '\n','c://1/ans_collaps.txt')

	require 'lfs'
	local fileEnd = '.html'
	local folderWS = m_simpleTV.Common.GetMainPath(1) .. m_simpleTV.Common.UTF8ToMultiByte('COLLAPS_HTML/')
	lfs.mkdir(folderWS)
	local filePath = folderWS .. m_simpleTV.Common.UTF8ToMultiByte(fileName) .. fileEnd
	local fhandle = io.open(filePath, 'w+')
	m_simpleTV.OSD.ShowMessageT({text = '', showTime = 1000 * 1, id = 'channelName'})
	if fhandle then
		fhandle:write(answer)
		fhandle:close()
--		debug_in_file(filePath:gsub(' ','%%20') .. '\n')
--		ShowInfo('HTML сохранен в файл\n' .. fileName .. fileEnd .. ' в папку\n' .. m_simpleTV.Common.multiByteToUTF8(folderWS))
		return m_simpleTV.Interface.OpenLink('file:///' .. filePath:gsub(' ','%%20'))
	else
		return ShowInfo('невозможно сохранить HTML')
	end