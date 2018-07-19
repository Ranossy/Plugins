--�������
local szPluginName = "���ܼ�ز��v0.1.2"

--------------------------������ݣ����Զ��壩--------------------------
local SkillList = {
	[10002] = {},	--ϴ��
	[10003] = {},	--�׽�
	[10014] = {},	--��ϼ
	[10015] = {},	--̫��
	[10021] = {},	--����
	[10026] = {},	--��Ѫ
	[10028] = {},	--�뾭
	[10062] = {},	--����
	[10080] = {},	--����
	[10081] = {},	--����
	[10144] = {},	--��ˮ
	[10145] = {},	--ɽ��
	[10175] = {},	--����
	[10176] = {},	--����
	[10224] = {},	--����
	[10225] = {},	--����
	[10242] = {},	--��Ӱ
	[10243] = {},	--����
	[10268] = {},	--Ц��
	[10389] = {},	--����
	[10390] = {},	--��ɽ
	[10447] = {},	--Ī��
	[10448] = {},	--��֪
	[10464] = {},	--����
}
local Cache_Skill = {[1] = {}}
local Cache_Caster = {[1]="N"}
local PlayerList = {}


--------------------------�û����ݣ��Զ��壩--------------------------
SkillList[10026] = {	--10026 ��Ѫ
	--[������] = {��������(��ͨ����Ϊ1,���ܼ���Ϊ���ܴ���,͸֧����Ϊ͸֧�����ĸ���), ���μ���CD}
	["����ɽ"] = {dwType = 1, dwCDTime = 120},
	["�����"] = {dwType = 1, dwCDTime = 50},
	["�γ۳�"] = {dwType = 1, dwCDTime = 45},
	["��"] = {dwType = 1, dwCDTime = 20},
	["ս�˷�"] = {dwType = 1, dwCDTime = 6}
}
SkillList[10081] = {	--10081 ����
	--[������] = {��������(��ͨ����Ϊ1,���ܼ���Ϊ���ܴ���,͸֧����Ϊ͸֧�����ĸ���), ���μ���CD}
	
}

--------------------------��������--------------------------
local function OnCastSkill(dwCaster,dwSkillID,dwLevel)
	--s_Output(dwCaster,dwSkillID,dwLevel)
	local isPlayer 
	--�ж��ͷ����Ƿ���Ϊ��ң��жϽ������Cache_Caster���Ժ󶼴ӻ����ȡ
	if Cache_Caster[dwCaster] == "P" then
		isPlayer = true
	elseif Cache_Caster[dwCaster] == "N" then
		isPlayer = false
	else 
		isPlayer = IsPlayer(dwCaster)
		Cache_Caster[dwCaster] = isPlayer and "P" or "N"
	end
	--���������Ҿ�ֱ�ӷ���
	if not isPlayer then return end
	--�������Ҳ���PlayerListδ��¼�����ʼ��һ�Σ�����PlayerList
	if not PlayerList[dwCaster] then
		local castPlayer = GetPlayer(dwCaster)
		PlayerList[dwCaster] = {}
		PlayerList[dwCaster].szName = castPlayer.szName
		PlayerList[dwCaster].dwKungFu = castPlayer.GetKungfuMount().dwSkillID
		PlayerList[dwCaster].tSkill = {}
		outputTable(PlayerList)
	end
	local kungFu = PlayerList[dwCaster].dwKungFu
	local skillName
	--��ȡ���ܵ����֣�����Cache_Skill���Ժ󶼴ӻ����ȡ
	if not Cache_Skill[dwSkillID] then
		skillName = Table_GetSkillName(dwSkillID,dwLevel)
		Cache_Skill[dwSkillID]={}
		Cache_Skill[dwSkillID].szSkillName = skillName
		--�жϼ����Ƿ�����Ҫ��¼�ģ������ȡ���ܵ�ͼ�����Cache_Skill�����򷵻�
		if SkillList[kungFu][skillName] then
			Cache_Skill[dwSkillID].dwIconID = Table_GetSkillIconID(dwSkillID,dwLevel)
		else
			return
		end
	else
		skillName = Cache_Skill[dwSkillID].szSkillName
		--�жϼ����Ƿ�����Ҫ��¼�ģ����򷵻�
		if not SkillList[kungFu][skillName] then
			return
		end
	end
	local frameCount = GetLogicFrameCount()
	local skillType = SkillList[kungFu][skillName].dwType
	if skillType == 1 then	--��ͨ����
		--����ǰ֡�������浽�ý�ɫ�ü��ܵ��ͷ�֡��
		if not PlayerList[dwCaster].tSkill[skillName] then PlayerList[dwCaster].tSkill[skillName] = {} end
		PlayerList[dwCaster].tSkill[skillName].dwCastframeCount = frameCount
		s_Output(frameCount..":["..PlayerList[dwCaster].szName.."]cast["..skillName.."]")
	elseif skillType > 1 then	--���ܼ��ܣ���ʵ�֣�
	
	elseif skillType < 0 then	--͸֧���ܣ���ʵ�֣�
	
	else	--0��������ʵ�֣�
	
	end
