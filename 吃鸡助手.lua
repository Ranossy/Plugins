local szPluginName = "�Լ�����1.2"

--�����¼��
local Party = {}
--δ�ֶ�player��¼��
local NoParty = {}
--αװ��¼��
local WeiZhuang = {}

--��ɫ��
local tColor = {
["��"] = { 169, 169, 169,  1.0 },			--�죬�̣���������
["��"] = { 250, 250, 250,  1.0 },
["��"] = {   0, 210,  75,  1.0 },
["��"] = {   0, 126, 255,  1.2 },
["��"] = { 255,  45, 255,  1.4 },
["��"] = { 255, 165,   0,  1.6 },
["��"] = { 255, 255,   0,  1.2 },
["��"] = {  94,  38,  18,  1.1 }
}

--��Ҫ��ʾ��Doodad��
local tTempID = {
[6817] = "��",		--һ������

[6818] = "��",		--����װ��
[6952] = "��",		--������װ������
[6819] = "��",		--��������
[6951] = "��",		--��������������

[6820] = "��",		--����װ��
[6954] = "��",		--������װ������
[6821] = "��",		--��������
[6953] = "��",		--��������������

[6955] = "��",		--��������������
[6884] = "��",		--���װ��
[6956] = "��",		--������װ������
[6883] = "��",		--�������

[6824] = "��",		--��ҩ
[6875] = "��",		--����ɢ
[6937] = "��",		--�����Ľ�ҩ
[6943] = "��",		--����������ɢ

[6973] = "��",		--��ө�귵��
[6994] = "��",		--����
[6863] = "��",		--���ٱ���
[6872] = "��",      --�绯��ʯ��
[6873] = "��",      --�����

[6858] = "��",		--��ľ
[6857] = "��",		--ɰʯ
[6859] = "��",		--�߹�
[6833] = "��",		--̾Ϣ�籮

[6822] = "��"		--����
}

--�ж��Ƿ�ʩ��ĳ������
--����(ʩ����id��ʩ�ż���ID����ȷ�ϵļ���ID�����룬�Ƿ����ж����Լ��ͷ�)
local function UpdateSkill (ID,dwSkillID,SkillID,Dis,bol)
	local wanjia = GetPlayer(ID)
	local target, targetClass = s_util.GetTarget(wanjia)
	local player = GetClientPlayer()
	local distance = s_util.GetDistance(player,wanjia)
	if not bol then
		if SkillID == dwSkillID and distance<=Dis and target.dwID==player.dwID then
			return true
		else
			return false
		end
	else
		if SkillID == dwSkillID and distance<=Dis then
			return true
		else
			return false
		end
	end
