-- AIRPLANE CONFIGURATION

-- Control fractions dedicated to spinners for each axis
-- Set to a positive value (usually 1) to use (dediblade)
-- spinners for the given axis.
SpinnerFractions = {
   -- Side-facing spinners
   Yaw = 0,
   -- Upward- and downward-facing spinners
   Pitch = 0,
   Roll = 0,
   -- Forward- and reverse-facing spinners
   Throttle = 0,
}

-- PID values
AirplanePIDConfig = {
   Altitude = {
      Kp = .1,
      Ti = 10,
      Td = .7,
   },
   Yaw = {
      Kp = .3,
      Ti = 10,
      Td = .7,
   },
   Pitch = {
      Kp = .5,
      Ti = 5,
      Td = .1,
   },
   Roll = {
      Kp = .5,
      Ti = 5,
      Td = .1,
   },
}

-- Pitch settings

-- Maximum pitch magnitude up & down relative to horizon. Allows for a
-- series of values based on altitude. Each row should be
-- "{ altitude, maxpitch },"
-- First row should always be altitude 0. Then have increasing
-- altitudes from there. The angles will be smoothly interpolated
-- between each point you provide.
MaxPitch = {
   { 0, 45 },
   -- More altitudes here if you want
}

-- Roll settings

-- Relative bearing necessary for banked turn. Set to nil to disable.
AngleBeforeRoll = nil

-- Minimum altitude necessary for banked turn. Set to negative number
-- to perform a banked turn no matter what (as long as AngleBeforeRoll
-- condition was met).
MinAltitudeForRoll = 100

-- Maximum roll angle to perform during banked turn. 0-180 degrees.
-- Higher performance aircraft should probably aim for something slightly
-- more than 90 (100? 105?) so they don't climb excessivly while banking.
MaxRollAngle = 30

-- To have the roll angle scale based on the magnitude of the relative
-- bearing, set the number here.
-- Calculated as: (roll angle) = ((relative bearing) - AngleBeforeRoll) *
--   RollAngleGain
-- If (roll angle) is greater than MaxRollAngle, MaxRollAngle will be
-- used instead.
-- To always use MaxRollAngle, set RollAngleGain to nil.
RollAngleGain = nil
