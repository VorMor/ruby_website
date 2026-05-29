class RecipeSearch
  def initialize(params, scope: Recipe.published)
    @params = params
    @scope = scope
  end

  def call
    filtered_scope = scope
      .search(params[:q])
      .by_category(params[:category_id])
      .max_time(params[:max_time])
      .with_ingredients(params[:ingredients])

    sort(filtered_scope)
  end

  private

  attr_reader :params, :scope

  # Сортировка вынесена отдельно, чтобы HTML-страница и API не расходились в поведении.
  def sort(filtered_scope)
    case params[:sort]
    when "popular"
      filtered_scope.popular
    when "time"
      filtered_scope.order(cooking_time: :asc, title: :asc)
    else
      filtered_scope.recent
    end
  end
end