end
local function RefreshCD(dwFrm)
	local skillCDMsg = ""
	for dwCastID,tCastInfo in pairs(PlayerList) do
		for szSkillName,tSkillInfo in pairs(PlayerList[dwCastID].tSkill) do
			local dwSkillCD = SkillList[PlayerList[dwCastID].dwKungFu][szSkillName].dwCDTime - (dwFrm - tSkillInfo.dwCastframeCount)/16
			if dwSkillCD < 0 then 
				dwSkillCD = 0 
			else
				dwSkillCD = string.format("%.1f",dwSkillCD)
				skillCDMsg = skillCDMsg.."["..szSkillName.."]="..dwSkillCD.."s;"
			end
		end
		if string.len(skillCDMsg) > 1 then
			skillCDMsg = "["..PlayerList[dwCastID].szName.."]:"..skillCDMsg
			skillCDMsg = skillCDMsg.."\n"
		end
	end
	if string.len(skillCDMsg) > 1 then
		s_Output(skillCDMsg)
		s_util.OutputTip(skillCDMsg)
		s_util.OutputSysMsg(skillCDMsg)
	end
	
end
local function UpdateCDData()--��CD�����ϴ���UI����ʵ�֣�

end
------------------------------------------------��������ò����Ϣ�ͻص�����------------------------------------------------
local tPlugin = {
--����ڲ˵�����ʾ�����֡���������
["szName"] = szPluginName,

--������͡�  1(5�˸���)�� 2(10�˸���)�� 3(25�˸���)��4(������)��5(����)����������
["nType"] = 4,

--�󶨵ĵ�ͼID�������Ӧ��ͼ�Զ����á�����ǿ�ѡ�ģ�ע�ⲻҪ�ظ������û�����ã�Ҳ��������Ϸ���ֶ��������
["dwMapID"] = 0,

--��ʼ�����������ò������á�û�в���������һ��boolֵ��ָʾ����Ƿ��ʼ���ɹ����������false������������á���������������ʹ�õı�Ҫ�����������ͼID�Բ���֮��ģ�
["OnInit"] = function()
	local player = GetClientPlayer()
	s_util.OutputSysMsg("��� "..szPluginName.." ������")
	s_util.OutputSysMsg("��ӭ "..player.szName.." ʹ�ñ����")
	s_util.OutputSysMsg("������ߣ�(�㡪�㡨)")
	s_util.OutputSysMsg("Ŀǰֻʵ����ͨ���ܼ�أ�������")
	return true
end,

--ÿ֡������ã�1��16֡)��û�в��������ڵ���Ƶ�������ʵ�ָ��ӣ���������һ��Ӱ�졣
["OnTick"] = function()
	local dwFrm = GetLogicFrameCount()
	if dwFrm % 16 == 0 then	--ÿ��16֡�������Զ���
		RefreshCD(dwFrm)
		--UpdateCDData()
	end
end,

--�о�����Ϣ����ã����������ͣ�����
["OnWarning"] = function(szType, szText)
	s_Output("OnWarning: "..szText)
end,

--��������Ϣ����ã������� ����ID�����ݣ����֣�Ƶ��
["OnTalk"] = function(dwID, szText, szName, nChannel)
	
end,

--ʩ�ż��ܵ��ã� ����������ID�� ����ID�� ���ܵȼ�
["OnCastSkill"] = function(dwID, dwSkillID, dwLevel)
	OnCastSkill(dwID,dwSkillID,dwLevel)
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
