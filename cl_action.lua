--[[------------------------------------------------------------------------

	ActionMenu - v1.0.1
	Created by WolfKnight
	Additional help from lowheartrate, TheStonedTurtle, and Briglair. 

------------------------------------------------------------------------]]--




-- Define the variable used to open/close the menu 
local menuEnabled = false 
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)



-- C O N F I G --
interactionDistance = 3.5 --The radius you have to be in to interact with the vehicle.
lockDistance = 25 --The radius you have to be in to lock your vehicle.

--  V A R I A B L E S --
engineoff = false
saved = false
controlsave_bool = false

-- KASA DENEME












-- E N G I N E --
IsEngineOn = true

function engine()
	local player = GetPlayerPed(-1)
	
	if (IsPedSittingInAnyVehicle(player)) then 
		local vehicle = GetVehiclePedIsIn(player,false)
		
		if IsEngineOn == true then
			IsEngineOn = false
			SetVehicleEngineOn(vehicle,false,false,false)
		else
			IsEngineOn = true
			SetVehicleUndriveable(vehicle,false)
			SetVehicleEngineOn(vehicle,true,false,false)
		end
		
		while (IsEngineOn == false) do
			SetVehicleUndriveable(vehicle,true)
			Citizen.Wait(0)
		end
	end
end

-- T R U N K --
function trunk()
	local player = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsUsing(GetPlayerPed(PlayerId()), false)
			
			local isopen = GetVehicleDoorAngleRatio(vehicle,5)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)

	if (GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(PlayerId())) then
			if distanceToVeh <= interactionDistance then
				if (isopen == 0) then
				SetVehicleDoorOpen(vehicle,5,0,0)
				else
				SetVehicleDoorShut(vehicle,5,0)
				end
			else
				ShowNotification("~r~Aracının Yanında Olmalısın!")
			end
	 end
end

local windowup = true

function camlariAc()
	local player = GetPlayerPed(-1)
    		local vehicle = GetVehiclePedIsUsing(GetPlayerPed(PlayerId()), false)
			
			
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			local camAcikMi1 = IsVehicleWindowIntact(vehicle, 0)
			local camAcikMi2 = IsVehicleWindowIntact(vehicle, 1)
			
	if (GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(PlayerId())) then
		
		if camAcikMi1 or camAcikMi2 then
				
					
				RollDownWindows(vehicle)
				
			else
				RollUpWindow(vehicle, 0)
				RollUpWindow(vehicle, 1)
				RollUpWindow(vehicle, 2)
				RollUpWindow(vehicle, 3)
			end
		end
end

function camlariKapat()
	local player = GetPlayerPed(-1)
    		local vehicle = GetVehiclePedIsUsing(GetPlayerPed(PlayerId()), false)
			
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)
			
		if (GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(PlayerId())) then
			
			solcamE = false
			if distanceToVeh <= interactionDistance then		
				ShowNotification("~r~Kayıtlı Aracının Yanında Olmalısın!")
				end
			else

				RollUpWindow(vehicle, 0)
				RollUpWindow(vehicle, 1)
			end
		end



-- H O O D --
function hood()
	local player = GetPlayerPed(-1)
    	if controlsave_bool == true then
			vehicle = saveVehicle
		else
			vehicle = GetVehiclePedIsIn(player,true)
		end
			
			local isopen = GetVehicleDoorAngleRatio(vehicle,4)
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(vehicle), 1)

				if distanceToVeh <= interactionDistance then

					if (isopen == 0) then
					SetVehicleDoorOpen(vehicle,4,0,0)
					else
					SetVehicleDoorShut(vehicle,4,0)
					end
			else
				ShowNotification("~r~Aracının Yanında Olmalısın!")
			end
end


