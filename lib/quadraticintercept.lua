--@ quadraticsolver
-- Quadratic intercept formula
function QuadraticIntercept(Position, SpeedSquared, Target, TargetVelocity, DefaultInterceptTime)
   if not DefaultInterceptTime then DefaultInterceptTime = 1 end
   local Offset = Target - Position
   -- Apparently you can apply binomial expansion to vectors
   -- ...as long as it's 2nd degree only
   local a = Vector3.Dot(TargetVelocity, TargetVelocity) - SpeedSquared  -- aka difference of squares of speeds
   local b = 2 * Vector3.Dot(Offset, TargetVelocity)
   local c = Vector3.Dot(Offset, Offset) -- Offset.magnitude squared
   local Solutions = QuadraticSolver(a, b, c)
   local InterceptTime = DefaultInterceptTime
   -- Pick smallest positive intercept time
   if #Solutions == 1 then
      local t = Solutions[1]
      if t > 0 then InterceptTime = t end
   elseif #Solutions == 2 then
      local t1 = Solutions[1]
      local t2 = Solutions[2]
      if t1 > 0 then
         InterceptTime = t1
      elseif t2 > 0 then
         InterceptTime = t2
      end
   end

   return Target + TargetVelocity * InterceptTime,InterceptTime
end
