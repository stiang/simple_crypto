defmodule SimpleCrypto do
  @moduledoc """
  Simple crypto helpers for Elixir.
  """

  @doc """
  Encrypts `str` using `key` as the encryption key.

  ## Examples
      iex> SimpleCrypto.encrypt("Hi there", "secret key")
      "qCgs4rfReY5nTX39uHwjww=="
  """
  @spec encrypt(iodata, iodata) :: binary
  def encrypt(str, key) do
    Base.encode64(
      :crypto.crypto_one_time(
        :aes_ecb,
        String.slice(pad(key), 0, 32),
        pad(Integer.to_string(byte_size(str)) <> "|" <> str),
        true
      )
    )
  end

  @doc """
  Decrypts `str` using `key` as the decryption key.

  ## Examples
      iex> SimpleCrypto.decrypt("qCgs4rfReY5nTX39uHwjww==", "secret key")
      "Hi there"
  """
  @spec decrypt(iodata, iodata) :: binary
  def decrypt(str, key) do
    decrypted =
      :crypto.crypto_one_time(
        :aes_ecb,
        String.slice(pad(key), 0, 32),
        pad(elem(Base.decode64(str), 1)),
        false
      )

    case Regex.run(~r/(\d+)\|/, decrypted) do
      nil -> decrypted
      [match, len] -> Kernel.binary_part(decrypted, byte_size(match), String.to_integer(len))
    end
  end

  @doc """
  Hashes `str` using the SHA256 algorithm.

  ## Examples
      iex> SimpleCrypto.sha256("Turn me into SHA256")
      "87A3AABED406EFBCD4956E2E32E75948DB88E7ED35CACD4D8B66669EA849C102"
  """
  @spec sha256(iodata) :: binary
  def sha256(str) do
    :crypto.hash(:sha256, str) |> Base.encode16()
  end

  @doc """
  Use `key` to generate a hash value of `str` using the HMAC method.

  ## Examples
      iex> SimpleCrypto.hmac("HMAC me now!", "secret key")
      "E7235176D81E29EC202B117324C7B3A2A6180F2A2A163D79E5A6BB58E7A61A7B"
  """
  @spec hmac(iodata, iodata) :: binary
  def hmac(str, key) do
    :crypto.mac(:hmac, :sha256, key, str) |> Base.encode16()
  end

  @doc """
  Generate a random string of `length` length.

  ## Examples
      iex> SimpleCrypto.rand_str(32)
      "rvbAtDMdVPJu2J-QDyAxgOLAL0LQWL0w"
  """
  @spec rand_str(non_neg_integer) :: binary
  def rand_str(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  @doc """
  Generate a random string of `length` length, consisting only of integers.

  ## Examples
      iex> SimpleCrypto.rand_int_str(6)
      "811238"
  """
  @spec rand_int_str(non_neg_integer) :: binary
  def rand_int_str(num_of_digits) do
    len = :math.pow(10, num_of_digits) |> round()

    Enum.random(0..len)
    |> Integer.to_string()
    |> String.pad_leading(4, "0")
  end

  @doc """
  Generate a random string of `length` length that is suitable to use as OTP codes.

  ## Examples
      iex> SimpleCrypto.otp_rand_str(16)
      "UXGMUXNUANHONKZR"
  """
  @spec otp_rand_str(non_neg_integer) :: binary
  def otp_rand_str(length \\ 16) do
    String.replace(String.replace(String.upcase(rand_str(length)), ~r([-_]), "N"), ~r(\d), "U")
  end

  @doc """
  Generate a random string of `length` length that is suitable to use as an 
  easily copy/pastable ID (no hyphens or other problematic characters).

  ## Examples
      iex> SimpleCrypto.id_rand_str(12)
      "SWm6fDWvd4id"
  """
  @spec id_rand_str(non_neg_integer) :: binary
  def id_rand_str(length) do
    String.replace(rand_str(length), ~r([-_]), "w")
  end

  @doc """
  Pad the end of `str` using `char`, so that the total length is `length`.

  ## Examples
      iex> SimpleCrypto.pad("123", 8, ".")
      "123....."
  """
  @spec pad(iodata, non_neg_integer, iodata) :: binary
  def pad(str, length \\ 16, char \\ " ") do
    # TODO: Use String.pad_trailing/2 instead?
    case rem(length - rem(byte_size(str), length), length) do
      0 -> str
      n -> str <> String.duplicate(char, n)
    end
  end
end
