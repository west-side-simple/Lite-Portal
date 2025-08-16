	if m_simpleTV.Control.ChangeAdress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAdress
	if not inAdr then return end
	if not inAdr:match('^kp_trailer=%d+')
	then return end
	if not m_simpleTV.User.TVPortal.trailer_data then
		m_simpleTV.User.TVPortal.trailer_data = {}
	end
	local kp_id = inAdr:match('^kp_trailer=(%d+)')
	local adr = inAdr:match('%&(.-)$')
	local bal = adr:match('%&balanser=(.-)%&')
	
local function Test_Trailer()
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = 'https://widgets.kinopoisk.ru/discovery/film/300/?from=discovery_player'
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
	debug_in_file(rc .. '\n' .. unescape(answer:match('<script type="application/json" data%-state>(.-)</script>')) .. '\n','c://1/discovery.txt')
	
end	
--Test_Trailer()	
local function Get_Trailer(kp_id)
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0')
	if not session then return false end
	m_simpleTV.Http.SetTimeout(session, 2000)
	local url = 'https://upn.pris.cam/https://widgets.kinopoisk.ru/discovery/api/trailers?params=' .. kp_id .. '%2C0%2C%200%2C%20rnd-0.07813094955279343&_=1749476824905'
	local rc, answer = m_simpleTV.Http.Request(session, {url = url})
--	debug_in_file(rc .. '\n' .. answer .. '\n')
	if rc~=200 then
		m_simpleTV.Http.Close(session)
		m_simpleTV.User.TVPortal.trailer = false
		return false
	end
--	"title":"Форсаж","originalTitle":"The Fast and the Furious","displayTitle":"Форсаж","img":{"posterMedium":{"x1":"//avatars.mds.yandex.net/get-kinopoisk-image/6201401/8277905e-aa09-465d-b0de-7c389a42f215/180","x2":"//avatars.mds.yandex.net/get-kinopoisk-image/6201401/8277905e-aa09-465d-b0de-7c389a42f215/360"},"poster":{"x1":"//avatars.mds.yandex.net/get-kinopoisk-image/6201401/8277905e-aa09-465d-b0de-7c389a42f215/60","x2":"//avatars.mds.yandex.net/get-kinopoisk-image/6201401/8277905e-aa09-465d-b0de-7c389a42f215/120"}},"genres":["боевик","триллер","криминал"],"kinopoiskRating":{"type":"positive","value":"7.8","count":429697,"ready":true},"ratings":{"type":"positive","value":"7.8","count":429697,"ready":true},"year":"2001","relativeUrl":"/film/666/?from=discovery_player","type":"MOVIE","country":{"name":"США"}
	
	
	
	if answer:match('streamUrl":".-"') then
		m_simpleTV.User.TVPortal.trailer = true		
		local logo = answer:match('"posterMedium".-"x2":"(.-)"') or ''
		m_simpleTV.User.TVPortal.trailer_data.logo = 'https:' .. logo
		m_simpleTV.User.TVPortal.trailer_data.title = answer:match('"title":"(.-)"') or ''
		m_simpleTV.User.TVPortal.trailer_data.original_title = answer:match('"originalTitle":"(.-)"') or ''
		m_simpleTV.User.TVPortal.trailer_data.year = answer:match('"year":"(.-)"') or ''
		m_simpleTV.User.TVPortal.trailer_data.country = answer:match('"country".-"name":"(.-)"') or ''
		m_simpleTV.User.TVPortal.trailer_data.genres = answer:match('"genres":%[(.-)%]') or ''
		m_simpleTV.User.TVPortal.trailer_data.rating = answer:match('"value":"(.-)"') or ''
		m_simpleTV.User.westSide.PortalTable = true
--		debug_in_file(answer:match('streamUrl":"(.-)"') .. '\n')
		return answer:match('streamUrl":"(.-)"')
	end
	m_simpleTV.User.TVPortal.trailer = false
	return false
end



	local retAdr = Get_Trailer(kp_id)
	local t1, title
	if adr then
	t1, title = get_media_info(adr)
	end
	m_simpleTV.Control.ChangeChannelLogo(m_simpleTV.User.TVPortal.trailer_data.logo , m_simpleTV.Control.ChannelID, 'CHANGE_IF_NOT_EQUAL')
	m_simpleTV.Control.CurrentTitle_UTF8 = m_simpleTV.User.TVPortal.trailer_data.title .. ' (' .. m_simpleTV.User.TVPortal.trailer_data.year .. ')'
	m_simpleTV.Control.SetTitle(m_simpleTV.User.TVPortal.trailer_data.title .. ' (' .. m_simpleTV.User.TVPortal.trailer_data.year .. ')')	

	m_simpleTV.Control.SetNewAddressT({address= retAdr, title= m_simpleTV.User.TVPortal.trailer_data.title .. ' (' .. m_simpleTV.User.TVPortal.trailer_data.year .. ')'})