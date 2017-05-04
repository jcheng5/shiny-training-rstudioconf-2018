get_nyt_archive <- function(year, month, day, api_key ="75f29a4d07eb423096785401b763c22d")
{
  year = as.integer(year)
  month = as.integer(month)
  day = as.integer(day)
  
  stopifnot(!any(is.na(c(year,month,day))))
  stopifnot(year >= 1851)
  stopifnot(month >= 1 & month <= 12)
  stopifnot(day >= 1 & day <= 31)
  
  url = sprintf(
    "https://api.nytimes.com/svc/archive/v1/%d/%d.json?api-key=%s",
    year,month, api_key
  )
  
  date = paste(year, month, day, sep="/") %>% ymd()
  
  d = fromJSON(url,flatten = TRUE)$response$docs
  res = d %>%
    select(web_url,lead_paragraph, print_page, multimedia,
           pub_date, headline = headline.main) %>%
    filter(ymd_hms(pub_date) == date, print_page == 1L) %>%
    mutate(headline = stri_trans_totitle(headline))
  
  stopifnot(is.data.frame(res))
  
  res
}