--! hover
--@ terraincheck getselfinfo getvectorangle gettargetpositioninfo
--@ pid spinnercontrol periodic
-- Hover module
AltitudePID = PID.create(AltitudePIDConfig, CanReverseBlades and -30 or 0, 30)

FirstRun = nil
PerlinOffset = 0

LiftSpinners = SpinnerControl.create(Vector3.up, false, true)

DesiredAltitude = 0

function FirstRun(I)
   FirstRun = nil

   PerlinOffset = 1000.0 * math.random()

   TerrainCheckFirstRun(I)
end

function Update_Hover(I)
   if FirstRun then FirstRun(I) end

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
      -- First check CoM's height
      local Height = I:GetTerrainAltitudeForPosition(CoM)
      -- Now check look-ahead values
      local Velocity = I:GetVelocityVector()
      Velocity.y = 0
      local Speed = Velocity.magnitude
      local VelocityAngle = GetVectorAngle(Velocity)
      Height = math.max(Height, GetTerrainHeight(I, VelocityAngle, Speed))
      -- Finally, don't fly lower than sea level
      Height = math.max(Height, 0)
      DesiredAltitude = DesiredAltitude + Height
   end
end

Hover = Periodic.create(UpdateRate, Update_Hover)

function Update(I)
   local CV = 0
   if not I:IsDocked() and I.AIMode ~= "off" then
      GetSelfInfo(I)

      Hover:Tick(I)

      CV = AltitudePID:Control(DesiredAltitude - Altitude)
   end

   -- Set spinner speed every update
   LiftSpinners:Classify(I)
   LiftSpinners:SetSpeed(I, CV)
end
