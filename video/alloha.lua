-- видеоскрипт для видеобалансера "alloha" https://api.alloha.tv/ (01/09/24)
-- author west_side
-- ## открывает подобные ссылки ##
-- https://api.alloha.tv/?token=...&imdb=...
-- https://api.alloha.tv/?token=...&tmdb=...
-- https://api.alloha.tv/?token=...&kp=...
-- https://api.alloha.tv/?token=...&name=...

	if m_simpleTV.Control.ChangeAddress ~= 'No' then 
		return 
	end
	if not m_simpleTV.Control.CurrentAddress:match('^https?://api%.alloha%.tv')
	and not m_simpleTV.Control.CurrentAddress:match('^https?://api%.alloha%.tv') then
		return
	end
	local inAdr = m_simpleTV.Control.CurrentAddress
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36')
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 12000)
	local rc, answer = m_simpleTV.Http.Request(session, {url = inAdr})
	debug_in_file(unescape3(answer):gsub('\\',''), 'c://1/allo.txt')
	m_simpleTV.Control.SetNewAddressT({address = 'wait'})