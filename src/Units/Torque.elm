module Units.Torque exposing (Torque, NewtonMeters, newtonMeters, inNewtonMeters, poundFeet, inPoundFeet)

{-| Torque is the rotational analogue of linear force. It is also referred to as the moment of force
(also abbreviated to moment). It describes the rate of change of angular momentum that would be
imparted to an isolated body.

@docs Torque, NewtonMeters


## Metric

@docs newtonMeters, inNewtonMeters


## Imperial

@docs poundFeet, inPoundFeet

-}

import Force
import Length
import Quantity
import Torque


{-| -}
type alias Torque =
  Torque.Torque


{-| NB: You may notice that the type here is exactly the same as for `Energy.Joules`.

This means the type checker will not help you in distinguishing between these units.

-}
type alias NewtonMeters =
  Torque.NewtonMeters


{-| Construct a torque value from a number of newton-meters.
-}
newtonMeters : Float -> Torque.Torque
newtonMeters =
  Torque.newtonMeters


{-| Convert a torque value to a number of newton-meters.
-}
inNewtonMeters : Torque.Torque -> Float
inNewtonMeters =
  Torque.inNewtonMeters


{-| Construct a torque value from a number of pound-feet (sometimes called foot-pounds).
-}
poundFeet : Float -> Torque.Torque
poundFeet =
  Torque.poundFeet


{-| Convert a torque value to a number of pound-feet (sometimes called foot-pounds).
-}
inPoundFeet : Torque.Torque -> Float
inPoundFeet =
  Torque.inPoundFeet