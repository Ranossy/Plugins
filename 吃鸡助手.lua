local szPluginName = "�Լ�����1.1"

--�ϴ�ʰȡʱ����Ϸ֡
local lastpicktime = GetLogicFrameCount()

--������Ʒ��
local NearDoodad = {}

--��ɫ��
local tColor = {
["��"] = { 169, 169, 169,  1.0 },			--�죬�̣���������
["��"] = { 250, 250, 250,  1.0 },
["��"] = {   0, 210,  75,  1.0 },
["��"] = {   0, 126, 255,  1.2 },
["��"] = { 255,  45, 255,  1.4 },
["��"] = { 255, 165,   0,  1.6 },
["��"] = { 255, 255,   0,  1.0 },
["��"] = {  94,  38,  18,  1.0 }
}

--��Ҫ��ʾ��Doodad��
local tTempID = {
[6817] = "��",		--һ������
[6949] = "��",		--������������һ

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

[6822] = "��",		--����
}

--ʰȡ����������:��Ʒģ��ID�����أ���ģ��������Ʒ������6���ڣ����ظ���Ʒ�����򷵻�nil
local function = PickUp(TemplateID)
	for dwTemplateID, dooded in pairs(NearDoodad) do
		if dwTemplateID == TemplateID then
			for dwID, _  in pairs(dooded) do
				local dooded = GetDoodad(dwID)
				local dis = s_util.GetDistance(player, dooded)	
				local player = GetClientPlayer()
				if dooded and dis <=6 then
					return dooded
				end
			end
		end
	end
	return nil
end

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
["dwMapID"] = { 296, 297 },

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
	if(IsAltKeyDown() and IsKeyDown("F")) then --���¡�Alt��+��F�� ˳�򽻻�
		--���� ��װ ���� ��װ ���� ��װ �� ���� ��� ����
		local treasures = PickUp(6883) or PickUp(6884) or PickUp(6956) or PickUp(6955) or PickUp(6821) or PickUp(6953) or PickUp(6954) or PickUp(6820) or PickUp(6819) or PickUp(6951) or PickUp(6818) or PickUp(6952) or PickUp(6824) or PickUp(6875) or PickUp(6873) or PickUp(6863)
		if treasures and GetLogicFrameCount() - lastpicktime >= 3 and player.nMoveState == MOVE_STATE.ON_STAND then
			lastpicktime = GetLogicFrameCount()
			OpenDoodad(player, treasures)
		end
	end
end,

--Doodad���볡����1��������DoodadID
["OnDoodadEnter"] = function(dwID)
	local doodad = GetDoodad(dwID)
	if doodad then
		local szColor = tTempID[doodad.dwTemplateID]
		NearDoodad[dwTemplateID][dwID] = true
		if szColor then
			local t = tColor[szColor]
			if t then
				local r, g, b, s = unpack(t)
				--����Ϸ�����������ı�
				s_util.AddText(TARGET.DOODAD, doodad.dwID, r, g, b, 255, doodad.szName, s, true)		--�������ͣ�����ID, �죬�̣�����͸���ȣ��ı������ִ�С���ţ��Ƿ���ʾ����
			end
		end
	end
	s_Output(doodad.szName)
	s_Output("ID"..doodad.dwID)
	s_Output("ģ��ID"..doodad.dwTemplateID)
	s_Output("����"..doodad.nKind)
	s_Output(doodad.CanDialog)
	s_Output(doodad.IsSelectable)
end,

--Doodad�뿪������1��������DoodadID
["OnDoodadLeave"] = function(dwID)
	NearDoodad[dwID] = nil
end,

--��ҽ��볡����1�����������ID 
["OnPlayerEnter"] = function(dwID)
	local me = GetClientPlayer()
	local player = GetPlayer(dwID)			--�ⷵ�صĶ���ֻ��ID֮��ģ����ֵȵȶ���ûͬ����ȡ���������Լ��޹ص��ˣ�Ҳû����ȡѪ�������ض���255
	if player and player.dwID ~= me.dwID and IsEnemy(me.dwID, player.dwID) then			--�������ң������ң��ǵ���
		s_util.AddText(TARGET.PLAYER, player.dwID, 255, 0, 0, 200, "����", 1.2, true)
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
		s_Output("tkongzhi1")
	end
	--���� 12�ߣ���Ծ��Ԩ 20�ߣ���ս��Ұ 20�ߣ�����ͷ 20�ߣ�����ع� 10�ߣ��ϻ�� 27�ߣ��Ƽ��� 4��
	if UpdateSkill(dwID,dwSkillID,13046,12) or UpdateSkill(dwID,dwSkillID,5262,20) or UpdateSkill(dwID,dwSkillID,5266,20) or UpdateSkill(dwID,dwSkillID,5259,20) or UpdateSkill(dwID,dwSkillID,16479,10) or UpdateSkill(dwID,dwSkillID,428,27) or UpdateSkill(dwID,dwSkillID,426,4) then 
		s_util.SetTimer("tkongzhi2")
		s_Output("tkongzhi2")
	end
	--������Ӱ 30�ߣ�ڤ�¶��� 12�ߣ��������� 20�ߣ������� 6�ߣ����� 20�ߣ����� 20��
	if UpdateSkill(dwID,dwSkillID,3112,30) or UpdateSkill(dwID,dwSkillID,18629,12) or UpdateSkill(dwID,dwSkillID,2681,20) or UpdateSkill(dwID,dwSkillID,260,6) or UpdateSkill(dwID,dwSkillID,2645,20) or UpdateSkill(dwID,dwSkillID,568,20) then 
		s_util.SetTimer("tbaofa1")
		s_Output("tbaofa1")
	end
end,

["OnDebug"] = function()
	s_util.OutputSysMsg(szPluginName.." OnDebug ������")
end,
}

--��������ϵͳ���ض���ı�
return tPlugin
