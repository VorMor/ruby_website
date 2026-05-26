categories = [
  { name: "Завтраки", description: "Быстрые и сытные блюда для начала дня.", color: "#f59e0b" },
  { name: "Супы", description: "Домашние супы для будней и выходных.", color: "#22c55e" },
  { name: "Горячее", description: "Основные блюда из мяса, птицы, рыбы и овощей.", color: "#ef4444" },
  { name: "Салаты", description: "Легкие и праздничные салаты.", color: "#14b8a6" },
  { name: "Выпечка", description: "Пироги, булочки и другая домашняя выпечка.", color: "#a855f7" }
].index_by { |category| category[:name] }

categories.each_value do |attrs|
  Category.find_or_initialize_by(name: attrs[:name]).tap do |category|
    category.assign_attributes(attrs)
    category.save!
  end
end

ingredient_names = [
  "курица", "картофель", "морковь", "лук", "рис", "яйцо", "молоко", "мука",
  "творог", "помидор", "огурец", "сыр", "сметана", "говядина", "свекла",
  "капуста", "чеснок", "укроп", "овсяные хлопья", "яблоко", "рыба", "лимон"
]

ingredient_names.each do |name|
  Ingredient.find_or_create_by!(name: name) do |ingredient|
    ingredient.description = "Популярный ингредиент для домашней кухни."
  end
end

recipes = [
  {
    title: "Овсяная каша с яблоком",
    category: "Завтраки",
    description: "Нежная каша на молоке с яблоком и легкой сладостью.",
    instructions: "Вскипятите молоко. Добавьте овсяные хлопья и варите 5 минут. Натрите яблоко, добавьте в кашу и прогрейте еще минуту.",
    cooking_time: 12,
    servings: 2,
    difficulty: "easy",
    image_url: "https://images.meme-arsenal.com/9119dbf0e54dc3cb8c1317ca677cc92f.jpg",
    ingredients: [
      [ "овсяные хлопья", 80, "г" ],
      [ "молоко", 300, "мл" ],
      [ "яблоко", 1, "шт" ]
    ]
  },
  {
    title: "Куриный суп с рисом",
    category: "Супы",
    description: "Простой домашний суп с прозрачным бульоном и овощами.",
    instructions: "Отварите курицу до готовности. Добавьте картофель, морковь, лук и рис. Варите до мягкости овощей, затем добавьте укроп.",
    cooking_time: 45,
    servings: 4,
    difficulty: "medium",
    image_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8Zno8NwCdGLeOGlZRzh_twQdhUIN3XciQWg&s",
    ingredients: [
      [ "курица", 400, "г" ],
      [ "картофель", 3, "шт" ],
      [ "морковь", 1, "шт" ],
      [ "лук", 1, "шт" ],
      [ "рис", 60, "г" ],
      [ "укроп", nil, "по вкусу" ]
    ]
  },
  {
    title: "Борщ со сметаной",
    category: "Супы",
    description: "Классический насыщенный борщ с говядиной, свеклой и капустой.",
    instructions: "Сварите бульон из говядины. Добавьте картофель и капусту. Свеклу, морковь и лук потушите отдельно, затем переложите в суп и доведите вкус чесноком.",
    cooking_time: 95,
    servings: 6,
    difficulty: "hard",
    image_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5w8nz-XlF9Nf1-QudQh0IMYnUyDJBnsMufw&s",
    ingredients: [
      [ "говядина", 500, "г" ],
      [ "свекла", 2, "шт" ],
      [ "капуста", 300, "г" ],
      [ "картофель", 3, "шт" ],
      [ "чеснок", 2, "зубчика" ],
      [ "сметана", nil, "для подачи" ]
    ]
  },
  {
    title: "Салат с помидорами, огурцами и сыром",
    category: "Салаты",
    description: "Свежий салат на каждый день с простой сметанной заправкой.",
    instructions: "Нарежьте овощи, добавьте кубики сыра, посолите и заправьте сметаной. Перед подачей посыпьте укропом.",
    cooking_time: 10,
    servings: 3,
    difficulty: "easy",
    image_url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5bhT43g6MGejDGoPQ10pxADiFpIci2Y_rCA&s",
    ingredients: [
      [ "помидор", 2, "шт" ],
      [ "огурец", 2, "шт" ],
      [ "сыр", 120, "г" ],
      [ "сметана", 2, "ст. л." ],
      [ "укроп", nil, "по вкусу" ]
    ]
  },
  {
    title: "Курица с картофелем в духовке",
    category: "Горячее",
    description: "Сытное блюдо для семейного ужина с румяной корочкой.",
    instructions: "Нарежьте картофель, смешайте с луком и специями. Сверху выложите курицу, запекайте при 190 градусах около 50 минут.",
    cooking_time: 65,
    servings: 4,
    difficulty: "medium",
    image_url: "https://i.ytimg.com/vi/orWIAaOUXR8/maxresdefault.jpg",
    ingredients: [
      [ "курица", 700, "г" ],
      [ "картофель", 6, "шт" ],
      [ "лук", 1, "шт" ],
      [ "чеснок", 2, "зубчика" ]
    ]
  },
  {
    title: "Творожные сырники",
    category: "Завтраки",
    description: "Мягкие сырники с золотистой корочкой для завтрака или полдника.",
    instructions: "Смешайте творог, яйцо и муку. Сформируйте сырники, обжарьте на среднем огне до румяности и подавайте со сметаной.",
    cooking_time: 25,
    servings: 3,
    difficulty: "medium",
    image_url: "https://www.tablicakalorijnosti.ru/file/image/foodstuff/2a9b7308c2144435a4d704781407ebc7/83d2e4c4b3fc44c0a1f5b9da1447d1f7",
    ingredients: [
      [ "творог", 400, "г" ],
      [ "яйцо", 1, "шт" ],
      [ "мука", 3, "ст. л." ],
      [ "сметана", nil, "для подачи" ]
    ]
  }
]

recipes.each do |attrs|
  recipe = Recipe.find_or_initialize_by(title: attrs[:title])
  recipe.assign_attributes(attrs.except(:category, :ingredients).merge(category: Category.find_by!(name: attrs[:category])))
  recipe.save!

  attrs[:ingredients].each do |name, amount, unit|
    ingredient = Ingredient.find_by!(name: name)
    recipe.recipe_ingredients.find_or_initialize_by(ingredient: ingredient).tap do |recipe_ingredient|
      recipe_ingredient.amount = amount
      recipe_ingredient.unit = unit
      recipe_ingredient.save!
    end
  end
end

AdminUser.ensure_default_admin!