--�������
local szPluginName = "����-PVP"

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
------------------------------------------------��������ò����Ϣ�ͻص�����------------------------------------------------
local tPlugin = {
--����ڲ˵�����ʾ�����֡���������
["szName"] = szPluginName,

--������͡�  1(5�˸���)�� 2(10�˸���)�� 3(25�˸���)��4(������)��5(����)����������
["nType"] = 5,

--�󶨵ĵ�ͼID�������Ӧ��ͼ�Զ����á�����ǿ�ѡ�ģ�ע�ⲻҪ�ظ������û�����ã�Ҳ��������Ϸ���ֶ��������
["dwMapID"] =0,

--��ʼ�����������ò������á�û�в���������һ��boolֵ��ָʾ����Ƿ��ʼ���ɹ����������false������������á���������������ʹ�õı�Ҫ�����������ͼID�Բ���֮��ģ�
["OnInit"] = function()
	local player = GetClientPlayer()
	s_util.OutputSysMsg("��� "..szPluginName.." ������")
	s_util.OutputSysMsg("��ӭ "..player.szName.." ʹ�ñ����")
	s_util.OutputSysMsg("������ߣ�������")
	return true
end,

--ÿ֡������ã�1��16֡)��û�в��������ڵ���Ƶ�������ʵ�ָ��ӣ���������һ��Ӱ�졣
["OnTick"] = function()
end,

--�о�����Ϣ����ã����������ͣ�����
["OnWarning"] = function(szType, szText)
end,

--��������Ϣ����ã������� ����ID�����ݣ����֣�Ƶ��
["OnTalk"] = function(dwID, szText, szName, nChannel)
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

--NPC���볡������ã�������NPCID
["OnNpcEnter"] = function(dwID)
end,

--NPC�뿪��������ã�������NPCID�����ﲻҪ�ٻ�ȡ����Ӧ��ִ�к����ID�йص�һЩ��������
["OnNpcLeave"] = function(dwID)
end,

--�˵�������Ե�ǰ�������ã��������������һЩ������Ϣ
["OnDebug"] = function()
end,
}


--��������ϵͳ���ض���ı�
return tPlugin
