parse_xref_results <- function(results) {

  map_dfr(content(results, "parsed")$results, function(result) {

    metadata <- tibble(
      id = result$id,
      score = result$score)

    entity <- map_dfr(result$entity$properties, str_c, collapse = " / ")
    colnames(entity) <- str_c("entity.", colnames(entity))
    entity$entity.url <- result$entity$links$ui

    match <- map_dfr(result$match$properties, str_c, collapse = " / ")
    colnames(match) <- str_c("match.", colnames(match))
    match$match.url <- result$match$links$ui

    bind_cols(metadata, entity, match)
  })
}

request_xref_results <- function(collection_id, match_collection_id, limit, offset) {

  url <- str_c(
    Sys.getenv("ALEPHCLIENT_HOST"), "/api/2/collections/",
    collection_id, "/xref/", match_collection_id)

  GET(
    url = url,
    add_headers(Authorization = str_c(
      "ApiKey ", Sys.getenv("ALEPHCLIENT_API_KEY"))),
    query = list(
      limit = limit,
      offset = offset))
}

get_xref_results <- function(collection_id, match_collection_id, limit = 50) {

  print(str_c("Checking for matches..."))
  initial_results <- request_xref_results(collection_id, match_collection_id, limit, 0)
  total <- content(initial_results, "parsed")$total
  if(!is.null(total)) {
    offsets <- tail(seq(0, total, limit), -1)

    remainder_results <- map(offsets, function(offset) {
      print(str_c("Getting matches ", offset, "-", offset + limit, "..."))
      results <- request_xref_results(collection_id, match_collection_id, limit, offset)
      parse_xref_results(results)
    })

    bind_rows(c(list(parse_xref_results(initial_results)), remainder_results))
  } else {
    print("No matches found! Have you cross-referenced the collections?")
  }
}
