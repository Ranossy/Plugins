--����UI��ʽ��������װ����ʾ����װ�ж��Ͷ����ʶ���Ҽ����Ѫ�����Ӷ�����ѡ�
--�ŵ��������Ӷ��ѱ�ʶ����ɫΪ��ɫ����ͷ������ͬɫ
--�ŵ�����ɾ��Ѫ����ʶ���滻Ϊ�����ʶ��
--װ����ʾ��װ�ָ����Լ��ĵ��ˣ������ּ�װ�ֻ��Ϊ��ɫ���ŵ�������ɫͬ���仯
--��װ�ж����г�װ�ĵ��ˣ������ּ�װ�ֻ��λ��ɫ���ŵ�������ɫͬ���仯
--�����ʶ����ѡĿ��󣬸���Ŀ�������buff�ж��Ƿ��ж��ѣ��ж��Ѿͽ��ж����ű�ǣ���ʱ�޷��ж��ı��Ϊ������
--�����ǣ��Ҽ����Ŀ���б�Ѫ�����ᵯ��������ѡ���ѡ�󽫶���ѡĿ��Ķ����Ա�ӽ���ʼ���α�ǡ���δ�ж�����ĵ��˾�ֻ�������һ��

local szPluginName = "�Լ�����1.6" 

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

local tForceTitle = {
	[0] = {"��", 0,},
	[7] = {"��", 7,},
	[1] = {"ͺ", 1,},
	[2] = {"��", 2,},
	[4] = {"��", 4,},
	[8] = {"ߴ", 8,},
	[9] = {"ؤ", 9,},
	[5] = {"��", 5,},
	[10] = {"��", 10,},
	[22] = {"��", 22,},
	[3] = {"��", 3,},
	[6] = {"��", 6,},
	[23] = {"��", 23,},
	[21] = {"��", 21,},
	}

local KungfuList = {
	[10002] = {"ϴ", 10002,},
	[10003] = {"ͺ", 10003,},
	[10014] = {"��", 10014,},
	[10015] = {"��", 10015,},
	[10021] = {"��", 10021,},
	[10028] = {"��", 10028,},
	[10026] = {"��", 10026,},
	[10062] = {"��", 10062,},
	[10080] = {"��", 10080,},
	[10081] = {"��", 10081,},
	[10144] = {"��", 10144,},
	[10145] = {"��", 10145,},
	[10175] = {"��", 10175,},
	[10176] = {"��", 10176,},
	[10224] = {"��", 10224,},
	[10225] = {"��", 10225,},
	[10242] = {"��", 10242,},
	[10243] = {"��", 10243,},
	[10389] = {"��", 10389,},
	[10390] = {"��", 10390,},
	[10447] = {"��", 10447,},
	[10448] = {"��", 10448,},
	[10464] = {"��", 10464,},
	[10268] = {"ؤ", 10268,},
	}

--�����ɫ������Ϣ
local tPlayerForce = {}
--�����ɫ�ķ���Ϣ
local tPlayer = {}

local Party = {}

local teamnum = 0

-- ��ȡ����ķ���������
local function GetForceTitle (playerObject)
	local dwID = playerObject.dwID
	local nForce = playerObject.dwForceID
	local KungfuID = playerObject.dwMountKungfuID
	--���ȷ����ڹ��ķ�
	if tPlayer[dwID] then
		return tPlayer[dwID][1], tPlayer[dwID][2], true
	end
	if KungfuID then
		if KungfuList[KungfuID] then
			tPlayer[dwID] = KungfuList[KungfuID]
			return tPlayer[dwID][1], tPlayer[dwID][2], true
		end
	else
		local kungfu = playerObject.GetKungfuMount()
		if kungfu and KungfuList[kungfu.dwSkillID] then
			tPlayer[dwID] = KungfuList[kungfu.dwSkillID]
			return tPlayer[dwID][1], tPlayer[dwID][2], true
		end
	end	
	--���ڹ���ʾ����
	if tPlayerForce[dwID] then
		return tPlayerForce[dwID][1], tPlayerForce[dwID][2], false
	end
	if nForce > 0 and tForceTitle[nForce] then
		tPlayerForce[dwID] = tForceTitle[nForce]
		return tPlayerForce[dwID][1], tPlayerForce[dwID][2], false
	end
	return tForceTitle[0][1], tForceTitle[0][2], false
