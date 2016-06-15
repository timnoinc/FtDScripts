-- CONFIGURATION

-- Set to true to control ship when AI set to "on" as well
ActivateWhenOn = false

-- Offset from parent. Note the Y value is ignored.
ParentOffset = Vector3(25, 0, 25)
ParentMaxDistance = 25
-- Throttle when distance from parent is >ParentMaxDistance
ClosingDrive = 1
-- Throttle when within ParentMaxDistance
-- Probably not a good idea for hydrofoil-based subs to stop
LoiterDrive = 0.2

-- Yaw PID controller settings
-- These default values have worked well for me on
-- a variety of ships. YMMV.
-- { 1.0, 0, 0 } is a good (but rough) starting point.
YawPIDValues = { 0.25, 0.0, 0.1 } -- P, I, D

-- Return-to-origin settings
ReturnToOrigin = true
ReturnDrive = 0.5
-- Stops after getting within this distance of origin
-- Should be quite generous, depending on your ship's turning
-- radius.
OriginMaxDistance = 100
