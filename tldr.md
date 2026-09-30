Read ./review-inline.txt, a review of a Linux kernel patch that will be
emailed to the patch author and the BPF mailing list. Don't modify it.

Write a TL;DR of the review to ./review-tldr.txt. It goes at the top of the
email, so that a reader can decide whether the review is worth reading.
Think of a headline: it gives up detail for a better chance of being read,
but it must represent the review faithfully.

Format, plain text, at most 40 words in total. Either one sentence:

TL;DR: <one sentence>

or, for distinct issues, a list of short phrases:

TL;DR:
- <short phrase>
- <short phrase>

Put the sentence, and each phrase, on a single line. No markdown, emphasis,
severity labels or emoji.

Content:
- Say what the problem is, where, and what it could break, in the reader's
  terms. The reader should be able to tell which kind it is:
  - a potential blocker: name the effect (a crash, a use-after-free, an
    out-of-bounds access, wrong behaviour, a uapi or ABI change, the
    verifier accepting unsafe programs) rather than calling it a blocker;
  - a behaviour or design question;
  - a test issue;
  - the commit message only;
  - nits only.
- Keep the review's certainty. The review asks questions ("Can this ...?").
  The TL;DR may state the issue, but must keep the hedging ("possible",
  "may", "if ...", "unverified"). Never add a claim the review doesn't make,
  and don't make an issue sound more or less serious than the review does.
- With several issues, lead with the most serious one. If the others are
  nits, say so.
- Use only the text of the review: it is what the reader sees.

Write the file and stop.
