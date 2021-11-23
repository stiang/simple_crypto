# Changelog

## 1.0.7 (2021-11-23)

* Added `hmac_base64/2`

## 1.0.6 (2021-11-23)

* Fixed Elixir version required

## 1.0.5 (2021-11-23)

* Dynamically use the correct function from OTP, so we can support older versions of Elixir/OTP as well

## 1.0.4 (2021-09-29)

* Fixed bug with `pad/3` that was introduced when this library was extracted from internal code. In that process, our internal pad logic was replaced with `String.pad_trailing/3` in an attempt to clean up the code, without remembering that `pad/3` actually pads by a *multiple* of the length/width parameter. This caused decryption of strings longer than 13 characters to fail.
* Introduced the more explicitly named `pad_by_width/3`
* Deprecated the poorly named `pad/3`

## 1.0.0 (2021-09-22)

* Initial release
* Use new crypto functions in OTP22
