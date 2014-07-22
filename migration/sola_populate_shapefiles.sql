﻿--INTO SOLA KANO DATABASE
--interim measure to add names to imported Ward Shapefiles
ALTER TABLE interim_data.wards DROP COLUMN IF EXISTS name;
ALTER TABLE interim_data.wards ADD COLUMN name text;
ALTER TABLE interim_data.wards_corrected DROP COLUMN IF EXISTS name;
ALTER TABLE interim_data.wards_corrected ADD COLUMN name text;
UPDATE interim_data.wards SET name = 'Ungogo ' || TRIM(TO_CHAR(gid, '99'));
UPDATE interim_data.wards_corrected SET name = 'Fagge ' || TRIM(TO_CHAR(gid, '99'));

----------- SPATIAL_UNIT TABLE POPULATION ----------------------------------------

DELETE FROM cadastre.spatial_unit WHERE level_id IN (SELECT id from cadastre.level WHERE name = 'LGA');
DELETE FROM cadastre.spatial_unit WHERE level_id IN (SELECT id from cadastre.level WHERE name = 'Ward');

----------- SPATIAL_UNIT_GROUP TABLE POPULATION ----------------------------------------

-- insert State - LGA - Ward hierarchy

DELETE FROM cadastre.spatial_unit_group;
DELETE FROM cadastre.spatial_unit_group_historic;

--------------- Country  is not needed
--INSERT INTO cadastre.spatial_unit_group( name,id, hierarchy_level, label,  change_user) SELECT distinct(adm0),(adm0), 0, (adm0), 'test'
--	FROM interim_data.lga WHERE (ST_GeometryN(the_geom, 1) IS NOT NULL);

--------------- STATE
INSERT INTO cadastre.spatial_unit_group( name,id, hierarchy_level, label, geom, change_user) SELECT distinct(adm1),adm1, 1, 
(adm1), '0103000020787F0000010000004D00000099A643E768921541FB02C26FA3583341D817107EFBA016415808EC3843A93441F05419F195961941F2E9FDC4813835415E052AC9471C1A41ADF45157292E3541682C310194551A4128614E3B83113541F96DDD9B4F621A41B63AA1199EFD3441020E438DD2E41A41065754BF42413541080B811D67D51C417515A8248734354177C9D482ABC81C41D7BDF94E15173541E68728E8EFBB1C411A4B4C00CD00354197C58B71592B1D41D455A09274F63441CE1D945D326E1D41688647309ADA3441543839C0A1411D41BF80F0DB12CD3441FBD53658882E1D412E3F444157C03441543839C0A1411D417FE2982DC5BA34418982FE1EE8161E41E3F24314F4BD3441922264106B991E41F28FE7957385344194A9055734501E41BD9F38663B633441CA010E430D931E410E438D52A95D3441BD45223765351F41A4DB8DAC6F623441DEC87A6CDC4E1F41149AE111B4553441DEC87A6CDC4E1F41CEA435A45B4B3441F49D2A233E781F41EDBF341D32443441B110D871868E1F41A27334F0CE413441D29330A7FDA71F4140CBE2C5405F3441351D3A4763F41F418B17E3F2A36134418A09A06511122041E2118C9E1C54344120A2A0BFD71620417542333C423834417E5BF7E6FB21204149113288B52E34417E5BF7E6FB212041A3FAD53698F83341E868E05D5FD11F4155467C4D94D533418458357730CE1F41FCE379E57AC233412B50493EED06204198D3CEFE4BBF3341E26BA2CD2A252041DEC87A6CA4C9334168FFA5E9D041204198D3CEFE4BBF334173AD4E68E63120415E8CCB0F09A53341409E57AE8579204175E81C0D34853341C0DA060B219E2041DF4F1CB36D8033412A4206B15A992041BECCC37DF6663341B05CAB13CA6C2041015A162FAE5033412AC9A7F7235020414CA6165C11533341D266A58F0A3D20413E9014215B4233416D56FAA8DB392041AE4E68869F3533414125F9F44E302041F6320FF76117334120A2A0BFD7162041DD6E643D96163341F31689DC74C11F41B694B74814053341FF4BD3A153681F41B694B748140533417E5BF7E69BDD1D412C3101B42CA73241FA4E9511BF771D41C82056CDFDA33241B848E4A6D0441D412C3101B42CA732418C9E84390DF21C417AE55A9D30CA32416CA2CD4A5F8F1C41CDF008463FE5324156467C4D34AF1C4134690DE90E0933416C1B2C0496D81C4166F1625CA60A334112328855B30E1D418774BB911D243341C47D2E6CAFEB1C41BB646AC155463341164E0E70D8E91B41ABE60ECAFE1433410EBCEB0BE8D41A41F0DBBA37571F334168A58FBACA9E1A41CC6967FF752E33417F8882FEBE351A41ABE60ECAFE143341A1927C7AFF051A4147D663E3CF113341ADC7C63FDEAC194120FCB6EE4D00334129BB646A014719417FB50D16720B334109BFAD7B53E418410FF7B9B02D183341C6B8FC1065B11841E52D12B9412F33416DCF586282E71841EDECBF34ED473341BB0A54924FC1184114C76C296F593341B1E34C5A038818417E2E6CCFA8543341388593033C1218418485C08EB34C33418747307AD2A21741F34314F4F73F33415C9DD00C0F501741FEF1BC720D30334152FD6A1B8CCD1641922264103314334128DAACF491311641417F0F24C5193341DA25530B8E0E16416EB010D851233341AEF45157010516414F95115F7B2A3341C450A3542CE51541AE4E68869F35334199A643E768921541FB02C26FA3583341', 'test'
	FROM interim_data.lga WHERE (ST_GeometryN(the_geom, 1) IS NOT NULL);
