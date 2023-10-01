-- script for creating an EPG plate 01.10.2023
-- author west_side GITHUB https://github.com/west-side-simple
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if m_simpleTV.Database.ExecuteSql('INSERT INTO ChannelsEpg ([Id],[ChName],[Source],[Logo]) VALUES ("WS_PortalTV","WS_PortalTV","WS PortalTV","");') then
m_simpleTV.EPG.Refresh()
end
m_simpleTV.Database.ExecuteSql('DELETE FROM ChProg WHERE (IdChannel="WS_PortalTV");', true)
local start_EPG = os.time() - (os.date("%H",os.time())*60*60 + os.date("%M",os.time())*60 + os.date("%S",os.time())) - os.date("%w",os.time())*24*60*60 - 6*24*60*60
local EPG = {
{0,6,"ночное вещание"},
{6,12,"утреннее вещание"},
{12,18,"дневное вещание"},
{18,24,"вечернее вещание"},
}
m_simpleTV.Database.ExecuteSql('START TRANSACTION;/*ChProg*/')
for i = 1,14 do
	local start_time = tonumber(start_EPG) + (i - 1)*24*60*60
	for j = 1,4 do
		local StartPr = tonumber(start_time) + tonumber(EPG[j][1])*60*60
		local EndPr = tonumber(start_time) + tonumber(EPG[j][2])*60*60
		StartPr = os.date('%Y-%m-%d %X', StartPr)
		EndPr = os.date('%Y-%m-%d %X', EndPr)
		local Title = EPG[j][3]
		m_simpleTV.Database.ExecuteSql('INSERT  INTO ChProg (IdChannel, StartPr, EndPr, Title, Desc, HaveDesc, Category, IconUrl) VALUES ("WS_PortalTV","' .. StartPr .. '","' .. EndPr .. '","' .. Title .. '","","0","NOT EPG","");', true)
		j = j + 1
	end
	i = i + 1
end
m_simpleTV.Database.ExecuteSql('COMMIT;/*ChProg*/')
m_simpleTV.EPG.Refresh()
m_simpleTV.Database.ExecuteSql([[UPDATE Channels SET EpgId="WS_PortalTV" WHERE ((Channels.Id<268435455)
                             AND (Channels.TypeMedia=0)
                             AND (Channels.EpgId = "" OR Channels.EpgId IS NULL)
                             AND (Channels.Title IS NULL OR trim(Channels.Title) = ""));]])

m_simpleTV.PlayList.Refresh()