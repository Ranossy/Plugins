local szPluginName = "���ܲ���"

--�Լ��Ľ�ɫID
local meID = 0


local tPlugin = {
--����ڲ˵�����ʾ�����֡���������
["szName"] = szPluginName,

--������͡�  1(5�˸���)�� 2(10�˸���)�� 3(25�˸���)��4(������)��5(����)����������
["nType"] = 5,

--��ʼ�����������ò�������
["OnInit"] = function()
local player = GetClientPlayer()
if not player then return false end

meID = player.dwID	--��¼�Լ��Ľ�ɫID

s_util.OutputSysMsg("��� "..szPluginName.." ������")
s_util.OutputSysMsg("��ӭ "..player.szName.." ʹ�ñ����")
s_util.OutputSysMsg("������ߣ�xxxx")
return true
end,

--��ʼ�������������ͷż��ܵĽ�ɫID����һ���NPC��������ID�����ܵȼ���ʣ��֡����Ŀ�����ͣ�Ŀ��ID����x��y��z
["OnSkillPrepare"] = function(dwID, dwSkillID, dwLevel, nLeftFrame, targetClass, tidOrx, y, z)
if dwID == meID then
s_Output("��ʼ����", dwID, dwSkillID, dwLevel, nLeftFrame, targetClass, tidOrx, y, z)
end
end,

--�ͷż��ܣ��������ͷż��ܵĽ�ɫID����һ���NPC��������ID�����ܵȼ���Ŀ�����ͣ�Ŀ��ID����x��y��z
--����ص�����Ҳ�����Ӽ��ܣ����Ի��Ƶ���ĵ��ã�ע�����������⣬����������������ٵĵط�����
--���Ծ�ȷ�ж�ͨ�����ܣ��������Ҽ������ͷŵ��ڼ��Σ���Ϊ��ÿ�ζ�������ļ��ܣ���ʼͨ�����ܼ�����0��ÿ�ͷ�һ�Σ�����+1�����������PVE�е��ã����Ծ�ȷ���
--Ҳ�����жϼ���ǰҡ��ĳЩ���ܴ��ͷŵ�����Ч�����м�ʮ����ļ��
["OnSkillCast"] = function(dwID, dwSkillID, dwLevel, targetClass, tidOrx, y, z)
--
if dwID == meID and not IsCommonSkill(dwSkillID) then
local szSkillName = Table_GetSkillName(dwSkillID, dwLevel)
if szSkillName and szSkillName ~= "" then
s_Output("������ͷż���", szSkillName, dwID, dwSkillID, dwLevel, targetClass, tidOrx, y, z)
end
end
--]]
end,

--��ʼ�������ܣ��������ͷż��ܵĽ�ɫID����һ���NPC��������ID�����ܵȼ���Ŀ�����ͣ�Ŀ��ID����x��y��z
["OnStartHoardSkill"] = function(dwID, dwSkillID, dwLevel, targetClass, tidOrx, y, z)
--s_Output("OnStartHoardSkill", dwID, dwSkillID, dwLevel, targetClass, tidOrx, y, z)
end,

--��ʼͨ�����ܣ����ǵ��Ŷ����ļ��ܣ����������ͷż��ܵĽ�ɫID����һ���NPC��������ID�����ܵȼ���ʣ��֡����Ŀ�����ͣ�Ŀ��ID����x��y��z
["OnSkillChannel"] = function(dwID, dwSkillID, dwLevel, nLeftFrame, targetClass, tidOrx, y, z)
if dwID == meID then
s_Output("ͨ������", dwID, dwSkillID, dwLevel, nLeftFrame, targetClass, tidOrx, y, z)
end
end,

--����˼��ܴ��󣬲������ı�������
["OnSkillError"] = function(text, code)
s_Output("�����ʩ�ż���ʧ�� "..tostring(text).." ,���� "..tostring(code))
end,

--�Լ�buff���£��������Ƿ��Ƴ�(true���Ƴ���false�����)���Ƿ���ȡ����buffID���ȼ�������������֡��������buff�Ķ���ID
["OnMyBuff"] = function(bDelete, bCanCancel, dwBuffID, nLevel, nStackNum, nEndframe, dwSkillSrcID)
--[[
if bDelete then return end	--������Ƴ�������
local buffName = Table_GetBuffName(dwBuffID, nLevel)
if buffName and buffName ~= "" then
s_Output("�Լ����Buff: "..buffName..", ID: "..dwBuffID..", �ȼ�: "..nLevel..", ����: "..nStackNum..", ʣ��ʱ��(��): "..((nEndframe - GetLogicFrameCount()) / 16)..", ԴID: "..dwSkillSrcID)
end
--]]
end,

["OnTick"] = function()
end,

}

--��������ϵͳ���ض���ı�
return tPlugin