--NEON
function neon()
	
    	
			local veh = GetVehiclePedIsUsing(GetPlayerPed(PlayerId()), false)
			local ped = GetPlayerPed(PlayerId())
			
			
			
			
			local distanceToVeh = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(veh, 1))
			local acikMi0 = IsVehicleNeonLightEnabled(veh, 0)
			local acikMi1 = IsVehicleNeonLightEnabled(veh, 1)
			local acikMi2 = IsVehicleNeonLightEnabled(veh, 2)
			local acikMi3 = IsVehicleNeonLightEnabled(veh, 3)
			
			if (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(PlayerId())) then
			
				if distanceToVeh <= interactionDistance then
				
					if acikMi0 or acikMi1 or acikMi2 or acikMi3 then

					SetVehicleNeonLightEnabled(veh, 0, false)
					SetVehicleNeonLightEnabled(veh, 1, false)
					SetVehicleNeonLightEnabled(veh, 2, false)
					SetVehicleNeonLightEnabled(veh, 3, false)
					
					else 
					
					SetVehicleNeonLightEnabled(veh, 0, true)
					SetVehicleNeonLightEnabled(veh, 1, true)
					SetVehicleNeonLightEnabled(veh, 2, true)
					SetVehicleNeonLightEnabled(veh, 3, true)
					
					end

			else
				ShowNotification("~r~Aracının Yanında Olmalısın!")
			end
			
		end	
end

--[[------------------------------------------------------------------------
	ActionMenu Toggle
	Calling this function will open or close the ActionMenu. 
------------------------------------------------------------------------]]--
function ToggleActionMenu()
	-- Make the menuEnabled variable not itself 
	-- e.g. not true = false, not false = true 
	menuEnabled = not menuEnabled

	if ( menuEnabled ) then 
		-- Focuses on the NUI, the second parameter toggles the 
		-- onscreen mouse cursor. 
		SetNuiFocus( true, true )

		-- Sends a message to the JavaScript side, telling it to 
		-- open the menu. 
		SendNUIMessage({
			showmenu = true 
		})
	else 
		-- Bring the focus back to the game
		SetNuiFocus( false )

		-- Sends a message to the JavaScript side, telling it to
		-- close the menu.
		SendNUIMessage({
			hidemenu = true 
		})
	end 
end 


--[[------------------------------------------------------------------------
	ActionMenu HTML Callbacks
	This will be called every single time the JavaScript side uses the
	sendData function. The name of the data-action is passed as the parameter
	variable data. 
------------------------------------------------------------------------]]--
function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

