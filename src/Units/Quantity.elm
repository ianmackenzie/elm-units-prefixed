module Units.Quantity exposing (Quantity, Squared, Cubed, Product, Rate, zero, infinity, positiveInfinity, negativeInfinity, lessThan, greaterThan, lessThanOrEqualTo, greaterThanOrEqualTo, lessThanZero, greaterThanZero, lessThanOrEqualToZero, greaterThanOrEqualToZero, compare, equalWithin, max, min, isNaN, isInfinite, negate, abs, plus, difference, minus, multiplyBy, divideBy, twice, half, ratio, squared, sqrt, cubed, cbrt, squaredUnitless, sqrtUnitless, cubedUnitless, cbrtUnitless, reciprocal, product, times, timesUnitless, over, over_, overUnitless, rate, per, at, at_, for, inverse, rateProduct, modBy, fractionalModBy, remainderBy, fractionalRemainderBy, clamp, sign, interpolateFrom, midpoint, range, in_, round, floor, ceiling, truncate, toFloatQuantity, sum, minimum, maximum, minimumBy, maximumBy, sort, sortBy, Unitless, int, toInt, float, toFloat, unsafe, unwrap)

{-|

@docs Quantity


# Unit types

The `Squared`, `Cubed`, `Product` and `Rate` units types allow you to build up
and work with composite units in a fairly flexible way.

@docs Squared, Cubed, Product, Rate


# Constants

@docs zero, infinity, positiveInfinity, negativeInfinity


# Comparison

@docs lessThan, greaterThan, lessThanOrEqualTo, greaterThanOrEqualTo
@docs lessThanZero, greaterThanZero, lessThanOrEqualToZero, greaterThanOrEqualToZero
@docs compare, equalWithin, max, min, isNaN, isInfinite


# Arithmetic

@docs negate, abs, plus, difference, minus, multiplyBy, divideBy, twice, half, ratio, squared, sqrt, cubed, cbrt


## Unitless quantities

Some specialized arithmetic functions for working with [unitless](#Unitless)
quantities. `squaredUnitless`, `sqrtUnitless`, `cubedUnitless` and
`cbrtUnitless` all behave just like their non-`Unitless` versions but return a
`Unitless` result (instead of for example something meaningless like `Squared
Unitless`).

@docs squaredUnitless, sqrtUnitless, cubedUnitless, cbrtUnitless, reciprocal


## Working with products

@docs product, times, timesUnitless, over, over_, overUnitless


## Working with rates

@docs rate, per, at, at_, for, inverse, rateProduct


## Modular arithmetic

`modBy` and `remainderBy` behave just like the [`modBy`](https://package.elm-lang.org/packages/elm/core/latest/Basics#modBy)
and [`remainderBy`](https://package.elm-lang.org/packages/elm/core/latest/Basics#remainderBy)
functions from Elm's built-in `Basics` module, but work on `Quantity` values
instead of raw `Int`s. `fractionalModBy` and `fractionalRemainderBy` have the
same behaviour but extended to `Float`-valued quantities.

    import Pixels exposing (pixels)
    import Length exposing (meters, centimeters)

    Quantity.modBy (pixels 4) (pixels 11)
    --> pixels 3

    Quantity.fractionalModBy (meters 0.5)
        (centimeters 162.3)
    --> centimeters 12.3

@docs modBy, fractionalModBy, remainderBy, fractionalRemainderBy


## Miscellaneous

@docs clamp, sign, interpolateFrom, midpoint, range, in_


# `Int`/`Float` conversion

These functions only really make sense for quantities in units like pixels,
cents or game tiles where an `Int` number of units is meaningful. For quantities
like `Length` or `Duration`, it doesn't really make sense to round to an `Int`
value since the underyling base unit is pretty arbitrary - should `round`ing a
`Duration` give you an `Int` number of seconds, milliseconds, or something else?
(The actual behavior is that quantities will generally get rounded to the
nearest SI base unit, since that is how they are stored internally - for
example, `Length` values will get rounded to the nearest meter regardless of
whether they were constructed from a number of meters, centimeters, inches or
light years.)

@docs round, floor, ceiling, truncate, toFloatQuantity


# List functions

These functions act just like the corresponding functions in the built-in `List`
module (or, int the case of `minimumBy` and `maximumBy`, the `List.Extra` module
from `elm-community/list-extra`). They're necessary because the built-in
`List.sum` only supports `List Int` and `List Float`, and the remaining
functions only support built-in `comparable` types like `Int`, `Float`, `String`
and tuples.

@docs sum, minimum, maximum, minimumBy, maximumBy, sort, sortBy


# Unitless quantities

It is sometimes useful to be able to represent _unitless_ quantities, especially
when working with generic code (in most other cases, it is likely simpler and
easier to just use `Int` or `Float` values directly). All the conversions in
this section simply wrap or unwrap a `Float` or `Int` value into a `Quantity`
value, and so should get compiled away entirely when using `elm make
--optimize`.

@docs Unitless, int, toInt, float, toFloat


# Unsafe conversions

These functions are equivalent to directly constructing or unwrapping `Quantity`
values, and generally shouldn't be used outside of some specialized situations
that can come up when authoring packages that use `elm-units`.

@docs unsafe, unwrap

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
example, `Meters` is one units type (the units type of a [`Length`](Length)) and
`Squared Meters` is another (the units type of an [`Area`](Area)). See the
[`squared`](#squared) and [`sqrt`](#sqrt) functions for examples of use.

This is a special case of the `Product` units type.

-}
type alias Squared units =
  Quantity.Squared units


{-| Represents a units type that is the cube of some other units type; for
example, `Meters` is one units type (the units type of a [`Length`](Length)) and
`Cubed Meters` is another (the units type of an [`Volume`](Volume)). See the
[`cubed`](Quantity#cubed) and [`cbrt`](Quantity#cbrt) functions for examples of
use.

This is a special case of the `Product` units type.

-}
type alias Cubed units =
  Quantity.Cubed units


{-| Represents a units type that is the product of two other units types. This
is a more general form of `Squared` or `Cubed`. See [`product`](#product),
[`times`](#times), [`over`](#over) and [`over_`](#over_) for how it can be used.
-}
type alias Product units1 units2 =
  Quantity.Product units1 units2


{-| Represents the units type of a rate or quotient such as a speed (`Rate
Meters Seconds`) or a pressure (`Rate Newtons SquareMeters`). See [Working with
rates](#working-with-rates) for details.
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


{-| Check if one quantity is less than or equal to another. Note the [argument
order](/#argument-order)!
-}
lessThanOrEqualTo : Quantity.Quantity number units -> Quantity.Quantity number units -> Bool
lessThanOrEqualTo =
  Quantity.lessThanOrEqualTo


{-| Check if one quantity is greater than or equal to another. Note the
[argument order](/#argument-order)!
-}
greaterThanOrEqualTo : Quantity.Quantity number units -> Quantity.Quantity number units -> Bool
greaterThanOrEqualTo =
  Quantity.greaterThanOrEqualTo


{-| Short form for `Quantity.lessThan Quantity.zero`.
-}
lessThanZero : Quantity.Quantity number units -> Bool
lessThanZero =
  Quantity.lessThanZero


{-| Short form for `Quantity.greaterThan Quantity.zero`.
-}
greaterThanZero : Quantity.Quantity number units -> Bool
greaterThanZero =
  Quantity.greaterThanZero


{-| Short form for `Quantity.lessThanOrEqualTo Quantity.zero`.
-}
lessThanOrEqualToZero : Quantity.Quantity number units -> Bool
lessThanOrEqualToZero =
  Quantity.lessThanOrEqualToZero


{-| Short form for `Quantity.greaterThanOrEqualTo Quantity.zero`.
-}
greaterThanOrEqualToZero : Quantity.Quantity number units -> Bool
greaterThanOrEqualToZero =
  Quantity.greaterThanOrEqualToZero


{-| Compare two quantities, returning an [`Order`](https://package.elm-lang.org/packages/elm/core/latest/Basics#Order)
value indicating whether the first is less than, equal to or greater than the
second.

    Quantity.compare
        (Duration.minutes 90)
        (Duration.hours 1)
    --> GT

    Quantity.compare
        (Duration.minutes 60)
        (Duration.hours 1)
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


{-| Get the absolute value of a quantity.

    Quantity.abs (Duration.milliseconds -10)
    --> Duration.milliseconds 10

-}
abs : Quantity.Quantity number units -> Quantity.Quantity number units
abs =
  Quantity.abs


{-| Add two quantities.

    Length.meters 1 |> Quantity.plus (Length.centimeters 5)
    --> Length.centimeters 105

-}
plus : Quantity.Quantity number units -> Quantity.Quantity number units -> Quantity.Quantity number units
plus =
  Quantity.plus


{-| Subtract one quantity from another.

    Quantity.difference
        (Duration.hours 1)
        (Duration.minutes 15)
    --> Duration.minutes 45

-}
difference : Quantity.Quantity number units -> Quantity.Quantity number units -> Quantity.Quantity number units
difference =
  Quantity.difference


{-| An 'infix' version of [`difference`](#difference), intended to be used in
pipeline form;

    Quantity.difference x y

can be written as

    x |> Quantity.minus y

Note that unlike `difference`, this also means that partial application will 'do
the right thing':

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


{-| Scale a `Quantity` by a `number`.

    Quantity.multiplyBy 1.5 (Duration.hours 1)
    --> Duration.minutes 90

Note that there are [other forms of multiplication](/#multiplication-and-division)!

-}
multiplyBy : number -> Quantity.Quantity number units -> Quantity.Quantity number units
multiplyBy =
  Quantity.multiplyBy


{-| Divide a `Quantity` by a `Float`.

    Quantity.divideBy 2 (Duration.hours 1)
    --> Duration.minutes 30

Note that there are [other forms of division](/#multiplication-and-division)!

-}
divideBy : Float -> Quantity.Quantity Float units -> Quantity.Quantity Float units
divideBy =
  Quantity.divideBy


{-| Convenient shorthand for `Quantity.multiplyBy 2`.

    Quantity.twice (Duration.minutes 30)
    --> Duration.hours 1

-}
twice : Quantity.Quantity number units -> Quantity.Quantity number units
twice =
  Quantity.twice


{-| Convenient shorthand for `Quantity.multiplyBy 0.5`.

    Quantity.half (Length.meters 1)
    --> Length.centimeters 50

-}
half : Quantity.Quantity Float units -> Quantity.Quantity Float units
half =
  Quantity.half


{-| Find the ratio of two quantities with the same units.

    Quantity.ratio (Length.miles 1) (Length.yards 1)
    --> 1760

-}
ratio : Quantity.Quantity Float units -> Quantity.Quantity Float units -> Float
ratio =
  Quantity.ratio


{-| Square a quantity with some `units`, resulting in a new quantity in
`Squared units`:

    Quantity.squared (Length.meters 5)
    --> Area.squareMeters 25

See also [`squaredUnitless`](#squaredUnitless).

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
        Quantity.sqrt
            (Quantity.squared x
                |> Quantity.plus
                    (Quantity.squared y)
            )

This works because:

  - The `x` and `y` arguments are both in `units`
  - So each squared item is in `Squared units`
  - So the sum is also in `Squared units`
  - And calling `sqrt` on something in `Squared units` returns a value back in
    `units`

See also [`sqrtUnitless`](#sqrtUnitless).

-}
sqrt : Quantity.Quantity Float (Quantity.Squared units) -> Quantity.Quantity Float units
sqrt =
  Quantity.sqrt


{-| Cube a quantity with some `units`, resulting in a new quantity in
`Cubed units`.

    Quantity.cubed (Length.meters 5)
    --> Volume.cubicMeters 125

See also [`cubedUnitless`](#cubedUnitless).

-}
cubed : Quantity.Quantity number units -> Quantity.Quantity number (Quantity.Cubed units)
cubed =
  Quantity.cubed


{-| Take a quantity in `Cubed units` and return the cube root of that
quantity in plain `units`.

    Quantity.cbrt (Volume.liters 1)
    --> Length.centimeters 10

See also [`cbrtUnitless`](#cbrtUnitless).

-}
cbrt : Quantity.Quantity Float (Quantity.Cubed units) -> Quantity.Quantity Float units
cbrt =
  Quantity.cbrt


{-| -}
squaredUnitless : Quantity.Quantity number Quantity.Unitless -> Quantity.Quantity number Quantity.Unitless
squaredUnitless =
  Quantity.squaredUnitless


{-| -}
sqrtUnitless : Quantity.Quantity Float Quantity.Unitless -> Quantity.Quantity Float Quantity.Unitless
sqrtUnitless =
  Quantity.sqrtUnitless


{-| -}
cubedUnitless : Quantity.Quantity number Quantity.Unitless -> Quantity.Quantity number Quantity.Unitless
cubedUnitless =
  Quantity.cubedUnitless


{-| -}
cbrtUnitless : Quantity.Quantity Float Quantity.Unitless -> Quantity.Quantity Float Quantity.Unitless
cbrtUnitless =
  Quantity.cbrtUnitless


{-| Find the inverse of a unitless value.

    Quantity.reciprocal (Quantity.float 5)
    --> Quantity.float 0.2

-}
reciprocal : Quantity.Quantity Float Quantity.Unitless -> Quantity.Quantity Float Quantity.Unitless
reciprocal =
  Quantity.reciprocal


{-| Multiply two quantities with units types `units1` and `units2` together,
resulting in a quantity with units type `Product units1 units2`.

This works for any two units types, but one special case is worth pointing out.
The units type of an [`Area`](Area) is `SquareMeters`, which is a type alias for
`Squared Meters`, which in turn expands to `Product Meters Meters`. This means
that the product of two `Length`s does in fact give you an `Area`:

    -- This is the definition of an acre, I kid you not 😈
    Quantity.product (Length.feet 66) (Length.feet 660)
    --> Area.acres 1

We can also multiply an `Area` by a `Length` to get a `Volume`:

    Quantity.product
        (Area.squareMeters 1)
        (Length.centimers 1)
    --> Volume.liters 10

Note that there are [other forms of multiplication](/#multiplication-and-division)!

-}
product : Quantity.Quantity number units1 -> Quantity.Quantity number units2 -> Quantity.Quantity number (Quantity.Product units1 units2)
product =
  Quantity.product


{-| An 'infix' version of [`product`](#product), intended to be used in pipeline
form;

    Quantity.product a b

can be written as

    a |> Quantity.times b

-}
times : Quantity.Quantity number units2 -> Quantity.Quantity number units1 -> Quantity.Quantity number (Quantity.Product units1 units2)
times =
  Quantity.times


{-| If you use [`times`](#times) or [`product`](#product) to multiply one
quantity by another [unitless](#Unitless) quantity, for example

    quantity |> Quantity.times unitlessQuantity

then the result you'll get will have units type `Product units Unitless`. But
this is silly and not super useful, since the product of `units` and `Unitless`
should really just be `units`. That's what `timesUnitless` does - it's a special
case of `times` for when you're multiplying by another unitless quantity, that
leaves the units alone.

You can think of `timesUnitless` as shorthand for `toFloat` and `multiplyBy`;
for `Float`-valued quantities,

    quantity |> Quantity.timesUnitless unitlessQuantity

is equivalent to

    quantity
        |> Quantity.multiplyBy
            (Quantity.toFloat unitlessQuantity)

-}
timesUnitless : Quantity.Quantity number Quantity.Unitless -> Quantity.Quantity number units -> Quantity.Quantity number units
timesUnitless =
  Quantity.timesUnitless


{-| Divide a quantity in `Product units1 units2` by a quantity in `units1`,
resulting in another quantity in `units2`. For example, the units type of a
`Force` is `Product Kilograms MetersPerSecondSquared` (mass times acceleration),
so we could divide a force by a given mass to determine how fast that mass would
be accelerated by the given force:

    Force.newtons 100
        |> Quantity.over
            (Mass.kilograms 50)
    --> Acceleration.metersPerSecondSquared 2

Note that there are [other forms of division](/#multiplication-and-division)!

-}
over : Quantity.Quantity Float units1 -> Quantity.Quantity Float (Quantity.Product units1 units2) -> Quantity.Quantity Float units2
over =
  Quantity.over


{-| Just like `over` but divide by a quantity in `units2`, resulting in another
quantity in `units1`. For example, we could divide a force by a desired
acceleration to determine how much mass could be accelerated at that rate:

    Force.newtons 100
        |> Quantity.over_
            (Acceleration.metersPerSecondSquared 5)
    --> Mass.kilograms 20

-}
over_ : Quantity.Quantity Float units2 -> Quantity.Quantity Float (Quantity.Product units1 units2) -> Quantity.Quantity Float units1
over_ =
  Quantity.over_


{-| Similar to [`timesUnitless`](#timesUnitless), `overUnitless` lets you
divide one quantity by a second [unitless](#Unitless) quantity without affecting
the units;

    quantity |> Quantity.overUnitless unitlessQuantity

is equivalent to

    quantity
        |> Quantity.divideBy
            (Quantity.toFloat unitlessQuantity)

-}
overUnitless : Quantity.Quantity Float Quantity.Unitless -> Quantity.Quantity Float units -> Quantity.Quantity Float units
overUnitless =
  Quantity.overUnitless


{-| Construct a rate of change by dividing a dependent quantity (numerator) by
an independent quantity (denominator):

    speed =
        Quantity.rate (Length.miles 1) Duration.minute

    speed |> Speed.inMilesPerHour
    --> 60

Note that we could directly use our rate of change value as a `Speed`! That is
because many built-in quantity types are defined as rates of change, for
example:

  - `Speed` is `Length` per `Duration`
  - `Acceleration` is `Speed` per `Duration`
  - `Pressure` is `Force` per `Area`
  - `Power` is `Energy` per `Duration`
  - `Current` is `Charge` per `Duration`
  - `Resistance` is `Voltage` per `Current`
  - `Voltage` is `Power` per `Current`

Note that there are [other forms of division](/#multiplication-and-division)!

-}
rate : Quantity.Quantity Float dependentUnits -> Quantity.Quantity Float independentUnits -> Quantity.Quantity Float (Quantity.Rate dependentUnits independentUnits)
rate =
  Quantity.rate


{-| 'Infix' version of [`rate`](#rate), meant to be used in pipeline form;

    Quantity.rate distance time

can be written as

    distance |> Quantity.per time

-}
per : Quantity.Quantity Float independentUnits -> Quantity.Quantity Float dependentUnits -> Quantity.Quantity Float (Quantity.Rate dependentUnits independentUnits)
per =
  Quantity.per


{-| Multiply a rate of change by an independent quantity (the denominator in
the rate) to get a total value:

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

Note that there are [other forms of multiplication](/#multiplication-and-division)!

-}
at : Quantity.Quantity number (Quantity.Rate dependentUnits independentUnits) -> Quantity.Quantity number independentUnits -> Quantity.Quantity number dependentUnits
at =
  Quantity.at


{-| Given a rate and a _dependent_ quantity (total value), determine the
necessary amount of the _independent_ quantity:

    Length.kilometers 75
        |> Quantity.at_
            (Speed.kilometersPerHour 100)
    --> Duration.minutes 45

Where `at` performs multiplication, `at_` performs division - you multiply a
speed by a duration to get a distance, but you divide a distance by a speed to
get a duration.

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


{-| Same as `at` but with the argument order flipped, which may read better
in some cases:

    Speed.kilometersPerHour 100
        |> Quantity.for
            (Duration.minutes 30)
    --> Length.kilometers 50

-}
for : Quantity.Quantity number independentUnits -> Quantity.Quantity number (Quantity.Rate dependentUnits independentUnits) -> Quantity.Quantity number dependentUnits
for =
  Quantity.for


{-| Find the inverse of a given rate. May be useful if you are using a rate to
define a conversion, and want to convert the other way;

    Quantity.at (Quantity.inverse rate)

is equivalent to

    Quantity.at_ rate

-}
inverse : Quantity.Quantity Float (Quantity.Rate dependentUnits independentUnits) -> Quantity.Quantity Float (Quantity.Rate independentUnits dependentUnits)
inverse =
  Quantity.inverse


{-| Multiply two rates of change that 'cancel out' together, resulting in a new
rate. For example, if you know the real-world speed of an on-screen object and
the display resolution, then you can get the speed in pixels per second:

    realWorldSpeed =
        Speed.metersPerSecond 0.1

    resolution =
        Pixels.float 96 |> Quantity.per Length.inch

    Quantity.rateProduct realWorldSpeed resolution
    --> Pixels.pixelsPerSecond 377.95

That is, "length per duration" multiplyed by "pixels per length" gives you
"pixels per duration".

Sometimes you can't directly multiply two rates to get what you want, in which
case you may need to use [`inverse`](#inverse) in combination with
`rateProduct`. For example, if you know the on-screen speed of some object and
the display resolution, then you can use those to get the real-world speed:

    pixelSpeed =
        Pixels.pixelsPerSecond 500

    resolution =
        Pixels.float 96 |> Quantity.per Length.inch

    Quantity.rateProduct pixelSpeed
        (Quantity.inverse resolution)
    --> Speed.metersPerSecond 0.1323

-}
rateProduct : Quantity.Quantity Float (Quantity.Rate units2 units1) -> Quantity.Quantity Float (Quantity.Rate units3 units2) -> Quantity.Quantity Float (Quantity.Rate units3 units1)
rateProduct =
  Quantity.rateProduct


{-| -}
modBy : Quantity.Quantity Int units -> Quantity.Quantity Int units -> Quantity.Quantity Int units
modBy =
  Quantity.modBy


{-| -}
fractionalModBy : Quantity.Quantity Float units -> Quantity.Quantity Float units -> Quantity.Quantity Float units
fractionalModBy =
  Quantity.fractionalModBy


{-| -}
remainderBy : Quantity.Quantity Int units -> Quantity.Quantity Int units -> Quantity.Quantity Int units
remainderBy =
  Quantity.remainderBy


{-| -}
fractionalRemainderBy : Quantity.Quantity Float units -> Quantity.Quantity Float units -> Quantity.Quantity Float units
fractionalRemainderBy =
  Quantity.fractionalRemainderBy


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


{-| Get the sign of a quantity. This will return 1, -1, 0 or NaN if the given
quantity is positive, negative, zero or NaN respectively.

    Quantity.sign (Length.meters 3)
    --> 1

    Quantity.sign (Length.meters -3)
    --> -1

    Quantity.sign (Length.meters 0)
    --> 0

    Quantity.sign Quantity.positiveInfinity
    --> 1

    Quantity.sign (Length.meters (0 / 0))
    --> NaN

-}
sign : Quantity.Quantity Float units -> Float
sign =
  Quantity.sign


{-| Interpolate from the first quantity to the second, based on a parameter that
ranges from zero to one. Passing a parameter value of zero will return the start
value and passing a parameter value of one will return the end value.

    fiveMeters =
        Length.meters 5

    tenMeters =
        Length.meters 10

    Quantity.interpolateFrom fiveMeters tenMeters 0
    --> Length.meters 5

    Quantity.interpolateFrom fiveMeters tenMeters 1
    --> Length.meters 10

    Quantity.interpolateFrom fiveMeters tenMeters 0.6
    --> Length.meters 8

The end value can be less than the start value:

    Quantity.interpolateFrom tenMeters fiveMeters 0.1
    --> Length.meters 9.5

Parameter values less than zero or greater than one can be used to extrapolate:

    Quantity.interpolateFrom fiveMeters tenMeters 1.5
    --> Length.meters 12.5

    Quantity.interpolateFrom fiveMeters tenMeters -0.5
    --> Length.meters 2.5

    Quantity.interpolateFrom tenMeters fiveMeters -0.2
    --> Length.meters 11

-}
interpolateFrom : Quantity.Quantity Float units -> Quantity.Quantity Float units -> Float -> Quantity.Quantity Float units
interpolateFrom =
  Quantity.interpolateFrom


{-| Find the midpoint between two quantities.

    Quantity.midpoint (Length.meters 5) (Length.meters 10)
    --> Length.meters 7.5

-}
midpoint : Quantity.Quantity Float units -> Quantity.Quantity Float units -> Quantity.Quantity Float units
midpoint =
  Quantity.midpoint


{-| Construct a range of evenly-spaced values given a `start` value, an `end`
value and the number of `steps` to take from the start to the end. The first
value in the returned list will be equal to `start` and the last value will be
equal to `end`. Note that the number of returned values will be one greater than
the number of steps!

    Quantity.range
        { start = Length.meters 2
        , end = Length.meters 3
        , steps = 5
        }
    --> [ Length.centimeters 200
    --> , Length.centimeters 220
    --> , Length.centimeters 240
    --> , Length.centimeters 260
    --> , Length.centimeters 280
    --> , Length.centimeters 300
    --> ]

The start and end values can be in either order:

    Quantity.range
        { start = Duration.hours 1
        , end = Quantity.zero
        , steps = 4
        }
    --> [ Duration.minutes 60
    --> , Duration.minutes 45
    --> , Duration.minutes 30
    --> , Duration.minutes 15
    --> , Duration.minutes 0
    --> ]

Passing a negative or zero `steps` value will result in an empty list being
returned.

If you need finer control over what values get generated, try combining
`interpolateFrom` with the various functions in the
[`elm-1d-parameter`](https://package.elm-lang.org/packages/ianmackenzie/elm-1d-parameter/latest/)
package. For example:

    -- Same as using Quantity.range
    Parameter1d.steps 4 <|
        Quantity.interpolateFrom
            (Length.meters 2)
            (Length.meters 3)
    --> [ Length.centimeters 200
    --> , Length.centimeters 225
    --> , Length.centimeters 250
    --> , Length.centimeters 275
    --> , Length.centimeters 300
    --> ]

    -- Omit the last value
    Parameter1d.leading 4 <|
        Quantity.interpolateFrom
            (Length.meters 2)
            (Length.meters 3)
    --> [ Length.centimeters 200
    --> , Length.centimeters 225
    --> , Length.centimeters 250
    --> , Length.centimeters 275
    --> ]

-}
range : { start : Quantity.Quantity Float units, end : Quantity.Quantity Float units, steps : Int } -> List (Quantity.Quantity Float units)
range =
  Quantity.range


{-| Generalized units conversion function that lets you convert to many kinds of
units not directly supported by `elm-units`. The first argument is a function
that constructs a value of the desired unit type, and the second is the quantity
to convert. For example,

    Speed.metersPerSecond 5
        |> Speed.inFeetPerSecond
    --> 16.4042

is equivalent to

    Speed.metersPerSecond 5
        |> Quantity.in_ Speed.feetPerSecond
    --> 16.4042

More interestingly, if you wanted to get speed in some weirder unit like
millimeters per minute (not directly supported by `elm-units`), you could do

    Speed.metersPerSecond 5
        |> Quantity.in_
            (Length.millimeters
                >> Quantity.per (Duration.minutes 1)
            )
    --> 300000

Internally,

    Quantity.in_ someUnits someQuantity

is simply implemented as

    Quantity.ratio someQuantity (someUnits 1)

-}
in_ : (Float -> Quantity.Quantity Float units) -> Quantity.Quantity Float units -> Float
in_ =
  Quantity.in_


{-| Round a `Float`-valued quantity to the nearest `Int`. Note that [this may
not do what you expect](#-int-float-conversion).

    Quantity.round (Pixels.pixels 3.5)
    --> Pixels.pixels 4

-}
round : Quantity.Quantity Float units -> Quantity.Quantity Int units
round =
  Quantity.round


{-| Round a `Float`-valued quantity down to the nearest `Int`. Note that [this
may not do what you expect](#-int-float-conversion).

    Quantity.floor (Pixels.pixels 2.9)
    --> Pixels.pixels 2

    Quantity.floor (Pixels.pixels -2.1)
    --> Pixels.pixels -3

-}
floor : Quantity.Quantity Float units -> Quantity.Quantity Int units
floor =
  Quantity.floor


{-| Round a `Float`-valued quantity up to the nearest `Int`. Note that [this may
not do what you expect](#-int-float-conversion).

    Quantity.ceiling (Pixels.pixels 1.2)
    --> Pixels.pixels 2

    Quantity.ceiling (Pixels.pixels -2.1)
    --> Pixels.pixels -2

-}
ceiling : Quantity.Quantity Float units -> Quantity.Quantity Int units
ceiling =
  Quantity.ceiling


{-| Round a `Float`-valued quantity towards zero. Note that [this may not do
what you expect](#-int-float-conversion).

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


{-| Find the sum of a list of quantities.

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


{-| Find the 'minimum' item in a list as measured by some derived `Quantity`:

    people =
        [ { name = "Bob", height = Length.meters 1.6 }
        , { name = "Charlie", height = Length.meters 2.0 }
        , { name = "Alice", height = Length.meters 1.8 }
        ]

    Quantity.minimumBy .height people
    --> Just { name = "Bob", height = Length.meters 1.6 }

If the list is empty, returns `Nothing`. If multiple items in the list are tied,
then the first one is returned.

-}
minimumBy : (a -> Quantity.Quantity number units) -> List a -> Maybe a
minimumBy =
  Quantity.minimumBy


{-| Find the 'maximum' item in a list as measured by some derived `Quantity`:

    people =
        [ { name = "Bob", height = Length.meters 1.6 }
        , { name = "Charlie", height = Length.meters 2.0 }
        , { name = "Alice", height = Length.meters 1.8 }
        ]

    Quantity.maximumBy .height people
    --> Just { name = "Charlie", height = Length.meters 2.0 }

If the list is empty, returns `Nothing`. If multiple items in the list are tied,
then the first one is returned.

-}
maximumBy : (a -> Quantity.Quantity number units) -> List a -> Maybe a
maximumBy =
  Quantity.maximumBy


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


{-| Sort an arbitrary list of values by a derived `Quantity`. If you had

    people =
        [ { name = "Bob", height = Length.meters 1.6 }
        , { name = "Charlie", height = Length.meters 2.0 }
        , { name = "Alice", height = Length.meters 1.8 }
        ]

then you could sort by name with

    List.sortBy .name people
    --> [ { name = "Alice", height = Length.meters 1.8 }
    --> , { name = "Bob", height = Length.meters 1.6 }
    --> , { name = "Charlie", height = Length.meters 2.0 }
    --> ]

(nothing new there!), and sort by height with

    Quantity.sortBy .height people
    --> [ { name = "Bob", height = Length.meters 1.6 }
    --> , { name = "Alice", height = Length.meters 1.8 }
    --> , { name = "Charlie", height = Length.meters 2.0 }
    --> ]

-}
sortBy : (a -> Quantity.Quantity number units) -> List a -> List a
sortBy =
  Quantity.sortBy


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


{-| -}
unsafe : number -> Quantity.Quantity number units
unsafe =
  Quantity.unsafe


{-| -}
unwrap : Quantity.Quantity number units -> number
unwrap =
  Quantity.unwrap