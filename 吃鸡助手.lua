local szPluginName = "�Լ�����1.1"

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
[6816] = "��",		--һ��װ��
[6950] = "��",		--������װ����һ
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

[6858] = "��",		--��ľ
[6857] = "��",		--ɰʯ
[6859] = "��",		--�߹�
[6833] = "��",		--̾Ϣ�籮
}


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
end,

--Doodad���볡����1��������DoodadID
["OnDoodadEnter"] = function(dwID)
	local doodad = GetDoodad(dwID)
	if doodad then
		local szColor = tTempID[doodad.dwTemplateID]
		if szColor then
			local t = tColor[szColor]
			if t then
				local r, g, b, s = unpack(t)
				--����Ϸ�����������ı�
				s_util.AddText(TARGET.DOODAD, doodad.dwID, r, g, b, 255, doodad.szName, s, true)		--�������ͣ�����ID, �죬�̣�����͸���ȣ��ı������ִ�С���ţ��Ƿ���ʾ����
			end
		end
	end
end,

--Doodad�뿪������1��������DoodadID
["OnDoodadLeave"] = function(dwID)

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

["OnDebug"] = function()
	s_util.OutputSysMsg(szPluginName.." OnDebug ������")
end,
}

--��������ϵͳ���ض���ı�
return tPlugin
