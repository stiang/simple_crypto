# SimpleCrypto

Simple crypto helpers for Elixir. Requires Elixir 1.12 since it uses the new crypto API in OTP22.

## Installation

The package can be installed by adding `simple_crypto` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [{:simple_crypto, "~> 1.0"}]
end
```

## Basic Usage

``` elixir
iex(1)> SimpleCrypto.encrypt("Hi there", "secret key")
"qCgs4rfReY5nTX39uHwjww=="

iex(2)> SimpleCrypto.decrypt("qCgs4rfReY5nTX39uHwjww==", "secret key")
"Hi there"

iex(3)> SimpleCrypto.sha256("Turn me into SHA256")
"87A3AABED406EFBCD4956E2E32E75948DB88E7ED35CACD4D8B66669EA849C102"

iex(4)> SimpleCrypto.hmac("HMAC me now!", "secret key")
"E7235176D81E29EC202B117324C7B3A2A6180F2A2A163D79E5A6BB58E7A61A7B"

iex(5)> SimpleCrypto.rand_str(32)
"rvbAtDMdVPJu2J-QDyAxgOLAL0LQWL0w"

iex(6)> SimpleCrypto.rand_int_str(6)
"811238"

iex(7)> SimpleCrypto.otp_rand_str(16)
"UXGMUXNUANHONKZR"

iex(8)> SimpleCrypto.id_rand_str(12)
"SWm6fDWvd4id"

iex(9)> SimpleCrypto.pad("123", 8, ".")
"123....."

Full documentation can be found at [https://hexdocs.pm/simple_crypto](https://hexdocs.pm/simple_crypto).