end
------------------------------------------------��������ò����Ϣ�ͻص�����------------------------------------------------
local tPlugin = {
--����ڲ˵�����ʾ�����֡���������
["szName"] = szPluginName,

--������͡�  1(5�˸���)�� 2(10�˸���)�� 3(25�˸���)��4(������)��5(����)����������
["nType"] = 5,

--�󶨵�ͼ��������ͼ����Ϊ��ͼID�������ͼ������Ϊ�����Բ����ã�����Ϸ���ֶ�����
["dwMapID"] = {296, 297},

--��ʼ�����������ò�������
["OnInit"] = function()
	local player = GetClientPlayer()
	if not player then return false end
	s_util.OutputSysMsg("��� "..szPluginName.." ������")
	s_util.OutputSysMsg("��ӭ "..player.szName.." ʹ�ñ����")
	s_util.OutputSysMsg("������ߣ�xxxx")
	return true
end,

["OnTick"] = function()
	Minimap.bSearchRedName = true			--��С��ͼ����
	local player = GetClientPlayer()
end,

--Doodad���볡����1��������DoodadID
["OnDoodadEnter"] = function(dwID)
	local doodad = GetDoodad(dwID)
	local me = GetClientPlayer()
	if doodad then 
		if tTempID[doodad.dwTemplateID] then
			local t = tColor[tTempID[doodad.dwTemplateID]]
			if t then
				local r, g, b, s = unpack(t)
				--����Ϸ�����������ı�
				s_util.AddText(TARGET.DOODAD, doodad.dwID, r, g, b, 255, doodad.szName, s, true)		--�������ͣ�����ID, �죬�̣�����͸���ȣ��ı������ִ�С���ţ��Ƿ���ʾ����
			end
		end
	end
	--����αװ��ǻ�Ȧ
	if (doodad and (doodad.dwTemplateID == 6858 or doodad.dwTemplateID == 6857 or doodad.dwTemplateID == 6859) and s_util.GetDistance(me,doodad) <= 100 ) or WeiZhuang[doodad.dwID] then
		if not WeiZhuang[doodad.dwID] then
			WeiZhuang[doodad.dwID] = true
		end
		s_util.AddShape(TARGET.DOODAD, doodad.dwID, 255, 255, 0, 80, 360, 2)
	end
end,

--Doodad�뿪������1��������DoodadID
["OnDoodadLeave"] = function(dwID)
end,

--��ҽ��볡����1�����������ID 
["OnPlayerEnter"] = function(dwID)
	local me = GetClientPlayer()
	local player = GetPlayer(dwID)	--�ⷵ�صĶ���ֻ��ID֮��ģ����ֵȵȶ���ûͬ����ȡ���������Լ��޹ص��ˣ�Ҳû����ȡѪ�������ض���255
	if player and player.dwID ~= me.dwID and IsEnemy(me.dwID, player.dwID) then			--�������ң������ң��ǵ���
		if Party[player.dwID] then
			s_util.AddText(TARGET.PLAYER, player.dwID, 255, 0, 0, 200, "��-��"..tostring(Party[player.dwID]), 1.3, true)
		else
			s_util.AddText(TARGET.PLAYER, player.dwID, 255, 0, 0, 200, "��-��#��", 1.3, true)
		end
	end
end,

--����뿪������1�����������ID
["OnPlayerLeave"] = function(dwID)
end,

--ʩ�ż��ܵ��ã� ����������ID�� ����ID�� ���ܵȼ�
["OnCastSkill"] = function(dwID, dwSkillID, dwLevel)
	local player = GetClientPlayer()
	if not IsPlayer(dwID) or not IsEnemy(player.dwID,dwID) then return end	--���˵��ǵж����
	--���� 20�ߣ�ǧ��׹ 20�ߣ��� 15��
	if UpdateSkill(dwID,dwSkillID,13424,20) or UpdateSkill(dwID,dwSkillID,18604,20) or UpdateSkill(dwID,dwSkillID,424,15) then 
		s_util.SetTimer("tkongzhi1")
		s_Output(Table_GetSkillName(dwSkillID, dwLevel))
	end
	--���� 12�ߣ���Ծ��Ԩ 20�ߣ���ս��Ұ 20�ߣ�����ͷ 20�ߣ�����ع� 10�ߣ��ϻ�� 27�ߣ��Ƽ��� 4��
	if UpdateSkill(dwID,dwSkillID,13046,12) or UpdateSkill(dwID,dwSkillID,5262,20) or UpdateSkill(dwID,dwSkillID,5266,20) or UpdateSkill(dwID,dwSkillID,5259,20) or UpdateSkill(dwID,dwSkillID,16479,10) or UpdateSkill(dwID,dwSkillID,428,27) or UpdateSkill(dwID,dwSkillID,426,4) then 
		s_util.SetTimer("tkongzhi2")
		s_Output(Table_GetSkillName(dwSkillID, dwLevel))
	end
	--ڤ�¶��� 12�ߣ��������� 20�ߣ������� 6�ߣ����� 20��
	if UpdateSkill(dwID,dwSkillID,18629,12) or UpdateSkill(dwID,dwSkillID,2681,20) or UpdateSkill(dwID,dwSkillID,260,6) or UpdateSkill(dwID,dwSkillID,2645,20) then 
		s_util.SetTimer("tbaofa1")
		s_Output(Table_GetSkillName(dwSkillID, dwLevel))
	end
	--���� 20��
	if UpdateSkill(dwID,dwSkillID,568,20,true) then
		s_util.SetTimer("tbaofa2")
		s_Output(Table_GetSkillName(dwSkillID, dwLevel))
	end
	--������Ӱ 30��
	if UpdateSkill(dwID,dwSkillID,3112,30,true) then
		s_util.SetTimer("tbaofa3")
		s_Output(Table_GetSkillName(dwSkillID, dwLevel))
	end
	--����
	if dwSkillID==13067 and target and target.dwID==dwID then s_util.SetTimer("dunli") end
end,

--��������Ϣ����ã������� ����ID�����ݣ����֣�Ƶ��
["OnTalk"] = function(dwID, szText, szName, nChannel)
	--[[if IsPlayer(dwID) then return end									--���˵���ҵ�������Ϣ
	if tBossID[dwID] then				--ֻ���Boss˵�Ļ�
		s_Output("OnTalk: "..szName.." ˵ "..szText..", Ƶ��: "..nChannel)
	end--]]
end,


["OnDebug"] = function()
	local me = GetClientPlayer()		
    local OthdwID = 0		    
    for _,v in ipairs(GetAllPlayer()) do		--�����������
        if IsParty(me.dwID, v.dwID) then
            Party[v.dwID] = 0
		else
			OthdwID = v.dwID
			NoParty[v.dwID] = true
		end
	end
	for team = 1, 19, 1 do
		if NoParty[OthdwID] then
			local temp = OthdwID
			Party[temp] = team
			NoParty[temp] = nil
			for i,_ in ipairs(NoParty) do
				if IsParty(i, temp) then
					Party[i] = team
					NoParty[i] = nil
				else
					OthdwID = i
				end
			end
		end
	end
	local count = 0
	for k,v in ipairs(Party) do
    	count = count + 1
	end
	s_util.OutputSysMsg(szPluginName.."�������"..tostring(count).."���������¼���")
end,
}

--��������ϵͳ���ض���ı�
return tPlugin
