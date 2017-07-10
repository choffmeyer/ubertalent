### Description
Ubertalent.io sources

### Overview
#### v1.0.x
```
We would like you to create the landing page and job page from the mongodb jobs using rails or sinatra. You may choose the ruby framework and use which ever is fastest for you. Please let me know if you have any questions.

You should be receiving an invite to slack and heroku from Craig Hoffmeyer for the project.

Overview and Requirements:
(1) Using Heroku and MongoDB for project. The initial setup has been completed as:
+ Domain & config for AWS completed
+ MongoDB with simple job model that includes:
[a] job title
[b] job description
[c] job post date
[d] company name
[e] tags
[f] published (true/false)
[g] expired (true/false)
[h] job URL
[i] job location
[j] remote (true/false)

(2) We are using bootstrap template [https://www.dropbox.com/s/wgn355jz80rrz6k/layout-10.zip?dl=0] for the project.

(3) Create landing page based on bootstrap template
â€˜Freelanceâ€™ remote work for Designers, Developers, & Writers
Page goes to same Mailchimp form/list (List name - Candidates)
Use CSS to style section that shows preview of last 10 jobs with "Show More" link to Jobs Page
Also, I will provide Mailchimp API tokens or login when you are ready.

(4) Create Jobs Page to show active jobs in database
[a] List jobs and allow filters by dev, design, writer 
[b] Search jobs
[c] Don't show jobs that are not published

(5) Automate Weekly Email (Mailchimp API)
Send email of new jobs scraped in the last week (last 7 days)
Categorize by Designer, Developer, & Writer
Send new jobs to each specific segment


Related sites for the job listing page that have simple filters:
https://www.workingnomads.co/jobs
https://authenticjobs.com/
```

### Local installation
Ensure you have installed ruby 2.4.0.

Run terminal and type following commands:
```
$ gem install bundler
$ bundle install
$ gem install foreman
$ foreman start
```

### Heroku installation
Add heroku remote and run:
```
$ git push heroku master
```
