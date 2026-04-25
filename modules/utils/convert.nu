def to-base [base: int] {
  let num = $in
  let digits = "0123456789abcdefghijklmnopqrstuvwxyz"

  if $num == 0 {
    return "0"
  }

  mut result = ""
  mut n = $num

  while $n > 0 {
    let remainder = $n mod $base
    let digit = ($digits | str substring $remainder..$remainder)
    $result = $digit + $result
    $n = ($n / $base) | math floor
  }

  $result
}
