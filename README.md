# SimpleCrypto

Simple crypto helpers for Elixir. Supports both the old and the new `:crypto` API (from OTP22).

## Installation

The package can be installed by adding `simple_crypto` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [{:simple_crypto, "~> 1.0.8"}]
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

iex> SimpleCrypto.sha256_base64("Turn me into base64-encoded SHA256")
"/UWKWh0NJFgCf3mWSIJiDuJA9HCY94T2l/XJ+CyreAM="

iex(4)> SimpleCrypto.hmac("HMAC me now!", "secret key")
"E7235176D81E29EC202B117324C7B3A2A6180F2A2A163D79E5A6BB58E7A61A7B"

iex> SimpleCrypto.hmac_base64("HMAC and base64 me now!", "secret key")
"Xqsja2bp+jfleCkl4bRFZoyljM2RL0DC4PNBkTtKXrk="

iex(5)> SimpleCrypto.rand_str(32)
"rvbAtDMdVPJu2J-QDyAxgOLAL0LQWL0w"

iex(6)> SimpleCrypto.rand_int_str(6)
"811238"

iex(7)> SimpleCrypto.otp_rand_str(16)
"UXGMUXNUANHONKZR"

iex(8)> SimpleCrypto.id_rand_str(12)
"SWm6fDWvd4id"

iex(9)> SimpleCrypto.pad_by_width("The length of this string is 76 before padding, 4 less than a multiple of 16", 16, ".")
"The length of this string is 76 before padding, 4 less than a multiple of 16...."

```

Full documentation can be found at [https://hexdocs.pm/simple_crypto](https://hexdocs.pm/simple_crypto).
