# Sales-report-automation
## About
An automation framework that uses RMarkdown to generate and email periodic parameterized sales reports. 🛠⚙    

## Packages used
The following librarires were used to facilitate this project

![tidyverse](tidverse.png)
![readxl](readxl.png)
![ggplot2](ggplot2.png)
![glue](glue.png)
![fs](fs.png)
![dplyr](dplyr.png)
![blastula](blastula.svg)



## PHASE I:
The project begins with the inspection of sales data. The data is stored in an Excel worksheet called `2.-Badly-Structured-Sales-Data-2.xlsx`. 
It is loaded into R via the `readxl` package.
Inspection is necessary to ensure that the data being analysed is in the right format.(tidy data) 
As expected, the sales data is messy and thus need cleaning to facilitate valid visualisation & analysis.
The `tidyverse` group of packages is employed for this task.  

### Data cleaning - highlights
The sales data initially had a wide format structure with missing value cases (NAs). 
For easier Statistical computation, it had to be converted to long format. The `reshape2` package facilitated this transition. All missing values were dropped.
The ISO date format (YYYY-MM-DD) was implemented to allow for feature engineering of the data.
Goods are categorised into 3 distinct segments each having 4 unique shipping modes. 
As a result of this, I split the data through `dplyr`'s filtering pipeline into `12 dataframes` representative of all possible segment-shipping mode combinations.
This was to ensure that I end up with two independent columns representing the segment type and shipping mode of each order.
Next, I merged all 12 dataframes and ended up with a time-ordered tidy version of the sales data running from `January 2013` upto `December 2016`. 
The tidy version of the sales data is written to a csv file `clean_sales.csv`


## PHASE II:
### Setting up the report template
For this phase, I set up the template to be used for reporting periodic sales. Parameterised reports are similar to `functions`, where the quarto template document (`.qmd` file)
is the `function`, the parameter is the `input` and the report is the `ouput` (Jadey, 2020). 
Parameters can be `character`, `integer`, `numeric` or `logical` values.  
Initially, I had planned to use `quarto` but ended up at `RMarkdown` due to debugging woes.
In my case I used two parameters: month, an ordered factor and year a numeric variable. These parameters were used in the code chunks to filter through the sales data.     
This was the automation roadmap that I used provided by `Jadey Ryan`.

### 1. Setting and using parameters
The parameters are well-defined in the YAML header within the `sales.Rmd` file under `params` section. 
They are accessed in the report content and code chunks as `params$year` and `params$month` for `year` and `month` variablres respectively.

### 2. Rendering one-at-a-time
Render reports one at a time by changing parameter values manually. The month `January` and year `2013` are set as the default parameter values.

### 3. Rendering all at once
Automate the rendering of all report variations with a script. The file `sales_Automation.R` renders all the sales reports using only 100 lines of code.

****

The sales template is the file `sales.Rmd`  

## PHASE III:
### Mailing the reports
This activity was not in the initial framework of this project. I consulted `chatGPT` on the possibility of sending emails through R. 
The result came out poitive and therefore I decided to append this section to the project.

Sending emails through R is made possible by the packages `blastula` and `keyring`.Requirements include: a sender and receipient email address and the SMTP log-in credentials for Google.
These credentials are encrypted via the `keyring` library ,ensuring password information is not exposed within an R script.
`blastula`'s `send_email()` function allows one to send email to any valid email address under any domain. However, the sender's email address is restricted to the `gmail` domain.
In order to validate blastula's capabilities, I used two of my email addresses; `pambagee@gmail.com` as the sender and `giftbugame@yahoo.com` as the recepient 

### Putting it all together
The `sales_Automation.R` script is the backbone of this project. It imports the cleaned sales data, renders the reports and emails them. 
The last two tasks are executed within two `for` loops whosw counters are `select_yr` and `select_month` that capture all the months within the years.  

These tasks are executed within the loops:

- The parameterised reports are rendered with respect to the parameter values in the set working directory
- Drafting and sending of emails with the report(s) attached
- Creation of new folders tha store monthly reports as per their respective years
- Relocation of sales reports from the working directory to their designated annual folder 
      
### Challenges encountered
Execution of this project was not short of challenges. Here are some of the challenges I faced and how they were resolved.

Quarto debugging
*****
I run into numerous bugs while attempting to use Quarto for rendering the sales reports. 95% of them involved caching issues on the parameterised .qmd version of `sales.Rmd`. 
The ggplot bar graphs were the most affected by this. On inspection of the rendered reports, all of them had data on `December 2016`. I therefore switched to RMarkdown and the caching problems were solved.
 
Email credentials
*****
The blastula library offered great help in drafting and sending emails via R. However, my email credentials were at risk of exposure within the rendering script. 
As a solution the `keyring` package came to my rescue and handled the SMTP encryption that ensured my email details were not exposed at the expense of this project.      


## Conclusion
I would first like to thank Dr. Thomas Mawora for his valued contribution to this project. He led me to investigate on RMarkdown/Quarto automation in R.
A few months later and here we are! The Sales-automation project is now complete.   
In colclusion ,automation is possible and fun in R!  


