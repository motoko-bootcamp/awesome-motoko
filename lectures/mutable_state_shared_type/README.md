## Prerequisites

- Read [this](https://smartcontracts.org/docs/language-guide/mutable-state.html)
- [this](https://smartcontracts.org/docs/language-guide/sharing.html)

## Things we'll cover

- `let` vs `var`
- immutable vs mutable arrays
- `Array` module from the base library - https://smartcontracts.org/docs/base-libraries/Array.html
  - freeze
  - thaw
  - tabulate
- Example of a Pub Sub implementation

## Takeaways

- As a rule of thumb, start with an immutable variable and change it when the situation demands.
- Sharing state requires that state to be sharable.

## Resources

- [pubsub example](https://github.com/dfinity/examples/tree/master/motoko/pub-sub)
