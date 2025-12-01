import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  close() {
    this.element.innerHTML = ""
  }

  backdrop(e) {
    if (e.target === this.element) this.close()
  }

  stop(e) {
    e.stopPropagation()
  }

  connect() {
    this.keyHandler = (e) => {
      if (e.key === "Escape") this.close()
    }
    document.addEventListener("keydown", this.keyHandler)
  }

  disconnect() {
    document.removeEventListener("keydown", this.keyHandler)
  }
}