end

--������麯��
local function GetParty(ID1, ID2)
	local num = Party[ID1] or Party[ID2]
	if num then 
		Party[ID1], Party[ID2] = num , num
	else
		teamnum = teamnum + 1 
		Party[ID1], Party[ID2] = teamnum , teamnum
	end
end

local function UpdateSkill (ID,dwSkillID,SkillID,Dis)
	local wanjia = GetPlayer(ID)
	local target, targetClass = s_util.GetTarget(wanjia)
	local player = GetClientPlayer()
	local distance = s_util.GetDistance(player,wanjia)
	if SkillID == dwSkillID and distance<=Dis then
		return true
	else
		return false
	end
end
---------------------------------------��Ŀ���б�����-------------------------------------------
--Ŀ���б���������
if not Junefocus then
	Junefocus={
		y0n = true,			 			--�����Ƿ��
		frame = nil,					--���������
		bShowFocus = true,				--�Ƿ���ʾ�б�
		frameSelf = nil,				
		frameTotal = nil,				
		frameList = nil,
		FocusList = {},					--Ŀ���б�
		IniFile = "interface\\SCD\\Junefocus.ini",		--����ini�ļ�·��
		Anchor={nX=500,nY=500},			--��ʼ���
	}
end

function Junefocus.OnFrameCreate()
	s_Output("���洴��")
end

function Junefocus.OnFrameBreathe()
	s_Output("�������")
end

function Junefocus.OnItemLButtonClick()
	s_Output("�ؼ����")
end

--���ش��ں���
function Junefocus.SwitchActive()
	if Junefocus.y0n then
		Junefocus.y0n=false
		Junefocus.frameSelf:Hide()
		Junefocus.ItemsTable = {}
		OutputMessage("MSG_SYS","Ŀ���б� �ѹر�!\n")
	else
		Junefocus.y0n=true
		Junefocus.OpenPanel()
		OutputMessage("MSG_SYS","Ŀ���б� �ѿ���!\n")
	end
end

--������壬���ð�������
function Junefocus.OpenPanel()
	local frame = Station.Lookup("Normal/Junefocus")
	if not frame then
		frame = Wnd.OpenWindow(Junefocus.IniFile, "Junefocus")
	end
	Junefocus.frameSelf = Station.Lookup("Normal/Junefocus")
	Junefocus.frameTotal = frame:Lookup("", "")
	Junefocus.frameList = Station.Lookup("Normal/Junefocus", "Handle_List")
	Junefocus.BtnSetting = frame:Lookup("Btn_Setting")
	Junefocus.BtnClose = frame:Lookup("Btn_Close")
	Junefocus.Minimize = frame:Lookup("CheckBox_Minimize")
	--���ּ��������˵�
	Junefocus.BtnSetting.OnLButtonClick = function()
		PopupMenu(g_MacroVars.chijimenu)
	end
	--XX�����ر�UI����
	Junefocus.BtnClose.OnLButtonClick = function()
		Junefocus.SwitchActive()
	end
	--��С����ѡ�������б�UI
	Junefocus.Minimize.OnCheckBoxCheck = function()
		Junefocus.bShowFocus = false
		Junefocus.frameList:Hide()
		Junefocus.frameSelf:SetSize(300, 32)
		Junefocus.frameTotal:SetSize(300, 32)
	end
	--��С��ȡ����ѡ����ʾ�б�UI
	Junefocus.Minimize.OnCheckBoxUncheck = function()
		Junefocus.bShowFocus = true
		Junefocus.frameList:Show()
	end
	if Junefocus.y0n then
		frame:Show()
	else
		frame:Hide()
	end
	Junefocus.frameList:Clear()
