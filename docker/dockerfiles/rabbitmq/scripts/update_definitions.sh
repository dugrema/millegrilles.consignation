#!/usr/bin/env bash

cat definitions.json | \
sed 's/\"sansnom\"/\"maple\"/' - |
sed 's/\"middleware\"/\"mathieu\"/' - \
> definitions2.json
