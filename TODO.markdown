Idea tracking and todo list, to not rely on horrible memory:

Must Have:

* Clean up site, try to "launch"
  * Add instructions
  * Clean up landing page
  * Remove (or hide) references to retrospective/PAT until they are brought in.
* Group naming or identifier
  * Something easier to refer to the group other than the horrific mongo id

Should Have:

* Group people (for pairs or cities)
* Focus iframe on id input
* Tests
* Better data security
* Figure out a way to reduce latency between deselecting all standup members and choosing the next (on all machines but the selecting)
  * probably by moving the selected field to the group
* Last shuffled on date
* human readable group identifier
* Big up and down button for standup participant on a mobile device

Could Have:

* Track standup members emails/users ids
* Require login to see internal pages
  * needs email addresses and google user ids
* Have notification in SA stating that a user didn't enable SA
  * needs email addresses and google user ids
  * gapi.hangout.getEnabledParticipants() [ each -> participant.yc.hasAppEnabled ] (and yc.person.id), notify the iframe
* find all participants in hangout, look up all meteor accounts of people in hangout, guess what group they want

Future:

* Bring back retrospective from git history
* merge in PAT
