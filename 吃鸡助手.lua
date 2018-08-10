local szPluginName = "�Լ�����1.2"

--αװ��¼
g_MacroVars.chijizhushou_WeiZhuangID = nil
g_MacroVars.chijizhushou_gouxuan = false

--���ֲ˵�
local chijimenu = {
	szOption = "�Լ����ֹ���",
	{
	szOption = "����αװID",
	fnAction =function() 
		g_MacroVars.chijizhushou_WeiZhuangID = nil
		s_util.OutputSysMsg("αװ��СID������") 
	end,
	},
	{
	szOption = "ȷ��αװID",
	fnAction =function() 
		s_util.OutputSysMsg("αװ��СIDΪ��"..tostring(g_MacroVars.chijizhushou_WeiZhuangID)) 
	end,
	},
	{
	szOption = "��ѡ����",
	bCheck = true, 
	bChecked = g_MacroVars.chijizhushou_gouxuan,
	fnAction =function() 
		g_MacroVars.chijizhushou_gouxuan = not g_MacroVars.chijizhushou_gouxuan
	end,
	},
}

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
	if not bol and target then
		if SkillID == dwSkillID and distance<=Dis and target.dwID==player.dwID then
			return true
		else
			return false
		end
	end
	if bol then
		if SkillID == dwSkillID and distance<=Dis then
			return true
		else
			return false
		end
	end
end

local tForceTitle = {
	[0] = "��",
	[7] = "��",
	[1] = "ͺ",
	[2] = "��",
	[4] = "��",
	[8] = "ߴ",
	[9] = "ؤ",
	[5] = "��",
	[10] = "��",
	[22] = "��",
	[3] = "��",
	[6] = "��",
	[23] = "��",
	[21] = "��",
}
local tPlayerForce = {}
local tPlayer = {}

-- ��ȡ�����������
local GetForceTitle = function(playerObject)
	local dwID = playerObject.dwID
	local nForce = playerObject.dwForceID
	if tPlayerForce[dwID] and tPlayerForce[dwID] > 0 then
		return tForceTitle[tPlayerForce[dwID]]
	end
	if nForce > 0 and tForceTitle[nForce] then
		tPlayerForce[dwID] = nForce
		return tForceTitle[nForce]
	end
	return tForceTitle[0]
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
	local me = GetClientPlayer()
	if not me then return false end
	s_util.OutputSysMsg("��� "..szPluginName.." ������")
	s_util.OutputSysMsg("��ӭ "..me.szName.." ʹ�ñ����")
	g_MacroVars.chijizhushou_WeiZhuangID = nil
	local menuisaction = false
	--�жϲ˵��Ƿ��Ѽ���
	for i,v in ipairs(TraceButton_GetAddonMenu()) do
		if type(v)=="table" then
			if v.szOption and v.szOption == "�Լ����ֹ���" then
				menuisaction = true
				break
			end
		end
	end
	if not menuisaction then
		TraceButton_AppendAddonMenu({chijimenu})
	end
	return true
end,

["OnTick"] = function()
	Minimap.bSearchRedName = true			--��С��ͼ����
	local nFrame, me = GetLogicFrameCount(), GetClientPlayer()
	if not me or (nFrame % 4) ~= 0 then return end
	for i,v in ipairs(GetAllPlayer()) do		--����
		if v and v.dwID ~= me.dwID then			--�������ң�������
			local dwForceTitle = GetForceTitle(v)
			if IsEnemy(me.dwID, v.dwID) and v.nMoveState ~= MOVE_STATE.ON_DEATH then	--����ǵ���
				local hpRatio, _ = math.modf(100 * v.nCurrentLife / v.nMaxLife)
				s_util.AddText(TARGET.PLAYER, v.dwID, 255, 0, 0, 200, dwForceTitle..hpRatio.."��", 1.3, true)
			end
		end
	end
	if g_MacroVars.chijizhushou_gouxuan then
		s_util.OutputSysMsg("�ѹ�ѡ") 
	end
end,

--Doodad���볡����1��������DoodadID
["OnDoodadEnter"] = function(dwID)
	local doodad = GetDoodad(dwID)
	local me = GetClientPlayer()
	local WeiZhuangID = g_MacroVars.chijizhushou_WeiZhuangID
	if doodad then 
		if tTempID[doodad.dwTemplateID] then
			local t = tColor[tTempID[doodad.dwTemplateID]]
			if t then
				local r, g, b, s = unpack(t)
				--����Ϸ�����������ı�
				s_util.AddText(TARGET.DOODAD, doodad.dwID, r, g, b, 255, doodad.szName, s, true)--�������ͣ�����ID, �죬�̣�����͸���ȣ��ı������ִ�С���ţ��Ƿ���ʾ����
			end
		end
		--��������װ����¼Ϊ��СID�����ڴ�ID���ж�Ϊαװ
		if not WeiZhuangID and doodad.dwTemplateID >= 6949 and doodad.dwTemplateID <= 6954 then
			g_MacroVars.chijizhushou_WeiZhuangID, WeiZhuangID = doodad.dwID, doodad.dwID
		end
		--αװ��ǻ�Ȧ
		if doodad.dwTemplateID >= 6857 and doodad.dwTemplateID <= 6859 and WeiZhuangID and doodad.dwID > WeiZhuangID then
			s_util.AddShape(TARGET.DOODAD, doodad.dwID, 255, 255, 0, 100, 360, 2)
		end
	end
end,

--Doodad�뿪������1��������DoodadID
["OnDoodadLeave"] = function(dwID)
end,

--��ҽ��볡����1�����������ID 
["OnPlayerEnter"] = function(dwID)
end,

--����뿪������1�����������ID
["OnPlayerLeave"] = function(dwID)
end,

--ʩ�ż��ܵ��ã� ����������ID�� ����ID�� ���ܵȼ�
["OnCastSkill"] = function(dwID, dwSkillID, dwLevel)
	local player = GetClientPlayer()
	local target, targetClass = s_util.GetTarget(player)
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
end,

["OnDebug"] = function()
end,
}

--��������ϵͳ���ض���ı�
return tPlugin
