module RussianSlug
  MAP = {
    "а" => "a", "б" => "b", "в" => "v", "г" => "g", "д" => "d", "е" => "e",
    "ё" => "e", "ж" => "zh", "з" => "z", "и" => "i", "й" => "y", "к" => "k",
    "л" => "l", "м" => "m", "н" => "n", "о" => "o", "п" => "p", "р" => "r",
    "с" => "s", "т" => "t", "у" => "u", "ф" => "f", "х" => "h", "ц" => "ts",
    "ч" => "ch", "ш" => "sh", "щ" => "sch", "ъ" => "", "ы" => "y", "ь" => "",
    "э" => "e", "ю" => "yu", "я" => "ya"
  }.freeze

  module_function

  def call(value)
    value.to_s.downcase.each_char.map { |char| MAP.fetch(char, char) }.join
      .gsub(/[^a-z0-9]+/, "-")
      .gsub(/\A-|-+\z/, "")
  end
end
