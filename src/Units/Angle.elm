module Units.Angle exposing (Angle, Radians, radians, inRadians, degrees, inDegrees, turns, inTurns, minutes, inMinutes, seconds, inSeconds, Sign, fromDms, toDms, sin, cos, tan, asin, acos, atan, atan2)

{-| An `Angle` represents an angle in degrees, radians, or turns. It is stored
as a number of radians.

@docs Angle, Radians


## Common units

@docs radians, inRadians, degrees, inDegrees, turns, inTurns


## Minutes and seconds

Angles are sometimes measured in degrees, minutes, and seconds, where 1 minute =
1/60th of a degree and 1 second = 1/60th of a minute.

@docs minutes, inMinutes, seconds, inSeconds

Degrees, minutes and seconds are often used together, so a couple of special
functions are provided to convert to and from combinations of those units.

@docs Sign, fromDms, toDms


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


{-| Construct an angle from a number of minutes.

    Angle.minutes 30
    --> Angle.degrees 0.5

-}
minutes : Float -> Angle.Angle
minutes =
  Angle.minutes


{-| Convert an angle to a number of minutes.

    Angle.degrees 2 |> Angle.inMinutes
    --> 120

-}
inMinutes : Angle.Angle -> Float
inMinutes =
  Angle.inMinutes


{-| Construct an angle from a number of seconds.

    Angle.seconds 120
    --> Angle.minutes 2

-}
seconds : Float -> Angle.Angle
seconds =
  Angle.seconds


{-| Convert an angle to a number of seconds.

    Angle.degrees 0.1 |> Angle.inSeconds
    --> 360

-}
inSeconds : Angle.Angle -> Float
inSeconds =
  Angle.inSeconds


{-| The sign of an angle given in degrees, minutes and seconds.
-}
type alias Sign =
  Angle.Sign


{-| Construct an angle given its sign and its degree, minute and second
components. The signs of `degrees`, `minutes` and `seconds` will be ignored
(their absolute values will be used). Note that only `seconds` may be
fractional! In general `minutes` and `seconds` should each be less than 60, but
this is not enforced.

    Angle.fromDms
        { sign = Angle.Positive
        , degrees = 45
        , minutes = 30
        , seconds = 36
        }
    --> Angle.degrees 45.51

    Angle.fromDms
        { sign = Angle.Negative
        , degrees = 2
        , minutes = 15
        , seconds = 0
        }
    --> Angle.degrees -2.25

-}
fromDms : { sign : Angle.Sign, degrees : Int, minutes : Int, seconds : Float } -> Angle.Angle
fromDms =
  Angle.fromDms


{-| Convert an angle to a number of degrees, minutes and seconds, along with its
sign. The `degrees`, `minutes` and `seconds` values will all be non-negative,
and both `minutes` and `seconds` will be less than 60.

    Angle.toDms (Angle.degrees 1.5)
    --> { sign = Angle.Positive
    --> , degrees = 1
    --> , minutes = 30
    --> , seconds = 0
    --> }

    Angle.toDms (Angle.degrees -0.751)
    --> { sign = Angle.Negative
    --> , degrees = 0
    --> , minutes = 45
    --> , seconds = 3.6
    --> }

You could use this to write a string-conversion function for angles, something
like:

    angleString angle =
        let
            { sign, degrees, minutes, seconds } =
                Angle.toDms angle

            signString =
                case sign of
                    Angle.Positive ->
                        ""

                    Angle.Negative ->
                        "-"
        in
        String.concat
            [ signString
            , String.fromInt degrees
            , "° "
            , String.fromInt minutes
            , "′ "
            , Round.round 3 seconds
            , "″"
            ]

(Here we're using the
[myrho/elm-round](https://package.elm-lang.org/packages/myrho/elm-round/latest/)
package to control the number of decimal places used when displaying the number
of seconds.)

-}
toDms : Angle.Angle -> { sign : Angle.Sign, degrees : Int, minutes : Int, seconds : Float }
toDms =
  Angle.toDms


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