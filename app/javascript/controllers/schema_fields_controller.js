import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["list", "preview"]

  connect() {
    this.sortable = Sortable.create(this.listTarget, {
      animation: 150,
      handle: ".drag-handle",
      onEnd: this.reorder.bind(this)
    });

    this.updatePreview()
  }

  reorder(event) {
    const ids = [...this.listTarget.querySelectorAll("[data-id]")].map(el => el.dataset.id)

    fetch(this.data.get("reorderUrl"), {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ order: ids })
    });
  }

  updatePreview() {
    const schemaString = this.data.get("schemaJson")
    if (this.previewTarget) {
      this.previewTarget.innerHTML = JSON.stringify(JSON.parse(schemaString), null, 2)
    }
  }
}

