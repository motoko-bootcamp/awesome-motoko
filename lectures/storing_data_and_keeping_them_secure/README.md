# Storing & Protecting Data on the Internet Computer Protocol

This repository contains the code sample that was used as source material in March 11th Motoko Bootcamp lecture. Feel free to use it and play with the code and try new things.

## How to run

First you need to make sure you have a local replica running:

```sh
dfx start --background --clean
dfx deploy lecture --no-wallet
dfx canister call lecture name
dfx canister call lecture add "(record { name= \"Test Addition\"; description= \"Test Addition Description\" })"
```