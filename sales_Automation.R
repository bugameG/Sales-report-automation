# LOADING LIBRARIES
library(readr)
library(tidyverse)
library(fs)
library(glue)
library(rmarkdown)
library(blastula)
library(keyring)

# LOADING CLEANED SALES DATA
clean_sales <- read_csv("clean_sales.csv")
# View(clean_sales)

# FACTORISING `ship.mode` and `segment` columns
clean_sales$ship.mode <- as.factor(clean_sales$ship.mode)
clean_sales$segment <- as.factor(clean_sales$segment)

# ADDING TIME-BASED COLUMNS FOR EASY TIME AGGREGATION
clean_sales <- clean_sales |> 
  mutate(week = week(order.date), ## week
         month = month(order.date,label = TRUE, abbr = FALSE), ## month
         quarter = quarter(order.date), ## quarter
         year = year(order.date))  ## year


## DEFINING LOOP PARAMETERS -- month & year
all_years <- unique(clean_sales$year)
all_months <- levels(clean_sales$month)


## SETTING UP SMTP EMAIL PASSWORD
# create_smtp_creds_key(id = "gmail_secret",
#                        user = "pambagee@gmail.com",
#                        provider = "gmail")


## STORING PASSWORD WITHIN A CREDENTIALS KEY VIA `keyring`
creds <- creds_key(id = "gmail_secret")


## RENDERS ALL 48 REPORTS, MAILING THEM TO RELEVANT ADDRESSES
for (select_yr in all_years) {
  for (select_month in all_months) {
  
    # Rendering periodic report(s)
   render(input = "sales.Rmd",
                params = list(month = select_month,
                                      year = select_yr),
                output_file = glue("Sales Report {select_month}-{select_yr}.html"),
                clean = TRUE)
   
    
    # Composing email
    email <- compose_email(
      title = md("
# Sales Report
                           "),
      header = paste(select_yr,select_month,"- Pinnacle Upholsters Sales Report"),
      body = md(
        "
Hello,

Please find attached the monthly sales report.

                  "),
      footer = md(
        "
### Regards,

#### Sales Department
                  ")
    ) |>  ## Attaching the sales report to email
      add_attachment(file = glue("Sales Report {select_month}-{select_yr}.html"))
    
    ## Sends the attached email
    smtp_send(email = email,
              from = "pambagee@gmail.com",
              to = "giftbugame@yahoo.com",
              subject = "Monthly Sales Report",
              credentials = creds,
  )
    ## PRINTS OUT THE EMAIL STATUS REPORT
    print(paste(select_yr,select_month,"email report sent!"))
    
    
    # Creation of yearly folder(s) 
   dir_create(select_yr)
   
   # Copying plot images of respective periods
   dir_copy("sales_files",
            path(select_yr,"sales_files"),overwrite = TRUE)
   
   # Moving periodic reports to respective yearly folders
   file_move(
      glue("Sales Report {select_month}-{select_yr}.html"),
              path(select_yr,
                          glue("Sales Report {select_month}-{select_yr}.html")))
      
   }
}
