end

--��ק���庯��
function Junefocus.OnFrameDragEnd()
	s_Output("������ק")
	Junefocus.Anchor.nX, Junefocus.Anchor.nY = this:GetRelPos()
end

--��Ŀ�������Ŀ���б�
function Junefocus.addFocus(dwID)
	if not dwID then
		nType, dwID = GetClientPlayer().GetTarget()
	end
	local tar, tType=GetPlayer(dwID), TARGET.PLAYER
	if tar then
		--Ŀ�������Ƴ���¼
		if tar.nMoveState == MOVE_STATE.ON_DEATH then 
			Junefocus.RemoveFocus(dwID)
			return
		else
			local player = GetClientPlayer()
			local dis = s_util.GetDistance(player, tar)
			local szlife= tar.nCurrentLife/tar.nMaxLife
			local level --����ȼ���������
			if dis < 20 then
				level = 1
			else
				level = 2
			end
			if not szlife then
				Junefocus.RemoveFocus(dwID)
				return
			end
			--�����б�ĩλ����¼Ŀ����룬Ŀ��ID��Ŀ�������ٷֱ�,����ȼ�
			table.insert(Junefocus.FocusList, {[1]=dis, [2]=tar.dwID, [3]=szlife, [4]=level,})
		end
	end
end

--�����б�handle��û������Ӵ�����
function Junefocus.DrawFocus(dwID)
	local obj = GetPlayer(dwID)
	if obj then
		if obj.nMoveState == MOVE_STATE.ON_DEATH then
			Junefocus.RemoveFocus(dwID)
		else
			local szName = obj.szName
			if string.find(szName,"(.+)@(.+)") then
				szName=(string.gsub(szName, "(.+)%@(.+)", "%1"))
			end
			local nName = szName
			if #nName  > 8 then
				nName =string.sub(nName, 0, 8)
			end
			local weizhi = "δ֪"
			local dwType = TARGET.PLAYER
			local School1, School2, School3 = GetForceTitle(obj)
			local hList = Station.Lookup('Normal/Junefocus', 'Handle_List')
			local player = GetClientPlayer()
			local dis = math.floor(s_util.GetDistance(player, obj))
			if not (obj and hList) then
				return
			end
			--PeekOtherPlayer(obj.dwID) --��ȡ�����Ϣ
			--���Handle
			local hItem = Junefocus.GetHandle(dwID)
			if not hItem then
				hItem = hList:AppendItemFromIni(Junefocus.IniFile, 'Handle_Info')
				hItem:SetName('HI_'..dwID)
			end

			-- GPS��λ
			-- ��������
			if player then
				hItem:Lookup('Handle_Compass'):Show()
				hItem:Lookup('Handle_Compass/Image_Player'):Show()
				hItem:Lookup('Handle_Compass/Image_Player'):SetRotate( - player.nFaceDirection / 128 * math.pi)
			end
			--Ŀ�����λ��
			local h = hItem:Lookup('Handle_Compass/Image_PointRed')
			hItem:Lookup('Handle_Compass/Image_PointRed'):Show()
			local nRotate = 0
			if player.nX == obj.nX then
				if player.nY > obj.nY then
					nRotate = math.pi / 2
				else
					nRotate = - math.pi / 2
				end
			else
				nRotate = math.atan((player.nY - obj.nY) / (player.nX - obj.nX))
			end
			if nRotate < 0 then
				nRotate = nRotate + math.pi
			end
			if obj.nY < player.nY then
				nRotate = math.pi + nRotate
			end
			local nRadius = 9.5
			h:SetRelPos((nRadius + nRadius * math.cos(nRotate)), (nRadius - nRadius * math.sin(nRotate))+1.5)
			hItem:Lookup('Handle_Compass'):FormatAllItemPos()
			
			--�ķ�ͼ��
			if School3 then
				hItem:Lookup('Image_School'):FromIconID(Table_GetSkillIconID(School2, 1))
			else
				hItem:Lookup('Image_School'):FromUITex(GetForceImage(School2))
			end
			
			-- ����
			local hitname = hItem:Lookup("Text_Name")
			hitname:SetText(dis.."�ߡ�"..(nName or weizhi))
			
			--���顤װ��
			local score = obj.GetTotalEquipScore()
			local dui = Party[obj.dwID] or "��"
			hItem:Lookup("Text_Score"):SetText("��"..dui.."��"..score)

			--Ѫ���ٷֱ�
			local nCurrentLife, nMaxLife = obj.nCurrentLife, obj.nMaxLife
			local szLife = ''
			if nMaxLife > 0 then
				local nPercent = math.floor(nCurrentLife / nMaxLife * 100)
				if nPercent > 100 then
					nPercent = 100
				end
				szLife = nPercent .. '%'
				hItem:Lookup("Image_Health"):SetPercentage(nCurrentLife/nMaxLife)
				hItem:Lookup("Text_Health"):SetText(szLife)
			end
			
			--���
			hItem:Lookup('Handle_Mark'):Hide()
			local KTeam = GetClientTeam()
			if KTeam then
				local tMark = KTeam.GetTeamMark()
				if tMark then
					local nMarkID = tMark[dwID]
					if nMarkID then
						hItem:Lookup('Handle_Mark'):Show()
						hItem:Lookup('Handle_Mark/Image_Mark'):FromUITex(PARTY_MARK_ICON_PATH, PARTY_MARK_ICON_FRAME_LIST[nMarkID])
					end
				end
			end
			
			--ѡ��Ŀ�갴ť
			local nIndex
			for i, p in ipairs(Junefocus.FocusList) do
				if p[2] == dwID then
					nIndex = i
					break
				end
			end
			hItem:SetRelPos(0,(nIndex-1)*44)
			if nIndex <= 10 then
				btn = Junefocus.frameSelf:Lookup("Btn_C"..nIndex)
				btn.OnLButtonClick = function()
					SetTarget(4, Junefocus.FocusList[nIndex][2])
				end
				btn.OnRButtonClick = function()
					local menu = {
						szOption = "��Ƕ���",
						fnAction = function()
							local me = GetClientPlayer()
							local myteam = GetClientTeam()
							if myteam and myteam.GetAuthorityInfo(TEAM_AUTHORITY_TYPE.MARK) == me.dwID then
								if not Party[Junefocus.FocusList[nIndex][2]] then
									myteam.SetTeamMark(1, Junefocus.FocusList[nIndex][2])
								else
									local dui = Party[Junefocus.FocusList[nIndex][2]]
									local teamformark = {Junefocus.FocusList[nIndex][2],}
									for i, p in pairs(Party) do
										if p == dui then
											table.insert(teamformark, i)
										end
									end									
									for i, p in ipairs(teamformark) do
										if i <= 10 then
											myteam.SetTeamMark(i, p)
										else
											break
										end
									end
								end
							else 
								s_util.OutputSysMsg("��û�б��Ȩ�ޣ�") 
							end
						end,
					}
					PopupMenu({menu})
				end
				btn:Show()
			end
			
			--��ʾHandle
			hItem:Show()
			if dis > 30 then
				hItem:SetAlpha(200)
			end
			
			--װ�ֱ�ɫ
			local me = GetClientPlayer()
			if score > me.GetTotalEquipScore() then --װ�ֳ�������ɫ
				hitname:SetFontColor(255,  45, 255)
				hItem:Lookup("Text_Score"):SetFontColor(255,  45, 255)
			end
			for i=0 ,12 do --��װ�ж�
				if GetPlayerItem(obj, INVENTORY_INDEX.EQUIP, i) and GetPlayerItem(obj, INVENTORY_INDEX.EQUIP, i).nQuality>4 then 
					hitname:SetFontColor(255, 165,   0)
					hItem:Lookup("Text_Score"):SetFontColor(255, 165,   0)
					break
				end
			end
		end
	end
	
	--�������ڴ�С
	local nWidthNeed = 300
	local nHeightNeed 
	if #Junefocus.FocusList <= 10 then
		nHeightNeed = 44 * #Junefocus.FocusList + 32
	else 
		nHeightNeed = 472
	end
	Junefocus.frameSelf:SetSize(nWidthNeed, nHeightNeed)
	Junefocus.frameTotal:SetSize(nWidthNeed, nHeightNeed)
	Junefocus.frameList:SetSize(nWidthNeed, nHeightNeed-32)
	Junefocus.frameList:FormatAllItemPos()
