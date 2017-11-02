
### Formats
 * SO %% Consider providing a sql or csv file export %%
   * CSV file (separator=;)
     * ``
     * ``
     * ``
     * ``
     * ``
     * ``
     * ``
     * ``
     * ``
     * ``
     * ``
     * ``
 * YA
   * CSV file (separator=;)
     * `date_time`: integer, with format yyyy-dd-mm HH:MM:SS (in Python, convert as `datetime.datetime.fromtimestamp(int(...))`)
     * `uid`: unique post identifier
     * `type`: question or answer
     * `author`: name of the author
     * `title`: title of question (inherited by answers)
     * `text`: body of the post
     * `views`: number time the thread/answer has been visualized
     * `answers`: number of answers received by a question (irrelevant for answers)
     * `url`: direct link to the thread/answer
     * `tags`: commaseparated list of tags
     * `upvotes`: number of upvotes received by the question/answer
     * `resolve`: boolean, accepted solution or not (irrelevant for questions)
 * SCN
   * JSON files, one per topic
     ``` 
       {  
         "date_time": formatted as yyyymmdd HH:MM:SS,
         "resolve": boolean, accepted solution or not (irrelevant for questions),
         "uid": unique post identifier,
         "title": title of question (inherited by answers),
         "url": direct link to the thread/answer,
         "text": body of the post,
         "views": number time the thread/answer has been visualized,
         "answers": number of answers received by a question (irrelevant for answers),
         "author": name of the author,
         "upvotes": number of upvotes received by the question/answer,
         "type": question or answer,
         "tags":"sap_visual_enterprise.opacity"
       } 
     ```
 * Dwolla
   * CSV file (separator=;)
     * `date_time`: formatted as dd/mm/yy HH:MM
     * `resolve`: boolean, accepted solution or not (irrelevant for questions)
     * `uid`: unique post identifier
     * `type`: question or answer
     * `views`: number time the thread/answer has been visualized
     * `answers`: number of answers received by a question (irrelevant for answers)
     * `upvotes`: number of upvotes received by the question/answer
     * `author`: name of the author
     * `title`: title of question (inherited by answers)
     * `text`: body of the post
     * `url`: direct link to the thread/answer
 * Docusign
   * CSV files (separator=;), separated per API programming language (i.e., .NET, Java, Python, PHP, Other)
     * `date_time`: formatted as dd/mm/yyyy HH:MM:SS
     * `resolve`: boolean, accepted solution or not (irrelevant for questions)
     * `uid`: unique post identifier
     * `title`: title of question (inherited by answers)
     * `url`: direct link to the thread/answer
     * `text`: body of the post
     * `views`: number time the thread/answer has been visualized
     * `answers`: number of answers received by a question (empty for answers)
     * `author`: name of the author
     * `upvotes`: number of upvotes received by the question/answer
     * `type`: question or answer
     * `tags`: commaseparated list of tags
