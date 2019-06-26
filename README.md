# First Circle Inventory Management

## Summary

This is a product which allows the user to run batch process that updates items to cleranced.
Apart from it, users can also view a report of the batch

The batch process should handle items that are sellable and make them clearanced.
  * items should only can only be sold if they are sellable.
  * Pants, Dresses discounted price should be limited to 5$.
  * Other types discounted price should be limited to 2$.
  * Provide a batch report for the user

## Installation

```
bundle install
bundle exc rake db:create db:migrate db:seed
```

## Seed

I've updated the seed file a bit to have styles whose wholesale prices
are specific to test the beehavior of the batch process.

```
Sweater -> $5.00
Top     -> $2.67
Dress   -> $4.00
Pants   -> $10.00
Pants   -> $6.67
Scarf   -> $2.00

```