end

--��ȡָ�������Handle û�з���nil
function Junefocus.GetHandle(dwID)
	return Station.Lookup('Normal/Junefocus', 'Handle_List/HI_'..dwID)
end

--��Ŀ���Ƴ������б�
function Junefocus.RemoveFocus(dwID)
	-- ���б�������ɾ��
	local dwType = TARGET.PLAYER
	for i = #Junefocus.FocusList, 1, -1 do
		local p = Junefocus.FocusList[i]
		if p[2] == dwID then
			table.remove(Junefocus.FocusList, i)
			break
		end
	end
	-- ��UI��ɾ��
	local hList = Station.Lookup('Normal/Junefocus', 'Handle_List')
	local szKey = 'HI_'..dwID
	local hItem = Station.Lookup('Normal/Junefocus', 'Handle_List/' .. szKey)
	if hItem then
		hList:RemoveItem(hItem)
	end
	hList:FormatAllItemPos()
end

function Junefocus.Sort(a, b)
	local r
	--����ȼ�
	local a4 = tonumber(a[4])
	local b4 = tonumber(b[4])
	--����
	local a1 = tonumber(a[1])
	local b1 = tonumber(b[1])
	--Ѫ���ٷֱ�
	local a3 = tonumber(a[3])
	local b3 = tonumber(b[3])
	--�������ȼ���1.����ȼ��ɵ͵��ߣ�2.Ѫ���ٷֱ��ɵ͵��ߣ�3.�����ɵ͵���
	if a4 == 1 and b4 == 1 then
		if a3 == b3 then
			r = a1 < b1
		else
			r = a3 < b3
		end
	elseif a4 == 2 and b4 == 2 then
		r = a1 < b1
	elseif a4 ~= b4 then
		r = a4 < b4
	end
	return r
