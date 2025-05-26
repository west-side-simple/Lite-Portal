-- скрапер TVS для загрузки плейлиста "DENMS TV" http://denms.tplinkdns.com/ (03/11/24)
-- ## Переименовать каналы ##
local filter = {
	{'Наука', 'Наука UA'},
	}
-- ##

	module('denms_plus_pls', package.seeall)
	local my_src_name = 'DENMS TV - StarNet (A)'

	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/81.0.3785.143 Safari/537.36')
		if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)

	local function ProcessFilterTableLocal(t)
		if not type(t) == 'table' then return end
		for i = 1, #t do
			t[i].name = tvs_core.tvs_clear_double_space(t[i].name)
			for _, ff in ipairs(filter) do
				if (type(ff) == 'table' and t[i].name == ff[1]) then
					t[i].name = ff[2]
				end
			end
		end
	 return t
	end
	function GetSettings()
	 return {name = my_src_name, sortname = '', scraper = '', m3u = 'out_' .. my_src_name .. '.m3u', logo = '../Channel/logo/extFiltersLogo/denms.png', TypeSource = 1, TypeCoding = 1, DeleteM3U = 1, RefreshButton = 0, AutoBuild = 0, AutoBuildDay = {0, 0, 0, 0, 0, 0, 0}, LastStart = 0, TVS = {add = 0, FilterCH = 0, FilterGR = 0, GetGroup = 0, LogoTVG = 0}, STV = {add = 1, ExtFilter = 1, FilterCH = 0, FilterGR = 0, GetGroup = 1, HDGroup = 0, AutoSearch = 1, AutoSearchLogo =1, AutoNumber = 0, NumberM3U = 0, GetSettings = 1, NotDeleteCH = 0, TypeSkip = 1, TypeFind = 1, TypeMedia = 0, RemoveDupCH = 1}}
	end
	function GetVersion()
	 return 2, 'UTF-8'
	end

	local function Get_adr_for_name(name)
		local tt = {
		{"Boomerang", "http://hls.stb.md/BOOMERANGTV_H264/video.m3u8?token="},
		{"Cartoon Network RO HD", "http://hls.stb.md/CARTOON_NETWORKRO_H264/video.m3u8?token="},
		{"Cartoon Network RU", "http://hls.stb.md/CARTOON_NETWORKRU_H264/video.m3u8?token="},
		{"Da Vinci Learning Россия", "http://hls.stb.md/DAVINCI_LEARNING_H264/video.m3u8?token="},
		{"Disney Channel", "http://hls.stb.md/DISNEY_CHANNELRO_H264/video.m3u8?token="},
		{"Disney Junior", "http://hls.stb.md/DISNEY_JUNIOR_H264/video.m3u8?token="},
		{"Duck TV HD", "http://hls.stb.md/DUCKTVHD_H264/video.m3u8?token="},
		{"Nick Jr.", "http://hls.stb.md/NICK_JR_H264/video.m3u8?token="},
		{"Nickelodeon HD", "http://hls.stb.md/NICKELODEON_HD_H264/video.m3u8?token="},
		{"Nickelodeon", "http://hls.stb.md/NICKELODEON_H264/video.m3u8?token="},
		{"Nickelodeon RO", "http://hls1.stb.md/NICKELODEON_H264/video.m3u8?token="},
		{"Nicktoons", "http://hls.stb.md/NICKTOONS_H264/video.m3u8?token="},
		{"TraLaLa TV HD", "http://hls.stb.md/TRALALA_HD_H264/video.m3u8?token="},
		{"Капитан Фантастика HD", "http://hls.stb.md/KAPITAN_FANTASTIKA_HD_H264/video.m3u8?token="},
		{"Карусель", "http://hls.stb.md/KARUSELI_H264/video.m3u8?token="},
		{"Малыш ТВ", "http://hls.stb.md/MALISH_H264/video.m3u8?token="},
		{"МУЛЬТ HD", "http://hls.stb.md/MULIT_H264/video.m3u8?token="},
		{"Рыжий", "http://hls.stb.md/RIJII_H264/video.m3u8?token="},
		{"СТС Kids", "http://hls.stb.md/CTC_KIDS_H264/video.m3u8?token="},
		{"BBC World News HD", "http://hls.stb.md/BBCWORLDNEWSEUROPE_HD_H264/video.m3u8?token="},
		{"Deutsche Welle Deutsch", "http://hls.stb.md/DE_DW_H264/video.m3u8?token="},
		{"Deutsche Welle EN HD", "http://hls.stb.md/DW_H264/video.m3u8?token="},
		{"France 24 English", "http://hls.stb.md/FRANCE_24ENG_H264/video.m3u8?token="},
		{"France 24 Francais", "http://hls.stb.md/FRANCE_24FR_H264/video.m3u8?token="},
		{"TV5 Monde", "http://hls.stb.md/TV5_MONDEEUROPE_H264/video.m3u8?token="},
		{"CNN HD", "http://hls.stb.md/CNN_H264/video.m3u8?token="},
		{"EuroNews ENG HD", "http://hls.stb.md/EURONEWS_H264/video.m3u8?token="},
		{"RTVi", "http://hls.stb.md/RTVI_EUROPE_H264/video.m3u8?token="},
		{"Настоящее время", "http://hls.stb.md/NASTOIASHIE_VREMEA_H264/video.m3u8?token="},
		{"Cinema", "http://hls.stb.md/CINEMA_H264/video.m3u8?token="},
		{"Film.Ua Drama", "http://hls.stb.md/FILMUA_DRAMA_H264/video.m3u8?token="},
		{"Paramount Channel", "http://hls.stb.md/PARAMOUNT_CHANNEL_H264/video.m3u8?token="},
		{"Paramount Comedy", "http://hls2.stb.md/PARAMOUNT_COMEDY_H264/video.m3u8?token="},
		{"Star Cinema HD", "http://hls.stb.md/STARCINEMA_HD_H264/video.m3u8?token="},
		{"Star Family HD", "http://hls.stb.md/STARFAMILY_HD_H264/video.m3u8?token="},
		{"Start Air HD", "http://hls.stb.md/START_AIR_HD_H264/video.m3u8?token="},
		{"Start World HD", "http://hls.stb.md/START_WORLD_HD_H264/video.m3u8?token="},
		{"viju TV1000 action HD", "http://hls.stb.md/TV1000ACTION_HD_H264/video.m3u8?token="},
		{"viju TV1000 HD", "http://hls.stb.md/TV1000_HD_H264/video.m3u8?token="},
		{"viju TV1000 pусское HD", "http://hls.stb.md/TV1000RU_HD_H264/video.m3u8?token="},
		{"viju+ Comedy HD", "http://hls.stb.md/VIP_COMEDYHD_H264/video.m3u8?token="},
		{"viju+ Megahit HD", "http://hls.stb.md/VIP_MEGAHITHD_H264/video.m3u8?token="},
		{"viju+ Premiere HD", "http://hls.stb.md/VIP_PREMIERHD_H264/video.m3u8?token="},
		{"viju+ Serial HD", "http://hls.stb.md/VIP_SERIALHD_H264/video.m3u8?token="},
		{"Zee TV", "http://hls.stb.md/ZEETV_H264/video.m3u8?token="},
		{"Кино ТВ HD", "http://hls1.stb.md/KINOTV_HD_H264/video.m3u8?token="},
		{"Кинокомедия HD", "http://hls.stb.md/KINO_KOMEDYA_H264/video.m3u8?token="},
		{"Киномикс HD", "http://hls.stb.md/KINOMIX_H264/video.m3u8?token="},
		{"Кинопремьера HD", "http://hls.stb.md/KINOPREMIERA_H264/video.m3u8?token="},
		{"Киносат", "http://hls.stb.md/KINOMAN_H264/video.m3u8?token="},
		{"Киносвидание HD", "http://hls.stb.md/KINO_SVIDANIE_H264/video.m3u8?token="},
		{"Киносемья", "http://hls.stb.md/KINOSEMYA_H264/video.m3u8?token="},
		{"Киносерия HD", "http://hls.stb.md/KINOSERYA_H264/video.m3u8?token="},
		{"Кинохит HD", "http://hls.stb.md/KINOHIT_H264/video.m3u8?token="},
		{"Мосфильм. Золотая коллекция", "http://hls.stb.md/MOSFILM_H264/video.m3u8?token="},
		{"Мужское кино", "http://hls.stb.md/MUJSKOE_KINO_H264/video.m3u8?token="},
		{"Наше новое кино", "http://hls.stb.md/NASHENOVOIE_KINO_H264/video.m3u8?token="},
		{"Родное кино", "http://hls.stb.md/RODNOIE_KINO_H264/video.m3u8?token="},
		{"10 TV HD Moldova", "http://hls.stb.md/10TV_H264/video.m3u8?token="},
		{"A7TV HD", "http://hls.stb.md/A7_HD_H264/video.m3u8?token="},
		{"ATV", "http://hls.stb.md/ATV_H264/video.m3u8?token="},
		{"ACASĂ HD", "http://hls.stb.md/ACASA_HD_H264/video.m3u8?token="},
		{"Acasă Gold", "http://hls.stb.md/PRO_GOLD_H264/video.m3u8?token="},
		{"Accent TV", "http://hls.stb.md/ACCENT_TV_H264/video.m3u8?token="},
		{"Agro TV Moldova HD", "http://hls.stb.md/AGROTV_H264/video.m3u8?token="},
		{"Alfa Omega TV", "http://hls.stb.md/ALFA_OMEGA_H264/video.m3u8?token="},
		{"Axial TV HD", "http://hls.stb.md/AXIALTV_H264/video.m3u8?token="},
		{"B1 TV", "http://hls.stb.md/B1_TV_H264/video.m3u8?token="},
		{"BTV HD Moldova", "http://hls.stb.md/BTV_H264/video.m3u8?token="},
		{"Bucuresti TV", "http://hls.stb.md/BUCURESTITV_HD_H264/video.m3u8?token="},
		{"Busuioc TV", "http://hls.stb.md/BUSUIOCTV_H264/video.m3u8?token="},
		{"CNL Европа", "http://hls.stb.md/CNL_H264/video.m3u8?token="},
		{"Canal 2 HD Moldova", "http://hls.stb.md/CANAL2_H264/video.m3u8?token="},
		{"Canal 3 HD Moldova", "http://hls.stb.md/CANAL3_H264/video.m3u8?token="},
		{"Canal 5 Moldova", "http://hls.stb.md/CANAL_5_H264/video.m3u8?token="},
		{"Canal Regional", "http://hls.stb.md/REGIONALTV_H264/video.m3u8?token="},
		{"Cinema 1 HD", "http://hls.stb.md/CINEMA1_H264/video.m3u8?token="},
		{"Clasa 1 RO", "http://hls.stb.md/CLASA1_RO_H264/video.m3u8?token="},
		{"Clasa 1 RU", "http://hls.stb.md/CLASA1_RU_H264/video.m3u8?token="},
		{"Clasa 10 RO", "http://hls.stb.md/CLASA10_RO_H264/video.m3u8?token="},
		{"Clasa 10 RU", "http://hls.stb.md/CLASA10_RU_H264/video.m3u8?token="},
		{"Clasa 11 RO", "http://hls.stb.md/CLASA11_RO_H264/video.m3u8?token="},
		{"Clasa 11 RU", "http://hls.stb.md/CLASA11_RU_H264/video.m3u8?token="},
		{"Clasa 12 RO", "http://hls.stb.md/CLASA12_RO_H264/video.m3u8?token="},
		{"Clasa 12 RU", "http://hls.stb.md/CLASA12_RU_H264/video.m3u8?token="},
		{"Clasa 2 RO", "http://hls.stb.md/CLASA2_RO_H264/video.m3u8?token="},
		{"Clasa 2 RU", "http://hls.stb.md/CLASA2_RU_H264/video.m3u8?token="},
		{"Clasa 3 RO", "http://hls.stb.md/CLASA3_RO_H264/video.m3u8?token="},
		{"Clasa 3 RU", "http://hls.stb.md/CLASA3_RU_H264/video.m3u8?token="},
		{"Clasa 4 RO", "http://hls.stb.md/CLASA4_RO_H264/video.m3u8?token="},
		{"Clasa 4 RU", "http://hls.stb.md/CLASA4_RU_H264/video.m3u8?token="},
		{"Clasa 5 RO", "http://hls.stb.md/CLASA5_RO_H264/video.m3u8?token="},
		{"Clasa 5 RU", "http://hls.stb.md/CLASA5_RU_H264/video.m3u8?token="},
		{"Clasa 6 RO", "http://hls.stb.md/CLASA6_RO_H264/video.m3u8?token="},
		{"Clasa 6 RU", "http://hls.stb.md/CLASA6_RU_H264/video.m3u8?token="},
		{"Clasa 7 RO", "http://hls.stb.md/CLASA7_RO_H264/video.m3u8?token="},
		{"Clasa 7 RU", "http://hls.stb.md/CLASA7_RU_H264/video.m3u8?token="},
		{"Clasa 8 RO", "http://hls.stb.md/CLASA8_RO_H264/video.m3u8?token="},
		{"Clasa 8 RU", "http://hls.stb.md/CLASA8_RU_H264/video.m3u8?token="},
		{"Clasa 9 RO", "http://hls.stb.md/CLASA9_RO_H264/video.m3u8?token="},
		{"Clasa 9 RU", "http://hls.stb.md/CLASA9_RU_H264/video.m3u8?token="},
		{"Cotidianul TV", "http://hls.stb.md/COTIDIANUL_TV_H264/video.m3u8?token="},
		{"DIGI24", "http://hls.stb.md/DIGI_24_H264/video.m3u8?token="},
		{"PEH TV HD", "http://hls.stb.md/DTV_H264/video.m3u8?token="},
		{"Drochia TV", "http://hls.stb.md/DROCHIATV_H264/video.m3u8?token="},
		{"Elita TV", "http://hls.stb.md/ELITA_H264/video.m3u8?token="},
		{"Etno TV", "http://hls.stb.md/ETNOTV_H264/video.m3u8?token="},
		{"Familia", "http://hls.stb.md/FAMILIA_DOMASHNII_H264/video.m3u8?token="},
		{"Favorit TV", "http://hls.stb.md/FAVORITTV_H264/video.m3u8?token="},
		{"GRT Moldova", "http://hls.stb.md/GRT_H264/video.m3u8?token="},
		{"Gurinel TV HD", "http://hls.stb.md/GURINELTV_H264/video.m3u8?token="},
		{"ITV Moldova", "http://hls.stb.md/ITV_H264/video.m3u8?token="},
		{"Jurnal TV HD", "http://hls.stb.md/JURNALTV_H264/video.m3u8?token="},
		{"Kanal D", "http://hls.stb.md/KANALD_H264/video.m3u8?token="},
		{"Media TV", "http://hls.stb.md/MEDIATV_H264/video.m3u8?token="},
		{"Mega", "http://hls.stb.md/CTCMEGA_H264/video.m3u8?token="},
		{"Minimax", "http://hls.stb.md/MINIMAX_H264/video.m3u8?token="},
		{"Moldova 1 HD", "http://hls.stb.md/MOLDOVA1_H264/video.m3u8?token="},
		{"Moldova 2", "http://hls.stb.md/MOLDOVA2_H264/video.m3u8?token="},
		{"Moldova TV HD", "http://hls.stb.md/MOLDOVA_TV_HD_H264/video.m3u8?token="},
		{"N4", "http://hls.stb.md/N4_H264/video.m3u8?token="},
		{"NTS", "http://hls.stb.md/NTS_H264/video.m3u8?token="},
		{"NTV Moldova", "http://hls.stb.md/NTV_MOLDOVA_H264/video.m3u8?token="},
		{"National 24 Plus", "http://hls.stb.md/NATIONAL24_PLUS_H264/video.m3u8?token="},
		{"National TV", "http://hls.stb.md/NATIONALTV_H264/video.m3u8?token="},
		{"Noroc TV HD", "http://hls.stb.md/NOROCTV_H264/video.m3u8?token="},
		{"Orhei TV HD", "http://hls.stb.md/ORHEITV_H264/video.m3u8?token="},
		{"Orizont TV", "http://hls.stb.md/ORIZONT_TV_H264/video.m3u8?token="},
		{"Party Mix HD", "http://hls.stb.md/PARTY_MIXHD_H264/video.m3u8?token="},
		{"Popas TV", "http://hls.stb.md/POPASTV_H264/video.m3u8?token="},
		{"Prime HD", "http://hls.stb.md/PRIMEHD_H264/video.m3u8?token="},
		{"Primul in Moldova", "http://hls.stb.md/PRIMULIN_MOLDOVA_H264/video.m3u8?token="},
		{"Privesc.Eu HD", "http://hls.stb.md/PRIVESC_EU_H264/video.m3u8?token="},
		{"Pro TV Chisinau HD", "http://hls.stb.md/PROTV_CHISINAU_H264/video.m3u8?token="},
		{"Publika TV HD", "http://hls.stb.md/PUBLIKATV_H264/video.m3u8?token="},
		{"R Live TV", "http://hls.stb.md/REALITATEA_LIVE_H264/video.m3u8?token="},
		{"Realitatea Plus", "http://hls.stb.md/REALITATEA_PLUS_H264/video.m3u8?token="},
		{"REN Moldova", "http://hls.stb.md/RENTV_MOLDOVA_H264/video.m3u8?token="},
		{"RTR Moldova HD", "http://hls.stb.md/RTR_MOLDOVA_H264/video.m3u8?token="},
		{"RU.TV Moldova", "http://hls.stb.md/RUTV_MOLDOVA_H264/video.m3u8?token="},
		{"Romania TV", "http://hls.stb.md/ROMANIA_TV_H264/video.m3u8?token="},
		{"STV HD Комрат", "http://hls.stb.md/STV_HD_H264/video.m3u8?token="},
		{"Sor TV", "http://hls.stb.md/SORTV_H264/video.m3u8?token="},
		{"Speranta TV", "http://hls.stb.md/SPRETANTATV_H264/video.m3u8?token="},
		{"TV Prim (Glodeni)", "http://hls.stb.md/PRIMTV_H264/video.m3u8?token="},
		{"TV6 HD", "http://hls.stb.md/TV6_H264/video.m3u8?token="},
		{"TV8 HD Moldova", "http://hls.stb.md/TV8_H264/video.m3u8?token="},
		{"TVC 21", "http://hls.stb.md/TVC21_H264/video.m3u8?token="},
		{"TVR Moldova", "http://hls.stb.md/TVR_H264/video.m3u8?token="},
		{"Taraf TV", "http://hls.stb.md/TARAFTV_H264/video.m3u8?token="},
		{"Tezaur Folc TV", "http://hls.stb.md/TEZAUR_TV_H264/video.m3u8?token="},
		{"Travel Mix HD", "http://hls.stb.md/TRAVELMIX_HD_H264/video.m3u8?token="},
		{"Trinitas TV", "http://hls.stb.md/TRINITASTV_H264/video.m3u8?token="},
		{"U TV Romania", "http://hls.stb.md/UTV_H264/video.m3u8?token="},
		{"Vocea Basarabiei TV HD", "http://hls.stb.md/VOCEA_BASARABIEI_H264/video.m3u8?token="},
		{"Zona M", "http://hls.stb.md/ZONAM_H264/video.m3u8?token="},
		{"ТНТ Exclusiv TV", "http://hls.stb.md/TNT_EXCLUSIV_H264/video.m3u8?token="},
		{"Atomic TV", "http://hls.stb.md/ATOMIC_TV_H264/video.m3u8?token="},
		{"Europa Plus TV", "http://hls.stb.md/EUROPA_PLUS_H264/video.m3u8?token="},
		{"MTV 80's", "http://hls1.stb.md/MTV80_H264/video.m3u8?token="},
		{"MTV 90's", "http://hls2.stb.md/MTV90_H264/video.m3u8?token="},
		{"MTV Live HD", "http://hls.stb.md/MTV_RUSSIA_H264/video.m3u8?token="},
		{"Ля-минор. Мой Музыкальный", "http://hls.stb.md/LEA_MINOR_H264/video.m3u8?token="},
		{"ТНТ MUSIC", "http://hls.stb.md/TNT_MUSIC_H264/video.m3u8?token="},
		{"Шансон ТВ", "http://hls.stb.md/SHANSON_H264/video.m3u8?token="},
		{"Animal Planet HD", "http://hls.stb.md/ANIMAL_PLANETHD_H264/video.m3u8?token="},
		{"CBS Reality", "http://hls.stb.md/CBS_REALITY_H264/video.m3u8?token="},
		{"DTX HD", "http://hls.stb.md/DTX_H264/video.m3u8?token="},
		{"Discovery Channel HD", "http://hls.stb.md/DISCOVERY_CHANNEL_H264/video.m3u8?token="},
		{"Discovery Science HD", "http://hls.stb.md/DISCOVERY_SCIENCEHD_H264/video.m3u8?token="},
		{"Food Network HD", "http://hls.stb.md/FOODNETWORK_HD_H264/video.m3u8?token="},
		{"HDL HD", "http://hls.stb.md/HD_LIFE_H264/video.m3u8?token="},
		{"Investigation Discovery HD", "http://hls.stb.md/IDXTRA_HD_H264/video.m3u8?token="},
		{"Travel Channel HD", "http://hls.stb.md/TRAVELCHANNEL_HD_H264/video.m3u8?token="},
		{"TV Paprika", "http://hls.stb.md/PAPRIKATV_H264/video.m3u8?token="},
		{"Viasat Explore HD", "http://hls.stb.md/VIASATEXPLORE_HD_H264/video.m3u8?token="},
		{"Viasat History HD", "http://hls.stb.md/VIASATHISTORY_HD_H264/video.m3u8?token="},
		{"Viasat Nature HD", "http://hls.stb.md/VIASATNATURE_HD_H264/video.m3u8?token="},
		{"Viasat Nature/History HD", "http://hls.stb.md/VIASAT_NATHISTORYHD_H264/video.m3u8?token="},
		{"Авто Плюс", "http://hls.stb.md/AVTO_PLUS_H264/video.m3u8?token="},
		{"Бобёр", "http://hls.stb.md/BOBIOR_H264/video.m3u8?token="},
		{"В мире животных HD", "http://hls.stb.md/VMIRE_JIVOTNIH_H264/video.m3u8?token="},
		{"Здоровое ТВ", "http://hls.stb.md/ZDOROVOYE_TV_H264/video.m3u8?token="},
		{"Кухня ТВ HD", "http://hls.stb.md/KUHNEATV_H264/video.m3u8?token="},
		{"Наша Сибирь HD", "http://hls.stb.md/NASHASYBYRI_H264/video.m3u8?token="},
		{"Ностальгия", "http://hls.stb.md/NOSTALIGYA_H264/video.m3u8?token="},
		{"Первый Космический HD", "http://hls.stb.md/PERVYY_KOSMICHESKIYHD_H264/video.m3u8?token="},
		{"Приключения HD", "http://hls.stb.md/PRIKLIUCENIAHD_H264/video.m3u8?token="},
		{"Усадьба", "http://hls.stb.md/USADBA_H264/video.m3u8?token="},
		{"Exploris HD", "http://hls.stb.md/EXPLORIS_HD_H264/video.m3u8?token="},
		{"Fashion TV HD", "http://hls.stb.md/FASHIONTV_HD_H264/video.m3u8?token="},
		{"GN TV HD", "http://hls.stb.md/GN_TV_HD_H264/video.m3u8?token="},
		{"Legal TV HD", "http://hls.stb.md/LEGAL_TV_HD_H264/video.m3u8?token="},
		{"TLC", "http://hls.stb.md/DISCOVERY_TLC_H264/video.m3u8?token="},
		{"Дикая Охота HD", "http://hls.stb.md/DIKAYAOHOTA_H264/video.m3u8?token="},
		{"Дикая Рыбалка HD", "http://hls.stb.md/DIKAYARIBALKA_H264/video.m3u8?token="},
		{"Дикий", "http://hls.stb.md/DIKYI_H264/video.m3u8?token="},
		{"Живи!", "http://hls.stb.md/JIVI_H264/video.m3u8?token="},
		{"КВН ТВ", "http://hls.stb.md/KVN_TV_H264/video.m3u8?token="},
		{"Охота и рыбалка", "http://hls.stb.md/OKHOTAIRYBALKA_H264/video.m3u8?token="},
		{"Охотник и рыболов HD", "http://hls.stb.md/OHOTNIK_IRIBALOV_H264/video.m3u8?token="},
		{"Сарафан", "http://hls.stb.md/SARAFAN_H264/video.m3u8?token="},
		{"Союз", "http://hls.stb.md/SOIUZ_H264/video.m3u8?token="},
		{"Eurosport 1 HD", "http://hls.stb.md/ESPHD_H264/video.m3u8?token="},
		{"Eurosport 2 HD", "http://hls.stb.md/EUROSPORT2HD_H264/video.m3u8?token="},
		{"M-1 Global", "http://hls.stb.md/M_1GLOBAL_H264/video.m3u8?token="},
		{"Q Sport HD", "http://hls.stb.md/QSPORT_H264/video.m3u8?token="},
		{"Setanta Sports 1 HD", "http://hls.stb.md/SETANTA_HD_H264/video.m3u8?token="},
		{"Setanta Sports 2 HD", "http://hls.stb.md/SETANTAPLUS_HD_H264/video.m3u8?token="},
		{"Setanta Sports HD", "http://hls.stb.md/SETANTASPORTS_HD_H264/video.m3u8?token="},
		{"Viasat Sport HD", "http://hls.stb.md/VIASAT_SPORTHD_H264/video.m3u8?token="},
		{"Драйв", "http://hls.stb.md/DRAIV_H264/video.m3u8?token="},
		{"Матч! Планета", "http://hls.stb.md/MATCH_PLANETA_H264/video.m3u8?token="},
		{"BOLT", "http://hls.stb.md/BOLT_H264/video.m3u8?token="},
		{"Iнтер+", "http://hls.stb.md/INTERPLUS_H264/video.m3u8?token="},
		{"UATV", "http://hls.stb.md/UATV_HD_H264/video.m3u8?token="},
		{"Квартал ТВ", "http://hls.stb.md/KVARTALTV_H264/video.m3u8?token="},
		{"5 International", "http://hls.stb.md/CANAL_5_RU_H264/video.m3u8?token="},
		{"Перец International", "http://hls.stb.md/PERETS_RU_H264/video.m3u8?token="},
		{"ТНТ4 Int.", "http://hls.stb.md/TNT_4_RU_H264/video.m3u8?token="},
		{"WE SPORT TV", "http://hls.stb.md/WE_SPORT_H264/video.m3u8?token="},
		{"4 TV International", "http://hls.stb.md/4_TV_H264/video.m3u8?token="},
		{"Black", "http://hls.stb.md/BLACK_H264/video.m3u8?token="},
		{"Exclusiv TV HD", "http://hls.stb.md/TNT_EXCLUSIV_H264/video.m3u8?token="},
		{"TV8 HD", "http://hls.stb.md/TV8_H264/video.m3u8?token="},
		{"PRO TV Chișinău HD", "http://hls.stb.md/PROTV_CHISINAU_H264/video.m3u8?token="},
		{"Moldova 2 HD", "http://hls.stb.md/MOLDOVA2_H264/video.m3u8?token="},
		{"Vocea Basarabiei HD", "http://hls.stb.md/VOCEA_BASARABIEI_H264/video.m3u8?token="},
		{"R LIVE TV HD", "http://hls.stb.md/REALITATEA_LIVE_H264/video.m3u8?token="},
		{"TV5 Monde Europe HD", "http://hls.stb.md/TV5_MONDEEUROPE_H264/video.m3u8?token="},
		{"N4 HD", "http://hls.stb.md/N4_H264/video.m3u8?token="},
		{"Drochia TV HD", "http://hls.stb.md/DROCHIATV_H264/video.m3u8?token="},
		{"GRT HD", "http://hls.stb.md/GRT_H264/video.m3u8?token="},
		{"SOR TV HD", "http://hls.stb.md/SORTV_H264/video.m3u8?token="},
		{"NTS HD", "http://hls.stb.md/NTS_H264/video.m3u8?token="},
		{"START AIR HD", "http://hls.stb.md/START_AIR_HD_H264/video.m3u8?token="},
		{"START WORLD HD", "http://hls.stb.md/START_WORLD_HD_H264/video.m3u8?token="},
		{"FilmUA Drama", "http://hls.stb.md/FILMUA_DRAMA_H264/video.m3u8?token="},
		{"COMEDY CENTRAL", "http://hls2.stb.md/PARAMOUNT_COMEDY_H264/video.m3u8?token="},
		{"Мосфильм", "http://hls.stb.md/MOSFILM_H264/video.m3u8?token="},
		{"Киносемья HD", "http://hls.stb.md/KINOSEMYA_H264/video.m3u8?token="},
		{"Мужское кино HD", "http://hls.stb.md/MUJSKOE_KINO_H264/video.m3u8?token="},
		{"Киноман", "http://hls.stb.md/KINOMAN_H264/video.m3u8?token="},
		{"Наше новое кино HD", "http://hls.stb.md/NASHENOVOIE_KINO_H264/video.m3u8?token="},
		{"Red", "http://hls.stb.md/RED_H264/video.m3u8?token="},
		{"sci-fi", "http://hls.stb.md/SCI_FI_H264/video.m3u8?token="},
		{"viju Explore HD", "http://hls.stb.md/VIASATEXPLORE_HD_H264/video.m3u8?token="},
		{"viju History HD", "http://hls.stb.md/VIASATHISTORY_HD_H264/video.m3u8?token="},
		{"viju Nature HD", "http://hls.stb.md/VIASATNATURE_HD_H264/video.m3u8?token="},
		{"viju+ Planet HD", "http://hls.stb.md/VIASAT_NATHISTORYHD_H264/video.m3u8?token="},
		{"Наша Cибирь HD", "http://hls.stb.md/NASHASYBYRI_H264/video.m3u8?token="},
		{"Da Vinci", "http://hls.stb.md/DAVINCI_LEARNING_H264/video.m3u8?token="},
		{"СТС Kids HD", "http://hls.stb.md/CTC_KIDS_H264/video.m3u8?token="},
		{"TraLaLa HD", "http://hls.stb.md/TRALALA_HD_H264/video.m3u8?token="},
		{"FREEДОМ HD", "http://hls.stb.md/UATV_HD_H264/video.m3u8?token="},
		{"Tezaur TV HD", "http://hls.stb.md/TEZAUR_TV_H264/video.m3u8?token="},
		{"THT Music", "http://hls.stb.md/TNT_MUSIC_H264/video.m3u8?token="},
		{"România TV", "http://hls.stb.md/ROMANIA_TV_H264/video.m3u8?token="},
		{"Euronews RU", "http://hls.stb.md/EURONEWS_H264/video.m3u8?token="},
		{"Paprika TV", "http://hls.stb.md/PAPRIKATV_H264/video.m3u8?token="},
		{"Живи", "http://hls.stb.md/JIVI_H264/video.m3u8?token="},
		{"Авто Плюс HD", "http://hls.stb.md/AVTO_PLUS_H264/video.m3u8?token="},
		{"Интер+ HD", "http://hls.stb.md/INTERPLUS_H264/video.m3u8?token="},
		{"Kvartal TV", "http://hls.stb.md/KVARTALTV_H264/video.m3u8?token="},
		{"France 24 FR HD", "http://hls.stb.md/FRANCE_24FR_H264/video.m3u8?token="},
		{"France 24 EN HD", "http://hls.stb.md/FRANCE_24ENG_H264/video.m3u8?token="},
		{"Realitatea Plus HD", "http://hls.stb.md/REALITATEA_PLUS_H264/video.m3u8?token="},
		{"Digi 24", "http://hls.stb.md/DIGI_24_H264/video.m3u8?token="},
		{"B1 TV HD", "http://hls.stb.md/B1_TV_H264/video.m3u8?token="},
		{"Național TV", "http://hls.stb.md/NATIONALTV_H264/video.m3u8?token="},
		{"Настоящее Время HD", "http://hls.stb.md/NASTOIASHIE_VREMEA_H264/video.m3u8?token="},
		{"TeleMoldova Plus HD", "http://hls.stb.md/NATIONAL24_PLUS_H264/video.m3u8?token="},
		{"CNL", "http://hls.stb.md/CNL_H264/video.m3u8?token="},
		{"Trinitas TV HD", "http://hls.stb.md/TRINITASTV_H264/video.m3u8?token="},
		{"Speranța TV", "http://hls.stb.md/SPRETANTATV_H264/video.m3u8?token="},
		{"viju+ Sport", "http://hls.stb.md/VIASAT_SPORTHD_H264/video.m3u8?token="},
		{"UTV HD", "http://hls.stb.md/UTV_H264/video.m3u8?token="},
		{"MMA-TV", "http://hls.stb.md/M_1GLOBAL_H264/video.m3u8?token="},
		{"7TV HD", "http://hls.stb.md/DTV_H264/video.m3u8?token="},
		{"GLOBAL 24 HD", "http://hls.stb.md/RENTV_MOLDOVA_H264/video.m3u8?token="},
		{"Индия", "http://hls.stb.md/ZEETV_H264/video.m3u8?token="},
		{"Star TV HD", "http://hls.stb.md/STAR_TV_HD_H264/video.m3u8?token="},
		{"Next TV", "http://hls.stb.md/NEXT_TV_H264/video.m3u8?token="},
		{"TV9", "http://hls.stb.md/TV9_HD_H264/video.m3u8?token="},
		{"СТСi", "http://hls.stb.md/CTC_RU_H264/video.m3u8?token="},
		{"TV3 International", "http://hls.stb.md/TV_3_RU_H264/video.m3u8?token="},
		{"ТНТi", "http://hls.stb.md/TNT_RU_H264/video.m3u8?token="},
		{"Пятница", "http://hls.stb.md/PYATNITSA_RU_H264/video.m3u8?token="},
		{"Домашний International", "http://hls.stb.md/DOMASHNYI_RU_H264/video.m3u8?token="},
		{"Redlight HD", "http://hls.stb.md/REDLIGHT_HD_H264/video.m3u8?token="},
		{"Simfonica", "http://hls.stb.md/SIMFONICA_H264/video.m3u8?token="},
		{"One TV HD", "http://hls.stb.md/ONE_TV_HD_H264/video.m3u8?token="},
		{"Studio-L HD", "http://hls.stb.md/STUDIO_L_H264/video.m3u8?token="},
		{"Rapsodia TV", "http://hls.stb.md/RAPSODIA_TV_H264/video.m3u8?token="},
		{"Autentic TV", "http://hls.stb.md/AUTENTIC_TV_H264/video.m3u8?token="},
		{"Columna TV", "http://hls.stb.md/COLUMNA_H264/video.m3u8?token="},
		{"Canal 33", "http://hls.stb.md/CANAL_33_H264/video.m3u8?token="},
		{"Prima News", "http://hls.stb.md/PRIMA_NEWS_H264/video.m3u8?token="},
		{"Atomic Academy", "http://hls.stb.md/ATOMIC_ACADEMY_H264/video.m3u8?token="},
		{"EMI TV", "http://hls.stb.md/EMI_TV_H264/video.m3u8?token="},
		{"TV-AS", "http://hls.stb.md/TV_AS_H264/video.m3u8?token="},
		{"Tele 8TV", "http://hls.stb.md/TELE_8TV_H264/video.m3u8?token="},
		{"Cinemaraton Moldova", "http://hls.stb.md/CINEMARATON_MD_H264/video.m3u8?token="},
		{"Premiera TV", "http://hls.stb.md/PREMIERA_TV_H264/video.m3u8?token="},
		{"Prima TV Moldova", "http://hls.stb.md/PRIMA_TV_MD_H264/video.m3u8?token="},
		{"Viasat Explore", "http://hls.stb.md/VIASATEXPLORE_HD_H264/video.m3u8?token="},
		{"Alba Carolina TV", "http://hls.stb.md/ALBA_CAROLINA_TV_H264/video.m3u8?token="},
		{"Prima World", "http://hls.stb.md/PRIMA_WORLD_H264/video.m3u8?token="},
		{"Iași TV Life", "http://hls.stb.md/IASI_TV_LIFE_H264/video.m3u8?token="},
		{"Hustler TV", "http://hls.stb.md/HUSTLER_TV_H264/video.m3u8?token="},
		{"Hustler HD", "http://hls.stb.md/HUSTLERTV_HD_H264/video.m3u8?token="},
		{"Private TV HD", "http://hls.stb.md/PRIVATETV_HD_H264/video.m3u8?token="},
		{"Barely Legal", "http://hls.stb.md/BARELY_LEGAL_H264/video.m3u8?token="},
		{"Realitatea Sportivă HD", "http://hls.stb.md/REALITATEA_SPORTIVA_HD_H264/video.m3u8?token="},
		{"Shop On TV", "http://hls.stb.md/SHOP_ON_TV_H264/video.m3u8?token="},
		{"Zoom TV", "http://hls.stb.md/ZOOM_TV_H264/video.m3u8?token="},
		{"Valea Prahovei TV", "http://hls.stb.md/VALEA_PRAHOVEI_TV_H264/video.m3u8?token="},
		{"SUPER TV", "http://hls.stb.md/SUPERTV_HD_H264/video.m3u8?token="},
		{"1+1 HD", "http://hls.stb.md/1+1_H264/video.m3u8?token="},
		{"CARTOONITO", "http://hls.stb.md/BOOMERANGTV_H264/video.m3u8?token="},
		}
		for i = 1,#tt do
			if name == tt[i][1] then
				return tt[i][2]
			end
		end
		return ""
	end
	local function findtok()
	local url= decode64('aHR0cHM6Ly90b2tlbi5zdGIubWQvYXBpL0ZsdXNzb25pYy9zdHJlYW0vTklDS0VMT0RFT05fSDI2NC9tZXRhZGF0YS5qc29u')
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc~=200 then
		return ''
		end
		require('json')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
		if tab and tab.variants and tab.variants[1] and tab.variants[1].url then
		return tab.variants[1].url:gsub('^.-token=','')
		else
		return ''
		end
	end

	local function LoadFromFile(pls, pls_name)
		local answer
	local url = 'https://swapi.starnet.md/api/v1/pages/home-grid?format=json'
	local session = m_simpleTV.Http.New()
	if not session then return end
	m_simpleTV.Http.SetTimeout(session, 8000)
	local rc,answer = m_simpleTV.Http.Request(session,{url=url})
		if rc~=200 then
		return ''
		end
