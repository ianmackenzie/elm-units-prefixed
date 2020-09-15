module Units.Angle exposing (Angle, Radians, radians, inRadians, degrees, inDegrees, turns, inTurns, sin, cos, tan, asin, acos, atan, atan2)

{-| An `Angle` represents an angle in degrees, radians, or turns. It is stored
as a number of radians.

@docs Angle, Radians


## Conversions

@docs radians, inRadians, degrees, inDegrees, turns, inTurns


## Trigonometry

If you're using `Angle` values instead of plain `Float`s, you'll need to use
these functions instead of [the corresponding ones in core][1].

[1]: https://package.elm-lang.org/packages/elm/core/latest/Basics#trigonometry

@docs sin, cos, tan, asin, acos, atan, atan2

-}

import Angle
import Quantity


{-| -}
type alias Angle =
  Angle.Angle


{-| -}
type alias Radians =
  Angle.Radians


{-| Construct an angle from a number of radians.
-}
radians : Float -> Angle.Angle
radians =
  Angle.radians


{-| Convert an angle to a number of radians.
-}
inRadians : Angle.Angle -> Float
inRadians =
  Angle.inRadians


{-| Construct an angle from a number of degrees.

    Angle.degrees 180
    --> Angle.radians pi

-}
degrees : Float -> Angle.Angle
degrees =
  Angle.degrees


{-| Convert an angle to a number of degrees.

    Angle.turns 2 |> Angle.inDegrees
    --> 720

-}
inDegrees : Angle.Angle -> Float
inDegrees =
  Angle.inDegrees


{-| Construct an angle from a number of turns.

    Angle.turns -0.25
    --> Angle.degrees -90

-}
turns : Float -> Angle.Angle
turns =
  Angle.turns


{-| Convert an angle to a number of turns.

    Angle.radians pi |> Angle.inTurns
    --> 0.5

-}
inTurns : Angle.Angle -> Float
inTurns =
  Angle.inTurns


{-| -}
sin : Angle.Angle -> Float
sin =
  Angle.sin


{-| -}
cos : Angle.Angle -> Float
cos =
  Angle.cos


{-| -}
tan : Angle.Angle -> Float
tan =
  Angle.tan


{-| -}
asin : Float -> Angle.Angle
asin =
  Angle.asin


{-| -}
acos : Float -> Angle.Angle
acos =
  Angle.acos


{-| -}
atan : Float -> Angle.Angle
atan =
  Angle.atan


{-| -}
atan2 : Quantity.Quantity Float units -> Quantity.Quantity Float units -> Angle.Angle
atan2 =
  Angle.atan2