end

----------------------------------��������ò����Ϣ�ͻص�����--------------------------------------
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

	--����αװID
	g_MacroVars.chijizhushou_WeiZhuangID = nil

	--���ֲ˵�
	if not g_MacroVars.chijimenu then
		g_MacroVars.chijimenu = {
		szOption = "�Լ����ֹ���",
		{
		szOption = "���ٱ��",
		fnAction =function() 
			local me = GetClientPlayer()
			local myteam = GetClientTeam()
			if myteam and myteam.GetAuthorityInfo(TEAM_AUTHORITY_TYPE.MARK) == me.dwID then
				for i, p in ipairs(Junefocus.FocusList) do
					if i <= 10 then
						myteam.SetTeamMark(i, p[2])
					else
						break
					end
				end
			else 
				s_util.OutputSysMsg("��û�б��Ȩ�ޣ�") 
			end
		end,
		},
		{
		szOption = "����Ŀ���б�",
		bCheck = true, 
		bChecked =function() return Junefocus.y0n end,
		fnAction =Junefocus.SwitchActive,
		},
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
	}
	end
	
	if not g_MacroVars.chijimenuisaction then
		TraceButton_AppendAddonMenu({g_MacroVars.chijimenu})
		g_MacroVars.chijimenuisaction = true
	end

	Junefocus.FocusList = {}
	Junefocus.SwitchActive()

	return true
