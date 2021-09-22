defmodule SimpleCrypto do
  require Logger

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

  def sha256(str) do
    :crypto.hash(:sha256, str) |> Base.encode16()
  end

  def hmac(str, key) do
    :crypto.mac(:hmac, :sha256, key, str) |> Base.encode16()
  end

  def rand_str(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  def rand_int_str(num_of_digits) do
    len = :math.pow(10, num_of_digits) |> round()

    Enum.random(0..len)
    |> Integer.to_string()
    |> String.pad_leading(4, "0")
  end

  def otp_rand_str(length \\ 16) do
    String.replace(String.replace(String.upcase(rand_str(length)), ~r([-_]), "N"), ~r(\d), "U")
  end

  def id_rand_str(length) do
    String.replace(rand_str(length), ~r([-_]), "w")
  end

  def pad(binary, width \\ 16, char \\ " ") do
    # TODO: Use String.pad_trailing/2 instead?
    case rem(width - rem(byte_size(binary), width), width) do
      0 -> binary
      n -> binary <> String.duplicate(char, n)
    end
  end
end
