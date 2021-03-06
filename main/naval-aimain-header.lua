-- Meant for any vehicle with yaw + propulsion control.
-- If it is a submarine, depth must be controlled some other means (or
-- see my submarine.lua script for hydrofoil-based vehicles).
-- If it is an airship, see my airship.lua script instead.

-- CONFIGURATION

-- Activate on these AI modes. Valid keys are "off", "on", "combat",
-- "patrol", and "fleetmove".
ActivateWhen = {
--   on = true,
   combat = true,
   fleetmove = true,
}

-- How often to run. At 1, it will run every update. At 10,
-- it will run every 10th update. The lower it is, the more
-- responsive it will be, but it will also take more processing time.
UpdateRate = 4
