local szPluginName = "�Զ���¼"

Plugins_AutoLogin = {}

Plugins_AutoLogin.frame = Station.Lookup("Normal/LoginPassword")
--Plugins_AutoLogin.frame.OnFrameBreathe = function()
--	s_Output("��¼�������")
--end

if Plugins_AutoLogin.frame then
	local frame = Station.Lookup("Normal/LoginPassword/WndPassword")
	--frame:Lookup("Wnd_PasswordContent/Edit_Account"):SetText("mizukicoen")
	frame:Lookup("Wnd_PasswordContent/Edit_Password"):SetText("mizuki1980")
	--local btn = Station.Lookup("Normal/LoginPassword/WndPassword/Wnd_PasswordContent/Btn_OK")
	--local btn = Station.Lookup("Normal/LoginServerPanel/Wnd_ServerPanel/Btn_ChangeServer")
	--s_Output(type(btn))
	--s_util.UICall(btn, LoginServerPanel.OnLButtonClick)
	--local btn1 = Station.Lookup("Topmost/LoginServerList/Wnd_Button/Btn_Ok")
	--s_util.UICall(btn1, LoginServerList.OnLButtonClick)
	--Login.RequestLogin(g_tGlue.tLoginString["CONNECTING"], true)
	--Login.BeginWait(g_tGlue.tLoginString["ENTERING_GAME"])
end

----------------------------------��������ò����Ϣ�ͻص�����--------------------------------------
local tPlugin = {
--����ڲ˵�����ʾ�����֡���������
["szName"] = szPluginName,

--������͡�  1(5�˸���)�� 2(10�˸���)�� 3(25�˸���)��4(������)��5(����)����������
["nType"] = 5,

--�󶨵�ͼ��������ͼ����Ϊ��ͼID�������ͼ������Ϊ�����Բ����ã�����Ϸ���ֶ�����
["dwMapID"] = 0,

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
end,

["OnDebug"] = function()
end,
}

--��������ϵͳ���ض���ı�
return tPlugin
