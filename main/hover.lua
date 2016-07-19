--! hover
--@ terraincheck getselfinfo gettargetpositioninfo
--@ pid spinnercontrol firstrun periodic
-- Hover module
AltitudePID = PID.create(AltitudePIDConfig, CanReverseBlades and -30 or 0, 30)

PerlinOffset = 0

LiftSpinners = SpinnerControl.create(Vector3.up, false, true)

DesiredAltitude = 0

function Hover_FirstRun(I)
   PerlinOffset = 1000.0 * math.random()
end
AddFirstRun(Hover_FirstRun)

function Update_Hover(I)
   if GetTargetPositionInfo(I) then
      DesiredAltitude = DesiredAltitudeCombat

      -- Modify by Evasion, if set
      if Evasion then
         DesiredAltitude = DesiredAltitude + Evasion[1] * (2.0 * Mathf.PerlinNoise(Evasion[2] * I:GetTimeSinceSpawn(), PerlinOffset) - 1.0)
      end
   else
      DesiredAltitude = DesiredAltitudeIdle
   end

   if not AbsoluteAltitude then
      -- Look ahead at the terrain, but don't fly lower than sea level
      local Velocity = I:GetVelocityVector()
      local Height = GetTerrainHeight(I, Velocity, 0, MaxAltitude)
      DesiredAltitude = DesiredAltitude + Height
   end
end

Hover = Periodic.create(UpdateRate, Update_Hover)

function Update(I)
   if not I:IsDocked() and I.AIMode ~= "off" then
      GetSelfInfo(I)

      if FirstRun then FirstRun(I) end

      Hover:Tick(I)

      -- Set spinner speed every update
      local CV = AltitudePID:Control(DesiredAltitude - Altitude)
      LiftSpinners:Classify(I)
      LiftSpinners:SetSpeed(I, CV)
   end
end
