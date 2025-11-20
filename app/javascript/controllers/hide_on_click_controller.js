import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hide-on-click"
export default class extends Controller {
  hide(event) {
    this.element.remove()
  }
  hide_parent(event) {
    this.element.parentElement.remove()
  }
  hide_grandparent(event) {
    this.element.parentElement.parentElement.remove()
  }
}