--- OLD STATE WITHOUT GEOMETRY -------------------	
--INSERT INTO cadastre.spatial_unit_group( name,id, hierarchy_level, label,  change_user) SELECT distinct(adm1),adm1, 1, 
--(adm1), 'test'
--	FROM interim_data.lga WHERE (ST_GeometryN(the_geom, 1) IS NOT NULL);

--------------- LGA
INSERT INTO cadastre.spatial_unit_group( id, hierarchy_level, label, name, geom, change_user) 
	SELECT adm1||'/'||adm2, 2, adm2, adm1||'/'||adm2
	, ST_GeometryN(the_geom, 1), 'test'
	FROM interim_data.lga WHERE (ST_GeometryN(the_geom, 1) IS NOT NULL);

--------------- Wards
--- NOT USABLE SO FAR BECAUSE FROM THE SHAPEFILES INTO THE WARDS TABLE ARRIVED ONLY UNGOGO 1 WHICH IS TOO SMALL AND ABSOLUTELY RUBBISH
--INSERT INTO cadastre.spatial_unit_group( id, hierarchy_level, label, name, geom, change_user, seq_nr)
--SELECT lga_group.name || '/' || w.name, 3, w.name, 
--lga_group.name || '/' ||w.name,
--ST_GeometryN(w.the_geom, 1), 'test', 0
--FROM cadastre.spatial_unit_group AS lga_group,  interim_data.wards AS w 
--WHERE lga_group.hierarchy_level = 2 
--AND st_intersects(lga_group.geom, st_pointonsurface(w.the_geom));

INSERT INTO cadastre.spatial_unit_group( id, hierarchy_level, label, name, geom, change_user, seq_nr)
SELECT lga_group.name || '/' || w.name, 3, w.name, 
replace(replace(lga_group.name,'Kano/Nassaraw','KN/FGE'),'Kano/Ungogo','KN/UNG' )|| '/' ||replace(replace(w.name,'Fagge ',''),'Ungogo ', ''),
ST_GeometryN(w.the_geom, 1), 'test', 0
FROM cadastre.spatial_unit_group AS lga_group,  interim_data.wards_corrected AS w 
WHERE lga_group.hierarchy_level = 2 
AND st_intersects(lga_group.geom, st_pointonsurface(w.the_geom));

DELETE FROM cadastre.spatial_unit_group WHERE id = 'Kano/Nassaraw/Fagge 1';
DELETE FROM cadastre.spatial_unit_group WHERE id = 'Kano/Nassaraw/Ungogo 1';

