local szPluginName = "�������̹���ǰ�ò��"

--���Ṧ����
--���̴��Ṧ����CatFlyTo (x, y, z, h, pass)
--������Ŀ�ĵ�X����,Ŀ�ĵ�Y����,Ŀ�ĵ�Z����,���и߶�Z����(ȱʡΪZ����+10000),�Ƿ�Ϊ·����(���ڵ���·�߹���ϰ�������ʱ�����½��߶�)
--���أ�����Ŀ�ĵ�����󷵻�true
function CatFlyTo (x, y, z ,h ,pass)
	if not h or type(h) == "boolean" then h, pass = (z+10000), h end
	local player = GetClientPlayer()
	s_util.TurnTo(x, y, z)
	if pass then 
		if	math.abs(player.nX-x)<1200 and math.abs(player.nY-y)<1200 then return true end
	end
	if math.abs(player.nX-x)<32 and math.abs(player.nY-y)<32 and math.abs(player.nZ-z)<32 then return true end
	if math.abs(player.nX-x)<1000 and math.abs(player.nY-y)<1000 then
		if math.abs(player.nZ-z)<1000 then
			s_cmd.MoveTo(x, y, z)
			return
		end
		if math.abs(player.nX-x)<360 and math.abs(player.nY-y)<360 and math.abs(player.nZ-z)<1000 then
			if player.nMoveState == 4 or player.nMoveState == 25 then
				player.PitchTo(-64)
			else
				s_cmd.MoveTo(x, y, z)
				return
			end
		else
			player.PitchTo(-44)
		end
	else
		if player.nZ < h then
			player.PitchTo(64)
		else
			player.PitchTo(0)
		end
	end
	if player.nMoveState ~= 25 and player.nSprintPower > 5 then
		StartSprint()
		Jump()
	else
		if s_util.Cast(9003, false) then return end
		if s_util.Cast(9005, false) then return end
		if s_util.Cast(9006, false) then return end
		if s_util.Cast(9004, false) then return end
	end
end
----------------------------------��������ò����Ϣ�ͻص�����--------------------------------------
local tPlugin = {
--����ڲ˵�����ʾ�����֡���������
["szName"] = szPluginName,

--������͡�  1(5�˸���)�� 2(10�˸���)�� 3(25�˸���)��4(������)��5(����)����������
["nType"] = 5,

--�󶨵�ͼ��������ͼ����Ϊ��ͼID�������ͼ������Ϊ�����Բ����ã�����Ϸ���ֶ�����
["dwMapID"] ={22, 30},

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
local nFrame, me = GetLogicFrameCount(), GetClientPlayer()
if not me.IsInParty() or (nFrame % 4) ~= 0 then return end  --ÿ�봦��4��

if GetClientTeam().GetAuthorityInfo(TEAM_AUTHORITY_TYPE.LEADER) == me.dwID then
	--ConvertToRaid() --ת��Ϊ�Ŷ�
	for k, v in ipairs(GetClientTeam().GetTeamMemberList()) do
		if v ~= me.dwID then
			GetClientTeam().SetAuthorityInfo(TEAM_AUTHORITY_TYPE.LEADER, v) --�ƽ��ӳ���ʡ������
			break
		end
	end
end
--GetClientTeam().RespondTeamApply(arg0, 1)--ͬ�����
--GetClientTeam().RespondTeamApply(arg0, 0)--�ܾ����
if not g_MacroVars.QianzhiTeam then 
	GetClientTeam().RequestLeaveTeam()
end
end,

--Doodad���볡����1��������DoodadID
["OnDoodadEnter"] = function(dwID)
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
["OnCastSkill"] = function(dwID, dwSkillID, dwLevel, targetClass, tidOrx, y, z)
end,

--��������Ϣ����ã������� ����ID�����ݣ����֣�Ƶ��
["OnTalk"] = function(dwID, szText, szName, nChannel)
if string.find(szText, "���뻢Ѩ") and g_MacroVars.QianzhiTeam == 1 then
	player = GetPlayer(dwID)
	if player then
		GetClientTeam().InviteJoinTeam(player.szName) 
		g_MacroVars.QianzhiTeam = 0
	end
end
if string.find(szText, "�Ĵ�����") and g_MacroVars.QianzhiTeam == 2 then
	player = GetPlayer(dwID)
	if player then
		GetClientTeam().InviteJoinTeam(player.szName) 
		g_MacroVars.QianzhiTeam = 0
	end
end
end,

["OnDebug"] = function()
end,
}

--��������ϵͳ���ض���ı�
return tPlugin
