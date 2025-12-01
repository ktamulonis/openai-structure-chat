import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["typeSelect", "itemType", "enumValues"]

  connect() {
    this.updateFieldOptions()
  }

  updateFieldOptions() {
    const type = this.typeSelectTarget.value

    this.itemTypeTarget.classList.toggle("hidden", type !== "array")
    this.enumValuesTarget.classList.toggle("hidden", type !== "enum")
  }
}

