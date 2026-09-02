# Headless component snapshots

This native sample treats the headless DOM like a small component runtime. It
prints deterministic snapshots while mutating form state, reordering retained
element handles, unmounting and reattaching an element, replacing an element,
clearing event handlers, and disposing subtrees.

Run it from the standard-library workspace:

```sh
doof run dom/samples/headless-components
```

`unmount()` is used for a node that will return. `dispose()` is used when a node
or component has reached its permanent lifecycle boundary.
