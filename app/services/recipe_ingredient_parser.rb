class RecipeIngredientParser
  def initialize(raw_text)
    @raw_text = raw_text.to_s
  end

  def rows
    raw_text.lines.filter_map { |line| parse_line(line) }.uniq { |row| row[:name] }
  end

  private

  attr_reader :raw_text

  # Формат строки в форме: название | количество | единица | примечание.
  # Если пользователь ввел только название, ингредиент все равно будет добавлен.
  def parse_line(line)
    parts = line.to_s.strip.split("|", 4).map(&:strip)
    name = normalize_name(parts[0])
    return if name.blank?

    {
      name: name,
      amount: normalize_amount(parts[1]),
      unit: parts[2].to_s.first(30),
      note: parts[3].presence
    }
  end

  def normalize_name(value)
    value.to_s.squish.downcase
  end

  def normalize_amount(value)
    return if value.blank?

    BigDecimal(value.to_s.tr(",", "."))
  rescue ArgumentError
    nil
  end
end
