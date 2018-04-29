# Compute the distribution of answer upvotes in the 5 experimental datasets

docusign <- read.csv("input/docusing.csv", header = TRUE, sep=";")
docusign_answers <- docusign[is.na(docusign$question_uid),]
nrow(docusign_answers)
no_upv <- nrow(docusign_answers[docusign_answers$upvotes ==0,])
no_upv
upv <- nrow(docusign_answers[docusign_answers$upvotes >0,])
upv
print(round((upv * 100) / (upv + no_upv), 1))
min(docusign_answers$upvotes)
max(docusign_answers$upvotes)
mean(docusign_answers$upvotes)
median(docusign_answers$upvotes)
stats::sd(docusign_answers$upvotes)

dwolla_answers <- read.csv("input/dwolla.csv", header = TRUE, sep=";")
nrow(dwolla_answers)
no_upv <- nrow(dwolla_answers[dwolla_answers$upvotes ==0,])
no_upv
upv <- nrow(dwolla_answers[dwolla_answers$upvotes >0,])
upv
print(round((upv * 100) / (upv + no_upv), 1))
min(dwolla_answers$upvotes)
max(dwolla_answers$upvotes)
mean(dwolla_answers$upvotes)
median(dwolla_answers$upvotes)
stats::sd(dwolla_answers$upvotes)

yahoo <- read.csv("input/yahoo.csv", header = TRUE, sep=";")
yahoo_answers <- yahoo[is.na(yahoo$question_uid),]
nrow(yahoo_answers)
no_upv <- nrow(yahoo_answers[yahoo_answers$upvotes ==0,])
no_upv
upv <- nrow(yahoo_answers[yahoo_answers$upvotes >0,])
upv
print(round((upv * 100) / (upv + no_upv), 1))
min(yahoo_answers$upvotes)
max(yahoo_answers$upvotes)
mean(yahoo_answers$upvotes)
median(yahoo_answers$upvotes)
stats::sd(yahoo_answers$upvotes)

scn_answers <- read.csv("input/scn.csv", header = TRUE, sep=",")
nrow(scn_answers)
no_upv <- nrow(scn_answers[scn_answers$upvotes ==0,])
no_upv
upv <- nrow(yahoo_answers[scn_answers$upvotes >0,])
upv
print(round((upv * 100) / (upv + no_upv), 1))
min(scn_answers$upvotes)
max(scn_answers$upvotes)
mean(scn_answers$upvotes)
median(scn_answers$upvotes)
stats::sd(scn_answers$upvotes)

so_answers <- read.csv('input/so_341k.csv', header = TRUE, sep=",")
nrow(so_answers)
no_upv <- nrow(so_answers[so_answers$upvotes ==0,])
no_upv
upv <- nrow(yahoo_answers[so_answers$upvotes >0,])
upv
print(round((upv * 100) / (upv + no_upv), 1))
min(so_answers$upvotes)
max(so_answers$upvotes)
mean(so_answers$upvotes)
median(so_answers$upvotes)
stats::sd(so_answers$upvotes)