UPDATE cadastre.spatial_unit_group 
SET GEOM = '0103000020787F0000010000003100000000203666F0981A41002065641E3E34410080B7DFF9981A41006090407042344100C0FBB405AA1A4100805BCCBF46344100C0E1641ABB1A4100206A22614F34410020DDDC26DD1A4100605C8DAE533441002065A23BFF1A4100E009DF4D5C34410080381F45101B4100A0B6A39D60344100A0CDF356211B410080614C3F6934410000B50D60321B4100C0F1088F6D3441008074E460431B41004004108D6D34410000ADB961541B4100A04A218B6D3441000009835B761B4100C0B7A4356934410080BD3555871B4100E0BFFCE164344100E05C3B4F981B4100A0E15F8E60344100C08C2949A91B4100E021CE3A5C34410000DC9B4ABA1B410020F61D395C34410060947C4DDC1B41004021DC355C34410020C5804EED1B4100A0814A345C34410020195A510F1C4100C0B045315C3441000004C552201C41008089D22F5C3441004087C453311C41004096692E5C34410060CB1E4E311C4100A026B0DC5734410020425B41201C410040FF6F3A4F34410020C17F390F1C4100A0E20DEA4A344100201A5231FE1B4100E085D09946344100E09D162FED1B4100607D569B463441006037442DDC1B4100608CE69C4634410040FDD91DCB1B4100C082D6FA3D34410020DC8B16981B4100E0E7DFFF3D3441058B7318C77B1B41FC7821037042344100009F031C541B410040E9D3AA46344100C0F56F17321B41008093B4AE4634410040A0571D211B4100E02F72024B344100800E331B101B410020417C044B344100E0297719FF1A4100E06890064B34410080F59F0EEE1A4100206CEFB6463441004095E9FFFE1A4100404B1E113E344100C0309CF4ED1A410000A361C13934410040EAF3EBED1A4100C01B886F35344100008D2DE0DC1A4100C0AAEF1F3134410000F15FD7DC1A4100E01A16CE2C344100001E15D4CB1A410040A545D02C344100003A15C8BA1A4100C0F6A48028344100E081F9BEBA1A410060E9CA2E24344100A04959BBA91A4100A0B40D3124344100E0DE32D1BA1A410000377FD22C344100C07052DABA1A410060AA59243134410040D2C3E9A91A4100203E39CA39344100203666F0981A41002065641E3E3441'
WHERE ID = 'Kano/Ungogo';

UPDATE cadastre.spatial_unit_group 
SET GEOM = '0103000020787F0000010000001B0000000080F59F0EEE1A4100206CEFB646344100E0297719FF1A4100E06890064B344100800E331B101B410020417C044B34410040A0571D211B4100E02F72024B344100C0F56F17321B41008093B4AE46344100009F031C541B410040E9D3AA463441DE578F1AC77B1B4173E9EC02704234410020DC8B16981B4100E0E7DFFF3D34410040FDD91DCB1B4100C082D6FA3D344100A0ED4517CB1B410040AE01A939344100E01E220ACB1B4100609E730531344100A0369203CB1B4100E0639FB32C344100E0B003FDCA1B4100805CCB61283441004019EFF2B91B41004041991124344100805466EFA81B4100400B451324344100806A4EF3971B4100A0B2CF662834410080D6EBEF861B410000F98F682834410080DA87EC751B410080525A6A2834410060FFD2ED531B410080B3E3BF2C344100008D93EA421B4100E0A8CCC12C344100A0476BF2421B4100E0BEA31331344100E07844FA421B4100A008606535344100C0821F02431B4100008537B739344100E09159FF311B410040BD2BB939344100201192FC201B4100E0102ABB393441004095E9FFFE1A4100404B1E113E34410080F59F0EEE1A4100206CEFB6463441'
WHERE ID = 'Kano/Nassaraw';


--Updating SpatialUnitGroup
UPDATE cadastre.spatial_unit_group 
SET label = 'Fagge D1',
name = 'KN/FGE/D1',
id = 'Kano/Nassaraw/Fagge D1'
WHERE ID = 'Kano/Nassaraw/Fagge 4';

UPDATE cadastre.spatial_unit_group 
SET label = 'Fagge D2',
name = 'KN/FGE/D2',
id = 'Kano/Nassaraw/Fagge D2'
WHERE ID = 'Kano/Nassaraw/Fagge 2';

UPDATE cadastre.spatial_unit_group 
SET label = 'Fagge C',
name = 'KN/FGE/C',
id = 'Kano/Nassaraw/Fagge C'
WHERE ID = 'Kano/Nassaraw/Fagge 5';

UPDATE cadastre.spatial_unit_group 
SET label = 'Fagge B',
name = 'KN/FGE/B',
id = 'Kano/Nassaraw/Fagge B'
WHERE ID = 'Kano/Nassaraw/Fagge 6';

UPDATE cadastre.spatial_unit_group 
SET label = 'Fagge A',
name = 'KN/FGE/A',
id = 'Kano/Nassaraw/Fagge A'
WHERE ID = 'Kano/Nassaraw/Fagge 3';

----------- SPATIAL_UNIT_GROUP_IN TABLE POPULATION ----------------------------------------

DELETE FROM cadastre.spatial_unit_in_group;

---the insert values for section polygons and section spatial unit group goes here while we wait for these shape file from malandi
