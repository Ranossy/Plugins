--�������
local szPluginName = "���ֺ���"

--����Ҫ��ע��NPC�����ڹ�����Ϣ��ʡ��������Ϣ̫��
local tNotCareNpc = {
------------------------�ⲿ����ͨ�õ�------------------------
[4976] = "������̫��",
[4977] = "�����Ʋ��",
[4980] = "�������ǳ�",
[4982] = "������ɽ��",
[4981] = "����������",
[3080] = "����������",
[57807] = "���������",
[58294] = "������������",
[16174] = "ǧ�������",
[16175] = "ǧ��������",
[16176] = "ǧ��������",
[16177] = "ǧ���䶾ɷ",
[9997] = "����",
[9956] = "ʥЫ",
[9996] = "����",
[9998] = "����",
[9999] = "���",
[12944] = "�̵�",

------------------------ÿ��������ͬ------------------------

}

--���boss��Ϣ
local tBossID = {}

local UpdateBuffs = function(obj, tData)
	local tBuffInfo = s_util.GetBuffInfo(obj)
	for k,v in pairs(tBuffInfo) do
		if v.dwSkillSrcID == obj.dwID then			--�����boss�Լ���buff
			--�������ӵģ������Ϣ
			if not tData.tBuff[k] then
				local buffName = Table_GetBuffName(v.dwID, v.nLevel)
				s_Output(obj.szName.." ���Buff: "..buffName..", BuffID: "..v.dwID..", ʣ��ʱ��(��): "..v.nLeftTime..", �ȼ�:"..v.nLevel..", ����:"..v.nStackNum)
			end
		end
	end
	tData.tBuff = tBuffInfo			--��¼��ε�buff��
end

local UpdatePrepare = function(obj, tData)
	local bPrepare, dwSkillId, dwLevel, nProgress, nActionState =  GetSkillOTActionState(obj)
	if bPrepare then
		if not tData.bPrepare then		--����ϴβ��Ƕ���״̬
			local skillName = Table_GetSkillName(skillID, level)
			s_Output(obj.szName.." ��ʼ����: "..skillName..", ����ID: "..skillID..", ���ܵȼ�: "..level..", �����ٷֱ�: "..nProgress)
		end
		tData.bPrepare = true
	else
		tData.bPrepare = false
	end
end


------------------------------------------------��������ò����Ϣ�ͻص�����------------------------------------------------
local tPlugin = {
--����ڲ˵�����ʾ�����֡���������
["szName"] = szPluginName,

--������͡�  1(5�˸���)�� 2(10�˸���)�� 3(25�˸���)��4(������)��5(����)����������
["nType"] = 1,

--�󶨵ĵ�ͼID�������Ӧ��ͼ�Զ����á�����ǿ�ѡ�ģ�ע�ⲻҪ�ظ������û�����ã�Ҳ��������Ϸ���ֶ��������
["dwMapID"] = 262,

--��ʼ�����������ò������á�û�в���������һ��boolֵ��ָʾ����Ƿ��ʼ���ɹ����������false������������á���������������ʹ�õı�Ҫ�����������ͼID�Բ���֮��ģ�
["OnInit"] = function()
	local player = GetClientPlayer()
	s_util.OutputSysMsg("��� "..szPluginName.." ������")
	s_util.OutputSysMsg("��ӭ "..player.szName.." ʹ�ñ����")
	s_util.OutputSysMsg("������ߣ�xxx")
	return true
end,

--ÿ֡������ã�1��16֡)��û�в��������ڵ���Ƶ�������ʵ�ָ��ӣ���������һ��Ӱ�졣
["OnTick"] = function()

local player = GetClientPlayer()
if not player then return end

--��ȡ��ǰĿ��,δ��սûĿ��ֱ�ӷ���,ս����ûĿ��ѡ������ж�NPC,��������
local target, targetClass = s_util.GetTarget(player)							
if not player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) )then return end --
if player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) ) then  
local MinDistance = 20			--��С����
local MindwID = 0		    --���NPC��ID
for i,v in ipairs(GetAllNpc()) do		--��������NPC
	if IsEnemy(player.dwID, v.dwID) and s_util.GetDistance(v, player) < MinDistance and v.nMaxLife>1000 then	--����ǵжԣ����Ҿ����С
		MinDistance = s_util.GetDistance(v, player)                             
		MindwID = v.dwID                                                                    --�滻�����ID
		end
	end
if MindwID == 0 then 
    return --û�еж�NPC�򷵻�
else	
    SetTarget(TARGET.NPC, MindwID)  --�趨Ŀ��Ϊ����ĵж�NPC                
end
end
if target then s_util.TurnTo(target.nX,target.nY) end  --��������
end,

--�о�����Ϣ����ã����������ͣ�����
["OnWarning"] = function(szType, szText)
	s_Output("OnWarning: "..szText)
end,

--��������Ϣ����ã������� ����ID�����ݣ����֣�Ƶ��
["OnTalk"] = function(dwID, szText, szName, nChannel)
	--if IsPlayer(dwID) then return end									--���˵���ҵ�������Ϣ
	if tBossID[dwID] then				--ֻ���Boss˵�Ļ�
		s_Output("OnTalk: "..szName.." ˵ "..szText..", Ƶ��: "..nChannel)
	end
end,

--ʩ�ż��ܵ��ã� ����������ID�� ����ID�� ���ܵȼ�
["OnCastSkill"] = function(dwID, dwSkillID, dwLevel)
	--if IsPlayer(dwID) then return end				--���˵����
	local tData = tBossID[dwID]
	if tData then									--ֻ���Boss
		local boss = GetNpc(dwID)
		if boss then
			if not tData.tSkill[dwSkillID] then tData.tSkill[dwSkillID] = {} end
			local tSkillData = tData.tSkill[dwSkillID]
			local lastCastTime = tSkillData.lastCastTime or 0				--�ϴ��ͷ�ʱ��
			local currTime = GetTickCount()							--��ǰʱ�䣨���룩
			local skillName = Table_GetSkillName(dwSkillID, dwLevel)
			s_Output("OnCastSkill: "..boss.szName.." ʩ�ż���: "..skillName..", ID: "..dwSkillID..", �ȼ�: "..dwLevel..", ��ǰʱ��: "..currTime..", ���ϴμ��: "..(currTime - lastCastTime))
			tSkillData.lastCastTime = currTime			--��¼ʩ��ʱ��
		end
	end
end,

--NPC���볡������ã�������NPCID
["OnNpcEnter"] = function(dwID)
	local npc = GetNpc(dwID)
	if npc then
		if GetNpcIntensity(npc) == 4 then			--�����boss
			if not tBossID[dwID] then
				tBossID[dwID] = { tBuff = {}, tSkill = {} }			--boss���ݲ����
			end
		end
		local dwTempID = npc.dwTemplateID
		if tNotCareNpc[dwTempID] then return end		--���˵�����ע��NPC������Ϣ
		s_Output("OnNpcEnter: ".."����: "..npc.szName..", ģ��ID: "..dwTempID..", ����ID: "..dwID)
	end
end,

--NPC�뿪��������ã�������NPCID�����ﲻҪ�ٻ�ȡ����Ӧ��ִ�к����ID�йص�һЩ��������
["OnNpcLeave"] = function(dwID)
	tBossID[dwID] = nil
end,

--�˵�������Ե�ǰ�������ã��������������һЩ������Ϣ
["OnDebug"] = function()
	s_Output(szPluginName.." OnDebug ������")
end,
}


--��������ϵͳ���ض���ı�
return tPlugin
