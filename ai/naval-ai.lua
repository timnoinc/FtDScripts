--@ commons planarvector getbearingtopoint evasion sign
--@ debug gettargetpositioninfo avoidance waypointmove
-- Naval AI module
Attacking = true
LastAttackTime = 0

-- Modifies bearing by some amount for evasive maneuvers
function Evade(Evasion, Bearing)
   if AirRaidEvasion and TargetPositionInfo.Position.y >= AirRaidAboveAltitude then
      Evasion = AirRaidEvasion
   end

   return CalculateEvasion(Evasion, Bearing)
end

-- Adjusts heading according to configured behaviors
function AdjustHeadingToTarget(I)
   local __func__ = "AdjustHeadingToTarget"

   local Distance = TargetPositionInfo.GroundDistance
   local Bearing = -TargetPositionInfo.Azimuth
   if Debugging then Debug(I, __func__, "Distance %f Bearing %f", Distance, Bearing) end

   local State,TargetAngle,Drive,Evasion = "escape",EscapeAngle,EscapeDrive,EscapeEvasion
   if Distance > MaxDistance then
      State = "closing"
      TargetAngle = ClosingAngle
      Drive = ClosingDrive
      Evasion = ClosingEvasion

      Attacking = true
   elseif Distance > MinDistance then
      if not AttackRuns or Attacking or (LastAttackTime + ForceAttackTime) <= C:Now() then
         State = "attack"
         TargetAngle = AttackAngle
         Drive = AttackDrive
         Evasion = AttackEvasion

         Attacking = true
         LastAttackTime = C:Now()
      end
   elseif Distance <= MinDistance then
      Attacking = false
   end

   Bearing = Bearing - Sign(Bearing, 1) * TargetAngle
   Bearing = Evade(Evasion, Bearing)
   if Bearing > 180 then Bearing = Bearing - 360 end

   if Debugging then Debug(I, __func__, "State %s Drive %f Bearing %f", State, Drive, Bearing) end

   AdjustHeading(Avoidance(I, Bearing))
   SetThrottle(Drive)
end

function Control_MoveToWaypoint(I, Waypoint, WaypointVelocity)
   MoveToWaypoint(I, Waypoint, function (Bearing) AdjustHeading(Avoidance(I, Bearing)) end, WaypointVelocity)
end

function FormationMove(I)
   local Flagship = I.Fleet.Flagship
   if not I.IsFlagship and Flagship.Valid then
      Control_MoveToWaypoint(I, Flagship.ReferencePosition + Flagship.Rotation * I.IdealFleetPosition, Flagship.Velocity)
   else
      Control_MoveToWaypoint(I, I.Waypoint) -- Waypoint assumed to be stationary
   end
end

function NavalAI_Update(I)
   Control_Reset()

   local AIMode = I.AIMode
   if AIMode ~= "fleetmove" then
      if GetTargetPositionInfo(I) then
         AdjustHeadingToTarget(I)
      elseif ReturnToOrigin then
         FormationMove(I)
      else
         -- Just continue along with avoidance active
         AdjustHeading(Avoidance(I, 0))
      end
   else
      FormationMove(I)
   end
end
