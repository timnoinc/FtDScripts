-- HYDROFOIL CONFIGURATION

-- Switches to enable/disable control of each axis.
ControlRoll = true
ControlPitch = true

-- PID values for hydrofoils
-- Start with { 1, 0, 0 } and tune from there.
SubControlPIDConfig = {
   Roll = {
      Kp = .01,
      Ti = 10,
      Td = .1,
   },
   Pitch = {
      Kp = .1,
      Ti = 5,
      Td = .125,
   },
   Depth = {
      Kp = 1,
      Ti = 0,
      Td = 0,
   },
}

-- If true then the angles of hydrofoils closer to the Center of Mass
-- (on both X and Z axes) will be scaled up in proportion to the
-- distance of the furthest hydrofoil.
ScaleByCoMOffset = true
