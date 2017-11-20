### Dump file formats
 * [Stack Overflow](https://github.com/collab-uniba/dataset_best-answers_emse/tree/master/dumps/stackoverflow)
     * CSV file (separator=;)
       * `question_id`: numeric, unique identifier
       * `question_body`: string, enclosed by `"`, with HTML tags
       * `question_title`: string
       * `question_tags`: string, comma separated list of tags
       * `accepted_answer_id`:  id of the question accepted as solution or empty otherwise
       * `answers_count`: numeric, number of answers in the question thread
       * `question_date`: string, formatted as %Y-%m-%d %H:%M:%S
       * `answer_id`: numeric, unique identifier
       * `answer_date`: string, formatted as %Y-%m-%d %H:%M:%S
       * `answer_upvotescore`: number, upvotes-downvotes received
       * `answer_body`: string, enclosed by `"`, with HTML tags
 * [Yahoo! Answers](https://github.com/collab-uniba/dataset_best-answers_emse/tree/master/dumps/yahoo)
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
 * [Sap Community Network (SCN)](https://github.com/collab-uniba/dataset_best-answers_emse/tree/master/dumps/scn)
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
 * [Dwolla](https://github.com/collab-uniba/dataset_best-answers_emse/tree/master/dumps/dwolla)
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
 * [Docusign](https://github.com/collab-uniba/dataset_best-answers_emse/tree/master/dumps/docusign)
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
