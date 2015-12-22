module IP
	( Octet()
	, Hextet()
	, makeOctet
	, makeHextet
	, cleanToOctet
	, cleanToHextet
	, toHexString
	, IP()
	, ipv4
	, ipv6
	, ipv4'
	, ipv6'
	, ipv4''
	, ipv6''
	, isIPv4
	, isIPv6
	, Version(V4, V6)
	, whichVersion
	) where

import Prelude

import Data.Maybe (Maybe(Just, Nothing))

-- | An unsigned 8-bit integer.
newtype Octet = Octet Int

 -- | An unsigned 16-bit integer.
newtype Hextet = Hextet Int

instance showOctet :: Show Octet where
	show (Octet o) = show o

instance showHextet :: Show Hextet where
	show (Hextet h) = show h

foreign import _toHexString :: Int -> String

-- | Turns a Hextet into a hex string.
toHexString :: Hextet -> String
toHexString (Hextet h) = _toHexString h

-- | Attempts to create an Octet from an unsigned 8-bit integer. If the given
-- | integer is signed negatively, or larger than 8-bits, `Nothing` is
-- | returned.
makeOctet :: Int -> Maybe Octet
makeOctet x
	| x < 0x0   = Nothing
	| x > 0xff  = Nothing
	| otherwise = Just $ Octet x

-- | Attempts to create an Hextet from an unsigned 16-bit integer. If the
-- | given integer is signed negatively, or larger than 16-bits, `Nothing` is
-- | returned.
makeHextet :: Int -> Maybe Hextet
makeHextet x
	| x < 0x0    = Nothing
	| x > 0xffff = Nothing
	| otherwise  = Just $ Hextet x

stopAt :: Int -> Int -> Int
stopAt n x
	| x > n     = n
	| otherwise = x

stopAt255 :: Int -> Int
stopAt255 = stopAt 0xff

stopAt65535 :: Int -> Int
stopAt65535 = stopAt 0xffff

abs :: Int -> Int
abs x
	| x < 0     = -x
	| otherwise = x

cleanTo :: forall a. (Int -> a) -> Int -> a
cleanTo fn = abs >>> fn

