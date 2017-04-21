--@ commons missiledriver generalmissile weapontypes
-- Multi profile module

GuidanceInfos = {}
-- Weapon slot to index (into GuidanceInfos) mapping
GuidanceInfosIndices = {}

-- Pre-process MissileProfiles, fill out GuidanceInfos
for i = 1,#MissileProfiles do
   local MP = MissileProfiles[i]
   local GuidanceInfo = {
      -- Create GeneralMissile instance
      Controller = GeneralMissile.create(MP.Config),
      -- Set limits
      MinAltitude = MP.Limits.MinAltitude,
      MaxAltitude = MP.Limits.MaxAltitude,
      -- Square ranges
      MinRange = MP.Limits.MinRange * MP.Limits.MinRange,
      MaxRange = MP.Limits.MaxRange * MP.Limits.MaxRange,
      -- Extra info to make things easier
      BlockRange = MP.BlockRange * MP.BlockRange,
      WeaponSlot = MP.FireControl and MP.WeaponSlot or nil,
      TargetSelector = MP.TargetSelector,
   }
   table.insert(GuidanceInfos, GuidanceInfo)
   GuidanceInfosIndices[MP.WeaponSlot] = i
end

MissileControllers = nil

-- Returns index into GuidanceInfos
function SelectGuidance(I, TransceiverIndex)
   if not MissileControllers then
      MissileControllers = {}
      for _,Weapon in pairs(C:WeaponControllers()) do
         if Weapon.Type == MISSILECONTROL then
            table.insert(MissileControllers, Weapon)
         end
      end
   end

   -- Look for closest missile controller within BlockRange
   local BlockInfo = I:GetLuaTransceiverInfo(TransceiverIndex)
   local Closest,SelectedIndex = math.huge,1 -- Default to GuidanceInfos[1]
   for i = 1,#MissileControllers do
      local MC = MissileControllers[i]
      local Index = GuidanceInfosIndices[MC.Slot]
      if Index then
         local Distance = (BlockInfo.Position - MC.Position).sqrMagnitude
         if Distance <= MissileProfiles[Index].BlockRange and Distance < Closest then
            Closest = Distance
            SelectedIndex = Index
         end
      end
   end

   return SelectedIndex
end

-- Main update loop
function MissileMain_Update(I)
   MissileControllers = nil

   MissileDriver_Update(I, GuidanceInfos, SelectGuidance)
end
