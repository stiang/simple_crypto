defmodule SimpleCrypto do
  @moduledoc """
  Simple crypto helpers for Elixir.
  """

  @doc """
  Encrypts `str` using `key` as the encryption key.

  ## Example
      iex> SimpleCrypto.encrypt("Hi there", "secret key")
      "qCgs4rfReY5nTX39uHwjww=="
  """
  @spec encrypt(iodata, iodata) :: binary
  def encrypt(str, key) do
    encrypt_fun(key, str)
    |> Base.encode64()
  end

  @doc """
  Decrypts `str` using `key` as the decryption key.

  ## Example
      iex> SimpleCrypto.decrypt("qCgs4rfReY5nTX39uHwjww==", "secret key")
      "Hi there"
  """
  @spec decrypt(iodata, iodata) :: binary
  def decrypt(str, key) do
    decrypted = decrypt_fun(key, str)

    case Regex.run(~r/(\d+)\|/, decrypted) do
      nil ->
        decrypted

      [match, len] ->
        Kernel.binary_part(decrypted, byte_size(match), String.to_integer(len))
    end
  end

  @doc """
  Hashes `str` using the SHA256 algorithm.

  ## Example
      iex> SimpleCrypto.sha256("Turn me into SHA256")
      "87A3AABED406EFBCD4956E2E32E75948DB88E7ED35CACD4D8B66669EA849C102"
  """
  @spec sha256(iodata) :: binary
  def sha256(str) do
    :crypto.hash(:sha256, str) |> Base.encode16()
  end

  @doc """
  Hashes `str` using the SHA256 algorithm, then base64-encodes it.

  ## Example
      iex> SimpleCrypto.sha256_base64("Turn me into base64-encoded SHA256")
      "/UWKWh0NJFgCf3mWSIJiDuJA9HCY94T2l/XJ+CyreAM="
  """
  @spec sha256_base64(iodata) :: binary
  def sha256_base64(str) do
    :crypto.hash(:sha256, str) |> Base.encode64()
  end

  @doc """
  Use `key` to generate a hash value of `str` using the HMAC method.

  ## Example
      iex> SimpleCrypto.hmac("HMAC me now!", "secret key")
      "E7235176D81E29EC202B117324C7B3A2A6180F2A2A163D79E5A6BB58E7A61A7B"
  """
  @spec hmac(iodata, iodata) :: binary
  def hmac(str, key) do
    hmac_fun(key, str)
    |> Base.encode16()
  end

  @doc """
  Use `key` to generate a base64-encoded hash value of `str` using the HMAC method

  ## Example
      iex> SimpleCrypto.hmac_base64("HMAC and base64 me now!", "secret key")
      "Xqsja2bp+jfleCkl4bRFZoyljM2RL0DC4PNBkTtKXrk="
  """
  @spec hmac_base64(iodata, iodata) :: binary
  def hmac_base64(str, key) do
    hmac_fun(key, str)
    |> Base.encode64()
  end

  @doc """
  Generate a random string of `length` length.

  ## Example
      iex> SimpleCrypto.rand_str(32)
      "rvbAtDMdVPJu2J-QDyAxgOLAL0LQWL0w"
  """
  @spec rand_str(pos_integer) :: binary
  def rand_str(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  @doc """
  Generate a random string of `length` length, consisting only of integers.

  ## Example
      iex> SimpleCrypto.rand_int_str(6)
      "811238"
  """
  @spec rand_int_str(pos_integer) :: binary
  def rand_int_str(num_of_digits) do
    len = :math.pow(10, num_of_digits) |> round()

    Enum.random(0..len)
    |> Integer.to_string()
    |> String.pad_leading(4, "0")
  end

  @doc """
  Generate a random string of `length` length that is suitable to use as an OTP (One-time pad) code.

  ## Example
      iex> SimpleCrypto.otp_rand_str(16)
      "UXGMUXNUANHONKZR"
  """
  @spec otp_rand_str(pos_integer) :: binary
  def otp_rand_str(length \\ 16) do
    String.replace(String.replace(String.upcase(rand_str(length)), ~r([-_]), "N"), ~r(\d), "U")
  end

  @doc """
  Generate a random string of `length` length that is suitable to use as an 
  easily copy/pastable ID (no hyphens or other problematic characters).

  ## Example
      iex> SimpleCrypto.id_rand_str(12)
      "SWm6fDWvd4id"
  """
  @spec id_rand_str(pos_integer) :: binary
  def id_rand_str(length) do
    String.replace(rand_str(length), ~r([-_]), "w")
  end

  @doc """
  Pad the end of `str` using `padding`, so that the total length becomes a multiple of `width`.

  ## Example
      iex> SimpleCrypto.pad_by_width("The length of this string is 76 before padding, 4 less than a multiple of 16", 16, ".")
      "The length of this string is 76 before padding, 4 less than a multiple of 16...."
  """
  @spec pad_by_width(iodata, pos_integer, iodata) :: binary
  def pad_by_width(str, width \\ 16, padding \\ " ") do
    str_len = byte_size(str)

    case rem(str_len, width) do
      0 -> str
      remainder -> String.pad_trailing(str, str_len - remainder + width, padding)
    end
  end

  @doc """
  DEPRECATED: Use pad_by_width/3 instead.
  """
  @spec pad(iodata, pos_integer, iodata) :: binary
  def pad(str, width \\ 16, padding \\ " ") do
    pad_by_width(str, width, padding)
  end

  if Code.ensure_loaded?(:crypto) and function_exported?(:crypto, :mac, 4) do
    defp hmac_fun(key, str) do
      :crypto.mac(:hmac, :sha256, key, str)
    end

    defp encrypt_fun(key, str) do
      :crypto.crypto_one_time(
        :aes_ecb,
        String.slice(pad_by_width(key), 0, 32),
        pad_by_width(Integer.to_string(byte_size(str)) <> "|" <> str),
        true
      )
    end

    defp decrypt_fun(key, str) do
      :crypto.crypto_one_time(
        :aes_ecb,
        String.slice(pad_by_width(key), 0, 32),
        pad_by_width(elem(Base.decode64(str), 1)),
        false
      )
    end
  else
    defp hmac_fun(key, str) do
      :crypto.hmac(:sha256, key, str)
    end

    defp encrypt_fun(key, str) do
      :crypto.block_encrypt(
        :aes_ecb,
        String.slice(pad(key), 0, 32),
        pad(Integer.to_string(byte_size(str)) <> "|" <> str)
      )
    end

    defp decrypt_fun(key, str) do
      :crypto.block_decrypt(
        :aes_ecb,
        String.slice(pad(key), 0, 32),
        pad(elem(Base.decode64(str), 1))
      )
    end
  end
end