RegisterNUICallback( "ButtonClick", function( data, cb ) 
	if ( data == "button1" ) then 
		TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
		
	elseif ( data == "button2" ) then 
		
		local player, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= 3.0 then
			  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
			else
			  ESX.ShowNotification('No players nearby')
			end
		
	elseif ( data == "button3" ) then 
		TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
		
	elseif ( data == "button4" ) then 
		
	local player, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= 3.0 then
			  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
			else
			  ESX.ShowNotification('No players nearby')
			end
		
	elseif ( data == "button5" ) then 
		TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
	elseif ( data == "button6" ) then 
		
		local player, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= 3.0 then
			  TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
			else
			  ESX.ShowNotification('No players nearby')
			end
			
	elseif ( data == "is1" ) then
	
		
			startAnim("random@arrests@busted", "idle_c")
				
	elseif ( data == "is2" ) then
				
			startScenario("world_human_stand_fishing")
			
	elseif ( data == "is3" ) then
	
		startScenario("WORLD_HUMAN_COP_IDLES")
		
				
	elseif ( data == "is4" ) then
	
		startAnim("amb@code_human_police_investigate@idle_b", "idle_f")
				
	elseif ( data == "is5" ) then
	
		startAnim("random@arrests", "generic_radio_chatter")
				
	elseif ( data == "is6" ) then
	
		startScenario("WORLD_HUMAN_CAR_PARK_ATTENDANT")
				
	elseif ( data == "is7" ) then
	
		startScenario("WORLD_HUMAN_BINOCULARS")
				
	elseif ( data == "is8" ) then
	
		startScenario("world_human_gardener_plant")
				
	elseif ( data == "is9" ) then
	
		startAnim("mini@repair", "fixing_a_ped")
				
	elseif ( data == "is10" ) then
				
		startScenario("CODE_HUMAN_MEDIC_KNEEL")
		
	elseif ( data == "is11" ) then
	
		startAnim("oddjobs@taxi@driver", "leanover_idle")
				
	elseif ( data == "is12" ) then
	
		startAnim("oddjobs@taxi@cyi", "std_hand_off_ps_passenger")
				
	elseif ( data == "is13" ) then
	
		startAnim("mp_am_hold_up", "purchase_beerbox_shopkeeper")
				
	elseif ( data == "is14" ) then
	
		startAnim("mini@drinking", "shots_barman_b")
				
	elseif ( data == "is15" ) then
	
		startScenario("WORLD_HUMAN_PAPARAZZI")
				
	elseif ( data == "is16" ) then
	
		startScenario("WORLD_HUMAN_CLIPBOARD")
				
	elseif ( data == "is17" ) then
	
		startScenario("WORLD_HUMAN_HAMMERING")
				
	elseif ( data == "is18" ) then
	
		startScenario("WORLD_HUMAN_BUM_FREEWAY")
				
	elseif ( data == "is19" ) then
	
	
		startScenario("WORLD_HUMAN_HUMAN_STATUE")
		
	elseif ( data == "spor1" ) then
	
	
		startAnim("amb@world_human_muscle_flex@arms_at_side@base", "base")
	
	elseif ( data == "spor2" ) then
	
	
		startAnim("amb@world_human_muscle_free_weights@male@barbell@base", "base")
		
	elseif ( data == "spor3" ) then
	
	
		startAnim("amb@world_human_push_ups@male@base", "base")
	
	elseif ( data == "spor4" ) then
	
	
		startAnim("amb@world_human_sit_ups@male@base", "base")
		
	elseif ( data == "spor5" ) then
	
	
		startAnim("amb@world_human_yoga@male@base", "base_a")
		
	elseif ( data == "eglence1" ) then
	
		startScenario("WORLD_HUMAN_MUSICIAN")
	
	elseif ( data == "eglence2" ) then
	
		startAnim("anim@mp_player_intcelebrationmale@dj", "dj")
	
	elseif ( data == "eglence3" ) then
	
		startScenario("WORLD_HUMAN_DRINKING")
	
	
	elseif ( data == "eglence4" ) then
	
		startScenario("WORLD_HUMAN_PARTYING")
	
	
	elseif ( data == "eglence5" ) then
	
		startAnim("anim@mp_player_intcelebrationmale@air_guitar", "air_guitar")
	
	
	elseif ( data == "eglence6" ) then
	
		startAnim("anim@mp_player_intcelebrationfemale@air_shagging", "air_shagging")
	
	
	elseif ( data == "eglence7" ) then
	
		startAnim("mp_player_int_upperrock", "mp_player_int_rock")
	
	
	elseif ( data == "eglence8" ) then
	
		startAnim("amb@world_human_bum_standing@drunk@idle_a", "idle_a")
	
	
	elseif ( data == "eglence9" ) then
	
		startAnim("oddjobs@taxi@tie", "vomit_outside")
	
	elseif ( data == "davranis1" ) then
	
		startScenario("WORLD_HUMAN_CHEERING")
	
	elseif ( data == "davranis2" ) then
	
		startAnim("mp_action", "thanks_male_06")
	
	elseif ( data == "davranis3" ) then
	
		startAnim("gestures@m@standing@casual", "gesture_point")
	
	elseif ( data == "davranis4" ) then
	
		startAnim("gestures@m@standing@casual", "gesture_come_here_soft")
	
	elseif ( data == "davranis5" ) then
	
		startAnim("gestures@m@standing@casual", "gesture_bring_it_on")
	
	elseif ( data == "davranis6" ) then
	
		startAnim("gestures@m@standing@casual", "gesture_me")
	
	elseif ( data == "davranis7" ) then
	
		startAnim("anim@am_hold_up@male", "shoplift_high")
	
	elseif ( data == "davranis8" ) then
	
		startAnim("anim@mp_player_intcelebrationmale@face_palm", "face_palm")
	
	elseif ( data == "davranis9" ) then
	
		startAnim("gestures@m@standing@casual", "gesture_easy_now")
	
	elseif ( data == "davranis10" ) then
	
		startAnim("oddjobs@assassinate@multi@", "react_big_variations_a")
	
	elseif ( data == "davranis11" ) then
	
		startAnim("amb@code_human_cower_stand@male@react_cowering", "base_right")
	
	elseif ( data == "davranis12" ) then
	
		startAnim("anim@deathmatch_intros@unarmed", "intro_male_unarmed_e")
	
	elseif ( data == "davranis13" ) then
	
		startAnim("gestures@m@standing@casual", "gesture_damn")
	
	elseif ( data == "davranis14" ) then
	
		startAnim("mp_ped_interaction", "kisses_guy_a")
	
	elseif ( data == "davranis15" ) then
	
		startAnim("mp_player_int_upperfinger", "mp_player_int_finger_01_enter")
	
	elseif ( data == "davranis16" ) then
	
		startAnim("mp_suicide", "pistol")
		
	elseif ( data == "genel1" ) then
	
		startAnim("amb@world_human_aa_coffee@idle_a", "idle_a")
	
	elseif ( data == "genel2" ) then
	
		startAnim("anim@heists@prison_heistunfinished_biztarget_idle", "target_idle")
	
	elseif ( data == "genel3" ) then
	
		startScenario("world_human_leaning")
	
	elseif ( data == "genel4" ) then
	
		startScenario("world_human_picnic")
	
	elseif ( data == "genel5" ) then
	
		startScenario("WORLD_HUMAN_SUNBATHE_BACK")
	
	elseif ( data == "genel6" ) then
	
		startScenario("WORLD_HUMAN_SUNBATHE")
	
	elseif ( data == "genel7" ) then
	
		startScenario("world_human_bum_slumped")
	
	elseif ( data == "genel8" ) then
	
		startScenario("world_human_maid_clean")
	
	elseif ( data == "genel9" ) then
	
		startScenario("PROP_HUMAN_BBQ")
	
	elseif ( data == "genel10" ) then
	
		startAnim("mini@prostitutes@sexlow_veh", "low_car_bj_to_prop_female")
	
	elseif ( data == "genel11" ) then
	
		startScenario("world_human_tourist_mobile")
	
	elseif ( data == "genel12" ) then
	
		startAnim("mini@safe_cracking", "idle_base")

	elseif ( data == "digerleri1" ) then
	
		startAnim("gestures@m@standing@casual", "gesture_hello")
		
	elseif ( data == "digerleri2" ) then
	
		startAnim("mp_common", "givetake1_a")
			
	elseif ( data == "digerleri3" ) then
	
		startAnim("mp_ped_interaction", "handshake_guy_a")
			
	elseif ( data == "digerleri4" ) then
	
		startAnim("mp_ped_interaction", "hugs_guy_a")
			
	elseif ( data == "digerleri5" ) then
	
		startAnim("mp_player_int_uppersalute", "mp_player_int_salute")
			
	elseif ( data == "digerleri6" ) then
	
		startAnim("oddjobs@towing", "m_blow_job_loop")
			
	elseif ( data == "digerleri7" ) then
	
		startAnim("oddjobs@towing", "f_blow_job_loop")
			
	elseif ( data == "digerleri8" ) then
	
		startAnim("mini@prostitutes@sexlow_veh", "low_car_sex_loop_player")
			
	elseif ( data == "digerleri9" ) then
	
		startAnim("mini@prostitutes@sexlow_veh", "low_car_sex_loop_female")
			
	elseif ( data == "digerleri10" ) then
	
		startAnim("mp_player_int_uppergrab_crotch", "mp_player_int_grab_crotch")
			
	elseif ( data == "digerleri11" ) then
	
		startAnim("mp_player_int_upperwank", "mp_player_int_wank_01")
			
	elseif ( data == "digerleri12" ) then
	
		startAnim("mini@strip_club@idles@stripper", "stripper_idle_02")
			
	elseif ( data == "digerleri13" ) then
	
		startScenario("WORLD_HUMAN_PROSTITUTE_HIGH_CLASS")
	
	elseif ( data == "digerleri14" ) then
		
		startAnim("mini@strip_club@backroom@", "stripper_b_backroom_idle_b")		
		
	elseif ( data == "digerleri15" ) then
	
		startAnim("mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f")	
		
	elseif ( data == "digerleri16" ) then
	
		startAnim("mini@strip_club@private_dance@part2", "priv_dance_p2")
				
	elseif ( data == "digerleri17" ) then
		
		startAnim("mini@strip_club@private_dance@part3", "priv_dance_p3")		
		
		
	elseif ( data == "danslar1" ) then
	
		startAnim("anim@amb@nightclub@dancers@crowddance_single_props@hi_intensity", "hi_dance_prop_13_v1_male^6")
	
	elseif ( data == "danslar2" ) then
	
		startAnim("anim@amb@nightclub@mini@dance@dance_solo@male@var_a@", "med_center_up")
	
	elseif ( data == "danslar3" ) then
	
		startAnim("anim@amb@nightclub@dancers@crowddance_groups@low_intensity", "li_dance_crowd_17_v1_male^6")
	
	elseif ( data == "danslar4" ) then
		
		startAnim("anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", "trans_dance_facedj_mi_to_li_09_v1_male^6")

	elseif ( data == "danslar5" ) then
	
		startAnim("mini@strip_club@idles@dj@idle_04", "idle_04")
	
	elseif ( data == "danslar6" ) then
	
		startAnim("special_ped@mountain_dancer@monologue_4@monologue_4a", "mnt_dnc_verse")
	
	elseif ( data == "danslar7" ) then
	
		startAnim("anim@amb@nightclub@dancers@crowddance_single_props@", "hi_dance_prop_09_v1_male^6")
	
	elseif ( data == "danslar8" ) then
		
		startAnim("anim@amb@nightclub@dancers@tale_of_us_entourage@", "mi_dance_prop_13_v2_male^4")

	elseif ( data == "danslar9" ) then
	
		startAnim("misschinese2_crystalmazemcs1_cs", "dance_loop_tao")
	
	elseif ( data == "danslar10" ) then
	
		startAnim("anim@mp_player_intcelebrationfemale@uncle_disco", "uncle_disco")
		
	elseif ( data == "danslar11" ) then
	
		startAnim("anim@mp_player_intcelebrationmale@cats_cradle", "cats_cradle")
	
	elseif ( data == "danslar12" ) then
		
		startAnim("anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", "high_center")

	elseif ( data == "danslar13" ) then
	
		startAnim("anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", "high_center")
	
	elseif ( data == "danslar14" ) then
	
		startAnim("anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", "hi_dance_crowd_09_v1_female^6")
	
	elseif ( data == "danslar15" ) then
	
		startAnim("anim@mp_player_intupperuncle_disco", "idle_a")
	
	elseif ( data == "danslar16" ) then
		
		startAnim("anim@amb@nightclub@dancers@black_madonna_entourage@", "li_dance_facedj_15_v2_male^2")
	
	elseif ( data == "danslar17" ) then
	
		startAnim("anim@amb@nightclub@dancers@crowddance_facedj@", "hi_dance_facedj_09_v1_male^1")
	
	elseif ( data == "danslar18" ) then
	
		startAnim("anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity", "trans_dance_crowd_hi_to_li__07_v1_male^6")
	
	elseif ( data == "danslar19" ) then
	
		startAnim("anim@amb@nightclub@dancers@black_madonna_entourage@", "li_dance_facedj_11_v1_male^1")
	
	elseif ( data == "danslar20" ) then
		
		startAnim("timetable@tracy@ig_5@idle_b", "idle_e")
		

	
	elseif ( data == "yuruyus1" ) then
	
		startAttitude("move_m@confident", "move_m@confident")
	
	elseif ( data == "yuruyus2" ) then
	
		startAttitude("move_f@heels@c", "move_f@heels@c")
	
	elseif ( data == "yuruyus3" ) then
	
		startAttitude("move_m@depressed@a", "move_m@depressed@a")
	
	elseif ( data == "yuruyus4" ) then
	
		startAttitude("move_f@depressed@a", "move_f@depressed@a")
	
	elseif ( data == "yuruyus5" ) then
	
		startAttitude("move_m@business@a", "move_m@business@a")
	
	elseif ( data == "yuruyus6" ) then
	
		startAttitude("move_m@brave@a", "move_m@brave@a")
	
	elseif ( data == "yuruyus7" ) then
	
		startAttitude("move_m@casual@a", "move_m@casual@a")
	
	elseif ( data == "yuruyus8" ) then
	
		startAttitude("move_m@fat@a", "move_m@fat@a")
	
	elseif ( data == "yuruyus9" ) then
	
		startAttitude("move_m@hipster@a", "move_m@hipster@a")
	
	elseif ( data == "yuruyus10" ) then
	
		startAttitude("move_m@injured", "move_m@injured")
	
	elseif ( data == "yuruyus11" ) then
	
		startAttitude("move_m@hurry@a", "move_m@hurry@a")
	
	elseif ( data == "yuruyus12" ) then
	
		startAttitude("move_m@hobo@a", "move_m@hobo@a")
	
	elseif ( data == "yuruyus13" ) then
	
		startAttitude("move_m@sad@a", "move_m@sad@a")
	
	elseif ( data == "yuruyus14" ) then
	
		startAttitude("move_m@muscle@a", "move_m@muscle@a")
	
	elseif ( data == "yuruyus15" ) then
	
		startAttitude("move_m@shocked@a", "move_m@shocked@a")
	
	elseif ( data == "yuruyus16" ) then
		
		startAttitude("move_m@shadyped@a", "move_m@shadyped@a")
		
	elseif ( data == "yuruyus17" ) then
			
		startAttitude("move_m@buzzed", "move_m@buzzed")	
			
	elseif ( data == "yuruyus18" ) then
	
		startAttitude("move_m@hurry_butch@a", "move_m@hurry_butch@a")
	
	elseif ( data == "yuruyus19" ) then
		
		startAttitude("move_m@money", "move_m@money")
	
	elseif ( data == "yuruyus20" ) then
	
		startAttitude("move_m@quick", "move_m@quick")
	
	elseif ( data == "yuruyus21" ) then
	
		startAttitude("move_f@maneater", "move_f@maneater")
	
	elseif ( data == "yuruyus22" ) then
		
		startAttitude("move_f@sassy", "move_f@sassy")
	
	elseif ( data == "yuruyus23" ) then
	
		startAttitude("move_f@arrogant@a", "move_f@arrogant@a")	
	
	elseif ( data == "arababuton1" ) then
	
		engine()
	
	elseif ( data == "arababuton2" ) then
	
		camlariAc()
	
	elseif ( data == "arababuton3" ) then
	
		trunk()
	
	elseif ( data == "arababuton4" ) then
	
		hood()
		
	elseif ( data == "arababuton5" ) then
		
		neon()
	
	elseif ( data == "testbutonu1" ) then
	
		ClearPedTasks(PlayerPedId())
	
	
	elseif ( data == "exit" ) then 
		-- We toggle the ActionMenu and return here, otherwise the function 
		-- call below would be executed too, which would just open the menu again 
		ToggleActionMenu()
		return 
	end 

	-- This will only be called if any button other than the exit button is pressed
	ToggleActionMenu()
end )



--[[------------------------------------------------------------------------
	ActionMenu Control and Input Blocking 
	This is the main while loop that opens the ActionMenu on keypress. It 
	uses the input blocking found in the ES Banking resource, credits to 
	the authors.
------------------------------------------------------------------------]]--
Citizen.CreateThread( function()
	-- This is just in case the resources restarted whilst the NUI is focused. 
	SetNuiFocus( false )

	while true do 
		-- Control ID 20 is the 'Z' key by default 
		-- Use https://wiki.fivem.net/wiki/Controls to find a different key 
		if ( IsControlJustPressed( 1, 170 ) ) then 
			ToggleActionMenu()
		end 

	    if ( menuEnabled ) then
            local ped = GetPlayerPed( -1 )	

            DisableControlAction( 0, 1, true ) -- LookLeftRight
            DisableControlAction( 0, 2, true ) -- LookUpDown
            DisableControlAction( 0, 24, true ) -- Attack
            DisablePlayerFiring( ped, true ) -- Disable weapon firing
            DisableControlAction( 0, 142, true ) -- MeleeAttackAlternate
            DisableControlAction( 0, 106, true ) -- VehicleMouseControlOverride
        end

		Citizen.Wait( 0 )
	end 
end )
