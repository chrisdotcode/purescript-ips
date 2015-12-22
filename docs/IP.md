## Module IP

#### `Octet`

``` purescript
newtype Octet
```

An unsigned 32-bit integer.

##### Instances
``` purescript
Show Octet
```

#### `Hextet`

``` purescript
newtype Hextet
```

An unsigned 128-bit integer.

##### Instances
``` purescript
Show Hextet
```

#### `toHexString`

``` purescript
toHexString :: Hextet -> String
```

Turns a Hextet into a hex string.

#### `makeOctet`

``` purescript
makeOctet :: Int -> Maybe Octet
```

Attempts to create an Octet from an unsigned 32-bit integer. If the given
integer is signed negatively, or larger than 32-bits, `Nothing` is
returned.

#### `makeHextet`

``` purescript
makeHextet :: Int -> Maybe Hextet
```

Attempts to create an Hextet from an unsigned 128-bit integer. If the
given integer is signed negatively, or larger than 128-bits, `Nothing` is
returned.

#### `cleanToOctet`

``` purescript
cleanToOctet :: Int -> Octet
```

Takes an `Integer` and returns an unsigned 32-bit [`Octet`](#octet). The
passed-in parameters will be stripped to 32 bits if longer, and made
non-negative.

#### `cleanToHextet`

``` purescript
cleanToHextet :: Int -> Hextet
```

Takes an `Integer` and returns an unsigned 128-bit [`Hextet`](#hextet). The
passed-in parameters will be stripped to 128 bits if longer, and made
non-negative.

#### `IP`

``` purescript
data IP
```

Represents either an IPv4 or an IPv6 address.

To create one, use one of the following:
- [`ipv4`](#ipv4)
- [`ipv4'`](#ipv4')
- [`ipv4''`](#ipv4'')
- [`ipv6`](#ipv6)
- [`ipv6'`](#ipv6')
- [`ipv6''`](#ipv6'')

Examples:

    λ> ipv4 255 9 255 255
    255.9.255.255
    λ> ipv6 0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 20 0xffff
    ffff:ffff:ffff:ffff:ffff:ffff:14:ffff

The IP show instance will return syntactically-valid IP address that can be
used in other programs.

##### Instances
``` purescript
Show IP
```

#### `ipv4`

``` purescript
ipv4 :: Int -> Int -> Int -> Int -> IP
```

Creates an IPv4 address from four unsigned 32-bit `Integer`s. All passed-in
parameters will be stripped to 32 bits if longer, and made non-negative.

If you would like IP creation to fail instead of cleaning up passed-in
parameters, use [`ipv4'`](#ipv4').

If you would like to create an IP address from [`Octet`](#octet)s, please
use [`ipv4''`](#ipv4'').

#### `ipv6`

``` purescript
ipv6 :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> IP
```

Creates an IPv6 address from eight unsigned 128-bit `Integer`s. All passed
in parameters will be stripped to 128 bits if longer, and made
non-negative.

If you would like IP creation to fail instead of cleaning up passed-in
parameters, use [`ipv6'`](#ipv6').

If you would like to create an IP address from [`Hextet`](#hextet)s, please
use [`ipv6''`](#ipv6'').

#### `ipv4'`

``` purescript
ipv4' :: Int -> Int -> Int -> Int -> Maybe IP
```

Creates an IPv4 address from four unsigned 32-bit `Integer`s. The creation
will fail if at least one of the passed-in parameters is not unsigned and
32-bits.

If you would like IP address creation to sanitize your passed-in
parameters, use [`ipv4`](#ipv4).

If you would like to create an IP address from [`Octet`](#octet)s, please
use [`ipv4''`](#ipv4'').

#### `ipv6'`

``` purescript
ipv6' :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Maybe IP
```

Creates an IPv6 address from eight unsigned 128-bit `Integer`s. The
creation will fail if at least one of the passed-in parameters is not
unsigned and 128-bits.

If you would like IP address creation to sanitize your passed-in
parameters, use [`ipv6`](#ipv6).

If you would like to create an IP address from [`Hextet`](#hextet)s, please
use [`ipv6''`](#ipv6'').

#### `ipv4''`

``` purescript
ipv4'' :: Octet -> Octet -> Octet -> Octet -> IP
```

Creates an IPv4 address from four [`Octet`](#octet)s.

If you would like to create an IP address from `Integers`, use either
[`ipv4`](#ipv4) or [`ipv4'`](#ipv4').

#### `ipv6''`

``` purescript
ipv6'' :: Hextet -> Hextet -> Hextet -> Hextet -> Hextet -> Hextet -> Hextet -> Hextet -> IP
```

Creates an IPv6 address from eight [`Hextets`](#hextet)s.

If you would like to create an IP address from `Integers`, use either
[`ipv6`](#ipv6) or [`ipv6'`](#ipv6').

#### `isIPv4`

``` purescript
isIPv4 :: IP -> Boolean
```

Verifies whether or not an IP address is version 4.

#### `isIPv6`

``` purescript
isIPv6 :: IP -> Boolean
```

Verifies whether or not an IP address is version 6.

#### `Version`

``` purescript
data Version
  = V4
  | V6
```

A IP address version: either Version 4 (V4) or Version 6 (V6).

#### `whichVersion`

``` purescript
whichVersion :: IP -> Version
```

Returns the version of a given IP address.