-- | Takes an `Integer` and returns an unsigned 8-bit [`Octet`](#octet). The
-- | passed-in parameters will be stripped to 8 bits if longer, and made
-- | non-negative.
cleanToOctet :: Int -> Octet
cleanToOctet = cleanTo (stopAt255 >>> Octet)

-- | Takes an `Integer` and returns an unsigned 16-bit [`Hextet`](#hextet). The
-- | passed-in parameters will be stripped to 16 bits if longer, and made
-- | non-negative.
cleanToHextet :: Int -> Hextet
cleanToHextet = cleanTo (stopAt65535 >>> Hextet)

-- | Represents either an IPv4 or an IPv6 address.
-- |
-- | To create one, use one of the following:
-- | - [`ipv4`](#ipv4)
-- | - [`ipv4'`](#ipv4')
-- | - [`ipv4''`](#ipv4'')
-- | - [`ipv6`](#ipv6)
-- | - [`ipv6'`](#ipv6')
-- | - [`ipv6''`](#ipv6'')
-- |
-- | Examples:
-- |
-- |     λ> ipv4 255 9 255 255
-- |     255.9.255.255
-- |     λ> ipv6 0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 20 0xffff
-- |     ffff:ffff:ffff:ffff:ffff:ffff:14:ffff
-- |
-- | The IP show instance will return syntactically-valid IP address that can be
-- | used in other programs.
data IP = IPv4 Octet Octet Octet Octet
		| IPv6 Hextet Hextet Hextet Hextet Hextet Hextet Hextet Hextet

instance showIP :: Show IP where
	show (IPv4 o1 o2 o3 o4) = show o1
		++ "." ++ show o2
		++ "." ++ show o3
		++ "." ++ show o4

	show (IPv6 h1 h2 h3 h4 h5 h6 h7 h8) = toHexString h1
		++ ":" ++ toHexString h2
		++ ":" ++ toHexString h3
		++ ":" ++ toHexString h4
		++ ":" ++ toHexString h5
		++ ":" ++ toHexString h6
		++ ":" ++ toHexString h7
		++ ":" ++ toHexString h8

-- | Creates an IPv4 address from four unsigned 8-bit `Integer`s. All passed-in
-- | parameters will be stripped to 8 bits if longer, and made non-negative.
-- |
-- | If you would like IP creation to fail instead of cleaning up passed-in
-- | parameters, use [`ipv4'`](#ipv4').
-- |
-- | If you would like to create an IP address from [`Octet`](#octet)s, please
-- | use [`ipv4''`](#ipv4'').
ipv4 :: Int -> Int -> Int -> Int -> IP
ipv4 o1 o2 o3 o4 = IPv4
	(cleanToOctet o1)
	(cleanToOctet o2)
	(cleanToOctet o3)
	(cleanToOctet o4)

-- | Creates an IPv6 address from eight unsigned 16-bit `Integer`s. All passed
-- | in parameters will be stripped to 16 bits if longer, and made
-- | non-negative.
-- |
-- | If you would like IP creation to fail instead of cleaning up passed-in
-- | parameters, use [`ipv6'`](#ipv6').
-- |
-- | If you would like to create an IP address from [`Hextet`](#hextet)s, please
-- | use [`ipv6''`](#ipv6'').
ipv6 :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> IP
ipv6 h1 h2 h3 h4 h5 h6 h7 h8 = IPv6
	(cleanToHextet h1)
	(cleanToHextet h2)
	(cleanToHextet h3)
	(cleanToHextet h4)
	(cleanToHextet h5)
	(cleanToHextet h6)
	(cleanToHextet h7)
	(cleanToHextet h8)

-- | Creates an IPv4 address from four unsigned 8-bit `Integer`s. The creation
-- | will fail if at least one of the passed-in parameters is not unsigned and
-- | 8-bits.
-- |
-- | If you would like IP address creation to sanitize your passed-in
-- | parameters, use [`ipv4`](#ipv4).
-- |
-- | If you would like to create an IP address from [`Octet`](#octet)s, please
-- | use [`ipv4''`](#ipv4'').
ipv4' :: Int -> Int -> Int -> Int -> Maybe IP
ipv4' o1 o2 o3 o4 = IPv4
	<$> makeOctet o1
	<*> makeOctet o2
	<*> makeOctet o3
	<*> makeOctet o4

-- | Creates an IPv6 address from eight unsigned 16-bit `Integer`s. The
-- | creation will fail if at least one of the passed-in parameters is not
-- | unsigned and 16-bits.
-- |
-- | If you would like IP address creation to sanitize your passed-in
-- | parameters, use [`ipv6`](#ipv6).
-- |
-- | If you would like to create an IP address from [`Hextet`](#hextet)s, please
-- | use [`ipv6''`](#ipv6'').
ipv6' :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int -> Maybe IP
ipv6' h1 h2 h3 h4 h5 h6 h7 h8 = IPv6
	<$> makeHextet h1
	<*> makeHextet h2
	<*> makeHextet h3
	<*> makeHextet h4
	<*> makeHextet h5
	<*> makeHextet h6
	<*> makeHextet h7
	<*> makeHextet h8

-- | Creates an IPv4 address from four [`Octet`](#octet)s.
-- |
-- | If you would like to create an IP address from `Integers`, use either
-- | [`ipv4`](#ipv4) or [`ipv4'`](#ipv4').
ipv4'' :: Octet -> Octet -> Octet -> Octet -> IP
ipv4'' o1 o2 o3 o4 = IPv4 o1 o2 o3 o4

-- | Creates an IPv6 address from eight [`Hextets`](#hextet)s.
-- |
-- | If you would like to create an IP address from `Integers`, use either
-- | [`ipv6`](#ipv6) or [`ipv6'`](#ipv6').
ipv6'' :: Hextet -> Hextet -> Hextet -> Hextet -> Hextet -> Hextet -> Hextet -> Hextet -> IP
ipv6'' h1 h2 h3 h4 h5 h6 h7 h8 = IPv6 h1 h2 h3 h4 h5 h6 h7 h8

-- | Verifies whether or not an IP address is version 4.
isIPv4 :: IP -> Boolean
isIPv4 (IPv4 _ _ _ _) = true
isIPv4 _              = false

-- | Verifies whether or not an IP address is version 6.
isIPv6 :: IP -> Boolean
isIPv6 = isIPv4 >>> not

-- | A IP address version: either Version 4 (V4) or Version 6 (V6).
data Version = V4 | V6

-- | Returns the version of a given IP address.
whichVersion :: IP -> Version
whichVersion (IPv4 _ _ _ _) = V4
whichVersion _              = V6

-- | The IPv4 address for localhost: `127.0.0.1`.
localhostv4 :: IP
localhostv4 = ipv4 127 0 0 1

-- | The IPv6 address for localhost: `0:0:0:0:0:0:0:1`.
localhostv6 :: IP
localhostv6 = ipv6 0 0 0 0 0 0 0 1
