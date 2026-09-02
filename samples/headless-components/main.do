import { button, div, domDocument, heading, input, p, section } from "std/dom"

function snapshot(name: string): none {
  println("\n--- ${name} ---")
  println(domDocument().body().innerHtml())
}

function main(): int {
  document := domDocument()
  status := <p className="status">2 tasks remaining</p>
  filter := <input id="filter" value="all" ariaLabel="Task filter"/>
  first := <div id="write-tests" className="task">Write tests</div>
  second := <div id="ship-release" className="task">Ship release</div>
  action := <button onClick=>{
    status.setText("The browser would run this handler")
  }>Complete next task</button>

  list := <div className="task-list">{first}{second}</div>
  app := <section id="tasks">
    <heading level=2>Release checklist</heading>
    {status}
    {filter}
    {list}
    {action}
  </section>
  app.appendTo(document.body())
  snapshot("initial render")

  filter.setValue("remaining")
  status.setText("1 task remaining")
  second.setClassName("task task--urgent").insertBefore(first)
  snapshot("state update and keyed reorder")

  second.unmount()
  snapshot("temporarily unmounted")
  second.insertAfter(first)
  snapshot("same handle reattached")

  replacement := <div id="write-docs" className="task">Write release notes</div>
  replacement.replace(first)
  snapshot("element replaced")

  app.clearEventHandlers(true)
  action.dispose()
  snapshot("handlers cleared and action disposed")

  app.dispose()
  snapshot("component disposed")
  return 0
}
