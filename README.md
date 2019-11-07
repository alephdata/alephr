# alephr

This package aims to provide a simple wrapper for the API exposed by [OCCRP's Aleph tool](https://docs.alephdata.org/). Currently it provides one useful function, `get_xref_results()`, which downloads cross-referencing results for a pair of collections as an R data frame.

The documentation for the Aleph API is available [here](https://tibble.tidyverse.org/).

## Usage

First, make sure you've set the environment variables `ALEPHCLIENT_HOST` and `ALEPHCLIENT_API_KEY`, as described in the [alephclient documentation](https://docs.alephdata.org/developers/alephclient#configuration). This can be done in R using an `.Renviron` file in your working directory - an example is provided as `.Renviron_example` (rename it before use).

To get cross-reference results for a pair of collections, use `get_xref_results()` with the IDs of the collections in question, e.g. `get_xref_results(1, 2)`. Optionally provide a third argument, `limit`, to specify the page size to be used for requests (defaulting to 50).
