local szPluginName = "�Լ�����1.0"

--��ɫ��
local tColor = {
["��"] = { 169, 169, 169,  1.0 },			--�죬�̣���������
["��"] = { 250, 250, 250,  1.0 },
["��"] = {   0, 210,  75,  1.0 },
["��"] = {   0, 126, 255,  1.2 },
["��"] = { 255,  45, 255,  1.4 },
["��"] = { 255, 165,   0,  1.6 },
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

["OnDebug"] = function()
	s_util.OutputSysMsg(szPluginName.." OnDebug ������")
end,
}

--��������ϵͳ���ض���ı�
return tPlugin