end,

["OnTick"] = function()
	Minimap.bSearchRedName = true			--��С��ͼ����
	local nFrame, me = GetLogicFrameCount(), GetClientPlayer()
	
	if not me or (nFrame % 4) ~= 0 then return end  --ÿ�봦��4��
	
	if (nFrame % 16) == 0 then --�б�����ÿ1Sˢ��
		Junefocus.FocusList = {}	--���Ŀ����
		if Station.Lookup('Normal/Junefocus', 'Handle_List') then Station.Lookup('Normal/Junefocus', 'Handle_List'):Clear() end		--�Ƴ�list���пؼ�
	end
	
	for i,v in ipairs(GetAllPlayer()) do			--����
		if v and v.dwID ~= me.dwID then				--�������ң�������
			local dis = s_util.GetDistance(me, v)
			if IsEnemy(me.dwID, v.dwID) and v.nMoveState ~= MOVE_STATE.ON_DEATH and dis < 300 then	--����ǵ���
				local dui = Party[v.dwID] or "��"	--������Ϣ
				local score = v.GetTotalEquipScore()	--��ȡװ��	
				if score == 0 or (nFrame % 80) == 0 then
					PeekOtherPlayer(v.dwID)					--��ȡ��������Ϣ
				end
				score = v.GetTotalEquipScore()	--��ȡװ��	
				local sco = (math.floor(score/1000))/10	--װ��ȡ��
				local dwForceTitle = GetForceTitle(v)
				if score > me.GetTotalEquipScore() then 	--װ�ֳ�������ɫ
					s_util.AddText(TARGET.PLAYER, v.dwID, 255, 45, 255, 200,sco.."W"..dwForceTitle.."����"..dui.."��", 1.3, true)
				else 										--����Ϊ��ɫ
					s_util.AddText(TARGET.PLAYER, v.dwID, 255, 0, 0, 200, sco.."W"..dwForceTitle.."����"..dui.."��", 1.3, true)
				end
				for i=0 ,12 do	--��װ�ж�
					if GetPlayerItem(v, INVENTORY_INDEX.EQUIP,i) and GetPlayerItem(v, INVENTORY_INDEX.EQUIP, i).nQuality>4 then 
						s_util.AddText(TARGET.PLAYER, v.dwID, 255, 165, 0, 200, sco.."W"..dwForceTitle.."����"..dui.."��", 1.3, true)
						break
					end
				end
				if (nFrame % 16) == 0 then
					Junefocus.addFocus(v.dwID)	--д��Ŀ���б�
				end
			end
			if IsParty(me.dwID, v.dwID)	and v.nMoveState ~= MOVE_STATE.ON_DEATH then	--����Ƕ��ѱ����ɫ
				local score = v.GetTotalEquipScore()	--��ȡװ��	
				if score == 0 or (nFrame % 80) == 0 then
					PeekOtherPlayer(v.dwID)					--��ȡ��������Ϣ
				end
				score = v.GetTotalEquipScore()	--��ȡװ��	
				local sco = (math.floor(score/1000))/10	--װ��ȡ��
				local dwForceTitle = GetForceTitle(v)
				s_util.AddText(TARGET.PLAYER, v.dwID, 0, 126, 255, 200, sco.."W"..dwForceTitle.."�����ѡ�", 1.3, true)
			end
		end
	end
	
	if (nFrame % 16) == 0 then
		table.sort(Junefocus.FocusList, Junefocus.Sort)	--�������
	end
	
	--����handle
	if Junefocus.bShowFocus == false then
		Junefocus.frameList:Hide()
		Junefocus.frameSelf:SetSize(300, 32)
		Junefocus.frameTotal:SetSize(300, 32)
		Junefocus.frameList:SetSize(300, 32)
	else
		local me = GetClientPlayer()
		local tar = s_util.GetTarget(me)
		for i, p in ipairs(Junefocus.FocusList) do
			if i <= 10 then
				Junefocus.DrawFocus(p[2])
				if tar and p[2] == tar.dwID then
					local hItem = Junefocus.GetHandle(tar.dwID)
					if hItem then hItem:Lookup('Image_Select'):Show() end		--ѡ�б�ʾ
				end
			else
				break
			end
		end
		if #Junefocus.FocusList then
			Station.Lookup("Normal/Junefocus", "Text_Title"):SetText("���ˣ�"..#Junefocus.FocusList.."��װ�֣�"..me.GetTotalEquipScore())
		end
	end
	
	local tar, tarclass = s_util.GetTarget(me)	
	if tar and tarclass == 4 and IsEnemy(me.dwID, tar.dwID) then
		local ttar , ttarclass = s_util.GetTarget(tar)
		local tbuff = s_util.GetBuffInfo(tar)		
		if tbuff then
			for k, v in pairs(tbuff) do
				if v.bCanCancel and Table_BuffIsVisible(v.dwID, v.nLevel) then
					if v.dwSkillSrcID and v.dwSkillSrcID ~= 0 and v.dwSkillSrcID~= tar.dwID then
						GetParty(v.dwSkillSrcID, tar.dwID)
					end
				end
			end
		end
		if ttar and ttarclass == 4 and IsEnemy(me.dwID, ttar.dwID) then 
			local ttbuff = s_util.GetBuffInfo(ttar)
			if ttbuff then
				for k, v in pairs(ttbuff) do
					if v.bCanCancel and Table_BuffIsVisible(v.dwID, v.nLevel) then
						if v.dwSkillSrcID and v.dwSkillSrcID ~= 0 and v.dwSkillSrcID~= ttar.dwID then
							GetParty(v.dwSkillSrcID, ttar.dwID)
						end
					end
				end
			end
		end
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
	local me = GetClientPlayer()
	local player = GetPlayer(dwID)			--�ⷵ�صĶ���ֻ��ID֮��ģ����ֵȵȶ���ûͬ����ȡ���������Լ��޹ص��ˣ�Ҳû����ȡѪ�������ض���255
	if player and player.dwID ~= me.dwID and IsEnemy(me.dwID, player.dwID) then			--�������ң������ң��ǵ���
		s_util.AddText(TARGET.PLAYER, player.dwID, 255, 0, 0, 200, "��", 1.2, true)
	end
end,

--����뿪������1�����������ID
["OnPlayerLeave"] = function(dwID)
	Junefocus.RemoveFocus(dwID)
end,

--ʩ�ż��ܵ��ã� ����������ID�� ����ID�� ���ܵȼ�
["OnCastSkill"] = function(dwID, dwSkillID, dwLevel, targetClass, tidOrx, y, z)
	local player = GetClientPlayer()
	local target, targetClass = s_util.GetTarget(player)
	if not IsPlayer(dwID) or not IsEnemy(player.dwID,dwID) then return end	--���˵��ǵж����
	if tidOrx == player.dwID then
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
		if UpdateSkill(dwID,dwSkillID,18629,12) or UpdateSkill(dwID,dwSkillID,2681,20) or UpdateSkill(dwID,dwSkillID,240,6) or UpdateSkill(dwID,dwSkillID,2645,20) then 
			s_util.SetTimer("tbaofa1")
			s_Output(Table_GetSkillName(dwSkillID, dwLevel))
		end
	end
	--���� 20��
	if UpdateSkill(dwID,dwSkillID,568,20) then
		s_util.SetTimer("tbaofa2")
		s_Output(Table_GetSkillName(dwSkillID, dwLevel))
	end
	--������Ӱ 30��
	if UpdateSkill(dwID,dwSkillID,3112,30) then
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
	Junefocus.FocusList = {}
end,
}

--��������ϵͳ���ض���ı�
return tPlugin
