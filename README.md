# Dataset and R scripts for best-answers prediction in Technical Q&A sites

## Datasets
Data have been retrieved from the following technical Q&A sites
* Modern platforms
  * [Stack Overflow (SO)](https://www.stackoverflow.com) 
  * [Yahoo! Answer (YA)](https://answers.yahoo.com/dir/index?sid=396545663&link=list) (category: _Programming & Design_)
  * [SAP Community Network (SCN)](https://www.sap.com/community.html) (topics: _Hana_, _Mobility_, _NetWeaver_, _Cloud_, _OLTP_, _Streaming_, _Analytic_, _PowerBuilder_, _Cross_, _3d_, _Frontend_, _ABAP_)
* Legacy platforms
  * [Dwolla](https://discuss.dwolla.com/c/api-support) (discontinued, read-only)
  * [Docusign](https://www.docusign.com) (discontinued, unavailable)
  
### Formats
* SO
* YA
  * CSV file (separator=;)
    * `date_time`: double (long) format 1122483646
    * `uid`: unique post identifier
    * `type`: question or answer
    * `author`: id of the authors
    * `title`: title of question (inherited by answers)
    * `text`: body of the post
    * `views`: number time the thread/answer has been visualized
    * `answers`: number of answers received by a question (empty for answers)
    * `url`: direct link to the thread/answer
    * `tags`: comma-separated list of tags
    * `upvotes`: number of upvotes
    * `resolve`: boolean, accepted solution or not
* SCN
* Dwolla
  * CSV file (separator=;)
    * `date_time`: formatted as dd/mm/yy HH:MM
    * `resolve`: boolean, accepted solution or not
    * `uid`: unique post identifier
    * `type`: question or answer
    * `views`: number time the thread/answer has been visualized
    * `answers`: number of answers received by a question (empty for answers)
    * `upvotes`: number of upvotes
    * `author`: id of the authors
    * `title`: title of question (inherited by answers)
    * `text`: body of the post
    * `url`: direct link to the thread/answer
* Docusign
  * CSV files (separator=;), separated per API programming language (i.e., .NET, Java, Python, PHP, Other)
    * `date_time`: formatted as dd/mm/yyyy HH:MM:SS
    * `resolve`: boolean, accepted solution or not
    * `uid`: unique post identifier
    * `title`: title of question (inherited by answers)
    * `url`: direct link to the thread/answer
    * `text`: body of the post
    * `views`: number time the thread/answer has been visualized
    * `answers`: number of answers received by a question (empty for answers)
    * `author`: id of the authors
    * `upvotes`: number of upvotes
    * `type`: question or answer
    * `tags`: comma-separated list of tags

## R scripts
