--�������
local szPluginName = "����-PVP"

local function UpdateSkill (ID,dwSkillID,SkillID,Dis,bol)
	local wanjia = GetPlayer(ID)
	local target, targetClass = s_util.GetTarget(wanjia)
	local player = GetClientPlayer()
	local distance = s_util.GetDistance(player,wanjia)
	if not bol then
		if SkillID == dwSkillID and distance<=Dis and target.dwID==player.dwID then
			return true
		else
			return false
		end
	else
		if SkillID == dwSkillID and distance<=Dis then
			return true
		else
			return false
		end
	end
end
--�ж϶���B�Ƿ��ڶ���A������������
--����������A,����B,�����(�Ƕ���)
local function Is_B_in_A_FaceDirection(pA, pB, agl)
	local rd = (pA.nFaceDirection%256)*math.pi/128
    local dx = pB.nX - pA.nX;
    local dy = pB.nY - pA.nY;
	local length = math.sqrt(dx*dx+dy*dy);
    return math.acos(dx/length*math.cos(rd)+dy/length*math.sin(rd)) < agl*math.pi/360;
end
------------------------------------------------��������ò����Ϣ�ͻص�����------------------------------------------------
local tPlugin = {
--����ڲ˵�����ʾ�����֡���������
["szName"] = szPluginName,

--������͡�  1(5�˸���)�� 2(10�˸���)�� 3(25�˸���)��4(������)��5(����)����������
["nType"] = 5,

--�󶨵ĵ�ͼID�������Ӧ��ͼ�Զ����á�����ǿ�ѡ�ģ�ע�ⲻҪ�ظ������û�����ã�Ҳ��������Ϸ���ֶ��������
["dwMapID"] = 0,

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
	local player = GetClientPlayer()
	if not player then return end
	--��ǰѪ����ֵ
	local hpRatio = player.nCurrentLife / player.nMaxLife
	--��ȡ��ǰĿ��,δ��սûĿ��ֱ�ӷ���,ս����ûĿ��ѡ������ж�NPC,��������
	local target, targetClass = s_util.GetTarget(player)
	if not player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) )then return end --
	if player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) ) then  
	local MinDistance = 20			--��С����
	local MindwID = 0		    --���NPC��ID
	for i,v in ipairs(GetAllNpc()) do		--��������NPC
		if IsEnemy(player.dwID, v.dwID) and s_util.GetDistance(v, player) < MinDistance and v.nLevel>0 then	--����ǵжԣ����Ҿ����С
			MinDistance = s_util.GetDistance(v, player)            
			MindwID = v.dwID      --�滻�����ID
		end
	end
	if MindwID == 0 then
		return --û�еж�NPC�򷵻�
	else
		SetTarget(TARGET.NPC, MindwID)  --�趨Ŀ��Ϊ����ĵж�
	end
	end
	if target then s_util.TurnTo(target.nX,target.nY) end  --��������
	--���Ŀ��������ֱ�ӷ���
	if target.nMoveState == MOVE_STATE.ON_DEATH then return end
	--��ȡ�Լ���Ŀ��ľ���
	local distance = s_util.GetDistance(player, target)
	--��ȡ�Լ��Ķ�������
	local bPrepareMe, dwSkillIdMe, dwLevelMe, nLeftTimeMe, nActionStateMe =  GetSkillOTActionState(player)
	--��ȡ�Լ���buff��
	local MyBuff = s_util.GetBuffInfo(player)
	--��ȡ�Լ���Ŀ����ɵ�buff��11
	local TargetBuff = s_util.GetBuffInfo(target, true)
	--��ȡĿ��ȫ����buff��
	local TargetBuffAll = s_util.GetBuffInfo(target)
	--�ж�Ŀ�����������û�������������ж϶����ļ���ID����Ӧ����(��ϡ�ӭ����ˡ�����ȵ�)
	local bPrepare, dwSkillId, dwLevel, nLeftTime, nActionState =  GetSkillOTActionState(target)		--���� �Ƿ��ڶ���, ����ID���ȼ���ʣ��ʱ��(��)����������
	--����������
	local CurrentSun=player.nCurrentSunEnergy/100
	local CurrentMoon=player.nCurrentMoonEnergy/100
	--��Ŀ�����>8��ʹ�����⣬����CDʹ�ûùⲽ
	if distance > 8 then if s_util.CastSkill(3977,false) then return end end --����
	if distance > 8 then if s_util.CastSkill(3970,false) then return end end --�ù�
	--�ж�player�Ƿ���target��180������������
	if (Is_B_in_A_FaceDirection(target, player, 180) and s_util.GetTarget(target).dwID ~= player.dwID) or distance > 3.5 then
		s_util.TurnTo(target.nX,target.nY) 
		MoveForwardStart()
	end
	if (not Is_B_in_A_FaceDirection(target, player, 180) or s_util.GetTarget(target).dwID == player.dwID) and distance < 3.5 then 
		MoveForwardStop()
		s_util.TurnTo(target.nX,target.nY)
	end
	--������û��ͬ�ԣ�������
	if player.nSunPowerValue > 0 and (not MyBuff[4937] or MyBuff[4937] and MyBuff[4937].nLevel ~= 2)   then
		if s_util.CastSkill(3969,true) then return end
	end
	--��60���մ�
	if CurrentSun > 59 and CurrentSun <=79 then if s_util.CastSkill(18626,true) then return end end
	--��ħ
	if s_util.CastSkill(3967,false) then return end
	--��0 ��0,�����֣���80 ��40��������
	if (CurrentMoon <= 19 and CurrentSun <= 19 ) or (CurrentSun >79 and CurrentSun <=99 and CurrentMoon >39 and CurrentMoon <=59 ) then 
		if s_util.CastSkill(3959,false) then return end
	end
	--��0 ��20 ����ӯ�У�������
	if CurrentSun <= 19 and CurrentMoon >19 and CurrentMoon <=39 and MyBuff[12487] then 
		if s_util.CastSkill(3959,false) then return end
	end
	--��0 ��40 �ҷ���ӯ�У���ն
	if  CurrentSun <= 19 and CurrentMoon >39 and CurrentMoon <=59 and not MyBuff[12487] then
		if  s_util.CastSkill(3963,false)  then return end 
	end
	--��20 ��20 �ҷ���ӯ�У���ն
	if CurrentSun >19 and CurrentSun <=39 and CurrentMoon >19 and CurrentMoon <=39 and not MyBuff[12487] then 
		if  s_util.CastSkill(3963,false)  then return end 
	end
	--��0 ��20 �ҷ���ӯ�У�������
	if CurrentSun <= 18 and CurrentMoon >19 and CurrentMoon <=39 and not MyBuff[12487] then 
		if  s_util.CastSkill(3962,false)  then return end 
	end
	--��60 ��60 �ҷ���ӯ�У�������
	if CurrentSun >59 and CurrentSun <=79 and CurrentMoon >59 and CurrentMoon <=79 and not MyBuff[12487] then
		if  s_util.CastSkill(3962,false)  then return end 
	end
	--��60 ��20����ҹ
	if  CurrentSun >59 and CurrentSun <=79 and CurrentMoon >19 and CurrentMoon <=39 then
		if s_util.CastSkill(3979,false) then return end
	end
	--��40 ��40����ҹ
	if  CurrentSun >39 and CurrentSun <=59 and CurrentMoon >39 and CurrentMoon <=59 then
		if s_util.CastSkill(3979,false) then return end
	end
	--��80 ��60����ն
	if CurrentSun >79 and CurrentSun <=99 and CurrentMoon >59 and CurrentMoon <=79 then 
		if s_util.CastSkill(3960,false) then return end 
	end
	--���겹����
	if CurrentSun < 100 and CurrentMoon < 100 and player.nSunPowerValue <= 0 and player.nMoonPowerValue <= 0 then
		if s_util.CastSkill(3959,false) then return end
	end
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
	if not IsPlayer(dwID) or not IsEnemy(player.dwID,dwID) then return end	--���˵��ǵж����
	--���� 20�ߣ�ǧ��׹ 20�ߣ��� 15��
	if UpdateSkill(dwID,dwSkillID,13424,20) or UpdateSkill(dwID,dwSkillID,18604,20) or UpdateSkill(dwID,dwSkillID,424,15) then 
		s_util.SetTimer("tkongzhi1")
		s_Output("tkongzhi1")
	end
	--���� 12�ߣ���Ծ��Ԩ 20�ߣ���ս��Ұ 20�ߣ�����ͷ 20�ߣ�����ع� 10�ߣ��ϻ�� 27�ߣ��Ƽ��� 4��
	if UpdateSkill(dwID,dwSkillID,13046,12) or UpdateSkill(dwID,dwSkillID,5262,20) or UpdateSkill(dwID,dwSkillID,5266,20) or UpdateSkill(dwID,dwSkillID,5259,20) or UpdateSkill(dwID,dwSkillID,16479,10) or UpdateSkill(dwID,dwSkillID,428,27) or UpdateSkill(dwID,dwSkillID,426,4) then 
		s_util.SetTimer("tkongzhi2")
		s_Output("tkongzhi2")
	end
	--������Ӱ 30�ߣ�ڤ�¶��� 12�ߣ��������� 20�ߣ������� 6�ߣ����� 20�ߣ����� 20��
	if UpdateSkill(dwID,dwSkillID,3112,30) or UpdateSkill(dwID,dwSkillID,18629,12) or UpdateSkill(dwID,dwSkillID,2681,20) or UpdateSkill(dwID,dwSkillID,260,6) or UpdateSkill(dwID,dwSkillID,2645,20) or UpdateSkill(dwID,dwSkillID,568,20) then 
		s_util.SetTimer("tbaofa1")
		s_Output("tbaofa1")
	end
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
