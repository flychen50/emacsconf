* What is Epic ?

  Epic is a small elisp to access Evernote process via AppleScript.
  Epic has these functions:

  - Completing read for tags and notebooks:
    + ``epic-read-notebook'', ``epic-read-tag'', ``epic-read-tag-list'' ::
      for the completion of tags and notebooks.

  - Creation of note articles:
    + ``epic-create-note-from-region'', ``epic-create-note-from-file'' ::
      for creation of a new note in your Evernote.app.

  - For Mew users:
    + ``epic-mew-forward-to-evernote'' ::
       Nifty mail forwarder.
       You need to set the vars: ``epic-evernote-mail-address'',
       ``epic-evernote-mail-headers''
    + ``epic-mew-create-note'' ::
       Import a mail article into the local Evernote.app.

  - For Org-mode users:
    With orglue.el (https://github.com/yoshinari-nomura/orglue)
    + Org-mode becomes to recognize evernote:// links.
    + You can drag notes in Evernote.app to an org-mode buffer.
    + ``epic-insert-selected-note-as-org-links''
       for insertion of org-style links.

* Setting Example

  : (require 'epic)
  : (define-key global-map [(control ?:)] 'epic-anything)
  : (define-key mew-summary-mode-map "r" 'epic-mew-create-note)
  : (define-key mew-summary-mode-map "e" 'epic-mew-forward-to-evernote)
  : (setq epic-evernote-mail-address "??????@???.evernote.com")

* Contact Info

  The updated version might be available from:
    http://github.com/yoshinari-nomura/epic