--	debug_in_file(answer .. '\n')
		require('json')
		answer = answer:gsub('(%[%])', '"nil"')
		local tab = json.decode(answer)
		local t, i = {}, 1
			while true do
				if not tab.channels[i] then break end
				t[i] = {}
				t[i].name = tab.channels[i].title
				t[i].address = Get_adr_for_name(t[i].name)
				local j = 1
				while true do
				if not tab.categories[j] then break end
					if tab.channels[i].category:gsub('%-','') == tab.categories[j].id:gsub('%-','')
						then t[i].group =  tab.categories[j].title
					end
					j = j + 1
				end
				if t[i].address == '' then
					t[i].group = 'NOT ADDRESS'
				end
				if tab.channels[i].tags and tab.channels[i].tags[1]:match('feature') then
					t[i].RawM3UString = 'catchup="append" catchup-days="7" catchup-type="flussonic"'
				end
				t[i].logo = tab.channels[i].logo
				if pls:match('18') and (t[i].group == 'Эротика' or t[i].group == 'Adult' or t[i].group == 'Для взрослых' or t[i].group == 'Взрослые') then
					t[i] = nil
				end
				i = i + 1
			end
			if i == 1 then return end
	 return t
	end
	function GetList(UpdateID, m3u_file)
			if not UpdateID then return end
			if not m3u_file then return end
			if not TVSources_var.tmp.source[UpdateID] then return end
		local Source = TVSources_var.tmp.source[UpdateID]
		local pll={

		{"full","полная версия"},
		{"minus 18","без 18+"},
}

  local t={}
  for i=1,#pll do
    t[i] = {}
    t[i].Id = i
    t[i].Name = pll[i][2]
    t[i].Action = pll[i][1]
  end

  local playlist, pls_name
  local ret,id = m_simpleTV.OSD.ShowSelect_UTF8('IPTVin.Ru StarNet - select playlist',0,t,9000,1+4+8)
  if id==nil then return end
  if ret == 1 then
   playlist = t[id].Action
   pls_name = t[id].Name
  end
		local t_pls = LoadFromFile(playlist, pls_name)
			if not t_pls then
				m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' ошибка загрузки плейлиста'
											, color = ARGB(255, 255, 100, 0)
											, showTime = 1000 * 5
											, id = 'channelName'})
			 return
			end
			if t_pls == 0 then
				m_simpleTV.OSD.ShowMessageT({text = 'логин/пароль установить\nв дополнении "Password Manager"\для id - denms'
											, color = ARGB(255, 255, 100, 0)
											, showTime = 1000 * 5
											, id = 'channelName'})
			 return
			end
		m_simpleTV.OSD.ShowMessageT({text = Source.name .. ' / ' .. pls_name .. ' (' .. #t_pls .. ')'
									, color = ARGB(255, 155, 255, 155)
									, showTime = 1000 * 5
									, id = 'channelName'})
--		t_pls = ProcessFilterTableLocal(t_pls)
		local m3ustr = tvs_core.ProcessFilterTable(UpdateID, Source, t_pls)
		local handle = io.open(m3u_file, 'w+')
			if not handle then return end
		handle:write(m3ustr)
		handle:close()
	 return 'ok'
	end
-- debug_in_file(#t_pls .. '\n')