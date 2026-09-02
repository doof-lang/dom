import {
  button, domDocument, form, heading, input, label, p, section,
} from "std/dom"

function main(): int {
  document := domDocument()
  email := <input
    id="email"
    name="email"
    inputType="email"
    value="ada&charles@example.com"
    placeholder="you@example.com"
    ariaLabel="Email address"
  />
  updates := <input
    id="updates"
    name="updates"
    inputType="checkbox"
    checked=true
  />

  signup := <form id="signup" ariaLabel="Newsletter signup">
    <heading level=2>Notes from the engine room</heading>
    <p>{"A native Doof process built this page. <script> is text, not markup."}</p>
    <label htmlFor="email">Email</label>
    {email}
    <label htmlFor="updates">Send me release notes</label>
    {updates}
    <button buttonType="submit">Subscribe</button>
  </form>

  page := <section
    id="content"
    className="landing-page"
    title={"Headless DOM: deterministic & safe"}
  >
    <heading>Doof on the server</heading>
    {signup}
  </section>
  page.setAttribute("data-renderer", "std/dom")
  page.appendTo(document.body())

  println(document.serializeHtml())
  return 0
}
