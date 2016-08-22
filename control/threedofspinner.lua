--@ sign pid
-- 3DoF Spinner module (Altitude, Pitch, Roll)
AltitudePID = PID.create(AltitudePIDConfig, -30, 30)
PitchPID = PID.create(PitchPIDConfig, -30, 30)
RollPID = PID.create(RollPIDConfig, -30, 30)

DesiredAltitude = 0
DesiredPitch = 0

LastSpinnerCount = 0
Spinners = {}

function SetAltitude(Alt)
   DesiredAltitude = Alt
end

function AdjustAltitude(Delta)
   DesiredAltitude = Altitude + Delta
end

function SetPitch(Angle)
   DesiredPitch = Angle
end

function ThreeDoFSpinner_ClassifySpinners(I)
   local SpinnerCount = I:GetSpinnerCount()
   if SpinnerCount ~= LastSpinnerCount then
      LastSpinnerCount = SpinnerCount
      Spinners = {}

      for i = 0,SpinnerCount-1 do
         local IsDedi = I:IsSpinnerDedicatedHelispinner(i)
         if IsDedi then -- TODO regular spinner support
            local Info = I:GetSpinnerInfo(i)
            local DotZ = (Info.LocalRotation * Vector3.up).y
            if math.abs(DotZ) > .001 then
               local CoMOffset = Info.LocalPositionRelativeToCom
               local UpSign = DediBladesAlwaysUp and 1 or Sign(DotZ)
               local Spinner = {
                  Index = i,
                  AltitudeSign = UpSign,
                  PitchSign = UpSign * Sign(CoMOffset.z),
                  RollSign = UpSign * Sign(CoMOffset.x),
               }
               table.insert(Spinners, Spinner)
            end
         end
      end
   end
end

function ThreeDoFSpinner_Update(I)
   local AltitudeCV = AltitudePID:Control(DesiredAltitude - Altitude)
   local PitchCV = ControlPitch and PitchPID:Control(DesiredPitch - Pitch) or 0
   local RollCV = ControlRoll and RollPID:Control(-Roll) or 0

   ThreeDoFSpinner_ClassifySpinners(I)

   for index,Info in pairs(Spinners) do
      local Output = AltitudeCV * Info.AltitudeSign + PitchCV * Info.PitchSign + RollCV * Info.RollSign
      Output = math.max(-30, math.min(30, Output))
      I:SetSpinnerContinuousSpeed(Info.Index, Output)
   end
end