module Units.Quantity exposing (Quantity, Squared, Rate, zero, infinity, positiveInfinity, negativeInfinity, lessThan, greaterThan, compare, equalWithin, max, min, isNaN, isInfinite, negate, plus, minus, product, ratio, scaleBy, divideBy, abs, clamp, squared, sqrt, round, floor, ceiling, truncate, toFloatQuantity, sum, minimum, maximum, sort, per, times, at, at_, inverse, Unitless, int, toInt, float, toFloat)

{-|

@docs Quantity


# Unit types

The `Squared` and `Rate` units types allow you to build up and work with
composite units in a fairly flexible way.

@docs Squared, Rate


# Constants

@docs zero, infinity, positiveInfinity, negativeInfinity


# Comparison

@docs lessThan, greaterThan, compare, equalWithin, max, min, isNaN, isInfinite


# Arithmetic

@docs negate, plus, minus, product, ratio, scaleBy, divideBy, abs, clamp, squared, sqrt


# `Int`/`Float` conversion

These functions only really make sense for quantities in units like pixels,
cents or game tiles where an `Int` number of units is meaningful. For quantities
like `Length` or `Duration`, it doesn't really make sense to round to an `Int`
value since the underyling base unit is pretty arbitrary - should `round`ing a
`Duration` give you an `Int` number of seconds, milliseconds, or something else?

@docs round, floor, ceiling, truncate, toFloatQuantity


# List functions

These functions act just like the corresponding functions in the built-in `List`
module. They're necessary because the built-in `List.sum` only supports `List
Int` and `List Float`, and `minimum`/`maximum`/`sort` only support built-in
comparable types like `Int`, `Float`, `String` and tuples.

@docs sum, minimum, maximum, sort


# Working with rates

@docs per, times, at, at_, inverse


# Unitless quantities

It is sometimes useful to be able to represent _unitless_ quantities, especially
when working with generic code (in most other cases, it is likely simpler and
easier to just use `Int` or `Float` values directly). All the conversions in
this section simply wrap or unwrap a `Float` or `Int` value into a `Quantity`
value, and so should get compiled away entirely when using `elm make
--optimize`.

@docs Unitless, int, toInt, float, toFloat

-}

import Quantity


{-| A `Quantity` is effectively a `number` (an `Int` or `Float`) tagged with a
`units` type. So a

    Quantity Float Meters

is a `Float` number of `Meters` and a

    Quantity Int Pixels

is an `Int` number of `Pixels`. When compiling with `elm make --optimize` the
`Quantity` wrapper type will be compiled away, so the runtime performance should
be comparable to using a raw `Float` or `Int`.

-}
type alias Quantity number units =
  Quantity.Quantity number units


{-| Represents a units type that is the square of some other units type; for
example, `Meters` is one units type (the units type of a `Length`) and `Squared
Meters` is another (the units type of an `Area`). This is useful because some
functions in this module (specifically [`product`](#product),
[`squared`](#squared), and [`sqrt`](#sqrt)) "know" about the `Squared` type and
how to work with it.
-}
type alias Squared units =
  Quantity.Squared units


{-| Represents the units type of a rate or quotient such as a speed (`Rate
Meters Seconds`) or a pressure (`Rate Newtons SquareMeters`). As with `Squared`,
there are several functions that "know" about the `Rate` units type and how to
work with it - see [Working with rates](#working-with-rates) for details.
-}
type alias Rate dependentUnits independentUnits =
  Quantity.Rate dependentUnits independentUnits


{-| A generic zero value. This can be treated as either an `Int` or `Float`
quantity in any units type, similar to how `Nothing` can be treated as any kind
of `Maybe` type and `[]` can be treated as any kind of `List`.
-}
zero : Quantity.Quantity number units
zero =
  Quantity.zero


{-| Alias for `positiveInfinity`.
-}
infinity : Quantity.Quantity Float units
infinity =
  Quantity.infinity


{-| A generic positive infinity value.
-}
positiveInfinity : Quantity.Quantity Float units
positiveInfinity =
  Quantity.positiveInfinity


{-| A generic negative infinity value.
-}
negativeInfinity : Quantity.Quantity Float units
negativeInfinity =
  Quantity.negativeInfinity


{-| Check if one quantity is less than another. Note the [argument order](/#argument-order)!

    oneMeter =
        Length.meters 1

    Length.feet 1 |> Quantity.lessThan oneMeter
    --> True

    -- Same as:
    Quantity.lessThan oneMeter (Length.feet 1)
    --> True

    List.filter (Quantity.lessThan oneMeter)
        [ Length.feet 1
        , Length.parsecs 1
        , Length.yards 1
        , Length.lightYears 1
        ]
    --> [ Length.feet 1, Length.yards 1 ]

-}
lessThan : Quantity.Quantity number units -> Quantity.Quantity number units -> Bool
lessThan =
  Quantity.lessThan


{-| Check if one quantity is greater than another. Note the [argument order](/#argument-order)!

    oneMeter =
        Length.meters 1

    Length.feet 1 |> Quantity.greaterThan oneMeter
    --> False

    -- Same as:
    Quantity.greaterThan oneMeter (Length.feet 1)
    --> False

    List.filter (Quantity.greaterThan oneMeter)
        [ Length.feet 1
        , Length.parsecs 1
        , Length.yards 1
        , Length.lightYears 1
        ]
    --> [ Length.parsecs 1, Length.lightYears 1 ]

-}
greaterThan : Quantity.Quantity number units -> Quantity.Quantity number units -> Bool
greaterThan =
  Quantity.greaterThan


{-| Compare two quantities, returning an [`Order`](https://package.elm-lang.org/packages/elm/core/latest/Basics#Order)
value indicating whether the first is less than, equal to or greater than the
second.

    Quantity.compare (Duration.minutes 90) (Duration.hours 1)
    --> GT

    Quantity.compare (Duration.minutes 60) (Duration.hours 1)
    --> EQ

-}
compare : Quantity.Quantity number units -> Quantity.Quantity number units -> Order
compare =
  Quantity.compare


{-| Check if two quantities are equal within a given absolute tolerance. The
given tolerance must be greater than or equal to zero - if it is negative, then
the result will always be false.

    -- 3 feet is 91.44 centimeters or 0.9144 meters

    Quantity.equalWithin (Length.centimeters 10)
        (Length.meters 1)
        (Length.feet 3)
    --> True

    Quantity.equalWithin (Length.centimeters 5)
        (Length.meters 1)
        (Length.feet 3)
    --> False

-}
equalWithin : Quantity.Quantity number units -> Quantity.Quantity number units -> Quantity.Quantity number units -> Bool
equalWithin =
  Quantity.equalWithin


{-| Find the maximum of two quantities.

    Quantity.max (Duration.hours 2) (Duration.minutes 100)
    --> Duration.hours 2

-}
max : Quantity.Quantity number units -> Quantity.Quantity number units -> Quantity.Quantity number units
max =
  Quantity.max


{-| Find the minimum of two quantities.

    Quantity.min (Duration.hours 2) (Duration.minutes 100)
    --> Duration.minutes 100

-}
min : Quantity.Quantity number units -> Quantity.Quantity number units -> Quantity.Quantity number units
min =
  Quantity.min


{-| Check if a quantity's underlying value is NaN (not-a-number).

    Quantity.isNan (Quantity.sqrt (Area.squareMeters -4))
    --> True

    Quantity.isNan (Quantity.sqrt (Area.squareMeters 4))
    --> False

-}
isNaN : Quantity.Quantity Float units -> Bool
isNaN =
  Quantity.isNaN


{-| Check if a quantity is positive or negative infinity.

    Quantity.isInfinite
        (Length.meters 1
            |> Quantity.per (Duration.seconds 0)
        )
    --> True

    Quantity.isInfinite Quantity.negativeInfinity
    --> True

-}
isInfinite : Quantity.Quantity Float units -> Bool
isInfinite =
  Quantity.isInfinite


{-| Negate a quantity!

    Quantity.negate (Length.millimeters 10)
    --> Length.millimeters -10

-}
negate : Quantity.Quantity number units -> Quantity.Quantity number units
negate =
  Quantity.negate


{-| Add two quantities.

    Length.meters 1 |> Quantity.plus (Length.centimeters 5)
    --> Length.centimeters 105

-}
plus : Quantity.Quantity number units -> Quantity.Quantity number units -> Quantity.Quantity number units
plus =
  Quantity.plus


{-| Subtract one quantity from another. Note the [argument order](/#argument-order)!

    fifteenMinutes =
        Duration.minutes 15

    Duration.hours 1 |> Quantity.minus fifteenMinutes
    --> Duration.minutes 45

    -- Same as:
    Quantity.minus fifteenMinutes (Duration.hours 1)
    --> Duration.minutes 45

    List.map (Quantity.minus fifteenMinutes)
        [ Duration.hours 1
        , Duration.hours 2
        , Duration.minutes 30
        ]
    --> [ Duration.minutes 45
    --> , Duration.minutes 105
    --> , Duration.minutes 15
    --> ]

-}
minus : Quantity.Quantity number units -> Quantity.Quantity number units -> Quantity.Quantity number units
minus =
  Quantity.minus


{-| Multiply two quantities with the same `units` together, resulting in a
quantity in `Squared units`.

This works for any units type (which is useful when used with [`sqrt`](#sqrt)!)
but one special case is worth pointing out. The units type of an [`Area`](Area)
is `SquareMeters`, which is a type alias for `Squared Meters`. This means that
the product of two `Length`s does in fact give you an `Area`:

    Quantity.product
        (Length.meters 2)
        (Length.centimeters 40)
    --> Area.squareMeters 0.8

    -- This is the definition of an acre, I kid you not 😈
    Quantity.product (Length.feet 66) (Length.feet 660)
    --> Area.acres 1

Note that there are [other forms of multiplication](/#multiplication)!

-}
product : Quantity.Quantity number units -> Quantity.Quantity number units -> Quantity.Quantity number (Quantity.Squared units)
product =
  Quantity.product


{-| Find the ratio of two quantities with the same units.

    Quantity.ratio (Length.miles 1) (Length.yards 1)
    --> 1760

-}
ratio : Quantity.Quantity Float units -> Quantity.Quantity Float units -> Float
ratio =
  Quantity.ratio


{-| Multiply a `Quantity` by a `number`.

    Quantity.scaleBy 1.5 (Duration.hours 1)
    --> Duration.minutes 90

Note that there are [other forms of multiplication](/#multiplication)!

-}
scaleBy : number -> Quantity.Quantity number units -> Quantity.Quantity number units
scaleBy =
  Quantity.scaleBy


{-| Divide a `Quantity` by a `Float`.

    Quantity.divideBy 2 (Duration.hours 1)
    --> Duration.minutes 30

-}
divideBy : Float -> Quantity.Quantity Float units -> Quantity.Quantity Float units
divideBy =
  Quantity.divideBy


{-| Get the absolute value of a quantity.

    Quantity.abs (Duration.milliseconds -10)
    --> Duration.milliseconds 10

-}
abs : Quantity.Quantity number units -> Quantity.Quantity number units
abs =
  Quantity.abs


{-| Given a lower and upper bound, clamp a given quantity to within those
bounds. Say you wanted to clamp an angle to be between +/-30 degrees:

    lowerBound =
        Angle.degrees -30

    upperBound =
        Angle.degrees 30

    Quantity.clamp lowerBound upperBound (Angle.degrees 5)
    --> Angle.degrees 5

    -- One radian is approximately 57 degrees
    Quantity.clamp lowerBound upperBound (Angle.radians 1)
    --> Angle.degrees 30

    Quantity.clamp lowerBound upperBound (Angle.turns -0.5)
    --> Angle.degrees -30

-}
clamp : Quantity.Quantity number units -> Quantity.Quantity number units -> Quantity.Quantity number units -> Quantity.Quantity number units
clamp =
  Quantity.clamp


{-| Square a quantity with some `units`, resulting in a new quantity in
`Squared units`:

    Quantity.squared (Length.meters 5)
    --> Area.squareMeters 25

(See the documentation of [`product`](#product) for an explanation of why a
squared `Length` does in fact give you an `Area`.)

-}
squared : Quantity.Quantity number units -> Quantity.Quantity number (Quantity.Squared units)
squared =
  Quantity.squared


{-| Take a quantity in `Squared units` and return the square root of that
quantity in plain `units`:

    Quantity.sqrt (Area.hectares 1)
    --> Length.meters 100

Getting fancier, you could write a 2D hypotenuse (magnitude) function that
worked on _any_ quantity type (length, speed, force...) as

    hypotenuse :
        Quantity Float units
        -> Quantity Float units
        -> Quantity Float units
    hypotenuse x y =
        Quantity.sqrt <|
            Quantity.sum
                [ Quantity.squared x
                , Quantity.squared y
                ]

This works because:

  - The `x` and `y` arguments are both in `units`
  - So each list item is in `Squared units`
  - So the sum is also in `Squared units`
  - And calling `sqrt` on something in `Squared units` returns a value back in
    `units`

-}
sqrt : Quantity.Quantity Float (Quantity.Squared units) -> Quantity.Quantity Float units
sqrt =
  Quantity.sqrt


{-| Round a `Float`-valued quantity to the nearest `Int`.

    Quantity.round (Pixels.pixels 3.5)
    --> Pixels.pixels 4

-}
round : Quantity.Quantity Float units -> Quantity.Quantity Int units
round =
  Quantity.round


{-| Round a `Float`-valued quantity down to the nearest `Int`.

    Quantity.floor (Pixels.pixels 2.9)
    --> Pixels.pixels 2

    Quantity.floor (Pixels.pixels -2.1)
    --> Pixels.pixels -3

-}
floor : Quantity.Quantity Float units -> Quantity.Quantity Int units
floor =
  Quantity.floor


{-| Round a `Float`-valued quantity up to the nearest `Int`.

    Quantity.ceiling (Pixels.pixels 1.2)
    --> Pixels.pixels 2

    Quantity.ceiling (Pixels.pixels -2.1)
    --> Pixels.pixels -2

-}
ceiling : Quantity.Quantity Float units -> Quantity.Quantity Int units
ceiling =
  Quantity.ceiling


{-| Round a `Float`-valued quantity towards zero.

    Quantity.truncate (Pixels.pixels -2.8)
    --> Pixels.pixels -2

-}
truncate : Quantity.Quantity Float units -> Quantity.Quantity Int units
truncate =
  Quantity.truncate


{-| Convert a `Quantity Int units` to a `Quantity Float units` with the same
value. Useful when you have an `Int`-valued quantity and want to divide it by
something, multiply it by a fractional value etc.
-}
toFloatQuantity : Quantity.Quantity Int units -> Quantity.Quantity Float units
toFloatQuantity =
  Quantity.toFloatQuantity


{-| Find the sum of a list of quanties.

    Quantity.sum
        [ Length.meters 1
        , Length.centimeters 2
        , Length.millimeters 3
        ]
    --> Length.meters 1.023

    Quantity.sum []
    --> Quantity.zero

-}
sum : List (Quantity.Quantity number units) -> Quantity.Quantity number units
sum =
  Quantity.sum


{-| Find the minimum value in a list of quantities. Returns `Nothing` if the
list is empty.

    Quantity.minimum
        [ Mass.kilograms 1
        , Mass.pounds 2
        , Mass.tonnes 3
        ]
    --> Just (Mass.pounds 2)

-}
minimum : List (Quantity.Quantity number units) -> Maybe (Quantity.Quantity number units)
minimum =
  Quantity.minimum


{-| Find the maximum value in a list of quantities. Returns `Nothing` if the
list is empty.

    Quantity.maximum
        [ Mass.kilograms 1
        , Mass.pounds 2
        , Mass.tonnes 3
        ]
    --> Just (Mass.tonnes 3)

-}
maximum : List (Quantity.Quantity number units) -> Maybe (Quantity.Quantity number units)
maximum =
  Quantity.maximum


{-| Sort a list of quantities.

    Quantity.sort
        [ Mass.kilograms 1
        , Mass.pounds 2
        , Mass.tonnes 3
        ]
    --> [ Mass.pounds 2
    --> , Mass.kilograms 1
    --> , Mass.tonnes 3
    --> ]

-}
sort : List (Quantity.Quantity number units) -> List (Quantity.Quantity number units)
sort =
  Quantity.sort


{-| Construct a rate of change by dividing a dependent quantity (numerator) by
an independent quantity (denominator):

    distance =
        Length.miles 1

    time =
        Duration.minutes 1

    speed =
        distance |> Quantity.per time

    speed |> Speed.inMilesPerHour
    --> 60

Note that we could directly use our rate of change value as a `Speed`! That is
because many built-in quantity types are defined as rates of change, for
example:

  - `Speed` is `Length` per `Duration`
  - `Acceleration` is `Speed` per `Duration`
  - `Pressure` is `Force` per `Area`
  - `Power` is `Energy` per `Duration`
  - `Force` is `Energy` per `Length`
  - `Current` is `Charge` per `Duration`
  - `Voltage` is `Power` per `Current`
  - `Resistance` is `Voltage` per `Current`

-}
per : Quantity.Quantity Float independentUnits -> Quantity.Quantity Float dependentUnits -> Quantity.Quantity Float (Quantity.Rate dependentUnits independentUnits)
per =
  Quantity.per


{-| Multiply a rate of change by an independent quantity (the denominator in
the rate) to get a total value:

    -- Pressure is force per area
    pressure =
        Pressure.kilopascals 10

    area =
        Area.squareMeters 3

    pressure |> Quantity.times area
    --> Force.newtons 30000

Note that there are [other forms of multiplication](/#multiplication)!

-}
times : Quantity.Quantity number independentUnits -> Quantity.Quantity number (Quantity.Rate dependentUnits independentUnits) -> Quantity.Quantity number dependentUnits
times =
  Quantity.times


{-| Same as `times` but with the argument order flipped, which may read better
in some cases:

    Duration.minutes 30
        |> Quantity.at
            (Speed.kilometersPerHour 100)
    --> Length.kilometers 50

Can be useful to define conversion functions from one unit to another, since
if you define a `rate` then `Quantity.at rate` will give you a conversion
function:

    pixelDensity : Quantity Float (Rate Pixels Meters)
    pixelDensity =
        Pixels.pixels 96 |> Quantity.per (Length.inches 1)

    lengthToPixels : Length -> Quantity Float Pixels
    lengthToPixels length =
        Quantity.at pixelDensity length

    lengthToPixels (Length.inches 3)
    --> Pixels.pixels 288

Eagle-eyed readers will note that using partial application you could also
simply write

    lengthToPixels =
        Quantity.at pixelDensity

-}
at : Quantity.Quantity number (Quantity.Rate dependentUnits independentUnits) -> Quantity.Quantity number independentUnits -> Quantity.Quantity number dependentUnits
at =
  Quantity.at


{-| Given a rate and a _dependent_ value, determine the necessary amount of the
_independent_ value:

    Length.kilometers 75
        |> Quantity.at_
            (Speed.kilometersPerHour 100)
    --> Duration.minutes 45

Where `times` and `at` perform multiplication, `at_` performs division - you
multiply a speed by a duration to get a distance, but you divide a distance by
a speed to get a duration.

Similar to `at`, `at_` can be used to define an _inverse_ conversion function:

    pixelDensity : Quantity Float (Rate Pixels Meters)
    pixelDensity =
        Pixels.pixels 96 |> Quantity.per (Length.inches 1)

    pixelsToLength : Quantity Float Pixels -> Length
    pixelsToLength pixels =
        Quantity.at_ pixelDensity pixels

    pixelsToLength (Pixels.pixels 48)
    --> Length.inches 0.5

-}
at_ : Quantity.Quantity Float (Quantity.Rate dependentUnits independentUnits) -> Quantity.Quantity Float dependentUnits -> Quantity.Quantity Float independentUnits
at_ =
  Quantity.at_


{-| Find the inverse of a given rate. May be useful if you are using a rate to
define a conversion, and want to convert the other way;

    Quantity.at (Quantity.inverse rate)

is equivalent to

    Quantity.at_ rate

-}
inverse : Quantity.Quantity Float (Quantity.Rate dependentUnits independentUnits) -> Quantity.Quantity Float (Quantity.Rate independentUnits dependentUnits)
inverse =
  Quantity.inverse


{-| A special units type representing 'no units'. A `Quantity Int Unitless`
value is interchangeable with a simple `Int`, and a `Quantity Float Unitless`
value is interchangeable with a simple `Float`.
-}
type alias Unitless =
  Quantity.Unitless


{-| Convert a plain `Int` into a `Quantity Int Unitless` value.
-}
int : Int -> Quantity.Quantity Int Quantity.Unitless
int =
  Quantity.int


{-| Convert a `Quantity Int Unitless` value into a plain `Int`.
-}
toInt : Quantity.Quantity Int Quantity.Unitless -> Int
toInt =
  Quantity.toInt


{-| Convert a plain `Float` into a `Quantity Float Unitless` value.
-}
float : Float -> Quantity.Quantity Float Quantity.Unitless
float =
  Quantity.float


{-| Convert a `Quantity Float Unitless` value into a plain `Float`.

If you're looking for a function to convert a `Quantity Int units` to `Quantity
Float units`, check out [`toFloatQuantity`](#toFloatQuantity).

-}
toFloat : Quantity.Quantity Float Quantity.Unitless -> Float
toFloat =
  Quantity.toFloat