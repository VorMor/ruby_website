import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "results", "summary"]

  connect() {
    this.timeout = null
  }

  search(event) {
    if (event.type === "input") {
      clearTimeout(this.timeout)
      this.timeout = setTimeout(() => this.loadResults(), 250)
    } else {
      this.loadResults()
    }
  }

  async loadResults() {
    const params = new URLSearchParams(new FormData(this.formTarget))
    const response = await fetch(`/api/recipes?${params.toString()}`, {
      headers: { "Accept": "application/json" }
    })

    if (!response.ok) return

    const recipes = await response.json()
    this.summaryTarget.textContent = `Найдено рецептов: ${recipes.length}`
    this.resultsTarget.innerHTML = recipes.map((recipe) => this.card(recipe)).join("")
  }

  // Разметка совпадает по смыслу с серверной карточкой, чтобы выдача не менялась после AJAX.
  card(recipe) {
    const image = recipe.image_url ? `<img class="recipe-card-image" src="${recipe.image_url}" alt="${this.escape(recipe.title)}">` : ""

    return `
      <article class="recipe-card">
        ${image}
        <div class="recipe-card-body">
          <div class="recipe-meta-row">
            <span class="pill">${this.escape(recipe.category)}</span>
            <span>${recipe.cooking_time} мин</span>
          </div>
          <h2><a href="${recipe.url}">${this.escape(recipe.title)}</a></h2>
          <p>${this.escape(recipe.description)}</p>
          <div class="recipe-meta-row">
            <span>${this.escape(recipe.difficulty)}</span>
            <span>${recipe.servings} порц.</span>
          </div>
        </div>
      </article>
    `
  }

  escape(value) {
    const element = document.createElement("div")
    element.textContent = value || ""
    return element.innerHTML
  }
}