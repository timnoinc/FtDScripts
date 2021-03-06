-- CANNON FIRE CONTROL

-- Configurations for each weapon slot.
-- Turret block and cannon firing piece(s) should be on the same weapon slot.
-- There should be no Local Weapon Controller.
-- Lua-fired turrets dont't use failsafes, so set turret constraints
-- appropriately!
CannonConfigs = {
   {
      -- Weapon slot for this cannon group.
      WeaponSlot = 1,
      -- Targeting limits for this cannon group. This is basically what
      -- you would put in the LWC.
      Limits = {
         MinRange = 0,
         MaxRange = 9999,
         MinAltitude = -500,
         MaxAltitude = 9999,
         -- Set to a number to constrain aim point to a minimum altitude
         -- e.g. 0 or -1 for near-waterline.
         -- Set to nil to disable this constraint.
         -- This differs from the limits above in that the above limits
         -- determine when to fire. ConstrainWaterline just moves the
         -- aim point up if it is too low.
         ConstrainWaterline = -1,
      }
   },
   -- Paste more copies of the above here to control more weapon slots.
}
